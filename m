Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41512 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751496AbdHAJkr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:40:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  1 Aug 2017 12:40:34 +0300
Message-Id: <20170801094039.22349-4-luca@coelho.fi> (sfid-20170801_114106_367036_C8289DAB)
In-Reply-To: <20170801094039.22349-1-luca@coelho.fi>
References: <20170801094039.22349-1-luca@coelho.fi>
Subject: [PATCH 3/8] iwlwifi: split the regulatory rules when the bandwidth flags require it
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we create a regulatory domain out of an MCC
notification, we need to make sure that all the channels
in the rule have the exact same properties.
The current code mixes channel 36 and 40 although 36 can be
a control channel with HT40+ (36, 40) whereas 40 can't be
a control channel with HT40+ since  (40, 44) is invalid.

Because of that, cfg80211 would allow to connect in 40MHz
to APs that are configured to channel 40 HT40+ and that made
our firmware assert.

Fix this by checking the bandwidth flags before taking the
decision if the rule should be split.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=195299 partly.

Fixes: af45a9003f1f ("iwlwifi: create regdomain from mcc_update_cmd response")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 5c08f4d40f6a..3ee6767392b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -785,7 +785,8 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		       int num_of_ch, __le32 *channels, u16 fw_mcc)
 {
 	int ch_idx;
-	u16 ch_flags, prev_ch_flags = 0;
+	u16 ch_flags;
+	u32 reg_rule_flags, prev_reg_rule_flags = 0;
 	const u8 *nvm_chan = cfg->ext_nvm ?
 			     iwl_ext_nvm_channels : iwl_nvm_channels;
 	struct ieee80211_regdomain *regd;
@@ -834,8 +835,11 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 			continue;
 		}
 
+		reg_rule_flags = iwl_nvm_get_regdom_bw_flags(nvm_chan, ch_idx,
+							     ch_flags, cfg);
+
 		/* we can't continue the same rule */
-		if (ch_idx == 0 || prev_ch_flags != ch_flags ||
+		if (ch_idx == 0 || prev_reg_rule_flags != reg_rule_flags ||
 		    center_freq - prev_center_freq > 20) {
 			valid_rules++;
 			new_rule = true;
@@ -854,18 +858,17 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		rule->power_rule.max_eirp =
 			DBM_TO_MBM(IWL_DEFAULT_MAX_TX_POWER);
 
-		rule->flags = iwl_nvm_get_regdom_bw_flags(nvm_chan, ch_idx,
-							  ch_flags, cfg);
+		rule->flags = reg_rule_flags;
 
 		/* rely on auto-calculation to merge BW of contiguous chans */
 		rule->flags |= NL80211_RRF_AUTO_BW;
 		rule->freq_range.max_bandwidth_khz = 0;
 
-		prev_ch_flags = ch_flags;
 		prev_center_freq = center_freq;
+		prev_reg_rule_flags = reg_rule_flags;
 
 		IWL_DEBUG_DEV(dev, IWL_DL_LAR,
-			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s(0x%02x): Ad-Hoc %ssupported\n",
+			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s(0x%02x) reg_flags 0x%x: %s\n",
 			      center_freq,
 			      band == NL80211_BAND_5GHZ ? "5.2" : "2.4",
 			      CHECK_AND_PRINT_I(VALID),
@@ -877,10 +880,10 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 			      CHECK_AND_PRINT_I(160MHZ),
 			      CHECK_AND_PRINT_I(INDOOR_ONLY),
 			      CHECK_AND_PRINT_I(GO_CONCURRENT),
-			      ch_flags,
+			      ch_flags, reg_rule_flags,
 			      ((ch_flags & NVM_CHANNEL_ACTIVE) &&
 			       !(ch_flags & NVM_CHANNEL_RADAR))
-					 ? "" : "not ");
+					 ? "Ad-Hoc" : "");
 	}
 
 	regd->n_reg_rules = valid_rules;
-- 
2.13.2
