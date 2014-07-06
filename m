Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33687 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaGFJhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:04 -0400
Received: by mail-wi0-f177.google.com with SMTP id r20so5486141wiv.4
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:02 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/40] iwlwifi: mvm: don't pass update type to quota iterator
Date: Sun,  6 Jul 2014 12:36:03 +0300
Message-Id: <1404639376-3792-27-git-send-email-egrumbach@gmail.com> (sfid-20140706_115954_307900_810A57FA)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Simplify the quota iterator by not passing the update type,
it only needs to know whether or not to skip an interface.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/quota.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 3f18786..6de0c63 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -73,8 +73,7 @@ struct iwl_mvm_quota_iterator_data {
 	int colors[MAX_BINDINGS];
 	int low_latency[MAX_BINDINGS];
 	int n_low_latency_bindings;
-	struct ieee80211_vif *vif;
-	enum iwl_mvm_quota_update_type type;
+	struct ieee80211_vif *skip_vif;
 };
 
 static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
@@ -89,8 +88,9 @@ static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
 	 * skip it here in case we're not called from within
 	 * the add_interface callback (otherwise it won't show
 	 * up in iteration)
+	 * Also skip disabled interfaces here immediately.
 	 */
-	if (data->type == IWL_MVM_QUOTA_UPDATE_TYPE_NEW && vif == data->vif)
+	if (vif == data->skip_vif)
 		return;
 
 	if (!mvmvif->phy_ctxt)
@@ -105,10 +105,6 @@ static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
 	if (WARN_ON_ONCE(id >= MAX_BINDINGS))
 		return;
 
-	if (data->type == IWL_MVM_QUOTA_UPDATE_TYPE_DISABLED &&
-	    vif == data->vif)
-		return;
-
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		if (vif->bss_conf.assoc)
@@ -184,8 +180,7 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_mvm_quota_iterator_data data = {
 		.n_interfaces = {},
 		.colors = { -1, -1, -1, -1 },
-		.vif = vif,
-		.type = type,
+		.skip_vif = vif,
 	};
 
 	lockdep_assert_held(&mvm->mutex);
@@ -205,8 +200,7 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_quota_iterator, &data);
 	if (type == IWL_MVM_QUOTA_UPDATE_TYPE_NEW) {
-		data.vif = NULL;
-		data.type = IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR;
+		data.skip_vif = NULL;
 		iwl_mvm_quota_iterator(&data, vif->addr, vif);
 	}
 
-- 
1.8.3.2

