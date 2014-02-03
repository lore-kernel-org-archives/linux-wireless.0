Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:39507 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaBCU7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:44 -0500
Received: by mail-ee0-f41.google.com with SMTP id e51so1759278eek.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:43 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 54/62] iwlwifi: mvm: clean up iwl_mvm_bss_info_changed_ap_ibss
Date: Mon,  3 Feb 2014 22:58:00 +0200
Message-Id: <1391461088-8082-54-git-send-email-egrumbach@gmail.com> (sfid-20140203_223008_452318_A97305E3)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Remove the enum abuse (using an enum to store a set of values),
the unneeded ret variable and unnecessary if nesting.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 9d9a2d0..3ef7d78 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1397,26 +1397,20 @@ iwl_mvm_bss_info_changed_ap_ibss(struct iwl_mvm *mvm,
 				 u32 changes)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	enum ieee80211_bss_change ht_change = BSS_CHANGED_ERP_CTS_PROT |
-					      BSS_CHANGED_HT |
-					      BSS_CHANGED_BANDWIDTH;
-	int ret;
 
 	/* Changes will be applied when the AP/IBSS is started */
 	if (!mvmvif->ap_ibss_active)
 		return;
 
-	if (changes & ht_change) {
-		ret = iwl_mvm_mac_ctxt_changed(mvm, vif);
-		if (ret)
-			IWL_ERR(mvm, "failed to update MAC %pM\n", vif->addr);
-	}
+	if (changes & (BSS_CHANGED_ERP_CTS_PROT | BSS_CHANGED_HT |
+		       BSS_CHANGED_BANDWIDTH) &&
+	    iwl_mvm_mac_ctxt_changed(mvm, vif))
+		IWL_ERR(mvm, "failed to update MAC %pM\n", vif->addr);
 
 	/* Need to send a new beacon template to the FW */
-	if (changes & BSS_CHANGED_BEACON) {
-		if (iwl_mvm_mac_ctxt_beacon_changed(mvm, vif))
-			IWL_WARN(mvm, "Failed updating beacon data\n");
-	}
+	if (changes & BSS_CHANGED_BEACON &&
+	    iwl_mvm_mac_ctxt_beacon_changed(mvm, vif))
+		IWL_WARN(mvm, "Failed updating beacon data\n");
 }
 
 static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
-- 
1.7.9.5

