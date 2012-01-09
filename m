Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17011 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab2AIHpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 02:45:46 -0500
From: Thirumalai <tpachamu@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Thirumalai <tpachamu@qca.qualcomm.com>
Subject: [PATCH 3/4] ath6kl: Add uAPSD support in rx path.
Date: Mon, 9 Jan 2012 13:15:35 +0530
Message-ID: <1326095135-1633-1-git-send-email-tpachamu@qca.qualcomm.com> (sfid-20120109_084548_653329_F0A87EB5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If uAPSD trigger is received, send out the packets in uAPSD
queue. Set more data bit if the queue is not empty else
update the uAPSD bitmap for the station.

Signed-off-by: Thirumalai <tpachamu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |  103 +++++++++++++++++++++++++++++++-
 1 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index fcea824..bf6b102 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1093,6 +1093,80 @@ static bool aggr_process_recv_frm(struct aggr_info *agg_info, u8 tid,
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
+	num_frames_to_deliver = (conn->apsd_info >> 4) & 0xF;
+
+	/*
+	 * Number of frames to send in a service period is
+	 * indicated by the station
+	 * in the QOS_INFO of the association request
+	 * If it is zero, send all frames
+	 */
+	if (!num_frames_to_deliver)
+		num_frames_to_deliver = 0xFFFF;
+
+	spin_lock_bh(&conn->psq_lock);
+	is_apsdq_empty  = skb_queue_empty(&conn->apsdq);
+	spin_unlock_bh(&conn->psq_lock);
+	is_apsdq_empty_at_start = is_apsdq_empty;
+
+	while ((!is_apsdq_empty) && (num_frames_to_deliver)) {
+
+		spin_lock_bh(&conn->psq_lock);
+		skb = skb_dequeue(&conn->apsdq);
+		is_apsdq_empty  = skb_queue_empty(&conn->apsdq);
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
+		ath6kl_wmi_set_pvb_cmd(ar->wmi, vif->fw_vif_idx, conn->aid, 0);
+		if (is_apsdq_empty_at_start) {
+			ath6kl_wmi_set_apsd_bfrd_traf(ar->wmi,
+					vif->fw_vif_idx,
+					conn->aid, 0,
+					WMI_AP_APSD_NO_DELIVERY_FRAMES);
+		} else {
+			ath6kl_wmi_set_apsd_bfrd_traf(ar->wmi,
+					vif->fw_vif_idx,
+					conn->aid, 0, 0);
+		}
+	}
+
+	return;
+}
+
 void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 {
 	struct ath6kl *ar = target->dev->ar;
@@ -1104,6 +1178,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	int status = packet->status;
 	enum htc_endpoint_id ept = packet->endpoint;
 	bool is_amsdu, prev_ps, ps_state = false;
+	bool trigger_state = false;
 	struct ath6kl_sta *conn = NULL;
 	struct sk_buff *skb1 = NULL;
 	struct ethhdr *datap = NULL;
@@ -1197,6 +1272,8 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 			      WMI_DATA_HDR_PS_MASK);
 
 		offset = sizeof(struct wmi_data_hdr);
+		trigger_state = !!((dhdr->info3 >> WMI_DATA_HDR_TRIGGER_SHIFT) &
+				  WMI_DATA_HDR_TRIGGER_MASK);
 
 		switch (meta_type) {
 		case 0:
@@ -1235,18 +1312,40 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		else
 			conn->sta_flags &= ~STA_PS_SLEEP;
 
+		/* Accept trigger only when the station is in sleep */
+		if ((conn->sta_flags & STA_PS_SLEEP) && trigger_state)
+			ath6kl_uapsd_trigger_frame_rx(vif, conn);
+
 		if (prev_ps ^ !!(conn->sta_flags & STA_PS_SLEEP)) {
 			if (!(conn->sta_flags & STA_PS_SLEEP)) {
 				struct sk_buff *skbuff = NULL;
+				bool is_apsdq_empty;
 
 				spin_lock_bh(&conn->psq_lock);
-				while ((skbuff = skb_dequeue(&conn->psq))
-				       != NULL) {
+				skbuff = skb_dequeue(&conn->psq);
+				while (skbuff != NULL) {
+					spin_unlock_bh(&conn->psq_lock);
+					ath6kl_data_tx(skbuff, vif->ndev);
+					spin_lock_bh(&conn->psq_lock);
+					skbuff = skb_dequeue(&conn->psq);
+				}
+
+				is_apsdq_empty = skb_queue_empty(&conn->apsdq);
+				skbuff = skb_dequeue(&conn->apsdq);
+				while (skbuff != NULL) {
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
-- 
1.7.4.1

