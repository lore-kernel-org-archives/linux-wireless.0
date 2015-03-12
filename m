Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26343 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbbCLNF3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:29 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/49] iwlwifi: change last 5ghz channel to 165 & add support for 8000 family
Date: Thu, 12 Mar 2015 15:03:56 +0200
Message-Id: <1426165474-25586-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140533_829479_FA9945D0)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Fix the last 5ghz channel to 165 instead of 161
Add support for 8000 family, until channel 181.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 5959329..727e8a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -146,7 +146,8 @@ static const u8 iwl_nvm_channels_family_8000[] = {
 #define NUM_2GHZ_CHANNELS_FAMILY_8000	14
 #define FIRST_2GHZ_HT_MINUS		5
 #define LAST_2GHZ_HT_PLUS		9
-#define LAST_5GHZ_HT			161
+#define LAST_5GHZ_HT			165
+#define LAST_5GHZ_HT_FAMILY_8000	181
 
 /* rate data (static) */
 static struct ieee80211_rate iwl_cfg80211_rates[] = {
@@ -202,16 +203,20 @@ enum iwl_nvm_channel_flags {
 	((ch_flags & NVM_CHANNEL_##x) ? # x " " : "")
 
 static u32 iwl_get_channel_flags(u8 ch_num, int ch_idx, bool is_5ghz,
-				 u16 nvm_flags)
+				 u16 nvm_flags, const struct iwl_cfg *cfg)
 {
 	u32 flags = IEEE80211_CHAN_NO_HT40;
+	u32 last_5ghz_ht = LAST_5GHZ_HT;
+
+	if (cfg->device_family == IWL_DEVICE_FAMILY_8000)
+		last_5ghz_ht = LAST_5GHZ_HT_FAMILY_8000;
 
 	if (!is_5ghz && (nvm_flags & NVM_CHANNEL_40MHZ)) {
 		if (ch_num <= LAST_2GHZ_HT_PLUS)
 			flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
 		if (ch_num >= FIRST_2GHZ_HT_MINUS)
 			flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
-	} else if (ch_num <= LAST_5GHZ_HT && (nvm_flags & NVM_CHANNEL_40MHZ)) {
+	} else if (ch_num <= last_5ghz_ht && (nvm_flags & NVM_CHANNEL_40MHZ)) {
 		if ((ch_idx - NUM_2GHZ_CHANNELS) % 2 == 0)
 			flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
 		else
@@ -312,7 +317,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 		if (!lar_supported)
 			channel->flags = iwl_get_channel_flags(nvm_chan[ch_idx],
 							       ch_idx, is_5ghz,
-							       ch_flags);
+							       ch_flags, cfg);
 		else
 			channel->flags = 0;
 
@@ -666,9 +671,14 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 IWL_EXPORT_SYMBOL(iwl_parse_nvm_data);
 
 static u32 iwl_nvm_get_regdom_bw_flags(const u8 *nvm_chan,
-				       int ch_idx, u16 nvm_flags)
+				       int ch_idx, u16 nvm_flags,
+				       const struct iwl_cfg *cfg)
 {
 	u32 flags = NL80211_RRF_NO_HT40;
+	u32 last_5ghz_ht = LAST_5GHZ_HT;
+
+	if (cfg->device_family == IWL_DEVICE_FAMILY_8000)
+		last_5ghz_ht = LAST_5GHZ_HT_FAMILY_8000;
 
 	if (ch_idx < NUM_2GHZ_CHANNELS &&
 	    (nvm_flags & NVM_CHANNEL_40MHZ)) {
@@ -676,7 +686,7 @@ static u32 iwl_nvm_get_regdom_bw_flags(const u8 *nvm_chan,
 			flags &= ~NL80211_RRF_NO_HT40PLUS;
 		if (nvm_chan[ch_idx] >= FIRST_2GHZ_HT_MINUS)
 			flags &= ~NL80211_RRF_NO_HT40MINUS;
-	} else if (nvm_chan[ch_idx] <= LAST_5GHZ_HT &&
+	} else if (nvm_chan[ch_idx] <= last_5ghz_ht &&
 		   (nvm_flags & NVM_CHANNEL_40MHZ)) {
 		if ((ch_idx - NUM_2GHZ_CHANNELS) % 2 == 0)
 			flags &= ~NL80211_RRF_NO_HT40PLUS;
@@ -777,7 +787,7 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		rule->power_rule.max_eirp = DBM_TO_MBM(20);
 
 		rule->flags = iwl_nvm_get_regdom_bw_flags(nvm_chan, ch_idx,
-							  ch_flags);
+							  ch_flags, cfg);
 
 		/* rely on auto-calculation to merge BW of contiguous chans */
 		rule->flags |= NL80211_RRF_AUTO_BW;
-- 
1.9.1

