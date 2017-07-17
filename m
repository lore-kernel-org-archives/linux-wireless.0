Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34490 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751342AbdGQPKO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 11:10:14 -0400
Received: by mail-oi0-f66.google.com with SMTP id d77so18146899oig.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 08:10:14 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 11/11] rtlwifi: Add module parameter ASPM
Date: Mon, 17 Jul 2017 10:09:54 -0500
Message-Id: <20170717150954.1441-12-Larry.Finger@lwfinger.net> (sfid-20170717_171017_961825_A8EE51BD)
In-Reply-To: <20170717150954.1441-1-Larry.Finger@lwfinger.net>
References: <20170717150954.1441-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

On some platforms, enable ASPM will cause AER error to be logged, thus
we use a parameter to selectively turn on ASPM.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - no changes
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c | 6 +++++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c | 6 +++++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c | 6 +++++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c | 6 +++++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c | 6 +++++-
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c | 6 +++++-
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c | 6 +++++-
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 6 +++++-
 drivers/net/wireless/realtek/rtlwifi/wifi.h         | 3 +++
 9 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
index 774e72058d24..41906ae5e0d8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
@@ -41,6 +41,7 @@
 
 static void rtl88e_init_aspm_vars(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
 	/*close ASPM for AMD defaultly */
@@ -77,7 +78,7 @@ static void rtl88e_init_aspm_vars(struct ieee80211_hw *hw)
 	 * 1 - Support ASPM,
 	 * 2 - According to chipset.
 	 */
-	rtlpci->const_support_pciaspm = 1;
+	rtlpci->const_support_pciaspm = rtlpriv->cfg->mod_params->aspm_support;
 }
 
 int rtl88e_init_sw_vars(struct ieee80211_hw *hw)
@@ -274,6 +275,7 @@ static struct rtl_mod_params rtl88ee_mod_params = {
 	.swctrl_lps = false,
 	.fwctrl_lps = false,
 	.msi_support = true,
+	.aspm_support = 1,
 	.debug_level = 0,
 	.debug_mask = 0,
 };
@@ -397,6 +399,7 @@ module_param_named(ips, rtl88ee_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl88ee_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl88ee_mod_params.fwctrl_lps, bool, 0444);
 module_param_named(msi, rtl88ee_mod_params.msi_support, bool, 0444);
+module_param_named(aspm, rtl88ee_mod_params.aspm_support, int, 0444);
 module_param_named(disable_watchdog, rtl88ee_mod_params.disable_watchdog,
 		   bool, 0444);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
@@ -404,6 +407,7 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 1)\n");
+MODULE_PARM_DESC(aspm, "Set to 1 to enable ASPM (default 1)\n");
 MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
 MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default 0)\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
index bcbb0c60f1f1..87dddd9c7e81 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
@@ -44,6 +44,7 @@
 
 static void rtl92c_init_aspm_vars(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
 	/*close ASPM for AMD defaultly */
@@ -83,7 +84,7 @@ static void rtl92c_init_aspm_vars(struct ieee80211_hw *hw)
 	 * 1 - Support ASPM,
 	 * 2 - According to chipset.
 	 */
-	rtlpci->const_support_pciaspm = 1;
+	rtlpci->const_support_pciaspm = rtlpriv->cfg->mod_params->aspm_support;
 }
 
 int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
@@ -250,6 +251,7 @@ static struct rtl_mod_params rtl92ce_mod_params = {
 	.inactiveps = true,
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
+	.aspm_support = 1,
 	.debug_level = 0,
 	.debug_mask = 0,
 };
@@ -373,10 +375,12 @@ module_param_named(debug_mask, rtl92ce_mod_params.debug_mask, ullong, 0644);
 module_param_named(ips, rtl92ce_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92ce_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92ce_mod_params.fwctrl_lps, bool, 0444);
+module_param_named(aspm, rtl92ce_mod_params.aspm_support, int, 0444);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
+MODULE_PARM_DESC(aspm, "Set to 1 to enable ASPM (default 1)\n");
 MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
 MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
index 16132c66e5e1..627105e45b54 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
@@ -40,6 +40,7 @@
 
 static void rtl92d_init_aspm_vars(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
 	/*close ASPM for AMD defaultly */
@@ -79,7 +80,7 @@ static void rtl92d_init_aspm_vars(struct ieee80211_hw *hw)
 	 * 1 - Support ASPM,
 	 * 2 - According to chipset.
 	 */
-	rtlpci->const_support_pciaspm = 1;
+	rtlpci->const_support_pciaspm = rtlpriv->cfg->mod_params->aspm_support;
 }
 
 static int rtl92d_init_sw_vars(struct ieee80211_hw *hw)
@@ -252,6 +253,7 @@ static struct rtl_mod_params rtl92de_mod_params = {
 	.inactiveps = true,
 	.swctrl_lps = true,
 	.fwctrl_lps = false,
+	.aspm_support = 1,
 	.debug_level = 0,
 	.debug_mask = 0,
 };
@@ -367,11 +369,13 @@ module_param_named(debug_level, rtl92de_mod_params.debug_level, int, 0644);
 module_param_named(ips, rtl92de_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92de_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92de_mod_params.fwctrl_lps, bool, 0444);
+module_param_named(aspm, rtl92de_mod_params.aspm_support, int, 0444);
 module_param_named(debug_mask, rtl92de_mod_params.debug_mask, ullong, 0644);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 1)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 0)\n");
+MODULE_PARM_DESC(aspm, "Set to 1 to enable ASPM (default 1)\n");
 MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
 MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
index ffee7b3b5af7..0c38b3409eab 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
@@ -44,6 +44,7 @@
 
 static void rtl92ee_init_aspm_vars(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
 	/*close ASPM for AMD defaultly */
@@ -83,7 +84,7 @@ static void rtl92ee_init_aspm_vars(struct ieee80211_hw *hw)
 	 * 1 - Support ASPM,
 	 * 2 - According to chipset.
 	 */
-	rtlpci->const_support_pciaspm = 1;
+	rtlpci->const_support_pciaspm = rtlpriv->cfg->mod_params->aspm_support;
 }
 
 int rtl92ee_init_sw_vars(struct ieee80211_hw *hw)
@@ -258,6 +259,7 @@ static struct rtl_mod_params rtl92ee_mod_params = {
 	.fwctrl_lps = true,
 	.msi_support = true,
 	.dma64 = false,
+	.aspm_support = 1,
 	.debug_level = 0,
 	.debug_mask = 0,
 };
@@ -376,6 +378,7 @@ module_param_named(swlps, rtl92ee_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92ee_mod_params.fwctrl_lps, bool, 0444);
 module_param_named(msi, rtl92ee_mod_params.msi_support, bool, 0444);
 module_param_named(dma64, rtl92ee_mod_params.dma64, bool, 0444);
+module_param_named(aspm, rtl92ee_mod_params.aspm_support, int, 0444);
 module_param_named(disable_watchdog, rtl92ee_mod_params.disable_watchdog,
 		   bool, 0444);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
@@ -384,6 +387,7 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 1)\n");
 MODULE_PARM_DESC(dma64, "Set to 1 to use DMA 64 (default 0)\n");
+MODULE_PARM_DESC(aspm, "Set to 1 to enable ASPM (default 1)\n");
 MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
 MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default 0)\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
index e7a37ee8ca5d..ae552b4f5326 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
@@ -41,6 +41,7 @@
 
 static void rtl92s_init_aspm_vars(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
 	/*close ASPM for AMD defaultly */
@@ -77,7 +78,7 @@ static void rtl92s_init_aspm_vars(struct ieee80211_hw *hw)
 	 * 1 - Support ASPM,
 	 * 2 - According to chipset.
 	 */
-	rtlpci->const_support_pciaspm = 2;
+	rtlpci->const_support_pciaspm = rtlpriv->cfg->mod_params->aspm_support;
 }
 
 static void rtl92se_fw_cb(const struct firmware *firmware, void *context)
@@ -295,6 +296,7 @@ static struct rtl_mod_params rtl92se_mod_params = {
 	.inactiveps = true,
 	.swctrl_lps = true,
 	.fwctrl_lps = false,
+	.aspm_support = 2,
 	.debug_level = 0,
 	.debug_mask = 0,
 };
@@ -420,10 +422,12 @@ module_param_named(debug_mask, rtl92se_mod_params.debug_mask, ullong, 0644);
 module_param_named(ips, rtl92se_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl92se_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92se_mod_params.fwctrl_lps, bool, 0444);
+module_param_named(aspm, rtl92se_mod_params.aspm_support, int, 0444);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 1)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 0)\n");
+MODULE_PARM_DESC(aspm, "Set to 1 to enable ASPM (default 1)\n");
 MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
 MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
index 7bf9f2557920..10381fa73f18 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
@@ -46,6 +46,7 @@
 
 static void rtl8723e_init_aspm_vars(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
 	/*close ASPM for AMD defaultly */
@@ -85,7 +86,7 @@ static void rtl8723e_init_aspm_vars(struct ieee80211_hw *hw)
 	 * 1 - Support ASPM,
 	 * 2 - According to chipset.
 	 */
-	rtlpci->const_support_pciaspm = 1;
+	rtlpci->const_support_pciaspm = rtlpriv->cfg->mod_params->aspm_support;
 }
 
 int rtl8723e_init_sw_vars(struct ieee80211_hw *hw)
@@ -266,6 +267,7 @@ static struct rtl_mod_params rtl8723e_mod_params = {
 	.inactiveps = true,
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
+	.aspm_support = 1,
 	.debug_level = 0,
 	.debug_mask = 0,
 	.msi_support = false,
@@ -387,6 +389,7 @@ module_param_named(ips, rtl8723e_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl8723e_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl8723e_mod_params.fwctrl_lps, bool, 0444);
 module_param_named(msi, rtl8723e_mod_params.msi_support, bool, 0444);
+module_param_named(aspm, rtl8723e_mod_params.aspm_support, int, 0444);
 module_param_named(disable_watchdog, rtl8723e_mod_params.disable_watchdog,
 		   bool, 0444);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
@@ -394,6 +397,7 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 0)\n");
+MODULE_PARM_DESC(aspm, "Set to 1 to enable ASPM (default 1)\n");
 MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
 MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default 0)\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
index f9d10f1e7cf8..f9be37503829 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
@@ -46,6 +46,7 @@
 
 static void rtl8723be_init_aspm_vars(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
 	/*close ASPM for AMD defaultly */
@@ -82,7 +83,7 @@ static void rtl8723be_init_aspm_vars(struct ieee80211_hw *hw)
 	 * 1 - Support ASPM,
 	 * 2 - According to chipset.
 	 */
-	rtlpci->const_support_pciaspm = 1;
+	rtlpci->const_support_pciaspm = rtlpriv->cfg->mod_params->aspm_support;
 }
 
 int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
@@ -277,6 +278,7 @@ static struct rtl_mod_params rtl8723be_mod_params = {
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
 	.msi_support = false,
+	.aspm_support = 1,
 	.disable_watchdog = false,
 	.debug_level = 0,
 	.debug_mask = 0,
@@ -401,6 +403,7 @@ module_param_named(ips, rtl8723be_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl8723be_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl8723be_mod_params.fwctrl_lps, bool, 0444);
 module_param_named(msi, rtl8723be_mod_params.msi_support, bool, 0444);
+module_param_named(aspm, rtl8723be_mod_params.aspm_support, int, 0444);
 module_param_named(disable_watchdog, rtl8723be_mod_params.disable_watchdog,
 		   bool, 0444);
 module_param_named(ant_sel, rtl8723be_mod_params.ant_sel, int, 0444);
@@ -409,6 +412,7 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 0)\n");
+MODULE_PARM_DESC(aspm, "Set to 1 to enable ASPM (default 1)\n");
 MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
 MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index d71d2776ca03..17a5b3b9e667 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -43,6 +43,7 @@
 
 static void rtl8821ae_init_aspm_vars(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
 	/*close ASPM for AMD defaultly */
@@ -82,7 +83,7 @@ static void rtl8821ae_init_aspm_vars(struct ieee80211_hw *hw)
 	 * 1 - Support ASPM,
 	 * 2 - According to chipset.
 	 */
-	rtlpci->const_support_pciaspm = 1;
+	rtlpci->const_support_pciaspm = rtlpriv->cfg->mod_params->aspm_support;
 }
 
 /*InitializeVariables8812E*/
@@ -315,6 +316,7 @@ static struct rtl_mod_params rtl8821ae_mod_params = {
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
 	.msi_support = true,
+	.aspm_support = 1,
 	.int_clear = true,
 	.debug_level = 0,
 	.debug_mask = 0,
@@ -445,6 +447,7 @@ module_param_named(ips, rtl8821ae_mod_params.inactiveps, bool, 0444);
 module_param_named(swlps, rtl8821ae_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl8821ae_mod_params.fwctrl_lps, bool, 0444);
 module_param_named(msi, rtl8821ae_mod_params.msi_support, bool, 0444);
+module_param_named(aspm, rtl8821ae_mod_params.aspm_support, int, 0444);
 module_param_named(disable_watchdog, rtl8821ae_mod_params.disable_watchdog,
 		   bool, 0444);
 module_param_named(int_clear, rtl8821ae_mod_params.int_clear, bool, 0444);
@@ -453,6 +456,7 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 1)\n");
+MODULE_PARM_DESC(aspm, "Set to 1 to enable ASPM (default 1)\n");
 MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
 MODULE_PARM_DESC(debug_mask, "Set debug mask (default 0)");
 MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default 0)\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index bb29c97a2c1f..55fe365418be 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2262,6 +2262,9 @@ struct rtl_mod_params {
 	/* default: 0 = dma 32 */
 	bool dma64;
 
+	/* default: 1 = enable aspm */
+	int aspm_support;
+
 	/* default 0: 1 means disable */
 	bool disable_watchdog;
 
-- 
2.12.3
