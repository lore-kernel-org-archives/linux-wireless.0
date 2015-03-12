Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:6667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbbCLNEz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:04:55 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/49] iwlwifi: ignore IBSS flag as regulatory NO-IR indication
Date: Thu, 12 Mar 2015 15:03:52 +0200
Message-Id: <1426165474-25586-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140459_249714_94380DD8)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

According to updated regulatory guidelines, the ACTIVE bit in the NVM
also allows ibss activity on the channel. The IBSS NVM bit is not updated
when LAR is active and is deprecated. Using this bit for NO-IR incorrectly
causes all 5Ghz channels to be marked as passive.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index a49666f..99476bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -684,9 +684,6 @@ static u32 iwl_nvm_get_regdom_bw_flags(const u8 *nvm_chan,
 	if (!(nvm_flags & NVM_CHANNEL_160MHZ))
 		flags |= NL80211_RRF_NO_160MHZ;
 
-	if (!(nvm_flags & NVM_CHANNEL_IBSS))
-		flags |= NL80211_RRF_NO_IR;
-
 	if (!(nvm_flags & NVM_CHANNEL_ACTIVE))
 		flags |= NL80211_RRF_NO_IR;
 
@@ -784,11 +781,10 @@ iwl_parse_nvm_mcc_info(struct device *dev, int num_of_ch, __le32 *channels,
 		prev_center_freq = center_freq;
 
 		IWL_DEBUG_DEV(dev, IWL_DL_LAR,
-			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s%s(0x%02x): Ad-Hoc %ssupported\n",
+			      "Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s(0x%02x): Ad-Hoc %ssupported\n",
 			      center_freq,
 			      band == IEEE80211_BAND_5GHZ ? "5.2" : "2.4",
 			      CHECK_AND_PRINT_I(VALID),
-			      CHECK_AND_PRINT_I(IBSS),
 			      CHECK_AND_PRINT_I(ACTIVE),
 			      CHECK_AND_PRINT_I(RADAR),
 			      CHECK_AND_PRINT_I(WIDE),
@@ -798,7 +794,7 @@ iwl_parse_nvm_mcc_info(struct device *dev, int num_of_ch, __le32 *channels,
 			      CHECK_AND_PRINT_I(INDOOR_ONLY),
 			      CHECK_AND_PRINT_I(GO_CONCURRENT),
 			      ch_flags,
-			      ((ch_flags & NVM_CHANNEL_IBSS) &&
+			      ((ch_flags & NVM_CHANNEL_ACTIVE) &&
 			       !(ch_flags & NVM_CHANNEL_RADAR))
 					 ? "" : "not ");
 	}
-- 
1.9.1

