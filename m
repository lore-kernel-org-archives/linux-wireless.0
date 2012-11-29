Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52898 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab2K2W1l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 17:27:41 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	ath9k-devel@lists.ath9k.org, Larry.Finger@lwfinger.net,
	chunkeey@googlemail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] rtlwifi: use SIMPLE_DEV_PM_OPS
Date: Thu, 29 Nov 2012 23:27:17 +0100
Message-Id: <1354228037-1700-4-git-send-email-hauke@hauke-m.de> (sfid-20121129_232744_055143_F933854B)
In-Reply-To: <1354228037-1700-1-git-send-email-hauke@hauke-m.de>
References: <1354228037-1700-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtlwifi only provides pm callbacks for functions covered by pm sleep
and they are also just called if CONFIG_PM_SLEEP is set.

Only add functions rtl_pci_suspend and rtl_pci_resume if
CONFIG_PM_SLEEP is set and use SIMPLE_DEV_PM_OPS instead of
manually filling struct dev_pm_ops.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/rtlwifi/pci.c          |    2 ++
 drivers/net/wireless/rtlwifi/pci.h          |    2 ++
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c |    9 +--------
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c |    9 +--------
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c |    9 +--------
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c |    9 +--------
 6 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index f38e30a..086140c 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1982,6 +1982,7 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(rtl_pci_disconnect);
 
+#ifdef CONFIG_PM_SLEEP
 /***************************************
 kernel pci power state define:
 PCI_D0         ((pci_power_t __force) 0)
@@ -2021,6 +2022,7 @@ int rtl_pci_resume(struct device *dev)
 	return 0;
 }
 EXPORT_SYMBOL(rtl_pci_resume);
+#endif /* CONFIG_PM_SLEEP */
 
 struct rtl_intf_ops rtl_pci_ops = {
 	.read_efuse_byte = read_efuse_byte,
diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
index f71b12a..7ea50a3 100644
--- a/drivers/net/wireless/rtlwifi/pci.h
+++ b/drivers/net/wireless/rtlwifi/pci.h
@@ -239,8 +239,10 @@ extern struct rtl_intf_ops rtl_pci_ops;
 int __devinit rtl_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id);
 void rtl_pci_disconnect(struct pci_dev *pdev);
+#ifdef CONFIG_PM_SLEEP
 int rtl_pci_suspend(struct device *dev);
 int rtl_pci_resume(struct device *dev);
+#endif /* CONFIG_PM_SLEEP */
 static inline u8 pci_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
 	return readb((u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index 60451ee..49f663b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -372,14 +372,7 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
-static const struct dev_pm_ops rtlwifi_pm_ops = {
-	.suspend = rtl_pci_suspend,
-	.resume = rtl_pci_resume,
-	.freeze = rtl_pci_suspend,
-	.thaw = rtl_pci_resume,
-	.poweroff = rtl_pci_suspend,
-	.restore = rtl_pci_resume,
-};
+static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
 
 static struct pci_driver rtl92ce_driver = {
 	.name = KBUILD_MODNAME,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
index 480862c..e17f670 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
@@ -378,14 +378,7 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
-static const struct dev_pm_ops rtlwifi_pm_ops = {
-	.suspend = rtl_pci_suspend,
-	.resume = rtl_pci_resume,
-	.freeze = rtl_pci_suspend,
-	.thaw = rtl_pci_resume,
-	.poweroff = rtl_pci_suspend,
-	.restore = rtl_pci_resume,
-};
+static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
 
 static struct pci_driver rtl92de_driver = {
 	.name = KBUILD_MODNAME,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
index ad4b480..940034f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -432,14 +432,7 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
-static const struct dev_pm_ops rtlwifi_pm_ops = {
-	.suspend = rtl_pci_suspend,
-	.resume = rtl_pci_resume,
-	.freeze = rtl_pci_suspend,
-	.thaw = rtl_pci_resume,
-	.poweroff = rtl_pci_suspend,
-	.restore = rtl_pci_resume,
-};
+static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
 
 static struct pci_driver rtl92se_driver = {
 	.name = KBUILD_MODNAME,
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
index 0afdc24..18b0bc5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
@@ -367,14 +367,7 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
-static const struct dev_pm_ops rtlwifi_pm_ops = {
-	.suspend = rtl_pci_suspend,
-	.resume = rtl_pci_resume,
-	.freeze = rtl_pci_suspend,
-	.thaw = rtl_pci_resume,
-	.poweroff = rtl_pci_suspend,
-	.restore = rtl_pci_resume,
-};
+static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
 
 static struct pci_driver rtl8723ae_driver = {
 	.name = KBUILD_MODNAME,
-- 
1.7.10.4

