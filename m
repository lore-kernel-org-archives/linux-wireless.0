Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40622 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751410AbcEJUJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:09:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:06 +0300
Message-Id: <1462910797-20303-10-git-send-email-luca@coelho.fi> (sfid-20160510_220926_103226_5A85D970)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 10/41] iwlwifi: mvm: utilize the frame release infrastructure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The firmware will send frame release notification in order
to release "stuck" frames on a queue where no more frames
arrive on.
Upon receiving the message the driver shall indicate the frames
up to the NSSN.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 33 +++++++++++++++++++++++++--
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 3c331bd..6eaf21a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1304,7 +1304,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 void iwl_mvm_rx_phy_cmd_mq(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb, int queue);
-void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm,
+void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm, struct napi_struct *napi,
 			      struct iwl_rx_cmd_buffer *rxb, int queue);
 int iwl_mvm_notify_rx_queue(struct iwl_mvm *mvm, u32 rxq_mask,
 			    const u8 *data, u32 count);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 7c6a598..2ba1369 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -932,7 +932,7 @@ static void iwl_mvm_rx(struct iwl_op_mode *op_mode,
 	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD))
 		iwl_mvm_rx_rx_mpdu(mvm, napi, rxb);
 	else if (pkt->hdr.cmd == FRAME_RELEASE)
-		iwl_mvm_rx_frame_release(mvm, rxb, 0);
+		iwl_mvm_rx_frame_release(mvm, napi, rxb, 0);
 	else if (pkt->hdr.cmd == REPLY_RX_PHY_CMD)
 		iwl_mvm_rx_rx_phy_cmd(mvm, rxb);
 	else
@@ -1634,7 +1634,7 @@ static void iwl_mvm_rx_mq_rss(struct iwl_op_mode *op_mode,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
 	if (unlikely(pkt->hdr.cmd == FRAME_RELEASE))
-		iwl_mvm_rx_frame_release(mvm, rxb, queue);
+		iwl_mvm_rx_frame_release(mvm, napi, rxb, queue);
 	else if (unlikely(pkt->hdr.cmd == RX_QUEUES_NOTIFICATION &&
 			  pkt->hdr.group_id == DATA_PATH_GROUP))
 		iwl_mvm_rx_queue_notif(mvm, rxb, queue);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index ed187af..0da93b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -900,8 +900,37 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	rcu_read_unlock();
 }
 
-void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm,
+void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm, struct napi_struct *napi,
 			      struct iwl_rx_cmd_buffer *rxb, int queue)
 {
-	/* TODO */
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_frame_release *release = (void *)pkt->data;
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_reorder_buffer *reorder_buf;
+	struct iwl_mvm_baid_data *ba_data;
+
+	int baid = release->baid;
+
+	if (WARN_ON_ONCE(baid == IWL_RX_REORDER_DATA_INVALID_BAID))
+		return;
+
+	rcu_read_lock();
+
+	ba_data = rcu_dereference(mvm->baid_map[baid]);
+	if (WARN_ON_ONCE(!ba_data))
+		goto out;
+
+	sta = rcu_dereference(mvm->fw_id_to_mac_id[ba_data->sta_id]);
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(sta)))
+		goto out;
+
+	reorder_buf = &ba_data->reorder_buf[queue];
+
+	spin_lock_bh(&reorder_buf->lock);
+	iwl_mvm_release_frames(mvm, sta, napi, reorder_buf,
+			       le16_to_cpu(release->nssn));
+	spin_unlock_bh(&reorder_buf->lock);
+
+out:
+	rcu_read_unlock();
 }
-- 
2.8.1

