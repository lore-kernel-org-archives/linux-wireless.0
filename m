Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45740 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754926AbdHYI1j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 04:27:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 25 Aug 2017 11:27:29 +0300
Message-Id: <20170825082730.31388-2-luca@coelho.fi> (sfid-20170825_102746_063498_7C523478)
In-Reply-To: <20170825082730.31388-1-luca@coelho.fi>
References: <20170825082730.31388-1-luca@coelho.fi>
Subject: [PATCH 1/2] iwlwifi: fix long debug print
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

There is a debug print that sometimes reaches over
110 chars, thus generating a warning in those cases.
Split the print into two to prevent these cases.

Fixes: 92b0f7b26b31 ("iwlwifi: split the regulatory rules when the bandwidth flags require it")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index b46796944cf2..3014beef4873 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -915,7 +915,7 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		prev_reg_rule_flags = reg_rule_flags;
 
 		IWL_DEBUG_DEV(dev, IWL_DL_LAR,
-			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s%s%s%s(0x%02x) reg_flags 0x%x: %s\n",
+			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s%s%s%s(0x%02x)\n",
 			      center_freq,
 			      band == NL80211_BAND_5GHZ ? "5.2" : "2.4",
 			      CHECK_AND_PRINT_I(VALID),
@@ -930,7 +930,12 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 			      CHECK_AND_PRINT_I(80MHZ),
 			      CHECK_AND_PRINT_I(160MHZ),
 			      CHECK_AND_PRINT_I(DC_HIGH),
-			      ch_flags, reg_rule_flags,
+			      ch_flags);
+		IWL_DEBUG_DEV(dev, IWL_DL_LAR,
+			      "Ch. %d [%sGHz] reg_flags 0x%x: %s\n",
+			      center_freq,
+			      band == NL80211_BAND_5GHZ ? "5.2" : "2.4",
+			      reg_rule_flags,
 			      ((ch_flags & NVM_CHANNEL_ACTIVE) &&
 			       !(ch_flags & NVM_CHANNEL_RADAR))
 					 ? "Ad-Hoc" : "");
-- 
2.14.1
