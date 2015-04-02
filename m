Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6056 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbbDBGma (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:30 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/31] iwlwifi: mvm: do string formatting in debug triggers
Date: Thu,  2 Apr 2015 09:41:17 +0300
Message-Id: <1427956879-11725-29-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090419_586545_8308C3B5)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The current code has a lot of duplicates of printing into a buffer
(while having to make sure it's NUL-filled and -terminated) and
then passing that to the debug trigger collection.

Since that's error-prone, instead make the debug trigger collection
function take a format string and format arguments (with compiler
validity checking) and handle the buffer internally.

This makes one behavioural change -- instead of sending the whole
buffer to userspace (clearing is needed to not leak stack data) it
just passes the actual string (including NUL-terminator.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c       | 23 ++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  9 ++-------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  7 +++----
 drivers/net/wireless/iwlwifi/mvm/rx.c       |  4 ++--
 6 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 6cf7d98..bc5eac4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -526,16 +526,33 @@ int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
 
 int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
 				struct iwl_fw_dbg_trigger_tlv *trigger,
-				const char *str, size_t len)
+				const char *fmt, ...)
 {
 	unsigned int delay = msecs_to_jiffies(le32_to_cpu(trigger->stop_delay));
 	u16 occurrences = le16_to_cpu(trigger->occurrences);
-	int ret;
+	int ret, len = 0;
+	char buf[64];
 
 	if (!occurrences)
 		return 0;
 
-	ret = iwl_mvm_fw_dbg_collect(mvm, le32_to_cpu(trigger->id), str,
+	if (fmt) {
+		va_list ap;
+
+		buf[sizeof(buf) - 1] = '\0';
+
+		va_start(ap, fmt);
+		vsnprintf(buf, sizeof(buf), fmt, ap);
+		va_end(ap);
+
+		/* check for truncation */
+		if (WARN_ON_ONCE(buf[sizeof(buf) - 1]))
+			buf[sizeof(buf) - 1] = '\0';
+
+		len = strlen(buf) + 1;
+	}
+
+	ret = iwl_mvm_fw_dbg_collect(mvm, le32_to_cpu(trigger->id), buf,
 				     len, delay);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 09f0124..8088c71 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1412,7 +1412,7 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 
 	if (rx_missed_bcon_since_rx >= stop_trig_missed_bcon_since_rx ||
 	    rx_missed_bcon >= stop_trig_missed_bcon)
-		iwl_mvm_fw_dbg_collect_trig(mvm, trigger, NULL, 0);
+		iwl_mvm_fw_dbg_collect_trig(mvm, trigger, NULL);
 }
 
 int iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 74912e7..8455517 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3961,19 +3961,16 @@ static void iwl_mvm_mac_event_callback(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       const struct ieee80211_event *event)
 {
-#define CHECK_MLME_TRIGGER(_mvm, _trig, _buf, _cnt, _str...)	\
+#define CHECK_MLME_TRIGGER(_mvm, _trig, _buf, _cnt, _fmt...)	\
 	do {							\
 		if ((_cnt) && --(_cnt))				\
 			break;					\
-		snprintf(_buf, sizeof(_buf), ##_str);		\
-		iwl_mvm_fw_dbg_collect_trig(_mvm, _trig, _buf,	\
-					    sizeof(_buf));	\
+		iwl_mvm_fw_dbg_collect_trig(_mvm, _trig, _fmt);\
 	} while (0)
 
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_fw_dbg_trigger_tlv *trig;
 	struct iwl_fw_dbg_trigger_mlme *trig_mlme;
-	char buf[32];
 
 	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_MLME))
 		return;
@@ -3986,8 +3983,6 @@ static void iwl_mvm_mac_event_callback(struct ieee80211_hw *hw,
 	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trig))
 		return;
 
-	memset(buf, 0, sizeof(buf));
-
 	if (event->u.mlme.data == ASSOC_EVENT) {
 		if (event->u.mlme.status == MLME_DENIED)
 			CHECK_MLME_TRIGGER(mvm, trig, buf,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 629b8c7..ef78ebc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1480,7 +1480,7 @@ int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
 void iwl_mvm_free_fw_dump_desc(struct iwl_mvm *mvm);
 int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
 				struct iwl_fw_dbg_trigger_tlv *trigger,
-				const char *str, size_t len);
+				const char *fmt, ...) __printf(3, 4);
 unsigned int iwl_mvm_get_wd_timeout(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
 				    bool tdls, bool cmd_q);
@@ -1527,7 +1527,7 @@ iwl_fw_dbg_trigger_simple_stop(struct iwl_mvm *mvm,
 	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trigger))
 		return;
 
-	iwl_mvm_fw_dbg_collect_trig(mvm, trigger, NULL, 0);
+	iwl_mvm_fw_dbg_collect_trig(mvm, trigger, NULL);
 }
 
 #endif /* __IWL_MVM_H__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 67ed57e..e656511 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -689,7 +689,6 @@ static inline void iwl_mvm_rx_check_trigger(struct iwl_mvm *mvm,
 {
 	struct iwl_fw_dbg_trigger_tlv *trig;
 	struct iwl_fw_dbg_trigger_cmd *cmds_trig;
-	char buf[32];
 	int i;
 
 	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_FW_NOTIF))
@@ -709,9 +708,9 @@ static inline void iwl_mvm_rx_check_trigger(struct iwl_mvm *mvm,
 		if (cmds_trig->cmds[i].cmd_id != pkt->hdr.cmd)
 			continue;
 
-		memset(buf, 0, sizeof(buf));
-		snprintf(buf, sizeof(buf), "CMD 0x%02x received", pkt->hdr.cmd);
-		iwl_mvm_fw_dbg_collect_trig(mvm, trig, buf, sizeof(buf));
+		iwl_mvm_fw_dbg_collect_trig(mvm, trig,
+					    "CMD 0x%02x received",
+					    pkt->hdr.cmd);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 6177e24..78ec7db 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -362,7 +362,7 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 				iwl_fw_dbg_trigger_check_stop(mvm, mvmsta->vif,
 							      trig);
 			if (trig_check && rx_status->signal < rssi)
-				iwl_mvm_fw_dbg_collect_trig(mvm, trig, NULL, 0);
+				iwl_mvm_fw_dbg_collect_trig(mvm, trig, NULL);
 		}
 	}
 
@@ -552,7 +552,7 @@ iwl_mvm_rx_stats_check_trigger(struct iwl_mvm *mvm, struct iwl_rx_packet *pkt)
 	if (le32_to_cpup((__le32 *) (pkt->data + trig_offset)) < trig_thold)
 		return;
 
-	iwl_mvm_fw_dbg_collect_trig(mvm, trig, NULL, 0);
+	iwl_mvm_fw_dbg_collect_trig(mvm, trig, NULL);
 }
 
 void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
-- 
1.9.1

