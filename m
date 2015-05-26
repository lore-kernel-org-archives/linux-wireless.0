Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbbEZTTL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:19:11 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 37/39] iwlwifi: mvm: treat scan races also on UMAC scans
Date: Tue, 26 May 2015 22:17:50 +0300
Message-Id: <1432667872-18092-37-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211923_987765_1FC8CA79)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

For UMAC, we were not treating a race condition that happens in the
scan flows, because it was not using the same state flags.  Now that
UMAC and LMAC scans use the same state flags, we can also handle the
race conditions for UMAC.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index d3af88b..cea2366 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2413,11 +2413,7 @@ static void iwl_mvm_mac_cancel_hw_scan(struct ieee80211_hw *hw,
 	 * cancel scan scan before ieee80211_scan_work() could run.
 	 * To handle that, simply return if the scan is not running.
 	*/
-	/* FIXME: for now, we ignore this race for UMAC scans, since
-	 * they don't set the scan_status.
-	 */
-	if ((mvm->scan_status & IWL_MVM_SCAN_REGULAR) ||
-	    (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN))
+	if (mvm->scan_status & IWL_MVM_SCAN_REGULAR)
 		iwl_mvm_scan_stop(mvm, IWL_MVM_SCAN_REGULAR, true);
 
 	mutex_unlock(&mvm->mutex);
@@ -2767,11 +2763,7 @@ static int iwl_mvm_mac_sched_scan_stop(struct ieee80211_hw *hw,
 	 * could run.  To handle this, simply return if the scan is
 	 * not running.
 	*/
-	/* FIXME: for now, we ignore this race for UMAC scans, since
-	 * they don't set the scan_status.
-	 */
-	if (!(mvm->scan_status & IWL_MVM_SCAN_SCHED) &&
-	    !(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
+	if (!(mvm->scan_status & IWL_MVM_SCAN_SCHED)) {
 		mutex_unlock(&mvm->mutex);
 		return 0;
 	}
-- 
2.1.4

