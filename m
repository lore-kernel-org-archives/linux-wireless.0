Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41005 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbYDOXCH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 19:02:07 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/11] iwlwifi: hw_setting cleanup
Date: Tue, 15 Apr 2008 16:01:38 -0700
Message-Id: <1208300507-25628-3-git-send-email-reinette.chatre@intel.com> (sfid-20080416_000230_480907_3B1D06E8)
In-Reply-To: <1208300507-25628-2-git-send-email-reinette.chatre@intel.com>
References: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

1. This patch renames hw_setting to hw_params
2. Align names of the structure and variables
3. set_hw_params is called from libs_ops

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   49 ++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   54 +++++++++++++-------------
 6 files changed, 61 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3df70f8..a1e91db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -504,10 +504,10 @@ u8 iwl4965_hw_find_station(struct iwl_priv *priv, const u8 *addr)
 		start = IWL_STA_ID;
 
 	if (is_broadcast_ether_addr(addr))
-		return priv->hw_setting.bcast_sta_id;
+		return priv->hw_params.bcast_sta_id;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	for (i = start; i < priv->hw_setting.max_stations; i++)
+	for (i = start; i < priv->hw_params.max_stations; i++)
 		if ((priv->stations[i].used) &&
 		    (!compare_ether_addr
 		     (priv->stations[i].sta.sta.addr, addr))) {
@@ -702,7 +702,7 @@ static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
 
 	/* Alloc and init all (default 16) Tx queues,
 	 * including the command queue (#4) */
-	for (txq_id = 0; txq_id < priv->hw_setting.max_txq_num; txq_id++) {
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
 		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		rc = iwl4965_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
@@ -908,7 +908,7 @@ void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv)
 	unsigned long flags;
 
 	/* Stop each Tx DMA channel, and wait for it to be idle */
-	for (txq_id = 0; txq_id < priv->hw_setting.max_txq_num; txq_id++) {
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
 		spin_lock_irqsave(&priv->lock, flags);
 		if (iwl_grab_nic_access(priv)) {
 			spin_unlock_irqrestore(&priv->lock, flags);
@@ -1954,7 +1954,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 		iwl_write_targ_mem(priv, a, 0);
 	for (; a < priv->scd_base_addr + SCD_TRANSLATE_TBL_OFFSET; a += 4)
 		iwl_write_targ_mem(priv, a, 0);
-	for (; a < sizeof(u16) * priv->hw_setting.max_txq_num; a += 4)
+	for (; a < sizeof(u16) * priv->hw_params.max_txq_num; a += 4)
 		iwl_write_targ_mem(priv, a, 0);
 
 	/* Tel 4965 where to find Tx byte count tables */
@@ -1966,7 +1966,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	iwl_write_prph(priv, IWL49_SCD_QUEUECHAIN_SEL, 0);
 
 	/* Initialize each Tx queue (including the command queue) */
-	for (i = 0; i < priv->hw_setting.max_txq_num; i++) {
+	for (i = 0; i < priv->hw_params.max_txq_num; i++) {
 
 		/* TFD circular buffer read/write indexes */
 		iwl_write_prph(priv, IWL49_SCD_QUEUE_RDPTR(i), 0);
@@ -1989,7 +1989,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 
 	}
 	iwl_write_prph(priv, IWL49_SCD_INTERRUPT_MASK,
-				 (1 << priv->hw_setting.max_txq_num) - 1);
+				 (1 << priv->hw_params.max_txq_num) - 1);
 
 	/* Activate all Tx DMA/FIFO channels */
 	iwl_write_prph(priv, IWL49_SCD_TXFACT,
@@ -2014,11 +2014,11 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 }
 
 /**
- * iwl4965_hw_set_hw_setting
+ * iwl4965_hw_set_hw_params
  *
  * Called when initializing driver
  */
-int iwl4965_hw_set_hw_setting(struct iwl_priv *priv)
+int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 {
 
 	if ((priv->cfg->mod_params->num_of_queues > IWL_MAX_NUM_QUEUES) ||
@@ -2028,19 +2028,19 @@ int iwl4965_hw_set_hw_setting(struct iwl_priv *priv)
 		return -EINVAL;
 	}
 
-	priv->hw_setting.max_txq_num = priv->cfg->mod_params->num_of_queues;
-	priv->hw_setting.tx_cmd_len = sizeof(struct iwl4965_tx_cmd);
-	priv->hw_setting.max_rxq_size = RX_QUEUE_SIZE;
-	priv->hw_setting.max_rxq_log = RX_QUEUE_SIZE_LOG;
+	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
+	priv->hw_params.tx_cmd_len = sizeof(struct iwl4965_tx_cmd);
+	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
+	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
 	if (priv->cfg->mod_params->amsdu_size_8K)
-		priv->hw_setting.rx_buf_size = IWL_RX_BUF_SIZE_8K;
+		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_8K;
 	else
-		priv->hw_setting.rx_buf_size = IWL_RX_BUF_SIZE_4K;
-	priv->hw_setting.max_pkt_size = priv->hw_setting.rx_buf_size - 256;
-	priv->hw_setting.max_stations = IWL4965_STATION_COUNT;
-	priv->hw_setting.bcast_sta_id = IWL4965_BROADCAST_ID;
+		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_4K;
+	priv->hw_params.max_pkt_size = priv->hw_params.rx_buf_size - 256;
+	priv->hw_params.max_stations = IWL4965_STATION_COUNT;
+	priv->hw_params.bcast_sta_id = IWL4965_BROADCAST_ID;
 
-	priv->hw_setting.tx_ant_num = 2;
+	priv->hw_params.tx_ant_num = 2;
 
 	return 0;
 }
@@ -2055,7 +2055,7 @@ void iwl4965_hw_txq_ctx_free(struct iwl_priv *priv)
 	int txq_id;
 
 	/* Tx queues */
-	for (txq_id = 0; txq_id < priv->hw_setting.max_txq_num; txq_id++)
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
 		iwl4965_tx_queue_free(priv, &priv->txq[txq_id]);
 
 	/* Keep-warm buffer */
@@ -3012,7 +3012,7 @@ unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 	tx_beacon_cmd = &frame->u.beacon;
 	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
 
-	tx_beacon_cmd->tx.sta_id = priv->hw_setting.bcast_sta_id;
+	tx_beacon_cmd->tx.sta_id = priv->hw_params.bcast_sta_id;
 	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	frame_size = iwl4965_fill_beacon_frame(priv,
@@ -3620,7 +3620,7 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 		rx_start->byte_count = amsdu->byte_count;
 		rx_end = (__le32 *) (((u8 *) hdr) + len);
 	}
-	if (len > priv->hw_setting.max_pkt_size || len < 16) {
+	if (len > priv->hw_params.max_pkt_size || len < 16) {
 		IWL_WARNING("byte count out of range [16,4K] : %d\n", len);
 		return;
 	}
@@ -4515,7 +4515,7 @@ void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 	link_cmd.agg_params.agg_time_limit = cpu_to_le16(4000);
 
 	/* Update the rate scaling for control frame Tx to AP */
-	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_setting.bcast_sta_id;
+	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_params.bcast_sta_id;
 
 	iwl_send_cmd_pdu_async(priv, REPLY_TX_LINK_QUALITY_CMD,
 			       sizeof(link_cmd), &link_cmd, NULL);
@@ -4704,7 +4704,7 @@ static int iwl4965_txq_ctx_activate_free(struct iwl_priv *priv)
 {
 	int txq_id;
 
-	for (txq_id = 0; txq_id < priv->hw_setting.max_txq_num; txq_id++)
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
 		if (!test_and_set_bit(txq_id, &priv->txq_ctx_active_msk))
 			return txq_id;
 	return -1;
@@ -4908,6 +4908,7 @@ static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 
 static struct iwl_lib_ops iwl4965_lib = {
 	.init_drv = iwl4965_init_drv,
+	.set_hw_params = iwl4965_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwl4965_txq_update_byte_cnt_tbl,
 	.hw_nic_init = iwl4965_hw_nic_init,
 	.is_valid_rtc_data_addr = iwl4965_hw_valid_rtc_data_addr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index c8e73a5..c127c91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -567,7 +567,7 @@ struct iwl4965_ibss_seq {
 };
 
 /**
- * struct iwl4965_driver_hw_info
+ * struct iwl_hw_params
  * @max_txq_num: Max # Tx queues supported
  * @tx_cmd_len: Size of Tx command (but not including frame itself)
  * @tx_ant_num: Number of TX antennas
@@ -577,7 +577,7 @@ struct iwl4965_ibss_seq {
  * @max_stations:
  * @bcast_sta_id:
  */
-struct iwl4965_driver_hw_info {
+struct iwl_hw_params {
 	u16 max_txq_num;
 	u16 tx_cmd_len;
 	u16 tx_ant_num;
@@ -675,7 +675,7 @@ extern void iwl4965_hw_rx_handler_setup(struct iwl_priv *priv);
 extern void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv);
 extern void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv);
 extern int iwl4965_hw_rxq_stop(struct iwl_priv *priv);
-extern int iwl4965_hw_set_hw_setting(struct iwl_priv *priv);
+extern int iwl4965_hw_set_hw_params(struct iwl_priv *priv);
 extern int iwl4965_hw_nic_init(struct iwl_priv *priv);
 extern int iwl4965_hw_nic_stop_master(struct iwl_priv *priv);
 extern void iwl4965_hw_txq_ctx_free(struct iwl_priv *priv);
@@ -1144,7 +1144,7 @@ struct iwl_priv {
 	u16 beacon_int;
 	struct ieee80211_vif *vif;
 
-	struct iwl4965_driver_hw_info hw_setting;
+	struct iwl_hw_params hw_params;
 	/* driver/uCode shared Tx Byte Counts and Rx status */
 	void *shared_virt;
 	/* Physical Pointer to Tx Byte Counts and Rx status */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index aef1b48..7791d2b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -89,6 +89,8 @@ struct iwl_hcmd_utils_ops {
 struct iwl_lib_ops {
 	/* iwlwifi driver (priv) init */
 	int (*init_drv)(struct iwl_priv *priv);
+	/* set hw dependant perameters */
+	int (*set_hw_params)(struct iwl_priv *priv);
 
 	void (*txq_update_byte_cnt_tbl)(struct iwl_priv *priv,
 					struct iwl4965_tx_queue *txq,
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index cbea477..0f16f26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -207,7 +207,7 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 {
 	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
 	struct iwl4965_station_entry *station;
-	int max_sta = priv->hw_setting.max_stations;
+	int max_sta = priv->hw_params.max_stations;
 	char *buf;
 	int i, j, pos = 0;
 	ssize_t ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 8765358..bc2e603 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -157,7 +157,7 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 	if (keyconf->keylen == WEP_KEY_LEN_128)
 		key_flags |= STA_KEY_FLG_KEY_SIZE_MSK;
 
-	if (sta_id == priv->hw_setting.bcast_sta_id)
+	if (sta_id == priv->hw_params.bcast_sta_id)
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
@@ -198,7 +198,7 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
 	key_flags &= ~STA_KEY_FLG_INVALID;
 
-	if (sta_id == priv->hw_setting.bcast_sta_id)
+	if (sta_id == priv->hw_params.bcast_sta_id)
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 42e519b..c71910d 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -398,9 +398,9 @@ static u8 iwl4965_remove_station(struct iwl_priv *priv, const u8 *addr, int is_a
 	if (is_ap)
 		index = IWL_AP_ID;
 	else if (is_broadcast_ether_addr(addr))
-		index = priv->hw_setting.bcast_sta_id;
+		index = priv->hw_params.bcast_sta_id;
 	else
-		for (i = IWL_STA_ID; i < priv->hw_setting.max_stations; i++)
+		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++)
 			if (priv->stations[i].used &&
 			    !compare_ether_addr(priv->stations[i].sta.sta.addr,
 						addr)) {
@@ -440,9 +440,9 @@ u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
 	if (is_ap)
 		index = IWL_AP_ID;
 	else if (is_broadcast_ether_addr(addr))
-		index = priv->hw_setting.bcast_sta_id;
+		index = priv->hw_params.bcast_sta_id;
 	else
-		for (i = IWL_STA_ID; i < priv->hw_setting.max_stations; i++) {
+		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++) {
 			if (!compare_ether_addr(priv->stations[i].sta.sta.addr,
 						addr)) {
 				index = i;
@@ -483,7 +483,7 @@ u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
 
 #ifdef CONFIG_IWL4965_HT
 	/* BCAST station and IBSS stations do not work in HT mode */
-	if (index != priv->hw_setting.bcast_sta_id &&
+	if (index != priv->hw_params.bcast_sta_id &&
 	    priv->iw_mode != IEEE80211_IF_TYPE_IBSS)
 		iwl4965_set_ht_add_station(priv, index,
 				 (struct ieee80211_ht_info *) ht_data);
@@ -1210,7 +1210,7 @@ static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
  *
  ******************************************************************************/
 
-static void iwl4965_unset_hw_setting(struct iwl_priv *priv)
+static void iwl4965_unset_hw_params(struct iwl_priv *priv)
 {
 	if (priv->shared_virt)
 		pci_free_consistent(priv->pci_dev,
@@ -2114,7 +2114,7 @@ static int iwl4965_get_sta_id(struct iwl_priv *priv,
 	/* If this frame is broadcast or management, use broadcast station id */
 	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA) ||
 	    is_multicast_ether_addr(hdr->addr1))
-		return priv->hw_setting.bcast_sta_id;
+		return priv->hw_params.bcast_sta_id;
 
 	switch (priv->iw_mode) {
 
@@ -2128,7 +2128,7 @@ static int iwl4965_get_sta_id(struct iwl_priv *priv,
 		sta_id = iwl4965_hw_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
-		return priv->hw_setting.bcast_sta_id;
+		return priv->hw_params.bcast_sta_id;
 
 	/* If this frame is going out to an IBSS network, find the station,
 	 * or create a new station table entry */
@@ -2148,11 +2148,11 @@ static int iwl4965_get_sta_id(struct iwl_priv *priv,
 			       "Defaulting to broadcast...\n",
 			       print_mac(mac, hdr->addr1));
 		iwl_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
-		return priv->hw_setting.bcast_sta_id;
+		return priv->hw_params.bcast_sta_id;
 
 	default:
 		IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
-		return priv->hw_setting.bcast_sta_id;
+		return priv->hw_params.bcast_sta_id;
 	}
 }
 
@@ -2299,7 +2299,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 	 * of the MAC header (device reads on dword boundaries).
 	 * We'll tell device about this padding later.
 	 */
-	len = priv->hw_setting.tx_cmd_len +
+	len = priv->hw_params.tx_cmd_len +
 		sizeof(struct iwl_cmd_header) + hdr_len;
 
 	len_org = len;
@@ -3726,7 +3726,7 @@ static void iwl4965_rx_allocate(struct iwl_priv *priv)
 
 		/* Alloc a new receive buffer */
 		rxb->skb =
-		    alloc_skb(priv->hw_setting.rx_buf_size,
+		    alloc_skb(priv->hw_params.rx_buf_size,
 				__GFP_NOWARN | GFP_ATOMIC);
 		if (!rxb->skb) {
 			if (net_ratelimit())
@@ -3743,7 +3743,7 @@ static void iwl4965_rx_allocate(struct iwl_priv *priv)
 		/* Get physical address of RB/SKB */
 		rxb->dma_addr =
 		    pci_map_single(priv->pci_dev, rxb->skb->data,
-			   priv->hw_setting.rx_buf_size, PCI_DMA_FROMDEVICE);
+			   priv->hw_params.rx_buf_size, PCI_DMA_FROMDEVICE);
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
 	}
@@ -3786,7 +3786,7 @@ static void iwl4965_rx_queue_free(struct iwl_priv *priv, struct iwl4965_rx_queue
 		if (rxq->pool[i].skb != NULL) {
 			pci_unmap_single(priv->pci_dev,
 					 rxq->pool[i].dma_addr,
-					 priv->hw_setting.rx_buf_size,
+					 priv->hw_params.rx_buf_size,
 					 PCI_DMA_FROMDEVICE);
 			dev_kfree_skb(rxq->pool[i].skb);
 		}
@@ -3838,7 +3838,7 @@ void iwl4965_rx_queue_reset(struct iwl_priv *priv, struct iwl4965_rx_queue *rxq)
 		if (rxq->pool[i].skb != NULL) {
 			pci_unmap_single(priv->pci_dev,
 					 rxq->pool[i].dma_addr,
-					 priv->hw_setting.rx_buf_size,
+					 priv->hw_params.rx_buf_size,
 					 PCI_DMA_FROMDEVICE);
 			priv->alloc_rxb_skb--;
 			dev_kfree_skb(rxq->pool[i].skb);
@@ -3973,7 +3973,7 @@ static void iwl4965_rx_handle(struct iwl_priv *priv)
 		rxq->queue[i] = NULL;
 
 		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->dma_addr,
-					    priv->hw_setting.rx_buf_size,
+					    priv->hw_params.rx_buf_size,
 					    PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl4965_rx_packet *)rxb->skb->data;
 
@@ -4026,7 +4026,7 @@ static void iwl4965_rx_handle(struct iwl_priv *priv)
 		}
 
 		pci_unmap_single(priv->pci_dev, rxb->dma_addr,
-				 priv->hw_setting.rx_buf_size,
+				 priv->hw_params.rx_buf_size,
 				 PCI_DMA_FROMDEVICE);
 		spin_lock_irqsave(&rxq->lock, flags);
 		list_add_tail(&rxb->list, &priv->rxq.rx_used);
@@ -5871,7 +5871,7 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 	}
 
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
-	scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
+	scan->tx_cmd.sta_id = priv->hw_params.bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 
@@ -6844,7 +6844,7 @@ static void iwl4965_mac_update_tkip_key(struct ieee80211_hw *hw,
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
 	key_flags &= ~STA_KEY_FLG_INVALID;
 
-	if (sta_id == priv->hw_setting.bcast_sta_id)
+	if (sta_id == priv->hw_params.bcast_sta_id)
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
@@ -6905,7 +6905,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	 * so far, we are in legacy wep mode (group key only), otherwise we are
 	 * in 1X mode.
 	 * In legacy wep mode, we use another host command to the uCode */
-	if (key->alg == ALG_WEP && sta_id == priv->hw_setting.bcast_sta_id &&
+	if (key->alg == ALG_WEP && sta_id == priv->hw_params.bcast_sta_id &&
 		priv->iw_mode != IEEE80211_IF_TYPE_AP) {
 		if (cmd == SET_KEY)
 			is_default_wep_key = !priv->key_mapping_key;
@@ -7831,8 +7831,8 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * 5. Setup HW constants
 	 ************************/
 	/* Device-specific setup */
-	if (iwl4965_hw_set_hw_setting(priv)) {
-		IWL_ERROR("failed to set hw settings\n");
+	if (priv->cfg->ops->lib->set_hw_params(priv)) {
+		IWL_ERROR("failed to set hw parameters\n");
 		goto out_iounmap;
 	}
 
@@ -7842,7 +7842,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	err = iwl_setup(priv);
 	if (err)
-		goto out_unset_hw_settings;
+		goto out_unset_hw_params;
 	/* At this point both hw and priv are initialized. */
 
 	/**********************************
@@ -7868,7 +7868,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 	if (err) {
 		IWL_ERROR("failed to create sysfs device attributes\n");
-		goto out_unset_hw_settings;
+		goto out_unset_hw_params;
 	}
 
 	err = iwl_dbgfs_register(priv, DRV_NAME);
@@ -7892,8 +7892,8 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
  out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
- out_unset_hw_settings:
-	iwl4965_unset_hw_setting(priv);
+ out_unset_hw_params:
+	iwl4965_unset_hw_params(priv);
  out_iounmap:
 	pci_iounmap(pdev, priv->hw_base);
  out_pci_release_regions:
@@ -7955,7 +7955,7 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 		iwl4965_rx_queue_free(priv, &priv->rxq);
 	iwl4965_hw_txq_ctx_free(priv);
 
-	iwl4965_unset_hw_setting(priv);
+	iwl4965_unset_hw_params(priv);
 	iwlcore_clear_stations_table(priv);
 
 
-- 
1.5.3.4

