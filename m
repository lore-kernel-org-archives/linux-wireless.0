Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1927 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbcCBH6M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:58:12 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/43] iwlwifi: mvm: Send power command on BSS_CHANGED_BEACON_INFO if needed
Date: Wed,  2 Mar 2016 09:56:33 +0200
Message-Id: <1456905404-14435-32-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085952_243538_71681FB0)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Beacon abort (ba) is set while sending power command, but only
after at least one beacon_filter command was successfully sent.

If we heard a beacon before starting association, this order
is maintained and ba is properly set.

However, if the first beacon is received after association,
we send the power command upon association, configure the
beacon filtering when the first beacon arrives, and in that case,
beacon abort is not set.

So identify this, and send a power command post the beacon_filter
command if needed.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 86b4b9d..927b055 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1955,7 +1955,12 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, 0));
 	}
 
-	if (changes & (BSS_CHANGED_PS | BSS_CHANGED_P2P_PS | BSS_CHANGED_QOS)) {
+	if (changes & (BSS_CHANGED_PS | BSS_CHANGED_P2P_PS | BSS_CHANGED_QOS |
+		       /*
+			* Send power command on every beacon change,
+			* because we may have not enabled beacon abort yet.
+			*/
+		       BSS_CHANGED_BEACON_INFO)) {
 		ret = iwl_mvm_power_update_mac(mvm);
 		if (ret)
 			IWL_ERR(mvm, "failed to update power mode\n");
-- 
2.5.0

