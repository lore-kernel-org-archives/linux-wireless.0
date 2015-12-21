Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:7697 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbbLUUvV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:21 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/45] iwlwifi: mvm: close the SP if we send fewer frames than expected in SP
Date: Mon, 21 Dec 2015 22:50:17 +0200
Message-Id: <1450731046-2796-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215142_081130_59D1978E)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we have holes in the BA window, there might be frames
that have been ACKed between the read and the right
pointers. This means that these frames won't be scheduled
again by the SCD and the firwmare won't see them.
This invalidates the number of frames we tell the firmware
to send. When we detect this case, tell mac80211 to close
the SP and to send an EOSP so that the firmware can be in
sync.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c |  6 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h |  6 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c  | 30 ++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 566b659..78ff21a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1664,6 +1664,7 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 	 */
 	if (agg) {
 		int remaining = cnt;
+		int sleep_tx_count;
 
 		spin_lock_bh(&mvmsta->lock);
 		for_each_set_bit(tid, &_tids, IWL_MAX_TID_COUNT) {
@@ -1688,9 +1689,12 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 			}
 			remaining -= n_queued;
 		}
+		sleep_tx_count = cnt - remaining;
+		if (reason == IEEE80211_FRAME_RELEASE_UAPSD)
+			mvmsta->sleep_tx_count = sleep_tx_count;
 		spin_unlock_bh(&mvmsta->lock);
 
-		cmd.sleep_tx_count = cpu_to_le16(cnt - remaining);
+		cmd.sleep_tx_count = cpu_to_le16(sleep_tx_count);
 		if (WARN_ON(cnt - remaining == 0)) {
 			ieee80211_sta_eosp(sta);
 			return;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 0631cc0..ce1b16a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -303,6 +303,11 @@ static inline u16 iwl_mvm_tid_queued(struct iwl_mvm_tid_data *tid_data)
  * @tt_tx_protection: is thermal throttling enable Tx protection?
  * @disable_tx: is tx to this STA disabled?
  * @agg_tids: bitmap of tids whose status is operational aggregated (IWL_AGG_ON)
+ * @sleep_tx_count: the number of frames that we told the firmware to let out
+ *	even when that station is asleep. This is useful in case the queue
+ *	gets empty before all the frames were sent, which can happen when
+ *	we are sending frames from an AMPDU queue and there was a hole in
+ *	the BA window. To be used for UAPSD only.
  *
  * When mac80211 creates a station it reserves some space (hw->sta_data_size)
  * in the structure for use by driver. This structure is placed in that
@@ -329,6 +334,7 @@ struct iwl_mvm_sta {
 
 	bool disable_tx;
 	u8 agg_tids;
+	u8 sleep_tx_count;
 };
 
 static inline struct iwl_mvm_sta *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index aaebb5d..cc0cdce 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -788,13 +788,43 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		if (tid != IWL_TID_NON_QOS) {
 			struct iwl_mvm_tid_data *tid_data =
 				&mvmsta->tid_data[tid];
+			bool send_eosp_ndp = false;
 
 			spin_lock_bh(&mvmsta->lock);
 			tid_data->next_reclaimed = next_reclaimed;
 			IWL_DEBUG_TX_REPLY(mvm, "Next reclaimed packet:%d\n",
 					   next_reclaimed);
 			iwl_mvm_check_ratid_empty(mvm, sta, tid);
+
+			if (mvmsta->sleep_tx_count) {
+				mvmsta->sleep_tx_count--;
+				if (mvmsta->sleep_tx_count &&
+				    !iwl_mvm_tid_queued(tid_data)) {
+					/*
+					 * The number of frames in the queue
+					 * dropped to 0 even if we sent less
+					 * frames than we thought we had on the
+					 * Tx queue.
+					 * This means we had holes in the BA
+					 * window that we just filled, ask
+					 * mac80211 to send EOSP since the
+					 * firmware won't know how to do that.
+					 * Send NDP and the firmware will send
+					 * EOSP notification that will trigger
+					 * a call to ieee80211_sta_eosp().
+					 */
+					send_eosp_ndp = true;
+				}
+			}
+
 			spin_unlock_bh(&mvmsta->lock);
+			if (send_eosp_ndp) {
+				iwl_mvm_sta_modify_sleep_tx_count(mvm, sta,
+					IEEE80211_FRAME_RELEASE_UAPSD,
+					1, tid, false, false);
+				mvmsta->sleep_tx_count = 0;
+				ieee80211_send_eosp_nullfunc(sta, tid);
+			}
 		}
 
 		if (mvmsta->next_status_eosp) {
-- 
2.5.0

