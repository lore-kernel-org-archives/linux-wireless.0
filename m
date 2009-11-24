Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44238 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757899AbZKXDaT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 22:30:19 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 6/8] iwmc3200wifi: 802.11n Tx aggregation support
Date: Tue, 24 Nov 2009 11:33:31 +0800
Message-Id: <1259033613-25600-7-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1259033613-25600-6-git-send-email-yi.zhu@intel.com>
References: <1259033613-25600-1-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-2-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-3-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-4-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-5-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

To support 802.11n Tx aggregation support with iwmc3200 wifi, we have to
handle the UMAC_CMD_OPCODE_STOP_RESUME_STA_TX notification from the UMAC.
Before sending an AddBA, the UMAC synchronizes with the host in order to
know what is the last Tx frame it's supposed to receive before it will be
able to start the actual aggregation session.
We thus have to keep track of the last sequence number that is scheduled
for transmission on a particular RAxTID, send an answer to the UMAC with
this sequence number. The UMAC then does the BA negociation and once it's
done with it sends a new UMAC_CMD_OPCODE_STOP_RESUME_STA_TX notification
to let us know that we can resume the Tx flow on the specified RAxTID.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Reviewed-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |   31 ++++++++++++
 drivers/net/wireless/iwmc3200wifi/commands.h |   10 ++++
 drivers/net/wireless/iwmc3200wifi/iwm.h      |   10 ++++
 drivers/net/wireless/iwmc3200wifi/main.c     |   11 ++++-
 drivers/net/wireless/iwmc3200wifi/netdev.c   |    8 +++
 drivers/net/wireless/iwmc3200wifi/rx.c       |   66 ++++++++++++++++++++++++++
 drivers/net/wireless/iwmc3200wifi/tx.c       |   57 +++++++++++++++++++---
 drivers/net/wireless/iwmc3200wifi/umac.h     |   34 ++++++++++++-
 8 files changed, 217 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 7e12438..46ca7c5 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -929,3 +929,34 @@ int iwm_target_reset(struct iwm_priv *iwm)
 
 	return iwm_hal_send_target_cmd(iwm, &target_cmd, NULL);
 }
+
+int iwm_send_umac_stop_resume_tx(struct iwm_priv *iwm,
+				 struct iwm_umac_notif_stop_resume_tx *ntf)
+{
+	struct iwm_udma_wifi_cmd udma_cmd = UDMA_UMAC_INIT;
+	struct iwm_umac_cmd umac_cmd;
+	struct iwm_umac_cmd_stop_resume_tx stp_res_cmd;
+	struct iwm_sta_info *sta_info;
+	u8 sta_id = STA_ID_N_COLOR_ID(ntf->sta_id);
+	int i;
+
+	sta_info = &iwm->sta_table[sta_id];
+	if (!sta_info->valid) {
+		IWM_ERR(iwm, "Invalid STA: %d\n", sta_id);
+		return -EINVAL;
+	}
+
+	umac_cmd.id = UMAC_CMD_OPCODE_STOP_RESUME_STA_TX;
+	umac_cmd.resp = 0;
+
+	stp_res_cmd.flags = ntf->flags;
+	stp_res_cmd.sta_id = ntf->sta_id;
+	stp_res_cmd.stop_resume_tid_msk = ntf->stop_resume_tid_msk;
+	for (i = 0; i < IWM_UMAC_TID_NR; i++)
+		stp_res_cmd.last_seq_num[i] =
+			sta_info->tid_info[i].last_seq_num;
+
+	return iwm_hal_send_umac_cmd(iwm, &udma_cmd, &umac_cmd, &stp_res_cmd,
+				 sizeof(struct iwm_umac_cmd_stop_resume_tx));
+
+}
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.h b/drivers/net/wireless/iwmc3200wifi/commands.h
index b36be2b..95cdf94 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.h
+++ b/drivers/net/wireless/iwmc3200wifi/commands.h
@@ -450,6 +450,14 @@ struct iwm_umac_cmd_stats_req {
 	__le32 flags;
 } __attribute__ ((packed));
 
+struct iwm_umac_cmd_stop_resume_tx {
+	u8 flags;
+	u8 sta_id;
+	__le16 stop_resume_tid_msk;
+	__le16 last_seq_num[IWM_UMAC_TID_NR];
+	u16 reserved;
+} __attribute__ ((packed));
+
 /* LMAC commands */
 int iwm_read_mac(struct iwm_priv *iwm, u8 *mac);
 int iwm_send_prio_table(struct iwm_priv *iwm);
@@ -478,6 +486,8 @@ int iwm_send_umac_channel_list(struct iwm_priv *iwm);
 int iwm_scan_ssids(struct iwm_priv *iwm, struct cfg80211_ssid *ssids,
 		   int ssid_num);
 int iwm_scan_one_ssid(struct iwm_priv *iwm, u8 *ssid, int ssid_len);
+int iwm_send_umac_stop_resume_tx(struct iwm_priv *iwm,
+				 struct iwm_umac_notif_stop_resume_tx *ntf);
 
 /* UDMA commands */
 int iwm_target_reset(struct iwm_priv *iwm);
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index a9bf6bc..8d091f9 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -131,11 +131,18 @@ struct iwm_notif {
 	unsigned long buf_size;
 };
 
+struct iwm_tid_info {
+	__le16 last_seq_num;
+	bool stopped;
+	struct mutex mutex;
+};
+
 struct iwm_sta_info {
 	u8 addr[ETH_ALEN];
 	bool valid;
 	bool qos;
 	u8 color;
+	struct iwm_tid_info tid_info[IWM_UMAC_TID_NR];
 };
 
 struct iwm_tx_info {
@@ -185,6 +192,8 @@ struct iwm_key {
 struct iwm_tx_queue {
 	int id;
 	struct sk_buff_head queue;
+	struct sk_buff_head stopped_queue;
+	spinlock_t lock;
 	struct workqueue_struct *wq;
 	struct work_struct worker;
 	u8 concat_buf[IWM_HAL_CONCATENATE_BUF_SIZE];
@@ -341,6 +350,7 @@ int iwm_up(struct iwm_priv *iwm);
 int iwm_down(struct iwm_priv *iwm);
 
 /* TX API */
+u16 iwm_tid_to_queue(u16 tid);
 void iwm_tx_credit_inc(struct iwm_priv *iwm, int id, int total_freed_pages);
 void iwm_tx_worker(struct work_struct *work);
 int iwm_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 92e4eaf..087f043 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -248,7 +248,7 @@ static void iwm_watchdog(unsigned long data)
 
 int iwm_priv_init(struct iwm_priv *iwm)
 {
-	int i;
+	int i, j;
 	char name[32];
 
 	iwm->status = 0;
@@ -292,6 +292,8 @@ int iwm_priv_init(struct iwm_priv *iwm)
 			return -EAGAIN;
 
 		skb_queue_head_init(&iwm->txq[i].queue);
+		skb_queue_head_init(&iwm->txq[i].stopped_queue);
+		spin_lock_init(&iwm->txq[i].lock);
 	}
 
 	for (i = 0; i < IWM_NUM_KEYS; i++)
@@ -299,6 +301,12 @@ int iwm_priv_init(struct iwm_priv *iwm)
 
 	iwm->default_key = -1;
 
+	for (i = 0; i < IWM_STA_TABLE_NUM; i++)
+		for (j = 0; j < IWM_UMAC_TID_NR; j++) {
+			mutex_init(&iwm->sta_table[i].tid_info[j].mutex);
+			iwm->sta_table[i].tid_info[j].stopped = false;
+		}
+
 	init_timer(&iwm->watchdog);
 	iwm->watchdog.function = iwm_watchdog;
 	iwm->watchdog.data = (unsigned long)iwm;
@@ -572,6 +580,7 @@ void iwm_link_off(struct iwm_priv *iwm)
 
 	for (i = 0; i < IWM_TX_QUEUES; i++) {
 		skb_queue_purge(&iwm->txq[i].queue);
+		skb_queue_purge(&iwm->txq[i].stopped_queue);
 
 		iwm->txq[i].concat_count = 0;
 		iwm->txq[i].concat_ptr = iwm->txq[i].concat_buf;
diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index 4f8dbdd..e4f0f87 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -76,6 +76,14 @@ static int iwm_stop(struct net_device *ndev)
  */
 static const u16 iwm_1d_to_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 
+u16 iwm_tid_to_queue(u16 tid)
+{
+	if (tid > IWM_UMAC_TID_NR - 2)
+		return -EINVAL;
+
+	return iwm_1d_to_queue[tid];
+}
+
 static u16 iwm_select_queue(struct net_device *dev, struct sk_buff *skb)
 {
 	skb->priority = cfg80211_classify8021d(skb);
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index bdb1d7e..72c27a3 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1087,6 +1087,71 @@ static int iwm_ntf_channel_info_list(struct iwm_priv *iwm, u8 *buf,
 	return 0;
 }
 
+static int iwm_ntf_stop_resume_tx(struct iwm_priv *iwm, u8 *buf,
+				  unsigned long buf_size,
+				  struct iwm_wifi_cmd *cmd)
+{
+	struct iwm_umac_notif_stop_resume_tx *stp_res_tx =
+		(struct iwm_umac_notif_stop_resume_tx *)buf;
+	struct iwm_sta_info *sta_info;
+	struct iwm_tid_info *tid_info;
+	u8 sta_id = STA_ID_N_COLOR_ID(stp_res_tx->sta_id);
+	u16 tid_msk = le16_to_cpu(stp_res_tx->stop_resume_tid_msk);
+	int bit, ret = 0;
+	bool stop = false;
+
+	IWM_DBG_NTF(iwm, DBG, "stop/resume notification:\n"
+		    "\tflags:       0x%x\n"
+		    "\tSTA id:      %d\n"
+		    "\tTID bitmask: 0x%x\n",
+		    stp_res_tx->flags, stp_res_tx->sta_id,
+		    stp_res_tx->stop_resume_tid_msk);
+
+	if (stp_res_tx->flags & UMAC_STOP_TX_FLAG)
+		stop = true;
+
+	sta_info = &iwm->sta_table[sta_id];
+	if (!sta_info->valid) {
+		IWM_ERR(iwm, "Stoping an invalid STA: %d %d\n",
+			sta_id, stp_res_tx->sta_id);
+		return -EINVAL;
+	}
+
+	for_each_bit(bit, (unsigned long *)&tid_msk, IWM_UMAC_TID_NR) {
+		tid_info = &sta_info->tid_info[bit];
+
+		mutex_lock(&tid_info->mutex);
+		tid_info->stopped = stop;
+		mutex_unlock(&tid_info->mutex);
+
+		if (!stop) {
+			struct iwm_tx_queue *txq;
+			u16 queue = iwm_tid_to_queue(bit);
+
+			if (queue < 0)
+				continue;
+
+			txq = &iwm->txq[queue];
+			/*
+			 * If we resume, we have to move our SKBs
+			 * back to the tx queue and queue some work.
+			 */
+			spin_lock_bh(&txq->lock);
+			skb_queue_splice_init(&txq->queue, &txq->stopped_queue);
+			spin_unlock_bh(&txq->lock);
+
+			queue_work(txq->wq, &txq->worker);
+		}
+
+	}
+
+	/* We send an ACK only for the stop case */
+	if (stop)
+		ret = iwm_send_umac_stop_resume_tx(iwm, stp_res_tx);
+
+	return ret;
+}
+
 static int iwm_ntf_wifi_if_wrapper(struct iwm_priv *iwm, u8 *buf,
 				   unsigned long buf_size,
 				   struct iwm_wifi_cmd *cmd)
@@ -1371,6 +1436,7 @@ static const iwm_handler iwm_umac_handlers[] =
 	[UMAC_NOTIFY_OPCODE_STATS]		= iwm_ntf_statistics,
 	[UMAC_CMD_OPCODE_EEPROM_PROXY]		= iwm_ntf_eeprom_proxy,
 	[UMAC_CMD_OPCODE_GET_CHAN_INFO_LIST]	= iwm_ntf_channel_info_list,
+	[UMAC_CMD_OPCODE_STOP_RESUME_STA_TX]	= iwm_ntf_stop_resume_tx,
 	[REPLY_RX_MPDU_CMD]			= iwm_ntf_rx_packet,
 	[UMAC_CMD_OPCODE_WIFI_IF_WRAPPER]	= iwm_ntf_wifi_if_wrapper,
 };
diff --git a/drivers/net/wireless/iwmc3200wifi/tx.c b/drivers/net/wireless/iwmc3200wifi/tx.c
index e3b4f79..01cc210 100644
--- a/drivers/net/wireless/iwmc3200wifi/tx.c
+++ b/drivers/net/wireless/iwmc3200wifi/tx.c
@@ -329,7 +329,7 @@ static int iwm_tx_build_packet(struct iwm_priv *iwm, struct sk_buff *skb,
 
 	memcpy(buf + sizeof(*hdr), skb->data, skb->len);
 
-	return 0;
+	return umac_cmd.seq_num;
 }
 
 static int iwm_tx_send_concat_packets(struct iwm_priv *iwm,
@@ -361,9 +361,10 @@ void iwm_tx_worker(struct work_struct *work)
 	struct iwm_priv *iwm;
 	struct iwm_tx_info *tx_info = NULL;
 	struct sk_buff *skb;
-	int cmdlen, ret;
 	struct iwm_tx_queue *txq;
-	int pool_id;
+	struct iwm_sta_info *sta_info;
+	struct iwm_tid_info *tid_info;
+	int cmdlen, ret, pool_id;
 
 	txq = container_of(work, struct iwm_tx_queue, worker);
 	iwm = container_of(txq, struct iwm_priv, txq[txq->id]);
@@ -373,8 +374,40 @@ void iwm_tx_worker(struct work_struct *work)
 	while (!test_bit(pool_id, &iwm->tx_credit.full_pools_map) &&
 	       !skb_queue_empty(&txq->queue)) {
 
+		spin_lock_bh(&txq->lock);
 		skb = skb_dequeue(&txq->queue);
+		spin_unlock_bh(&txq->lock);
+
 		tx_info = skb_to_tx_info(skb);
+		sta_info = &iwm->sta_table[tx_info->sta];
+		if (!sta_info->valid) {
+			IWM_ERR(iwm, "Trying to send a frame to unknown STA\n");
+			kfree_skb(skb);
+			continue;
+		}
+
+		tid_info = &sta_info->tid_info[tx_info->tid];
+
+		mutex_lock(&tid_info->mutex);
+
+		/*
+		 * If the RAxTID is stopped, we queue the skb to the stopped
+		 * queue.
+		 * Whenever we'll get a UMAC notification to resume the tx flow
+		 * for this RAxTID, we'll merge back the stopped queue into the
+		 * regular queue. See iwm_ntf_stop_resume_tx() from rx.c.
+		 */
+		if (tid_info->stopped) {
+			IWM_DBG_TX(iwm, DBG, "%dx%d stopped\n",
+				   tx_info->sta, tx_info->tid);
+			spin_lock_bh(&txq->lock);
+			skb_queue_tail(&txq->stopped_queue, skb);
+			spin_unlock_bh(&txq->lock);
+
+			mutex_unlock(&tid_info->mutex);
+			continue;
+		}
+
 		cmdlen = IWM_UDMA_HDR_LEN + skb->len;
 
 		IWM_DBG_TX(iwm, DBG, "Tx frame on queue %d: skb: 0x%p, sta: "
@@ -393,13 +426,20 @@ void iwm_tx_worker(struct work_struct *work)
 		if (ret) {
 			IWM_DBG_TX(iwm, DBG, "not enough tx_credit for queue "
 				   "%d, Tx worker stopped\n", txq->id);
+			spin_lock_bh(&txq->lock);
 			skb_queue_head(&txq->queue, skb);
+			spin_unlock_bh(&txq->lock);
+
+			mutex_unlock(&tid_info->mutex);
 			break;
 		}
 
 		txq->concat_ptr = txq->concat_buf + txq->concat_count;
-		iwm_tx_build_packet(iwm, skb, pool_id, txq->concat_ptr);
+		tid_info->last_seq_num =
+			iwm_tx_build_packet(iwm, skb, pool_id, txq->concat_ptr);
 		txq->concat_count += ALIGN(cmdlen, 16);
+
+		mutex_unlock(&tid_info->mutex);
 #endif
 		kfree_skb(skb);
 	}
@@ -419,14 +459,14 @@ int iwm_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 	struct iwm_priv *iwm = ndev_to_iwm(netdev);
 	struct net_device *ndev = iwm_to_ndev(iwm);
 	struct wireless_dev *wdev = iwm_to_wdev(iwm);
-	u8 *dst_addr;
 	struct iwm_tx_info *tx_info;
 	struct iwm_tx_queue *txq;
 	struct iwm_sta_info *sta_info;
-	u8 sta_id;
+	u8 *dst_addr, sta_id;
 	u16 queue;
 	int ret;
 
+
 	if (!test_bit(IWM_STATUS_ASSOCIATED, &iwm->status)) {
 		IWM_DBG_TX(iwm, DBG, "LINK: stop netif_all_queues: "
 			   "not associated\n");
@@ -440,7 +480,8 @@ int iwm_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 	txq = &iwm->txq[queue];
 
 	/* No free space for Tx, tx_worker is too slow */
-	if (skb_queue_len(&txq->queue) > IWM_TX_LIST_SIZE) {
+	if ((skb_queue_len(&txq->queue) > IWM_TX_LIST_SIZE) ||
+	    (skb_queue_len(&txq->stopped_queue) > IWM_TX_LIST_SIZE)) {
 		IWM_DBG_TX(iwm, DBG, "LINK: stop netif_subqueue[%d]\n", queue);
 		netif_stop_subqueue(netdev, queue);
 		return NETDEV_TX_BUSY;
@@ -477,7 +518,9 @@ int iwm_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 	else
 		tx_info->tid = IWM_UMAC_MGMT_TID;
 
+	spin_lock_bh(&iwm->txq[queue].lock);
 	skb_queue_tail(&iwm->txq[queue].queue, skb);
+	spin_unlock_bh(&iwm->txq[queue].lock);
 
 	queue_work(iwm->txq[queue].wq, &iwm->txq[queue].worker);
 
diff --git a/drivers/net/wireless/iwmc3200wifi/umac.h b/drivers/net/wireless/iwmc3200wifi/umac.h
index be90354..70094bf 100644
--- a/drivers/net/wireless/iwmc3200wifi/umac.h
+++ b/drivers/net/wireless/iwmc3200wifi/umac.h
@@ -83,6 +83,20 @@ struct iwm_udma_out_wifi_hdr {
 	((UMAC_HDI_ACT_TBL_IDX_RA_UMAC << UMAC_HDI_ACT_TBL_IDX_RA_POS) |\
 	(UMAC_HDI_ACT_TBL_IDX_TID_LMAC << UMAC_HDI_ACT_TBL_IDX_TID_POS))
 
+/* STA ID and color */
+#define STA_ID_SEED                        (0x0f)
+#define STA_ID_POS                         (0)
+#define STA_ID_MSK                         (STA_ID_SEED << STA_ID_POS)
+
+#define STA_COLOR_SEED                     (0x7)
+#define STA_COLOR_POS                      (4)
+#define STA_COLOR_MSK                      (STA_COLOR_SEED << STA_COLOR_POS)
+
+#define STA_ID_N_COLOR_COLOR(id_n_color) \
+	(((id_n_color) & STA_COLOR_MSK) >> STA_COLOR_POS)
+#define STA_ID_N_COLOR_ID(id_n_color) \
+	(((id_n_color) & STA_ID_MSK) >> STA_ID_POS)
+
 /* iwm_umac_notif_alive.page_grp_state Group number -- bits [3:0] */
 #define UMAC_ALIVE_PAGE_STS_GRP_NUM_POS		0
 #define UMAC_ALIVE_PAGE_STS_GRP_NUM_SEED	0xF
@@ -260,6 +274,9 @@ struct iwm_udma_out_wifi_hdr {
 #define UMAC_CMD_OPCODE_GET_CHAN_INFO_LIST	0x16
 #define UMAC_CMD_OPCODE_SET_PARAM_LIST		0x17
 #define UMAC_CMD_OPCODE_GET_PARAM_LIST		0x18
+#define UMAC_CMD_OPCODE_STOP_RESUME_STA_TX      0x19
+#define UMAC_CMD_OPCODE_TEST_BLOCK_ACK          0x1A
+
 #define UMAC_CMD_OPCODE_BASE_WRAPPER            0xFA
 #define UMAC_CMD_OPCODE_LMAC_WRAPPER            0xFB
 #define UMAC_CMD_OPCODE_HW_TEST_WRAPPER         0xFC
@@ -691,13 +708,13 @@ struct iwm_umac_notif_rx_ticket {
 #define UMAC_PHY_NUM_CHAINS     3
 
 #define IWM_UMAC_MGMT_TID	8
-#define IWM_UMAC_TID_NR		8
+#define IWM_UMAC_TID_NR		9 /* 8 TIDs + MGMT */
 
 struct iwm_umac_notif_stats {
 	struct iwm_umac_wifi_in_hdr hdr;
 	__le32 flags;
 	__le32 timestamp;
-	__le16 tid_load[IWM_UMAC_TID_NR + 2]; /* 1 non-QoS + 1 dword align */
+	__le16 tid_load[IWM_UMAC_TID_NR + 1]; /* 1 non-QoS + 1 dword align */
 	__le16 tx_rate[UMAC_NTF_RATE_SAMPLE_NR];
 	__le16 rx_rate[UMAC_NTF_RATE_SAMPLE_NR];
 	__le32 chain_energy[UMAC_PHY_NUM_CHAINS];
@@ -742,6 +759,19 @@ struct iwm_umac_notif_stats {
 	__le32 roam_ap_loadblance;
 } __attribute__ ((packed));
 
+#define UMAC_STOP_TX_FLAG    0x1
+#define UMAC_RESUME_TX_FLAG  0x2
+
+#define LAST_SEQ_NUM_INVALID     0xFFFF
+
+struct iwm_umac_notif_stop_resume_tx {
+	struct iwm_umac_wifi_in_hdr hdr;
+	u8 flags; /* UMAC_*_TX_FLAG_* */
+	u8 sta_id;
+	__le16 stop_resume_tid_msk; /* tid bitmask */
+} __attribute__ ((packed));
+
+
 /* WiFi interface wrapper header */
 struct iwm_umac_wifi_if {
 	u8 oid;
-- 
1.6.0.4

