Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57186 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752472AbbJEPBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:52 +0300
Message-Id: <1444055820-27506-21-git-send-email-luca@coelho.fi> (sfid-20151005_170143_611420_9407DACF)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 21/29] iwlwifi: mvm: rs: fix success ratio comparison in rs_get_best_rate
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

success_ratio is actually 128 * SR in percentage while
IWL_MVM_RS_SR_NO_DECREASE is 85%. Fix this by using RS_PERCENT().
This bug caused the if branch to be always executed. This in turn
led to always selecting a rate, following a column switch, in which
the expected throughput would exceed the best expected current throughput.
In some scenarios where the success ratio isn't >85% such a rate
could be too aggressive leading us to avoid the new column.
This has the potential of causing sub optimal performance.

Reported-by: Moshe Harel <moshe.harel@intel.com>
Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 2bf2a08..435e1e4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1527,7 +1527,7 @@ static s32 rs_get_best_rate(struct iwl_mvm *mvm,
 	u32 target_tpt;
 	int rate_idx;
 
-	if (success_ratio > IWL_MVM_RS_SR_NO_DECREASE) {
+	if (success_ratio >= RS_PERCENT(IWL_MVM_RS_SR_NO_DECREASE)) {
 		target_tpt = 100 * expected_current_tpt;
 		IWL_DEBUG_RATE(mvm,
 			       "SR %d high. Find rate exceeding EXPECTED_CURRENT %d\n",
@@ -1535,7 +1535,7 @@ static s32 rs_get_best_rate(struct iwl_mvm *mvm,
 	} else {
 		target_tpt = lq_sta->last_tpt;
 		IWL_DEBUG_RATE(mvm,
-			       "SR %d not thag good. Find rate exceeding ACTUAL_TPT %d\n",
+			       "SR %d not that good. Find rate exceeding ACTUAL_TPT %d\n",
 			       success_ratio, target_tpt);
 	}
 
-- 
2.5.3

