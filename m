Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33961 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753639AbdASReb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 12:34:31 -0500
Received: by mail-oi0-f68.google.com with SMTP id w144so3736401oiw.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2017 09:34:24 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH v2 2/3] rtlwifi: Convert COMP_XX entries into a proper debugging mask
Date: Thu, 19 Jan 2017 11:25:20 -0600
Message-Id: <20170119172521.32643-3-Larry.Finger@lwfinger.net> (sfid-20170119_183730_737667_E7C75D33)
In-Reply-To: <20170119172521.32643-1-Larry.Finger@lwfinger.net>
References: <20170119172521.32643-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The debugging macros contain a parameter COMP_XX that could be used as a
mask; however, the code turns all these various bits on at the same time.
This change implements them as a proper mask, and adds module parameters
to set the mask at load time.

The current name "debug" for the debug level has been changed to
"debug_level" to better differentiate it from "debug_mask".

The debug routines have also been changed to interrogate the structure
that is loaded at entry time. As a result, the structure rtl_debug is no
longer needed, and all references to it are deleted.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
V2 - renamed debug module parameter
     deleted struct rtl_debug
---
 drivers/net/wireless/realtek/rtlwifi/base.c        |  6 +--
 drivers/net/wireless/realtek/rtlwifi/debug.c       | 43 +++++-----------------
 drivers/net/wireless/realtek/rtlwifi/debug.h       |  2 -
 drivers/net/wireless/realtek/rtlwifi/pci.c         | 10 -----
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.c    | 11 +++---
 .../net/wireless/realtek/rtlwifi/rtl8192ce/sw.c    | 11 +++---
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    | 10 +++--
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c    | 11 +++---
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    | 11 +++---
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    | 11 +++---
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.c    | 11 +++---
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    | 11 +++---
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    | 11 +++---
 drivers/net/wireless/realtek/rtlwifi/usb.c         |  1 -
 drivers/net/wireless/realtek/rtlwifi/wifi.h        | 15 ++------
 15 files changed, 70 insertions(+), 105 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 13325e1..1b23b24 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2094,7 +2094,7 @@ static ssize_t rtl_show_debug_level(struct device *d,
 	struct ieee80211_hw *hw = dev_get_drvdata(d);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	return sprintf(buf, "0x%08X\n", rtlpriv->dbg.global_debuglevel);
+	return sprintf(buf, "0x%08X\n", rtlpriv->cfg->mod_params->debug_level);
 }
 
 static ssize_t rtl_store_debug_level(struct device *d,
@@ -2111,10 +2111,10 @@ static ssize_t rtl_store_debug_level(struct device *d,
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
 			 "%s is not in hex or decimal form.\n", buf);
 	} else {
-		rtlpriv->dbg.global_debuglevel = val;
+		rtlpriv->cfg->mod_params->debug_level = val;
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
 			 "debuglevel:%x\n",
-			 rtlpriv->dbg.global_debuglevel);
+			 rtlpriv->cfg->mod_params->debug_level);
 	}
 
 	return strnlen(buf, count);
diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index cd2efac..7ecac611 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -26,35 +26,12 @@
 
 #include <linux/moduleparam.h>
 
-void rtl_dbgp_flag_init(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 i;
-
-	rtlpriv->dbg.global_debugcomponents =
-	    COMP_ERR | COMP_FW | COMP_INIT | COMP_RECV | COMP_SEND |
-	    COMP_MLME | COMP_SCAN | COMP_INTR | COMP_LED | COMP_SEC |
-	    COMP_BEACON | COMP_RATE | COMP_RXDESC | COMP_DIG | COMP_TXAGC |
-	    COMP_POWER | COMP_POWER_TRACKING | COMP_BB_POWERSAVING | COMP_SWAS |
-	    COMP_RF | COMP_TURBO | COMP_RATR | COMP_CMD |
-	    COMP_EFUSE | COMP_QOS | COMP_MAC80211 | COMP_REGD | COMP_CHAN |
-	    COMP_EASY_CONCURRENT | COMP_EFUSE | COMP_QOS | COMP_MAC80211 |
-	    COMP_REGD | COMP_CHAN | COMP_BT_COEXIST;
-
-
-	for (i = 0; i < DBGP_TYPE_MAX; i++)
-		rtlpriv->dbg.dbgp_type[i] = 0;
-
-	/*Init Debug flag enable condition */
-}
-EXPORT_SYMBOL_GPL(rtl_dbgp_flag_init);
-
 #ifdef CONFIG_RTLWIFI_DEBUG
 void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
 		    const char *fmt, ...)
 {
-	if (unlikely((comp & rtlpriv->dbg.global_debugcomponents) &&
-		     (level <= rtlpriv->dbg.global_debuglevel))) {
+	if (unlikely((comp & rtlpriv->cfg->mod_params->debug_mask) &&
+		     (level <= rtlpriv->cfg->mod_params->debug_level))) {
 		struct va_format vaf;
 		va_list args;
 
@@ -63,7 +40,7 @@ void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
 		vaf.fmt = fmt;
 		vaf.va = &args;
 
-		pr_debug(":<%lx> %pV", in_interrupt(), &vaf);
+		pr_info(":<%lx> %pV", in_interrupt(), &vaf);
 
 		va_end(args);
 	}
@@ -73,8 +50,8 @@ EXPORT_SYMBOL_GPL(_rtl_dbg_trace);
 void _rtl_dbg_print(struct rtl_priv *rtlpriv, u64 comp, int level,
 		    const char *fmt, ...)
 {
-	if (unlikely((comp & rtlpriv->dbg.global_debugcomponents) &&
-		     (level <= rtlpriv->dbg.global_debuglevel))) {
+	if (unlikely((comp & rtlpriv->cfg->mod_params->debug_mask) &&
+		     (level <= rtlpriv->cfg->mod_params->debug_level))) {
 		struct va_format vaf;
 		va_list args;
 
@@ -83,7 +60,7 @@ void _rtl_dbg_print(struct rtl_priv *rtlpriv, u64 comp, int level,
 		vaf.fmt = fmt;
 		vaf.va = &args;
 
-		pr_debug("%pV", &vaf);
+		pr_info("%pV", &vaf);
 
 		va_end(args);
 	}
@@ -94,10 +71,10 @@ void _rtl_dbg_print_data(struct rtl_priv *rtlpriv, u64 comp, int level,
 			 const char *titlestring,
 			 const void *hexdata, int hexdatalen)
 {
-	if (unlikely(((comp) & rtlpriv->dbg.global_debugcomponents) &&
-		     ((level) <= rtlpriv->dbg.global_debuglevel))) {
-		pr_debug("In process \"%s\" (pid %i): %s\n",
-			 current->comm, current->pid, titlestring);
+	if (unlikely(((comp) & rtlpriv->cfg->mod_params->debug_mask) &&
+		     ((level) <= rtlpriv->cfg->mod_params->debug_level))) {
+		pr_info("In process \"%s\" (pid %i): %s\n",
+			current->comm, current->pid, titlestring);
 		print_hex_dump_bytes("", DUMP_PREFIX_NONE,
 				     hexdata, hexdatalen);
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index 90c670b..bf5339f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -218,6 +218,4 @@ static inline void RT_PRINT_DATA(struct rtl_priv *rtlpriv,
 }
 
 #endif
-
-void rtl_dbgp_flag_init(struct ieee80211_hw *hw);
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 81ac0b3..f6d4dbe 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2212,16 +2212,6 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	rtlpriv->intf_ops = &rtl_pci_ops;
 	rtlpriv->glb_var = &rtl_global_var;
 
-	/*
-	 *init dbgp flags before all
-	 *other functions, because we will
-	 *use it in other funtions like
-	 *RT_TRACE/RT_PRINT/RTL_PRINT_DATA
-	 *you can not use these macro
-	 *before this
-	 */
-	rtl_dbgp_flag_init(hw);
-
 	/* MEM map */
 	err = pci_request_regions(pdev, KBUILD_MODNAME);
 	if (err) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
index 276c745..7661cfa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
@@ -131,8 +131,6 @@ int rtl88e_init_sw_vars(struct ieee80211_hw *hw)
 	rtlpci->irq_mask[1] = (u32) (IMR_RXFOVW | 0);
 	rtlpci->sys_irq_mask = (u32) (HSIMR_PDN_INT_EN | HSIMR_RON_INT_EN);
 
-	/* for debug level */
-	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -276,7 +274,8 @@ static struct rtl_mod_params rtl88ee_mod_params = {
 	.swctrl_lps = false,
 	.fwctrl_lps = false,
 	.msi_support = true,
-	.debug = 0,
+	.debug_level = 0,
+	.debug_mask = 0,
 };
 
 static const struct rtl_hal_cfg rtl88ee_hal_cfg = {
@@ -392,7 +391,8 @@ MODULE_DESCRIPTION("Realtek 8188E 802.11n PCI wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8188efw.bin");
 
 module_param_named(swenc, rtl88ee_mod_params.sw_crypto, bool, 0444);
-module_param_named(debug, rtl88ee_mod_params.debug, int, 0444);
+module_param_named(debug_level, rtl88ee_mod_params.debug_level, int, 0644);
+module_param_named(debug_mask, rtl88ee_mod_params.debug_mask, ullong, 0644);
 module_param_named(ips, rtl88ee_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl88ee_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl88ee_mod_params.fwctrl_lps, bool, 0444);
@@ -404,7 +404,8 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 1)\n");
-MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default 0)\n");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
index 9bd2bff6..efedd91 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
@@ -130,8 +130,6 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 
 	rtlpci->irq_mask[1] = (u32) (IMR_CPWM | IMR_C2HCMD | 0);
 
-	/* for debug level */
-	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -247,7 +245,8 @@ static struct rtl_mod_params rtl92ce_mod_params = {
 	.inactiveps = true,
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
-	.debug = 0,
+	.debug_level = 0,
+	.debug_mask = 0,
 };
 
 static const struct rtl_hal_cfg rtl92ce_hal_cfg = {
@@ -364,7 +363,8 @@ MODULE_FIRMWARE("rtlwifi/rtl8192cfwU.bin");
 MODULE_FIRMWARE("rtlwifi/rtl8192cfwU_B.bin");
 
 module_param_named(swenc, rtl92ce_mod_params.sw_crypto, bool, 0444);
-module_param_named(debug, rtl92ce_mod_params.debug, int, 0444);
+module_param_named(debug_level, rtl92ce_mod_params.debug_level, int, 0644);
+module_param_named(debug_mask, rtl92ce_mod_params.debug_mask, ullong, 0644);
 module_param_named(ips, rtl92ce_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92ce_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92ce_mod_params.fwctrl_lps, bool, 0444);
@@ -372,7 +372,8 @@ MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
-MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
index 935e830..96c923b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
@@ -61,7 +61,6 @@ static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 	rtlpriv->dm.dm_flag = 0;
 	rtlpriv->dm.disable_framebursting = false;
 	rtlpriv->dm.thermalvalue = 0;
-	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
 	rtlpriv->cfg->mod_params->sw_crypto =
 		rtlpriv->cfg->mod_params->sw_crypto;
 
@@ -157,13 +156,16 @@ static struct rtl_hal_ops rtl8192cu_hal_ops = {
 
 static struct rtl_mod_params rtl92cu_mod_params = {
 	.sw_crypto = 0,
-	.debug = 0,
+	.debug_level = 0,
+	.debug_mask = 0,
 };
 
 module_param_named(swenc, rtl92cu_mod_params.sw_crypto, bool, 0444);
-module_param_named(debug, rtl92cu_mod_params.debug, int, 0444);
+module_param_named(debug_level, rtl92cu_mod_params.debug_level, int, 0644);
+module_param_named(debug_mask, rtl92cu_mod_params.debug_mask, ullong, 0644);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
-MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 
 static struct rtl_hal_usbint_cfg rtl92cu_interface_cfg = {
 	/* rx */
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
index 51463d7..16132c6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
@@ -140,8 +140,6 @@ static int rtl92d_init_sw_vars(struct ieee80211_hw *hw)
 
 	rtlpci->irq_mask[1] = (u32) (IMR_CPWM | IMR_C2HCMD);
 
-	/* for debug level */
-	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -254,7 +252,8 @@ static struct rtl_mod_params rtl92de_mod_params = {
 	.inactiveps = true,
 	.swctrl_lps = true,
 	.fwctrl_lps = false,
-	.debug = 0,
+	.debug_level = 0,
+	.debug_mask = 0,
 };
 
 static const struct rtl_hal_cfg rtl92de_hal_cfg = {
@@ -364,15 +363,17 @@ MODULE_DESCRIPTION("Realtek 8192DE 802.11n Dual Mac PCI wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8192defw.bin");
 
 module_param_named(swenc, rtl92de_mod_params.sw_crypto, bool, 0444);
-module_param_named(debug, rtl92de_mod_params.debug, int, 0444);
+module_param_named(debug_level, rtl92de_mod_params.debug_level, int, 0644);
 module_param_named(ips, rtl92de_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92de_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92de_mod_params.fwctrl_lps, bool, 0444);
+module_param_named(debug_mask, rtl92de_mod_params.debug_mask, ullong, 0644);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 1)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 0)\n");
-MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
index eddc704..554f2dc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
@@ -133,8 +133,6 @@ int rtl92ee_init_sw_vars(struct ieee80211_hw *hw)
 				     0);
 	rtlpci->irq_mask[1] = (u32)(IMR_RXFOVW | 0);
 
-	/* for debug level */
-	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -258,7 +256,8 @@ static struct rtl_mod_params rtl92ee_mod_params = {
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
 	.msi_support = true,
-	.debug = 0,
+	.debug_level = 0,
+	.debug_mask = 0,
 };
 
 static const struct rtl_hal_cfg rtl92ee_hal_cfg = {
@@ -368,7 +367,8 @@ MODULE_DESCRIPTION("Realtek 8192EE 802.11n PCI wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8192eefw.bin");
 
 module_param_named(swenc, rtl92ee_mod_params.sw_crypto, bool, 0444);
-module_param_named(debug, rtl92ee_mod_params.debug, int, 0444);
+module_param_named(debug_level, rtl92ee_mod_params.debug_level, int, 0644);
+module_param_named(debug_mask, rtl92ee_mod_params.debug_mask, ullong, 0644);
 module_param_named(ips, rtl92ee_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92ee_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92ee_mod_params.fwctrl_lps, bool, 0444);
@@ -380,7 +380,8 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 1)\n");
-MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default 0)\n");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
index 3c66d00..2006b09 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
@@ -178,8 +178,6 @@ static int rtl92s_init_sw_vars(struct ieee80211_hw *hw)
 
 	rtlpci->first_init = true;
 
-	/* for debug level */
-	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -297,7 +295,8 @@ static struct rtl_mod_params rtl92se_mod_params = {
 	.inactiveps = true,
 	.swctrl_lps = true,
 	.fwctrl_lps = false,
-	.debug = 0,
+	.debug_level = 0,
+	.debug_mask = 0,
 };
 
 /* Because memory R/W bursting will cause system hang/crash
@@ -416,7 +415,8 @@ MODULE_DESCRIPTION("Realtek 8192S/8191S 802.11n PCI wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8192sefw.bin");
 
 module_param_named(swenc, rtl92se_mod_params.sw_crypto, bool, 0444);
-module_param_named(debug, rtl92se_mod_params.debug, int, 0444);
+module_param_named(debug_level, rtl92se_mod_params.debug_level, int, 0644);
+module_param_named(debug_mask, rtl92se_mod_params.debug_mask, ullong, 0644);
 module_param_named(ips, rtl92se_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92se_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92se_mod_params.fwctrl_lps, bool, 0444);
@@ -424,7 +424,8 @@ MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 1)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 0)\n");
-MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
index 401f542..7bf9f25 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
@@ -145,8 +145,6 @@ int rtl8723e_init_sw_vars(struct ieee80211_hw *hw)
 		 (u32)(PHIMR_RXFOVW |
 				0);
 
-	/* for debug level */
-	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -268,7 +266,8 @@ static struct rtl_mod_params rtl8723e_mod_params = {
 	.inactiveps = true,
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
-	.debug = 0,
+	.debug_level = 0,
+	.debug_mask = 0,
 	.msi_support = false,
 	.disable_watchdog = false,
 };
@@ -382,7 +381,8 @@ MODULE_DESCRIPTION("Realtek 8723E 802.11n PCI wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8723efw.bin");
 
 module_param_named(swenc, rtl8723e_mod_params.sw_crypto, bool, 0444);
-module_param_named(debug, rtl8723e_mod_params.debug, int, 0444);
+module_param_named(debug_level, rtl8723e_mod_params.debug_level, int, 0644);
+module_param_named(debug_mask, rtl8723e_mod_params.debug_mask, ullong, 0644);
 module_param_named(ips, rtl8723e_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl8723e_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl8723e_mod_params.fwctrl_lps, bool, 0444);
@@ -394,7 +394,8 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 0)\n");
-MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default 0)\n");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
index dd42c1a..e571b87 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
@@ -144,8 +144,6 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
 				     HSIMR_RON_INT_EN	|
 				     0);
 
-	/* for debug level */
-	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -271,7 +269,8 @@ static struct rtl_mod_params rtl8723be_mod_params = {
 	.fwctrl_lps = true,
 	.msi_support = false,
 	.disable_watchdog = false,
-	.debug = 0,
+	.debug_level = 0,
+	.debug_mask = 0,
 	.ant_sel = 0,
 };
 
@@ -386,7 +385,8 @@ MODULE_DESCRIPTION("Realtek 8723BE 802.11n PCI wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8723befw.bin");
 
 module_param_named(swenc, rtl8723be_mod_params.sw_crypto, bool, 0444);
-module_param_named(debug, rtl8723be_mod_params.debug, int, 0444);
+module_param_named(debug_level, rtl8723be_mod_params.debug_level, int, 0644);
+module_param_named(debug_mask, rtl8723be_mod_params.debug_mask, ullong, 0644);
 module_param_named(ips, rtl8723be_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl8723be_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl8723be_mod_params.fwctrl_lps, bool, 0444);
@@ -399,7 +399,8 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 0)\n");
-MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog,
 		 "Set to 1 to disable the watchdog (default 0)\n");
 MODULE_PARM_DESC(ant_sel, "Set to 1 or 2 to force antenna number (default 0)\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index 220de5f..cd2a53b7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -160,8 +160,6 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 	rtlpriv->psc.wo_wlan_mode = WAKE_ON_MAGIC_PACKET |
 				    WAKE_ON_PATTERN_MATCH;
 
-	/* for debug level */
-	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -309,7 +307,8 @@ static struct rtl_mod_params rtl8821ae_mod_params = {
 	.fwctrl_lps = true,
 	.msi_support = true,
 	.int_clear = true,
-	.debug = 0,
+	.debug_level = 0,
+	.debug_mask = 0,
 	.disable_watchdog = 0,
 };
 
@@ -430,7 +429,8 @@ MODULE_DESCRIPTION("Realtek 8821ae 802.11ac PCI wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8821aefw.bin");
 
 module_param_named(swenc, rtl8821ae_mod_params.sw_crypto, bool, 0444);
-module_param_named(debug, rtl8821ae_mod_params.debug, int, 0444);
+module_param_named(debug_level, rtl8821ae_mod_params.debug_level, int, 0644);
+module_param_named(debug_mask, rtl8821ae_mod_params.debug_mask, ullong, 0644);
 module_param_named(ips, rtl8821ae_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl8821ae_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl8821ae_mod_params.fwctrl_lps, bool, 0444);
@@ -443,7 +443,8 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 1)\n");
-MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default 0)\n");
 MODULE_PARM_DESC(int_clear, "Set to 0 to disable interrupt clear before set (default 1)\n");
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index b2b62ef..20d3fcc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1073,7 +1073,6 @@ int rtl_usb_probe(struct usb_interface *intf,
 	rtlpriv->rtlhal.interface = INTF_USB;
 	rtlpriv->cfg = rtl_hal_cfg;
 	rtlpriv->intf_ops = &rtl_usb_ops;
-	rtl_dbgp_flag_init(hw);
 	/* Init IO handler */
 	_rtl_usb_io_handler_init(&udev->dev, hw);
 	rtlpriv->cfg->ops->read_chip_version(hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index dafe486..262c02a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2221,11 +2221,13 @@ struct rtl_intf_ops {
 };
 
 struct rtl_mod_params {
+	/* default: 0,0 */
+	u64 debug_mask;
 	/* default: 0 = using hardware encryption */
 	bool sw_crypto;
 
 	/* default: 0 = DBG_EMERG (0)*/
-	int debug;
+	int debug_level;
 
 	/* default: 1 = using no linked power save */
 	bool inactiveps;
@@ -2345,16 +2347,6 @@ struct rtl_works {
 	struct work_struct fill_h2c_cmd;
 };
 
-struct rtl_debug {
-	u32 dbgp_type[DBGP_TYPE_MAX];
-	int global_debuglevel;
-	u64 global_debugcomponents;
-
-	/* add for proc debug */
-	struct proc_dir_entry *proc_dir;
-	char proc_name[20];
-};
-
 #define MIMO_PS_STATIC			0
 #define MIMO_PS_DYNAMIC			1
 #define MIMO_PS_NOLIMIT			3
@@ -2583,7 +2575,6 @@ struct rtl_priv {
 	/* sta entry list for ap adhoc or mesh */
 	struct list_head entry_list;
 
-	struct rtl_debug dbg;
 	int max_fw_size;
 
 	/*
-- 
2.10.2
