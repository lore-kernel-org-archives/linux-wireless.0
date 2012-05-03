Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:64003 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758755Ab2ECV2n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 17:28:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Amit Beka <amit.beka@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/6] iwlwifi: fix power index handling
Date: Thu,  3 May 2012 14:22:04 -0700
Message-Id: <1336080126-22606-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120503_232848_315767_7A01DBC5)
In-Reply-To: <1336080126-22606-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1336080126-22606-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Beka <amit.beka@intel.com>

The power index that the user gives as module parameter
in in range 1-5, but we need to decrease it in order
to create an array index out of it (0-4) for the power
table command.

Signed-off-by: Amit Beka <amit.beka@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 8352265..544ddf1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -253,6 +253,8 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 
 	IWL_DEBUG_POWER(priv, "numSkipDtim = %u, dtimPeriod = %d\n",
 			skip, period);
+	/* The power level here is 0-4 (used as array index), but user expects
+	to see 1-5 (according to spec). */
 	IWL_DEBUG_POWER(priv, "Sleep command for index %d\n", lvl + 1);
 }
 
@@ -308,10 +310,12 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 				     priv->power_data.debug_sleep_level_override,
 				     dtimper);
 	else {
+		/* Note that the user parameter is 1-5 (according to spec),
+		but we pass 0-4 because it acts as an array index. */
 		if (iwlwifi_mod_params.power_level > IWL_POWER_INDEX_1 &&
-		    iwlwifi_mod_params.power_level <= IWL_POWER_INDEX_5)
+		    iwlwifi_mod_params.power_level <= IWL_POWER_NUM)
 			iwl_static_sleep_cmd(priv, cmd,
-				iwlwifi_mod_params.power_level, dtimper);
+				iwlwifi_mod_params.power_level - 1, dtimper);
 		else
 			iwl_static_sleep_cmd(priv, cmd,
 				IWL_POWER_INDEX_1, dtimper);
-- 
1.7.0.4

