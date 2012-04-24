Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56419 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab2DXNRl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 09:17:41 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [RFCv2 6/6] mac80211: softamp: Handle data traffic
Date: Tue, 24 Apr 2012 16:17:40 +0300
Message-Id: <1335273460-12682-7-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120424_151758_110337_C01CE795)
In-Reply-To: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Adds handling for data traffic. The patch is partly based on patch:
"mac80211: BT3 AMP support".

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 include/linux/ieee80211.h  |   13 +++++
 net/mac80211/rx.c          |    4 ++
 net/mac80211/sta_info.h    |    4 ++
 net/mac80211/virtual_amp.c |  131 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/virtual_amp.h |   19 +++++++
 5 files changed, 170 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 210e2c3..f19728e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -184,6 +184,19 @@ struct ieee80211_qos_hdr {
 	__le16 qos_ctrl;
 } __attribute__ ((packed));
 
+#define P80211_OUI_LEN 3
+
+struct ieee80211_llc_snap_hdr {
+	/* LLC */
+	u8 dsap;   /* always 0xAA */
+	u8 ssap;   /* always 0xAA */
+	u8 ctrl;   /* always 0x03 */
+
+	/* SNAP */
+	u8 oui[P80211_OUI_LEN];    /* organizational universal id */
+	__be16 proto;
+} __attribute__ ((packed));
+
 /**
  * ieee80211_has_tods - check if IEEE80211_FCTL_TODS is set
  * @fc: frame control bytes in little-endian byteorder
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bcfe8c7..760d20c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -30,6 +30,7 @@
 #include "tkip.h"
 #include "wme.h"
 #include "rate.h"
+#include "virtual_amp.h"
 
 /*
  * monitor mode reception
@@ -1767,6 +1768,9 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 				skb = NULL;
 			}
 		}
+	} else if (ieee80211_vif_is_softamp(&sdata->vif)) {
+		ieee80211_softamp_receive_skb(sdata, rx->skb, rx->sta);
+		return;
 	}
 
 	if (skb) {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ab05768..47ed9f0 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -362,6 +362,10 @@ struct sta_info {
 	} debugfs;
 #endif
 
+#ifdef CONFIG_MAC80211_BLUETOOTH_SOFTAMP
+	u16 hci_handle;
+#endif
+
 	unsigned int lost_packets;
 	unsigned int beacon_loss_count;
 
diff --git a/net/mac80211/virtual_amp.c b/net/mac80211/virtual_amp.c
index 62ebb50..6d2ffef 100644
--- a/net/mac80211/virtual_amp.c
+++ b/net/mac80211/virtual_amp.c
@@ -432,14 +432,137 @@ drop:
 	kfree_skb(skb);
 }
 
+void ieee80211_softamp_receive_skb(struct ieee80211_sub_if_data *sdata,
+				   struct sk_buff *skb, struct sta_info *sta)
+{
+	struct ethhdr *hdr = (void *) skb->data;
+	struct ieee80211_llc_snap_hdr *snap_hdr;
+	struct hci_acl_hdr *acl_hdr;
+	int min_hdr = sizeof(*hdr) + sizeof(*snap_hdr);
+	u16 proto;
+
+	if (!sta)
+		goto drop;
+
+	if (skb->len < min_hdr)
+		goto drop;
+
+	if (compare_ether_addr(sta->sta.addr, hdr->h_source) ||
+	    compare_ether_addr(sdata->vif.addr, hdr->h_dest))
+		goto drop;
+
+	skb_pull(skb, sizeof(*hdr));
+
+	snap_hdr = (void *) skb->data;
+	if (snap_hdr->dsap != 0xAA || snap_hdr->ssap != 0xAA ||
+	     snap_hdr->ctrl != 0x03 || snap_hdr->oui[0] != 0x00 ||
+	     snap_hdr->oui[1] != 0x19 || snap_hdr->oui[2] != 0x58)
+		goto drop;
+
+	skb_pull(skb, sizeof(*snap_hdr));
+
+	proto = ntohs(snap_hdr->proto);
+	switch (proto) {
+	case SOFTAMP_ACL_DATA:
+		acl_hdr = (void *) skb_push(skb, sizeof(*acl_hdr));
+		acl_hdr->handle = 0;
+		acl_hdr->dlen = cpu_to_le16(skb->len - sizeof(*acl_hdr));
+		memset(skb->cb, 0, sizeof(skb->cb));
+		bt_cb(skb)->pkt_type = HCI_ACLDATA_PKT;
+		skb->dev = (void *)sdata->u.softamp.hdev;
+		hci_recv_frame(skb);
+		break;
+	}
+
+drop:
+	kfree_skb(skb);
+}
+
+static struct sta_info *find_sta_for_hndl(struct ieee80211_sub_if_data *sdata,
+					  u16 handle)
+{
+	struct sta_info *sta;
+
+	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {
+		if (sta->sdata != sdata)
+			continue;
+		if (sta->hci_handle == handle)
+			return sta;
+	}
+
+	return NULL;
+}
+
+static void softamp_xmit_sta(struct ieee80211_sub_if_data *sdata,
+			     struct sk_buff *skb, struct sta_info *sta,
+			     u16 proto)
+{
+	struct ieee80211_tx_info *info;
+	struct ieee80211_hdr *hdr;
+	struct ieee80211_llc_snap_hdr *snap_hdr;
+	struct sk_buff *nskb;
+	u16 fc;
+	__le16 *qos;
+
+	fc = IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS |
+	     IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA;
+
+	nskb = skb_copy_expand(skb, sizeof(*hdr) + sizeof(*snap_hdr) +
+			       sizeof(*qos), 0, GFP_ATOMIC);
+	kfree_skb(skb);
+
+	if (!nskb)
+		return;
+
+	skb = nskb;
+
+	snap_hdr = (void *) skb_push(skb, sizeof(*snap_hdr));
+
+	/* 802.11 AMP LLC/SNAP encapsulation. All fields except proto
+	   are hardcoded in Bluetooth Core Specification v4.0 */
+	snap_hdr->dsap = 0xAA;
+	snap_hdr->ssap = 0xAA;
+	snap_hdr->ctrl = 0x03;
+	snap_hdr->oui[0] = 0x00;
+	snap_hdr->oui[1] = 0x19;
+	snap_hdr->oui[2] = 0x58;
+
+	/* Apparently this is __be */
+	snap_hdr->proto = htons(proto);
+
+	/* QoS */
+	if (test_sta_flag(sta, WLAN_STA_WME) && sdata->local->hw.queues >= 4) {
+		fc |= IEEE80211_STYPE_QOS_DATA;
+		qos = (void *)skb_push(skb, sizeof(*qos));
+		*qos = 0;
+	}
+
+	hdr = (void *) skb_put(skb, sizeof(*hdr));
+	memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
+	memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+	memcpy(hdr->addr3, sta->sta.addr, ETH_ALEN);
+	memcpy(hdr->addr4, sdata->vif.addr, ETH_ALEN);
+	hdr->frame_control = cpu_to_le16(fc);
+
+	info = IEEE80211_SKB_CB(skb);
+	memset(info, 0, sizeof(*info));
+
+	ieee80211_tx_skb(sdata, skb);
+}
+
 static void vamp_acldata_packet(struct vamp_data *data, struct sk_buff *skb)
 {
 	struct hci_acl_hdr *hdr = (void *) skb->data;
+	struct ieee80211_sub_if_data *sdata = data->sdata;
+	struct sta_info *sta;
 	__u16 handle, flags;
 
 	if (skb->len < sizeof(*hdr))
 		goto drop;
 
+	if (skb->len != sizeof(*hdr) + le16_to_cpu(hdr->dlen))
+		goto drop;
+
 	skb_pull(skb, HCI_ACL_HDR_SIZE);
 
 	handle = __le16_to_cpu(hdr->handle);
@@ -449,7 +572,13 @@ static void vamp_acldata_packet(struct vamp_data *data, struct sk_buff *skb)
 	BT_DBG("%s len %d handle 0x%x flags 0x%x", data->hdev->name, skb->len,
 	       handle, flags);
 
-	/* Send data through WIFI */
+	rcu_read_lock();
+
+	sta = find_sta_for_hndl(sdata, handle);
+	if (sta)
+		softamp_xmit_sta(sdata, skb, sta, 1);
+
+	rcu_read_unlock();
 
 drop:
 	kfree_skb(skb);
diff --git a/net/mac80211/virtual_amp.h b/net/mac80211/virtual_amp.h
index a353ac3..d55da78 100644
--- a/net/mac80211/virtual_amp.h
+++ b/net/mac80211/virtual_amp.h
@@ -24,6 +24,13 @@
 #define SOFTAMP_PAL_CAP_TYPE		4
 #define SOFTAMP_PAL_VER_INFO		5
 
+/* Protocol identifiers for LLC/SNAP hdr */
+#define SOFTAMP_ACL_DATA		1
+#define SOFTAMP_ACTIVITY_REPORT		2
+#define SOFTAMP_SECURITY_FRAME		3
+#define SOFTAMP_LINK_SUPERVISION_REQ	4
+#define SOFTAMP_LINK_SUPERVISION_REPLY	5
+
 /* Data types related to ASSOC data */
 struct tlv {
 	__u8 type;
@@ -40,6 +47,8 @@ struct softamp_pref_chans {
 
 void ieee80211_vamp_setup_sdata(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vamp_clean_sdata(struct ieee80211_sub_if_data *sdata);
+void ieee80211_softamp_receive_skb(struct ieee80211_sub_if_data *sdata,
+				   struct sk_buff *skb, struct sta_info *sta);
 
 struct vamp_data {
 	struct hci_dev *hdev;
@@ -74,4 +83,14 @@ ieee80211_vamp_setup_sdata(struct ieee80211_sub_if_data *sdata) {}
 static inline void
 ieee80211_vamp_clean_sdata(struct ieee80211_sub_if_data *sdata) {}
 
+static inline void
+ieee80211_softamp_receive_skb(struct ieee80211_sub_if_data *sdata,
+			      struct sk_buff *skb, struct sta_info *sta)
+{}
+
 #endif /* CONFIG_MAC80211_BLUETOOTH_SOFTAMP */
+
+static inline bool ieee80211_vif_is_softamp(struct ieee80211_vif *vif)
+{
+	return vif->type == NL80211_IFTYPE_BLUETOOTH_SOFTAMP;
+}
-- 
1.7.9.5

