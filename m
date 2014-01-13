Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36757 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaAMUWG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:06 -0500
Received: by mail-ee0-f44.google.com with SMTP id c13so421322eek.3
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:05 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/18] iwlwifi: mvm: update power after binding in start_ap_ibss()
Date: Mon, 13 Jan 2014 22:21:41 +0200
Message-Id: <1389644517-22807-2-git-send-email-egrumbach@gmail.com> (sfid-20140113_212210_863348_8C554B9D)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

The power settings need to be updated after a binding flow is done
and before quota calculations. This was missing in the start_ap_ibss()
flow. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 2ac3b25..208771a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1015,9 +1015,13 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	/* must be set before quota calculations */
 	mvmvif->ap_ibss_active = true;
 
+	/* power updated needs to be done before quotas */
+	mvm->bound_vif_cnt++;
+	iwl_mvm_power_update_binding(mvm, vif, true);
+
 	ret = iwl_mvm_update_quotas(mvm, vif);
 	if (ret)
-		goto out_rm_bcast;
+		goto out_quota_failed;
 
 	/* Need to update the P2P Device MAC (only GO, IBSS is single vif) */
 	if (vif->p2p && mvm->p2p_device_vif)
@@ -1028,7 +1032,9 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	mutex_unlock(&mvm->mutex);
 	return 0;
 
-out_rm_bcast:
+out_quota_failed:
+	mvm->bound_vif_cnt--;
+	iwl_mvm_power_update_binding(mvm, vif, false);
 	mvmvif->ap_ibss_active = false;
 	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
 out_unbind:
@@ -1061,6 +1067,10 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 	iwl_mvm_update_quotas(mvm, NULL);
 	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
 	iwl_mvm_binding_remove_vif(mvm, vif);
+
+	mvm->bound_vif_cnt--;
+	iwl_mvm_power_update_binding(mvm, vif, false);
+
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
 
 	mutex_unlock(&mvm->mutex);
@@ -1772,11 +1782,11 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	}
 
 	iwl_mvm_binding_remove_vif(mvm, vif);
-out_unlock:
-	mvmvif->phy_ctxt = NULL;
 	mvm->bound_vif_cnt--;
 	iwl_mvm_power_update_binding(mvm, vif, false);
 
+out_unlock:
+	mvmvif->phy_ctxt = NULL;
 	mutex_unlock(&mvm->mutex);
 }
 
-- 
1.7.9.5

