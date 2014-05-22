Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:39167 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbaEVHYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:24:19 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so3012512wgh.14
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 00:24:18 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/11] iwlwifi: mvm: make iwl_mvm_update_beacon_abort static
Date: Thu, 22 May 2014 10:23:54 +0300
Message-Id: <1400743435-702-10-git-send-email-egrumbach@gmail.com> (sfid-20140522_095147_527490_B0F430B1)
In-Reply-To: <537DA58C.5050003@gmail.com>
References: <537DA58C.5050003@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h   |   2 -
 drivers/net/wireless/iwlwifi/mvm/power.c | 103 ++++++++++++++++---------------
 2 files changed, 52 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 20884b7..4b7461e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -997,8 +997,6 @@ int iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
 int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 				  struct ieee80211_vif *vif,
 				  u32 flags);
-int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
-				struct ieee80211_vif *vif, bool enable);
 /* SMPS */
 void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				enum iwl_mvm_smps_type_request req_type,
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index a2b426b..b0b8f5c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -642,55 +642,6 @@ iwl_mvm_power_set_pm(struct iwl_mvm *mvm,
 	}
 }
 
-int iwl_mvm_power_update_mac(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
-{
-	struct iwl_mvm_vif *mvmvif;
-	struct iwl_power_vifs vifs = {};
-	bool ba_enable;
-	int ret;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	iwl_mvm_power_set_pm(mvm, &vifs);
-
-	/* disable PS if CAM */
-	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM) {
-		mvm->ps_disabled = true;
-	} else {
-	/* don't update device power state unless we add / remove monitor */
-		if (vifs.monitor_vif) {
-			if (vifs.monitor_active)
-				mvm->ps_disabled = true;
-			ret = iwl_mvm_power_update_device(mvm);
-			if (ret)
-				return ret;
-		}
-	}
-
-	if (vifs.bss_vif) {
-		ret = iwl_mvm_power_send_cmd(mvm, vifs.bss_vif);
-		if (ret)
-			return ret;
-	}
-
-	if (vifs.p2p_vif) {
-		ret = iwl_mvm_power_send_cmd(mvm, vifs.p2p_vif);
-		if (ret)
-			return ret;
-	}
-
-	if (!vifs.bf_vif)
-		return 0;
-
-	vif = vifs.bf_vif;
-	mvmvif = iwl_mvm_vif_from_mac80211(vif);
-
-	ba_enable = !(!mvmvif->pm_enabled || mvm->ps_disabled ||
-		      !vif->bss_conf.ps || iwl_mvm_vif_low_latency(mvmvif));
-
-	return iwl_mvm_update_beacon_abort(mvm, vifs.bf_vif, ba_enable);
-}
-
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
 				 struct ieee80211_vif *vif, char *buf,
@@ -838,8 +789,9 @@ int iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
 	return _iwl_mvm_enable_beacon_filter(mvm, vif, &cmd, flags, false);
 }
 
-int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
-				struct ieee80211_vif *vif, bool enable)
+static int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
+				       struct ieee80211_vif *vif,
+				       bool enable)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_beacon_filter_cmd cmd = {
@@ -876,6 +828,55 @@ int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 	return ret;
 }
 
+int iwl_mvm_power_update_mac(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif;
+	struct iwl_power_vifs vifs = {};
+	bool ba_enable;
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	iwl_mvm_power_set_pm(mvm, &vifs);
+
+	/* disable PS if CAM */
+	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM) {
+		mvm->ps_disabled = true;
+	} else {
+	/* don't update device power state unless we add / remove monitor */
+		if (vifs.monitor_vif) {
+			if (vifs.monitor_active)
+				mvm->ps_disabled = true;
+			ret = iwl_mvm_power_update_device(mvm);
+			if (ret)
+				return ret;
+		}
+	}
+
+	if (vifs.bss_vif) {
+		ret = iwl_mvm_power_send_cmd(mvm, vifs.bss_vif);
+		if (ret)
+			return ret;
+	}
+
+	if (vifs.p2p_vif) {
+		ret = iwl_mvm_power_send_cmd(mvm, vifs.p2p_vif);
+		if (ret)
+			return ret;
+	}
+
+	if (!vifs.bf_vif)
+		return 0;
+
+	vif = vifs.bf_vif;
+	mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	ba_enable = !(!mvmvif->pm_enabled || mvm->ps_disabled ||
+		      !vif->bss_conf.ps || iwl_mvm_vif_low_latency(mvmvif));
+
+	return iwl_mvm_update_beacon_abort(mvm, vifs.bf_vif, ba_enable);
+}
+
 int iwl_mvm_update_d0i3_power_mode(struct iwl_mvm *mvm,
 				   struct ieee80211_vif *vif,
 				   bool enable, u32 flags)
-- 
1.8.3.2

