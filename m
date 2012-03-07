Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48759 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759705Ab2CGTGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:31 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 11/35] iwlwifi: make EEPROM enhanced TX power a bool
Date: Wed,  7 Mar 2012 09:52:20 -0800
Message-Id: <1331142764-5750-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200744_260237_CDF07734)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to carry around the function
pointer when a boolean indicating that the
EEPROM stores enhanced TX power information
is sufficient.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    1 -
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    2 +-
 5 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 2c03858..6931820 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -147,7 +147,7 @@ static struct iwl_lib_ops iwl2000_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REGULATORY_BAND_NO_HT40,
 		},
-		.update_enhanced_txpower = iwl_eeprom_enhanced_txpower,
+		.enhanced_txpower = true,
 	},
 	.temperature = iwlagn_temperature,
 };
@@ -165,7 +165,7 @@ static struct iwl_lib_ops iwl2030_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REGULATORY_BAND_NO_HT40,
 		},
-		.update_enhanced_txpower = iwl_eeprom_enhanced_txpower,
+		.enhanced_txpower = true,
 	},
 	.temperature = iwlagn_temperature,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 510a5c0..9fbab01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -243,7 +243,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.update_enhanced_txpower = iwl_eeprom_enhanced_txpower,
+		.enhanced_txpower = true,
 	},
 	.temperature = iwlagn_temperature,
 };
@@ -262,7 +262,7 @@ static struct iwl_lib_ops iwl6030_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.update_enhanced_txpower = iwl_eeprom_enhanced_txpower,
+		.enhanced_txpower = true,
 	},
 	.temperature = iwlagn_temperature,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index b56498b..6345ab0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -305,7 +305,6 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
 }
 
 /* eeprom */
-void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv);
 void iwl_eeprom_get_mac(const struct iwl_shared *shrd, u8 *mac);
 
 extern int iwl_alive_start(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index e2d8084..23cea42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -589,7 +589,7 @@ iwl_eeprom_enh_txp_read_element(struct iwl_priv *priv,
 #define TXP_CHECK_AND_PRINT(x) ((txp->flags & IWL_EEPROM_ENH_TXP_FL_##x) \
 			    ? # x " " : "")
 
-void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
+static void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
 {
 	struct iwl_shared *shrd = priv->shrd;
 	struct iwl_eeprom_enhanced_txpwr *txp_array, *txp;
@@ -1025,8 +1025,8 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	 * driver need to process addition information
 	 * to determine the max channel tx power limits
 	 */
-	if (cfg(priv)->lib->eeprom_ops.update_enhanced_txpower)
-		cfg(priv)->lib->eeprom_ops.update_enhanced_txpower(priv);
+	if (cfg(priv)->lib->eeprom_ops.enhanced_txpower)
+		iwl_eeprom_enhanced_txpower(priv);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 3b17056..e4a7583 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -302,7 +302,7 @@ extern const u8 iwl_eeprom_band_1[14];
 
 struct iwl_eeprom_ops {
 	const u32 regulatory_bands[7];
-	void (*update_enhanced_txpower) (struct iwl_priv *priv);
+	bool enhanced_txpower;
 };
 
 
-- 
1.7.0.4

