Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1GHQUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/21] iwlagn: remove double level temperature indirect call
Date: Fri,  8 Jul 2011 08:46:20 -0700
Message-Id: <1310139989-27661-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182101_466074_4F77260A)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to do double level indirect call after driver split
no functional changes

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    4 +---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    4 +---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-6000.c |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-core.h |    6 +-----
 drivers/net/wireless/iwlwifi/iwl-rx.c   |    4 ++--
 6 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index a558df9..7795855 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -183,9 +183,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 			EEPROM_REGULATORY_BAND_NO_HT40,
 		},
 	},
-	.temp_ops = {
-		.temperature = iwlagn_temperature,
-	 },
+	.temperature = iwlagn_temperature,
 };
 
 static const struct iwl_ops iwl1000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 2855994..b2b054f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -184,9 +184,7 @@ static struct iwl_lib_ops iwl2000_lib = {
 		},
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
-	.temp_ops = {
-		.temperature = iwlagn_temperature,
-	},
+	.temperature = iwlagn_temperature,
 };
 
 static const struct iwl_ops iwl2000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 55972cf..30c2df6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -336,9 +336,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
 	},
-	.temp_ops = {
-		.temperature = iwlagn_temperature,
-	 },
+	.temperature = iwlagn_temperature,
 };
 
 static struct iwl_lib_ops iwl5150_lib = {
@@ -359,9 +357,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
 	},
-	.temp_ops = {
-		.temperature = iwl5150_temperature,
-	 },
+	.temperature = iwl5150_temperature,
 };
 
 static const struct iwl_ops iwl5000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 17dc337..57f3169 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -277,9 +277,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 		},
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
-	.temp_ops = {
-		.temperature = iwlagn_temperature,
-	 },
+	.temperature = iwlagn_temperature,
 };
 
 static struct iwl_lib_ops iwl6030_lib = {
@@ -302,9 +300,7 @@ static struct iwl_lib_ops iwl6030_lib = {
 		},
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
-	.temp_ops = {
-		.temperature = iwlagn_temperature,
-	 },
+	.temperature = iwlagn_temperature,
 };
 
 static struct iwl_nic_ops iwl6050_nic_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 47cfbb9..2e3ea55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -96,10 +96,6 @@ struct iwl_hcmd_utils_ops {
 	int (*request_scan)(struct iwl_priv *priv, struct ieee80211_vif *vif);
 };
 
-struct iwl_temp_ops {
-	void (*temperature)(struct iwl_priv *priv);
-};
-
 struct iwl_lib_ops {
 	/* set hw dependent parameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
@@ -120,7 +116,7 @@ struct iwl_lib_ops {
 	struct iwl_eeprom_ops eeprom_ops;
 
 	/* temperature */
-	struct iwl_temp_ops temp_ops;
+	void (*temperature)(struct iwl_priv *priv);
 };
 
 /* NIC specific ops */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 87148bb..1690b49 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -624,8 +624,8 @@ static void iwl_rx_statistics(struct iwl_priv *priv,
 		iwl_rx_calc_noise(priv);
 		queue_work(priv->workqueue, &priv->run_time_calib_work);
 	}
-	if (priv->cfg->ops->lib->temp_ops.temperature && change)
-		priv->cfg->ops->lib->temp_ops.temperature(priv);
+	if (priv->cfg->ops->lib->temperature && change)
+		priv->cfg->ops->lib->temperature(priv);
 }
 
 static void iwl_rx_reply_statistics(struct iwl_priv *priv,
-- 
1.7.0.4

