Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbbDBGla (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:30 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/31] iwlwifi: mvm: properly flush the queues for buffering transport
Date: Thu,  2 Apr 2015 09:40:52 +0300
Message-Id: <1427956879-11725-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_084133_359044_1FF845BF)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are transport that must buffer frames in the driver.
This means that we have frames that are not in the op_mode
and not visible to the firwmare. This causes issues when we
flush the queues: the op_mode flushes a queue, and the
firmware flushes all the frames that are *currently* on the
rings, but if the transport buffers frames, it can submit
these while we are flushing. This leads to a situation
where we still have frames on the queues after we flushed
them.
Preventing those buffered frame from getting into the
firmware is possible, but then, we have to run the Tx
response path on frames that didn't reach the firmware
which is not desirable.
The way I solve this here is to let these frames go to the
firmware, but make sure the firmware will not transmit them
(by setting the station as draining). The op_mode then needs
to wait until the transport itself is empty to be sure that
the queue is really empty.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 24 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 14 ++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/tx.c       |  8 ++++++++
 3 files changed, 46 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5f26557..babe892 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1595,9 +1595,33 @@ static void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 	u32 tfd_msk = iwl_mvm_mac_get_queues_mask(vif);
 
 	if (tfd_msk) {
+		/*
+		 * mac80211 first removes all the stations of the vif and
+		 * then removes the vif. When it removes a station it also
+		 * flushes the AMPDU session. So by now, all the AMPDU sessions
+		 * of all the stations of this vif are closed, and the queues
+		 * of these AMPDU sessions are properly closed.
+		 * We still need to take care of the shared queues of the vif.
+		 * Flush them here.
+		 */
 		mutex_lock(&mvm->mutex);
 		iwl_mvm_flush_tx_path(mvm, tfd_msk, true);
 		mutex_unlock(&mvm->mutex);
+
+		/*
+		 * There are transports that buffer a few frames in the host.
+		 * For these, the flush above isn't enough since while we were
+		 * flushing, the transport might have sent more frames to the
+		 * device. To solve this, wait here until the transport is
+		 * empty. Technically, this could have replaced the flush
+		 * above, but flush is much faster than draining. So flush
+		 * first, and drain to make sure we have no frames in the
+		 * transport anymore.
+		 * If a station still had frames on the shared queues, it is
+		 * already marked as draining, so to complete the draining, we
+		 * just need to wait until the transport is empty.
+		 */
+		iwl_trans_wait_tx_queue_empty(mvm->trans, tfd_msk);
 	}
 
 	if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 50f9288..9bf512b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -491,8 +491,18 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 
 	if (vif->type == NL80211_IFTYPE_STATION &&
 	    mvmvif->ap_sta_id == mvm_sta->sta_id) {
+		ret = iwl_mvm_drain_sta(mvm, mvm_sta, true);
+		if (ret)
+			return ret;
 		/* flush its queues here since we are freeing mvm_sta */
 		ret = iwl_mvm_flush_tx_path(mvm, mvm_sta->tfd_queue_msk, true);
+		if (ret)
+			return ret;
+		ret = iwl_trans_wait_tx_queue_empty(mvm->trans,
+						    mvm_sta->tfd_queue_msk);
+		if (ret)
+			return ret;
+		ret = iwl_mvm_drain_sta(mvm, mvm_sta, false);
 
 		/* if we are associated - we can't remove the AP STA now */
 		if (vif->bss_conf.assoc)
@@ -1120,8 +1130,12 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	spin_unlock_bh(&mvmsta->lock);
 
 	if (old_state >= IWL_AGG_ON) {
+		iwl_mvm_drain_sta(mvm, mvmsta, true);
 		if (iwl_mvm_flush_tx_path(mvm, BIT(txq_id), true))
 			IWL_ERR(mvm, "Couldn't flush the AGG queue\n");
+		iwl_trans_wait_tx_queue_empty(mvm->trans,
+					      mvmsta->tfd_queue_msk);
+		iwl_mvm_drain_sta(mvm, mvmsta, false);
 
 		iwl_mvm_sta_tx_agg(mvm, sta, tid, txq_id, false);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 7906b97..d963439 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -1047,6 +1047,14 @@ out:
 	return 0;
 }
 
+/*
+ * Note that there are transports that buffer frames before they reach
+ * the firmware. This means that after flush_tx_path is called, the
+ * queue might not be empty. The race-free way to handle this is to:
+ * 1) set the station as draining
+ * 2) flush the Tx path
+ * 3) wait for the transport queues to be empty
+ */
 int iwl_mvm_flush_tx_path(struct iwl_mvm *mvm, u32 tfd_msk, bool sync)
 {
 	int ret;
-- 
1.9.1

