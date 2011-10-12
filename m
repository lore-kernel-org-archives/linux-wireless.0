Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64830 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1JLC3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 22:29:22 -0400
Received: by ywb5 with SMTP id 5so226869ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 19:29:21 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/5 V2] rtlwifi: Change PCI drivers to use the new PM framework
Date: Tue, 11 Oct 2011 21:28:47 -0500
Message-Id: <1318386531-5859-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111012_042932_183436_4A204315)
In-Reply-To: <1318386531-5859-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1318386531-5859-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/pci.c          |   19 ++++---------------
 drivers/net/wireless/rtlwifi/pci.h          |    4 ++--
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c |   16 ++++++++++------
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c |   16 ++++++++++------
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c |   16 ++++++++++------
 5 files changed, 36 insertions(+), 35 deletions(-)

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -1993,36 +1993,25 @@ call rtl_mac_stop() from the mac80211
 suspend function first, So there is
 no need to call hw_disable here.
 ****************************************/
-int rtl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+int rtl_pci_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	rtlpriv->cfg->ops->hw_suspend(hw);
 	rtl_deinit_rfkill(hw);
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
 	return 0;
 }
 EXPORT_SYMBOL(rtl_pci_suspend);
 
-int rtl_pci_resume(struct pci_dev *pdev)
+int rtl_pci_resume(struct device *dev)
 {
-	int ret;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	pci_set_power_state(pdev, PCI_D0);
-	ret = pci_enable_device(pdev);
-	if (ret) {
-		RT_ASSERT(false, ("ERR: <======\n"));
-		return ret;
-	}
-
-	pci_restore_state(pdev);
-
 	rtlpriv->cfg->ops->hw_resume(hw);
 	rtl_init_rfkill(hw);
 	return 0;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.h
@@ -237,8 +237,8 @@ extern struct rtl_intf_ops rtl_pci_ops;
 int __devinit rtl_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id);
 void rtl_pci_disconnect(struct pci_dev *pdev);
-int rtl_pci_suspend(struct pci_dev *pdev, pm_message_t state);
-int rtl_pci_resume(struct pci_dev *pdev);
+int rtl_pci_suspend(struct device *dev);
+int rtl_pci_resume(struct device *dev);
 
 static inline u8 pci_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -370,17 +370,21 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
+static const struct dev_pm_ops rtlwifi_pm_ops = {
+	.suspend = rtl_pci_suspend,
+	.resume = rtl_pci_resume,
+	.freeze = rtl_pci_suspend,
+	.thaw = rtl_pci_resume,
+	.poweroff = rtl_pci_suspend,
+	.restore = rtl_pci_resume,
+};
+
 static struct pci_driver rtl92ce_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtl92ce_pci_ids,
 	.probe = rtl_pci_probe,
 	.remove = rtl_pci_disconnect,
-
-#ifdef CONFIG_PM
-	.suspend = rtl_pci_suspend,
-	.resume = rtl_pci_resume,
-#endif
-
+	.driver.pm = &rtlwifi_pm_ops,
 };
 
 static int __init rtl92ce_module_init(void)
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
@@ -390,17 +390,21 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
+static const struct dev_pm_ops rtlwifi_pm_ops = {
+	.suspend = rtl_pci_suspend,
+	.resume = rtl_pci_resume,
+	.freeze = rtl_pci_suspend,
+	.thaw = rtl_pci_resume,
+	.poweroff = rtl_pci_suspend,
+	.restore = rtl_pci_resume,
+};
+
 static struct pci_driver rtl92de_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtl92de_pci_ids,
 	.probe = rtl_pci_probe,
 	.remove = rtl_pci_disconnect,
-
-#ifdef CONFIG_PM
-	.suspend = rtl_pci_suspend,
-	.resume = rtl_pci_resume,
-#endif
-
+	.driver.pm = &rtlwifi_pm_ops,
 };
 
 /* add global spin lock to solve the problem that
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -401,17 +401,21 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
+static const struct dev_pm_ops rtlwifi_pm_ops = {
+	.suspend = rtl_pci_suspend,
+	.resume = rtl_pci_resume,
+	.freeze = rtl_pci_suspend,
+	.thaw = rtl_pci_resume,
+	.poweroff = rtl_pci_suspend,
+	.restore = rtl_pci_resume,
+};
+
 static struct pci_driver rtl92se_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtl92se_pci_ids,
 	.probe = rtl_pci_probe,
 	.remove = rtl_pci_disconnect,
-
-#ifdef CONFIG_PM
-	.suspend = rtl_pci_suspend,
-	.resume = rtl_pci_resume,
-#endif
-
+	.driver.pm = &rtlwifi_pm_ops,
 };
 
 static int __init rtl92se_module_init(void)
