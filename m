Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62419 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1JGQ1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 12:27:36 -0400
Date: Fri, 07 Oct 2011 11:27:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Change debug parameter to apply to individual
 drivers
Message-ID: <4e8f2875.9zb3XOO0mZeRKHSE%Larry.Finger@lwfinger.net> (sfid-20111007_182803_090991_E1152E55)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current debug parameter is applied to rtlwifi, which means that all
loaded drivers have the same level of debugging applied. In addition,
the previous method requires a two-step load process to enable debugging.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is -next material.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/debug.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/debug.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/debug.c
@@ -30,17 +30,11 @@
 
 #include "wifi.h"
 
-static unsigned int debug = DBG_EMERG;
-module_param(debug, uint, 0);
-MODULE_PARM_DESC(debug, "Set global debug level for rtlwifi (0,2-5)");
-
 void rtl_dbgp_flag_init(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 i;
 
-	rtlpriv->dbg.global_debuglevel = debug;
-
 	rtlpriv->dbg.global_debugcomponents =
 	    COMP_ERR | COMP_FW | COMP_INIT | COMP_RECV | COMP_SEND |
 	    COMP_MLME | COMP_SCAN | COMP_INTR | COMP_LED | COMP_SEC |
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -131,6 +131,8 @@ int rtl92c_init_sw_vars(struct ieee80211
 
 	rtlpci->irq_mask[1] = (u32) (IMR_CPWM | IMR_C2HCMD | 0);
 
+	/* for debug level */
+	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -253,6 +255,7 @@ static struct rtl_mod_params rtl92ce_mod
 	.inactiveps = true,
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
+	.debug = DBG_EMERG,
 };
 
 static struct rtl_hal_cfg rtl92ce_hal_cfg = {
@@ -367,6 +370,7 @@ MODULE_FIRMWARE("rtlwifi/rtl8192cfwU.bin
 MODULE_FIRMWARE("rtlwifi/rtl8192cfwU_B.bin");
 
 module_param_named(swenc, rtl92ce_mod_params.sw_crypto, bool, 0444);
+module_param_named(debug, rtl92ce_mod_params.debug, int, 0444);
 module_param_named(ips, rtl92ce_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92ce_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92ce_mod_params.fwctrl_lps, bool, 0444);
@@ -374,6 +378,7 @@ MODULE_PARM_DESC(swenc, "Set to 1 for so
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
+MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
 static const struct dev_pm_ops rtlwifi_pm_ops = {
 	.suspend = rtl_pci_suspend,
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
@@ -1487,6 +1487,9 @@ struct rtl_mod_params {
 	/* default: 0 = using hardware encryption */
 	int sw_crypto;
 
+	/* default: 0 = DBG_EMERG (0)*/
+	int debug;
+
 	/* default: 1 = using no linked power save */
 	bool inactiveps;
 
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -60,6 +60,7 @@ static int rtl92cu_init_sw_vars(struct i
 	rtlpriv->dm.dm_flag = 0;
 	rtlpriv->dm.disable_framebursting = 0;
 	rtlpriv->dm.thermalvalue = 0;
+	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
 	rtlpriv->rtlhal.pfirmware = vmalloc(0x4000);
 	if (!rtlpriv->rtlhal.pfirmware) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
@@ -149,8 +150,14 @@ static struct rtl_hal_ops rtl8192cu_hal_
 
 static struct rtl_mod_params rtl92cu_mod_params = {
 	.sw_crypto = 0,
+	.debug = DBG_EMERG,
 };
 
+module_param_named(swenc, rtl92cu_mod_params.sw_crypto, bool, 0444);
+module_param_named(debug, rtl92cu_mod_params.debug, int, 0444);
+MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
+MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+
 static struct rtl_hal_usbint_cfg rtl92cu_interface_cfg = {
 	/* rx */
 	.in_ep_num = RTL92C_USB_BULK_IN_NUM,
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
@@ -146,6 +146,8 @@ static int rtl92d_init_sw_vars(struct ie
 
 	rtlpci->irq_mask[1] = (u32) (IMR_CPWM | IMR_C2HCMD);
 
+	/* for debug level */
+	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -267,6 +269,7 @@ static struct rtl_mod_params rtl92de_mod
 	.inactiveps = true,
 	.swctrl_lps = true,
 	.fwctrl_lps = false,
+	.debug = DBG_EMERG,
 };
 
 static struct rtl_hal_cfg rtl92de_hal_cfg = {
@@ -377,6 +380,7 @@ MODULE_DESCRIPTION("Realtek 8192DE 802.1
 MODULE_FIRMWARE("rtlwifi/rtl8192defw.bin");
 
 module_param_named(swenc, rtl92de_mod_params.sw_crypto, bool, 0444);
+module_param_named(debug, rtl92de_mod_params.debug, int, 0444);
 module_param_named(ips, rtl92de_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92de_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92de_mod_params.fwctrl_lps, bool, 0444);
@@ -384,6 +388,7 @@ MODULE_PARM_DESC(swenc, "Set to 1 for so
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
+MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
 static const struct dev_pm_ops rtlwifi_pm_ops = {
 	.suspend = rtl_pci_suspend,
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -160,6 +160,8 @@ static int rtl92s_init_sw_vars(struct ie
 
 	rtlpci->first_init = true;
 
+	/* for debug level */
+	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -272,6 +274,7 @@ static struct rtl_mod_params rtl92se_mod
 	.inactiveps = true,
 	.swctrl_lps = true,
 	.fwctrl_lps = false,
+	.debug = DBG_EMERG,
 };
 
 /* Because memory R/W bursting will cause system hang/crash
@@ -389,6 +392,7 @@ MODULE_DESCRIPTION("Realtek 8192S/8191S
 MODULE_FIRMWARE("rtlwifi/rtl8192sefw.bin");
 
 module_param_named(swenc, rtl92se_mod_params.sw_crypto, bool, 0444);
+module_param_named(debug, rtl92se_mod_params.debug, int, 0444);
 module_param_named(ips, rtl92se_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92se_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92se_mod_params.fwctrl_lps, bool, 0444);
@@ -396,6 +400,7 @@ MODULE_PARM_DESC(swenc, "Set to 1 for so
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
+MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
 static const struct dev_pm_ops rtlwifi_pm_ops = {
 	.suspend = rtl_pci_suspend,
