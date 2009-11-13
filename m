Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292AbZKMT4v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:51 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/16] iwlwifi: handle unicast PS buffering
Date: Fri, 13 Nov 2009 11:56:37 -0800
Message-Id: <1258142198-3223-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

Using the new mac80211 functionality, this makes
iwlwifi handle unicast PS buffering correctly.
The device works like this:

 * when a station goes to sleep, the microcode notices
   this and marks the station as asleep
 * when the station is marked asleep, the microcode
   refuses to transmit to the station and rejects all
   frames queued to it with the failure status code
   TX_STATUS_FAIL_DEST_PS (a previous patch handled
   this correctly)
 * when we need to send frames to the station _although_
   it is asleep, we need to tell the ucode how many,
   and this is asynchronous with sending so we cannot
   just send the frames, we need to wait for all other
   frames to be flushed, and then update the counter
   before sending out the poll response frames. This
   is handled partially in the driver and partially in
   mac80211.

In order to do all this correctly, we need to
 * keep track of how many frames are pending for each
   associated client station (avoid doing it for other
   stations to avoid the atomic ops)
 * tell mac80211 that we driver-block the PS status
   while there are still frames pending on the queues,
   and once they are all rejected (due to the dest sta
   being in PS) unblock mac80211

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   42 +++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   10 ++----
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   17 +--------
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   29 +++++++--------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   51 ++++++++++++++++++++++++++-
 8 files changed, 113 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6db7447..9223397 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2745,6 +2745,45 @@ static int iwl_mac_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static void iwl_mac_sta_notify(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       enum sta_notify_cmd cmd,
+			       struct ieee80211_sta *sta)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
+	int sta_id;
+
+	/*
+	 * TODO: We really should use this callback to
+	 *	 actually maintain the station table in
+	 *	 the device.
+	 */
+
+	switch (cmd) {
+	case STA_NOTIFY_ADD:
+		atomic_set(&sta_priv->pending_frames, 0);
+		if (vif->type == NL80211_IFTYPE_AP)
+			sta_priv->client = true;
+		break;
+	case STA_NOTIFY_SLEEP:
+		WARN_ON(!sta_priv->client);
+		sta_priv->asleep = true;
+		if (atomic_read(&sta_priv->pending_frames) > 0)
+			ieee80211_sta_block_awake(hw, sta, true);
+		break;
+	case STA_NOTIFY_AWAKE:
+		WARN_ON(!sta_priv->client);
+		sta_priv->asleep = false;
+		sta_id = iwl_find_station(priv, sta->addr);
+		if (sta_id != IWL_INVALID_STATION)
+			iwl_sta_modify_ps_wake(priv, sta_id);
+		break;
+	default:
+		break;
+	}
+}
+
 /*****************************************************************************
  *
  * sysfs attributes
@@ -3176,7 +3215,8 @@ static struct ieee80211_ops iwl_hw_ops = {
 	.reset_tsf = iwl_mac_reset_tsf,
 	.bss_info_changed = iwl_bss_info_changed,
 	.ampdu_action = iwl_mac_ampdu_action,
-	.hw_scan = iwl_mac_hw_scan
+	.hw_scan = iwl_mac_hw_scan,
+	.sta_notify = iwl_mac_sta_notify,
 };
 
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index aa4e38c..e915075 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -977,6 +977,7 @@ struct iwl_qosparam_cmd {
 #define	STA_MODIFY_TX_RATE_MSK		0x04
 #define STA_MODIFY_ADDBA_TID_MSK	0x08
 #define STA_MODIFY_DELBA_TID_MSK	0x10
+#define STA_MODIFY_SLEEP_TX_COUNT_MSK	0x20
 
 /* Receiver address (actually, Rx station's index into station table),
  * combined with Traffic ID (QOS priority), in format used by Tx Scheduler */
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index ba9c96f..9a5ca25 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -336,8 +336,6 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 			pos += scnprintf(buf + pos, bufsz - pos,
 					"flags: 0x%x\n",
 					station->sta.station_flags_msk);
-			pos += scnprintf(buf + pos, bufsz - pos,
-					"ps_status: %u\n", station->ps_status);
 			pos += scnprintf(buf + pos, bufsz - pos, "tid data:\n");
 			pos += scnprintf(buf + pos, bufsz - pos,
 					"seq_num\t\ttxq_id");
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a474383..f1601cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -545,15 +545,11 @@ struct iwl_qos_info {
 	struct iwl_qosparam_cmd def_qos_parm;
 };
 
-#define STA_PS_STATUS_WAKE             0
-#define STA_PS_STATUS_SLEEP            1
-
 
 struct iwl3945_station_entry {
 	struct iwl3945_addsta_cmd sta;
 	struct iwl_tid_data tid[MAX_TID_COUNT];
 	u8 used;
-	u8 ps_status;
 	struct iwl_hw_key keyinfo;
 };
 
@@ -561,7 +557,6 @@ struct iwl_station_entry {
 	struct iwl_addsta_cmd sta;
 	struct iwl_tid_data tid[MAX_TID_COUNT];
 	u8 used;
-	u8 ps_status;
 	struct iwl_hw_key keyinfo;
 };
 
@@ -571,11 +566,12 @@ struct iwl_station_entry {
  * When mac80211 creates a station it reserves some space (hw->sta_data_size)
  * in the structure for use by driver. This structure is places in that
  * space.
- *
- * At the moment use it for the station's rate scaling information.
  */
 struct iwl_station_priv {
 	struct iwl_lq_sta lq_sta;
+	atomic_t pending_frames;
+	bool client;
+	bool asleep;
 };
 
 /* one for each uCode image (inst/data, boot/init/runtime) */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 9d010a0..cc980d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1028,7 +1028,6 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	struct iwl4965_rx_mpdu_res_start *amsdu;
 	u32 len;
 	u32 ampdu_status;
-	u16 fc;
 	u32 rate_n_flags;
 
 	/**
@@ -1161,20 +1160,8 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 		priv->last_tsf = le64_to_cpu(phy_res->timestamp);
 	}
 
-	fc = le16_to_cpu(header->frame_control);
-	switch (fc & IEEE80211_FCTL_FTYPE) {
-	case IEEE80211_FTYPE_MGMT:
-	case IEEE80211_FTYPE_DATA:
-		if (priv->iw_mode == NL80211_IFTYPE_AP)
-			iwl_update_ps_mode(priv, fc  & IEEE80211_FCTL_PM,
-						header->addr2);
-		/* fall through */
-	default:
-		iwl_pass_packet_to_mac80211(priv, header, len, ampdu_status,
-				rxb, &rx_status);
-		break;
-
-	}
+	iwl_pass_packet_to_mac80211(priv, header, len, ampdu_status,
+				    rxb, &rx_status);
 }
 EXPORT_SYMBOL(iwl_rx_reply_rx);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index eba36f7..cd6a690 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1216,7 +1216,7 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid)
 }
 EXPORT_SYMBOL(iwl_sta_rx_agg_stop);
 
-static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
+void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 {
 	unsigned long flags;
 
@@ -1224,27 +1224,26 @@ static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 	priv->stations[sta_id].sta.station_flags &= ~STA_FLG_PWR_SAVE_MSK;
 	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
 	priv->stations[sta_id].sta.sta.modify_mask = 0;
+	priv->stations[sta_id].sta.sleep_tx_count = 0;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
+EXPORT_SYMBOL(iwl_sta_modify_ps_wake);
 
-void iwl_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr)
+void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt)
 {
-	/* FIXME: need locking over ps_status ??? */
-	u8 sta_id = iwl_find_station(priv, addr);
+	unsigned long flags;
 
-	if (sta_id != IWL_INVALID_STATION) {
-		u8 sta_awake = priv->stations[sta_id].
-				ps_status == STA_PS_STATUS_WAKE;
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].sta.station_flags |= STA_FLG_PWR_SAVE_MSK;
+	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
+	priv->stations[sta_id].sta.sta.modify_mask =
+					STA_MODIFY_SLEEP_TX_COUNT_MSK;
+	priv->stations[sta_id].sta.sleep_tx_count = cpu_to_le16(cnt);
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-		if (sta_awake && ps_bit)
-			priv->stations[sta_id].ps_status = STA_PS_STATUS_SLEEP;
-		else if (!sta_awake && !ps_bit) {
-			iwl_sta_modify_ps_wake(priv, sta_id);
-			priv->stations[sta_id].ps_status = STA_PS_STATUS_WAKE;
-		}
-	}
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
-
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 1c382de..8d052de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -66,5 +66,6 @@ void iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid);
 int iwl_sta_rx_agg_start(struct iwl_priv *priv,
 			 const u8 *addr, int tid, u16 ssn);
 int iwl_sta_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid);
-void iwl_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr);
+void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id);
+void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt);
 #endif /* __iwl_sta_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 6199bf6..5f1e5f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -710,6 +710,8 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sta *sta = info->control.sta;
+	struct iwl_station_priv *sta_priv = NULL;
 	struct iwl_tx_queue *txq;
 	struct iwl_queue *q;
 	struct iwl_device_cmd *out_cmd;
@@ -772,6 +774,24 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
 
+	if (sta)
+		sta_priv = (void *)sta->drv_priv;
+
+	if (sta_priv && sta_id != priv->hw_params.bcast_sta_id &&
+	    sta_priv->asleep) {
+		WARN_ON(!(info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE));
+		/*
+		 * This sends an asynchronous command to the device,
+		 * but we can rely on it being processed before the
+		 * next frame is processed -- and the next frame to
+		 * this station is the one that will consume this
+		 * counter.
+		 * For now set the counter to just 1 since we do not
+		 * support uAPSD yet.
+		 */
+		iwl_sta_modify_sleep_tx_count(priv, sta_id, 1);
+	}
+
 	txq_id = skb_get_queue_mapping(skb);
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
@@ -931,6 +951,17 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	ret = iwl_txq_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	/*
+	 * At this point the frame is "transmitted" successfully
+	 * and we will get a TX status notification eventually,
+	 * regardless of the value of ret. "ret" only indicates
+	 * whether or not we should update the write pointer.
+	 */
+
+	/* avoid atomic ops if it isn't an associated client */
+	if (sta_priv && sta_priv->client)
+		atomic_inc(&sta_priv->pending_frames);
+
 	if (ret)
 		return ret;
 
@@ -1075,6 +1106,24 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	return ret ? ret : idx;
 }
 
+static void iwl_tx_status(struct iwl_priv *priv, struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_sta *sta;
+	struct iwl_station_priv *sta_priv;
+
+	sta = ieee80211_find_sta(priv->vif, hdr->addr1);
+	if (sta) {
+		sta_priv = (void *)sta->drv_priv;
+		/* avoid atomic ops if this isn't a client */
+		if (sta_priv->client &&
+		    atomic_dec_return(&sta_priv->pending_frames) == 0)
+			ieee80211_sta_block_awake(priv->hw, sta, false);
+	}
+
+	ieee80211_tx_status_irqsafe(priv->hw, skb);
+}
+
 int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
@@ -1094,7 +1143,7 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
-		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0]);
+		iwl_tx_status(priv, tx_info->skb[0]);
 		tx_info->skb[0] = NULL;
 
 		if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)
-- 
1.5.6.3

