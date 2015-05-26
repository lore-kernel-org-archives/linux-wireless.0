Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbbEZTSn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/39] iwlwifi: mvm: don't stop regular scans when going out of idle state
Date: Tue, 26 May 2015 22:17:37 +0300
Message-Id: <1432667872-18092-24-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_213349_308741_00636A81)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

It is not necessary to stop regular scans when going out of idle
state.  Previously, we were doing so for LMAC scans because the
iwl_mvm_scan_offload_stop() function was stopping both kinds of scans.
Now that we have more granularity, we can skip it.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 1346931..df0199e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2360,10 +2360,8 @@ static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	if (changes & BSS_CHANGED_IDLE && !bss_conf->idle) {
+	if (changes & BSS_CHANGED_IDLE && !bss_conf->idle)
 		iwl_mvm_sched_scan_stop(mvm, true);
-		iwl_mvm_reg_scan_stop(mvm);
-	}
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-- 
2.1.4

