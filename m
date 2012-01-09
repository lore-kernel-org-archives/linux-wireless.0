Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16104 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab2AIHqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 02:46:02 -0500
From: Thirumalai <tpachamu@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Thirumalai <tpachamu@qca.qualcomm.com>
Subject: [PATCH 4/4] ath6kl: Add UAPSD support in tx path.
Date: Mon, 9 Jan 2012 13:15:52 +0530
Message-ID: <1326095152-1663-1-git-send-email-tpachamu@qca.qualcomm.com> (sfid-20120109_084605_771617_8CAA0842)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If tx is not because of uAPSD trigger and if power save is
enabled then queue the packet uAPSD queue.

Signed-off-by: Thirumalai <tpachamu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |  155 ++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath6kl/wmi.h  |    1 +
 2 files changed, 121 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index bf6b102..b37ee00 100644
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
+	bool ps_queued = false, is_apsdq_empty = false;
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
+	} else if (conn->apsd_info) {
+		if (test_bit(WMM_ENABLED, &vif->flags)) {
+			ether_type = datap->h_proto;
+			if (is_ethertype(be16_to_cpu(ether_type))) {
+				/* packet is in DIX format  */
+				ip_hdr = (u8 *)(datap + 1);
+			} else {
+				/* packet is in 802.3 format */
+				llc_hdr = (struct ath6kl_llc_snap_hdr *)
+							(datap + 1);
+				ether_type = llc_hdr->eth_type;
+				ip_hdr = (u8 *)(llc_hdr + 1);
+			}
+
+			if (ether_type == cpu_to_be16(IP_ETHERTYPE))
+				up = ath6kl_wmi_determine_user_priority(
+						ip_hdr, 0);
+		}
+
+		traffic_class =
+			ath6kl_wmi_get_traffic_class(up);
+		if (conn->apsd_info & (1 << traffic_class)) {
+			/* Queue the frames if the STA is sleeping */
+			spin_lock_bh(&conn->psq_lock);
+			is_apsdq_empty = skb_queue_empty(&conn->apsdq);
+			skb_queue_tail(&conn->apsdq, skb);
+			spin_unlock_bh(&conn->psq_lock);
+
+			/*
+			 * If this is the first pkt getting queued
+			 * for this STA, update the PVB for this STA
+			 */
+			if (is_apsdq_empty) {
+				ath6kl_wmi_set_apsd_bfrd_traf(ar->wmi,
+						vif->fw_vif_idx,
+						conn->aid, 1, 0);
+				ath6kl_wmi_set_pvb_cmd(ar->wmi,
+						vif->fw_vif_idx,
+						conn->aid, 1);
+			}
+			*flags |= WMI_DATA_HDR_FLAGS_UAPSD;
+			ps_queued = true;
+		}
+	}
+	return ps_queued;
+}
+
+static bool ath6kl_process_psq(struct ath6kl_sta *conn,
+				struct ath6kl_vif *vif,
+				struct sk_buff *skb,
+				u32 *flags)
+{
+	bool ps_queued = false, is_psq_empty = false;
+	struct ath6kl *ar = vif->ar;
+
+	if (conn->sta_flags & STA_PS_POLLED) {
+		spin_lock_bh(&conn->psq_lock);
+		if (!skb_queue_empty(&conn->psq))
+			*flags |= WMI_DATA_HDR_FLAGS_MORE;
+		spin_unlock_bh(&conn->psq_lock);
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
+		ps_queued = true;
+	}
+	return ps_queued;
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
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index fba2c01..d4bc5a8 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -164,6 +164,7 @@ enum wmi_data_hdr_data_type {
 enum wmi_data_hdr_flags {
 	WMI_DATA_HDR_FLAGS_MORE = 0x1,
 	WMI_DATA_HDR_FLAGS_EOSP = 0x2,
+	WMI_DATA_HDR_FLAGS_UAPSD = 0x4,
 };
 
 #define WMI_DATA_HDR_DATA_TYPE_MASK     0x3
-- 
1.7.4.1

