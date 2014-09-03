Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44424 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbaICT5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:13 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so9030484wgh.15
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:12 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/36] iwlwifi: mvm: set the TX disable bit when doing a chanctx switch
Date: Wed,  3 Sep 2014 22:56:17 +0300
Message-Id: <1409774184-24665-29-git-send-email-egrumbach@gmail.com> (sfid-20140903_220114_982285_D4837DAF)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

During a channel switch we should tell the firmware to disable TX
temporarily and re-enable it after the switch is done.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index cbe9ff0..3bbeedf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2748,6 +2748,19 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 		iwl_mvm_mac_ctxt_changed(mvm, vif, false);
 	}
 
+	if (vif->csa_active && vif->type == NL80211_IFTYPE_STATION) {
+		struct iwl_mvm_sta *mvmsta;
+
+		mvmsta = iwl_mvm_sta_from_staid_protected(mvm,
+							  mvmvif->ap_sta_id);
+
+		if (WARN_ON(!mvmsta))
+			goto out;
+
+		/* TODO: only re-enable after the first beacon */
+		iwl_mvm_sta_modify_disable_tx(mvm, mvmsta, false);
+	}
+
 	goto out;
 
 out_remove_binding:
@@ -2779,6 +2792,7 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct ieee80211_vif *disabled_vif = NULL;
+	struct iwl_mvm_sta *mvmsta;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -2810,6 +2824,12 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 
 		disabled_vif = vif;
 
+		mvmsta = iwl_mvm_sta_from_staid_protected(mvm,
+							  mvmvif->ap_sta_id);
+
+		if (!WARN_ON(!mvmsta))
+			iwl_mvm_sta_modify_disable_tx(mvm, mvmsta, true);
+
 		iwl_mvm_mac_ctxt_changed(mvm, vif, true);
 		break;
 	default:
-- 
1.9.1

