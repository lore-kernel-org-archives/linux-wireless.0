Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992AbbLAJ70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:26 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/41] iwlwifi: mvm: change name of iwl_mvm_d3_update_gtk
Date: Tue,  1 Dec 2015 11:58:38 +0200
Message-Id: <1448963947-24302-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110339_820902_D371E0C9)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function updates the pairwise keys as well.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 29ae58e..76c2002 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1406,7 +1406,7 @@ struct iwl_mvm_d3_gtk_iter_data {
 	int num_keys;
 };
 
-static void iwl_mvm_d3_update_gtks(struct ieee80211_hw *hw,
+static void iwl_mvm_d3_update_keys(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_sta *sta,
 				   struct ieee80211_key_conf *key,
@@ -1494,7 +1494,7 @@ static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 	/* find last GTK that we used initially, if any */
 	gtkdata.find_phase = true;
 	ieee80211_iter_keys(mvm->hw, vif,
-			    iwl_mvm_d3_update_gtks, &gtkdata);
+			    iwl_mvm_d3_update_keys, &gtkdata);
 	/* not trying to keep connections with MFP/unhandled ciphers */
 	if (gtkdata.unhandled_cipher)
 		return false;
@@ -1509,7 +1509,7 @@ static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 	 */
 	gtkdata.find_phase = false;
 	ieee80211_iter_keys(mvm->hw, vif,
-			    iwl_mvm_d3_update_gtks, &gtkdata);
+			    iwl_mvm_d3_update_keys, &gtkdata);
 
 	if (status->num_of_gtk_rekeys) {
 		struct ieee80211_key_conf *key;
-- 
2.5.0

