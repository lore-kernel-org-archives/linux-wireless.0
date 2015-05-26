Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4720 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbbEZTSE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:04 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Nicholas Krause <xerofoify@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/39] iwlwifi: Remove use of the deprecacted PTR_RET
Date: Tue, 26 May 2015 22:17:17 +0300
Message-Id: <1432667872-18092-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_212030_056642_5D36494D)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nicholas Krause <xerofoify@gmail.com>

This removes the use of the two deprecated calls to the
macro PTR_RET in iwl_mvm_get_regdomain and replaces them
both to PTR_ERR_OR_ZERO.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
[Commit message editing]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index ccbe575..677143c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -318,7 +318,7 @@ struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
 	resp = iwl_mvm_update_mcc(mvm, alpha2, src_id);
 	if (IS_ERR_OR_NULL(resp)) {
 		IWL_DEBUG_LAR(mvm, "Could not get update from FW %d\n",
-			      PTR_RET(resp));
+			      PTR_ERR_OR_ZERO(resp));
 		goto out;
 	}
 
@@ -334,7 +334,7 @@ struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
 	kfree(resp);
 	if (IS_ERR_OR_NULL(regd)) {
 		IWL_DEBUG_LAR(mvm, "Could not get parse update from FW %d\n",
-			      PTR_RET(regd));
+			      PTR_ERR_OR_ZERO(regd));
 		goto out;
 	}
 
-- 
2.1.4

