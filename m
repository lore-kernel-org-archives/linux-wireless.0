Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36590 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312AbaHVMnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:43:10 -0400
Received: by mail-lb0-f174.google.com with SMTP id c11so9264187lbj.5
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:43:09 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 4/5] ath10k: remove ar_pci->started
Date: Fri, 22 Aug 2014 14:33:17 +0200
Message-Id: <1408710798-25198-5-git-send-email-michal.kazior@tieto.com> (sfid-20140822_144321_321580_2E72A66D)
In-Reply-To: <1408710798-25198-1-git-send-email-michal.kazior@tieto.com>
References: <1408710798-25198-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are basically no more uses for
ar_pci->started. It is also perfectly safe to call
hif_stop without hif_start now.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * tweak commit message
     * don't update power_down() comment

 drivers/net/wireless/ath/ath10k/pci.c | 10 ----------
 drivers/net/wireless/ath/ath10k/pci.h |  2 --
 2 files changed, 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index cb4049f..3af462a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1115,14 +1115,11 @@ static void ath10k_pci_irq_enable(struct ath10k *ar)
 
 static int ath10k_pci_hif_start(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif start\n");
 
 	ath10k_pci_irq_enable(ar);
 	ath10k_pci_rx_post(ar);
 
-	ar_pci->started = 1;
 	return 0;
 }
 
@@ -1225,13 +1222,8 @@ static void ath10k_pci_flush(struct ath10k *ar)
 
 static void ath10k_pci_hif_stop(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif stop\n");
 
-	if (WARN_ON(!ar_pci->started))
-		return;
-
 	ath10k_pci_irq_disable(ar);
 	ath10k_pci_flush(ar);
 
@@ -1240,8 +1232,6 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	 * memory is to reset the chip now.
 	 */
 	ath10k_pci_warm_reset(ar);
-
-	ar_pci->started = 0;
 }
 
 static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index b9aa692..d88928c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -167,8 +167,6 @@ struct ath10k_pci {
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct msi_fw_err;
 
-	int started;
-
 	struct ath10k_pci_pipe pipe_info[CE_COUNT_MAX];
 
 	struct ath10k_hif_cb msg_callbacks_current;
-- 
1.8.5.3

