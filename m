Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:6667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbbCLNEu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:04:50 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/49] iwlwifi: create regdomain from mcc_update_cmd response
Date: Thu, 12 Mar 2015 15:03:50 +0200
Message-Id: <1426165474-25586-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140454_222144_47A3270E)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Parse the NVM channel data and create a regulatory domain with a rule
for every 20Mhz channel. Use the AUTO_BW flag so the regulatory core
can unify single-channel rules into ranges.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 153 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h |  14 +++
 2 files changed, 167 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index c74f1a4..d8d9a97 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -643,3 +643,156 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 	return data;
 }
 IWL_EXPORT_SYMBOL(iwl_parse_nvm_data);
+
+static u32 iwl_nvm_get_regdom_bw_flags(const u8 *nvm_chan,
+				       int ch_idx, u16 nvm_flags)
+{
+	u32 flags = NL80211_RRF_NO_HT40;
+
+	if (ch_idx < NUM_2GHZ_CHANNELS &&
+	    (nvm_flags & NVM_CHANNEL_40MHZ)) {
+		if (nvm_chan[ch_idx] <= LAST_2GHZ_HT_PLUS)
+			flags &= ~NL80211_RRF_NO_HT40PLUS;
+		if (nvm_chan[ch_idx] >= FIRST_2GHZ_HT_MINUS)
+			flags &= ~NL80211_RRF_NO_HT40MINUS;
+	} else if (nvm_chan[ch_idx] <= LAST_5GHZ_HT &&
+		   (nvm_flags & NVM_CHANNEL_40MHZ)) {
+		if ((ch_idx - NUM_2GHZ_CHANNELS) % 2 == 0)
+			flags &= ~NL80211_RRF_NO_HT40PLUS;
+		else
+			flags &= ~NL80211_RRF_NO_HT40MINUS;
+	}
+
+	if (!(nvm_flags & NVM_CHANNEL_80MHZ))
+		flags |= NL80211_RRF_NO_80MHZ;
+	if (!(nvm_flags & NVM_CHANNEL_160MHZ))
+		flags |= NL80211_RRF_NO_160MHZ;
+
+	if (!(nvm_flags & NVM_CHANNEL_IBSS))
+		flags |= NL80211_RRF_NO_IR;
+
+	if (!(nvm_flags & NVM_CHANNEL_ACTIVE))
+		flags |= NL80211_RRF_NO_IR;
+
+	if (nvm_flags & NVM_CHANNEL_RADAR)
+		flags |= NL80211_RRF_DFS;
+
+	if (nvm_flags & NVM_CHANNEL_INDOOR_ONLY)
+		flags |= NL80211_RRF_NO_OUTDOOR;
+
+	/* Set the GO concurrent flag only in case that NO_IR is set.
+	 * Otherwise it is meaningless
+	 */
+	if ((nvm_flags & NVM_CHANNEL_GO_CONCURRENT) &&
+	    (flags & NL80211_RRF_NO_IR))
+		flags |= NL80211_RRF_GO_CONCURRENT;
+
+	return flags;
+}
+
+struct ieee80211_regdomain *
+iwl_parse_nvm_mcc_info(struct device *dev, int num_of_ch, __le32 *channels,
+		       u16 fw_mcc)
+{
+	int ch_idx;
+	u16 ch_flags, prev_ch_flags = 0;
+	const u8 *nvm_chan = iwl_nvm_channels; /* TODO: 8000 series differs */
+	struct ieee80211_regdomain *regd;
+	int size_of_regd;
+	struct ieee80211_reg_rule *rule;
+	enum ieee80211_band band;
+	int center_freq, prev_center_freq = 0;
+	int valid_rules = 0;
+	bool new_rule;
+
+	if (WARN_ON_ONCE(num_of_ch > NL80211_MAX_SUPP_REG_RULES))
+		return ERR_PTR(-EINVAL);
+
+	IWL_DEBUG_DEV(dev, IWL_DL_LAR, "building regdom for %d channels\n",
+		      num_of_ch);
+
+	/* build a regdomain rule for every valid channel */
+	size_of_regd =
+		sizeof(struct ieee80211_regdomain) +
+		num_of_ch * sizeof(struct ieee80211_reg_rule);
+
+	regd = kzalloc(size_of_regd, GFP_KERNEL);
+	if (!regd)
+		return ERR_PTR(-ENOMEM);
+
+	for (ch_idx = 0; ch_idx < num_of_ch; ch_idx++) {
+		ch_flags = (u16)__le32_to_cpup(channels + ch_idx);
+		band = (ch_idx < NUM_2GHZ_CHANNELS) ?
+		       IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+		center_freq = ieee80211_channel_to_frequency(nvm_chan[ch_idx],
+							     band);
+		new_rule = false;
+
+		if (!(ch_flags & NVM_CHANNEL_VALID)) {
+			IWL_DEBUG_DEV(dev, IWL_DL_LAR,
+				      "Ch. %d Flags %x [%sGHz] - No traffic\n",
+				      nvm_chan[ch_idx],
+				      ch_flags,
+				      (ch_idx >= NUM_2GHZ_CHANNELS) ?
+				      "5.2" : "2.4");
+			continue;
+		}
+
+		/* we can't continue the same rule */
+		if (ch_idx == 0 || prev_ch_flags != ch_flags ||
+		    center_freq - prev_center_freq > 20) {
+			valid_rules++;
+			new_rule = true;
+		}
+
+		rule = &regd->reg_rules[valid_rules - 1];
+
+		if (new_rule)
+			rule->freq_range.start_freq_khz =
+						MHZ_TO_KHZ(center_freq - 10);
+
+		rule->freq_range.end_freq_khz = MHZ_TO_KHZ(center_freq + 10);
+
+		/* this doesn't matter - not used by FW */
+		rule->power_rule.max_antenna_gain = DBI_TO_MBI(6);
+		rule->power_rule.max_eirp = DBM_TO_MBM(20);
+
+		rule->flags = iwl_nvm_get_regdom_bw_flags(nvm_chan, ch_idx,
+							  ch_flags);
+
+		/* rely on auto-calculation to merge BW of contiguous chans */
+		rule->flags |= NL80211_RRF_AUTO_BW;
+		rule->freq_range.max_bandwidth_khz = 0;
+
+		prev_ch_flags = ch_flags;
+		prev_center_freq = center_freq;
+
+		IWL_DEBUG_DEV(dev, IWL_DL_LAR,
+			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s%s(0x%02x): Ad-Hoc %ssupported\n",
+			      center_freq,
+			      band == IEEE80211_BAND_5GHZ ? "5.2" : "2.4",
+			      CHECK_AND_PRINT_I(VALID),
+			      CHECK_AND_PRINT_I(IBSS),
+			      CHECK_AND_PRINT_I(ACTIVE),
+			      CHECK_AND_PRINT_I(RADAR),
+			      CHECK_AND_PRINT_I(WIDE),
+			      CHECK_AND_PRINT_I(40MHZ),
+			      CHECK_AND_PRINT_I(80MHZ),
+			      CHECK_AND_PRINT_I(160MHZ),
+			      CHECK_AND_PRINT_I(INDOOR_ONLY),
+			      CHECK_AND_PRINT_I(GO_CONCURRENT),
+			      ch_flags,
+			      ((ch_flags & NVM_CHANNEL_IBSS) &&
+			       !(ch_flags & NVM_CHANNEL_RADAR))
+					 ? "" : "not ");
+	}
+
+	regd->n_reg_rules = valid_rules;
+
+	/* set alpha2 from FW. */
+	regd->alpha2[0] = fw_mcc >> 8;
+	regd->alpha2[1] = fw_mcc & 0xff;
+
+	return regd;
+}
+IWL_EXPORT_SYMBOL(iwl_parse_nvm_mcc_info);
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
index c9c45a3..fa493ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
@@ -62,6 +62,7 @@
 #ifndef __iwl_nvm_parse_h__
 #define __iwl_nvm_parse_h__
 
+#include <net/cfg80211.h>
 #include "iwl-eeprom-parse.h"
 
 /**
@@ -78,4 +79,17 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
 		   const __le16 *mac_override, u8 tx_chains, u8 rx_chains);
 
+/**
+ * iwl_parse_mcc_info - parse MCC (mobile country code) info coming from FW
+ *
+ * This function parses the regulatory channel data received as a
+ * MCC_UPDATE_CMD command. It returns a newly allocation regulatory domain,
+ * to be fed into the regulatory core. An ERR_PTR is returned on error.
+ * If not given to the regulatory core, the user is responsible for freeing
+ * the regdomain returned here with kfree.
+ */
+struct ieee80211_regdomain *
+iwl_parse_nvm_mcc_info(struct device *dev, int num_of_ch, __le32 *channels,
+		       u16 fw_mcc);
+
 #endif /* __iwl_nvm_parse_h__ */
-- 
1.9.1

