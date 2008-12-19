Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41646 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbYLSCpZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:25 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 26/43] iwl3945: use iwl_hw_params in iwl3945_priv
Date: Fri, 19 Dec 2008 10:37:26 +0800
Message-Id: <1229654263-21454-27-git-send-email-yi.zhu@intel.com> (sfid-20081219_034611_457987_32E18D58)
In-Reply-To: <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

The patch makes changed necessary to use iwl_hw_params to
replace iwl3945_driver_hw_info.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   41 +++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   34 ++-------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    7 ++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   36 ++++++++++++------------
 4 files changed, 49 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 0192a88..8333ee4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -805,10 +805,10 @@ u8 iwl3945_hw_find_station(struct iwl3945_priv *priv, const u8 *addr)
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
@@ -976,7 +976,7 @@ static int iwl3945_rx_init(struct iwl3945_priv *priv, struct iwl_rx_queue *rxq)
 
 	iwl3945_write_direct32(priv, FH39_RCSR_RBD_BASE(0), rxq->dma_addr);
 	iwl3945_write_direct32(priv, FH39_RCSR_RPTR_ADDR(0),
-			     priv->hw_setting.shared_phys +
+			     priv->shared_phys +
 			     offsetof(struct iwl3945_shared, rx_read_ptr[0]));
 	iwl3945_write_direct32(priv, FH39_RCSR_WPTR(0), 0);
 	iwl3945_write_direct32(priv, FH39_RCSR_CONFIG(0),
@@ -1025,7 +1025,7 @@ static int iwl3945_tx_reset(struct iwl3945_priv *priv)
 	iwl3945_write_prph(priv, ALM_SCD_TXF5MF_REG, 0x000005);
 
 	iwl3945_write_direct32(priv, FH39_TSSR_CBB_BASE,
-			     priv->hw_setting.shared_phys);
+			     priv->shared_phys);
 
 	iwl3945_write_direct32(priv, FH39_TSSR_MSG_CONFIG,
 		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON |
@@ -2315,7 +2315,7 @@ int iwl3945_hw_tx_queue_init(struct iwl3945_priv *priv, struct iwl3945_tx_queue
 	unsigned long flags;
 	int txq_id = txq->q.id;
 
-	struct iwl3945_shared *shared_data = priv->hw_setting.shared_virt;
+	struct iwl3945_shared *shared_data = priv->shared_virt;
 
 	shared_data->tx_base_ptr[txq_id] = cpu_to_le32((u32)txq->q.dma_addr);
 
@@ -2345,7 +2345,7 @@ int iwl3945_hw_tx_queue_init(struct iwl3945_priv *priv, struct iwl3945_tx_queue
 
 int iwl3945_hw_get_rx_read(struct iwl3945_priv *priv)
 {
-	struct iwl3945_shared *shared_data = priv->hw_setting.shared_virt;
+	struct iwl3945_shared *shared_data = priv->shared_virt;
 
 	return le32_to_cpu(shared_data->rx_read_ptr[0]);
 }
@@ -2430,31 +2430,30 @@ int iwl3945_init_hw_rate_table(struct iwl3945_priv *priv)
 }
 
 /* Called when initializing driver */
-int iwl3945_hw_set_hw_setting(struct iwl3945_priv *priv)
+int iwl3945_hw_set_hw_params(struct iwl3945_priv *priv)
 {
-	memset((void *)&priv->hw_setting, 0,
-	       sizeof(struct iwl3945_driver_hw_info));
+	memset((void *)&priv->hw_params, 0,
+	       sizeof(struct iwl_hw_params));
 
-	priv->hw_setting.shared_virt =
+	priv->shared_virt =
 	    pci_alloc_consistent(priv->pci_dev,
 				 sizeof(struct iwl3945_shared),
-				 &priv->hw_setting.shared_phys);
+				 &priv->shared_phys);
 
-	if (!priv->hw_setting.shared_virt) {
+	if (!priv->shared_virt) {
 		IWL_ERROR("failed to allocate pci memory\n");
 		mutex_unlock(&priv->mutex);
 		return -ENOMEM;
 	}
 
-	priv->hw_setting.rx_buf_size = IWL_RX_BUF_SIZE;
-	priv->hw_setting.max_pkt_size = 2342;
-	priv->hw_setting.tx_cmd_len = sizeof(struct iwl3945_tx_cmd);
-	priv->hw_setting.max_rxq_size = RX_QUEUE_SIZE;
-	priv->hw_setting.max_rxq_log = RX_QUEUE_SIZE_LOG;
-	priv->hw_setting.max_stations = IWL3945_STATION_COUNT;
-	priv->hw_setting.bcast_sta_id = IWL3945_BROADCAST_ID;
+	priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE;
+	priv->hw_params.max_pkt_size = 2342;
+	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
+	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
+	priv->hw_params.max_stations = IWL3945_STATION_COUNT;
+	priv->hw_params.bcast_sta_id = IWL3945_BROADCAST_ID;
 
-	priv->hw_setting.tx_ant_num = 2;
+	priv->hw_params.tx_ant_num = 2;
 	return 0;
 }
 
@@ -2467,7 +2466,7 @@ unsigned int iwl3945_hw_get_beacon_cmd(struct iwl3945_priv *priv,
 	tx_beacon_cmd = (struct iwl3945_tx_beacon_cmd *)&frame->u;
 	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
 
-	tx_beacon_cmd->tx.sta_id = priv->hw_setting.bcast_sta_id;
+	tx_beacon_cmd->tx.sta_id = priv->hw_params.bcast_sta_id;
 	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	frame_size = iwl3945_fill_beacon_frame(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index c4d56ef..cfceee1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -253,34 +253,6 @@ struct iwl3945_ibss_seq {
 	struct list_head list;
 };
 
-/**
- * struct iwl3945_driver_hw_info
- * @max_txq_num: Max # Tx queues supported
- * @tx_cmd_len: Size of Tx command (but not including frame itself)
- * @tx_ant_num: Number of TX antennas
- * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
- * @rx_buf_size:
- * @max_pkt_size:
- * @max_rxq_log: Log-base-2 of max_rxq_size
- * @max_stations:
- * @bcast_sta_id:
- * @shared_virt: Pointer to driver/uCode shared Tx Byte Counts and Rx status
- * @shared_phys: Physical Pointer to Tx Byte Counts and Rx status
- */
-struct iwl3945_driver_hw_info {
-	u16 max_txq_num;
-	u16 tx_cmd_len;
-	u16 tx_ant_num;
-	u16 max_rxq_size;
-	u32 rx_buf_size;
-	u32 max_pkt_size;
-	u16 max_rxq_log;
-	u8  max_stations;
-	u8  bcast_sta_id;
-	void *shared_virt;
-	dma_addr_t shared_phys;
-};
-
 #define IWL_RX_HDR(x) ((struct iwl3945_rx_frame_hdr *)(\
 		       x->u.rx_frame.stats.payload + \
 		       x->u.rx_frame.stats.phy_count))
@@ -353,7 +325,7 @@ extern void iwl3945_hw_rx_handler_setup(struct iwl3945_priv *priv);
 extern void iwl3945_hw_setup_deferred_work(struct iwl3945_priv *priv);
 extern void iwl3945_hw_cancel_deferred_work(struct iwl3945_priv *priv);
 extern int iwl3945_hw_rxq_stop(struct iwl3945_priv *priv);
-extern int iwl3945_hw_set_hw_setting(struct iwl3945_priv *priv);
+extern int iwl3945_hw_set_hw_params(struct iwl3945_priv *priv);
 extern int iwl3945_hw_nic_init(struct iwl3945_priv *priv);
 extern int iwl3945_hw_nic_stop_master(struct iwl3945_priv *priv);
 extern void iwl3945_hw_txq_ctx_free(struct iwl3945_priv *priv);
@@ -583,7 +555,9 @@ struct iwl3945_priv {
 	/* Last Rx'd beacon timestamp */
 	u64 timestamp;
 	u16 beacon_int;
-	struct iwl3945_driver_hw_info hw_setting;
+	void *shared_virt;
+	dma_addr_t shared_phys;
+	struct iwl_hw_params hw_params;
 	struct ieee80211_vif *vif;
 
 	/* Current association information needed to configure the
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 245f1d2..9904406 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -611,6 +611,9 @@ struct iwl_hw_params {
 	u32 ct_kill_threshold; /* value in hw-dependent units */
 	u32 calib_init_cfg;
 	const struct iwl_sensitivity_ranges *sens;
+
+	/* for 3945 */
+	u16 tx_ant_num;
 };
 
 
@@ -1010,6 +1013,10 @@ struct iwl_priv {
 	u16 beacon_int;
 	struct ieee80211_vif *vif;
 
+	/*Added	for 3945 */
+	void *shared_virt;
+	dma_addr_t shared_phys;
+	/*End*/
 	struct iwl_hw_params hw_params;
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c3ffbec..751cd3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -326,9 +326,9 @@ static u8 iwl3945_remove_station(struct iwl3945_priv *priv, const u8 *addr, int
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
@@ -385,9 +385,9 @@ u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap, u8
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
@@ -1472,13 +1472,13 @@ int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 	return 0;
 }
 
-static void iwl3945_unset_hw_setting(struct iwl3945_priv *priv)
+static void iwl3945_unset_hw_params(struct iwl3945_priv *priv)
 {
-	if (priv->hw_setting.shared_virt)
+	if (priv->shared_virt)
 		pci_free_consistent(priv->pci_dev,
 				    sizeof(struct iwl3945_shared),
-				    priv->hw_setting.shared_virt,
-				    priv->hw_setting.shared_phys);
+				    priv->shared_virt,
+				    priv->shared_phys);
 }
 
 /**
@@ -2324,7 +2324,7 @@ static int iwl3945_get_sta_id(struct iwl3945_priv *priv, struct ieee80211_hdr *h
 	/* If this frame is broadcast or management, use broadcast station id */
 	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA) ||
 	    is_multicast_ether_addr(hdr->addr1))
-		return priv->hw_setting.bcast_sta_id;
+		return priv->hw_params.bcast_sta_id;
 
 	switch (priv->iw_mode) {
 
@@ -2338,7 +2338,7 @@ static int iwl3945_get_sta_id(struct iwl3945_priv *priv, struct ieee80211_hdr *h
 		sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
-		return priv->hw_setting.bcast_sta_id;
+		return priv->hw_params.bcast_sta_id;
 
 	/* If this frame is going out to an IBSS network, find the station,
 	 * or create a new station table entry */
@@ -2359,16 +2359,16 @@ static int iwl3945_get_sta_id(struct iwl3945_priv *priv, struct ieee80211_hdr *h
 			       "Defaulting to broadcast...\n",
 			       print_mac(mac, hdr->addr1));
 		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
-		return priv->hw_setting.bcast_sta_id;
+		return priv->hw_params.bcast_sta_id;
 	}
 	/* If we are in monitor mode, use BCAST. This is required for
 	 * packet injection. */
 	case NL80211_IFTYPE_MONITOR:
-		return priv->hw_setting.bcast_sta_id;
+		return priv->hw_params.bcast_sta_id;
 
 	default:
 		IWL_WARNING("Unknown mode of operation: %d\n", priv->iw_mode);
-		return priv->hw_setting.bcast_sta_id;
+		return priv->hw_params.bcast_sta_id;
 	}
 }
 
@@ -2503,7 +2503,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 	 * of the MAC header (device reads on dword boundaries).
 	 * We'll tell device about this padding later.
 	 */
-	len = priv->hw_setting.tx_cmd_len +
+	len = sizeof(struct iwl3945_tx_cmd) +
 			sizeof(struct iwl_cmd_header) + hdr_len;
 
 	len_org = len;
@@ -6104,7 +6104,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		iwl3945_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
 			IWL_MAX_SCAN_SIZE - sizeof(*scan)));
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
-	scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
+	scan->tx_cmd.sta_id = priv->hw_params.bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	/* flags + rate selection */
@@ -7866,7 +7866,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * 5. Setup HW Constants
 	 * ********************/
 	/* Device-specific setup */
-	if (iwl3945_hw_set_hw_setting(priv)) {
+	if (iwl3945_hw_set_hw_params(priv)) {
 		IWL_ERROR("failed to set hw settings\n");
 		goto out_iounmap;
 	}
@@ -7989,7 +7989,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
  out_release_irq:
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
-	iwl3945_unset_hw_setting(priv);
+	iwl3945_unset_hw_params(priv);
 
  out_iounmap:
 	pci_iounmap(pdev, priv->hw_base);
@@ -8036,7 +8036,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 		iwl3945_rx_queue_free(priv, &priv->rxq);
 	iwl3945_hw_txq_ctx_free(priv);
 
-	iwl3945_unset_hw_setting(priv);
+	iwl3945_unset_hw_params(priv);
 	iwl3945_clear_stations_table(priv);
 
 	if (priv->mac80211_registered)
-- 
1.5.3.6

