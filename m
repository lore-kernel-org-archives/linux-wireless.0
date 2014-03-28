Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:43819 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaC1Hc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 03:32:29 -0400
Subject: [PATCH v2 2/8] ath10k: add module parameter to disable cold reset
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 09:32:27 +0200
Message-ID: <20140328073227.30438.84645.stgit@potku.adurom.net> (sfid-20140328_083232_284941_4802D6F6)
In-Reply-To: <20140328073040.30438.17966.stgit@potku.adurom.net>
References: <20140328073040.30438.17966.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As cold reset is not reliable with CUS223 boards, make it possible
to disable cold reset entirely and only use warm reset. This makes it also
easier to debug warm reset problems.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 43d63677b133..9dab859ed77b 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -39,8 +39,14 @@ enum ath10k_pci_irq_mode {
 	ATH10K_PCI_IRQ_MSI = 2,
 };
 
+enum ath10k_pci_reset_mode {
+	ATH10K_PCI_RESET_AUTO = 0,
+	ATH10K_PCI_RESET_WARM_ONLY = 1,
+};
+
 static unsigned int ath10k_target_ps;
 static unsigned int ath10k_pci_irq_mode = ATH10K_PCI_IRQ_AUTO;
+static unsigned int ath10k_pci_reset_mode = ATH10K_PCI_RESET_AUTO;
 
 module_param(ath10k_target_ps, uint, 0644);
 MODULE_PARM_DESC(ath10k_target_ps, "Enable ath10k Target (SoC) PS option");
@@ -48,6 +54,9 @@ MODULE_PARM_DESC(ath10k_target_ps, "Enable ath10k Target (SoC) PS option");
 module_param_named(irq_mode, ath10k_pci_irq_mode, uint, 0644);
 MODULE_PARM_DESC(irq_mode, "0: auto, 1: legacy, 2: msi (default: 0)");
 
+module_param_named(reset_mode, ath10k_pci_reset_mode, uint, 0644);
+MODULE_PARM_DESC(reset_mode, "0: auto, 1: warm only (default: 0)");
+
 /* how long wait to wait for target to initialise, in ms */
 #define ATH10K_PCI_TARGET_WAIT 3000
 
@@ -1969,9 +1978,14 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 	 */
 	ret = __ath10k_pci_hif_power_up(ar, false);
 	if (ret) {
-		ath10k_warn("failed to power up target using warm reset (%d), trying cold reset\n",
+		ath10k_warn("failed to power up target using warm reset: %d\n",
 			    ret);
 
+		if (ath10k_pci_reset_mode == ATH10K_PCI_RESET_WARM_ONLY)
+			return ret;
+
+		ath10k_warn("trying cold reset\n");
+
 		ret = __ath10k_pci_hif_power_up(ar, true);
 		if (ret) {
 			ath10k_err("failed to power up target using cold reset too (%d)\n",

