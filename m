Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56425 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab1JEDhD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 23:37:03 -0400
Received: by ywb5 with SMTP id 5so1180401ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 20:37:03 -0700 (PDT)
Message-ID: <4E8BD0D9.1000305@lwfinger.net> (sfid-20111005_053714_833399_16BD4309)
Date: Tue, 04 Oct 2011 22:36:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: RTL8192SE blank EFUSE readout after suspend resume cycle
References: <4E8AFBCB.8070100@gmail.com> <20111004135757.GA6207@redhat.com>
In-Reply-To: <20111004135757.GA6207@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------060006090609060302070307"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060006090609060302070307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/04/2011 08:57 AM, Stanislaw Gruszka wrote:
> On Tue, Oct 04, 2011 at 02:27:55PM +0200, Stefan Zwanenburg wrote:
>> I recently discussed this with Larry Finger and Chaomin Li, but every
>> once in a while, after having resumed from suspending to RAM, my NIC
>> (10ec:8172) doesn't work anymore, even after reloading the module. Even
>> worse, after reloading the module, my NIC's name gets changed (because
>> of udev rules) as a result of the MAC address changing, which means I
>> have to temporarily reconfigure whatever I'm using to make a connection
>> (wicd in my case).
>
> You might try configure pm-utils to unload module before suspend, by
> something like this:
>
> echo 'SUSPEND_MODULES="rtl8192se rtlwifi"'>>  /etc/pm/config.d/modules.conf
>
> Other than that, would be good to try if converting to new PM framework
> helps. It can be done quite simply, similar way like in this ath9k commit:
>
> commit f0e94b479c987abef17eb18e5c8e0ed178d00cd4
> Author: Rafael J. Wysocki<rjw@sisk.pl>
> Date:   Sat Oct 16 00:36:17 2010 +0200
>
>      ath9k: Convert to new PCI PM framework

Stefan,

Following Stanislaw's suggestion, I have reworked the PM routines to use the new 
framework. Attached is a patch. My system does not sleep and I cannot test it, 
but it does hibernate. Let me know what happens.

Larry


--------------060006090609060302070307
Content-Type: text/plain;
 name="rtl8192se_new_pm_framework"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192se_new_pm_framework"

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -397,17 +397,21 @@ MODULE_PARM_DESC(ips, "Set to 0 to not u
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 
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
@@ -365,17 +365,21 @@ MODULE_PARM_DESC(ips, "Set to 0 to not u
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 
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
@@ -385,17 +385,21 @@ MODULE_PARM_DESC(ips, "Set to 0 to not u
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 
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

--------------060006090609060302070307--
