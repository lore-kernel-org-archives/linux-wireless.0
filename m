Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbbCATcq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:46 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/31] iwlwifi: mvm: add trigger for firmware dump upon statistics
Date: Sun,  1 Mar 2015 21:31:42 +0200
Message-Id: <1425238304-498-29-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203418_252091_44681295)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It can be very useful to monitor the statistics and trigger
a firmware dump when a certain value hits a certain offset.
Since the statistics are huge, add a generic trigger. When
the DWORD at offset X reaches value Y.

Since there is another trigger before this one I can't add
right now because of a dependency on mac80211, add a
reserved entry to keep the enum in place.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  4 ++++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       | 14 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/rx.c            | 30 ++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 1d5195b..95bef17 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -246,6 +246,8 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  * @FW_DBG_TRIGGER_CHANNEL_SWITCH: trigger log collection upon channel switch.
  * @FW_DBG_TRIGGER_FW_NOTIF: trigger log collection when the firmware sends a
  *	command response or a notification.
+ * @FW_DB_TRIGGER_RESERVED: reserved
+ * @FW_DBG_TRIGGER_STATS: trigger log collection upon statistics threshold.
  */
 enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_INVALID = 0,
@@ -254,6 +256,8 @@ enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_MISSED_BEACONS,
 	FW_DBG_TRIGGER_CHANNEL_SWITCH,
 	FW_DBG_TRIGGER_FW_NOTIF,
+	FW_DB_TRIGGER_RESERVED,
+	FW_DBG_TRIGGER_STATS,
 
 	/* must be last */
 	FW_DBG_TRIGGER_MAX,
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 49388c2..de0e96d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -552,6 +552,20 @@ struct iwl_fw_dbg_trigger_cmd {
 } __packed;
 
 /**
+ * iwl_fw_dbg_trigger_stats - configures trigger for statistics
+ * @stop_offset: the offset of the value to be monitored
+ * @stop_threshold: the threshold above which to collect
+ * @start_offset: the offset of the value to be monitored
+ * @start_threshold: the threshold above which to start recording
+ */
+struct iwl_fw_dbg_trigger_stats {
+	__le32 stop_offset;
+	__le32 stop_threshold;
+	__le32 start_offset;
+	__le32 start_threshold;
+} __packed;
+
+/**
  * struct iwl_fw_dbg_conf_tlv - a TLV that describes a debug configuration.
  * @id: conf id
  * @usniffer: should the uSniffer image be used
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index b86ff66..9b2c537 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -508,6 +508,34 @@ static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
 	}
 }
 
+static inline void
+iwl_mvm_rx_stats_check_trigger(struct iwl_mvm *mvm, struct iwl_rx_packet *pkt)
+{
+	struct iwl_fw_dbg_trigger_tlv *trig;
+	struct iwl_fw_dbg_trigger_stats *trig_stats;
+	u32 trig_offset, trig_thold;
+
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_STATS))
+		return;
+
+	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_STATS);
+	trig_stats = (void *)trig->data;
+
+	if (!iwl_fw_dbg_trigger_check_stop(mvm, NULL, trig))
+		return;
+
+	trig_offset = le32_to_cpu(trig_stats->stop_offset);
+	trig_thold = le32_to_cpu(trig_stats->stop_threshold);
+
+	if (WARN_ON_ONCE(trig_offset >= iwl_rx_packet_payload_len(pkt)))
+		return;
+
+	if (le32_to_cpup((__le32 *) (pkt->data + trig_offset)) < trig_thold)
+		return;
+
+	iwl_mvm_fw_dbg_collect_trig(mvm, trig, NULL, 0);
+}
+
 void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 				  struct iwl_rx_packet *pkt)
 {
@@ -553,6 +581,8 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 		iwl_mvm_update_rx_statistics(mvm, &stats->rx);
 	}
 
+	iwl_mvm_rx_stats_check_trigger(mvm, pkt);
+
 	/* Only handle rx statistics temperature changes if async temp
 	 * notifications are not supported
 	 */
-- 
1.9.1

