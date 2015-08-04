Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132AbbHDU7Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:16 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/37] iwlwifi: add wide firmware command support for notifications
Date: Tue,  4 Aug 2015 23:43:24 +0300
Message-Id: <1438721007-23283-34-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230716_928213_C970D917)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Add support for extended command id in notification system.
Extended command id header contains group id in addition to command id.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c   | 2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c       | 3 ++-
 drivers/net/wireless/iwlwifi/dvm/ucode.c      | 5 +++--
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c | 8 +++++---
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h | 5 +++--
 drivers/net/wireless/iwlwifi/iwl-trans.h      | 3 +++
 drivers/net/wireless/iwlwifi/mvm/d3.c         | 2 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c         | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   | 2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c       | 2 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/tt.c         | 3 ++-
 12 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index f603fb3..453f7c3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -444,7 +444,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 		u32 error_id;
 	} err_info;
 	struct iwl_notification_wait status_wait;
-	static const u8 status_cmd[] = {
+	static const u16 status_cmd[] = {
 		REPLY_WOWLAN_GET_STATUS,
 	};
 	struct iwlagn_wowlan_status status_data = {};
diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index ed50de6..85ceceb 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -123,7 +124,7 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 	__le32 old_filter = send->filter_flags;
 	u8 old_dev_type = send->dev_type;
 	int ret;
-	static const u8 deactivate_cmd[] = {
+	static const u16 deactivate_cmd[] = {
 		REPLY_WIPAN_DEACTIVATION_COMPLETE
 	};
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index 5244e43..931a8e4 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -3,6 +3,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -327,7 +328,7 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	const struct fw_img *fw;
 	int ret;
 	enum iwl_ucode_type old_type;
-	static const u8 alive_cmd[] = { REPLY_ALIVE };
+	static const u16 alive_cmd[] = { REPLY_ALIVE };
 
 	fw = iwl_get_ucode_image(priv, ucode_type);
 	if (WARN_ON(!fw))
@@ -406,7 +407,7 @@ static bool iwlagn_wait_calib(struct iwl_notif_wait_data *notif_wait,
 int iwl_run_init_ucode(struct iwl_priv *priv)
 {
 	struct iwl_notification_wait calib_wait;
-	static const u8 calib_complete[] = {
+	static const u16 calib_complete[] = {
 		CALIBRATION_RES_NOTIFICATION,
 		CALIBRATION_COMPLETE_NOTIFICATION
 	};
diff --git a/drivers/net/wireless/iwlwifi/iwl-notif-wait.c b/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
index b5bc959..6caf2af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
+++ b/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -98,7 +99,8 @@ void iwl_notification_wait_notify(struct iwl_notif_wait_data *notif_wait,
 				continue;
 
 			for (i = 0; i < w->n_cmds; i++) {
-				if (w->cmds[i] == pkt->hdr.cmd) {
+				if (w->cmds[i] ==
+				    WIDE_ID(pkt->hdr.group_id, pkt->hdr.cmd)) {
 					found = true;
 					break;
 				}
@@ -136,7 +138,7 @@ IWL_EXPORT_SYMBOL(iwl_abort_notification_waits);
 void
 iwl_init_notification_wait(struct iwl_notif_wait_data *notif_wait,
 			   struct iwl_notification_wait *wait_entry,
-			   const u8 *cmds, int n_cmds,
+			   const u16 *cmds, int n_cmds,
 			   bool (*fn)(struct iwl_notif_wait_data *notif_wait,
 				      struct iwl_rx_packet *pkt, void *data),
 			   void *fn_data)
@@ -147,7 +149,7 @@ iwl_init_notification_wait(struct iwl_notif_wait_data *notif_wait,
 	wait_entry->fn = fn;
 	wait_entry->fn_data = fn_data;
 	wait_entry->n_cmds = n_cmds;
-	memcpy(wait_entry->cmds, cmds, n_cmds);
+	memcpy(wait_entry->cmds, cmds, n_cmds * sizeof(u16));
 	wait_entry->triggered = false;
 	wait_entry->aborted = false;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-notif-wait.h b/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
index 95af97a..dbe8234 100644
--- a/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
+++ b/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -105,7 +106,7 @@ struct iwl_notification_wait {
 		   struct iwl_rx_packet *pkt, void *data);
 	void *fn_data;
 
-	u8 cmds[MAX_NOTIF_CMDS];
+	u16 cmds[MAX_NOTIF_CMDS];
 	u8 n_cmds;
 	bool triggered, aborted;
 };
@@ -121,7 +122,7 @@ void iwl_abort_notification_waits(struct iwl_notif_wait_data *notif_data);
 void __acquires(wait_entry)
 iwl_init_notification_wait(struct iwl_notif_wait_data *notif_data,
 			   struct iwl_notification_wait *wait_entry,
-			   const u8 *cmds, int n_cmds,
+			   const u16 *cmds, int n_cmds,
 			   bool (*fn)(struct iwl_notif_wait_data *notif_data,
 				      struct iwl_rx_packet *pkt, void *data),
 			   void *fn_data);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index e698ed5..2f79e54 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -148,6 +148,9 @@ static inline u32 iwl_cmd_id(u8 opcode, u8 groupid, u8 version)
 	return opcode + (groupid << 8) + (version << 16);
 }
 
+/* make u16 wide id out of u8 group and opcode */
+#define WIDE_ID(grp, opcode) ((grp << 8) | opcode)
+
 /* due to the conversion, this group is special; new groups
  * should be defined in the appropriate fw-api header files
  */
diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index a85be4e..04264e4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1145,7 +1145,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 static int iwl_mvm_enter_d0i3_sync(struct iwl_mvm *mvm)
 {
 	struct iwl_notification_wait wait_d3;
-	static const u8 d3_notif[] = { D3_CONFIG_CMD };
+	static const u16 d3_notif[] = { D3_CONFIG_CMD };
 	int ret;
 
 	iwl_init_notification_wait(&mvm->notif_wait, &wait_d3,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index ebda61bc6..106edc7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -213,7 +213,7 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	const struct fw_img *fw;
 	int ret, i;
 	enum iwl_ucode_type old_type = mvm->cur_ucode;
-	static const u8 alive_cmd[] = { MVM_ALIVE };
+	static const u16 alive_cmd[] = { MVM_ALIVE };
 	struct iwl_sf_region st_fwrd_space;
 
 	if (ucode_type == IWL_UCODE_REGULAR &&
@@ -314,7 +314,7 @@ static int iwl_send_phy_cfg_cmd(struct iwl_mvm *mvm)
 int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 {
 	struct iwl_notification_wait calib_wait;
-	static const u8 init_complete[] = {
+	static const u16 init_complete[] = {
 		INIT_COMPLETE_NOTIF,
 		CALIB_RES_NOTIF_PHY_DB
 	};
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5a4bf84..9e64184 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3019,7 +3019,7 @@ static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
 	int res, time_reg = DEVICE_SYSTEM_TIME_REG;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->hs_time_event_data;
-	static const u8 time_event_response[] = { HOT_SPOT_CMD };
+	static const u16 time_event_response[] = { HOT_SPOT_CMD };
 	struct iwl_notification_wait wait_time_event;
 	struct iwl_hs20_roc_req aux_roc_req = {
 		.action = cpu_to_le32(FW_CTXT_ACTION_ADD),
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index d34b2e5..8d7fefe 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1395,7 +1395,7 @@ static int iwl_mvm_umac_scan_abort(struct iwl_mvm *mvm, int type)
 static int iwl_mvm_scan_stop_wait(struct iwl_mvm *mvm, int type)
 {
 	struct iwl_notification_wait wait_scan_done;
-	static const u8 scan_done_notif[] = { SCAN_COMPLETE_UMAC,
+	static const u16 scan_done_notif[] = { SCAN_COMPLETE_UMAC,
 					      SCAN_OFFLOAD_COMPLETE, };
 	int ret;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 8fe7ecd..c0d09af 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -500,7 +500,7 @@ static int iwl_mvm_time_event_send_add(struct iwl_mvm *mvm,
 				       struct iwl_mvm_time_event_data *te_data,
 				       struct iwl_time_event_cmd *te_cmd)
 {
-	static const u8 time_event_response[] = { TIME_EVENT_CMD };
+	static const u16 time_event_response[] = { TIME_EVENT_CMD };
 	struct iwl_notification_wait wait_time_event;
 	int ret;
 
@@ -563,7 +563,7 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->time_event_data;
-	const u8 te_notif_response[] = { TIME_EVENT_NOTIFICATION };
+	const u16 te_notif_response[] = { TIME_EVENT_NOTIFICATION };
 	struct iwl_notification_wait wait_te_notif;
 	struct iwl_time_event_cmd time_cmd = {};
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 7e88d39..fe7145c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -33,6 +33,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -183,7 +184,7 @@ static int iwl_mvm_get_temp_cmd(struct iwl_mvm *mvm)
 int iwl_mvm_get_temp(struct iwl_mvm *mvm)
 {
 	struct iwl_notification_wait wait_temp_notif;
-	static const u8 temp_notif[] = { DTS_MEASUREMENT_NOTIFICATION };
+	static const u16 temp_notif[] = { DTS_MEASUREMENT_NOTIFICATION };
 	int ret, temp;
 
 	lockdep_assert_held(&mvm->mutex);
-- 
2.1.4

