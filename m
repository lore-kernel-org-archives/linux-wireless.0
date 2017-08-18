Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44658 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751446AbdHRPw5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:52:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:16 +0300
Message-Id: <20170818154922.2904-19-luca@coelho.fi> (sfid-20170818_175300_081315_A98F4A49)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 18/24] iwlwifi: update channel flags parser
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

There are some new flags in the channel flags that we don't know
about.  Also, the "WIDE" flag is very confusing, because it actually
means 20MHz bandwidth, which is not very wide.

Add the new flags and rename the confusing one.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 51 +++++++++++++---------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 5c08f4d40f6a..1172e4572a82 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -183,22 +183,26 @@ static struct ieee80211_rate iwl_cfg80211_rates[] = {
  * @NVM_CHANNEL_INDOOR_ONLY: only indoor use is allowed
  * @NVM_CHANNEL_GO_CONCURRENT: GO operation is allowed when connected to BSS
  *	on same channel on 2.4 or same UNII band on 5.2
- * @NVM_CHANNEL_WIDE: 20 MHz channel okay (?)
- * @NVM_CHANNEL_40MHZ: 40 MHz channel okay (?)
- * @NVM_CHANNEL_80MHZ: 80 MHz channel okay (?)
- * @NVM_CHANNEL_160MHZ: 160 MHz channel okay (?)
+ * @NVM_CHANNEL_UNIFORM: uniform spreading required
+ * @NVM_CHANNEL_20MHZ: 20 MHz channel okay
+ * @NVM_CHANNEL_40MHZ: 40 MHz channel okay
+ * @NVM_CHANNEL_80MHZ: 80 MHz channel okay
+ * @NVM_CHANNEL_160MHZ: 160 MHz channel okay
+ * @NVM_CHANNEL_DC_HIGH: DC HIGH required/allowed (?)
  */
 enum iwl_nvm_channel_flags {
-	NVM_CHANNEL_VALID = BIT(0),
-	NVM_CHANNEL_IBSS = BIT(1),
-	NVM_CHANNEL_ACTIVE = BIT(3),
-	NVM_CHANNEL_RADAR = BIT(4),
-	NVM_CHANNEL_INDOOR_ONLY = BIT(5),
-	NVM_CHANNEL_GO_CONCURRENT = BIT(6),
-	NVM_CHANNEL_WIDE = BIT(8),
-	NVM_CHANNEL_40MHZ = BIT(9),
-	NVM_CHANNEL_80MHZ = BIT(10),
-	NVM_CHANNEL_160MHZ = BIT(11),
+	NVM_CHANNEL_VALID		= BIT(0),
+	NVM_CHANNEL_IBSS		= BIT(1),
+	NVM_CHANNEL_ACTIVE		= BIT(3),
+	NVM_CHANNEL_RADAR		= BIT(4),
+	NVM_CHANNEL_INDOOR_ONLY		= BIT(5),
+	NVM_CHANNEL_GO_CONCURRENT	= BIT(6),
+	NVM_CHANNEL_UNIFORM		= BIT(7),
+	NVM_CHANNEL_20MHZ		= BIT(8),
+	NVM_CHANNEL_40MHZ		= BIT(9),
+	NVM_CHANNEL_80MHZ		= BIT(10),
+	NVM_CHANNEL_160MHZ		= BIT(11),
+	NVM_CHANNEL_DC_HIGH		= BIT(12),
 };
 
 #define CHECK_AND_PRINT_I(x)	\
@@ -327,7 +331,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 			channel->flags = 0;
 
 		IWL_DEBUG_EEPROM(dev,
-				 "Ch. %d [%sGHz] flags 0x%x %s%s%s%s%s%s%s%s%s%s(%ddBm): Ad-Hoc %ssupported\n",
+				 "Ch. %d [%sGHz] flags 0x%x %s%s%s%s%s%s%s%s%s%s%s%s(%ddBm): Ad-Hoc %ssupported\n",
 				 channel->hw_value,
 				 is_5ghz ? "5.2" : "2.4",
 				 ch_flags,
@@ -337,10 +341,12 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 				 CHECK_AND_PRINT_I(RADAR),
 				 CHECK_AND_PRINT_I(INDOOR_ONLY),
 				 CHECK_AND_PRINT_I(GO_CONCURRENT),
-				 CHECK_AND_PRINT_I(WIDE),
+				 CHECK_AND_PRINT_I(UNIFORM),
+				 CHECK_AND_PRINT_I(20MHZ),
 				 CHECK_AND_PRINT_I(40MHZ),
 				 CHECK_AND_PRINT_I(80MHZ),
 				 CHECK_AND_PRINT_I(160MHZ),
+				 CHECK_AND_PRINT_I(DC_HIGH),
 				 channel->max_power,
 				 ((ch_flags & NVM_CHANNEL_IBSS) &&
 				  !(ch_flags & NVM_CHANNEL_RADAR))
@@ -865,22 +871,25 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		prev_center_freq = center_freq;
 
 		IWL_DEBUG_DEV(dev, IWL_DL_LAR,
-			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s(0x%02x): Ad-Hoc %ssupported\n",
+			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s%s%s%s(0x%02x): %s\n",
 			      center_freq,
 			      band == NL80211_BAND_5GHZ ? "5.2" : "2.4",
 			      CHECK_AND_PRINT_I(VALID),
+			      CHECK_AND_PRINT_I(IBSS),
 			      CHECK_AND_PRINT_I(ACTIVE),
 			      CHECK_AND_PRINT_I(RADAR),
-			      CHECK_AND_PRINT_I(WIDE),
+			      CHECK_AND_PRINT_I(INDOOR_ONLY),
+			      CHECK_AND_PRINT_I(GO_CONCURRENT),
+			      CHECK_AND_PRINT_I(UNIFORM),
+			      CHECK_AND_PRINT_I(20MHZ),
 			      CHECK_AND_PRINT_I(40MHZ),
 			      CHECK_AND_PRINT_I(80MHZ),
 			      CHECK_AND_PRINT_I(160MHZ),
-			      CHECK_AND_PRINT_I(INDOOR_ONLY),
-			      CHECK_AND_PRINT_I(GO_CONCURRENT),
+			      CHECK_AND_PRINT_I(DC_HIGH),
 			      ch_flags,
 			      ((ch_flags & NVM_CHANNEL_ACTIVE) &&
 			       !(ch_flags & NVM_CHANNEL_RADAR))
-					 ? "" : "not ");
+					 ? "Ad-Hoc" : "");
 	}
 
 	regd->n_reg_rules = valid_rules;
-- 
2.14.1
