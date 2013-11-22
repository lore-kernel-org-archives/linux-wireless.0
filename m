Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:64472 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3KVNIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 08:08:44 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so498387eaj.26
        for <linux-wireless@vger.kernel.org>; Fri, 22 Nov 2013 05:08:43 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/8] ath10k: don't use interrupts for BMI
Date: Fri, 22 Nov 2013 14:05:14 +0100
Message-Id: <1385125518-13461-5-git-send-email-michal.kazior@tieto.com> (sfid-20131122_140857_259128_9B7B0221)
In-Reply-To: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
References: <1385125518-13461-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not really necessary for interrupts to be
used for BMI. BMI already assumes there's only one
caller at a time and it works directly with CE.

Make BMI poll for CE completions instead of
waiting for interrupts. This makes disabling
interrupts during early boot possible.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 50 ++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 4067890..1b12db8 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -59,6 +59,9 @@ static int ath10k_pci_init_irq(struct ath10k *ar);
 static int ath10k_pci_deinit_irq(struct ath10k *ar);
 static int ath10k_pci_request_irq(struct ath10k *ar);
 static void ath10k_pci_free_irq(struct ath10k *ar);
+static int ath10k_pci_bmi_wait(struct ath10k_ce_pipe *tx_pipe,
+			       struct ath10k_ce_pipe *rx_pipe,
+			       struct bmi_xfer *xfer);
 
 static const struct ce_attr host_ce_config_wlan[] = {
 	/* CE0: host->target HTC control and raw streams */
@@ -1382,6 +1385,8 @@ static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
 	void *treq, *tresp = NULL;
 	int ret = 0;
 
+	might_sleep();
+
 	if (resp && !resp_len)
 		return -EINVAL;
 
@@ -1422,14 +1427,12 @@ static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
 	if (ret)
 		goto err_resp;
 
-	ret = wait_for_completion_timeout(&xfer.done,
-					  BMI_COMMUNICATION_TIMEOUT_HZ);
-	if (ret <= 0) {
+	ret = ath10k_pci_bmi_wait(ce_tx, ce_rx, &xfer);
+	if (ret) {
 		u32 unused_buffer;
 		unsigned int unused_nbytes;
 		unsigned int unused_id;
 
-		ret = -ETIMEDOUT;
 		ath10k_ce_cancel_send_next(ce_tx, NULL, &unused_buffer,
 					   &unused_nbytes, &unused_id);
 	} else {
@@ -1497,6 +1500,25 @@ static void ath10k_pci_bmi_recv_data(struct ath10k_ce_pipe *ce_state)
 	complete(&xfer->done);
 }
 
+static int ath10k_pci_bmi_wait(struct ath10k_ce_pipe *tx_pipe,
+			       struct ath10k_ce_pipe *rx_pipe,
+			       struct bmi_xfer *xfer)
+{
+	unsigned long timeout = jiffies + BMI_COMMUNICATION_TIMEOUT_HZ;
+
+	while (time_before_eq(jiffies, timeout)) {
+		ath10k_pci_bmi_send_done(tx_pipe);
+		ath10k_pci_bmi_recv_data(rx_pipe);
+
+		if (completion_done(&xfer->done))
+			return 0;
+
+		schedule();
+	}
+
+	return -ETIMEDOUT;
+}
+
 /*
  * Map from service/endpoint to Copy Engine.
  * This table is derived from the CE_PCI TABLE, above.
@@ -1834,24 +1856,6 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 	ath10k_pci_sleep(ar);
 }
 
-static void ath10k_pci_start_bmi(struct ath10k *ar)
-{
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_pci_pipe *pipe;
-
-	/*
-	 * Initially, establish CE completion handlers for use with BMI.
-	 * These are overwritten with generic handlers after we exit BMI phase.
-	 */
-	pipe = &ar_pci->pipe_info[BMI_CE_NUM_TO_TARG];
-	ath10k_ce_send_cb_register(pipe->ce_hdl, ath10k_pci_bmi_send_done, 0);
-
-	pipe = &ar_pci->pipe_info[BMI_CE_NUM_TO_HOST];
-	ath10k_ce_recv_cb_register(pipe->ce_hdl, ath10k_pci_bmi_recv_data);
-
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot start bmi\n");
-}
-
 static int ath10k_pci_hif_power_up(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1926,8 +1930,6 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 		goto err_free_irq;
 	}
 
-	ath10k_pci_start_bmi(ar);
-
 	if (ar_pci->num_msi_intrs > 1)
 		irq_mode = "MSI-X";
 	else if (ar_pci->num_msi_intrs == 1)
-- 
1.8.4.rc3

