Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab3GZITe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:19:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 5/7] iwlwifi: mvm: Disable managed PS when GO is added
Date: Fri, 26 Jul 2013 10:19:26 +0200
Message-Id: <1374826768-2440-5-git-send-email-johannes@sipsolutions.net> (sfid-20130726_101943_527938_8A5875DC)
In-Reply-To: <1374826768-2440-1-git-send-email-johannes@sipsolutions.net>
References: <1374826675.8248.11.camel@jlt4.sipsolutions.net>
 <1374826768-2440-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

The managed interface PS was not disabled when a GO interface
was added. As a consequence, when the station VMAC was in PS,
the GO also was not on the medium. Fix this.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 42 ++++++++++++++---------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 1eedc42..f19baf0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -512,6 +512,27 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		goto out_unlock;
 
 	/*
+	 * TODO: remove this temporary code.
+	 * Currently MVM FW supports power management only on single MAC.
+	 * If new interface added, disable PM on existing interface.
+	 * P2P device is a special case, since it is handled by FW similary to
+	 * scan. If P2P deviced is added, PM remains enabled on existing
+	 * interface.
+	 * Note: the method below does not count the new interface being added
+	 * at this moment.
+	 */
+	if (vif->type != NL80211_IFTYPE_P2P_DEVICE)
+		mvm->vif_count++;
+	if (mvm->vif_count > 1) {
+		IWL_DEBUG_MAC80211(mvm,
+				   "Disable power on existing interfaces\n");
+		ieee80211_iterate_active_interfaces_atomic(
+					    mvm->hw,
+					    IEEE80211_IFACE_ITER_NORMAL,
+					    iwl_mvm_pm_disable_iterator, mvm);
+	}
+
+	/*
 	 * The AP binding flow can be done only after the beacon
 	 * template is configured (which happens only in the mac80211
 	 * start_ap() flow), and adding the broadcast station can happen
@@ -534,27 +555,6 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
-	/*
-	 * TODO: remove this temporary code.
-	 * Currently MVM FW supports power management only on single MAC.
-	 * If new interface added, disable PM on existing interface.
-	 * P2P device is a special case, since it is handled by FW similary to
-	 * scan. If P2P deviced is added, PM remains enabled on existing
-	 * interface.
-	 * Note: the method below does not count the new interface being added
-	 * at this moment.
-	 */
-	if (vif->type != NL80211_IFTYPE_P2P_DEVICE)
-		mvm->vif_count++;
-	if (mvm->vif_count > 1) {
-		IWL_DEBUG_MAC80211(mvm,
-				   "Disable power on existing interfaces\n");
-		ieee80211_iterate_active_interfaces_atomic(
-					    mvm->hw,
-					    IEEE80211_IFACE_ITER_NORMAL,
-					    iwl_mvm_pm_disable_iterator, mvm);
-	}
-
 	ret = iwl_mvm_mac_ctxt_add(mvm, vif);
 	if (ret)
 		goto out_release;
-- 
1.8.0

