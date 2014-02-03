Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:49686 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaBCU7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:50 -0500
Received: by mail-ee0-f52.google.com with SMTP id e53so3886382eek.39
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:49 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 60/62] iwlwifi: mvm: remove support for legacy power API
Date: Mon,  3 Feb 2014 22:58:06 +0200
Message-Id: <1391461088-8082-60-git-send-email-egrumbach@gmail.com> (sfid-20140203_220008_181302_ECA62C70)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

If the driver detects old firmware, we disable support for
power management.
This greatly simplifies the code.

Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/Makefile       |    2 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c           |    4 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c  |    7 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      |    2 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c           |    8 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |   31 +--
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |   62 +----
 drivers/net/wireless/iwlwifi/mvm/ops.c          |    5 -
 drivers/net/wireless/iwlwifi/mvm/power.c        |   54 ++--
 drivers/net/wireless/iwlwifi/mvm/power_legacy.c |  319 -----------------------
 drivers/net/wireless/iwlwifi/mvm/utils.c        |    2 +-
 11 files changed, 62 insertions(+), 434 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/mvm/power_legacy.c

diff --git a/drivers/net/wireless/iwlwifi/mvm/Makefile b/drivers/net/wireless/iwlwifi/mvm/Makefile
index f98ec2b..41d390f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/iwlwifi/mvm/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_IWLMVM)   += iwlmvm.o
 iwlmvm-y += fw.o mac80211.o nvm.o ops.o phy-ctxt.o mac-ctxt.o
 iwlmvm-y += utils.o rx.o tx.o binding.o quota.o sta.o sf.o
 iwlmvm-y += scan.o time-event.o rs.o
-iwlmvm-y += power.o power_legacy.o bt-coex.o
+iwlmvm-y += power.o bt-coex.o
 iwlmvm-y += led.o tt.o
 iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o debugfs-vif.o
 iwlmvm-$(CONFIG_PM_SLEEP) += d3.o
diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index f36a7ee..a9850aa 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1191,11 +1191,11 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	if (ret)
 		goto out;
 
-	ret = iwl_mvm_power_update_device_mode(mvm);
+	ret = iwl_mvm_power_update_device(mvm);
 	if (ret)
 		goto out;
 
-	ret = iwl_mvm_power_update_mode(mvm, vif);
+	ret = iwl_mvm_power_mac_update_mode(mvm, vif);
 	if (ret)
 		goto out;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index a46895e..9c0708e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -185,7 +185,7 @@ static ssize_t iwl_dbgfs_pm_params_write(struct ieee80211_vif *vif, char *buf,
 
 	mutex_lock(&mvm->mutex);
 	iwl_dbgfs_update_pm(mvm, vif, param, val);
-	ret = iwl_mvm_power_update_mode(mvm, vif);
+	ret = iwl_mvm_power_mac_update_mode(mvm, vif);
 	mutex_unlock(&mvm->mutex);
 
 	return ret ?: count;
@@ -202,7 +202,7 @@ static ssize_t iwl_dbgfs_pm_params_read(struct file *file,
 	int bufsz = sizeof(buf);
 	int pos;
 
-	pos = iwl_mvm_power_dbgfs_read(mvm, vif, buf, bufsz);
+	pos = iwl_mvm_power_mac_dbgfs_read(mvm, vif, buf, bufsz);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
@@ -587,7 +587,8 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		return;
 	}
 
-	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM &&
+	if ((mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT) &&
+	    iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM &&
 	    ((vif->type == NL80211_IFTYPE_STATION && !vif->p2p) ||
 	     (vif->type == NL80211_IFTYPE_STATION && vif->p2p &&
 	      mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PS)))
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index c116765..6853e5e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -250,7 +250,7 @@ static ssize_t iwl_dbgfs_disable_power_off_write(struct iwl_mvm *mvm, char *buf,
 	}
 
 	mutex_lock(&mvm->mutex);
-	ret = iwl_mvm_power_update_device_mode(mvm);
+	ret = iwl_mvm_power_update_device(mvm);
 	mutex_unlock(&mvm->mutex);
 
 	return ret ?: count;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 212ffec..155bb20 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -442,7 +442,13 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	/* Initialize tx backoffs to the minimal possible */
 	iwl_mvm_tt_tx_backoff(mvm, 0);
 
-	ret = iwl_mvm_power_update_device_mode(mvm);
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT)) {
+		ret = iwl_power_legacy_set_cam_mode(mvm);
+		if (ret)
+			goto error;
+	}
+
+	ret = iwl_mvm_power_update_device(mvm);
 	if (ret)
 		goto error;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 43dd644..01b4500 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -636,14 +636,6 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&mvm->async_handlers_wk);
 }
 
-static void iwl_mvm_power_update_iterator(void *data, u8 *mac,
-					  struct ieee80211_vif *vif)
-{
-	struct iwl_mvm *mvm = data;
-
-	iwl_mvm_power_update_mode(mvm, vif);
-}
-
 static struct iwl_mvm_phy_ctxt *iwl_mvm_get_free_phy_ctxt(struct iwl_mvm *mvm)
 {
 	u16 i;
@@ -725,7 +717,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_release;
 
-	iwl_mvm_power_disable(mvm, vif);
+	iwl_mvm_power_mac_disable(mvm, vif);
 
 	/* beacon filtering */
 	ret = iwl_mvm_disable_beacon_filter(mvm, vif, CMD_SYNC);
@@ -787,11 +779,6 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (vif->type != NL80211_IFTYPE_P2P_DEVICE)
 		mvm->vif_count--;
 
-	/* TODO: remove this when legacy PM will be discarded */
-	ieee80211_iterate_active_interfaces(
-		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-		iwl_mvm_power_update_iterator, mvm);
-
 	iwl_mvm_mac_ctxt_release(mvm, vif);
  out_unlock:
 	mutex_unlock(&mvm->mutex);
@@ -880,11 +867,6 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 	if (mvm->vif_count && vif->type != NL80211_IFTYPE_P2P_DEVICE)
 		mvm->vif_count--;
 
-	/* TODO: remove this when legacy PM will be discarded */
-	ieee80211_iterate_active_interfaces(
-		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-		iwl_mvm_power_update_iterator, mvm);
-
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
 
 out_release:
@@ -1237,15 +1219,6 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		/* reset rssi values */
 		mvmvif->bf_data.ave_beacon_signal = 0;
 
-		if (!(mvm->fw->ucode_capa.flags &
-					IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT)) {
-			/* Workaround for FW bug, otherwise FW disables device
-			 * power save upon disassociation
-			 */
-			ret = iwl_mvm_power_update_mode(mvm, vif);
-			if (ret)
-				IWL_ERR(mvm, "failed to update power mode\n");
-		}
 		iwl_mvm_bt_coex_vif_change(mvm);
 		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_TT,
 				    IEEE80211_SMPS_AUTOMATIC);
@@ -1258,7 +1231,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 					  &mvmvif->time_event_data);
 	} else if (changes & (BSS_CHANGED_PS | BSS_CHANGED_P2P_PS |
 			      BSS_CHANGED_QOS)) {
-		ret = iwl_mvm_power_update_mode(mvm, vif);
+		ret = iwl_mvm_power_mac_update_mode(mvm, vif);
 		if (ret)
 			IWL_ERR(mvm, "failed to update power mode\n");
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 2d76e228..0c12c32 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -92,7 +92,6 @@ enum iwl_mvm_tx_fifo {
 };
 
 extern struct ieee80211_ops iwl_mvm_hw_ops;
-extern const struct iwl_mvm_power_ops pm_legacy_ops;
 extern const struct iwl_mvm_power_ops pm_mac_ops;
 
 /**
@@ -159,20 +158,6 @@ enum iwl_power_scheme {
 					 IEEE80211_WMM_IE_STA_QOSINFO_AC_BE)
 #define IWL_UAPSD_MAX_SP		IEEE80211_WMM_IE_STA_QOSINFO_SP_2
 
-struct iwl_mvm_power_ops {
-	int (*power_update_mode)(struct iwl_mvm *mvm,
-				 struct ieee80211_vif *vif);
-	int (*power_update_device_mode)(struct iwl_mvm *mvm);
-	int (*power_disable)(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-	void (*power_update_binding)(struct iwl_mvm *mvm,
-				     struct ieee80211_vif *vif, bool assign);
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	int (*power_dbgfs_read)(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-				char *buf, int bufsz);
-#endif
-};
-
-
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 enum iwl_dbgfs_pm_mask {
 	MVM_DEBUGFS_PM_KEEP_ALIVE = BIT(0),
@@ -590,8 +575,6 @@ struct iwl_mvm {
 	struct iwl_mvm_tt_mgmt thermal_throttle;
 	s32 temperature;	/* Celsius */
 
-	const struct iwl_mvm_power_ops *pm_ops;
-
 #ifdef CONFIG_NL80211_TESTMODE
 	u32 noa_duration;
 	struct ieee80211_vif *noa_vif;
@@ -826,48 +809,23 @@ iwl_mvm_vif_dbgfs_clean(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 /* rate scaling */
 int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq, bool init);
 
-/* power managment */
-static inline int iwl_mvm_power_update_mode(struct iwl_mvm *mvm,
-					    struct ieee80211_vif *vif)
-{
-	return mvm->pm_ops->power_update_mode(mvm, vif);
-}
+/* power management */
+int iwl_power_legacy_set_cam_mode(struct iwl_mvm *mvm);
 
-static inline int iwl_mvm_power_disable(struct iwl_mvm *mvm,
-					struct ieee80211_vif *vif)
-{
-	return mvm->pm_ops->power_disable(mvm, vif);
-}
-
-static inline int iwl_mvm_power_update_device_mode(struct iwl_mvm *mvm)
-{
-	if (mvm->pm_ops->power_update_device_mode)
-		return mvm->pm_ops->power_update_device_mode(mvm);
-	return 0;
-}
-
-static inline void iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
-						struct ieee80211_vif *vif,
-						bool assign)
-{
-	if (mvm->pm_ops->power_update_binding)
-		mvm->pm_ops->power_update_binding(mvm, vif, assign);
-}
+int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
+				  struct ieee80211_vif *vif);
+int iwl_mvm_power_mac_disable(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_power_update_device(struct iwl_mvm *mvm);
+void iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
+				  struct ieee80211_vif *vif, bool assign);
+int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+				 char *buf, int bufsz);
 
 void iwl_mvm_power_vif_assoc(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
 					     struct iwl_rx_cmd_buffer *rxb,
 					     struct iwl_device_cmd *cmd);
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-static inline int iwl_mvm_power_dbgfs_read(struct iwl_mvm *mvm,
-					    struct ieee80211_vif *vif,
-					    char *buf, int bufsz)
-{
-	return mvm->pm_ops->power_dbgfs_read(mvm, vif, buf, bufsz);
-}
-#endif
-
 int iwl_mvm_leds_init(struct iwl_mvm *mvm);
 void iwl_mvm_leds_exit(struct iwl_mvm *mvm);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index e268c15..a46f0b8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -496,11 +496,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	if (err)
 		goto out_unregister;
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT)
-		mvm->pm_ops = &pm_mac_ops;
-	else
-		mvm->pm_ops = &pm_legacy_ops;
-
 	memset(&mvm->rx_stats, 0, sizeof(struct mvm_statistics_rx));
 
 	/* rpm starts with a taken ref. only set the appropriate bit here. */
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index ac6d2c8..2eea5b3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -439,14 +439,17 @@ static int _iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
 				    sizeof(cmd), &cmd);
 }
 
-static int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
-					 struct ieee80211_vif *vif)
+int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
+				  struct ieee80211_vif *vif)
 
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	bool ba_enable;
 	int ret;
 
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT))
+		return 0;
+
 	ret = _iwl_mvm_power_mac_update_mode(mvm, vif);
 	if (ret)
 		return ret;
@@ -458,13 +461,15 @@ static int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
 	return iwl_mvm_update_beacon_abort(mvm, vif, ba_enable);
 }
 
-static int iwl_mvm_power_mac_disable(struct iwl_mvm *mvm,
-				     struct ieee80211_vif *vif)
+int iwl_mvm_power_mac_disable(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 	struct iwl_mac_power_cmd cmd = {};
 	struct iwl_mvm_vif *mvmvif __maybe_unused =
 		iwl_mvm_vif_from_mac80211(vif);
 
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT))
+		return 0;
+
 	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
 		return 0;
 
@@ -513,8 +518,11 @@ static int _iwl_mvm_power_update_device(struct iwl_mvm *mvm, bool force_disable)
 				    &cmd);
 }
 
-static int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
+int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
 {
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT))
+		return 0;
+
 	return _iwl_mvm_power_update_device(mvm, false);
 }
 
@@ -577,9 +585,8 @@ static void iwl_mvm_power_binding_iterator(void *_data, u8 *mac,
 	WARN_ONCE(ret, "Failed to update power parameters on a specific vif\n");
 }
 
-static void _iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
-					  struct ieee80211_vif *vif,
-					  bool assign)
+void iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
+				  struct ieee80211_vif *vif, bool assign)
 {
 	bool ba_enable;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
@@ -589,6 +596,9 @@ static void _iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT))
+		return;
+
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
 		int ret = _iwl_mvm_power_update_device(mvm, assign);
 		mvm->ps_prevented = assign;
@@ -615,14 +625,18 @@ static void _iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-static int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
-					struct ieee80211_vif *vif, char *buf,
-					int bufsz)
+int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
+				 struct ieee80211_vif *vif, char *buf,
+				 int bufsz)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mac_power_cmd cmd = {};
 	int pos = 0;
 
+	if (WARN_ON(!(mvm->fw->ucode_capa.flags &
+		      IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT)))
+		return 0;
+
 	mutex_lock(&mvm->mutex);
 	memcpy(&cmd, &mvmvif->mac_pwr_cmd, sizeof(cmd));
 	mutex_unlock(&mvm->mutex);
@@ -863,12 +877,12 @@ int iwl_mvm_update_beacon_filter(struct iwl_mvm *mvm,
 	return iwl_mvm_enable_beacon_filter(mvm, vif, flags);
 }
 
-const struct iwl_mvm_power_ops pm_mac_ops = {
-	.power_update_mode = iwl_mvm_power_mac_update_mode,
-	.power_update_device_mode = iwl_mvm_power_update_device,
-	.power_disable = iwl_mvm_power_mac_disable,
-	.power_update_binding = _iwl_mvm_power_update_binding,
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	.power_dbgfs_read = iwl_mvm_power_mac_dbgfs_read,
-#endif
-};
+int iwl_power_legacy_set_cam_mode(struct iwl_mvm *mvm)
+{
+	struct iwl_powertable_cmd cmd = {
+		.keep_alive_seconds = POWER_KEEP_ALIVE_PERIOD_SEC,
+	};
+
+	return iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, CMD_SYNC,
+				    sizeof(cmd), &cmd);
+}
diff --git a/drivers/net/wireless/iwlwifi/mvm/power_legacy.c b/drivers/net/wireless/iwlwifi/mvm/power_legacy.c
deleted file mode 100644
index ef712ae..0000000
--- a/drivers/net/wireless/iwlwifi/mvm/power_legacy.c
+++ /dev/null
@@ -1,319 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called COPYING.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/init.h>
-
-#include <net/mac80211.h>
-
-#include "iwl-debug.h"
-#include "mvm.h"
-#include "iwl-modparams.h"
-#include "fw-api-power.h"
-
-#define POWER_KEEP_ALIVE_PERIOD_SEC    25
-
-static void iwl_mvm_power_log(struct iwl_mvm *mvm,
-			      struct iwl_powertable_cmd *cmd)
-{
-	IWL_DEBUG_POWER(mvm,
-			"Sending power table command for power level %d, flags = 0x%X\n",
-			iwlmvm_mod_params.power_scheme,
-			le16_to_cpu(cmd->flags));
-	IWL_DEBUG_POWER(mvm, "Keep alive = %u sec\n", cmd->keep_alive_seconds);
-
-	if (cmd->flags & cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK)) {
-		IWL_DEBUG_POWER(mvm, "Rx timeout = %u usec\n",
-				le32_to_cpu(cmd->rx_data_timeout));
-		IWL_DEBUG_POWER(mvm, "Tx timeout = %u usec\n",
-				le32_to_cpu(cmd->tx_data_timeout));
-		if (cmd->flags & cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK))
-			IWL_DEBUG_POWER(mvm, "DTIM periods to skip = %u\n",
-					le32_to_cpu(cmd->skip_dtim_periods));
-		if (cmd->flags & cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK))
-			IWL_DEBUG_POWER(mvm, "LP RX RSSI threshold = %u\n",
-					le32_to_cpu(cmd->lprx_rssi_threshold));
-	}
-}
-
-static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
-				    struct ieee80211_vif *vif,
-				    struct iwl_powertable_cmd *cmd)
-{
-	struct ieee80211_hw *hw = mvm->hw;
-	struct ieee80211_chanctx_conf *chanctx_conf;
-	struct ieee80211_channel *chan;
-	int dtimper, dtimper_msec;
-	int keep_alive;
-	bool radar_detect = false;
-	struct iwl_mvm_vif *mvmvif __maybe_unused =
-		iwl_mvm_vif_from_mac80211(vif);
-
-	/*
-	 * Regardless of power management state the driver must set
-	 * keep alive period. FW will use it for sending keep alive NDPs
-	 * immediately after association.
-	 */
-	cmd->keep_alive_seconds = POWER_KEEP_ALIVE_PERIOD_SEC;
-
-	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM)
-		return;
-
-	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
-	if (!vif->bss_conf.assoc)
-		cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_DISABLE_POWER_OFF &&
-	    mvmvif->dbgfs_pm.disable_power_off)
-		cmd->flags &= cpu_to_le16(~POWER_FLAGS_POWER_SAVE_ENA_MSK);
-#endif
-	if (!vif->bss_conf.ps)
-		return;
-
-	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
-
-	if (vif->bss_conf.beacon_rate &&
-	    (vif->bss_conf.beacon_rate->bitrate == 10 ||
-	     vif->bss_conf.beacon_rate->bitrate == 60)) {
-		cmd->flags |= cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK);
-		cmd->lprx_rssi_threshold =
-			cpu_to_le32(POWER_LPRX_RSSI_THRESHOLD);
-	}
-
-	dtimper = hw->conf.ps_dtim_period ?: 1;
-
-	/* Check if radar detection is required on current channel */
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(vif->chanctx_conf);
-	WARN_ON(!chanctx_conf);
-	if (chanctx_conf) {
-		chan = chanctx_conf->def.chan;
-		radar_detect = chan->flags & IEEE80211_CHAN_RADAR;
-	}
-	rcu_read_unlock();
-
-	/* Check skip over DTIM conditions */
-	if (!radar_detect && (dtimper <= 10) &&
-	    (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_LP ||
-	     mvm->cur_ucode == IWL_UCODE_WOWLAN)) {
-		cmd->flags |= cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
-		cmd->skip_dtim_periods = cpu_to_le32(3);
-	}
-
-	/* Check that keep alive period is at least 3 * DTIM */
-	dtimper_msec = dtimper * vif->bss_conf.beacon_int;
-	keep_alive = max_t(int, 3 * dtimper_msec,
-			   MSEC_PER_SEC * cmd->keep_alive_seconds);
-	keep_alive = DIV_ROUND_UP(keep_alive, MSEC_PER_SEC);
-	cmd->keep_alive_seconds = keep_alive;
-
-	if (mvm->cur_ucode != IWL_UCODE_WOWLAN) {
-		cmd->rx_data_timeout = cpu_to_le32(100 * USEC_PER_MSEC);
-		cmd->tx_data_timeout = cpu_to_le32(100 * USEC_PER_MSEC);
-	} else {
-		cmd->rx_data_timeout = cpu_to_le32(10 * USEC_PER_MSEC);
-		cmd->tx_data_timeout = cpu_to_le32(10 * USEC_PER_MSEC);
-	}
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_KEEP_ALIVE)
-		cmd->keep_alive_seconds = mvmvif->dbgfs_pm.keep_alive_seconds;
-	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_SKIP_OVER_DTIM) {
-		if (mvmvif->dbgfs_pm.skip_over_dtim)
-			cmd->flags |=
-				cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
-		else
-			cmd->flags &=
-				cpu_to_le16(~POWER_FLAGS_SKIP_OVER_DTIM_MSK);
-	}
-	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_RX_DATA_TIMEOUT)
-		cmd->rx_data_timeout =
-			cpu_to_le32(mvmvif->dbgfs_pm.rx_data_timeout);
-	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_TX_DATA_TIMEOUT)
-		cmd->tx_data_timeout =
-			cpu_to_le32(mvmvif->dbgfs_pm.tx_data_timeout);
-	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_SKIP_DTIM_PERIODS)
-		cmd->skip_dtim_periods =
-			cpu_to_le32(mvmvif->dbgfs_pm.skip_dtim_periods);
-	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_LPRX_ENA) {
-		if (mvmvif->dbgfs_pm.lprx_ena)
-			cmd->flags |= cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK);
-		else
-			cmd->flags &= cpu_to_le16(~POWER_FLAGS_LPRX_ENA_MSK);
-	}
-	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_LPRX_RSSI_THRESHOLD)
-		cmd->lprx_rssi_threshold =
-			cpu_to_le32(mvmvif->dbgfs_pm.lprx_rssi_threshold);
-#endif /* CONFIG_IWLWIFI_DEBUGFS */
-}
-
-static int iwl_mvm_power_legacy_update_mode(struct iwl_mvm *mvm,
-					    struct ieee80211_vif *vif)
-{
-	int ret;
-	bool ba_enable;
-	struct iwl_powertable_cmd cmd = {};
-
-	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
-		return 0;
-
-	/*
-	 * TODO: The following vif_count verification is temporary condition.
-	 * Avoid power mode update if more than one interface is currently
-	 * active. Remove this condition when FW will support power management
-	 * on multiple MACs.
-	 */
-	IWL_DEBUG_POWER(mvm, "Currently %d interfaces active\n",
-			mvm->vif_count);
-	if (mvm->vif_count > 1)
-		return 0;
-
-	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
-	iwl_mvm_power_log(mvm, &cmd);
-
-	ret = iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, CMD_SYNC,
-				   sizeof(cmd), &cmd);
-	if (ret)
-		return ret;
-
-	ba_enable = !!(cmd.flags &
-		       cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK));
-
-	return iwl_mvm_update_beacon_abort(mvm, vif, ba_enable);
-}
-
-static int iwl_mvm_power_legacy_disable(struct iwl_mvm *mvm,
-					struct ieee80211_vif *vif)
-{
-	struct iwl_powertable_cmd cmd = {};
-	struct iwl_mvm_vif *mvmvif __maybe_unused =
-		iwl_mvm_vif_from_mac80211(vif);
-
-	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
-		return 0;
-
-	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM)
-		cmd.flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (mvmvif->dbgfs_pm.mask & MVM_DEBUGFS_PM_DISABLE_POWER_OFF &&
-	    mvmvif->dbgfs_pm.disable_power_off)
-		cmd.flags &= cpu_to_le16(~POWER_FLAGS_POWER_SAVE_ENA_MSK);
-#endif
-	iwl_mvm_power_log(mvm, &cmd);
-
-	return iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, CMD_ASYNC,
-				    sizeof(cmd), &cmd);
-}
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-static int iwl_mvm_power_legacy_dbgfs_read(struct iwl_mvm *mvm,
-					   struct ieee80211_vif *vif, char *buf,
-					   int bufsz)
-{
-	struct iwl_powertable_cmd cmd = {};
-	int pos = 0;
-
-	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
-
-	pos += scnprintf(buf+pos, bufsz-pos, "disable_power_off = %d\n",
-			 (cmd.flags &
-			 cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK)) ?
-			 0 : 1);
-	pos += scnprintf(buf+pos, bufsz-pos, "skip_dtim_periods = %d\n",
-			 le32_to_cpu(cmd.skip_dtim_periods));
-	pos += scnprintf(buf+pos, bufsz-pos, "power_scheme = %d\n",
-			 iwlmvm_mod_params.power_scheme);
-	pos += scnprintf(buf+pos, bufsz-pos, "flags = 0x%x\n",
-			 le16_to_cpu(cmd.flags));
-	pos += scnprintf(buf+pos, bufsz-pos, "keep_alive = %d\n",
-			 cmd.keep_alive_seconds);
-
-	if (cmd.flags & cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK)) {
-		pos += scnprintf(buf+pos, bufsz-pos, "skip_over_dtim = %d\n",
-				 (cmd.flags &
-				 cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK)) ?
-				 1 : 0);
-		pos += scnprintf(buf+pos, bufsz-pos, "rx_data_timeout = %d\n",
-				 le32_to_cpu(cmd.rx_data_timeout));
-		pos += scnprintf(buf+pos, bufsz-pos, "tx_data_timeout = %d\n",
-				 le32_to_cpu(cmd.tx_data_timeout));
-		if (cmd.flags & cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK))
-			pos += scnprintf(buf+pos, bufsz-pos,
-					 "lprx_rssi_threshold = %d\n",
-					 le32_to_cpu(cmd.lprx_rssi_threshold));
-	}
-	return pos;
-}
-#endif
-
-const struct iwl_mvm_power_ops pm_legacy_ops = {
-	.power_update_mode = iwl_mvm_power_legacy_update_mode,
-	.power_disable = iwl_mvm_power_legacy_disable,
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	.power_dbgfs_read = iwl_mvm_power_legacy_dbgfs_read,
-#endif
-};
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index b216232..d4d9010 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -564,5 +564,5 @@ int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	iwl_mvm_bt_coex_vif_change(mvm);
 
-	return iwl_mvm_power_update_mode(mvm, vif);
+	return iwl_mvm_power_mac_update_mode(mvm, vif);
 }
-- 
1.7.9.5

