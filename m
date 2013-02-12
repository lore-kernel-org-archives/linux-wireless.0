Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181Ab3BLQCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:02:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/15] iwlwifi: mvm: use atomic interface iteration to avoid deadlock
Date: Tue, 12 Feb 2013 17:02:00 +0100
Message-Id: <1360684927-1367-8-git-send-email-johannes@sipsolutions.net> (sfid-20130212_170224_550570_3B38684A)
In-Reply-To: <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
 <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Using the non-atomic version creates a dependency between
mac80211's iflist_mtx and mvm->mutex. Use the atomic version
instead which doesn't take iflist_mtx but can't sleep, so
send the HCMD in ASYNC.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 drivers/net/wireless/iwlwifi/mvm/power.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index a6b05a0..64acc4a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -475,7 +475,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (mvm->vif_count > 1) {
 		IWL_DEBUG_MAC80211(mvm,
 				   "Disable power on existing interfaces\n");
-		ieee80211_iterate_active_interfaces(
+		ieee80211_iterate_active_interfaces_atomic(
 					    mvm->hw,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_pm_disable_iterator, mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 6362873..5a92a49 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -194,7 +194,7 @@ int iwl_mvm_power_disable(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 			cmd.id_and_color, iwlmvm_mod_params.power_scheme,
 			le16_to_cpu(cmd.flags));
 
-	return iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, CMD_SYNC,
+	return iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, CMD_ASYNC,
 				    sizeof(cmd), &cmd);
 }
 
-- 
1.8.0

