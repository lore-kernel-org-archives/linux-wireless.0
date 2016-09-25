Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:34504 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966335AbcIYQkD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Sep 2016 12:40:03 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mac80211: multicast to unicast conversion
Date: Sun, 25 Sep 2016 18:39:55 +0200
Message-Id: <1474821596-12155-3-git-send-email-michael-dev@fami-braun.de> (sfid-20160925_184017_226526_22D8F1A1)
In-Reply-To: <1474821596-12155-1-git-send-email-michael-dev@fami-braun.de>
References: <1474821596-12155-1-git-send-email-michael-dev@fami-braun.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for sending multicast data packets with ARP, IPv4 and
IPv6 payload (possible 802.1q tagged) as 802.11 unicast frames to all stations.

IEEE 802.11 multicast has well known issues, among them:
 1. packets are not acked and hence not retransmitted, resulting in decreased
    reliablity
 2. packets are send at low rate, increasing time required on air

When used with AP_VLAN, there is another disadvantage:
 3. all stations in the BSS are woken up, regardsless of their AP_VLAN
    assignment.

By doing multicast to unicast conversion, all three issus are solved.

IEEE802.11-2012 proposes directed multicast service (DMS) using A-MSDU frames
and a station initiated control protocol. It has the advantage that the station
can recover the destination multicast mac address, but it is not backward
compatible with non QOS stations and does not enable the administrator of a BSS
to force this mode of operation within a BSS. Additionally, it would require
both the ap and the station to implement the control protocol, which is
optional on both ends. Furthermore, I've seen a few mobile phone stations
locally that indicate qos support but won't complete DHCP if their broadcasts
are encapsulated as A-MSDU. Though they work fine with this series approach.

This patch therefore does not opt to implement DMS but instead just replicates
the packet and changes the destination address. As this works fine with ARP,
IPv4 and IPv6, it is limited to these protocols and normal 802.11 multicast
frames are send out for all other payload protocols.

There is a runtime toggle to enable multicast conversion in a per-bss fashion.

When there is only a single station assigned to the AP_VLAN interface, no
packet replication will occur. 4addr mode of operation is unchanged.

This change opts for iterating all BSS stations for finding the stations
assigned to this AP/AP_VLAN interface, as there currently is no per AP_VLAN
list to iterate and multicast packets are expected to be few. If needed, such
a list could be added later.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/mac80211/debugfs_netdev.c |  27 +++++++++++
 net/mac80211/ieee80211_i.h    |   1 +
 net/mac80211/tx.c             | 105 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 133 insertions(+)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index d97756d..cfffbc0 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -488,6 +488,32 @@ static ssize_t ieee80211_if_fmt_num_buffered_multicast(
 }
 IEEE80211_IF_FILE_R(num_buffered_multicast);
 
+static ssize_t ieee80211_if_fmt_unicast(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	const struct ieee80211_if_ap *ifap = &sdata->u.ap;
+
+	return snprintf(buf, buflen, "0x%x\n", ifap->unicast);
+}
+
+static ssize_t ieee80211_if_parse_unicast(
+	struct ieee80211_sub_if_data *sdata, const char *buf, int buflen)
+{
+	struct ieee80211_if_ap *ifap = &sdata->u.ap;
+	u8 val;
+	int ret;
+
+	ret = kstrtou8(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	ifap->unicast = val ? 1 : 0;
+
+	return buflen;
+}
+
+IEEE80211_IF_FILE_RW(unicast);
+
 /* IBSS attributes */
 static ssize_t ieee80211_if_fmt_tsf(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
@@ -644,6 +670,7 @@ static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(dtim_count);
 	DEBUGFS_ADD(num_buffered_multicast);
 	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
+	DEBUGFS_ADD_MODE(unicast, 0600);
 }
 
 static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b10e8be..7b3de28 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -294,6 +294,7 @@ struct ieee80211_if_ap {
 			 driver_smps_mode; /* smps mode request */
 
 	struct work_struct request_smps_work;
+	int unicast;
 };
 
 struct ieee80211_if_wds {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7130862..9c82fd8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/skbuff.h>
+#include <linux/if_vlan.h>
 #include <linux/etherdevice.h>
 #include <linux/bitmap.h>
 #include <linux/rcupdate.h>
@@ -1770,6 +1771,106 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_tx_prepare_skb);
 
+/* rewrite destination mac address */
+static int ieee80211_tx_dnat(struct sk_buff *skb, struct sta_info *sta)
+{
+	struct ethhdr *eth;
+	int err;
+
+	err = skb_ensure_writable(skb, ETH_HLEN);
+	if (unlikely(err))
+		return err;
+
+	eth = (void *)skb->data;
+	ether_addr_copy(eth->h_dest, sta->sta.addr);
+
+	return 0;
+}
+
+/* Check if multicast to unicast conversion is needed and do it.
+ *
+ * Returns: 1 if skb was freed and should not be send out
+ */
+static int
+ieee80211_tx_multicast_to_unicast(struct ieee80211_sub_if_data *sdata,
+				  struct sk_buff *skb, u32  info_flags)
+{
+	struct ieee80211_local *local = sdata->local;
+	const struct ethhdr *eth = (void *)skb->data;
+	const struct vlan_ethhdr *ethvlan = (void *)skb->data;
+	struct sta_info *sta, *prev = NULL;
+	struct sk_buff *cloned_skb;
+	u16 ethertype;
+
+	/* multicast to unicast conversion only for AP interfaces */
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP_VLAN:
+		sta = rcu_dereference(sdata->u.vlan.sta);
+		if (sta) /* 4addr */
+			return 0;
+	case NL80211_IFTYPE_AP:
+		break;
+	default:
+		return 0;
+	}
+
+	/* check runtime toggle for this bss */
+	if (!sdata->bss->unicast)
+		return 0;
+
+	/* check if this is a multicast frame */
+	if (!is_multicast_ether_addr(eth->h_dest))
+		return 0;
+
+	/* info_flags would not get preserved, used only by TLDS*/
+	if (info_flags)
+		return 0;
+
+	/* multicast to unicast conversion only for some payload */
+	ethertype = ntohs(eth->h_proto);
+	if (ethertype == ETH_P_8021Q && skb->len >= VLAN_ETH_HLEN)
+		ethertype = ntohs(ethvlan->h_vlan_encapsulated_proto);
+	switch (ethertype) {
+	case ETH_P_ARP:
+	case ETH_P_IP:
+	case ETH_P_IPV6:
+		break;
+	default:
+		return 0;
+	}
+
+	/* clone packets and update destination mac */
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (sdata != sta->sdata)
+			continue;
+		if (unlikely(!memcmp(eth->h_source, sta->sta.addr, ETH_ALEN)))
+			/* do not send back to source */
+			continue;
+		if (unlikely(is_multicast_ether_addr(sta->sta.addr))) {
+			WARN_ONCE(1, "sta with multicast address %pM",
+				  sta->sta.addr);
+			continue;
+		}
+		if (prev) {
+			cloned_skb = skb_clone(skb, GFP_ATOMIC);
+			if (likely(!ieee80211_tx_dnat(cloned_skb, prev)))
+				ieee80211_subif_start_xmit(cloned_skb,
+							   cloned_skb->dev);
+			else
+				dev_kfree_skb(cloned_skb);
+		}
+		prev = sta;
+	}
+
+	if (likely(prev)) {
+		ieee80211_tx_dnat(skb, prev);
+		return 0;
+	}
+
+	/* no STA connected, drop */
+	return 1;
+}
+
 /*
  * Returns false if the frame couldn't be transmitted but was queued instead.
  */
@@ -3353,6 +3454,10 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 	rcu_read_lock();
 
+	/* AP multicast to unicast conversion */
+	if (ieee80211_tx_multicast_to_unicast(sdata, skb, info_flags))
+		goto out_free;
+
 	if (ieee80211_lookup_ra_sta(sdata, skb, &sta))
 		goto out_free;
 
-- 
2.1.4
