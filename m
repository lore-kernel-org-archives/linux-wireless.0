Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42591 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbYFLBuA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:50:00 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 24/29] iwlwifi: retfactor get_temperature functions
Date: Thu, 12 Jun 2008 09:47:14 +0800
Message-Id: <1213235239-2954-25-git-send-email-yi.zhu@intel.com> (sfid-20080612_041914_165154_619AE3D0)
In-Reply-To: <1213235239-2954-24-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-17-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-18-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-19-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-20-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-21-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-22-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-23-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-24-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch renames iwl4965_get_tempearture to iwl4965_hw_get_temperature
and replaces usage of original iwl4965_hw_get_temperature by
direct access to priv->temperature.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   24 +++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 4 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index aeb29b9..6e6038f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -47,6 +47,7 @@
 #include "iwl-sta.h"
 
 static int iwl4965_send_tx_power(struct iwl_priv *priv);
+static int iwl4965_hw_get_temperature(const struct iwl_priv *priv);
 
 /* module parameters */
 static struct iwl_mod_params iwl4965_mod_params = {
@@ -283,7 +284,7 @@ static void iwl4965_init_alive_start(struct iwl_priv *priv)
 	}
 
 	/* Calculate temperature */
-	priv->temperature = iwl4965_get_temperature(priv);
+	priv->temperature = iwl4965_hw_get_temperature(priv);
 
 	/* Send pointers to protocol/runtime uCode image ... init code will
 	 * load and launch runtime uCode, which will send us another "Alive"
@@ -1691,11 +1692,6 @@ static int iwl4965_shared_mem_rx_idx(struct iwl_priv *priv)
 	return le32_to_cpu(s->rb_closed) & 0xFFF;
 }
 
-int iwl4965_hw_get_temperature(struct iwl_priv *priv)
-{
-	return priv->temperature;
-}
-
 unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 			  struct iwl_frame *frame, u8 rate)
 {
@@ -1793,12 +1789,12 @@ static s32 sign_extend(u32 oper, int index)
 }
 
 /**
- * iwl4965_get_temperature - return the calibrated temperature (in Kelvin)
+ * iwl4965_hw_get_temperature - return the calibrated temperature (in Kelvin)
  * @statistics: Provides the temperature reading from the uCode
  *
  * A return of <0 indicates bogus data in the statistics
  */
-int iwl4965_get_temperature(const struct iwl_priv *priv)
+static int iwl4965_hw_get_temperature(const struct iwl_priv *priv)
 {
 	s32 temperature;
 	s32 vt;
@@ -1833,8 +1829,7 @@ int iwl4965_get_temperature(const struct iwl_priv *priv)
 		vt = sign_extend(
 			le32_to_cpu(priv->statistics.general.temperature), 23);
 
-	IWL_DEBUG_TEMP("Calib values R[1-3]: %d %d %d R4: %d\n",
-		       R1, R2, R3, vt);
+	IWL_DEBUG_TEMP("Calib values R[1-3]: %d %d %d R4: %d\n", R1, R2, R3, vt);
 
 	if (R3 == R1) {
 		IWL_ERROR("Calibration conflict R1 == R3\n");
@@ -1845,11 +1840,10 @@ int iwl4965_get_temperature(const struct iwl_priv *priv)
 	 * Add offset to center the adjustment around 0 degrees Centigrade. */
 	temperature = TEMPERATURE_CALIB_A_VAL * (vt - R2);
 	temperature /= (R3 - R1);
-	temperature = (temperature * 97) / 100 +
-	    TEMPERATURE_CALIB_KELVIN_OFFSET;
+	temperature = (temperature * 97) / 100 + TEMPERATURE_CALIB_KELVIN_OFFSET;
 
-	IWL_DEBUG_TEMP("Calibrated temperature: %dK, %dC\n", temperature,
-	    KELVIN_TO_CELSIUS(temperature));
+	IWL_DEBUG_TEMP("Calibrated temperature: %dK, %dC\n",
+			temperature, KELVIN_TO_CELSIUS(temperature));
 
 	return temperature;
 }
@@ -1977,7 +1971,7 @@ void iwl4965_hw_rx_statistics(struct iwl_priv *priv,
 	if (!change)
 		return;
 
-	temp = iwl4965_get_temperature(priv);
+	temp = iwl4965_hw_get_temperature(priv);
 	if (temp < 0)
 		return;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 59dd342..054ab7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -359,7 +359,6 @@ static inline int iwl_is_ready_rf(struct iwl_priv *priv)
 	return iwl_is_ready(priv);
 }
 
-
 enum iwlcore_card_notify {
 	IWLCORE_INIT_EVT = 0,
 	IWLCORE_START_EVT = 1,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ef74159..7001854 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -643,7 +643,6 @@ extern void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv);
 extern int iwl4965_hw_set_hw_params(struct iwl_priv *priv);
 extern int iwl_rxq_stop(struct iwl_priv *priv);
 extern void iwl_txq_ctx_stop(struct iwl_priv *priv);
-extern int iwl4965_hw_get_temperature(struct iwl_priv *priv);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl_frame *frame, u8 rate);
 extern void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 3717f99..14d4432 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3867,7 +3867,7 @@ static ssize_t show_temperature(struct device *d,
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
-	return sprintf(buf, "%d\n", iwl4965_hw_get_temperature(priv));
+	return sprintf(buf, "%d\n", priv->temperature);
 }
 
 static DEVICE_ATTR(temperature, S_IRUGO, show_temperature, NULL);
-- 
1.5.3.6

