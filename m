Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29820 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbXJYJXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:23:08 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 28/30] iwlwifi: mark more functions/variables static
Date: Thu, 25 Oct 2007 17:15:49 +0800
Message-Id: <11933037922031-git-send-email-yi.zhu@intel.com> (sfid-20071025_102315_258832_8D21F57D)
In-Reply-To: <11933037903508-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
 <11933037663659-git-send-email-yi.zhu@intel.com>
 <11933037674045-git-send-email-yi.zhu@intel.com>
 <11933037692766-git-send-email-yi.zhu@intel.com>
 <1193303770550-git-send-email-yi.zhu@intel.com>
 <11933037721573-git-send-email-yi.zhu@intel.com>
 <1193303773185-git-send-email-yi.zhu@intel.com>
 <11933037743841-git-send-email-yi.zhu@intel.com>
 <11933037762104-git-send-email-yi.zhu@intel.com>
 <11933037784073-git-send-email-yi.zhu@intel.com>
 <11933037794199-git-send-email-yi.zhu@intel.com>
 <11933037812209-git-send-email-yi.zhu@intel.com>
 <11933037822284-git-send-email-yi.zhu@intel.com>
 <11933037831480-git-send-email-yi.zhu@intel.com>
 <11933037851697-git-send-email-yi.zhu@intel.com>
 <11933037863641-git-send-email-yi.zhu@intel.com>
 <11933037881944-git-send-email-yi.zhu@intel.com>
 <11933037893348-git-send-email-yi.zhu@intel.com>
 <11933037903508-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christoph Hellwig <hch@lst.de>

mark more functions/variables static

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   17 +--------------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 ++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   29 ++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   25 +++++++++++++----------
 drivers/net/wireless/iwlwifi/iwlwifi.h      |   20 +++--------------
 6 files changed, 38 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index e26d551..2178697 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -688,21 +688,6 @@ u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate, u8 flags)
 	return sta_id;
 }
 
-void iwl_hw_card_show_info(struct iwl_priv *priv)
-{
-	IWL_DEBUG_INFO("3945ABG HW Version %u.%u.%u\n",
-		       ((priv->eeprom.board_revision >> 8) & 0x0F),
-		       ((priv->eeprom.board_revision >> 8) >> 4),
-		       (priv->eeprom.board_revision & 0x00FF));
-
-	IWL_DEBUG_INFO("3945ABG PBA Number %.*s\n",
-		       (int)sizeof(priv->eeprom.board_pba_number),
-		       priv->eeprom.board_pba_number);
-
-	IWL_DEBUG_INFO("EEPROM_ANTENNA_SWITCH_TYPE is 0x%02X\n",
-		       priv->eeprom.antenna_switch_type);
-}
-
 static int iwl3945_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 {
 	int rc;
@@ -1753,7 +1738,7 @@ void iwl3945_reg_txpower_periodic(struct iwl_priv *priv)
 			   &priv->thermal_periodic, REG_RECALIB_PERIOD * HZ);
 }
 
-void iwl3945_bg_reg_txpower_periodic(struct work_struct *work)
+static void iwl3945_bg_reg_txpower_periodic(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
 					     thermal_periodic.work);
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 2bc5e9a..adb5d67 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -34,7 +34,6 @@ extern int iwl_eeprom_acquire_semaphore(struct iwl_priv *priv);
 extern __le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv);
 extern int iwl3945_init_hw_rate_table(struct iwl_priv *priv);
 extern void iwl3945_reg_txpower_periodic(struct iwl_priv *priv);
-extern void iwl3945_bg_reg_txpower_periodic(struct work_struct *work);
 extern int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv);
 extern u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
 		 u16 tx_rate, u8 flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 541ace9..5dca474 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -43,6 +43,8 @@
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
 
+static void iwl_hw_card_show_info(struct iwl_priv *priv);
+
 #define IWL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
 	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,      \
 				    IWL_RATE_SISO_##s##M_PLCP, \
@@ -2743,7 +2745,7 @@ int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 	return 0;
 }
 
-void iwl_hw_card_show_info(struct iwl_priv *priv)
+static void iwl_hw_card_show_info(struct iwl_priv *priv)
 {
 	u16 hw_version = priv->eeprom.board_revision_4965;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 62bbde3..9eb7938 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -66,6 +66,9 @@
 u32 iwl_debug_level;
 #endif
 
+static int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
+				  struct iwl_tx_queue *txq);
+
 /******************************************************************************
  *
  * module boiler plate
@@ -73,12 +76,12 @@ u32 iwl_debug_level;
  ******************************************************************************/
 
 /* module parameters */
-int iwl_param_disable_hw_scan;
-int iwl_param_debug;
-int iwl_param_disable;      /* def: enable radio */
-int iwl_param_antenna;      /* def: 0 = both antennas (use diversity) */
+static int iwl_param_disable_hw_scan;
+static int iwl_param_debug;
+static int iwl_param_disable;      /* def: enable radio */
+static int iwl_param_antenna;      /* def: 0 = both antennas (use diversity) */
 int iwl_param_hwcrypto;     /* def: using software encryption */
-int iwl_param_qos_enable = 1;
+static int iwl_param_qos_enable = 1;
 int iwl_param_queues_num = IWL_MAX_NUM_QUEUES;
 
 /*
@@ -116,7 +119,7 @@ MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
 MODULE_LICENSE("GPL");
 
-__le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr)
+static __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr)
 {
 	u16 fc = le16_to_cpu(hdr->frame_control);
 	int hdr_len = ieee80211_get_hdrlen(fc);
@@ -693,7 +696,7 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	return ret ? ret : idx;
 }
 
-int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	int ret;
 
@@ -717,7 +720,7 @@ int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	return 0;
 }
 
-int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+static int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	int cmd_idx;
 	int ret;
@@ -2198,7 +2201,7 @@ int iwl_is_network_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
 
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
-const char *iwl_get_tx_fail_reason(u32 status)
+static const char *iwl_get_tx_fail_reason(u32 status)
 {
 	switch (status & TX_STATUS_MSK) {
 	case TX_STATUS_SUCCESS:
@@ -3344,7 +3347,7 @@ static void iwl_txstatus_to_ieee(struct iwl_priv *priv,
  * new 'R' index need to be reclaimed. As result, some free space
  * forms. If there is enough free space (> low mark), wake Tx queue.
  */
-int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
+static int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
@@ -3984,7 +3987,7 @@ static inline __le32 iwl_dma_addr2rbd_ptr(struct iwl_priv *priv,
  * also updates the memory address in the firmware to reference the new
  * target buffer.
  */
-int iwl_rx_queue_restock(struct iwl_priv *priv)
+static int iwl_rx_queue_restock(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
@@ -4074,7 +4077,7 @@ void iwl_rx_replenish(void *data)
  * This free routine walks the list of POOL entries and if SKB is set to
  * non NULL it is unmapped and freed
  */
-void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
+static void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 {
 	int i;
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
@@ -4317,7 +4320,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 	iwl_rx_queue_restock(priv);
 }
 
-int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
+static int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_tx_queue *txq)
 {
 	u32 reg = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 1f9b565..128ea76 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -66,6 +66,9 @@
 u32 iwl_debug_level;
 #endif
 
+static int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
+				  struct iwl_tx_queue *txq);
+
 /******************************************************************************
  *
  * module boiler plate
@@ -73,12 +76,12 @@ u32 iwl_debug_level;
  ******************************************************************************/
 
 /* module parameters */
-int iwl_param_disable_hw_scan;
-int iwl_param_debug;
-int iwl_param_disable;      /* def: enable radio */
-int iwl_param_antenna;      /* def: 0 = both antennas (use diversity) */
+static int iwl_param_disable_hw_scan;
+static int iwl_param_debug;
+static int iwl_param_disable;      /* def: enable radio */
+static int iwl_param_antenna;      /* def: 0 = both antennas (use diversity) */
 int iwl_param_hwcrypto;     /* def: using software encryption */
-int iwl_param_qos_enable = 1;
+static int iwl_param_qos_enable = 1;
 int iwl_param_queues_num = IWL_MAX_NUM_QUEUES;
 
 /*
@@ -691,7 +694,7 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	return ret ? ret : idx;
 }
 
-int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	int ret;
 
@@ -715,7 +718,7 @@ int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	return 0;
 }
 
-int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+static int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	int cmd_idx;
 	int ret;
@@ -2279,7 +2282,7 @@ int iwl_is_network_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
 
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
-const char *iwl_get_tx_fail_reason(u32 status)
+static const char *iwl_get_tx_fail_reason(u32 status)
 {
 	switch (status & TX_STATUS_MSK) {
 	case TX_STATUS_SUCCESS:
@@ -4312,7 +4315,7 @@ static inline __le32 iwl_dma_addr2rbd_ptr(struct iwl_priv *priv,
  * also updates the memory address in the firmware to reference the new
  * target buffer.
  */
-int iwl_rx_queue_restock(struct iwl_priv *priv)
+static int iwl_rx_queue_restock(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
@@ -4402,7 +4405,7 @@ void iwl_rx_replenish(void *data)
  * This free routine walks the list of POOL entries and if SKB is set to
  * non NULL it is unmapped and freed
  */
-void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
+static void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 {
 	int i;
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
@@ -4648,7 +4651,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 	iwl_rx_queue_restock(priv);
 }
 
-int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
+static int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_tx_queue *txq)
 {
 	u32 reg = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwlwifi.h b/drivers/net/wireless/iwlwifi/iwlwifi.h
index 9071600..96558cc 100644
--- a/drivers/net/wireless/iwlwifi/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi/iwlwifi.h
@@ -76,13 +76,7 @@ extern struct pci_device_id iwl_hw_card_ids[];
 #define IWL_NOISE_MEAS_NOT_AVAILABLE (-127)
 
 /* Module parameters accessible from iwl-*.c */
-extern int iwl_param_disable_hw_scan;
-extern int iwl_param_debug;
-extern int iwl_param_mode;
-extern int iwl_param_disable;
-extern int iwl_param_antenna;
 extern int iwl_param_hwcrypto;
-extern int iwl_param_qos_enable;
 extern int iwl_param_queues_num;
 
 enum iwl_antenna {
@@ -574,7 +568,6 @@ struct iwl_driver_hw_info {
 struct iwl_addsta_cmd;
 extern int iwl_send_add_station(struct iwl_priv *priv,
 				struct iwl_addsta_cmd *sta, u8 flags);
-extern const char *iwl_get_tx_fail_reason(u32 status);
 extern u8 iwl_add_station(struct iwl_priv *priv, const u8 *bssid,
 			  int is_ap, u8 flags);
 extern int iwl_is_network_packet(struct iwl_priv *priv,
@@ -591,8 +584,6 @@ static inline void iwl_report_frame(struct iwl_priv *priv,
 				    struct ieee80211_hdr *header,
 				    int group100) {}
 #endif
-extern int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
-					 struct iwl_tx_queue *txq);
 extern void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
 					   struct iwl_rx_mem_buffer *rxb,
 					   void *data, short len,
@@ -600,7 +591,6 @@ extern void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
 					   u16 phy_flags);
 extern int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr
 			       *header);
-extern void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 extern int iwl_rx_queue_alloc(struct iwl_priv *priv);
 extern void iwl_rx_queue_reset(struct iwl_priv *priv,
 			       struct iwl_rx_queue *rxq);
@@ -608,15 +598,10 @@ extern int iwl_calc_db_from_ratio(int sig_ratio);
 extern int iwl_calc_sig_qual(int rssi_dbm, int noise_dbm);
 extern int iwl_tx_queue_init(struct iwl_priv *priv,
 			     struct iwl_tx_queue *txq, int count, u32 id);
-extern int iwl_rx_queue_restock(struct iwl_priv *priv);
 extern void iwl_rx_replenish(void *data);
 extern void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 extern int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
 			    const void *data);
-extern int __must_check iwl_send_cmd_async(struct iwl_priv *priv,
-		struct iwl_host_cmd *cmd);
-extern int __must_check iwl_send_cmd_sync(struct iwl_priv *priv,
-		struct iwl_host_cmd *cmd);
 extern int __must_check iwl_send_cmd(struct iwl_priv *priv,
 		struct iwl_host_cmd *cmd);
 extern unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
@@ -628,7 +613,9 @@ extern int iwl_send_statistics_request(struct iwl_priv *priv);
 extern void iwl_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
 				   u32 decrypt_res,
 				   struct ieee80211_rx_status *stats);
+#if IWL == 4965
 extern __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr);
+#endif
 
 extern const u8 BROADCAST_ADDR[ETH_ALEN];
 
@@ -666,7 +653,6 @@ extern void iwl_hw_cancel_deferred_work(struct iwl_priv *priv);
 extern int iwl_hw_rxq_stop(struct iwl_priv *priv);
 extern int iwl_hw_set_hw_setting(struct iwl_priv *priv);
 extern int iwl_hw_nic_init(struct iwl_priv *priv);
-extern void iwl_hw_card_show_info(struct iwl_priv *priv);
 extern int iwl_hw_nic_stop_master(struct iwl_priv *priv);
 extern void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
 extern void iwl_hw_txq_ctx_stop(struct iwl_priv *priv);
@@ -703,5 +689,7 @@ extern int iwl4965_get_temperature(const struct iwl_priv *priv);
 extern u8 iwl_hw_find_station(struct iwl_priv *priv, const u8 *bssid);
 
 extern int iwl_hw_channel_switch(struct iwl_priv *priv, u16 channel);
+#if IWL == 4965
 extern int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
 #endif
+#endif
-- 
1.5.2
