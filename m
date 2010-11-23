Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47771 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453Ab0KWTEa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:04:30 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/5] iwlwifi: advance power management support
Date: Tue, 23 Nov 2010 10:58:56 -0800
Message-Id: <1290538736-10816-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290538736-10816-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290538736-10816-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 6000g2b and up, adding advance power management support
for better power consumption

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    8 +++
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-power.c    |   68 +++++++++++++++++++++++++--
 4 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f650282..93e3fe9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -621,6 +621,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
+	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -641,6 +642,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
+	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -662,6 +664,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
+	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -682,6 +685,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
+	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -703,6 +707,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
+	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -723,6 +728,7 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
+	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -862,6 +868,7 @@ struct iwl_cfg iwl130_bgn_cfg = {
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
+	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
@@ -881,6 +888,7 @@ struct iwl_cfg iwl130_bg_cfg = {
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
+	.adv_pm = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index f9e7fa4..c9448cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2668,6 +2668,8 @@ struct iwl_spectrum_notification {
 #define IWL_POWER_VEC_SIZE 5
 
 #define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	cpu_to_le16(BIT(0))
+#define IWL_POWER_POWER_SAVE_ENA_MSK		cpu_to_le16(BIT(0))
+#define IWL_POWER_POWER_MANAGEMENT_ENA_MSK	cpu_to_le16(BIT(1))
 #define IWL_POWER_SLEEP_OVER_DTIM_MSK		cpu_to_le16(BIT(2))
 #define IWL_POWER_PCI_PM_MSK			cpu_to_le16(BIT(3))
 #define IWL_POWER_FAST_PD			cpu_to_le16(BIT(4))
@@ -2675,7 +2677,7 @@ struct iwl_spectrum_notification {
 #define IWL_POWER_SHADOW_REG_ENA		cpu_to_le16(BIT(6))
 #define IWL_POWER_CT_KILL_SET			cpu_to_le16(BIT(7))
 #define IWL_POWER_BT_SCO_ENA			cpu_to_le16(BIT(8))
-#define IWL_POWER_ADVANCE_PM_ENA		cpu_to_le16(BIT(9))
+#define IWL_POWER_ADVANCE_PM_ENA_MSK		cpu_to_le16(BIT(9))
 
 struct iwl3945_powertable_cmd {
 	__le16 flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3f7bd40..808be73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -366,6 +366,7 @@ struct iwl_ht_params {
  * @need_temp_offset_calib: need to perform temperature offset calibration
  * @scan_antennas: available antenna for scan operation
  * @led_mode: 0=blinking, 1=On(RF On)/Off(RF Off)
+ * @adv_pm: advance power management
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -413,6 +414,7 @@ struct iwl_cfg {
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
 	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
 	enum iwl_led_mode led_mode;
+	const bool adv_pm;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 21c5e6a..1eec18d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -75,6 +75,10 @@ struct iwl_power_vec_entry {
 
 #define NOSLP cpu_to_le16(0), 0, 0
 #define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK, 0, 0
+#define ASLP (IWL_POWER_POWER_SAVE_ENA_MSK |	\
+		IWL_POWER_POWER_MANAGEMENT_ENA_MSK | \
+		IWL_POWER_ADVANCE_PM_ENA_MSK)
+#define ASLP_TOUT(T) cpu_to_le32(T)
 #define TU_TO_USEC 1024
 #define SLP_TOUT(T) cpu_to_le32((T) * TU_TO_USEC)
 #define SLP_VEC(X0, X1, X2, X3, X4) {cpu_to_le32(X0), \
@@ -114,6 +118,52 @@ static const struct iwl_power_vec_entry range_2[IWL_POWER_NUM] = {
 	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
 };
 
+/* advance power management */
+/* DTIM 0 - 2 */
+static const struct iwl_power_vec_entry apm_range_0[IWL_POWER_NUM] = {
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 4, 6, 0xFF), 0}, 0},
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 4, 6, 0xFF), 0}, 0},
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 4, 6, 0xFF), 0}, 0},
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 4, 6, 0xFF), 0}, 0},
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 6, 8, 0xFF), ASLP_TOUT(2)}, 2}
+};
+
+
+/* for DTIM period IWL_DTIM_RANGE_0_MAX + 1 through IWL_DTIM_RANGE_1_MAX */
+/* DTIM 3 - 10 */
+static const struct iwl_power_vec_entry apm_range_1[IWL_POWER_NUM] = {
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 4, 6, 0xFF), 0}, 0},
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 4, 6, 0xFF), 0}, 0},
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 4, 6, 0xFF), 0}, 0},
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 4, 6, 0xFF), 0}, 0},
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 6, 8, 0xFF), 0}, 2}
+};
+
+/* for DTIM period > IWL_DTIM_RANGE_1_MAX */
+/* DTIM 11 - */
+static const struct iwl_power_vec_entry apm_range_2[IWL_POWER_NUM] = {
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 4, 6, 0xFF), 0}, 0},
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 4, 6, 0xFF), 0}, 0},
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 4, 6, 0xFF), 0}, 0},
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 4, 6, 0xFF), 0}, 0},
+	{{ASLP, 0, 0, ASLP_TOUT(50), ASLP_TOUT(50),
+		SLP_VEC(1, 2, 6, 8, 0xFF), ASLP_TOUT(2)}, 2}
+};
+
 static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 				 struct iwl_powertable_cmd *cmd,
 				 enum iwl_power_level lvl, int period)
@@ -124,11 +174,19 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 	u8 skip;
 	u32 slp_itrvl;
 
-	table = range_2;
-	if (period <= IWL_DTIM_RANGE_1_MAX)
-		table = range_1;
-	if (period <= IWL_DTIM_RANGE_0_MAX)
-		table = range_0;
+	if (priv->cfg->adv_pm) {
+		table = apm_range_2;
+		if (period <= IWL_DTIM_RANGE_1_MAX)
+			table = apm_range_1;
+		if (period <= IWL_DTIM_RANGE_0_MAX)
+			table = apm_range_0;
+	} else {
+		table = range_2;
+		if (period <= IWL_DTIM_RANGE_1_MAX)
+			table = range_1;
+		if (period <= IWL_DTIM_RANGE_0_MAX)
+			table = range_0;
+	}
 
 	BUG_ON(lvl < 0 || lvl >= IWL_POWER_NUM);
 
-- 
1.7.0.4

