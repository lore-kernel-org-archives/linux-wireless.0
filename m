Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:63552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbbECTcH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:07 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/42] iwlwifi: mvm: don't increase max_out_time when low priority scan is requested
Date: Sun,  3 May 2015 22:31:16 +0300
Message-Id: <1430681513-7838-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213212_138256_1F79E07C)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

In some cases, max_out_time value is smaller than 200 and having the
NL80211_SCAN_FLAG_LOW_PRIORITY flag was actually causing the
max_out_time to be increased.  To avoid that, set max_out_time to 200
only if it's greater than 200.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 9f72505..8a0b244 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -257,7 +257,8 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 		}
 	}
 
-	if (flags & NL80211_SCAN_FLAG_LOW_PRIORITY)
+	if ((flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
+	    (params->max_out_time > 200))
 		params->max_out_time = 200;
 
 not_bound:
-- 
2.1.0

