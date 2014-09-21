Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35312 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaIUTWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:47 -0400
Received: by mail-wg0-f50.google.com with SMTP id l18so756012wgh.21
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:46 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/17] iwlwifi: mvm: report all BA notifs to RS
Date: Sun, 21 Sep 2014 22:22:15 +0300
Message-Id: <1411327338-23099-14-git-send-email-egrumbach@gmail.com> (sfid-20140921_213114_037055_B4F953F6)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Currently BA notifications which don't reclaim any frames
would not cause the RS to be called as no skbs are passed
to mac80211. This is not optimal as RS can benefit from the
statistics of sent vs. acked of such a BA. This can improve the
reaction time of the RS algorithm. Also, an upcoming change in
the firmware would cause BA timeout to be reported as a BA notif
with 0 acked so this change is required for that as well.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 51 +++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 66e1a3d..1cb793a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -873,6 +873,19 @@ int iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	return 0;
 }
 
+static void iwl_mvm_tx_info_from_ba_notif(struct ieee80211_tx_info *info,
+					  struct iwl_mvm_ba_notif *ba_notif,
+					  struct iwl_mvm_tid_data *tid_data)
+{
+	info->flags |= IEEE80211_TX_STAT_AMPDU;
+	info->status.ampdu_ack_len = ba_notif->txed_2_done;
+	info->status.ampdu_len = ba_notif->txed;
+	iwl_mvm_hwrate_to_tx_status(tid_data->rate_n_flags,
+				    info);
+	info->status.status_driver_data[0] =
+		(void *)(uintptr_t)tid_data->reduced_tpc;
+}
+
 int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			struct iwl_device_cmd *cmd)
 {
@@ -959,21 +972,37 @@ int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		 */
 		info->flags |= IEEE80211_TX_STAT_ACK;
 
-		if (freed == 1) {
-			/* this is the first skb we deliver in this batch */
-			/* put the rate scaling data there */
-			info->flags |= IEEE80211_TX_STAT_AMPDU;
-			info->status.ampdu_ack_len = ba_notif->txed_2_done;
-			info->status.ampdu_len = ba_notif->txed;
-			iwl_mvm_hwrate_to_tx_status(tid_data->rate_n_flags,
-						    info);
-			info->status.status_driver_data[0] =
-				(void *)(uintptr_t)tid_data->reduced_tpc;
-		}
+		/* this is the first skb we deliver in this batch */
+		/* put the rate scaling data there */
+		if (freed == 1)
+			iwl_mvm_tx_info_from_ba_notif(info, ba_notif, tid_data);
 	}
 
 	spin_unlock_bh(&mvmsta->lock);
 
+	/* We got a BA notif with 0 acked or scd_ssn didn't progress which is
+	 * possible (i.e. first MPDU in the aggregation wasn't acked)
+	 * Still it's important to update RS about sent vs. acked.
+	 */
+	if (skb_queue_empty(&reclaimed_skbs)) {
+		struct ieee80211_tx_info ba_info = {};
+		struct ieee80211_chanctx_conf *chanctx_conf = NULL;
+
+		if (mvmsta->vif)
+			chanctx_conf =
+				rcu_dereference(mvmsta->vif->chanctx_conf);
+
+		if (WARN_ON_ONCE(!chanctx_conf))
+			goto out;
+
+		ba_info.band = chanctx_conf->def.chan->band;
+		iwl_mvm_tx_info_from_ba_notif(&ba_info, ba_notif, tid_data);
+
+		IWL_DEBUG_TX_REPLY(mvm, "No reclaim. Update rs directly\n");
+		iwl_mvm_rs_tx_status(mvm, sta, tid, &ba_info);
+	}
+
+out:
 	rcu_read_unlock();
 
 	while (!skb_queue_empty(&reclaimed_skbs)) {
-- 
1.9.1

