Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:52937 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373Ab3GENPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 12/16] ath10k: embed HTC struct inside ath10k
Date: Fri,  5 Jul 2013 16:15:13 +0300
Message-Id: <1373030117-18077-13-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_151529_987001_E7503AD2)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

This reduces number of allocations and simplifies
memory managemnt.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c   |   28 ++++++++++++----------------
 drivers/net/wireless/ath/ath10k/core.h   |    2 +-
 drivers/net/wireless/ath/ath10k/htc.c    |   23 +++++------------------
 drivers/net/wireless/ath/ath10k/htc.h    |    4 +---
 drivers/net/wireless/ath/ath10k/htt.c    |    2 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |   10 +++++-----
 drivers/net/wireless/ath/ath10k/wmi.c    |    4 ++--
 7 files changed, 27 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index aabe166..4199560 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -100,7 +100,7 @@ static int ath10k_init_connect_htc(struct ath10k *ar)
 		goto conn_fail;
 
 	/* Start HTC */
-	status = ath10k_htc_start(ar->htc);
+	status = ath10k_htc_start(&ar->htc);
 	if (status)
 		goto conn_fail;
 
@@ -116,7 +116,7 @@ static int ath10k_init_connect_htc(struct ath10k *ar)
 	return 0;
 
 timeout:
-	ath10k_htc_stop(ar->htc);
+	ath10k_htc_stop(&ar->htc);
 conn_fail:
 	return status;
 }
@@ -505,7 +505,6 @@ EXPORT_SYMBOL(ath10k_core_destroy);
 
 int ath10k_core_register(struct ath10k *ar)
 {
-	struct ath10k_htc_ops htc_ops;
 	struct bmi_target_info target_info;
 	int status;
 
@@ -534,26 +533,26 @@ int ath10k_core_register(struct ath10k *ar)
 	if (status)
 		goto err;
 
-	htc_ops.target_send_suspend_complete = ath10k_send_suspend_complete;
+	ar->htc.htc_ops.target_send_suspend_complete =
+		ath10k_send_suspend_complete;
 
-	ar->htc = ath10k_htc_create(ar, &htc_ops);
-	if (IS_ERR(ar->htc)) {
-		status = PTR_ERR(ar->htc);
-		ath10k_err("could not create HTC (%d)\n", status);
+	status = ath10k_htc_init(ar);
+	if (status) {
+		ath10k_err("could not init HTC (%d)\n", status);
 		goto err;
 	}
 
 	status = ath10k_bmi_done(ar);
 	if (status)
-		goto err_htc_destroy;
+		goto err;
 
 	status = ath10k_wmi_attach(ar);
 	if (status) {
 		ath10k_err("WMI attach failed: %d\n", status);
-		goto err_htc_destroy;
+		goto err;
 	}
 
-	status = ath10k_htc_wait_target(ar->htc);
+	status = ath10k_htc_wait_target(&ar->htc);
 	if (status)
 		goto err_wmi_detach;
 
@@ -605,13 +604,11 @@ int ath10k_core_register(struct ath10k *ar)
 err_unregister_mac:
 	ath10k_mac_unregister(ar);
 err_disconnect_htc:
-	ath10k_htc_stop(ar->htc);
+	ath10k_htc_stop(&ar->htc);
 err_htt_detach:
 	ath10k_htt_detach(ar->htt);
 err_wmi_detach:
 	ath10k_wmi_detach(ar);
-err_htc_destroy:
-	ath10k_htc_destroy(ar->htc);
 err:
 	return status;
 }
@@ -623,10 +620,9 @@ void ath10k_core_unregister(struct ath10k *ar)
 	 * Otherwise we will fail to submit commands to FW and mac80211 will be
 	 * unhappy about callback failures. */
 	ath10k_mac_unregister(ar);
-	ath10k_htc_stop(ar->htc);
+	ath10k_htc_stop(&ar->htc);
 	ath10k_htt_detach(ar->htt);
 	ath10k_wmi_detach(ar);
-	ath10k_htc_destroy(ar->htc);
 }
 EXPORT_SYMBOL(ath10k_core_unregister);
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7489770..dfd4fe1 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -279,8 +279,8 @@ struct ath10k {
 	bool is_target_paused;
 
 	struct ath10k_bmi bmi;
+	struct ath10k_htc htc;
 
-	struct ath10k_htc *htc;
 	struct ath10k_htt *htt;
 
 	struct ath10k_hw_params {
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index f37a6e1..7d5a366 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -265,7 +265,7 @@ static int ath10k_htc_tx_completion_handler(struct ath10k *ar,
 					    struct sk_buff *skb,
 					    unsigned int eid)
 {
-	struct ath10k_htc *htc = ar->htc;
+	struct ath10k_htc *htc = &ar->htc;
 	struct ath10k_htc_ep *ep = &htc->endpoint[eid];
 	bool stopping;
 
@@ -414,7 +414,7 @@ static int ath10k_htc_rx_completion_handler(struct ath10k *ar,
 					    u8 pipe_id)
 {
 	int status = 0;
-	struct ath10k_htc *htc = ar->htc;
+	struct ath10k_htc *htc = &ar->htc;
 	struct ath10k_htc_hdr *hdr;
 	struct ath10k_htc_ep *ep;
 	u16 payload_len;
@@ -961,22 +961,14 @@ void ath10k_htc_stop(struct ath10k_htc *htc)
 }
 
 /* registered target arrival callback from the HIF layer */
-struct ath10k_htc *ath10k_htc_create(struct ath10k *ar,
-				     struct ath10k_htc_ops *htc_ops)
+int ath10k_htc_init(struct ath10k *ar)
 {
 	struct ath10k_hif_cb htc_callbacks;
 	struct ath10k_htc_ep *ep = NULL;
-	struct ath10k_htc *htc = NULL;
-
-	/* FIXME: use struct ath10k instead */
-	htc = kzalloc(sizeof(struct ath10k_htc), GFP_KERNEL);
-	if (!htc)
-		return ERR_PTR(-ENOMEM);
+	struct ath10k_htc *htc = &ar->htc;
 
 	spin_lock_init(&htc->tx_lock);
 
-	memcpy(&htc->htc_ops, htc_ops, sizeof(struct ath10k_htc_ops));
-
 	ath10k_htc_reset_endpoint_states(htc);
 
 	/* setup HIF layer callbacks */
@@ -992,10 +984,5 @@ struct ath10k_htc *ath10k_htc_create(struct ath10k *ar,
 
 	init_completion(&htc->ctl_resp);
 
-	return htc;
-}
-
-void ath10k_htc_destroy(struct ath10k_htc *htc)
-{
-	kfree(htc);
+	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index fa45844..1606c9f 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -352,8 +352,7 @@ struct ath10k_htc {
 	bool stopping;
 };
 
-struct ath10k_htc *ath10k_htc_create(struct ath10k *ar,
-				     struct ath10k_htc_ops *htc_ops);
+int ath10k_htc_init(struct ath10k *ar);
 int ath10k_htc_wait_target(struct ath10k_htc *htc);
 int ath10k_htc_start(struct ath10k_htc *htc);
 int ath10k_htc_connect_service(struct ath10k_htc *htc,
@@ -362,7 +361,6 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 int ath10k_htc_send(struct ath10k_htc *htc, enum ath10k_htc_ep_id eid,
 		    struct sk_buff *packet);
 void ath10k_htc_stop(struct ath10k_htc *htc);
-void ath10k_htc_destroy(struct ath10k_htc *htc);
 struct sk_buff *ath10k_htc_alloc_skb(int size);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 185a546..2bfb9b4 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -36,7 +36,7 @@ static int ath10k_htt_htc_attach(struct ath10k_htt *htt)
 	/* connect to control service */
 	conn_req.service_id = ATH10K_HTC_SVC_ID_HTT_DATA_MSG;
 
-	status = ath10k_htc_connect_service(htt->ar->htc, &conn_req,
+	status = ath10k_htc_connect_service(&htt->ar->htc, &conn_req,
 					    &conn_resp);
 
 	if (status)
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index ef79106..fa568f1 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -92,7 +92,7 @@ int ath10k_htt_tx_attach(struct ath10k_htt *htt)
 
 	/* At the beginning free queue number should hint us the maximum
 	 * queue length */
-	pipe = htt->ar->htc->endpoint[htt->eid].ul_pipe_id;
+	pipe = htt->ar->htc.endpoint[htt->eid].ul_pipe_id;
 	htt->max_num_pending_tx = ath10k_hif_get_free_queue_number(htt->ar,
 								   pipe);
 
@@ -194,7 +194,7 @@ int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt)
 
 	ATH10K_SKB_CB(skb)->htt.is_conf = true;
 
-	ret = ath10k_htc_send(htt->ar->htc, htt->eid, skb);
+	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
 	if (ret) {
 		dev_kfree_skb_any(skb);
 		return ret;
@@ -281,7 +281,7 @@ int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt)
 
 	ATH10K_SKB_CB(skb)->htt.is_conf = true;
 
-	ret = ath10k_htc_send(htt->ar->htc, htt->eid, skb);
+	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
 	if (ret) {
 		dev_kfree_skb_any(skb);
 		return ret;
@@ -346,7 +346,7 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	skb_cb->htt.refcount = 2;
 	skb_cb->htt.msdu = msdu;
 
-	res = ath10k_htc_send(htt->ar->htc, htt->eid, txdesc);
+	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc);
 	if (res)
 		goto err;
 
@@ -486,7 +486,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	skb_cb->htt.txfrag = txfrag;
 	skb_cb->htt.msdu = msdu;
 
-	res = ath10k_htc_send(htt->ar->htc, htt->eid, txdesc);
+	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc);
 	if (res)
 		goto err;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 1b5312d..681e941 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -111,7 +111,7 @@ static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
 
 	trace_ath10k_wmi_cmd(cmd_id, skb->data, skb->len);
 
-	status = ath10k_htc_send(ar->htc, ar->wmi.eid, skb);
+	status = ath10k_htc_send(&ar->htc, ar->wmi.eid, skb);
 	if (status) {
 		dev_kfree_skb_any(skb);
 		atomic_dec(&ar->wmi.pending_tx_count);
@@ -1114,7 +1114,7 @@ int ath10k_wmi_connect_htc_service(struct ath10k *ar)
 	/* connect to control service */
 	conn_req.service_id = ATH10K_HTC_SVC_ID_WMI_CONTROL;
 
-	status = ath10k_htc_connect_service(ar->htc, &conn_req, &conn_resp);
+	status = ath10k_htc_connect_service(&ar->htc, &conn_req, &conn_resp);
 	if (status) {
 		ath10k_warn("failed to connect to WMI CONTROL service status: %d\n",
 			    status);
-- 
1.7.9.5

