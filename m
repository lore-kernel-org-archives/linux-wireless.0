Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:27220 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbbECTch (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:37 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/42] iwlwifi: rs: remove unneeded check of average tpt in window
Date: Sun,  3 May 2015 22:31:25 +0300
Message-Id: <1430681513-7838-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213417_886717_026F8AF0)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Previously there was a check that compared window->average_tpt
to some value, and if it was different - it set it to that
value. However, this value was already calculated and set in
_rs_collect_tx_data(), so the entire check is unneeded.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 316c6e0..0440142 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2183,13 +2183,6 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 
 		return;
 	}
-	/* Else we have enough samples; calculate estimate of
-	 * actual average throughput */
-	if (window->average_tpt != ((window->success_ratio *
-			tbl->expected_tpt[index] + 64) / 128)) {
-		window->average_tpt = ((window->success_ratio *
-					tbl->expected_tpt[index] + 64) / 128);
-	}
 
 	/* If we are searching for better modulation mode, check success. */
 	if (lq_sta->search_better_tbl) {
-- 
2.1.0

