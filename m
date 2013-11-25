Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:65367 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab3KYNKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 08:10:24 -0500
Received: by mail-ea0-f179.google.com with SMTP id r15so2347812ead.24
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 05:10:23 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 4/8] ath10k: decouple ath10k_pci_start_ce()
Date: Mon, 25 Nov 2013 14:06:23 +0100
Message-Id: <1385384787-12470-5-git-send-email-michal.kazior@tieto.com> (sfid-20131125_141050_109036_E362CF62)
In-Reply-To: <1385384787-12470-1-git-send-email-michal.kazior@tieto.com>
References: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
 <1385384787-12470-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function did a couple of things: it allocated
CE completions, registered CE callbacks and
enabled CE interrupts through HW registers.

This cannot be so. Split the function into one
that allocates CE completions and the other one
that starts off CE operation.

This is required for future legacy shared
interrupt handling.

This also fixes possible memory leak if post rx
failed.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 75 +++++++++++++++++++++++++----------
 1 file changed, 54 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 327afbc..05e6f8b 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -62,6 +62,7 @@ static void ath10k_pci_free_irq(struct ath10k *ar);
 static int ath10k_pci_bmi_wait(struct ath10k_ce_pipe *tx_pipe,
 			       struct ath10k_ce_pipe *rx_pipe,
 			       struct bmi_xfer *xfer);
+static void ath10k_pci_cleanup_ce(struct ath10k *ar);
 
 static const struct ce_attr host_ce_config_wlan[] = {
 	/* CE0: host->target HTC control and raw streams */
@@ -824,14 +825,13 @@ static void ath10k_pci_hif_set_callbacks(struct ath10k *ar,
 	       sizeof(ar_pci->msg_callbacks_current));
 }
 
-static int ath10k_pci_start_ce(struct ath10k *ar)
+static int ath10k_pci_alloc_compl(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_ce_pipe *ce_diag = ar_pci->ce_diag;
 	const struct ce_attr *attr;
 	struct ath10k_pci_pipe *pipe_info;
 	struct ath10k_pci_compl *compl;
-	int i, pipe_num, completions, disable_interrupts;
+	int i, pipe_num, completions;
 
 	spin_lock_init(&ar_pci->compl_lock);
 	INIT_LIST_HEAD(&ar_pci->compl_process);
@@ -843,34 +843,23 @@ static int ath10k_pci_start_ce(struct ath10k *ar)
 		INIT_LIST_HEAD(&pipe_info->compl_free);
 
 		/* Handle Diagnostic CE specially */
-		if (pipe_info->ce_hdl == ce_diag)
+		if (pipe_info->ce_hdl == ar_pci->ce_diag)
 			continue;
 
 		attr = &host_ce_config_wlan[pipe_num];
 		completions = 0;
 
-		if (attr->src_nentries) {
-			disable_interrupts = attr->flags & CE_ATTR_DIS_INTR;
-			ath10k_ce_send_cb_register(pipe_info->ce_hdl,
-						   ath10k_pci_ce_send_done,
-						   disable_interrupts);
+		if (attr->src_nentries)
 			completions += attr->src_nentries;
-		}
 
-		if (attr->dest_nentries) {
-			ath10k_ce_recv_cb_register(pipe_info->ce_hdl,
-						   ath10k_pci_ce_recv_data);
+		if (attr->dest_nentries)
 			completions += attr->dest_nentries;
-		}
-
-		if (completions == 0)
-			continue;
 
 		for (i = 0; i < completions; i++) {
 			compl = kmalloc(sizeof(*compl), GFP_KERNEL);
 			if (!compl) {
 				ath10k_warn("No memory for completion state\n");
-				ath10k_pci_stop_ce(ar);
+				ath10k_pci_cleanup_ce(ar);
 				return -ENOMEM;
 			}
 
@@ -882,6 +871,37 @@ static int ath10k_pci_start_ce(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_pci_setup_ce_irq(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	const struct ce_attr *attr;
+	struct ath10k_pci_pipe *pipe_info;
+	int pipe_num, disable_interrupts;
+
+	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
+		pipe_info = &ar_pci->pipe_info[pipe_num];
+
+		/* Handle Diagnostic CE specially */
+		if (pipe_info->ce_hdl == ar_pci->ce_diag)
+			continue;
+
+		attr = &host_ce_config_wlan[pipe_num];
+
+		if (attr->src_nentries) {
+			disable_interrupts = attr->flags & CE_ATTR_DIS_INTR;
+			ath10k_ce_send_cb_register(pipe_info->ce_hdl,
+						   ath10k_pci_ce_send_done,
+						   disable_interrupts);
+		}
+
+		if (attr->dest_nentries)
+			ath10k_ce_recv_cb_register(pipe_info->ce_hdl,
+						   ath10k_pci_ce_recv_data);
+	}
+
+	return 0;
+}
+
 static void ath10k_pci_kill_tasklet(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1210,22 +1230,35 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
 
-	ret = ath10k_pci_start_ce(ar);
+	ret = ath10k_pci_alloc_compl(ar);
 	if (ret) {
-		ath10k_warn("failed to start CE: %d\n", ret);
+		ath10k_warn("failed to allocate CE completions: %d\n", ret);
 		return ret;
 	}
 
+	ret = ath10k_pci_setup_ce_irq(ar);
+	if (ret) {
+		ath10k_warn("failed to setup CE interrupts: %d\n", ret);
+		goto err_free_compl;
+	}
+
 	/* Post buffers once to start things off. */
 	ret = ath10k_pci_post_rx(ar);
 	if (ret) {
 		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
 			    ret);
-		return ret;
+		goto err_stop_ce;
 	}
 
 	ar_pci->started = 1;
 	return 0;
+
+err_stop_ce:
+	ath10k_pci_stop_ce(ar);
+	ath10k_pci_process_ce(ar);
+err_free_compl:
+	ath10k_pci_cleanup_ce(ar);
+	return ret;
 }
 
 static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
-- 
1.8.4.rc3

