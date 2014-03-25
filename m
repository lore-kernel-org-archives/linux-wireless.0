Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:48493 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaCYJPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 05:15:19 -0400
Subject: [PATCH 3/8] ath10k: fix name of target_ps module parameter
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Mar 2014 11:15:17 +0200
Message-ID: <20140325091517.16651.58082.stgit@potku.adurom.net> (sfid-20140325_101523_806850_F76E8D52)
In-Reply-To: <20140325091311.16651.15747.stgit@potku.adurom.net>
References: <20140325091311.16651.15747.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The parameter name was ath10k_target_ps, but actually it should be just
target_ps. Module parameter names should not use the ath10k_ prefix.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d968aedc4863..2c5a83d2748a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -44,12 +44,12 @@ enum ath10k_pci_reset_mode {
 	ATH10K_PCI_RESET_WARM_ONLY = 1,
 };
 
-static unsigned int ath10k_target_ps;
+static unsigned int ath10k_pci_target_ps;
 static unsigned int ath10k_pci_irq_mode = ATH10K_PCI_IRQ_AUTO;
 static unsigned int ath10k_pci_reset_mode = ATH10K_PCI_RESET_AUTO;
 
-module_param(ath10k_target_ps, uint, 0644);
-MODULE_PARM_DESC(ath10k_target_ps, "Enable ath10k Target (SoC) PS option");
+module_param_named(target_ps, ath10k_pci_target_ps, uint, 0644);
+MODULE_PARM_DESC(target_ps, "Enable ath10k Target (SoC) PS option");
 
 module_param_named(irq_mode, ath10k_pci_irq_mode, uint, 0644);
 MODULE_PARM_DESC(irq_mode, "0: auto, 1: legacy, 2: msi (default: 0)");
@@ -2524,7 +2524,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_ar_pci;
 	}
 
-	if (ath10k_target_ps)
+	if (ath10k_pci_target_ps)
 		set_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features);
 
 	ath10k_pci_dump_features(ar_pci);

