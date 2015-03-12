Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbbCLNGG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:06 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/49] iwlwifi: don't allow the FW to return invalid ch indices
Date: Thu, 12 Mar 2015 15:04:18 +0200
Message-Id: <1426165474-25586-33-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140741_737132_24B95DD5)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

If the FW returns an invalid channels count in response to an MCC request,
make sure we don't reference invalid indices in the channels array.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index b372105..7746377 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -743,10 +743,15 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	int center_freq, prev_center_freq = 0;
 	int valid_rules = 0;
 	bool new_rule;
+	int max_num_ch = cfg->device_family == IWL_DEVICE_FAMILY_8000 ?
+			 IWL_NUM_CHANNELS_FAMILY_8000 : IWL_NUM_CHANNELS;
 
 	if (WARN_ON_ONCE(num_of_ch > NL80211_MAX_SUPP_REG_RULES))
 		return ERR_PTR(-EINVAL);
 
+	if (WARN_ON(num_of_ch > max_num_ch))
+		num_of_ch = max_num_ch;
+
 	IWL_DEBUG_DEV(dev, IWL_DL_LAR, "building regdom for %d channels\n",
 		      num_of_ch);
 
-- 
1.9.1

