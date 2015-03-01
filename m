Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbbCATck (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:40 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/31] iwlwifi: mvm: add trigger for firmware dump upon missed beacons
Date: Sun,  1 Mar 2015 21:31:38 +0200
Message-Id: <1425238304-498-25-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203418_394430_AC5C15C6)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Missing beacons is a good indication that something is going
wrong in the firmware. Add a trigger to be able to collect
data when we start missing beacons with a configurable
threshold.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  3 +++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       | 18 +++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c      | 28 ++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index b733c58..7d74126 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -241,11 +241,14 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  *	driver should set to indicate that the trigger was initiated by the
  *	user.
  * @FW_DBG_TRIGGER_FW_ASSERT: trigger log collection when the firmware asserts
+ * @FW_DBG_TRIGGER_MISSED_BEACONS: trigger log collection when beacons are
+ *	missed.
  */
 enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_INVALID = 0,
 	FW_DBG_TRIGGER_USER,
 	FW_DBG_TRIGGER_FW_ASSERT,
+	FW_DBG_TRIGGER_MISSED_BEACONS,
 
 	/* must be last */
 	FW_DBG_TRIGGER_MAX,
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index d2c4d21..85745dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -523,6 +523,24 @@ struct iwl_fw_dbg_trigger_tlv {
 #define FW_DBG_INVALID		0xff
 
 /**
+ * struct iwl_fw_dbg_trigger_missed_bcon - configures trigger for missed beacons
+ * @stop_consec_missed_bcon: stop recording if threshold is crossed.
+ * @stop_consec_missed_bcon_since_rx: stop recording if threshold is crossed.
+ * @start_consec_missed_bcon: start recording if threshold is crossed.
+ * @start_consec_missed_bcon_since_rx: start recording if threshold is crossed.
+ * @reserved1: reserved
+ * @reserved2: reserved
+ */
+struct iwl_fw_dbg_trigger_missed_bcon {
+	__le32 stop_consec_missed_bcon;
+	__le32 stop_consec_missed_bcon_since_rx;
+	__le32 reserved2[2];
+	__le32 start_consec_missed_bcon;
+	__le32 start_consec_missed_bcon_since_rx;
+	__le32 reserved1[2];
+} __packed;
+
+/**
  * struct iwl_fw_dbg_conf_tlv - a TLV that describes a debug configuration.
  * @id: conf id
  * @usniffer: should the uSniffer image be used
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index f2bfc15..581b3b8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1375,10 +1375,18 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 {
 	struct iwl_missed_beacons_notif *missed_beacons = _data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = mvmvif->mvm;
+	struct iwl_fw_dbg_trigger_missed_bcon *bcon_trig;
+	struct iwl_fw_dbg_trigger_tlv *trigger;
+	u32 stop_trig_missed_bcon, stop_trig_missed_bcon_since_rx;
+	u32 rx_missed_bcon, rx_missed_bcon_since_rx;
 
 	if (mvmvif->id != (u16)le32_to_cpu(missed_beacons->mac_id))
 		return;
 
+	rx_missed_bcon = le32_to_cpu(missed_beacons->consec_missed_beacons);
+	rx_missed_bcon_since_rx =
+		le32_to_cpu(missed_beacons->consec_missed_beacons_since_last_rx);
 	/*
 	 * TODO: the threshold should be adjusted based on latency conditions,
 	 * and/or in case of a CS flow on one of the other AP vifs.
@@ -1386,6 +1394,26 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 	if (le32_to_cpu(missed_beacons->consec_missed_beacons_since_last_rx) >
 	     IWL_MVM_MISSED_BEACONS_THRESHOLD)
 		ieee80211_beacon_loss(vif);
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw,
+					FW_DBG_TRIGGER_MISSED_BEACONS))
+		return;
+
+	trigger = iwl_fw_dbg_get_trigger(mvm->fw,
+					 FW_DBG_TRIGGER_MISSED_BEACONS);
+	bcon_trig = (void *)trigger->data;
+	stop_trig_missed_bcon = le32_to_cpu(bcon_trig->stop_consec_missed_bcon);
+	stop_trig_missed_bcon_since_rx =
+		le32_to_cpu(bcon_trig->stop_consec_missed_bcon_since_rx);
+
+	/* TODO: implement start trigger */
+
+	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trigger))
+		return;
+
+	if (rx_missed_bcon_since_rx >= stop_trig_missed_bcon_since_rx ||
+	    rx_missed_bcon >= stop_trig_missed_bcon)
+		iwl_mvm_fw_dbg_collect_trig(mvm, trigger, NULL, 0);
 }
 
 int iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
-- 
1.9.1

