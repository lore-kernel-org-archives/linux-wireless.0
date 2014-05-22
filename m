Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:59057 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaEVHYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:24:22 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so3070155wes.27
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 00:24:21 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/11] iwlwifi: mvm: remove vif argument from power_update_mac
Date: Thu, 22 May 2014 10:23:55 +0300
Message-Id: <1400743435-702-11-git-send-email-egrumbach@gmail.com> (sfid-20140522_095147_721121_D5DE8B55)
In-Reply-To: <537DA58C.5050003@gmail.com>
References: <537DA58C.5050003@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The power update function looks at all current vifs to determine the power
policy. It doesn't use the current vif. Instead the value was overwritten
and used internally.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c          |  2 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    | 18 +++++++++---------
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  2 +-
 drivers/net/wireless/iwlwifi/mvm/power.c       |  8 ++++----
 drivers/net/wireless/iwlwifi/mvm/utils.c       |  2 +-
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 48c192d..645b3cf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1028,7 +1028,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	if (ret)
 		goto out;
 
-	ret = iwl_mvm_power_update_mac(mvm, vif);
+	ret = iwl_mvm_power_update_mac(mvm);
 	if (ret)
 		goto out;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 44b19e6..2e90ff7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -175,7 +175,7 @@ static ssize_t iwl_dbgfs_pm_params_write(struct ieee80211_vif *vif, char *buf,
 
 	mutex_lock(&mvm->mutex);
 	iwl_dbgfs_update_pm(mvm, vif, param, val);
-	ret = iwl_mvm_power_update_mac(mvm, vif);
+	ret = iwl_mvm_power_update_mac(mvm);
 	mutex_unlock(&mvm->mutex);
 
 	return ret ?: count;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 1146cfb..7215f59 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -832,7 +832,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_release;
 
-	ret = iwl_mvm_power_update_mac(mvm, vif);
+	ret = iwl_mvm_power_update_mac(mvm);
 	if (ret)
 		goto out_release;
 
@@ -983,7 +983,7 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 	if (mvm->vif_count && vif->type != NL80211_IFTYPE_P2P_DEVICE)
 		mvm->vif_count--;
 
-	iwl_mvm_power_update_mac(mvm, vif);
+	iwl_mvm_power_update_mac(mvm);
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
 
 out_release:
@@ -1354,7 +1354,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, 0));
 	} else if (changes & (BSS_CHANGED_PS | BSS_CHANGED_P2P_PS |
 			      BSS_CHANGED_QOS)) {
-		ret = iwl_mvm_power_update_mac(mvm, vif);
+		ret = iwl_mvm_power_update_mac(mvm);
 		if (ret)
 			IWL_ERR(mvm, "failed to update power mode\n");
 	}
@@ -1423,7 +1423,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	mvmvif->ap_ibss_active = true;
 
 	/* power updated needs to be done before quotas */
-	iwl_mvm_power_update_mac(mvm, vif);
+	iwl_mvm_power_update_mac(mvm);
 
 	ret = iwl_mvm_update_quotas(mvm, vif);
 	if (ret)
@@ -1441,7 +1441,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	return 0;
 
 out_quota_failed:
-	iwl_mvm_power_update_mac(mvm, vif);
+	iwl_mvm_power_update_mac(mvm);
 	mvmvif->ap_ibss_active = false;
 	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
 out_unbind:
@@ -1477,7 +1477,7 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
 	iwl_mvm_binding_remove_vif(mvm, vif);
 
-	iwl_mvm_power_update_mac(mvm, vif);
+	iwl_mvm_power_update_mac(mvm);
 
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
 
@@ -2239,7 +2239,7 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 	 * Power state must be updated before quotas,
 	 * otherwise fw will complain.
 	 */
-	iwl_mvm_power_update_mac(mvm, vif);
+	iwl_mvm_power_update_mac(mvm);
 
 	/* Setting the quota at this stage is only required for monitor
 	 * interfaces. For the other types, the bss_info changed flow
@@ -2262,7 +2262,7 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 
  out_remove_binding:
 	iwl_mvm_binding_remove_vif(mvm, vif);
-	iwl_mvm_power_update_mac(mvm, vif);
+	iwl_mvm_power_update_mac(mvm);
  out_unlock:
 	mutex_unlock(&mvm->mutex);
 	if (ret)
@@ -2304,7 +2304,7 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 
 out_unlock:
 	mvmvif->phy_ctxt = NULL;
-	iwl_mvm_power_update_mac(mvm, vif);
+	iwl_mvm_power_update_mac(mvm);
 	mutex_unlock(&mvm->mutex);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 4b7461e..fcc6c29 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -894,7 +894,7 @@ int rs_pretty_print_rate(char *buf, const u32 rate);
 
 /* power management */
 int iwl_mvm_power_update_device(struct iwl_mvm *mvm);
-int iwl_mvm_power_update_mac(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_power_update_mac(struct iwl_mvm *mvm);
 int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				 char *buf, int bufsz);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index b0b8f5c..c182a8b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -828,7 +828,7 @@ int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 	return ret;
 }
 
-int iwl_mvm_power_update_mac(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+int iwl_mvm_power_update_mac(struct iwl_mvm *mvm)
 {
 	struct iwl_mvm_vif *mvmvif;
 	struct iwl_power_vifs vifs = {};
@@ -868,11 +868,11 @@ int iwl_mvm_power_update_mac(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (!vifs.bf_vif)
 		return 0;
 
-	vif = vifs.bf_vif;
-	mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	mvmvif = iwl_mvm_vif_from_mac80211(vifs.bf_vif);
 
 	ba_enable = !(!mvmvif->pm_enabled || mvm->ps_disabled ||
-		      !vif->bss_conf.ps || iwl_mvm_vif_low_latency(mvmvif));
+		      !vifs.bf_vif->bss_conf.ps ||
+		      iwl_mvm_vif_low_latency(mvmvif));
 
 	return iwl_mvm_update_beacon_abort(mvm, vifs.bf_vif, ba_enable);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 01ad730..aa9fc77 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -702,7 +702,7 @@ int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	iwl_mvm_bt_coex_vif_change(mvm);
 
-	return iwl_mvm_power_update_mac(mvm, vif);
+	return iwl_mvm_power_update_mac(mvm);
 }
 
 static void iwl_mvm_ll_iter(void *_data, u8 *mac, struct ieee80211_vif *vif)
-- 
1.8.3.2

