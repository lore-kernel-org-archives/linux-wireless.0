Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60396 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab2ALMwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 07:52:43 -0500
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
From: Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
Subject: [PATCH v2] ath6kl: Add support for uAPSD
Date: Thu, 12 Jan 2012 18:21:39 +0530
Message-ID: <1326372699-6344-2-git-send-email-tpachamu@qca.qualcomm.com> (sfid-20120112_135248_936995_637D9859)
In-Reply-To: <1326372699-6344-1-git-send-email-tpachamu@qca.qualcomm.com>
References: <1326372699-6344-1-git-send-email-tpachamu@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* A new APSD power save queue is added in the station structure.
* When a station has APSD capability and goes to power save, the frame
  designated to the station will be buffered in APSD queue.
* When the host receives a frame which the firmware marked as trigger,
  host delivers the buffered frame from the APSD power save queue.
  Number of frames to deliver is decided by MAX SP length.
* When a station moves from sleep to awake state, all frames buffered
  in APSD power save queue are sent to the firmware.
* When a station is disconnected, all frames bufferes in APSD power save
  queue are dropped.
* When the host queues the first frame to the APSD queue or removes the
  last frame from the APSD queue, it is indicated to the firmware using
  WMI_AP_APSD_BUFFERED_TRAFFIC_CMD.

Signed-off-by: Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 +
 drivers/net/wireless/ath/ath6kl/core.h     |   10 +-
 drivers/net/wireless/ath/ath6kl/main.c     |    9 +-
 drivers/net/wireless/ath/ath6kl/txrx.c     |  253 ++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |   62 ++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |   41 ++++-
 6 files changed, 328 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 14f180e..5a71984 100644
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
index 793c6a5..8239842 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -44,6 +44,10 @@
 #define ATH6KL_MAX_ENDPOINTS   4
 #define MAX_NODE_NUM           15
 
+#define ATH6KL_APSD_ALL_FRAME		0xFFFF
+#define ATH6KL_APSD_NUM_OF_AC		0x4
+#define ATH6KL_APSD_FRAME_MASK		0xF
+
 /* Extra bytes for htc header alignment */
 #define ATH6KL_HTC_ALIGN_BYTES 3
 
@@ -146,6 +150,8 @@ struct ath6kl_fw_ie {
 #define STA_PS_AWAKE		BIT(0)
 #define	STA_PS_SLEEP		BIT(1)
 #define	STA_PS_POLLED		BIT(2)
+#define STA_PS_APSD_TRIGGER     BIT(3)
+#define STA_PS_APSD_EOSP        BIT(4)
 
 /* HTC TX packet tagging definitions */
 #define ATH6KL_CONTROL_PKT_TAG    HTC_TX_PACKET_TAG_USER_DEFINED
@@ -282,6 +288,8 @@ struct ath6kl_sta {
 	u8 wpa_ie[ATH6KL_MAX_IE];
 	struct sk_buff_head psq;
 	spinlock_t psq_lock;
+	u8 apsd_info;
+	struct sk_buff_head apsdq;
 };
 
 struct ath6kl_version {
@@ -715,7 +723,7 @@ void ath6kl_connect_event(struct ath6kl_vif *vif, u16 channel,
 void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel);
 void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 				u8 keymgmt, u8 ucipher, u8 auth,
-				u8 assoc_req_len, u8 *assoc_info);
+				u8 assoc_req_len, u8 *assoc_info, u8 apsd_info);
 void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 			     u8 *bssid, u8 assoc_resp_len,
 			     u8 *assoc_info, u16 prot_reason_status);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 8742eaa..1b36a90 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -53,7 +53,8 @@ struct ath6kl_sta *ath6kl_find_sta_by_aid(struct ath6kl *ar, u8 aid)
 }
 
 static void ath6kl_add_new_sta(struct ath6kl *ar, u8 *mac, u16 aid, u8 *wpaie,
-			size_t ielen, u8 keymgmt, u8 ucipher, u8 auth)
+			       size_t ielen, u8 keymgmt, u8 ucipher, u8 auth,
+			       u8 apsd_info)
 {
 	struct ath6kl_sta *sta;
 	u8 free_slot;
@@ -68,6 +69,7 @@ static void ath6kl_add_new_sta(struct ath6kl *ar, u8 *mac, u16 aid, u8 *wpaie,
 	sta->keymgmt = keymgmt;
 	sta->ucipher = ucipher;
 	sta->auth = auth;
+	sta->apsd_info = apsd_info;
 
 	ar->sta_list_index = ar->sta_list_index | (1 << free_slot);
 	ar->ap_stats.sta[free_slot].aid = cpu_to_le32(aid);
@@ -80,6 +82,7 @@ static void ath6kl_sta_cleanup(struct ath6kl *ar, u8 i)
 	/* empty the queued pkts in the PS queue if any */
 	spin_lock_bh(&sta->psq_lock);
 	skb_queue_purge(&sta->psq);
+	skb_queue_purge(&sta->apsdq);
 	spin_unlock_bh(&sta->psq_lock);
 
 	memset(&ar->ap_stats.sta[sta->aid - 1], 0,
@@ -425,7 +428,7 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel)
 
 void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 				u8 keymgmt, u8 ucipher, u8 auth,
-				u8 assoc_req_len, u8 *assoc_info)
+				u8 assoc_req_len, u8 *assoc_info, u8 apsd_info)
 {
 	struct ath6kl *ar = vif->ar;
 	u8 *ies = NULL, *wpa_ie = NULL, *pos;
@@ -483,7 +486,7 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 
 	ath6kl_add_new_sta(ar, mac_addr, aid, wpa_ie,
 			   wpa_ie ? 2 + wpa_ie[1] : 0,
-			   keymgmt, ucipher, auth);
+			   keymgmt, ucipher, auth, apsd_info);
 
 	/* send event to application */
 	memset(&sinfo, 0, sizeof(sinfo));
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index fcea824..22119fe 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -77,12 +77,120 @@ static u8 ath6kl_ibss_map_epid(struct sk_buff *skb, struct net_device *dev,
 	return ar->node_map[ep_map].ep_id;
 }
 
+static bool ath6kl_process_uapsdq(struct ath6kl_sta *conn,
+				struct ath6kl_vif *vif,
+				struct sk_buff *skb,
+				u32 *flags)
+{
+	struct ath6kl *ar = vif->ar;
+	bool is_apsdq_empty = false;
+	struct ethhdr *datap = (struct ethhdr *) skb->data;
+	u8 up = 0;
+	u8 traffic_class;
+	u16 ether_type;
+	u8 *ip_hdr;
+	struct ath6kl_llc_snap_hdr *llc_hdr;
+
+	if (conn->sta_flags & STA_PS_APSD_TRIGGER) {
+		/*
+		 * This tx is because of a uAPSD trigger, determine
+		 * more and EOSP bit. Set EOSP if queue is empty
+		 * or sufficient frames are delivered for this trigger.
+		 */
+		spin_lock_bh(&conn->psq_lock);
+		if (!skb_queue_empty(&conn->apsdq))
+			*flags |= WMI_DATA_HDR_FLAGS_MORE;
+		else if (conn->sta_flags & STA_PS_APSD_EOSP)
+			*flags |= WMI_DATA_HDR_FLAGS_EOSP;
+		*flags |= WMI_DATA_HDR_FLAGS_UAPSD;
+		spin_unlock_bh(&conn->psq_lock);
+		return false;
+	} else if (!conn->apsd_info)
+		return false;
+
+	if (test_bit(WMM_ENABLED, &vif->flags)) {
+		ether_type = be16_to_cpu(datap->h_proto);
+		if (is_ethertype(ether_type)) {
+			/* packet is in DIX format  */
+			ip_hdr = (u8 *)(datap + 1);
+		} else {
+			/* packet is in 802.3 format */
+			llc_hdr = (struct ath6kl_llc_snap_hdr *)
+							(datap + 1);
+			ether_type = be16_to_cpu(llc_hdr->eth_type);
+			ip_hdr = (u8 *)(llc_hdr + 1);
+		}
+
+		if (ether_type == IP_ETHERTYPE)
+			up = ath6kl_wmi_determine_user_priority(
+							ip_hdr, 0);
+	}
+
+	traffic_class = ath6kl_wmi_get_traffic_class(up);
+
+	if ((conn->apsd_info & (1 << traffic_class)) == 0)
+		return false;
+
+	/* Queue the frames if the STA is sleeping */
+	spin_lock_bh(&conn->psq_lock);
+	is_apsdq_empty = skb_queue_empty(&conn->apsdq);
+	skb_queue_tail(&conn->apsdq, skb);
+	spin_unlock_bh(&conn->psq_lock);
+
+	/*
+	 * If this is the first pkt getting queued
+	 * for this STA, update the PVB for this STA
+	 */
+	if (is_apsdq_empty) {
+		ath6kl_wmi_set_apsd_bfrd_traf(ar->wmi,
+				vif->fw_vif_idx,
+				conn->aid, 1, 0);
+	}
+	*flags |= WMI_DATA_HDR_FLAGS_UAPSD;
+
+	return true;
+}
+
+static bool ath6kl_process_psq(struct ath6kl_sta *conn,
+				struct ath6kl_vif *vif,
+				struct sk_buff *skb,
+				u32 *flags)
+{
+	bool is_psq_empty = false;
+	struct ath6kl *ar = vif->ar;
+
+	if (conn->sta_flags & STA_PS_POLLED) {
+		spin_lock_bh(&conn->psq_lock);
+		if (!skb_queue_empty(&conn->psq))
+			*flags |= WMI_DATA_HDR_FLAGS_MORE;
+		spin_unlock_bh(&conn->psq_lock);
+		return false;
+	} else {
+		/* Queue the frames if the STA is sleeping */
+		spin_lock_bh(&conn->psq_lock);
+		is_psq_empty = skb_queue_empty(&conn->psq);
+		skb_queue_tail(&conn->psq, skb);
+		spin_unlock_bh(&conn->psq_lock);
+
+		/*
+		 * If this is the first pkt getting queued
+		 * for this STA, update the PVB for this
+		 * STA.
+		 */
+		if (is_psq_empty)
+			ath6kl_wmi_set_pvb_cmd(ar->wmi,
+					vif->fw_vif_idx,
+					conn->aid, 1);
+		return true;
+	}
+}
+
 static bool ath6kl_powersave_ap(struct ath6kl_vif *vif, struct sk_buff *skb,
-				bool *more_data)
+				u32 *flags)
 {
 	struct ethhdr *datap = (struct ethhdr *) skb->data;
 	struct ath6kl_sta *conn = NULL;
-	bool ps_queued = false, is_psq_empty = false;
+	bool ps_queued = false;
 	struct ath6kl *ar = vif->ar;
 
 	if (is_multicast_ether_addr(datap->h_dest)) {
@@ -128,7 +236,7 @@ static bool ath6kl_powersave_ap(struct ath6kl_vif *vif, struct sk_buff *skb,
 				 */
 				spin_lock_bh(&ar->mcastpsq_lock);
 				if (!skb_queue_empty(&ar->mcastpsq))
-					*more_data = true;
+					*flags |= WMI_DATA_HDR_FLAGS_MORE;
 				spin_unlock_bh(&ar->mcastpsq_lock);
 			}
 		}
@@ -142,37 +250,13 @@ static bool ath6kl_powersave_ap(struct ath6kl_vif *vif, struct sk_buff *skb,
 		}
 
 		if (conn->sta_flags & STA_PS_SLEEP) {
-			if (!(conn->sta_flags & STA_PS_POLLED)) {
-				/* Queue the frames if the STA is sleeping */
-				spin_lock_bh(&conn->psq_lock);
-				is_psq_empty = skb_queue_empty(&conn->psq);
-				skb_queue_tail(&conn->psq, skb);
-				spin_unlock_bh(&conn->psq_lock);
-
-				/*
-				 * If this is the first pkt getting queued
-				 * for this STA, update the PVB for this
-				 * STA.
-				 */
-				if (is_psq_empty)
-					ath6kl_wmi_set_pvb_cmd(ar->wmi,
-							       vif->fw_vif_idx,
-							       conn->aid, 1);
-
-				ps_queued = true;
-			} else {
-				/*
-				 * This tx is because of a PsPoll.
-				 * Determine if MoreData bit has to be set.
-				 */
-				spin_lock_bh(&conn->psq_lock);
-				if (!skb_queue_empty(&conn->psq))
-					*more_data = true;
-				spin_unlock_bh(&conn->psq_lock);
-			}
+			ps_queued = ath6kl_process_uapsdq(conn,
+						vif, skb, flags);
+			if (!(*flags & WMI_DATA_HDR_FLAGS_UAPSD))
+				ps_queued = ath6kl_process_psq(conn,
+						vif, skb, flags);
 		}
 	}
-
 	return ps_queued;
 }
 
@@ -242,12 +326,13 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	u32 map_no = 0;
 	u16 htc_tag = ATH6KL_DATA_PKT_TAG;
 	u8 ac = 99 ; /* initialize to unmapped ac */
-	bool chk_adhoc_ps_mapping = false, more_data = false;
+	bool chk_adhoc_ps_mapping = false;
 	int ret;
 	struct wmi_tx_meta_v2 meta_v2;
 	void *meta;
 	u8 csum_start = 0, csum_dest = 0, csum = skb->ip_summed;
 	u8 meta_ver = 0;
+	u32 flags = 0;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
 		   "%s: skb=0x%p, data=0x%p, len=0x%x\n", __func__,
@@ -264,7 +349,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 
 	/* AP mode Power saving processing */
 	if (vif->nw_type == AP_NETWORK) {
-		if (ath6kl_powersave_ap(vif, skb, &more_data))
+		if (ath6kl_powersave_ap(vif, skb, &flags))
 			return 0;
 	}
 
@@ -308,7 +393,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 		}
 
 		ret = ath6kl_wmi_data_hdr_add(ar->wmi, skb,
-				DATA_MSGTYPE, more_data, 0,
+				DATA_MSGTYPE, flags, 0,
 				meta_ver,
 				meta, vif->fw_vif_idx);
 
@@ -1093,6 +1178,78 @@ static bool aggr_process_recv_frm(struct aggr_info *agg_info, u8 tid,
 	return is_queued;
 }
 
+static void ath6kl_uapsd_trigger_frame_rx(struct ath6kl_vif *vif,
+						 struct ath6kl_sta *conn)
+{
+	struct ath6kl *ar = vif->ar;
+	bool is_apsdq_empty;
+	bool is_apsdq_empty_at_start;
+	u32 num_frames_to_deliver;
+	struct sk_buff *skb = NULL;
+	u32 flags;
+
+	/*
+	 * If the APSD q for this STA is not empty, dequeue and
+	 * send a pkt from the head of the q. Also update the
+	 * More data bit in the WMI_DATA_HDR if there are
+	 * more pkts for this STA in the APSD q.
+	 * If there are no more pkts for this STA,
+	 * update the APSD bitmap for this STA.
+	 */
+
+	num_frames_to_deliver = (conn->apsd_info >> ATH6KL_APSD_NUM_OF_AC) &
+						    ATH6KL_APSD_FRAME_MASK;
+	/*
+	 * Number of frames to send in a service period is
+	 * indicated by the station
+	 * in the QOS_INFO of the association request
+	 * If it is zero, send all frames
+	 */
+	if (!num_frames_to_deliver)
+		num_frames_to_deliver = ATH6KL_APSD_ALL_FRAME;
+
+	spin_lock_bh(&conn->psq_lock);
+	is_apsdq_empty = skb_queue_empty(&conn->apsdq);
+	spin_unlock_bh(&conn->psq_lock);
+	is_apsdq_empty_at_start = is_apsdq_empty;
+
+	while ((!is_apsdq_empty) && (num_frames_to_deliver)) {
+
+		spin_lock_bh(&conn->psq_lock);
+		skb = skb_dequeue(&conn->apsdq);
+		is_apsdq_empty = skb_queue_empty(&conn->apsdq);
+		spin_unlock_bh(&conn->psq_lock);
+
+		/*
+		 * Set the STA flag to Trigger delivery,
+		 * so that the frame will go out
+		 */
+		conn->sta_flags |= STA_PS_APSD_TRIGGER;
+		num_frames_to_deliver--;
+
+		/* Last frame in the service period, set EOSP or queue empty */
+		if ((is_apsdq_empty) || (!num_frames_to_deliver))
+			conn->sta_flags |= STA_PS_APSD_EOSP;
+
+		ath6kl_data_tx(skb, vif->ndev);
+		conn->sta_flags &= ~(STA_PS_APSD_TRIGGER);
+		conn->sta_flags &= ~(STA_PS_APSD_EOSP);
+	}
+
+	if (is_apsdq_empty) {
+		if (is_apsdq_empty_at_start)
+			flags = WMI_AP_APSD_NO_DELIVERY_FRAMES;
+		else
+			flags = 0;
+
+		ath6kl_wmi_set_apsd_bfrd_traf(ar->wmi,
+				vif->fw_vif_idx,
+				conn->aid, 0, flags);
+	}
+
+	return;
+}
+
 void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 {
 	struct ath6kl *ar = target->dev->ar;
@@ -1104,6 +1261,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	int status = packet->status;
 	enum htc_endpoint_id ept = packet->endpoint;
 	bool is_amsdu, prev_ps, ps_state = false;
+	bool trig_state = false;
 	struct ath6kl_sta *conn = NULL;
 	struct sk_buff *skb1 = NULL;
 	struct ethhdr *datap = NULL;
@@ -1197,6 +1355,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 			      WMI_DATA_HDR_PS_MASK);
 
 		offset = sizeof(struct wmi_data_hdr);
+		trig_state = !!(le16_to_cpu(dhdr->info3) & WMI_DATA_HDR_TRIG);
 
 		switch (meta_type) {
 		case 0:
@@ -1235,18 +1394,38 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		else
 			conn->sta_flags &= ~STA_PS_SLEEP;
 
+		/* Accept trigger only when the station is in sleep */
+		if ((conn->sta_flags & STA_PS_SLEEP) && trig_state)
+			ath6kl_uapsd_trigger_frame_rx(vif, conn);
+
 		if (prev_ps ^ !!(conn->sta_flags & STA_PS_SLEEP)) {
 			if (!(conn->sta_flags & STA_PS_SLEEP)) {
 				struct sk_buff *skbuff = NULL;
+				bool is_apsdq_empty;
 
 				spin_lock_bh(&conn->psq_lock);
-				while ((skbuff = skb_dequeue(&conn->psq))
-				       != NULL) {
+				while ((skbuff = skb_dequeue(&conn->psq))) {
+					spin_unlock_bh(&conn->psq_lock);
+					ath6kl_data_tx(skbuff, vif->ndev);
+					spin_lock_bh(&conn->psq_lock);
+					skbuff = skb_dequeue(&conn->psq);
+				}
+
+				is_apsdq_empty = skb_queue_empty(&conn->apsdq);
+				while ((skbuff = skb_dequeue(&conn->apsdq))) {
 					spin_unlock_bh(&conn->psq_lock);
 					ath6kl_data_tx(skbuff, vif->ndev);
 					spin_lock_bh(&conn->psq_lock);
+					skbuff = skb_dequeue(&conn->apsdq);
 				}
 				spin_unlock_bh(&conn->psq_lock);
+
+				if (!is_apsdq_empty)
+					ath6kl_wmi_set_apsd_bfrd_traf(
+							ar->wmi,
+							vif->fw_vif_idx,
+							conn->aid, 0, 0);
+
 				/* Clear the PVB for this STA */
 				ath6kl_wmi_set_pvb_cmd(ar->wmi, vif->fw_vif_idx,
 						       conn->aid, 0);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 08fbd9a..c2420f8 100644
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
+		data_hdr->info |= WMI_DATA_HDR_MORE;
 
-	data_hdr->info2 = cpu_to_le16(meta_ver << WMI_DATA_HDR_META_SHIFT);
-	data_hdr->info3 = cpu_to_le16(if_idx & WMI_DATA_HDR_IF_IDX_MASK);
+	if (flags & WMI_DATA_HDR_FLAGS_EOSP)
+		data_hdr->info3 |= cpu_to_le16(WMI_DATA_HDR_EOSP);
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
@@ -2993,6 +3002,43 @@ int ath6kl_wmi_ap_set_mlme(struct wmi *wmip, u8 if_idx, u8 cmd, const u8 *mac,
 				   NO_SYNC_WMIFLAG);
 }
 
+/* This command will be used to enable/disable AP uAPSD feature */
+int ath6kl_wmi_ap_set_apsd(struct wmi *wmi, u8 if_idx, u8 enable)
+{
+	struct wmi_ap_set_apsd_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_ap_set_apsd_cmd *)skb->data;
+	cmd->enable = enable;
+
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_AP_SET_APSD_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
+int ath6kl_wmi_set_apsd_bfrd_traf(struct wmi *wmi, u8 if_idx,
+					     u16 aid, u16 bitmap, u32 flags)
+{
+	struct wmi_ap_apsd_buffered_traffic_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_ap_apsd_buffered_traffic_cmd *)skb->data;
+	cmd->aid = cpu_to_le16(aid);
+	cmd->bitmap = cpu_to_le16(bitmap);
+	cmd->flags = cpu_to_le32(flags);
+
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb,
+				   WMI_AP_APSD_BUFFERED_TRAFFIC_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 static int ath6kl_wmi_pspoll_event_rx(struct wmi *wmi, u8 *datap, int len,
 				      struct ath6kl_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index eae0e4e..48e9d26 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -149,8 +149,7 @@ enum wmi_msg_type {
 #define WMI_DATA_HDR_PS_MASK        0x1
 #define WMI_DATA_HDR_PS_SHIFT       5
 
-#define WMI_DATA_HDR_MORE_MASK      0x1
-#define WMI_DATA_HDR_MORE_SHIFT     5
+#define WMI_DATA_HDR_MORE	0x20
 
 enum wmi_data_hdr_data_type {
 	WMI_DATA_HDR_DATA_TYPE_802_3 = 0,
@@ -160,6 +159,13 @@ enum wmi_data_hdr_data_type {
 	WMI_DATA_HDR_DATA_TYPE_ACL,
 };
 
+/* Bitmap of data header flags */
+enum wmi_data_hdr_flags {
+	WMI_DATA_HDR_FLAGS_MORE = 0x1,
+	WMI_DATA_HDR_FLAGS_EOSP = 0x2,
+	WMI_DATA_HDR_FLAGS_UAPSD = 0x4,
+};
+
 #define WMI_DATA_HDR_DATA_TYPE_MASK     0x3
 #define WMI_DATA_HDR_DATA_TYPE_SHIFT    6
 
@@ -173,8 +179,12 @@ enum wmi_data_hdr_data_type {
 #define WMI_DATA_HDR_META_MASK      0x7
 #define WMI_DATA_HDR_META_SHIFT     13
 
+/* Macros for operating on WMI_DATA_HDR (info3) field */
 #define WMI_DATA_HDR_IF_IDX_MASK    0xF
 
+#define WMI_DATA_HDR_TRIG	    0x10
+#define WMI_DATA_HDR_EOSP	    0x10
+
 struct wmi_data_hdr {
 	s8 rssi;
 
@@ -203,7 +213,8 @@ struct wmi_data_hdr {
 	/*
 	 * usage of info3, 16-bit:
 	 * b3:b0	- Interface index
-	 * b15:b4	- Reserved
+	 * b4		- uAPSD trigger in rx & EOSP in tx
+	 * b15:b5	- Reserved
 	 */
 	__le16 info3;
 } __packed;
@@ -2116,6 +2127,19 @@ struct wmi_rx_frame_format_cmd {
 } __packed;
 
 /* AP mode events */
+struct wmi_ap_set_apsd_cmd {
+	u8 enable;
+} __packed;
+
+enum wmi_ap_apsd_buffered_traffic_flags {
+	WMI_AP_APSD_NO_DELIVERY_FRAMES =  0x1,
+};
+
+struct wmi_ap_apsd_buffered_traffic_cmd {
+	__le16 aid;
+	__le16 bitmap;
+	__le32 flags;
+} __packed;
 
 /* WMI_PS_POLL_EVENT */
 struct wmi_pspoll_event {
@@ -2332,7 +2356,7 @@ enum htc_endpoint_id ath6kl_wmi_get_control_ep(struct wmi *wmi);
 void ath6kl_wmi_set_control_ep(struct wmi *wmi, enum htc_endpoint_id ep_id);
 int ath6kl_wmi_dix_2_dot3(struct wmi *wmi, struct sk_buff *skb);
 int ath6kl_wmi_data_hdr_add(struct wmi *wmi, struct sk_buff *skb,
-			    u8 msg_type, bool more_data,
+			    u8 msg_type, u32 flags,
 			    enum wmi_data_hdr_data_type data_type,
 			    u8 meta_ver, void *tx_meta_info, u8 if_idx);
 
@@ -2446,7 +2470,16 @@ int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode);
 int ath6kl_wmi_mcast_filter_cmd(struct wmi *wmi, u8 if_idx, bool mc_all_on);
 int ath6kl_wmi_add_del_mcast_filter_cmd(struct wmi *wmi, u8 if_idx,
 					u8 *filter, bool add_filter);
+/* AP mode uAPSD */
+int ath6kl_wmi_ap_set_apsd(struct wmi *wmi, u8 if_idx, u8 enable);
+
+int ath6kl_wmi_set_apsd_bfrd_traf(struct wmi *wmi,
+						u8 if_idx, u16 aid,
+						u16 bitmap, u32 flags);
+
+u8 ath6kl_wmi_get_traffic_class(u8 user_priority);
 
+u8 ath6kl_wmi_determine_user_priority(u8 *pkt, u32 layer2_pri);
 /* AP mode */
 int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, u8 if_idx,
 				 struct wmi_connect_cmd *p);
-- 
1.7.0.4

