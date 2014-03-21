Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43413 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaCUS4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 14:56:52 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/3] ath10k:  Add debugging for tx-credits usage.
Date: Fri, 21 Mar 2014 11:55:48 -0700
Message-Id: <1395428150-31996-1-git-send-email-greearb@candelatech.com> (sfid-20140321_195655_892743_A9AFE1EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This helps track tx credits accounting and usage.  If
firmware hangs or otherwise fails to return credits, one
can more easily see the last few command types that
was send to the firmware.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/htc.c    | 16 ++++++++++------
 drivers/net/wireless/ath/ath10k/htc.h    |  2 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  8 ++++----
 drivers/net/wireless/ath/ath10k/wmi.c    |  2 +-
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index ba3084c..bca5c41 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -121,7 +121,7 @@ static void ath10k_htc_prepare_tx_skb(struct ath10k_htc_ep *ep,
 
 int ath10k_htc_send(struct ath10k_htc *htc,
 		    enum ath10k_htc_ep_id eid,
-		    struct sk_buff *skb)
+		    struct sk_buff *skb, int dbg)
 {
 	struct ath10k_htc_ep *ep = &htc->endpoint[eid];
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
@@ -167,6 +167,10 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 			goto err_pull;
 		}
 		ep->tx_credits -= credits;
+		ath10k_dbg(ATH10K_DBG_HTC,
+			   "ep %d used %d credits, remaining %d dbg %d (0x%x)\n",
+			   eid, credits, ep->tx_credits, dbg, dbg);
+
 		spin_unlock_bh(&htc->tx_lock);
 	}
 
@@ -244,13 +248,13 @@ ath10k_htc_process_credit_report(struct ath10k_htc *htc,
 		if (report->eid >= ATH10K_HTC_EP_COUNT)
 			break;
 
-		ath10k_dbg(ATH10K_DBG_HTC, "ep %d got %d credits\n",
-			   report->eid, report->credits);
-
 		ep = &htc->endpoint[report->eid];
 		ep->tx_credits += report->credits;
 		htc->ar->no_tx_credits_at = 0;
 
+		ath10k_dbg(ATH10K_DBG_HTC, "ep %d got %d credits tot %d\n",
+			   report->eid, report->credits, ep->tx_credits);
+
 		if (ep->ep_ops.ep_tx_credits) {
 			spin_unlock_bh(&htc->tx_lock);
 			ep->ep_ops.ep_tx_credits(htc->ar);
@@ -680,7 +684,7 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 
 	reinit_completion(&htc->ctl_resp);
 
-	status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb);
+	status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb, __LINE__);
 	if (status) {
 		kfree_skb(skb);
 		return status;
@@ -826,7 +830,7 @@ int ath10k_htc_start(struct ath10k_htc *htc)
 
 	ath10k_dbg(ATH10K_DBG_HTC, "HTC is using TX credit flow control\n");
 
-	status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb);
+	status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb, __LINE__);
 	if (status) {
 		kfree_skb(skb);
 		return status;
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index 4716d33..b86dc2b 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -356,7 +356,7 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 			       struct ath10k_htc_svc_conn_req  *conn_req,
 			       struct ath10k_htc_svc_conn_resp *conn_resp);
 int ath10k_htc_send(struct ath10k_htc *htc, enum ath10k_htc_ep_id eid,
-		    struct sk_buff *packet);
+		    struct sk_buff *packet, int dbg);
 void ath10k_htc_stop(struct ath10k_htc *htc);
 struct sk_buff *ath10k_htc_alloc_skb(int size);
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 7a3e2e4..22a4542 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -173,7 +173,7 @@ int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt)
 	cmd = (struct htt_cmd *)skb->data;
 	cmd->hdr.msg_type = HTT_H2T_MSG_TYPE_VERSION_REQ;
 
-	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
+	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb, __LINE__);
 	if (ret) {
 		dev_kfree_skb_any(skb);
 		return ret;
@@ -212,7 +212,7 @@ int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie)
 	req->cookie_lsb = cpu_to_le32(cookie & 0xffffffff);
 	req->cookie_msb = cpu_to_le32((cookie & 0xffffffff00000000ULL) >> 32);
 
-	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
+	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb, __LINE__);
 	if (ret) {
 		ath10k_warn("failed to send htt type stats request: %d", ret);
 		dev_kfree_skb_any(skb);
@@ -298,7 +298,7 @@ int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt)
 
 #undef desc_offset
 
-	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
+	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb, __LINE__);
 	if (ret) {
 		dev_kfree_skb_any(skb);
 		return ret;
@@ -360,7 +360,7 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 
 	skb_cb->htt.txbuf = NULL;
 
-	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc);
+	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc, __LINE__);
 	if (res)
 		goto err_unmap_msdu;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 8b99e17..a8827e2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -544,7 +544,7 @@ static int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
 	cmd_hdr->cmd_id = __cpu_to_le32(cmd);
 
 	memset(skb_cb, 0, sizeof(*skb_cb));
-	ret = ath10k_htc_send(&ar->htc, ar->wmi.eid, skb);
+	ret = ath10k_htc_send(&ar->htc, ar->wmi.eid, skb, 0x71100000 | cmd_id);
 	trace_ath10k_wmi_cmd(cmd_id, skb->data, skb->len, ret);
 
 	if (ret)
-- 
1.7.11.7

