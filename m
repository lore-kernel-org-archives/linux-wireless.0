Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:6667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbbCLNE6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:04:58 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/49] iwlwifi: don't declare support for 5ghz if not supported
Date: Thu, 12 Mar 2015 15:03:53 +0200
Message-Id: <1426165474-25586-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140512_653192_73E7EAA4)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Remove a useless debug print about unsupported channels.
Also add a comment about the LAR special case where channels
might become valid later.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 99476bd..8870377 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -272,9 +272,14 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 
 		if (ch_idx >= num_2ghz_channels &&
 		    !data->sku_cap_band_52GHz_enable)
-			ch_flags &= ~NVM_CHANNEL_VALID;
+			continue;
 
 		if (!lar_supported && !(ch_flags & NVM_CHANNEL_VALID)) {
+			/*
+			 * Channels might become valid later if lar is
+			 * supported, hence we still want to add them to
+			 * the list of supported channels to cfg80211.
+			 */
 			IWL_DEBUG_EEPROM(dev,
 					 "Ch. %d Flags %x [%sGHz] - No traffic\n",
 					 nvm_chan[ch_idx],
-- 
1.9.1

