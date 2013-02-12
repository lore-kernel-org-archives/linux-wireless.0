Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761262Ab3BLQCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:02:17 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Beni Lev <beni.lev@intel.com>
Subject: [PATCH 06/15] iwlwifi: mvm: fix TKIP key updating
Date: Tue, 12 Feb 2013 17:01:58 +0100
Message-Id: <1360684927-1367-6-git-send-email-johannes@sipsolutions.net> (sfid-20130212_170241_070039_929C7876)
In-Reply-To: <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
 <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

When a TKIP key is updated with a station pointer that is NULL it is
a GTK, so it should use the AP's station ID. Fix the code to do that.

Signed-off-by: Beni Lev <beni.lev@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 8f8b66e..6b22bac 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1155,14 +1155,26 @@ void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
 			     struct ieee80211_sta *sta, u32 iv32,
 			     u16 *phase1key)
 {
-	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+	struct iwl_mvm_sta *mvm_sta;
 	u8 sta_id = iwl_mvm_get_key_sta_id(vif, sta);
 
-	if (sta_id == IWL_INVALID_STATION)
+	if (WARN_ON_ONCE(sta_id == IWL_INVALID_STATION))
 		return;
 
+	rcu_read_lock();
+
+	if (!sta) {
+		sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
+		if (WARN_ON(IS_ERR_OR_NULL(sta))) {
+			rcu_read_unlock();
+			return;
+		}
+	}
+
+	mvm_sta = (void *)sta->drv_priv;
 	iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, sta_id,
 			     iv32, phase1key, CMD_ASYNC);
+	rcu_read_unlock();
 }
 
 void iwl_mvm_sta_modify_ps_wake(struct iwl_mvm *mvm, int sta_id)
-- 
1.8.0

