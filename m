Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37247 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab0JYUPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 16:15:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, wey-yi.w.guy@intel.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [RFC] iwlwifi: Convert to new PCI PM framework
Date: Mon, 25 Oct 2010 16:12:37 -0400
Message-Id: <1288037557-5197-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the new PCI PM and let the PCI core code handle the PCI-specific
details of power transitions.

Based on similarly titled ath9k patch posted by Rafael J. Wysocki.

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Compile-tested only...do the iwl_pci_resume changes look right?

 drivers/net/wireless/iwlwifi/iwl-agn.c      |    5 +----
 drivers/net/wireless/iwlwifi/iwl-core.c     |   26 ++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |   14 +++++++++++---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 +----
 4 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c2636a7..513bb31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4836,10 +4836,7 @@ static struct pci_driver iwl_driver = {
 	.id_table = iwl_hw_card_ids,
 	.probe = iwl_pci_probe,
 	.remove = __devexit_p(iwl_pci_remove),
-#ifdef CONFIG_PM
-	.suspend = iwl_pci_suspend,
-	.resume = iwl_pci_resume,
-#endif
+	.driver.pm = IWL_PM_OPS,
 };
 
 static int __init iwl_init(void)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 25fb391..eb39b43 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2584,8 +2584,9 @@ EXPORT_SYMBOL(iwl_add_beacon_time);
 
 #ifdef CONFIG_PM
 
-int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+int iwl_pci_suspend(struct device *device)
 {
+	struct pci_dev *pdev = to_pci_dev(device);
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	/*
@@ -2597,18 +2598,14 @@ int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	 */
 	iwl_apm_stop(priv);
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
-
 	return 0;
 }
 EXPORT_SYMBOL(iwl_pci_suspend);
 
-int iwl_pci_resume(struct pci_dev *pdev)
+int iwl_pci_resume(struct device *device)
 {
+	struct pci_dev *pdev = to_pci_dev(device);
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
-	int ret;
 	bool hw_rfkill = false;
 
 	/*
@@ -2617,11 +2614,6 @@ int iwl_pci_resume(struct pci_dev *pdev)
 	 */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
-	pci_set_power_state(pdev, PCI_D0);
-	ret = pci_enable_device(pdev);
-	if (ret)
-		return ret;
-	pci_restore_state(pdev);
 	iwl_enable_interrupts(priv);
 
 	if (!(iwl_read32(priv, CSR_GP_CNTRL) &
@@ -2639,4 +2631,14 @@ int iwl_pci_resume(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(iwl_pci_resume);
 
+const struct dev_pm_ops iwl_pm_ops = {
+	.suspend = iwl_pci_suspend,
+	.resume = iwl_pci_resume,
+	.freeze = iwl_pci_suspend,
+	.thaw = iwl_pci_resume,
+	.poweroff = iwl_pci_suspend,
+	.restore = iwl_pci_resume,
+};
+EXPORT_SYMBOL(iwl_pm_ops);
+
 #endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 64527de..b17de82 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -615,9 +615,17 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 			   u32 addon, u32 beacon_interval);
 
 #ifdef CONFIG_PM
-int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state);
-int iwl_pci_resume(struct pci_dev *pdev);
-#endif /* CONFIG_PM */
+int iwl_pci_suspend(struct device *device);
+int iwl_pci_resume(struct device *device);
+extern const struct dev_pm_ops iwl_pm_ops;
+
+#define IWL_PM_OPS	(&iwl_pm_ops)
+
+#else /* !CONFIG_PM */
+
+#define IWL_PM_OPS	NULL
+
+#endif /* !CONFIG_PM */
 
 /*****************************************************
 *  Error Handling Debugging
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8f8c4b7..895690f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4274,10 +4274,7 @@ static struct pci_driver iwl3945_driver = {
 	.id_table = iwl3945_hw_card_ids,
 	.probe = iwl3945_pci_probe,
 	.remove = __devexit_p(iwl3945_pci_remove),
-#ifdef CONFIG_PM
-	.suspend = iwl_pci_suspend,
-	.resume = iwl_pci_resume,
-#endif
+	.driver.pm = IWL_PM_OPS,
 };
 
 static int __init iwl3945_init(void)
-- 
1.7.2.3

