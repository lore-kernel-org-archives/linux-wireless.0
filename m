Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbbEZTSG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:06 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/39] iwlwifi: mvm: small fix in a comment about UMAC scan schedules
Date: Tue, 26 May 2015 22:17:18 +0300
Message-Id: <1432667872-18092-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211822_487886_717CEFF6)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The UMAC API supports multiple scan schedules, but now we use only a
single one.  Change the comment to make this clear and avoid
confusion.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index e50fd3f..e54432a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1222,8 +1222,8 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	iwl_mvm_umac_scan_cfg_channels(mvm, params->channels,
 				       params->n_channels, ssid_bitmap, cmd);
 
-	/* With UMAC we can have only one schedule, so use the sum of
-	 * the iterations (with a a maximum of 255).
+	/* With UMAC we use only one schedule for now, so use the sum
+	 * of the iterations (with a a maximum of 255).
 	 */
 	sec_part->schedule[0].iter_count =
 		(n_iterations > 255) ? 255 : n_iterations;
-- 
2.1.4

