Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35982 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751224AbdI2MDZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 08:03:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 15:03:04 +0300
Message-Id: <20170929120305.20551-5-luca@coelho.fi> (sfid-20170929_140328_218383_F66C7C38)
In-Reply-To: <20170929120305.20551-1-luca@coelho.fi>
References: <20170929120305.20551-1-luca@coelho.fi>
Subject: [PATCH 4/5] iwlwifi: nvm-parse: unify channel flags printing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The current channel flags printing is very strange and messy,
in LAR we sometimes print the channel number and sometimes the
frequency, in both we print a calculated value (whether ad-hoc
is supported or not) etc.

Unify all this to
 * print the channel number, not the frequency
 * remove the band print (2.4/5.2 GHz, it's obvious)
 * remove the calculated Ad-Hoc print

Doing all of this also gets the length of the string to a max
of 101 characters, which is below the max of 110 for tracing,
and thus avoids the warning that came up on certain channels
with certain flag combinations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 98 +++++++++-------------
 1 file changed, 39 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 3014beef4873..35638404c24e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -206,8 +206,36 @@ enum iwl_nvm_channel_flags {
 	NVM_CHANNEL_DC_HIGH		= BIT(12),
 };
 
+static inline void iwl_nvm_print_channel_flags(struct device *dev, u32 level,
+					       int chan, u16 flags)
+{
 #define CHECK_AND_PRINT_I(x)	\
-	((ch_flags & NVM_CHANNEL_##x) ? # x " " : "")
+	((flags & NVM_CHANNEL_##x) ? " " #x : "")
+
+	if (!(flags & NVM_CHANNEL_VALID)) {
+		IWL_DEBUG_DEV(dev, level, "Ch. %d: 0x%x: No traffic\n",
+			      chan, flags);
+		return;
+	}
+
+	/* Note: already can print up to 101 characters, 110 is the limit! */
+	IWL_DEBUG_DEV(dev, level,
+		      "Ch. %d: 0x%x:%s%s%s%s%s%s%s%s%s%s%s%s\n",
+		      chan, flags,
+		      CHECK_AND_PRINT_I(VALID),
+		      CHECK_AND_PRINT_I(IBSS),
+		      CHECK_AND_PRINT_I(ACTIVE),
+		      CHECK_AND_PRINT_I(RADAR),
+		      CHECK_AND_PRINT_I(INDOOR_ONLY),
+		      CHECK_AND_PRINT_I(GO_CONCURRENT),
+		      CHECK_AND_PRINT_I(UNIFORM),
+		      CHECK_AND_PRINT_I(20MHZ),
+		      CHECK_AND_PRINT_I(40MHZ),
+		      CHECK_AND_PRINT_I(80MHZ),
+		      CHECK_AND_PRINT_I(160MHZ),
+		      CHECK_AND_PRINT_I(DC_HIGH));
+#undef CHECK_AND_PRINT_I
+}
 
 static u32 iwl_get_channel_flags(u8 ch_num, int ch_idx, bool is_5ghz,
 				 u16 nvm_flags, const struct iwl_cfg *cfg)
@@ -302,12 +330,8 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 			 * supported, hence we still want to add them to
 			 * the list of supported channels to cfg80211.
 			 */
-			IWL_DEBUG_EEPROM(dev,
-					 "Ch. %d Flags %x [%sGHz] - No traffic\n",
-					 nvm_chan[ch_idx],
-					 ch_flags,
-					 (ch_idx >= num_2ghz_channels) ?
-					 "5.2" : "2.4");
+			iwl_nvm_print_channel_flags(dev, IWL_DL_EEPROM,
+						    nvm_chan[ch_idx], ch_flags);
 			continue;
 		}
 
@@ -337,27 +361,10 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 		else
 			channel->flags = 0;
 
-		IWL_DEBUG_EEPROM(dev,
-				 "Ch. %d [%sGHz] flags 0x%x %s%s%s%s%s%s%s%s%s%s%s%s(%ddBm): Ad-Hoc %ssupported\n",
-				 channel->hw_value,
-				 is_5ghz ? "5.2" : "2.4",
-				 ch_flags,
-				 CHECK_AND_PRINT_I(VALID),
-				 CHECK_AND_PRINT_I(IBSS),
-				 CHECK_AND_PRINT_I(ACTIVE),
-				 CHECK_AND_PRINT_I(RADAR),
-				 CHECK_AND_PRINT_I(INDOOR_ONLY),
-				 CHECK_AND_PRINT_I(GO_CONCURRENT),
-				 CHECK_AND_PRINT_I(UNIFORM),
-				 CHECK_AND_PRINT_I(20MHZ),
-				 CHECK_AND_PRINT_I(40MHZ),
-				 CHECK_AND_PRINT_I(80MHZ),
-				 CHECK_AND_PRINT_I(160MHZ),
-				 CHECK_AND_PRINT_I(DC_HIGH),
-				 channel->max_power,
-				 ((ch_flags & NVM_CHANNEL_IBSS) &&
-				  !(ch_flags & NVM_CHANNEL_RADAR))
-					? "" : "not ");
+		iwl_nvm_print_channel_flags(dev, IWL_DL_EEPROM,
+					    channel->hw_value, ch_flags);
+		IWL_DEBUG_EEPROM(dev, "Ch. %d: %ddBm\n",
+				 channel->hw_value, channel->max_power);
 	}
 
 	return n_channels;
@@ -873,12 +880,8 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		new_rule = false;
 
 		if (!(ch_flags & NVM_CHANNEL_VALID)) {
-			IWL_DEBUG_DEV(dev, IWL_DL_LAR,
-				      "Ch. %d Flags %x [%sGHz] - No traffic\n",
-				      nvm_chan[ch_idx],
-				      ch_flags,
-				      (ch_idx >= NUM_2GHZ_CHANNELS) ?
-				      "5.2" : "2.4");
+			iwl_nvm_print_channel_flags(dev, IWL_DL_LAR,
+						    nvm_chan[ch_idx], ch_flags);
 			continue;
 		}
 
@@ -914,31 +917,8 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		prev_center_freq = center_freq;
 		prev_reg_rule_flags = reg_rule_flags;
 
-		IWL_DEBUG_DEV(dev, IWL_DL_LAR,
-			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s%s%s%s(0x%02x)\n",
-			      center_freq,
-			      band == NL80211_BAND_5GHZ ? "5.2" : "2.4",
-			      CHECK_AND_PRINT_I(VALID),
-			      CHECK_AND_PRINT_I(IBSS),
-			      CHECK_AND_PRINT_I(ACTIVE),
-			      CHECK_AND_PRINT_I(RADAR),
-			      CHECK_AND_PRINT_I(INDOOR_ONLY),
-			      CHECK_AND_PRINT_I(GO_CONCURRENT),
-			      CHECK_AND_PRINT_I(UNIFORM),
-			      CHECK_AND_PRINT_I(20MHZ),
-			      CHECK_AND_PRINT_I(40MHZ),
-			      CHECK_AND_PRINT_I(80MHZ),
-			      CHECK_AND_PRINT_I(160MHZ),
-			      CHECK_AND_PRINT_I(DC_HIGH),
-			      ch_flags);
-		IWL_DEBUG_DEV(dev, IWL_DL_LAR,
-			      "Ch. %d [%sGHz] reg_flags 0x%x: %s\n",
-			      center_freq,
-			      band == NL80211_BAND_5GHZ ? "5.2" : "2.4",
-			      reg_rule_flags,
-			      ((ch_flags & NVM_CHANNEL_ACTIVE) &&
-			       !(ch_flags & NVM_CHANNEL_RADAR))
-					 ? "Ad-Hoc" : "");
+		iwl_nvm_print_channel_flags(dev, IWL_DL_LAR,
+					    nvm_chan[ch_idx], ch_flags);
 	}
 
 	regd->n_reg_rules = valid_rules;
-- 
2.14.1
