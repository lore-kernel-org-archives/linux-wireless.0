Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:44733 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbaDMTUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:55 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so7202584wes.4
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:54 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/47] iwlwifi: remove IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT flag
Date: Sun, 13 Apr 2014 22:19:45 +0300
Message-Id: <1397416802-32403-30-git-send-email-egrumbach@gmail.com> (sfid-20140413_213514_794685_D3870B71)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares have this flag set.

Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h          |  1 -
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |  3 +--
 drivers/net/wireless/iwlwifi/mvm/fw.c          |  6 ------
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  2 --
 drivers/net/wireless/iwlwifi/mvm/power.c       | 20 --------------------
 5 files changed, 1 insertion(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 9cb4ad9..c9a3ca6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -107,7 +107,6 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_MFP			= BIT(2),
 	IWL_UCODE_TLV_FLAGS_P2P			= BIT(3),
 	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE		= BIT(4),
-	IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT	= BIT(6),
 	IWL_UCODE_TLV_FLAGS_SHORT_BL		= BIT(7),
 	IWL_UCODE_TLV_FLAGS_RX_ENERGY_API	= BIT(8),
 	IWL_UCODE_TLV_FLAGS_TIME_EVENT_API_V2	= BIT(9),
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 9b59e1d..d372ca6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -592,8 +592,7 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		return;
 	}
 
-	if ((mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT) &&
-	    iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM &&
+	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM &&
 	    ((vif->type == NL80211_IFTYPE_STATION && !vif->p2p) ||
 	     (vif->type == NL80211_IFTYPE_STATION && vif->p2p &&
 	      mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM)))
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 7ce2006..e7a2639 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -468,12 +468,6 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	/* Initialize tx backoffs to the minimal possible */
 	iwl_mvm_tt_tx_backoff(mvm, 0);
 
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT)) {
-		ret = iwl_power_legacy_set_cam_mode(mvm);
-		if (ret)
-			goto error;
-	}
-
 	ret = iwl_mvm_power_update_device(mvm);
 	if (ret)
 		goto error;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 9f2ecf2..a0fb7b1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -877,8 +877,6 @@ void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm,
 int rs_pretty_print_rate(char *buf, const u32 rate);
 
 /* power management */
-int iwl_power_legacy_set_cam_mode(struct iwl_mvm *mvm);
-
 int iwl_mvm_power_update_device(struct iwl_mvm *mvm);
 int iwl_mvm_power_update_mac(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index a1ce8d2..ab92a63 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -437,9 +437,6 @@ int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
 		.flags = cpu_to_le16(DEVICE_POWER_FLAGS_POWER_SAVE_ENA_MSK),
 	};
 
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT))
-		return 0;
-
 	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD))
 		return 0;
 
@@ -646,9 +643,6 @@ int iwl_mvm_power_update_mac(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT))
-		return 0;
-
 	iwl_mvm_power_set_pm(mvm, &vifs);
 
 	/* disable PS if CAM */
@@ -698,10 +692,6 @@ int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
 	struct iwl_mac_power_cmd cmd = {};
 	int pos = 0;
 
-	if (WARN_ON(!(mvm->fw->ucode_capa.flags &
-		      IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT)))
-		return 0;
-
 	mutex_lock(&mvm->mutex);
 	memcpy(&cmd, &mvmvif->mac_pwr_cmd, sizeof(cmd));
 	mutex_unlock(&mvm->mutex);
@@ -941,13 +931,3 @@ int iwl_mvm_update_beacon_filter(struct iwl_mvm *mvm,
 
 	return iwl_mvm_enable_beacon_filter(mvm, vif, flags);
 }
-
-int iwl_power_legacy_set_cam_mode(struct iwl_mvm *mvm)
-{
-	struct iwl_powertable_cmd cmd = {
-		.keep_alive_seconds = POWER_KEEP_ALIVE_PERIOD_SEC,
-	};
-
-	return iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, CMD_SYNC,
-				    sizeof(cmd), &cmd);
-}
-- 
1.8.3.2

