Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99DD2C07EBF
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E7D12086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbfARTAw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:00:52 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48414 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728543AbfARTAw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:00:52 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNR-0004cj-VH; Fri, 18 Jan 2019 21:00:27 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 21:00:04 +0200
Message-Id: <20190118190004.22270-17-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118190004.22270-1-luca@coelho.fi>
References: <20190118190004.22270-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 16/16] iwlwifi: mvm: support mac80211 TXQs model
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Move to use the new mac80211 TXQs implementation. This has
quite a few benefits for us. We can get rid of the awkward
mapping of DQA to mac80211 queues. We can stop buffering
traffic while waiting for the queue to be allocated. We can
also use mac80211 AMSDUs instead of building it ourselves.

The usage is pretty simple:
Each ieee80211_txq contains iwl_mvm_txq. There is such a
queue for each TID, and one for management frames. We keep
having static AP queues for probes and non-bufferable MMPDUs,
along with broadcast and multicast queues. Those are being
used from the "old" TX invocation path - iwl_mvm_mac_tx.

When there is a new frame in a TXQ, iwl_mvm_mac_wake_tx is
being called, and either invokes the TX path, or allocates
the queue if it does not exist.

Most of the TX path is left untouched, although we can consider
cleaning it up some more, for example get rid of the duplication
of txq_id in both iwl_mvm_txq and iwl_mvm_dqa_txq_info.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |   5 +-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  72 +---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 113 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  54 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  87 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 360 +++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  |   4 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  71 +---
 9 files changed, 331 insertions(+), 443 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 01b5338201d6..36ed7d6fc971 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2125,7 +2125,6 @@ static int iwl_mvm_d3_test_open(struct inode *inode, struct file *file)
 
 	file->private_data = inode->i_private;
 
-	ieee80211_stop_queues(mvm->hw);
 	synchronize_net();
 
 	mvm->trans->system_pm_mode = IWL_PLAT_PM_MODE_D3;
@@ -2140,10 +2139,9 @@ static int iwl_mvm_d3_test_open(struct inode *inode, struct file *file)
 	rtnl_unlock();
 	if (err > 0)
 		err = -EINVAL;
-	if (err) {
-		ieee80211_wake_queues(mvm->hw);
+	if (err)
 		return err;
-	}
+
 	mvm->d3_test_active = true;
 	mvm->keep_vif = NULL;
 	return 0;
@@ -2223,8 +2221,6 @@ static int iwl_mvm_d3_test_release(struct inode *inode, struct file *file)
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_d3_test_disconn_work_iter, mvm->keep_vif);
 
-	ieee80211_wake_queues(mvm->hw);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 0d6c313b6669..27582d70d45a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -295,7 +295,7 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	struct iwl_notification_wait alive_wait;
 	struct iwl_mvm_alive_data alive_data;
 	const struct fw_img *fw;
-	int ret, i;
+	int ret;
 	enum iwl_ucode_type old_type = mvm->fwrt.cur_fw_img;
 	static const u16 alive_cmd[] = { MVM_ALIVE };
 
@@ -373,9 +373,6 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	mvm->queue_info[IWL_MVM_DQA_CMD_QUEUE].tid_bitmap =
 		BIT(IWL_MAX_TID_COUNT + 2);
 
-	for (i = 0; i < IEEE80211_MAX_QUEUES; i++)
-		atomic_set(&mvm->mac80211_queue_stop_count[i], 0);
-
 	set_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	iwl_fw_set_dbg_rec_on(&mvm->fwrt);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index eb66269ddf73..a79c79701cc4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -97,11 +97,6 @@ struct iwl_mvm_mac_iface_iterator_data {
 	bool found_vif;
 };
 
-struct iwl_mvm_hw_queues_iface_iterator_data {
-	struct ieee80211_vif *exclude_vif;
-	unsigned long used_hw_queues;
-};
-
 static void iwl_mvm_mac_tsf_id_iter(void *_data, u8 *mac,
 				    struct ieee80211_vif *vif)
 {
@@ -208,61 +203,6 @@ static void iwl_mvm_mac_tsf_id_iter(void *_data, u8 *mac,
 		data->preferred_tsf = NUM_TSF_IDS;
 }
 
-/*
- * Get the mask of the queues used by the vif
- */
-u32 iwl_mvm_mac_get_queues_mask(struct ieee80211_vif *vif)
-{
-	u32 qmask = 0, ac;
-
-	if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
-		return BIT(IWL_MVM_OFFCHANNEL_QUEUE);
-
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		if (vif->hw_queue[ac] != IEEE80211_INVAL_HW_QUEUE)
-			qmask |= BIT(vif->hw_queue[ac]);
-	}
-
-	if (vif->type == NL80211_IFTYPE_AP ||
-	    vif->type == NL80211_IFTYPE_ADHOC)
-		qmask |= BIT(vif->cab_queue);
-
-	return qmask;
-}
-
-static void iwl_mvm_iface_hw_queues_iter(void *_data, u8 *mac,
-					 struct ieee80211_vif *vif)
-{
-	struct iwl_mvm_hw_queues_iface_iterator_data *data = _data;
-
-	/* exclude the given vif */
-	if (vif == data->exclude_vif)
-		return;
-
-	data->used_hw_queues |= iwl_mvm_mac_get_queues_mask(vif);
-}
-
-unsigned long iwl_mvm_get_used_hw_queues(struct iwl_mvm *mvm,
-					 struct ieee80211_vif *exclude_vif)
-{
-	struct iwl_mvm_hw_queues_iface_iterator_data data = {
-		.exclude_vif = exclude_vif,
-		.used_hw_queues =
-			BIT(IWL_MVM_OFFCHANNEL_QUEUE) |
-			BIT(mvm->aux_queue) |
-			BIT(IWL_MVM_DQA_GCAST_QUEUE),
-	};
-
-	lockdep_assert_held(&mvm->mutex);
-
-	/* mark all VIF used hw queues */
-	ieee80211_iterate_active_interfaces_atomic(
-		mvm->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
-		iwl_mvm_iface_hw_queues_iter, &data);
-
-	return data.used_hw_queues;
-}
-
 static void iwl_mvm_mac_iface_iterator(void *_data, u8 *mac,
 				       struct ieee80211_vif *vif)
 {
@@ -360,8 +300,6 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		mvm->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
 		iwl_mvm_mac_iface_iterator, &data);
 
-	used_hw_queues = iwl_mvm_get_used_hw_queues(mvm, vif);
-
 	/*
 	 * In the case we're getting here during resume, it's similar to
 	 * firmware restart, and with RESUME_ALL the iterator will find
@@ -416,9 +354,6 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	 * the ones here - no real limit
 	 */
 	queue_limit = IEEE80211_MAX_QUEUES;
-	BUILD_BUG_ON(IEEE80211_MAX_QUEUES >
-		     BITS_PER_BYTE *
-		     sizeof(mvm->hw_queue_to_mac80211[0]));
 
 	/*
 	 * Find available queues, and allocate them to the ACs. When in
@@ -446,9 +381,6 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		 * queue value (when queue is enabled).
 		 */
 		mvmvif->cab_queue = IWL_MVM_DQA_GCAST_QUEUE;
-		vif->cab_queue = IWL_MVM_DQA_GCAST_QUEUE;
-	} else {
-		vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
 	}
 
 	mvmvif->bcast_sta.sta_id = IWL_MVM_INVALID_STA;
@@ -462,8 +394,6 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 exit_fail:
 	memset(mvmvif, 0, sizeof(struct iwl_mvm_vif));
-	memset(vif->hw_queue, IEEE80211_INVAL_HW_QUEUE, sizeof(vif->hw_queue));
-	vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
 	return ret;
 }
 
@@ -1185,7 +1115,7 @@ static void iwl_mvm_mac_ctxt_cmd_fill_ap(struct iwl_mvm *mvm,
 
 	if (!fw_has_api(&mvm->fw->ucode_capa,
 			IWL_UCODE_TLV_API_STA_TYPE))
-		ctxt_ap->mcast_qid = cpu_to_le32(vif->cab_queue);
+		ctxt_ap->mcast_qid = cpu_to_le32(mvmvif->cab_queue);
 
 	/*
 	 * Only set the beacon time when the MAC is being added, when we
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 310a36dd33cf..58bb92b0ef05 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -425,7 +425,6 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, SIGNAL_DBM);
 	ieee80211_hw_set(hw, SPECTRUM_MGMT);
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
-	ieee80211_hw_set(hw, QUEUE_CONTROL);
 	ieee80211_hw_set(hw, WANT_MONITOR_VIF);
 	ieee80211_hw_set(hw, SUPPORTS_PS);
 	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
@@ -439,6 +438,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, NEEDS_UNIQUE_STA_ADDR);
 	ieee80211_hw_set(hw, DEAUTH_NEED_MGD_TX_PREP);
 	ieee80211_hw_set(hw, SUPPORTS_VHT_EXT_NSS_BW);
+	ieee80211_hw_set(hw, BUFF_MMPDU_TXQ);
+	ieee80211_hw_set(hw, STA_MMPDU_TXQ);
 
 	if (iwl_mvm_has_tlc_offload(mvm)) {
 		ieee80211_hw_set(hw, TX_AMPDU_SETUP_IN_HW);
@@ -549,6 +550,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	hw->sta_data_size = sizeof(struct iwl_mvm_sta);
 	hw->vif_data_size = sizeof(struct iwl_mvm_vif);
 	hw->chanctx_data_size = sizeof(u16);
+	hw->txq_data_size = sizeof(struct iwl_mvm_txq);
 
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_P2P_CLIENT) |
@@ -798,7 +800,6 @@ static bool iwl_mvm_defer_tx(struct iwl_mvm *mvm,
 		goto out;
 
 	__skb_queue_tail(&mvm->d0i3_tx, skb);
-	ieee80211_stop_queues(mvm->hw);
 
 	/* trigger wakeup */
 	iwl_mvm_ref(mvm, IWL_MVM_REF_TX);
@@ -818,13 +819,15 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 	struct ieee80211_sta *sta = control->sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
+	bool offchannel = IEEE80211_SKB_CB(skb)->flags &
+		IEEE80211_TX_CTL_TX_OFFCHAN;
 
 	if (iwl_mvm_is_radio_killed(mvm)) {
 		IWL_DEBUG_DROP(mvm, "Dropping - RF/CT KILL\n");
 		goto drop;
 	}
 
-	if (info->hw_queue == IWL_MVM_OFFCHANNEL_QUEUE &&
+	if (offchannel &&
 	    !test_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status) &&
 	    !test_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status))
 		goto drop;
@@ -837,8 +840,8 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 		sta = NULL;
 
 	/* If there is no sta, and it's not offchannel - send through AP */
-	if (info->control.vif->type == NL80211_IFTYPE_STATION &&
-	    info->hw_queue != IWL_MVM_OFFCHANNEL_QUEUE && !sta) {
+	if (!sta && info->control.vif->type == NL80211_IFTYPE_STATION &&
+	    !offchannel) {
 		struct iwl_mvm_vif *mvmvif =
 			iwl_mvm_vif_from_mac80211(info->control.vif);
 		u8 ap_sta_id = READ_ONCE(mvmvif->ap_sta_id);
@@ -866,6 +869,77 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 	ieee80211_free_txskb(hw, skb);
 }
 
+void iwl_mvm_mac_itxq_xmit(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_txq *mvmtxq = iwl_mvm_txq_from_mac80211(txq);
+	struct sk_buff *skb = NULL;
+
+	spin_lock(&mvmtxq->tx_path_lock);
+
+	rcu_read_lock();
+	while (likely(!mvmtxq->stopped &&
+		      (mvm->trans->system_pm_mode ==
+		       IWL_PLAT_PM_MODE_DISABLED))) {
+		skb = ieee80211_tx_dequeue(hw, txq);
+
+		if (!skb)
+			break;
+
+		if (!txq->sta)
+			iwl_mvm_tx_skb_non_sta(mvm, skb);
+		else
+			iwl_mvm_tx_skb(mvm, skb, txq->sta);
+	}
+	rcu_read_unlock();
+
+	spin_unlock(&mvmtxq->tx_path_lock);
+}
+
+static void iwl_mvm_mac_wake_tx_queue(struct ieee80211_hw *hw,
+				      struct ieee80211_txq *txq)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_txq *mvmtxq = iwl_mvm_txq_from_mac80211(txq);
+
+	/*
+	 * Please note that racing is handled very carefully here:
+	 * mvmtxq->txq_id is updated during allocation, and mvmtxq->list is
+	 * deleted afterwards.
+	 * This means that if:
+	 * mvmtxq->txq_id != INVALID_QUEUE && list_empty(&mvmtxq->list):
+	 *	queue is allocated and we can TX.
+	 * mvmtxq->txq_id != INVALID_QUEUE && !list_empty(&mvmtxq->list):
+	 *	a race, should defer the frame.
+	 * mvmtxq->txq_id == INVALID_QUEUE && list_empty(&mvmtxq->list):
+	 *	need to allocate the queue and defer the frame.
+	 * mvmtxq->txq_id == INVALID_QUEUE && !list_empty(&mvmtxq->list):
+	 *	queue is already scheduled for allocation, no need to allocate,
+	 *	should defer the frame.
+	 */
+
+	/* If the queue is allocated TX and return. */
+	if (!txq->sta || mvmtxq->txq_id != IWL_MVM_INVALID_QUEUE) {
+		/*
+		 * Check that list is empty to avoid a race where txq_id is
+		 * already updated, but the queue allocation work wasn't
+		 * finished
+		 */
+		if (unlikely(txq->sta && !list_empty(&mvmtxq->list)))
+			return;
+
+		iwl_mvm_mac_itxq_xmit(hw, txq);
+		return;
+	}
+
+	/* The list is being deleted only after the queue is fully allocated. */
+	if (!list_empty(&mvmtxq->list))
+		return;
+
+	list_add_tail(&mvmtxq->list, &mvm->add_stream_txqs);
+	schedule_work(&mvm->add_stream_wk);
+}
+
 static inline bool iwl_enable_rx_ampdu(const struct iwl_cfg *cfg)
 {
 	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG)
@@ -1107,7 +1181,6 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 
 	iwl_mvm_reset_phy_ctxts(mvm);
 	memset(mvm->fw_key_table, 0, sizeof(mvm->fw_key_table));
-	memset(mvm->sta_deferred_frames, 0, sizeof(mvm->sta_deferred_frames));
 	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
 	memset(&mvm->last_bt_ci_cmd, 0, sizeof(mvm->last_bt_ci_cmd));
 
@@ -2883,32 +2956,6 @@ iwl_mvm_tdls_check_trigger(struct iwl_mvm *mvm,
 				peer_addr, action);
 }
 
-static void iwl_mvm_purge_deferred_tx_frames(struct iwl_mvm *mvm,
-					     struct iwl_mvm_sta *mvm_sta)
-{
-	struct iwl_mvm_tid_data *tid_data;
-	struct sk_buff *skb;
-	int i;
-
-	spin_lock_bh(&mvm_sta->lock);
-	for (i = 0; i <= IWL_MAX_TID_COUNT; i++) {
-		tid_data = &mvm_sta->tid_data[i];
-
-		while ((skb = __skb_dequeue(&tid_data->deferred_tx_frames))) {
-			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
-			/*
-			 * The first deferred frame should've stopped the MAC
-			 * queues, so we should never get a second deferred
-			 * frame for the RA/TID.
-			 */
-			iwl_mvm_start_mac_queues(mvm, BIT(info->hw_queue));
-			ieee80211_free_txskb(mvm->hw, skb);
-		}
-	}
-	spin_unlock_bh(&mvm_sta->lock);
-}
-
 static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta,
@@ -2942,7 +2989,6 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 	 */
 	if (old_state == IEEE80211_STA_NONE &&
 	    new_state == IEEE80211_STA_NOTEXIST) {
-		iwl_mvm_purge_deferred_tx_frames(mvm, mvm_sta);
 		flush_work(&mvm->add_stream_wk);
 
 		/*
@@ -4680,6 +4726,7 @@ static void iwl_mvm_sync_rx_queues(struct ieee80211_hw *hw)
 
 const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.tx = iwl_mvm_mac_tx,
+	.wake_tx_queue = iwl_mvm_mac_wake_tx_queue,
 	.ampdu_action = iwl_mvm_mac_ampdu_action,
 	.start = iwl_mvm_mac_start,
 	.reconfig_complete = iwl_mvm_mac_reconfig_complete,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 1aa690e081ff..39ee3ace59b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -778,6 +778,40 @@ struct iwl_mvm_geo_profile {
 	u8 values[ACPI_GEO_TABLE_SIZE];
 };
 
+struct iwl_mvm_txq {
+	struct list_head list;
+	u16 txq_id;
+	/* Protects TX path invocation from two places */
+	spinlock_t tx_path_lock;
+	bool stopped;
+};
+
+static inline struct iwl_mvm_txq *
+iwl_mvm_txq_from_mac80211(struct ieee80211_txq *txq)
+{
+	return (void *)txq->drv_priv;
+}
+
+static inline struct iwl_mvm_txq *
+iwl_mvm_txq_from_tid(struct ieee80211_sta *sta, u8 tid)
+{
+	if (tid == IWL_MAX_TID_COUNT)
+		tid = IEEE80211_NUM_TIDS;
+
+	return (void *)sta->txq[tid]->drv_priv;
+}
+
+/**
+ * struct iwl_mvm_tvqm_txq_info - maps TVQM hw queue to tid
+ *
+ * @sta_id: sta id
+ * @txq_tid: txq tid
+ */
+struct iwl_mvm_tvqm_txq_info {
+	u8 sta_id;
+	u8 txq_tid;
+};
+
 struct iwl_mvm_dqa_txq_info {
 	u8 ra_sta_id; /* The RA this queue is mapped to, if exists */
 	bool reserved; /* Is this the TXQ reserved for a STA */
@@ -843,13 +877,13 @@ struct iwl_mvm {
 		u64 on_time_scan;
 	} radio_stats, accu_radio_stats;
 
-	u16 hw_queue_to_mac80211[IWL_MAX_TVQM_QUEUES];
-
-	struct iwl_mvm_dqa_txq_info queue_info[IWL_MAX_HW_QUEUES];
+	struct list_head add_stream_txqs;
+	union {
+		struct iwl_mvm_dqa_txq_info queue_info[IWL_MAX_HW_QUEUES];
+		struct iwl_mvm_tvqm_txq_info tvqm_info[IWL_MAX_TVQM_QUEUES];
+	};
 	struct work_struct add_stream_wk; /* To add streams to queues */
 
-	atomic_t mac80211_queue_stop_count[IEEE80211_MAX_QUEUES];
-
 	const char *nvm_file_name;
 	struct iwl_nvm_data *nvm_data;
 	/* NVM sections */
@@ -863,7 +897,6 @@ struct iwl_mvm {
 	/* data related to data path */
 	struct iwl_rx_phy_info last_phy_info;
 	struct ieee80211_sta __rcu *fw_id_to_mac_id[IWL_MVM_STATION_COUNT];
-	unsigned long sta_deferred_frames[BITS_TO_LONGS(IWL_MVM_STATION_COUNT)];
 	u8 rx_ba_sessions;
 
 	/* configured by mac80211 */
@@ -1470,6 +1503,8 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 			    struct ieee80211_tx_info *info,
 			    struct ieee80211_sta *sta, __le16 fc);
+void iwl_mvm_mac_itxq_xmit(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
+
 #ifdef CONFIG_IWLWIFI_DEBUG
 const char *iwl_mvm_get_tx_fail_reason(u32 status);
 #else
@@ -1599,7 +1634,6 @@ int iwl_mvm_mac_ctxt_add(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_mac_ctxt_changed(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			     bool force_assoc_off, const u8 *bssid_override);
 int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-u32 iwl_mvm_mac_get_queues_mask(struct ieee80211_vif *vif);
 int iwl_mvm_mac_ctxt_beacon_changed(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif);
 void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
@@ -1615,8 +1649,6 @@ void iwl_mvm_window_status_notif(struct iwl_mvm *mvm,
 				 struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_mac_ctxt_recalc_tsf_id(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif);
-unsigned long iwl_mvm_get_used_hw_queues(struct iwl_mvm *mvm,
-					 struct ieee80211_vif *exclude_vif);
 void iwl_mvm_probe_resp_data_notif(struct iwl_mvm *mvm,
 				   struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_channel_switch_noa_notif(struct iwl_mvm *mvm,
@@ -1906,10 +1938,6 @@ static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 	iwl_trans_stop_device(mvm->trans);
 }
 
-/* Stop/start all mac queues in a given bitmap */
-void iwl_mvm_start_mac_queues(struct iwl_mvm *mvm, unsigned long mq);
-void iwl_mvm_stop_mac_queues(struct iwl_mvm *mvm, unsigned long mq);
-
 /* Re-configure the SCD for a queue that has already been configured */
 int iwl_mvm_reconfig_scd(struct iwl_mvm *mvm, int queue, int fifo, int sta_id,
 			 int tid, int frame_limit, u16 ssn);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 30c5127034a0..d257c143e624 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -685,6 +685,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_DELAYED_WORK(&mvm->tdls_cs.dwork, iwl_mvm_tdls_ch_switch_work);
 	INIT_DELAYED_WORK(&mvm->scan_timeout_dwork, iwl_mvm_scan_timeout_wk);
 	INIT_WORK(&mvm->add_stream_wk, iwl_mvm_add_new_dqa_stream_wk);
+	INIT_LIST_HEAD(&mvm->add_stream_txqs);
 
 	spin_lock_init(&mvm->d0i3_tx_lock);
 	spin_lock_init(&mvm->refs_lock);
@@ -1079,24 +1080,6 @@ static void iwl_mvm_rx_mq(struct iwl_op_mode *op_mode,
 		iwl_mvm_rx_common(mvm, rxb, pkt);
 }
 
-void iwl_mvm_stop_mac_queues(struct iwl_mvm *mvm, unsigned long mq)
-{
-	int q;
-
-	if (WARN_ON_ONCE(!mq))
-		return;
-
-	for_each_set_bit(q, &mq, IEEE80211_MAX_QUEUES) {
-		if (atomic_inc_return(&mvm->mac80211_queue_stop_count[q]) > 1) {
-			IWL_DEBUG_TX_QUEUES(mvm,
-					    "mac80211 %d already stopped\n", q);
-			continue;
-		}
-
-		ieee80211_stop_queue(mvm->hw, q);
-	}
-}
-
 static void iwl_mvm_async_cb(struct iwl_op_mode *op_mode,
 			     const struct iwl_device_cmd *cmd)
 {
@@ -1109,38 +1092,66 @@ static void iwl_mvm_async_cb(struct iwl_op_mode *op_mode,
 	iwl_trans_block_txq_ptrs(mvm->trans, false);
 }
 
-static void iwl_mvm_stop_sw_queue(struct iwl_op_mode *op_mode, int hw_queue)
+static void iwl_mvm_queue_state_change(struct iwl_op_mode *op_mode,
+				       int hw_queue, bool start)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
-	unsigned long mq = mvm->hw_queue_to_mac80211[hw_queue];
+	struct ieee80211_sta *sta;
+	struct ieee80211_txq *txq;
+	struct iwl_mvm_txq *mvmtxq;
+	int i;
+	unsigned long tid_bitmap;
+	struct iwl_mvm_sta *mvmsta;
+	u8 sta_id;
 
-	iwl_mvm_stop_mac_queues(mvm, mq);
-}
+	sta_id = iwl_mvm_has_new_tx_api(mvm) ?
+		mvm->tvqm_info[hw_queue].sta_id :
+		mvm->queue_info[hw_queue].ra_sta_id;
 
-void iwl_mvm_start_mac_queues(struct iwl_mvm *mvm, unsigned long mq)
-{
-	int q;
-
-	if (WARN_ON_ONCE(!mq))
+	if (WARN_ON_ONCE(sta_id >= ARRAY_SIZE(mvm->fw_id_to_mac_id)))
 		return;
 
-	for_each_set_bit(q, &mq, IEEE80211_MAX_QUEUES) {
-		if (atomic_dec_return(&mvm->mac80211_queue_stop_count[q]) > 0) {
-			IWL_DEBUG_TX_QUEUES(mvm,
-					    "mac80211 %d still stopped\n", q);
-			continue;
-		}
+	rcu_read_lock();
 
-		ieee80211_wake_queue(mvm->hw, q);
+	sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
+	if (IS_ERR_OR_NULL(sta))
+		goto out;
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		int tid = mvm->tvqm_info[hw_queue].txq_tid;
+
+		tid_bitmap = BIT(tid);
+	} else {
+		tid_bitmap = mvm->queue_info[hw_queue].tid_bitmap;
+	}
+
+	for_each_set_bit(i, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
+		int tid = i;
+
+		if (tid == IWL_MAX_TID_COUNT)
+			tid = IEEE80211_NUM_TIDS;
+
+		txq = sta->txq[tid];
+		mvmtxq = iwl_mvm_txq_from_mac80211(txq);
+		mvmtxq->stopped = !start;
+
+		if (start && mvmsta->sta_state != IEEE80211_STA_NOTEXIST)
+			iwl_mvm_mac_itxq_xmit(mvm->hw, txq);
 	}
+
+out:
+	rcu_read_unlock();
 }
 
-static void iwl_mvm_wake_sw_queue(struct iwl_op_mode *op_mode, int hw_queue)
+static void iwl_mvm_stop_sw_queue(struct iwl_op_mode *op_mode, int hw_queue)
 {
-	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
-	unsigned long mq = mvm->hw_queue_to_mac80211[hw_queue];
+	iwl_mvm_queue_state_change(op_mode, hw_queue, false);
+}
 
-	iwl_mvm_start_mac_queues(mvm, mq);
+static void iwl_mvm_wake_sw_queue(struct iwl_op_mode *op_mode, int hw_queue)
+{
+	iwl_mvm_queue_state_change(op_mode, hw_queue, true);
 }
 
 static void iwl_mvm_set_rfkill_state(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index e28009832da0..09f294c466da 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -356,24 +356,16 @@ static int iwl_mvm_invalidate_sta_queue(struct iwl_mvm *mvm, int queue,
 	return ret;
 }
 
-static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue,
-			       int mac80211_queue, u8 tid, u8 flags)
+static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			       int queue, u8 tid, u8 flags)
 {
 	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
 		.action = SCD_CFG_DISABLE_QUEUE,
 	};
-	bool remove_mac_queue = mac80211_queue != IEEE80211_INVAL_HW_QUEUE;
 	int ret;
 
-	if (WARN_ON(remove_mac_queue && mac80211_queue >= IEEE80211_MAX_QUEUES))
-		return -EINVAL;
-
 	if (iwl_mvm_has_new_tx_api(mvm)) {
-		if (remove_mac_queue)
-			mvm->hw_queue_to_mac80211[queue] &=
-				~BIT(mac80211_queue);
-
 		iwl_trans_txq_free(mvm->trans, queue);
 
 		return 0;
@@ -384,36 +376,15 @@ static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue,
 
 	mvm->queue_info[queue].tid_bitmap &= ~BIT(tid);
 
-	/*
-	 * If there is another TID with the same AC - don't remove the MAC queue
-	 * from the mapping
-	 */
-	if (tid < IWL_MAX_TID_COUNT) {
-		unsigned long tid_bitmap =
-			mvm->queue_info[queue].tid_bitmap;
-		int ac = tid_to_mac80211_ac[tid];
-		int i;
-
-		for_each_set_bit(i, &tid_bitmap, IWL_MAX_TID_COUNT) {
-			if (tid_to_mac80211_ac[i] == ac)
-				remove_mac_queue = false;
-		}
-	}
-
-	if (remove_mac_queue)
-		mvm->hw_queue_to_mac80211[queue] &=
-			~BIT(mac80211_queue);
-
 	cmd.action = mvm->queue_info[queue].tid_bitmap ?
 		SCD_CFG_ENABLE_QUEUE : SCD_CFG_DISABLE_QUEUE;
 	if (cmd.action == SCD_CFG_DISABLE_QUEUE)
 		mvm->queue_info[queue].status = IWL_MVM_QUEUE_FREE;
 
 	IWL_DEBUG_TX_QUEUES(mvm,
-			    "Disabling TXQ #%d tids=0x%x (mac80211 map:0x%x)\n",
+			    "Disabling TXQ #%d tids=0x%x\n",
 			    queue,
-			    mvm->queue_info[queue].tid_bitmap,
-			    mvm->hw_queue_to_mac80211[queue]);
+			    mvm->queue_info[queue].tid_bitmap);
 
 	/* If the queue is still enabled - nothing left to do in this func */
 	if (cmd.action == SCD_CFG_ENABLE_QUEUE)
@@ -423,15 +394,19 @@ static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue,
 	cmd.tid = mvm->queue_info[queue].txq_tid;
 
 	/* Make sure queue info is correct even though we overwrite it */
-	WARN(mvm->queue_info[queue].tid_bitmap ||
-	     mvm->hw_queue_to_mac80211[queue],
-	     "TXQ #%d info out-of-sync - mac map=0x%x, tids=0x%x\n",
-	     queue, mvm->hw_queue_to_mac80211[queue],
-	     mvm->queue_info[queue].tid_bitmap);
+	WARN(mvm->queue_info[queue].tid_bitmap,
+	     "TXQ #%d info out-of-sync - tids=0x%x\n",
+	     queue, mvm->queue_info[queue].tid_bitmap);
 
 	/* If we are here - the queue is freed and we can zero out these vals */
 	mvm->queue_info[queue].tid_bitmap = 0;
-	mvm->hw_queue_to_mac80211[queue] = 0;
+
+	if (sta) {
+		struct iwl_mvm_txq *mvmtxq =
+			iwl_mvm_txq_from_tid(sta, tid);
+
+		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
+	}
 
 	/* Regardless if this is a reserved TXQ for a STA - mark it as false */
 	mvm->queue_info[queue].reserved = false;
@@ -517,9 +492,14 @@ static int iwl_mvm_remove_sta_queue_marking(struct iwl_mvm *mvm, int queue)
 	spin_lock_bh(&mvmsta->lock);
 	/* Unmap MAC queues and TIDs from this queue */
 	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
+		struct iwl_mvm_txq *mvmtxq =
+			iwl_mvm_txq_from_tid(sta, tid);
+
 		if (mvmsta->tid_data[tid].state == IWL_AGG_ON)
 			disable_agg_tids |= BIT(tid);
 		mvmsta->tid_data[tid].txq_id = IWL_MVM_INVALID_QUEUE;
+
+		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
 	}
 
 	mvmsta->tfd_queue_msk &= ~BIT(queue); /* Don't use this queue anymore */
@@ -541,10 +521,11 @@ static int iwl_mvm_remove_sta_queue_marking(struct iwl_mvm *mvm, int queue)
 }
 
 static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
+				       struct ieee80211_sta *old_sta,
 				       u8 new_sta_id)
 {
 	struct iwl_mvm_sta *mvmsta;
-	u8 txq_curr_ac, sta_id, tid;
+	u8 sta_id, tid;
 	unsigned long disable_agg_tids = 0;
 	bool same_sta;
 	int ret;
@@ -554,7 +535,6 @@ static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return -EINVAL;
 
-	txq_curr_ac = mvm->queue_info[queue].mac80211_ac;
 	sta_id = mvm->queue_info[queue].ra_sta_id;
 	tid = mvm->queue_info[queue].txq_tid;
 
@@ -570,9 +550,7 @@ static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
 		iwl_mvm_invalidate_sta_queue(mvm, queue,
 					     disable_agg_tids, false);
 
-	ret = iwl_mvm_disable_txq(mvm, queue,
-				  mvmsta->vif->hw_queue[txq_curr_ac],
-				  tid, 0);
+	ret = iwl_mvm_disable_txq(mvm, old_sta, queue, tid, 0);
 	if (ret) {
 		IWL_ERR(mvm,
 			"Failed to free inactive queue %d (ret=%d)\n",
@@ -662,16 +640,15 @@ static int iwl_mvm_get_shared_queue(struct iwl_mvm *mvm,
  * in such a case, otherwise - if no redirection required - it does nothing,
  * unless the %force param is true.
  */
-static int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
-				      int ac, int ssn, unsigned int wdg_timeout,
-				      bool force)
+static int iwl_mvm_redirect_queue(struct iwl_mvm *mvm, int queue, int tid,
+				  int ac, int ssn, unsigned int wdg_timeout,
+				  bool force, struct iwl_mvm_txq *txq)
 {
 	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
 		.action = SCD_CFG_DISABLE_QUEUE,
 	};
 	bool shared_queue;
-	unsigned long mq;
 	int ret;
 
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
@@ -695,14 +672,14 @@ static int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 	cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
 	cmd.tx_fifo = iwl_mvm_ac_to_tx_fifo[mvm->queue_info[queue].mac80211_ac];
 	cmd.tid = mvm->queue_info[queue].txq_tid;
-	mq = mvm->hw_queue_to_mac80211[queue];
 	shared_queue = hweight16(mvm->queue_info[queue].tid_bitmap) > 1;
 
 	IWL_DEBUG_TX_QUEUES(mvm, "Redirecting TXQ #%d to FIFO #%d\n",
 			    queue, iwl_mvm_ac_to_tx_fifo[ac]);
 
-	/* Stop MAC queues and wait for this queue to empty */
-	iwl_mvm_stop_mac_queues(mvm, mq);
+	/* Stop the queue and wait for it to empty */
+	txq->stopped = true;
+
 	ret = iwl_trans_wait_tx_queues_empty(mvm->trans, BIT(queue));
 	if (ret) {
 		IWL_ERR(mvm, "Error draining queue %d before reconfig\n",
@@ -743,8 +720,8 @@ static int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 		iwl_trans_txq_set_shared_mode(mvm->trans, queue, true);
 
 out:
-	/* Continue using the MAC queues */
-	iwl_mvm_start_mac_queues(mvm, mq);
+	/* Continue using the queue */
+	txq->stopped = false;
 
 	return ret;
 }
@@ -769,7 +746,7 @@ static int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 sta_id,
 	return -ENOSPC;
 }
 
-static int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm, int mac80211_queue,
+static int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm,
 				   u8 sta_id, u8 tid, unsigned int timeout)
 {
 	int queue, size = IWL_DEFAULT_QUEUE_SIZE;
@@ -792,10 +769,7 @@ static int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm, int mac80211_queue,
 	IWL_DEBUG_TX_QUEUES(mvm, "Enabling TXQ #%d for sta %d tid %d\n",
 			    queue, sta_id, tid);
 
-	mvm->hw_queue_to_mac80211[queue] |= BIT(mac80211_queue);
-	IWL_DEBUG_TX_QUEUES(mvm,
-			    "Enabling TXQ #%d (mac80211 map:0x%x)\n",
-			    queue, mvm->hw_queue_to_mac80211[queue]);
+	IWL_DEBUG_TX_QUEUES(mvm, "Enabling TXQ #%d\n", queue);
 
 	return queue;
 }
@@ -805,9 +779,10 @@ static int iwl_mvm_sta_alloc_queue_tvqm(struct iwl_mvm *mvm,
 					int tid)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_mvm_txq *mvmtxq =
+		iwl_mvm_txq_from_tid(sta, tid);
 	unsigned int wdg_timeout =
 		iwl_mvm_get_wd_timeout(mvm, mvmsta->vif, false, false);
-	u8 mac_queue = mvmsta->vif->hw_queue[ac];
 	int queue = -1;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -815,11 +790,16 @@ static int iwl_mvm_sta_alloc_queue_tvqm(struct iwl_mvm *mvm,
 	IWL_DEBUG_TX_QUEUES(mvm,
 			    "Allocating queue for sta %d on tid %d\n",
 			    mvmsta->sta_id, tid);
-	queue = iwl_mvm_tvqm_enable_txq(mvm, mac_queue, mvmsta->sta_id, tid,
-					wdg_timeout);
+	queue = iwl_mvm_tvqm_enable_txq(mvm, mvmsta->sta_id, tid, wdg_timeout);
 	if (queue < 0)
 		return queue;
 
+	if (sta) {
+		mvmtxq->txq_id = queue;
+		mvm->tvqm_info[queue].txq_tid = tid;
+		mvm->tvqm_info[queue].sta_id = mvmsta->sta_id;
+	}
+
 	IWL_DEBUG_TX_QUEUES(mvm, "Allocated queue is %d\n", queue);
 
 	spin_lock_bh(&mvmsta->lock);
@@ -829,8 +809,9 @@ static int iwl_mvm_sta_alloc_queue_tvqm(struct iwl_mvm *mvm,
 	return 0;
 }
 
-static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
-				       int mac80211_queue, u8 sta_id, u8 tid)
+static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm,
+				       struct ieee80211_sta *sta,
+				       int queue, u8 sta_id, u8 tid)
 {
 	bool enable_queue = true;
 
@@ -845,14 +826,6 @@ static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
 	if (mvm->queue_info[queue].tid_bitmap)
 		enable_queue = false;
 
-	if (mac80211_queue != IEEE80211_INVAL_HW_QUEUE) {
-		WARN(mac80211_queue >=
-		     BITS_PER_BYTE * sizeof(mvm->hw_queue_to_mac80211[0]),
-		     "cannot track mac80211 queue %d (queue %d, sta %d, tid %d)\n",
-		     mac80211_queue, queue, sta_id, tid);
-		mvm->hw_queue_to_mac80211[queue] |= BIT(mac80211_queue);
-	}
-
 	mvm->queue_info[queue].tid_bitmap |= BIT(tid);
 	mvm->queue_info[queue].ra_sta_id = sta_id;
 
@@ -866,16 +839,22 @@ static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
 		mvm->queue_info[queue].txq_tid = tid;
 	}
 
+	if (sta) {
+		struct iwl_mvm_txq *mvmtxq =
+			iwl_mvm_txq_from_tid(sta, tid);
+
+		mvmtxq->txq_id = queue;
+	}
+
 	IWL_DEBUG_TX_QUEUES(mvm,
-			    "Enabling TXQ #%d tids=0x%x (mac80211 map:0x%x)\n",
-			    queue, mvm->queue_info[queue].tid_bitmap,
-			    mvm->hw_queue_to_mac80211[queue]);
+			    "Enabling TXQ #%d tids=0x%x\n",
+			    queue, mvm->queue_info[queue].tid_bitmap);
 
 	return enable_queue;
 }
 
-static bool iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue,
-			       int mac80211_queue, u16 ssn,
+static bool iwl_mvm_enable_txq(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			       int queue, u16 ssn,
 			       const struct iwl_trans_txq_scd_cfg *cfg,
 			       unsigned int wdg_timeout)
 {
@@ -895,8 +874,7 @@ static bool iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue,
 		return false;
 
 	/* Send the enabling command if we need to */
-	if (!iwl_mvm_update_txq_mapping(mvm, queue, mac80211_queue,
-					cfg->sta_id, cfg->tid))
+	if (!iwl_mvm_update_txq_mapping(mvm, sta, queue, cfg->sta_id, cfg->tid))
 		return false;
 
 	inc_ssn = iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn,
@@ -989,9 +967,10 @@ static void iwl_mvm_unshare_queue(struct iwl_mvm *mvm, int queue)
 
 	ssn = IEEE80211_SEQ_TO_SN(mvmsta->tid_data[tid].seq_number);
 
-	ret = iwl_mvm_scd_queue_redirect(mvm, queue, tid,
-					 tid_to_mac80211_ac[tid], ssn,
-					 wdg_timeout, true);
+	ret = iwl_mvm_redirect_queue(mvm, queue, tid,
+				     tid_to_mac80211_ac[tid], ssn,
+				     wdg_timeout, true,
+				     iwl_mvm_txq_from_tid(sta, tid));
 	if (ret) {
 		IWL_ERR(mvm, "Failed to redirect TXQ %d\n", queue);
 		return;
@@ -1068,11 +1047,9 @@ static bool iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 	 * Remove the ones that did.
 	 */
 	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
-		int mac_queue = mvmsta->vif->hw_queue[tid_to_mac80211_ac[tid]];
 		u16 tid_bitmap;
 
 		mvmsta->tid_data[tid].txq_id = IWL_MVM_INVALID_QUEUE;
-		mvm->hw_queue_to_mac80211[queue] &= ~BIT(mac_queue);
 		mvm->queue_info[queue].tid_bitmap &= ~BIT(tid);
 
 		tid_bitmap = mvm->queue_info[queue].tid_bitmap;
@@ -1105,10 +1082,6 @@ static bool iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 	 * sure all TIDs have existing corresponding mac queues enabled
 	 */
 	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
-	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
-		mvm->hw_queue_to_mac80211[queue] |=
-			BIT(mvmsta->vif->hw_queue[tid_to_mac80211_ac[tid]]);
-	}
 
 	/* If the queue is marked as shared - "unshare" it */
 	if (hweight16(mvm->queue_info[queue].tid_bitmap) == 1 &&
@@ -1136,6 +1109,7 @@ static int iwl_mvm_inactivity_check(struct iwl_mvm *mvm, u8 alloc_for_sta)
 	unsigned long unshare_queues = 0;
 	unsigned long changetid_queues = 0;
 	int i, ret, free_queue = -ENOSPC;
+	struct ieee80211_sta *queue_owner  = NULL;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1201,13 +1175,14 @@ static int iwl_mvm_inactivity_check(struct iwl_mvm *mvm, u8 alloc_for_sta)
 						   inactive_tid_bitmap,
 						   &unshare_queues,
 						   &changetid_queues);
-		if (ret >= 0 && free_queue < 0)
+		if (ret >= 0 && free_queue < 0) {
+			queue_owner = sta;
 			free_queue = ret;
+		}
 		/* only unlock sta lock - we still need the queue info lock */
 		spin_unlock_bh(&mvmsta->lock);
 	}
 
-	rcu_read_unlock();
 
 	/* Reconfigure queues requiring reconfiguation */
 	for_each_set_bit(i, &unshare_queues, IWL_MAX_HW_QUEUES)
@@ -1216,18 +1191,21 @@ static int iwl_mvm_inactivity_check(struct iwl_mvm *mvm, u8 alloc_for_sta)
 		iwl_mvm_change_queue_tid(mvm, i);
 
 	if (free_queue >= 0 && alloc_for_sta != IWL_MVM_INVALID_STA) {
-		ret = iwl_mvm_free_inactive_queue(mvm, free_queue,
+		ret = iwl_mvm_free_inactive_queue(mvm, free_queue, queue_owner,
 						  alloc_for_sta);
-		if (ret)
+		if (ret) {
+			rcu_read_unlock();
 			return ret;
+		}
 	}
 
+	rcu_read_unlock();
+
 	return free_queue;
 }
 
 static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
-				   struct ieee80211_sta *sta, u8 ac, int tid,
-				   struct ieee80211_hdr *hdr)
+				   struct ieee80211_sta *sta, u8 ac, int tid)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_trans_txq_scd_cfg cfg = {
@@ -1238,7 +1216,6 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	};
 	unsigned int wdg_timeout =
 		iwl_mvm_get_wd_timeout(mvm, mvmsta->vif, false, false);
-	u8 mac_queue = mvmsta->vif->hw_queue[ac];
 	int queue = -1;
 	unsigned long disable_agg_tids = 0;
 	enum iwl_mvm_agg_state queue_state;
@@ -1257,12 +1234,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	ssn = IEEE80211_SEQ_TO_SN(mvmsta->tid_data[tid].seq_number);
 	spin_unlock_bh(&mvmsta->lock);
 
-	/*
-	 * Non-QoS, QoS NDP and MGMT frames should go to a MGMT queue, if one
-	 * exists
-	 */
-	if (!ieee80211_is_data_qos(hdr->frame_control) ||
-	    ieee80211_is_qos_nullfunc(hdr->frame_control)) {
+	if (tid == IWL_MAX_TID_COUNT) {
 		queue = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
 						IWL_MVM_DQA_MIN_MGMT_QUEUE,
 						IWL_MVM_DQA_MAX_MGMT_QUEUE);
@@ -1341,8 +1313,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		}
 	}
 
-	inc_ssn = iwl_mvm_enable_txq(mvm, queue, mac_queue,
-				     ssn, &cfg, wdg_timeout);
+	inc_ssn = iwl_mvm_enable_txq(mvm, sta, queue, ssn, &cfg, wdg_timeout);
 
 	/*
 	 * Mark queue as shared in transport if shared
@@ -1384,8 +1355,9 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		}
 	} else {
 		/* Redirect queue, if needed */
-		ret = iwl_mvm_scd_queue_redirect(mvm, queue, tid, ac, ssn,
-						 wdg_timeout, false);
+		ret = iwl_mvm_redirect_queue(mvm, queue, tid, ac, ssn,
+					     wdg_timeout, false,
+					     iwl_mvm_txq_from_tid(sta, tid));
 		if (ret)
 			goto out_err;
 	}
@@ -1393,7 +1365,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	return 0;
 
 out_err:
-	iwl_mvm_disable_txq(mvm, queue, mac_queue, tid, 0);
+	iwl_mvm_disable_txq(mvm, sta, queue, tid, 0);
 
 	return ret;
 }
@@ -1406,87 +1378,34 @@ static inline u8 iwl_mvm_tid_to_ac_queue(int tid)
 	return tid_to_mac80211_ac[tid];
 }
 
-static void iwl_mvm_tx_deferred_stream(struct iwl_mvm *mvm,
-				       struct ieee80211_sta *sta, int tid)
-{
-	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
-	struct sk_buff *skb;
-	struct ieee80211_hdr *hdr;
-	struct sk_buff_head deferred_tx;
-	u8 mac_queue;
-	bool no_queue = false; /* Marks if there is a problem with the queue */
-	u8 ac;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	skb = skb_peek(&tid_data->deferred_tx_frames);
-	if (!skb)
-		return;
-	hdr = (void *)skb->data;
-
-	ac = iwl_mvm_tid_to_ac_queue(tid);
-	mac_queue = IEEE80211_SKB_CB(skb)->hw_queue;
-
-	if (tid_data->txq_id == IWL_MVM_INVALID_QUEUE &&
-	    iwl_mvm_sta_alloc_queue(mvm, sta, ac, tid, hdr)) {
-		IWL_ERR(mvm,
-			"Can't alloc TXQ for sta %d tid %d - dropping frame\n",
-			mvmsta->sta_id, tid);
-
-		/*
-		 * Mark queue as problematic so later the deferred traffic is
-		 * freed, as we can do nothing with it
-		 */
-		no_queue = true;
-	}
-
-	__skb_queue_head_init(&deferred_tx);
-
-	/* Disable bottom-halves when entering TX path */
-	local_bh_disable();
-	spin_lock(&mvmsta->lock);
-	skb_queue_splice_init(&tid_data->deferred_tx_frames, &deferred_tx);
-	mvmsta->deferred_traffic_tid_map &= ~BIT(tid);
-	spin_unlock(&mvmsta->lock);
-
-	while ((skb = __skb_dequeue(&deferred_tx)))
-		if (no_queue || iwl_mvm_tx_skb(mvm, skb, sta))
-			ieee80211_free_txskb(mvm->hw, skb);
-	local_bh_enable();
-
-	/* Wake queue */
-	iwl_mvm_start_mac_queues(mvm, BIT(mac_queue));
-}
-
 void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 {
 	struct iwl_mvm *mvm = container_of(wk, struct iwl_mvm,
 					   add_stream_wk);
-	struct ieee80211_sta *sta;
-	struct iwl_mvm_sta *mvmsta;
-	unsigned long deferred_tid_traffic;
-	int sta_id, tid;
 
 	mutex_lock(&mvm->mutex);
 
 	iwl_mvm_inactivity_check(mvm, IWL_MVM_INVALID_STA);
 
-	/* Go over all stations with deferred traffic */
-	for_each_set_bit(sta_id, mvm->sta_deferred_frames,
-			 IWL_MVM_STATION_COUNT) {
-		clear_bit(sta_id, mvm->sta_deferred_frames);
-		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
-						lockdep_is_held(&mvm->mutex));
-		if (IS_ERR_OR_NULL(sta))
-			continue;
+	while (!list_empty(&mvm->add_stream_txqs)) {
+		struct iwl_mvm_txq *mvmtxq;
+		struct ieee80211_txq *txq;
+		u8 tid;
 
-		mvmsta = iwl_mvm_sta_from_mac80211(sta);
-		deferred_tid_traffic = mvmsta->deferred_traffic_tid_map;
+		mvmtxq = list_first_entry(&mvm->add_stream_txqs,
+					  struct iwl_mvm_txq, list);
+
+		txq = container_of((void *)mvmtxq, struct ieee80211_txq,
+				   drv_priv);
+		tid = txq->tid;
+		if (tid == IEEE80211_NUM_TIDS)
+			tid = IWL_MAX_TID_COUNT;
 
-		for_each_set_bit(tid, &deferred_tid_traffic,
-				 IWL_MAX_TID_COUNT + 1)
-			iwl_mvm_tx_deferred_stream(mvm, sta, tid);
+		iwl_mvm_sta_alloc_queue(mvm, txq->sta, txq->ac, tid);
+		list_del_init(&mvmtxq->list);
+		local_bh_disable();
+		iwl_mvm_mac_itxq_xmit(mvm->hw, txq);
+		local_bh_enable();
 	}
 
 	mutex_unlock(&mvm->mutex);
@@ -1542,10 +1461,11 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
  * Note that re-enabling aggregations isn't done in this function.
  */
 static void iwl_mvm_realloc_queues_after_restart(struct iwl_mvm *mvm,
-						 struct iwl_mvm_sta *mvm_sta)
+						 struct ieee80211_sta *sta)
 {
-	unsigned int wdg_timeout =
-			iwl_mvm_get_wd_timeout(mvm, mvm_sta->vif, false, false);
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+	unsigned int wdg =
+		iwl_mvm_get_wd_timeout(mvm, mvm_sta->vif, false, false);
 	int i;
 	struct iwl_trans_txq_scd_cfg cfg = {
 		.sta_id = mvm_sta->sta_id,
@@ -1561,23 +1481,18 @@ static void iwl_mvm_realloc_queues_after_restart(struct iwl_mvm *mvm,
 		struct iwl_mvm_tid_data *tid_data = &mvm_sta->tid_data[i];
 		int txq_id = tid_data->txq_id;
 		int ac;
-		u8 mac_queue;
 
 		if (txq_id == IWL_MVM_INVALID_QUEUE)
 			continue;
 
-		skb_queue_head_init(&tid_data->deferred_tx_frames);
-
 		ac = tid_to_mac80211_ac[i];
-		mac_queue = mvm_sta->vif->hw_queue[ac];
 
 		if (iwl_mvm_has_new_tx_api(mvm)) {
 			IWL_DEBUG_TX_QUEUES(mvm,
 					    "Re-mapping sta %d tid %d\n",
 					    mvm_sta->sta_id, i);
-			txq_id = iwl_mvm_tvqm_enable_txq(mvm, mac_queue,
-							 mvm_sta->sta_id,
-							 i, wdg_timeout);
+			txq_id = iwl_mvm_tvqm_enable_txq(mvm, mvm_sta->sta_id,
+							 i, wdg);
 			tid_data->txq_id = txq_id;
 
 			/*
@@ -1600,8 +1515,7 @@ static void iwl_mvm_realloc_queues_after_restart(struct iwl_mvm *mvm,
 					    "Re-mapping sta %d tid %d to queue %d\n",
 					    mvm_sta->sta_id, i, txq_id);
 
-			iwl_mvm_enable_txq(mvm, txq_id, mac_queue, seq, &cfg,
-					   wdg_timeout);
+			iwl_mvm_enable_txq(mvm, sta, txq_id, seq, &cfg, wdg);
 			mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_READY;
 		}
 	}
@@ -1691,7 +1605,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		if (ret)
 			goto err;
 
-		iwl_mvm_realloc_queues_after_restart(mvm, mvm_sta);
+		iwl_mvm_realloc_queues_after_restart(mvm, sta);
 		sta_update = true;
 		sta_flags = iwl_mvm_has_new_tx_api(mvm) ? 0 : STA_MODIFY_QUEUES;
 		goto update_fw;
@@ -1724,9 +1638,17 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		 * frames until the queue is allocated
 		 */
 		mvm_sta->tid_data[i].txq_id = IWL_MVM_INVALID_QUEUE;
-		skb_queue_head_init(&mvm_sta->tid_data[i].deferred_tx_frames);
 	}
-	mvm_sta->deferred_traffic_tid_map = 0;
+
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
+		struct iwl_mvm_txq *mvmtxq =
+			iwl_mvm_txq_from_mac80211(sta->txq[i]);
+
+		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
+		INIT_LIST_HEAD(&mvmtxq->list);
+		spin_lock_init(&mvmtxq->tx_path_lock);
+	}
+
 	mvm_sta->agg_tids = 0;
 
 	if (iwl_mvm_has_new_rx_api(mvm) &&
@@ -1861,9 +1783,9 @@ static int iwl_mvm_rm_sta_common(struct iwl_mvm *mvm, u8 sta_id)
 
 static void iwl_mvm_disable_sta_queues(struct iwl_mvm *mvm,
 				       struct ieee80211_vif *vif,
-				       struct iwl_mvm_sta *mvm_sta)
+				       struct ieee80211_sta *sta)
 {
-	int ac;
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	int i;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1872,11 +1794,17 @@ static void iwl_mvm_disable_sta_queues(struct iwl_mvm *mvm,
 		if (mvm_sta->tid_data[i].txq_id == IWL_MVM_INVALID_QUEUE)
 			continue;
 
-		ac = iwl_mvm_tid_to_ac_queue(i);
-		iwl_mvm_disable_txq(mvm, mvm_sta->tid_data[i].txq_id,
-				    vif->hw_queue[ac], i, 0);
+		iwl_mvm_disable_txq(mvm, sta, mvm_sta->tid_data[i].txq_id, i,
+				    0);
 		mvm_sta->tid_data[i].txq_id = IWL_MVM_INVALID_QUEUE;
 	}
+
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
+		struct iwl_mvm_txq *mvmtxq =
+			iwl_mvm_txq_from_mac80211(sta->txq[i]);
+
+		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
+	}
 }
 
 int iwl_mvm_wait_sta_queues_empty(struct iwl_mvm *mvm,
@@ -1938,7 +1866,7 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 
 	ret = iwl_mvm_drain_sta(mvm, mvm_sta, false);
 
-	iwl_mvm_disable_sta_queues(mvm, vif, mvm_sta);
+	iwl_mvm_disable_sta_queues(mvm, vif, sta);
 
 	/* If there is a TXQ still marked as reserved - free it */
 	if (mvm_sta->reserved_queue != IEEE80211_INVAL_HW_QUEUE) {
@@ -2044,7 +1972,7 @@ static void iwl_mvm_enable_aux_snif_queue(struct iwl_mvm *mvm, u16 *queue,
 
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		int tvqm_queue =
-			iwl_mvm_tvqm_enable_txq(mvm, *queue, sta_id,
+			iwl_mvm_tvqm_enable_txq(mvm, sta_id,
 						IWL_MAX_TID_COUNT,
 						wdg_timeout);
 		*queue = tvqm_queue;
@@ -2057,7 +1985,7 @@ static void iwl_mvm_enable_aux_snif_queue(struct iwl_mvm *mvm, u16 *queue,
 			.frame_limit = IWL_FRAME_LIMIT,
 		};
 
-		iwl_mvm_enable_txq(mvm, *queue, *queue, 0, &cfg, wdg_timeout);
+		iwl_mvm_enable_txq(mvm, NULL, *queue, 0, &cfg, wdg_timeout);
 	}
 }
 
@@ -2135,8 +2063,7 @@ int iwl_mvm_rm_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	iwl_mvm_disable_txq(mvm, mvm->snif_queue, mvm->snif_queue,
-			    IWL_MAX_TID_COUNT, 0);
+	iwl_mvm_disable_txq(mvm, NULL, mvm->snif_queue, IWL_MAX_TID_COUNT, 0);
 	ret = iwl_mvm_rm_sta_common(mvm, mvm->snif_sta.sta_id);
 	if (ret)
 		IWL_WARN(mvm, "Failed sending remove station\n");
@@ -2195,8 +2122,7 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 		bsta->tfd_queue_msk |= BIT(queue);
 
-		iwl_mvm_enable_txq(mvm, queue, vif->hw_queue[0], 0,
-				   &cfg, wdg_timeout);
+		iwl_mvm_enable_txq(mvm, NULL, queue, 0, &cfg, wdg_timeout);
 	}
 
 	if (vif->type == NL80211_IFTYPE_ADHOC)
@@ -2215,8 +2141,7 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	 * to firmware so enable queue here - after the station was added
 	 */
 	if (iwl_mvm_has_new_tx_api(mvm)) {
-		queue = iwl_mvm_tvqm_enable_txq(mvm, vif->hw_queue[0],
-						bsta->sta_id,
+		queue = iwl_mvm_tvqm_enable_txq(mvm, bsta->sta_id,
 						IWL_MAX_TID_COUNT,
 						wdg_timeout);
 
@@ -2254,7 +2179,7 @@ static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
 		return;
 	}
 
-	iwl_mvm_disable_txq(mvm, queue, vif->hw_queue[0], IWL_MAX_TID_COUNT, 0);
+	iwl_mvm_disable_txq(mvm, NULL, queue, IWL_MAX_TID_COUNT, 0);
 	if (iwl_mvm_has_new_tx_api(mvm))
 		return;
 
@@ -2377,10 +2302,8 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	 * Note that this is done here as we want to avoid making DQA
 	 * changes in mac80211 layer.
 	 */
-	if (vif->type == NL80211_IFTYPE_ADHOC) {
-		vif->cab_queue = IWL_MVM_DQA_GCAST_QUEUE;
-		mvmvif->cab_queue = vif->cab_queue;
-	}
+	if (vif->type == NL80211_IFTYPE_ADHOC)
+		mvmvif->cab_queue = IWL_MVM_DQA_GCAST_QUEUE;
 
 	/*
 	 * While in previous FWs we had to exclude cab queue from TFD queue
@@ -2388,9 +2311,9 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	 */
 	if (!iwl_mvm_has_new_tx_api(mvm) &&
 	    fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STA_TYPE)) {
-		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue, 0,
-				   &cfg, timeout);
-		msta->tfd_queue_msk |= BIT(vif->cab_queue);
+		iwl_mvm_enable_txq(mvm, NULL, mvmvif->cab_queue, 0, &cfg,
+				   timeout);
+		msta->tfd_queue_msk |= BIT(mvmvif->cab_queue);
 	}
 	ret = iwl_mvm_add_int_sta_common(mvm, msta, maddr,
 					 mvmvif->id, mvmvif->color);
@@ -2407,15 +2330,14 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	 * tfd_queue_mask.
 	 */
 	if (iwl_mvm_has_new_tx_api(mvm)) {
-		int queue = iwl_mvm_tvqm_enable_txq(mvm, vif->cab_queue,
-						    msta->sta_id,
+		int queue = iwl_mvm_tvqm_enable_txq(mvm, msta->sta_id,
 						    0,
 						    timeout);
 		mvmvif->cab_queue = queue;
 	} else if (!fw_has_api(&mvm->fw->ucode_capa,
 			       IWL_UCODE_TLV_API_STA_TYPE))
-		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue, 0,
-				   &cfg, timeout);
+		iwl_mvm_enable_txq(mvm, NULL, mvmvif->cab_queue, 0, &cfg,
+				   timeout);
 
 	if (mvmvif->ap_wep_key) {
 		u8 key_offset = iwl_mvm_set_fw_key_idx(mvm);
@@ -2446,8 +2368,7 @@ int iwl_mvm_rm_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	iwl_mvm_flush_sta(mvm, &mvmvif->mcast_sta, true, 0);
 
-	iwl_mvm_disable_txq(mvm, mvmvif->cab_queue, vif->cab_queue,
-			    0, 0);
+	iwl_mvm_disable_txq(mvm, NULL, mvmvif->cab_queue, 0, 0);
 
 	ret = iwl_mvm_rm_sta_common(mvm, mvmvif->mcast_sta.sta_id);
 	if (ret)
@@ -2976,8 +2897,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	}
 
 	if (alloc_queue)
-		iwl_mvm_enable_txq(mvm, queue,
-				   vif->hw_queue[tid_to_mac80211_ac[tid]], ssn,
+		iwl_mvm_enable_txq(mvm, sta, queue, ssn,
 				   &cfg, wdg_timeout);
 
 	/* Send ADD_STA command to enable aggs only if the queue isn't shared */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index d52cd888f77d..0614296244b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -297,7 +297,6 @@ enum iwl_mvm_agg_state {
 
 /**
  * struct iwl_mvm_tid_data - holds the states for each RA / TID
- * @deferred_tx_frames: deferred TX frames for this RA/TID
  * @seq_number: the next WiFi sequence number to use
  * @next_reclaimed: the WiFi sequence number of the next packet to be acked.
  *	This is basically (last acked packet++).
@@ -318,7 +317,6 @@ enum iwl_mvm_agg_state {
  *	 tpt_meas_start
  */
 struct iwl_mvm_tid_data {
-	struct sk_buff_head deferred_tx_frames;
 	u16 seq_number;
 	u16 next_reclaimed;
 	/* The rest is Tx AGG related */
@@ -427,8 +425,6 @@ struct iwl_mvm_sta {
 	struct iwl_mvm_key_pn __rcu *ptk_pn[4];
 	struct iwl_mvm_rxq_dup_data *dup_data;
 
-	u16 deferred_traffic_tid_map;
-
 	u8 reserved_queue;
 
 	/* Temporary, until the new TLC will control the Tx protection */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 995fe2a6abbb..dfdfaa9ecfdb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -602,11 +602,12 @@ static void iwl_mvm_skb_prepare_status(struct sk_buff *skb,
 }
 
 static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
-				      struct ieee80211_tx_info *info, __le16 fc)
+				      struct ieee80211_tx_info *info,
+				      struct ieee80211_hdr *hdr)
 {
-	struct iwl_mvm_vif *mvmvif;
-
-	mvmvif = iwl_mvm_vif_from_mac80211(info->control.vif);
+	struct iwl_mvm_vif *mvmvif =
+		iwl_mvm_vif_from_mac80211(info->control.vif);
+	__le16 fc = hdr->frame_control;
 
 	switch (info->control.vif->type) {
 	case NL80211_IFTYPE_AP:
@@ -625,7 +626,9 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 		    (!ieee80211_is_bufferable_mmpdu(fc) ||
 		     ieee80211_is_deauth(fc) || ieee80211_is_disassoc(fc)))
 			return mvm->probe_queue;
-		if (info->hw_queue == info->control.vif->cab_queue)
+
+		if (!ieee80211_has_order(fc) && !ieee80211_is_probe_req(fc) &&
+		    is_multicast_ether_addr(hdr->addr1))
 			return mvmvif->cab_queue;
 
 		WARN_ONCE(info->control.vif->type != NL80211_IFTYPE_ADHOC,
@@ -634,8 +637,6 @@ static int iwl_mvm_get_ctrl_vif_queue(struct iwl_mvm *mvm,
 	case NL80211_IFTYPE_P2P_DEVICE:
 		if (ieee80211_is_mgmt(fc))
 			return mvm->p2p_dev_queue;
-		if (info->hw_queue == info->control.vif->cab_queue)
-			return mvmvif->cab_queue;
 
 		WARN_ON_ONCE(1);
 		return mvm->p2p_dev_queue;
@@ -713,6 +714,8 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	u8 sta_id;
 	int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	__le16 fc = hdr->frame_control;
+	bool offchannel = IEEE80211_SKB_CB(skb)->flags &
+		IEEE80211_TX_CTL_TX_OFFCHAN;
 	int queue = -1;
 
 	memcpy(&info, skb->cb, sizeof(info));
@@ -720,11 +723,6 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	if (WARN_ON_ONCE(info.flags & IEEE80211_TX_CTL_AMPDU))
 		return -1;
 
-	if (WARN_ON_ONCE(info.flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM &&
-			 (!info.control.vif ||
-			  info.hw_queue != info.control.vif->cab_queue)))
-		return -1;
-
 	if (info.control.vif) {
 		struct iwl_mvm_vif *mvmvif =
 			iwl_mvm_vif_from_mac80211(info.control.vif);
@@ -737,14 +735,12 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 			else
 				sta_id = mvmvif->mcast_sta.sta_id;
 
-			queue = iwl_mvm_get_ctrl_vif_queue(mvm, &info,
-							   hdr->frame_control);
-
+			queue = iwl_mvm_get_ctrl_vif_queue(mvm, &info, hdr);
 		} else if (info.control.vif->type == NL80211_IFTYPE_MONITOR) {
 			queue = mvm->snif_queue;
 			sta_id = mvm->snif_sta.sta_id;
 		} else if (info.control.vif->type == NL80211_IFTYPE_STATION &&
-			   info.hw_queue == IWL_MVM_OFFCHANNEL_QUEUE) {
+			   offchannel) {
 			/*
 			 * IWL_MVM_OFFCHANNEL_QUEUE is used for ROC packets
 			 * that can be used in 2 different types of vifs, P2P &
@@ -758,8 +754,10 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 		}
 	}
 
-	if (queue < 0)
+	if (queue < 0) {
+		IWL_ERR(mvm, "No queue was found. Dropping TX\n");
 		return -1;
+	}
 
 	if (unlikely(ieee80211_is_probe_resp(fc)))
 		iwl_mvm_probe_resp_set_noa(mvm, skb);
@@ -1002,34 +1000,6 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 }
 #endif
 
-static void iwl_mvm_tx_add_stream(struct iwl_mvm *mvm,
-				  struct iwl_mvm_sta *mvm_sta, u8 tid,
-				  struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	u8 mac_queue = info->hw_queue;
-	struct sk_buff_head *deferred_tx_frames;
-
-	lockdep_assert_held(&mvm_sta->lock);
-
-	mvm_sta->deferred_traffic_tid_map |= BIT(tid);
-	set_bit(mvm_sta->sta_id, mvm->sta_deferred_frames);
-
-	deferred_tx_frames = &mvm_sta->tid_data[tid].deferred_tx_frames;
-
-	skb_queue_tail(deferred_tx_frames, skb);
-
-	/*
-	 * The first deferred frame should've stopped the MAC queues, so we
-	 * should never get a second deferred frame for the RA/TID.
-	 * In case of GSO the first packet may have been split, so don't warn.
-	 */
-	if (skb_queue_len(deferred_tx_frames) == 1) {
-		iwl_mvm_stop_mac_queues(mvm, BIT(mac_queue));
-		schedule_work(&mvm->add_stream_wk);
-	}
-}
-
 /* Check if there are any timed-out TIDs on a given shared TXQ */
 static bool iwl_mvm_txq_should_update(struct iwl_mvm *mvm, int txq_id)
 {
@@ -1088,7 +1058,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	__le16 fc;
 	u16 seq_number = 0;
 	u8 tid = IWL_MAX_TID_COUNT;
-	u16 txq_id = info->hw_queue;
+	u16 txq_id;
 	bool is_ampdu = false;
 	int hdrlen;
 
@@ -1152,14 +1122,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM);
 
-	/* Check if TXQ needs to be allocated or re-activated */
-	if (unlikely(txq_id == IWL_MVM_INVALID_QUEUE)) {
-		iwl_mvm_tx_add_stream(mvm, mvmsta, tid, skb);
-
-		/*
-		 * The frame is now deferred, and the worker scheduled
-		 * will re-allocate it, so we can free it for now.
-		 */
+	if (WARN_ON_ONCE(txq_id == IWL_MVM_INVALID_QUEUE)) {
 		iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
 		spin_unlock(&mvmsta->lock);
 		return 0;
-- 
2.20.1

