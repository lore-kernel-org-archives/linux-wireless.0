Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbbCATcs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:48 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/31] iwlwifi: mvm: add trigger for firmware dump upon low RSSI
Date: Sun,  1 Mar 2015 21:31:43 +0200
Message-Id: <1425238304-498-30-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203418_822508_187047B6)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lots of issues can be caught when the RSSI drops. Add the
ability to collect the firmware data at that point.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  3 +++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       |  8 ++++++++
 drivers/net/wireless/iwlwifi/mvm/rx.c            | 19 +++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 95bef17..37b38a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -248,6 +248,8 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  *	command response or a notification.
  * @FW_DB_TRIGGER_RESERVED: reserved
  * @FW_DBG_TRIGGER_STATS: trigger log collection upon statistics threshold.
+ * @FW_DBG_TRIGGER_RSSI: trigger log collection when the rssi of the beacon
+ *	goes below a threshold.
  */
 enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_INVALID = 0,
@@ -258,6 +260,7 @@ enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_FW_NOTIF,
 	FW_DB_TRIGGER_RESERVED,
 	FW_DBG_TRIGGER_STATS,
+	FW_DBG_TRIGGER_RSSI,
 
 	/* must be last */
 	FW_DBG_TRIGGER_MAX,
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index de0e96d..5ea3818 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -566,6 +566,14 @@ struct iwl_fw_dbg_trigger_stats {
 } __packed;
 
 /**
+ * struct iwl_fw_dbg_trigger_low_rssi - trigger for low beacon RSSI
+ * @rssi: RSSI value to trigger at
+ */
+struct iwl_fw_dbg_trigger_low_rssi {
+	__le32 rssi;
+} __packed;
+
+/**
  * struct iwl_fw_dbg_conf_tlv - a TLV that describes a debug configuration.
  * @id: conf id
  * @usniffer: should the uSniffer image be used
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 9b2c537..6177e24 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -345,6 +345,25 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		struct iwl_mvm_sta *mvmsta;
 		mvmsta = iwl_mvm_sta_from_mac80211(sta);
 		rs_update_last_rssi(mvm, &mvmsta->lq_sta, rx_status);
+
+		if (iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_RSSI) &&
+		    ieee80211_is_beacon(hdr->frame_control)) {
+			struct iwl_fw_dbg_trigger_tlv *trig;
+			struct iwl_fw_dbg_trigger_low_rssi *rssi_trig;
+			bool trig_check;
+			s32 rssi;
+
+			trig = iwl_fw_dbg_get_trigger(mvm->fw,
+						      FW_DBG_TRIGGER_RSSI);
+			rssi_trig = (void *)trig->data;
+			rssi = le32_to_cpu(rssi_trig->rssi);
+
+			trig_check =
+				iwl_fw_dbg_trigger_check_stop(mvm, mvmsta->vif,
+							      trig);
+			if (trig_check && rx_status->signal < rssi)
+				iwl_mvm_fw_dbg_collect_trig(mvm, trig, NULL, 0);
+		}
 	}
 
 	rcu_read_unlock();
-- 
1.9.1

