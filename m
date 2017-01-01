Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34834 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754832AbdAABHR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Dec 2016 20:07:17 -0500
Received: by mail-oi0-f67.google.com with SMTP id v84so62356636oie.2
        for <linux-wireless@vger.kernel.org>; Sat, 31 Dec 2016 17:07:17 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 2/3] rtlwifi: Convert COMP_XX entries into a proper debugging mask
Date: Sat, 31 Dec 2016 19:07:05 -0600
Message-Id: <20170101010706.13234-3-Larry.Finger@lwfinger.net> (sfid-20170101_020726_582861_65E53370)
In-Reply-To: <20170101010706.13234-1-Larry.Finger@lwfinger.net>
References: <20170101010706.13234-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The debugging macros contain a parameter COMP_XX that could be used as a
mask; however, the code turns all these various bits on at the same time.
This change implements them as a proper mask, and adds module parameters
to set the mask at load time.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/debug.c        | 17 +++--------------
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c |  5 +++++
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c |  5 +++++
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c |  5 +++++
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c |  5 +++++
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c |  5 +++++
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c |  5 +++++
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c |  5 +++++
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c |  5 +++++
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c |  5 +++++
 drivers/net/wireless/realtek/rtlwifi/wifi.h         |  4 +++-
 11 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index cd2efac..23a54be 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -31,17 +31,6 @@ void rtl_dbgp_flag_init(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 i;
 
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
 	for (i = 0; i < DBGP_TYPE_MAX; i++)
 		rtlpriv->dbg.dbgp_type[i] = 0;
 
@@ -53,7 +42,7 @@ EXPORT_SYMBOL_GPL(rtl_dbgp_flag_init);
 void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
 		    const char *fmt, ...)
 {
-	if (unlikely((comp & rtlpriv->dbg.global_debugcomponents) &&
+	if (unlikely((comp & rtlpriv->dbg.global_debug_mask) &&
 		     (level <= rtlpriv->dbg.global_debuglevel))) {
 		struct va_format vaf;
 		va_list args;
@@ -73,7 +62,7 @@ EXPORT_SYMBOL_GPL(_rtl_dbg_trace);
 void _rtl_dbg_print(struct rtl_priv *rtlpriv, u64 comp, int level,
 		    const char *fmt, ...)
 {
-	if (unlikely((comp & rtlpriv->dbg.global_debugcomponents) &&
+	if (unlikely((comp & rtlpriv->dbg.global_debug_mask) &&
 		     (level <= rtlpriv->dbg.global_debuglevel))) {
 		struct va_format vaf;
 		va_list args;
@@ -94,7 +83,7 @@ void _rtl_dbg_print_data(struct rtl_priv *rtlpriv, u64 comp, int level,
 			 const char *titlestring,
 			 const void *hexdata, int hexdatalen)
 {
-	if (unlikely(((comp) & rtlpriv->dbg.global_debugcomponents) &&
+	if (unlikely(((comp) & rtlpriv->dbg.global_debug_mask) &&
 		     ((level) <= rtlpriv->dbg.global_debuglevel))) {
 		pr_debug("In process \"%s\" (pid %i): %s\n",
 			 current->comm, current->pid, titlestring);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
index 1bf2993..75d8f75 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
@@ -133,6 +133,8 @@ int rtl88e_init_sw_vars(struct ieee80211_hw *hw)
 
 	/* for debug level */
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
+	/* for debug mask */
+	rtlpriv->dbg.global_debug_mask = rtlpriv->cfg->mod_params->debug_mask;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -277,6 +279,7 @@ static struct rtl_mod_params rtl88ee_mod_params = {
 	.fwctrl_lps = false,
 	.msi_support = true,
 	.debug = 0,
+	.debug_mask = 0,
 };
 
 static const struct rtl_hal_cfg rtl88ee_hal_cfg = {
@@ -393,6 +396,7 @@ MODULE_FIRMWARE("rtlwifi/rtl8188efw.bin");
 
 module_param_named(swenc, rtl88ee_mod_params.sw_crypto, bool, 0444);
 module_param_named(debug, rtl88ee_mod_params.debug, int, 0444);
+module_param_named(debug_mask, rtl88ee_mod_params.debug_mask, ullong, 0444);
 module_param_named(ips, rtl88ee_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl88ee_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl88ee_mod_params.fwctrl_lps, bool, 0444);
@@ -405,6 +409,7 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 1)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default 0)\n");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
index 1fd8818..93ef2a5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
@@ -132,6 +132,8 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 
 	/* for debug level */
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
+	/* for debug mask */
+	rtlpriv->dbg.global_debug_mask = rtlpriv->cfg->mod_params->debug_mask;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -248,6 +250,7 @@ static struct rtl_mod_params rtl92ce_mod_params = {
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
 	.debug = 0,
+	.debug_mask = 0,
 };
 
 static const struct rtl_hal_cfg rtl92ce_hal_cfg = {
@@ -365,6 +368,7 @@ MODULE_FIRMWARE("rtlwifi/rtl8192cfwU_B.bin");
 
 module_param_named(swenc, rtl92ce_mod_params.sw_crypto, bool, 0444);
 module_param_named(debug, rtl92ce_mod_params.debug, int, 0444);
+module_param_named(debug_mask, rtl92ce_mod_params.debug_mask, ullong, 0444);
 module_param_named(ips, rtl92ce_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92ce_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92ce_mod_params.fwctrl_lps, bool, 0444);
@@ -373,6 +377,7 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
index 935e830..bca46ed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
@@ -62,6 +62,8 @@ static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 	rtlpriv->dm.disable_framebursting = false;
 	rtlpriv->dm.thermalvalue = 0;
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
+	/* for debug mask */
+	rtlpriv->dbg.global_debug_mask = rtlpriv->cfg->mod_params->debug_mask;
 	rtlpriv->cfg->mod_params->sw_crypto =
 		rtlpriv->cfg->mod_params->sw_crypto;
 
@@ -158,12 +160,15 @@ static struct rtl_hal_ops rtl8192cu_hal_ops = {
 static struct rtl_mod_params rtl92cu_mod_params = {
 	.sw_crypto = 0,
 	.debug = 0,
+	.debug_mask = 0,
 };
 
 module_param_named(swenc, rtl92cu_mod_params.sw_crypto, bool, 0444);
 module_param_named(debug, rtl92cu_mod_params.debug, int, 0444);
+module_param_named(debug_mask, rtl92cu_mod_params.debug_mask, ullong, 0444);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 
 static struct rtl_hal_usbint_cfg rtl92cu_interface_cfg = {
 	/* rx */
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
index 680217f..e214761 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
@@ -142,6 +142,8 @@ static int rtl92d_init_sw_vars(struct ieee80211_hw *hw)
 
 	/* for debug level */
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
+	/* for debug mask */
+	rtlpriv->dbg.global_debug_mask = rtlpriv->cfg->mod_params->debug_mask;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -255,6 +257,7 @@ static struct rtl_mod_params rtl92de_mod_params = {
 	.swctrl_lps = true,
 	.fwctrl_lps = false,
 	.debug = 0,
+	.debug_mask = 0,
 };
 
 static const struct rtl_hal_cfg rtl92de_hal_cfg = {
@@ -368,11 +371,13 @@ module_param_named(debug, rtl92de_mod_params.debug, int, 0444);
 module_param_named(ips, rtl92de_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92de_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92de_mod_params.fwctrl_lps, bool, 0444);
+module_param_named(debug_mask, rtl92de_mod_params.debug_mask, ullong, 0444);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 1)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 0)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
index 17e675d..91387ed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
@@ -135,6 +135,8 @@ int rtl92ee_init_sw_vars(struct ieee80211_hw *hw)
 
 	/* for debug level */
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
+	/* for debug mask */
+	rtlpriv->dbg.global_debug_mask = rtlpriv->cfg->mod_params->debug_mask;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -259,6 +261,7 @@ static struct rtl_mod_params rtl92ee_mod_params = {
 	.fwctrl_lps = true,
 	.msi_support = true,
 	.debug = 0,
+	.debug_mask = 0,
 };
 
 static const struct rtl_hal_cfg rtl92ee_hal_cfg = {
@@ -369,6 +372,7 @@ MODULE_FIRMWARE("rtlwifi/rtl8192eefw.bin");
 
 module_param_named(swenc, rtl92ee_mod_params.sw_crypto, bool, 0444);
 module_param_named(debug, rtl92ee_mod_params.debug, int, 0444);
+module_param_named(debug_mask, rtl92ee_mod_params.debug_mask, ullong, 0444);
 module_param_named(ips, rtl92ee_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92ee_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92ee_mod_params.fwctrl_lps, bool, 0444);
@@ -381,6 +385,7 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 1)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default 0)\n");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
index a19d1ec..a6db38e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
@@ -180,6 +180,8 @@ static int rtl92s_init_sw_vars(struct ieee80211_hw *hw)
 
 	/* for debug level */
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
+	/* for debug mask */
+	rtlpriv->dbg.global_debug_mask = rtlpriv->cfg->mod_params->debug_mask;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -298,6 +300,7 @@ static struct rtl_mod_params rtl92se_mod_params = {
 	.swctrl_lps = true,
 	.fwctrl_lps = false,
 	.debug = 0,
+	.debug_mask = 0,
 };
 
 /* Because memory R/W bursting will cause system hang/crash
@@ -417,6 +420,7 @@ MODULE_FIRMWARE("rtlwifi/rtl8192sefw.bin");
 
 module_param_named(swenc, rtl92se_mod_params.sw_crypto, bool, 0444);
 module_param_named(debug, rtl92se_mod_params.debug, int, 0444);
+module_param_named(debug_mask, rtl92se_mod_params.debug_mask, ullong, 0444);
 module_param_named(ips, rtl92se_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92se_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92se_mod_params.fwctrl_lps, bool, 0444);
@@ -425,6 +429,7 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 1)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 0)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
index 833ef8a..e42c5b1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
@@ -147,6 +147,8 @@ int rtl8723e_init_sw_vars(struct ieee80211_hw *hw)
 
 	/* for debug level */
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
+	/* for debug mask */
+	rtlpriv->dbg.global_debug_mask = rtlpriv->cfg->mod_params->debug_mask;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -269,6 +271,7 @@ static struct rtl_mod_params rtl8723e_mod_params = {
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
 	.debug = 0,
+	.debug_mask = 0,
 	.msi_support = false,
 	.disable_watchdog = false,
 };
@@ -383,6 +386,7 @@ MODULE_FIRMWARE("rtlwifi/rtl8723efw.bin");
 
 module_param_named(swenc, rtl8723e_mod_params.sw_crypto, bool, 0444);
 module_param_named(debug, rtl8723e_mod_params.debug, int, 0444);
+module_param_named(debug_mask, rtl8723e_mod_params.debug_mask, ullong, 0444);
 module_param_named(ips, rtl8723e_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl8723e_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl8723e_mod_params.fwctrl_lps, bool, 0444);
@@ -395,6 +399,7 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 0)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default 0)\n");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
index f8322fc..c02300d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
@@ -146,6 +146,8 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
 
 	/* for debug level */
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
+	/* for debug mask */
+	rtlpriv->dbg.global_debug_mask = rtlpriv->cfg->mod_params->debug_mask;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -272,6 +274,7 @@ static struct rtl_mod_params rtl8723be_mod_params = {
 	.msi_support = false,
 	.disable_watchdog = false,
 	.debug = 0,
+	.debug_mask = 0,
 	.ant_sel = 0,
 };
 
@@ -387,6 +390,7 @@ MODULE_FIRMWARE("rtlwifi/rtl8723befw.bin");
 
 module_param_named(swenc, rtl8723be_mod_params.sw_crypto, bool, 0444);
 module_param_named(debug, rtl8723be_mod_params.debug, int, 0444);
+module_param_named(debug_mask, rtl8723be_mod_params.debug_mask, ullong, 0444);
 module_param_named(ips, rtl8723be_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl8723be_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl8723be_mod_params.fwctrl_lps, bool, 0444);
@@ -400,6 +404,7 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 0)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog,
 		 "Set to 1 to disable the watchdog (default 0)\n");
 MODULE_PARM_DESC(ant_sel, "Set to 1 or 2 to force antenna number (default 0)\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index 6ecaf94..28d778e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -162,6 +162,8 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 
 	/* for debug level */
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
+	/* for debug mask */
+	rtlpriv->dbg.global_debug_mask = rtlpriv->cfg->mod_params->debug_mask;
 	/* for LPS & IPS */
 	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
 	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
@@ -310,6 +312,7 @@ static struct rtl_mod_params rtl8821ae_mod_params = {
 	.msi_support = true,
 	.int_clear = true,
 	.debug = 0,
+	.debug_mask = 0,
 	.disable_watchdog = 0,
 };
 
@@ -431,6 +434,7 @@ MODULE_FIRMWARE("rtlwifi/rtl8821aefw.bin");
 
 module_param_named(swenc, rtl8821ae_mod_params.sw_crypto, bool, 0444);
 module_param_named(debug, rtl8821ae_mod_params.debug, int, 0444);
+module_param_named(debug_mask, rtl8821ae_mod_params.debug_mask, ullong, 0444);
 module_param_named(ips, rtl8821ae_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl8821ae_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl8821ae_mod_params.fwctrl_lps, bool, 0444);
@@ -444,6 +448,7 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 1)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
+MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default 0)\n");
 MODULE_PARM_DESC(int_clear, "Set to 0 to disable interrupt clear before set (default 1)\n");
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index dafe486..419d512 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2221,6 +2221,8 @@ struct rtl_intf_ops {
 };
 
 struct rtl_mod_params {
+	/* default: 0,0 */
+	u64 debug_mask;
 	/* default: 0 = using hardware encryption */
 	bool sw_crypto;
 
@@ -2348,7 +2350,7 @@ struct rtl_works {
 struct rtl_debug {
 	u32 dbgp_type[DBGP_TYPE_MAX];
 	int global_debuglevel;
-	u64 global_debugcomponents;
+	u64 global_debug_mask;
 
 	/* add for proc debug */
 	struct proc_dir_entry *proc_dir;
-- 
2.10.2
