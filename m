Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:11274 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714AbZIKRiU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:38:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/13] iwlwifi: Adjust blink rate to compensate Clock difference
Date: Fri, 11 Sep 2009 10:38:14 -0700
Message-Id: <1252690699-25796-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adjust led blink rate to compensate on a MAC Clock difference on every
HW. Led blink rate analysis showed an average deviation of 0% on 3945,
5% on 4965 HW and 20% on 5000 series and up.
Need to compensate on the led on/off time per HW according to the
deviation to achieve the desired led frequency
The calculation is: (100-averageDeviation)/100 * blinkTime
For code efficiency the calculation will be:
    compensation = (100 - averageDeviation) * 64 / 100
    NewBlinkTime = (compensation * BlinkTime) / 64

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.c |    2 +
 drivers/net/wireless/iwlwifi/iwl-4965.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c |    6 +++++
 drivers/net/wireless/iwlwifi/iwl-6000.c |    5 ++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    4 +++
 drivers/net/wireless/iwlwifi/iwl-led.c  |   33 +++++++++++++++++++++++++++++-
 7 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index b6d2abe..486b144 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -162,5 +162,6 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
 	.ht_greenfield_support = true,
+	.led_compensation = 51,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index e9a685d..63dfa57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2892,6 +2892,7 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.mod_params = &iwl3945_mod_params,
 	.use_isr_legacy = true,
 	.ht_greenfield_support = false,
+	.led_compensation = 64,
 };
 
 static struct iwl_cfg iwl3945_abg_cfg = {
@@ -2906,6 +2907,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.mod_params = &iwl3945_mod_params,
 	.use_isr_legacy = true,
 	.ht_greenfield_support = false,
+	.led_compensation = 64,
 };
 
 struct pci_device_id iwl3945_hw_card_ids[] = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6a13bfb..63df1e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2346,6 +2346,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.mod_params = &iwl4965_mod_params,
 	.use_isr_legacy = true,
 	.ht_greenfield_support = false,
+	.led_compensation = 61,
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e4acfc3..c31bde3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1646,6 +1646,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.valid_rx_ant = ANT_ABC,
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
+	.led_compensation = 51,
 };
 
 struct iwl_cfg iwl5100_bg_cfg = {
@@ -1663,6 +1664,7 @@ struct iwl_cfg iwl5100_bg_cfg = {
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
+	.led_compensation = 51,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
@@ -1680,6 +1682,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
+	.led_compensation = 51,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
@@ -1697,6 +1700,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
+	.led_compensation = 51,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -1714,6 +1718,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.valid_rx_ant = ANT_ABC,
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
+	.led_compensation = 51,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -1731,6 +1736,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
+	.led_compensation = 51,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 957205c..89b111a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -256,6 +256,7 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
+	.led_compensation = 51,
 };
 
 /*
@@ -279,6 +280,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
+	.led_compensation = 51,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -299,6 +301,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
+	.led_compensation = 51,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -319,6 +322,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
+	.led_compensation = 51,
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -339,6 +343,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
+	.led_compensation = 51,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index c04d2a2..dfeca62 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -211,6 +211,9 @@ struct iwl_mod_params {
  * @pa_type: used by 6000 series only to identify the type of Power Amplifier
  * @max_ll_items: max number of OTP blocks
  * @shadow_ram_support: shadow support for OTP memory
+ * @led_compensation: compensate on the led on/off time per HW according
+ *	to the deviation to achieve the desired led frequency.
+ *	The detail algorithm is described in iwl-led.c
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -252,6 +255,7 @@ struct iwl_cfg {
 	const u16 max_ll_items;
 	const bool shadow_ram_support;
 	const bool ht_greenfield_support;
+	u16 led_compensation;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 41addd1..f547233 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -78,6 +78,29 @@ static const struct {
 #define IWL_MAX_BLINK_TBL (ARRAY_SIZE(blink_tbl) - 1) /* exclude SOLID_ON */
 #define IWL_SOLID_BLINK_IDX (ARRAY_SIZE(blink_tbl) - 1)
 
+/*
+ * Adjust led blink rate to compensate on a MAC Clock difference on every HW
+ * Led blink rate analysis showed an average deviation of 0% on 3945,
+ * 5% on 4965 HW and 20% on 5000 series and up.
+ * Need to compensate on the led on/off time per HW according to the deviation
+ * to achieve the desired led frequency
+ * The calculation is: (100-averageDeviation)/100 * blinkTime
+ * For code efficiency the calculation will be:
+ *     compensation = (100 - averageDeviation) * 64 / 100
+ *     NewBlinkTime = (compensation * BlinkTime) / 64
+ */
+static inline u8 iwl_blink_compensation(struct iwl_priv *priv,
+				    u8 time, u16 compensation)
+{
+	if (!compensation) {
+		IWL_ERR(priv, "undefined blink compensation: "
+			"use pre-defined blinking time\n");
+		return time;
+	}
+
+	return (u8)((time * compensation) >> 6);
+}
+
 /*  [0-256] -> [0..8] FIXME: we need [0..10] */
 static inline int iwl_brightness_to_idx(enum led_brightness brightness)
 {
@@ -114,8 +137,14 @@ static int iwl_led_pattern(struct iwl_priv *priv, int led_id,
 
 	BUG_ON(idx > IWL_MAX_BLINK_TBL);
 
-	led_cmd.on = blink_tbl[idx].on_time;
-	led_cmd.off = blink_tbl[idx].off_time;
+	IWL_DEBUG_LED(priv, "Led blink time compensation= %u\n",
+			priv->cfg->led_compensation);
+	led_cmd.on =
+		iwl_blink_compensation(priv, blink_tbl[idx].on_time,
+					priv->cfg->led_compensation);
+	led_cmd.off =
+		iwl_blink_compensation(priv, blink_tbl[idx].off_time,
+					priv->cfg->led_compensation);
 
 	return iwl_send_led_cmd(priv, &led_cmd);
 }
-- 
1.5.6.3

