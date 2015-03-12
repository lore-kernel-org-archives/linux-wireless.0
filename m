Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26343 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489AbbCLNFd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:33 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/49] iwlwifi: use IWL_DEFAULT_MAX_TX_POWER for max_eirp
Date: Thu, 12 Mar 2015 15:03:57 +0200
Message-Id: <1426165474-25586-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140537_452671_87A0C55E)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

max_eirp affects the txpower configured to the power,
so use the max tx power (22) instead of some other
value.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 727e8a4..83ba307f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -784,7 +784,8 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 
 		/* this doesn't matter - not used by FW */
 		rule->power_rule.max_antenna_gain = DBI_TO_MBI(6);
-		rule->power_rule.max_eirp = DBM_TO_MBM(20);
+		rule->power_rule.max_eirp =
+			DBM_TO_MBM(IWL_DEFAULT_MAX_TX_POWER);
 
 		rule->flags = iwl_nvm_get_regdom_bw_flags(nvm_chan, ch_idx,
 							  ch_flags, cfg);
-- 
1.9.1

