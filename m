Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:53341 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaBCU7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:51 -0500
Received: by mail-ea0-f180.google.com with SMTP id o10so3988893eaj.39
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:50 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 61/62] iwlwifi: mvm: remove iwl_mvm_power_mac_disable
Date: Mon,  3 Feb 2014 22:58:07 +0200
Message-Id: <1391461088-8082-61-git-send-email-egrumbach@gmail.com> (sfid-20140203_220010_347995_4419D973)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Its logic can be implemented with
iwl_mvm_power_mac_update_mode.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |    1 -
 drivers/net/wireless/iwlwifi/mvm/power.c    |   30 ---------------------------
 3 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 01b4500..9d29069 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -717,7 +717,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_release;
 
-	iwl_mvm_power_mac_disable(mvm, vif);
+	iwl_mvm_power_mac_update_mode(mvm, vif);
 
 	/* beacon filtering */
 	ret = iwl_mvm_disable_beacon_filter(mvm, vif, CMD_SYNC);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 0c12c32..bf6b602 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -814,7 +814,6 @@ int iwl_power_legacy_set_cam_mode(struct iwl_mvm *mvm);
 
 int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
 				  struct ieee80211_vif *vif);
-int iwl_mvm_power_mac_disable(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_power_update_device(struct iwl_mvm *mvm);
 void iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
 				  struct ieee80211_vif *vif, bool assign);
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 2eea5b3..5671b83 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -461,36 +461,6 @@ int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
 	return iwl_mvm_update_beacon_abort(mvm, vif, ba_enable);
 }
 
-int iwl_mvm_power_mac_disable(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
-{
-	struct iwl_mac_power_cmd cmd = {};
-	struct iwl_mvm_vif *mvmvif __maybe_unused =
-		iwl_mvm_vif_from_mac80211(vif);
-
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT))
-		return 0;
-
-	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
-		return 0;
-
-	cmd.id_and_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
-							   mvmvif->color));
-
-	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM)
-		cmd.flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_DISABLE_POWER_OFF &&
-	    mvmvif->dbgfs_pm.disable_power_off)
-		cmd.flags &= cpu_to_le16(~POWER_FLAGS_POWER_SAVE_ENA_MSK);
-	memcpy(&mvmvif->mac_pwr_cmd, &cmd, sizeof(cmd));
-#endif
-	iwl_mvm_power_log(mvm, &cmd);
-
-	return iwl_mvm_send_cmd_pdu(mvm, MAC_PM_POWER_TABLE, CMD_ASYNC,
-				    sizeof(cmd), &cmd);
-}
-
 static int _iwl_mvm_power_update_device(struct iwl_mvm *mvm, bool force_disable)
 {
 	struct iwl_device_power_cmd cmd = {
-- 
1.7.9.5

