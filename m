Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbbEZTTN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:19:13 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 38/39] iwlwifi: mvm: implement the BlockAck related debug triggers
Date: Tue, 26 May 2015 22:17:51 +0300
Message-Id: <1432667872-18092-38-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211928_112414_4F2396BC)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BlockAck sessions can have events that are interesting to
debug. When we send or receive a BAR, it is may indicate
that something bad is happening. Even more so when mac80211
tells us that a frame timed out in the reodering buffer.
Add a few triggers for BlockAck session debugging.
Allow per-TID debugging.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c           |   6 +-
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |   6 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       |  27 +++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 140 ++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/tx.c            |  31 ++++-
 5 files changed, 200 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 7267152..12566c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1239,6 +1239,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		sizeof(struct iwl_fw_dbg_trigger_txq_timer);
 	trigger_tlv_sz[FW_DBG_TRIGGER_TIME_EVENT] =
 		sizeof(struct iwl_fw_dbg_trigger_time_event);
+	trigger_tlv_sz[FW_DBG_TRIGGER_BA] =
+		sizeof(struct iwl_fw_dbg_trigger_ba);
 
 	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_trigger_tlv); i++) {
 		if (pieces->dbg_trigger_tlv[i]) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 251bf8d..e57dbd0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2014 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2014 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -254,6 +254,7 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  *	detection.
  * @FW_DBG_TRIGGER_TIME_EVENT: trigger log collection upon time events related
  *	events.
+ * @FW_DBG_TRIGGER_BA: trigger log collection upon BlockAck related events.
  */
 enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_INVALID = 0,
@@ -267,6 +268,7 @@ enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_RSSI,
 	FW_DBG_TRIGGER_TXQ_TIMERS,
 	FW_DBG_TRIGGER_TIME_EVENT,
+	FW_DBG_TRIGGER_BA,
 
 	/* must be last */
 	FW_DBG_TRIGGER_MAX,
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 839b2c4..a8d0b64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -664,6 +664,33 @@ struct iwl_fw_dbg_trigger_time_event {
 } __packed;
 
 /**
+ * struct iwl_fw_dbg_trigger_ba - configures BlockAck related trigger
+ * rx_ba_start: tid bitmap to configure on what tid the trigger should occur
+ *	when an Rx BlockAck session is started.
+ * rx_ba_stop: tid bitmap to configure on what tid the trigger should occur
+ *	when an Rx BlockAck session is stopped.
+ * tx_ba_start: tid bitmap to configure on what tid the trigger should occur
+ *	when a Tx BlockAck session is started.
+ * tx_ba_stop: tid bitmap to configure on what tid the trigger should occur
+ *	when a Tx BlockAck session is stopped.
+ * rx_bar: tid bitmap to configure on what tid the trigger should occur
+ *	when a BAR is received (for a Tx BlockAck session).
+ * tx_bar: tid bitmap to configure on what tid the trigger should occur
+ *	when a BAR is send (for an Rx BlocAck session).
+ * frame_timeout: tid bitmap to configure on what tid the trigger should occur
+ *	when a frame times out in the reodering buffer.
+ */
+struct iwl_fw_dbg_trigger_ba {
+	__le16 rx_ba_start;
+	__le16 rx_ba_stop;
+	__le16 tx_ba_start;
+	__le16 tx_ba_stop;
+	__le16 rx_bar;
+	__le16 tx_bar;
+	__le16 frame_timeout;
+} __packed;
+
+/**
  * struct iwl_fw_dbg_conf_tlv - a TLV that describes a debug configuration.
  * @id: conf id
  * @usniffer: should the uSniffer image be used
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index cea2366..71b66cb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -737,6 +737,60 @@ static inline bool iwl_enable_tx_ampdu(const struct iwl_cfg *cfg)
 	return true;
 }
 
+#define CHECK_BA_TRIGGER(_mvm, _trig, _tid_bm, _tid, _fmt...)	\
+	do {							\
+		if (!(le16_to_cpu(_tid_bm) & BIT(_tid)))	\
+			break;					\
+		iwl_mvm_fw_dbg_collect_trig(_mvm, _trig, _fmt);	\
+	} while (0)
+
+static void
+iwl_mvm_ampdu_check_trigger(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta, u16 tid, u16 rx_ba_ssn,
+			    enum ieee80211_ampdu_mlme_action action)
+{
+	struct iwl_fw_dbg_trigger_tlv *trig;
+	struct iwl_fw_dbg_trigger_ba *ba_trig;
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_BA))
+		return;
+
+	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_BA);
+	ba_trig = (void *)trig->data;
+
+	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
+		return;
+
+	switch (action) {
+	case IEEE80211_AMPDU_TX_OPERATIONAL: {
+		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+		struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
+
+		CHECK_BA_TRIGGER(mvm, trig, ba_trig->tx_ba_start, tid,
+				 "TX AGG START: MAC %pM tid %d ssn %d\n",
+				 sta->addr, tid, tid_data->ssn);
+		break;
+		}
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+		CHECK_BA_TRIGGER(mvm, trig, ba_trig->tx_ba_stop, tid,
+				 "TX AGG STOP: MAC %pM tid %d\n",
+				 sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_RX_START:
+		CHECK_BA_TRIGGER(mvm, trig, ba_trig->rx_ba_start, tid,
+				 "RX AGG START: MAC %pM tid %d ssn %d\n",
+				 sta->addr, tid, rx_ba_ssn);
+		break;
+	case IEEE80211_AMPDU_RX_STOP:
+		CHECK_BA_TRIGGER(mvm, trig, ba_trig->rx_ba_stop, tid,
+				 "RX AGG STOP: MAC %pM tid %d\n",
+				 sta->addr, tid);
+		break;
+	default:
+		break;
+	}
+}
+
 static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    enum ieee80211_ampdu_mlme_action action,
@@ -813,6 +867,16 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 		ret = -EINVAL;
 		break;
 	}
+
+	if (!ret) {
+		u16 rx_ba_ssn = 0;
+
+		if (action == IEEE80211_AMPDU_RX_START)
+			rx_ba_ssn = *ssn;
+
+		iwl_mvm_ampdu_check_trigger(mvm, vif, sta, tid,
+					    rx_ba_ssn, action);
+	}
 	mutex_unlock(&mvm->mutex);
 
 	/*
@@ -3904,9 +3968,9 @@ static void iwl_mvm_mac_sta_statistics(struct ieee80211_hw *hw,
 	mutex_unlock(&mvm->mutex);
 }
 
-static void iwl_mvm_mac_event_callback(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
-				       const struct ieee80211_event *event)
+static void iwl_mvm_event_mlme_callback(struct iwl_mvm *mvm,
+					struct ieee80211_vif *vif,
+					const struct ieee80211_event *event)
 {
 #define CHECK_MLME_TRIGGER(_mvm, _trig, _buf, _cnt, _fmt...)	\
 	do {							\
@@ -3915,7 +3979,6 @@ static void iwl_mvm_mac_event_callback(struct ieee80211_hw *hw,
 		iwl_mvm_fw_dbg_collect_trig(_mvm, _trig, _fmt);\
 	} while (0)
 
-	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_fw_dbg_trigger_tlv *trig;
 	struct iwl_fw_dbg_trigger_mlme *trig_mlme;
 
@@ -3959,6 +4022,75 @@ static void iwl_mvm_mac_event_callback(struct ieee80211_hw *hw,
 #undef CHECK_MLME_TRIGGER
 }
 
+static void iwl_mvm_event_bar_rx_callback(struct iwl_mvm *mvm,
+					  struct ieee80211_vif *vif,
+					  const struct ieee80211_event *event)
+{
+	struct iwl_fw_dbg_trigger_tlv *trig;
+	struct iwl_fw_dbg_trigger_ba *ba_trig;
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_BA))
+		return;
+
+	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_BA);
+	ba_trig = (void *)trig->data;
+	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
+		return;
+
+	if (!(le16_to_cpu(ba_trig->rx_bar) & BIT(event->u.ba.tid)))
+		return;
+
+	iwl_mvm_fw_dbg_collect_trig(mvm, trig,
+				    "BAR received from %pM, tid %d, ssn %d",
+				    event->u.ba.sta->addr, event->u.ba.tid,
+				    event->u.ba.ssn);
+}
+
+static void
+iwl_mvm_event_frame_timeout_callback(struct iwl_mvm *mvm,
+				     struct ieee80211_vif *vif,
+				     const struct ieee80211_event *event)
+{
+	struct iwl_fw_dbg_trigger_tlv *trig;
+	struct iwl_fw_dbg_trigger_ba *ba_trig;
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_BA))
+		return;
+
+	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_BA);
+	ba_trig = (void *)trig->data;
+	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
+		return;
+
+	if (!(le16_to_cpu(ba_trig->frame_timeout) & BIT(event->u.ba.tid)))
+		return;
+
+	iwl_mvm_fw_dbg_collect_trig(mvm, trig,
+				    "Frame from %pM timed out, tid %d",
+				    event->u.ba.sta->addr, event->u.ba.tid);
+}
+
+static void iwl_mvm_mac_event_callback(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       const struct ieee80211_event *event)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	switch (event->type) {
+	case MLME_EVENT:
+		iwl_mvm_event_mlme_callback(mvm, vif, event);
+		break;
+	case BAR_RX_EVENT:
+		iwl_mvm_event_bar_rx_callback(mvm, vif, event);
+		break;
+	case BA_FRAME_TIMEOUT:
+		iwl_mvm_event_frame_timeout_callback(mvm, vif, event);
+		break;
+	default:
+		break;
+	}
+}
+
 const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.tx = iwl_mvm_mac_tx,
 	.ampdu_action = iwl_mvm_mac_ampdu_action,
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index ef32e17..57e0cbb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -70,6 +70,30 @@
 #include "mvm.h"
 #include "sta.h"
 
+static void
+iwl_mvm_bar_check_trigger(struct iwl_mvm *mvm, const u8 *addr,
+			  u16 tid, u16 ssn)
+{
+	struct iwl_fw_dbg_trigger_tlv *trig;
+	struct iwl_fw_dbg_trigger_ba *ba_trig;
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_BA))
+		return;
+
+	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_BA);
+	ba_trig = (void *)trig->data;
+
+	if (!iwl_fw_dbg_trigger_check_stop(mvm, NULL, trig))
+		return;
+
+	if (!(le16_to_cpu(ba_trig->tx_bar) & BIT(tid)))
+		return;
+
+	iwl_mvm_fw_dbg_collect_trig(mvm, trig,
+				    "BAR sent to %pM, tid %d, ssn %d",
+				    addr, tid, ssn);
+}
+
 /*
  * Sets most of the Tx cmd's fields
  */
@@ -101,12 +125,15 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 	} else if (ieee80211_is_back_req(fc)) {
 		struct ieee80211_bar *bar = (void *)skb->data;
 		u16 control = le16_to_cpu(bar->control);
+		u16 ssn = le16_to_cpu(bar->start_seq_num);
 
 		tx_flags |= TX_CMD_FLG_ACK | TX_CMD_FLG_BAR;
 		tx_cmd->tid_tspec = (control &
 				     IEEE80211_BAR_CTRL_TID_INFO_MASK) >>
 			IEEE80211_BAR_CTRL_TID_INFO_SHIFT;
 		WARN_ON_ONCE(tx_cmd->tid_tspec >= IWL_MAX_TID_COUNT);
+		iwl_mvm_bar_check_trigger(mvm, bar->ra, tx_cmd->tid_tspec,
+					  ssn);
 	} else {
 		tx_cmd->tid_tspec = IWL_TID_NON_QOS;
 		if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
-- 
2.1.4

