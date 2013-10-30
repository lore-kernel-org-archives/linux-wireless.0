Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:36917 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3J3LpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 07:45:22 -0400
Received: by mail-ee0-f42.google.com with SMTP id b45so711545eek.15
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 04:45:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 12/12] ath10k: add some debug prints
Date: Wed, 30 Oct 2013 12:42:26 +0100
Message-Id: <1383133346-8135-13-git-send-email-michal.kazior@tieto.com> (sfid-20131030_124555_016592_6B5E9236)
In-Reply-To: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some errors were handled too silently. Also add a
print indicating BMI is booted.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 7b606d0..42dd0b7 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1832,6 +1832,8 @@ static void ath10k_pci_start_bmi(struct ath10k *ar)
 
 	pipe = &ar_pci->pipe_info[BMI_CE_NUM_TO_HOST];
 	ath10k_ce_recv_cb_register(pipe->ce_hdl, ath10k_pci_bmi_recv_data);
+
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot start bmi\n");
 }
 
 static int ath10k_pci_hif_power_up(struct ath10k *ar)
@@ -1860,8 +1862,10 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 		ath10k_do_pci_wake(ar);
 
 	ret = ath10k_pci_ce_init(ar);
-	if (ret)
+	if (ret) {
+		ath10k_err("could not initialize CE (%d)\n", ret);
 		goto err_ps;
+	}
 
 	ret = ath10k_ce_disable_interrupts(ar);
 	if (ret) {
@@ -1876,16 +1880,22 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 	}
 
 	ret = ath10k_pci_wait_for_target_init(ar);
-	if (ret)
+	if (ret) {
+		ath10k_err("failed to wait for target to init (%d)\n", ret);
 		goto err_irq;
+	}
 
 	ret = ath10k_ce_enable_err_irq(ar);
-	if (ret)
+	if (ret) {
+		ath10k_err("failed to enable CE error irq (%d)\n", ret);
 		goto err_irq;
+	}
 
 	ret = ath10k_pci_init_config(ar);
-	if (ret)
+	if (ret) {
+		ath10k_err("failed to setup init config (%d)\n", ret);
 		goto err_irq;
+	}
 
 	ret = ath10k_pci_wake_target_cpu(ar);
 	if (ret) {
-- 
1.8.4.rc3

