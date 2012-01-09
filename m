Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64185 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab2AIHp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 02:45:29 -0500
From: Thirumalai <tpachamu@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Thirumalai <tpachamu@qca.qualcomm.com>
Subject: [PATCH 2/4] ath6kl: Introduce new queue for uAPSD.
Date: Mon, 9 Jan 2012 13:15:20 +0530
Message-ID: <1326095120-1603-1-git-send-email-tpachamu@qca.qualcomm.com> (sfid-20120109_084533_727311_7BC278CD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add apsd_info in necessary places to indicate which
AC's uAPSD is enabled.

A bit is added in the wmi header (bit 4 of info3)
to specify uapsd trigger in rx direction (target to host)
and end of service period in tx direction (host to target)

Signed-off-by: Thirumalai <tpachamu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 +++++
 drivers/net/wireless/ath/ath6kl/core.h     |    6 ++++-
 drivers/net/wireless/ath/ath6kl/main.c     |    8 ++++--
 drivers/net/wireless/ath/ath6kl/wmi.c      |   25 ++++++++++++++------
 drivers/net/wireless/ath/ath6kl/wmi.h      |   34 ++++++++++++++++++++++++++-
 5 files changed, 65 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2a166cc..f7b3429 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2254,6 +2254,11 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	p.dot11_auth_mode = vif->dot11_auth_mode;
 	p.ch = cpu_to_le16(vif->next_chan);
 
+	/* Enable uAPSD support by default */
+	res = ath6kl_wmi_ap_set_apsd(ar->wmi, vif->fw_vif_idx, true);
+	if (res < 0)
+		return res;
+
 	if (vif->wdev.iftype == NL80211_IFTYPE_P2P_GO) {
 		p.nw_subtype = SUBTYPE_P2PGO;
 	} else {
@@ -2742,6 +2747,7 @@ struct ath6kl *ath6kl_core_alloc(struct device *dev)
 	for (ctr = 0; ctr < AP_MAX_NUM_STA; ctr++) {
 		spin_lock_init(&ar->sta_list[ctr].psq_lock);
 		skb_queue_head_init(&ar->sta_list[ctr].psq);
+		skb_queue_head_init(&ar->sta_list[ctr].apsdq);
 	}
 
 	skb_queue_head_init(&ar->mcastpsq);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c095faf..8cc305a 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -146,6 +146,8 @@ struct ath6kl_fw_ie {
 #define STA_PS_AWAKE		BIT(0)
 #define	STA_PS_SLEEP		BIT(1)
 #define	STA_PS_POLLED		BIT(2)
+#define STA_PS_APSD_TRIGGER     BIT(3)
+#define STA_PS_APSD_EOSP        BIT(4)
 
 /* HTC TX packet tagging definitions */
 #define ATH6KL_CONTROL_PKT_TAG    HTC_TX_PACKET_TAG_USER_DEFINED
@@ -282,6 +284,8 @@ struct ath6kl_sta {
 	u8 wpa_ie[ATH6KL_MAX_IE];
 	struct sk_buff_head psq;
 	spinlock_t psq_lock;
+	u8 apsd_info;
+	struct sk_buff_head apsdq;
 };
 
 struct ath6kl_version {
@@ -706,7 +710,7 @@ void ath6kl_connect_event(struct ath6kl_vif *vif, u16 channel,
 void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel);
 void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 				u8 keymgmt, u8 ucipher, u8 auth,
-				u8 assoc_req_len, u8 *assoc_info);
+				u8 assoc_req_len, u8 *assoc_info, u8 apsd_info);
 void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 			     u8 *bssid, u8 assoc_resp_len,
 			     u8 *assoc_info, u16 prot_reason_status);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index f74986d..07dd92f4 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -53,7 +53,7 @@ struct ath6kl_sta *ath6kl_find_sta_by_aid(struct ath6kl *ar, u8 aid)
 }
 
 static void ath6kl_add_new_sta(struct ath6kl *ar, u8 *mac, u16 aid, u8 *wpaie,
-			u8 ielen, u8 keymgmt, u8 ucipher, u8 auth)
+			u8 ielen, u8 keymgmt, u8 ucipher, u8 auth, u8 apsd_info)
 {
 	struct ath6kl_sta *sta;
 	u8 free_slot;
@@ -68,6 +68,7 @@ static void ath6kl_add_new_sta(struct ath6kl *ar, u8 *mac, u16 aid, u8 *wpaie,
 	sta->keymgmt = keymgmt;
 	sta->ucipher = ucipher;
 	sta->auth = auth;
+	sta->apsd_info = apsd_info;
 
 	ar->sta_list_index = ar->sta_list_index | (1 << free_slot);
 	ar->ap_stats.sta[free_slot].aid = cpu_to_le32(aid);
@@ -80,6 +81,7 @@ static void ath6kl_sta_cleanup(struct ath6kl *ar, u8 i)
 	/* empty the queued pkts in the PS queue if any */
 	spin_lock_bh(&sta->psq_lock);
 	skb_queue_purge(&sta->psq);
+	skb_queue_purge(&sta->apsdq);
 	spin_unlock_bh(&sta->psq_lock);
 
 	memset(&ar->ap_stats.sta[sta->aid - 1], 0,
@@ -428,7 +430,7 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel)
 
 void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 				u8 keymgmt, u8 ucipher, u8 auth,
-				u8 assoc_req_len, u8 *assoc_info)
+				u8 assoc_req_len, u8 *assoc_info, u8 apsd_info)
 {
 	struct ath6kl *ar = vif->ar;
 	u8 *ies = NULL, *wpa_ie = NULL, *pos;
@@ -486,7 +488,7 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 
 	ath6kl_add_new_sta(ar, mac_addr, aid, wpa_ie,
 			   wpa_ie ? 2 + wpa_ie[1] : 0,
-			   keymgmt, ucipher, auth);
+			   keymgmt, ucipher, auth, apsd_info);
 
 	/* send event to application */
 	memset(&sinfo, 0, sizeof(sinfo));
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index cda9cc7..570c892 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -180,7 +180,7 @@ static int ath6kl_wmi_meta_add(struct wmi *wmi, struct sk_buff *skb,
 }
 
 int ath6kl_wmi_data_hdr_add(struct wmi *wmi, struct sk_buff *skb,
-			    u8 msg_type, bool more_data,
+			    u8 msg_type, u32 flags,
 			    enum wmi_data_hdr_data_type data_type,
 			    u8 meta_ver, void *tx_meta_info, u8 if_idx)
 {
@@ -204,17 +204,19 @@ int ath6kl_wmi_data_hdr_add(struct wmi *wmi, struct sk_buff *skb,
 	data_hdr->info = msg_type << WMI_DATA_HDR_MSG_TYPE_SHIFT;
 	data_hdr->info |= data_type << WMI_DATA_HDR_DATA_TYPE_SHIFT;
 
-	if (more_data)
-		data_hdr->info |=
-		    WMI_DATA_HDR_MORE_MASK << WMI_DATA_HDR_MORE_SHIFT;
+	if (flags & WMI_DATA_HDR_FLAGS_MORE)
+		wmi_data_hdr_set_more_bit(data_hdr);
 
-	data_hdr->info2 = cpu_to_le16(meta_ver << WMI_DATA_HDR_META_SHIFT);
-	data_hdr->info3 = cpu_to_le16(if_idx & WMI_DATA_HDR_IF_IDX_MASK);
+	if (flags & WMI_DATA_HDR_FLAGS_EOSP)
+		wmi_data_hdr_set_eosp_bit(data_hdr);
+
+	data_hdr->info2 |= cpu_to_le16(meta_ver << WMI_DATA_HDR_META_SHIFT);
+	data_hdr->info3 |= cpu_to_le16(if_idx & WMI_DATA_HDR_IF_IDX_MASK);
 
 	return 0;
 }
 
-static u8 ath6kl_wmi_determine_user_priority(u8 *pkt, u32 layer2_pri)
+u8 ath6kl_wmi_determine_user_priority(u8 *pkt, u32 layer2_pri)
 {
 	struct iphdr *ip_hdr = (struct iphdr *) pkt;
 	u8 ip_pri;
@@ -236,6 +238,11 @@ static u8 ath6kl_wmi_determine_user_priority(u8 *pkt, u32 layer2_pri)
 		return ip_pri;
 }
 
+u8 ath6kl_wmi_get_traffic_class(u8 user_priority)
+{
+	return  up_to_ac[user_priority & 0x7];
+}
+
 int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, u8 if_idx,
 				       struct sk_buff *skb,
 				       u32 layer2_priority, bool wmm_enabled,
@@ -786,12 +793,14 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len,
 				   ev->u.ap_sta.keymgmt,
 				   le16_to_cpu(ev->u.ap_sta.cipher),
 				   ev->u.ap_sta.apsd_info);
+
 			ath6kl_connect_ap_mode_sta(
 				vif, ev->u.ap_sta.aid, ev->u.ap_sta.mac_addr,
 				ev->u.ap_sta.keymgmt,
 				le16_to_cpu(ev->u.ap_sta.cipher),
 				ev->u.ap_sta.auth, ev->assoc_req_len,
-				ev->assoc_info + ev->beacon_ie_len);
+				ev->assoc_info + ev->beacon_ie_len,
+				ev->u.ap_sta.apsd_info);
 		}
 		return 0;
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index c48e289..fba2c01 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -160,6 +160,12 @@ enum wmi_data_hdr_data_type {
 	WMI_DATA_HDR_DATA_TYPE_ACL,
 };
 
+/* Bitmap of data header flags */
+enum wmi_data_hdr_flags {
+	WMI_DATA_HDR_FLAGS_MORE = 0x1,
+	WMI_DATA_HDR_FLAGS_EOSP = 0x2,
+};
+
 #define WMI_DATA_HDR_DATA_TYPE_MASK     0x3
 #define WMI_DATA_HDR_DATA_TYPE_SHIFT    6
 
@@ -172,9 +178,15 @@ enum wmi_data_hdr_data_type {
 
 #define WMI_DATA_HDR_META_MASK      0x7
 #define WMI_DATA_HDR_META_SHIFT     13
 
 #define WMI_DATA_HDR_IF_IDX_MASK    0xF
 
+#define WMI_DATA_HDR_TRIGGER_MASK      0x1
+#define WMI_DATA_HDR_TRIGGER_SHIFT     4
+
+#define WMI_DATA_HDR_EOSP_MASK      WMI_DATA_HDR_TRIGGER_MASK
+#define WMI_DATA_HDR_EOSP_SHIFT     WMI_DATA_HDR_TRIGGER_SHIFT
+
 struct wmi_data_hdr {
 	s8 rssi;
 
@@ -203,11 +217,22 @@ struct wmi_data_hdr {
 	/*
 	 * usage of info3, 16-bit:
 	 * b3:b0	- Interface index
-	 * b15:b4	- Reserved
+	 * b4		- uAPSD trigger in rx & EOSP in tx
+	 * b15:b5	- Reserved
 	 */
 	__le16 info3;
 } __packed;
 
+static inline void wmi_data_hdr_set_more_bit(struct wmi_data_hdr *dhdr)
+{
+	dhdr->info |= (WMI_DATA_HDR_MORE_MASK << WMI_DATA_HDR_MORE_SHIFT);
+}
+
+static inline void wmi_data_hdr_set_eosp_bit(struct wmi_data_hdr *dhdr)
+{
+	dhdr->info3 |= (WMI_DATA_HDR_EOSP_MASK << WMI_DATA_HDR_EOSP_SHIFT);
+}
+
 static inline u8 wmi_data_hdr_get_up(struct wmi_data_hdr *dhdr)
 {
 	return (dhdr->info >> WMI_DATA_HDR_UP_SHIFT) & WMI_DATA_HDR_UP_MASK;
@@ -2336,7 +2361,7 @@ enum htc_endpoint_id ath6kl_wmi_get_control_ep(struct wmi *wmi);
 void ath6kl_wmi_set_control_ep(struct wmi *wmi, enum htc_endpoint_id ep_id);
 int ath6kl_wmi_dix_2_dot3(struct wmi *wmi, struct sk_buff *skb);
 int ath6kl_wmi_data_hdr_add(struct wmi *wmi, struct sk_buff *skb,
-			    u8 msg_type, bool more_data,
+			    u8 msg_type, u32 flags,
 			    enum wmi_data_hdr_data_type data_type,
 			    u8 meta_ver, void *tx_meta_info, u8 if_idx);
 
@@ -2452,6 +2477,11 @@ int ath6kl_wmi_ap_set_apsd(struct wmi *wmi, u8 if_idx, u8 enable);
 int ath6kl_wmi_set_apsd_bfrd_traf(struct wmi *wmi,
 						u8 if_idx, u16 aid,
 						u16 bitmap, u32 flags);
+
+u8 ath6kl_wmi_get_traffic_class(u8 user_priority);
+
+u8 ath6kl_wmi_determine_user_priority(u8 *pkt, u32 layer2_pri);
+
 /* AP mode */
 int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, u8 if_idx,
 				 struct wmi_connect_cmd *p);
-- 
1.7.4.1

