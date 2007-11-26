Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:41608 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbXKZOVw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 09:21:52 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 15/15] iwlwifi: 802.11n add support to 8K A-MSDU Rx frames
Date: Mon, 26 Nov 2007 16:14:42 +0200
Message-Id: <11960864922274-git-send-email-ron.rindjunsky@intel.com> (sfid-20071126_143529_017179_AE793A0C)
In-Reply-To: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch give the iwlwifi the ability to support A-MSDU up to 8K

Please notice - in order to work in 8K A-MSDU ucode support is needed,
version 4.44.1.19 (soon to be published). 4K A-MSDU works in current ucode
version as well.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |   14 +++++++++-----
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   20 +++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    5 +++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   21 ++++++++++++++-------
 7 files changed, 48 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 402e347..a5e783c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -691,7 +691,6 @@ struct iwl3945_eeprom {
 #define RX_LOW_WATERMARK 8
 
 
-#define IWL_RX_BUF_SIZE 3000
 /* card static random access memory (SRAM) for processor data and instructs */
 #define ALM_RTC_INST_UPPER_BOUND		(0x014000)
 #define ALM_RTC_DATA_UPPER_BOUND		(0x808000)
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 953a9be..3de88b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2219,7 +2219,8 @@ int iwl3945_hw_set_hw_setting(struct iwl3945_priv *priv)
 	}
 
 	priv->hw_setting.ac_queue_count = AC_NUM;
-	priv->hw_setting.rx_buffer_size = IWL_RX_BUF_SIZE;
+	priv->hw_setting.rx_buf_size = IWL_RX_BUF_SIZE;
+	priv->hw_setting.max_pkt_size = 2342;
 	priv->hw_setting.tx_cmd_len = sizeof(struct iwl3945_tx_cmd);
 	priv->hw_setting.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_setting.max_rxq_log = RX_QUEUE_SIZE_LOG;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index e5b345d..49fc6a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -72,6 +72,7 @@ enum iwl3945_antenna {
  * else RTS for data/management frames where MPDU is larger
  *   than RTS value.
  */
+#define IWL_RX_BUF_SIZE           3000U
 #define DEFAULT_RTS_THRESHOLD     2347U
 #define MIN_RTS_THRESHOLD         0U
 #define MAX_RTS_THRESHOLD         2347U
@@ -447,7 +448,6 @@ union iwl3945_ht_rate_supp {
 
 #ifdef CONFIG_IWL3945_HT
 #define CFG_HT_RX_AMPDU_FACTOR_DEF  (0x3)
-#define HT_IE_MAX_AMSDU_SIZE_4K     (0)
 #define CFG_HT_MPDU_DENSITY_2USEC   (0x5)
 #define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_2USEC
 
@@ -552,7 +552,8 @@ struct iwl3945_driver_hw_info {
 	u16 ac_queue_count;
 	u16 tx_cmd_len;
 	u16 max_rxq_size;
-	u32 rx_buffer_size;
+	u32 rx_buf_size;
+	u32 max_pkt_size;
 	u16 max_rxq_log;
 	u8  max_stations;
 	u8  bcast_sta_id;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 1800490..0d3f632 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -740,8 +740,8 @@ struct iwl4965_eeprom {
 #define RX_FREE_BUFFERS 64
 #define RX_LOW_WATERMARK 8
 
-
-#define IWL_RX_BUF_SIZE (4 * 1024)
+#define IWL_RX_BUF_SIZE_4K (4 * 1024)
+#define IWL_RX_BUF_SIZE_8K (8 * 1024)
 #define IWL_MAX_BSM_SIZE BSM_SRAM_SIZE
 #define KDR_RTC_INST_UPPER_BOUND		(0x018000)
 #define KDR_RTC_DATA_UPPER_BOUND		(0x80A000)
@@ -1055,15 +1055,19 @@ union iwl4965_tx_power_dual_stream {
 #define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_MASK     (0x00001000) /* bit 12 */
 #define FH_RCSR_CHNL0_RX_CONFIG_RB_TIMEOUT_MASK   (0x00000FF0) /* bit 4-11 */
 
-#define FH_RCSR_RX_CONFIG_RBDCB_SIZE_BITSHIFT       (20)
-#define FH_RCSR_RX_CONFIG_RB_SIZE_BITSHIFT			(16)
+#define FH_RCSR_RX_CONFIG_RBDCB_SIZE_BITSHIFT	(20)
+#define FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_BITSHIFT	(4)
+#define RX_RB_TIMEOUT	(0x10)
 
 /* RCSR: rx_config register values */
 #define FH_RCSR_RX_CONFIG_CHNL_EN_PAUSE_VAL         (0x00000000)
 #define FH_RCSR_RX_CONFIG_CHNL_EN_PAUSE_EOF_VAL     (0x40000000)
 #define FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL        (0x80000000)
 
-#define IWL_FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K    (0x00000000)
+#define FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K    (0x00000000)
+#define FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K    (0x00010000)
+#define FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_12K   (0x00020000)
+#define FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_16K   (0x00030000)
 
 /* RCSR channel 0 config register values */
 #define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_NO_INT_VAL       (0x00000000)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8eea5c1..f2b5076 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -226,6 +226,7 @@ static int iwl4965_rx_init(struct iwl4965_priv *priv, struct iwl4965_rx_queue *r
 {
 	int rc;
 	unsigned long flags;
+	unsigned int rb_size;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	rc = iwl4965_grab_nic_access(priv);
@@ -234,6 +235,11 @@ static int iwl4965_rx_init(struct iwl4965_priv *priv, struct iwl4965_rx_queue *r
 		return rc;
 	}
 
+	if (iwl4965_param_amsdu_size_8K)
+		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
+	else
+		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
+
 	/* stop HW */
 	iwl4965_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 
@@ -248,7 +254,7 @@ static int iwl4965_rx_init(struct iwl4965_priv *priv, struct iwl4965_rx_queue *r
 	iwl4965_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
 			     FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
 			     FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
-			     IWL_FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K |
+			     rb_size |
 			     /*0x10 << 4 | */
 			     (RX_QUEUE_SIZE_LOG <<
 			      FH_RCSR_RX_CONFIG_RBDCB_SIZE_BITSHIFT));
@@ -1721,7 +1727,11 @@ int iwl4965_hw_set_hw_setting(struct iwl4965_priv *priv)
 	priv->hw_setting.tx_cmd_len = sizeof(struct iwl4965_tx_cmd);
 	priv->hw_setting.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_setting.max_rxq_log = RX_QUEUE_SIZE_LOG;
-
+	if (iwl4965_param_amsdu_size_8K)
+		priv->hw_setting.rx_buf_size = IWL_RX_BUF_SIZE_8K;
+	else
+		priv->hw_setting.rx_buf_size = IWL_RX_BUF_SIZE_4K;
+	priv->hw_setting.max_pkt_size = priv->hw_setting.rx_buf_size - 256;
 	priv->hw_setting.max_stations = IWL4965_STATION_COUNT;
 	priv->hw_setting.bcast_sta_id = IWL4965_BROADCAST_ID;
 	return 0;
@@ -3519,7 +3529,7 @@ static void iwl4965_handle_data_packet(struct iwl4965_priv *priv, int is_data,
 		rx_start->byte_count = amsdu->byte_count;
 		rx_end = (__le32 *) (((u8 *) hdr) + len);
 	}
-	if (len > IWL_RX_BUF_SIZE || len < 16) {
+	if (len > priv->hw_setting.max_pkt_size || len < 16) {
 		IWL_WARNING("byte count out of range [16,4K]"
 			       " : %d\n", len);
 		return;
@@ -3685,6 +3695,10 @@ void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info, int mode)
 	ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_20;
 	ht_info->cap |= (u16)(IEEE80211_HT_CAP_MIMO_PS &
 			     (IWL_MIMO_PS_NONE << 2));
+	if (iwl4965_param_amsdu_size_8K) {
+		printk(KERN_DEBUG "iwl4965 in A-MSDU 8K support mode\n");
+		ht_info->cap |= (u16)IEEE80211_HT_CAP_MAX_AMSDU;
+	}
 
 	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
 	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index c098bb8..36c8d38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -56,6 +56,7 @@ extern struct pci_device_id iwl4965_hw_card_ids[];
 /* Module parameters accessible from iwl-*.c */
 extern int iwl4965_param_hwcrypto;
 extern int iwl4965_param_queues_num;
+extern int iwl4965_param_amsdu_size_8K;
 
 enum iwl4965_antenna {
 	IWL_ANTENNA_DIVERSITY,
@@ -473,7 +474,6 @@ union iwl4965_ht_rate_supp {
 
 #ifdef CONFIG_IWL4965_HT
 #define CFG_HT_RX_AMPDU_FACTOR_DEF  (0x3)
-#define HT_IE_MAX_AMSDU_SIZE_4K     (0)
 #define CFG_HT_MPDU_DENSITY_2USEC   (0x5)
 #define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_2USEC
 
@@ -572,7 +572,8 @@ struct iwl4965_driver_hw_info {
 	u16 ac_queue_count;
 	u16 tx_cmd_len;
 	u16 max_rxq_size;
-	u32 rx_buffer_size;
+	u32 rx_buf_size;
+	u32 max_pkt_size;
 	u16 max_rxq_log;
 	u8  max_stations;
 	u8  bcast_sta_id;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f90fc73..d67ec75 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -80,6 +80,7 @@ static int iwl4965_param_antenna;      /* def: 0 = both antennas (use diversity)
 int iwl4965_param_hwcrypto;     /* def: using software encryption */
 static int iwl4965_param_qos_enable = 1;
 int iwl4965_param_queues_num = IWL_MAX_NUM_QUEUES;
+int iwl4965_param_amsdu_size_8K; /* def: enable 8K amsdu size */
 
 /*
  * module name, copyright, version, etc.
@@ -3164,7 +3165,7 @@ void iwl4965_handle_data_packet_monitor(struct iwl4965_priv *priv,
 	__le16 phy_flags_hw = cpu_to_le16(phy_flags);
 
 	/* We received data from the HW, so stop the watchdog */
-	if (len > IWL_RX_BUF_SIZE - sizeof(*iwl4965_rt)) {
+	if (len > priv->hw_setting.rx_buf_size - sizeof(*iwl4965_rt)) {
 		IWL_DEBUG_DROP("Dropping too large packet in monitor\n");
 		return;
 	}
@@ -4393,7 +4394,8 @@ void iwl4965_rx_replenish(void *data)
 		element = rxq->rx_used.next;
 		rxb = list_entry(element, struct iwl4965_rx_mem_buffer, list);
 		rxb->skb =
-		    alloc_skb(IWL_RX_BUF_SIZE, __GFP_NOWARN | GFP_ATOMIC);
+		    alloc_skb(priv->hw_setting.rx_buf_size,
+				__GFP_NOWARN | GFP_ATOMIC);
 		if (!rxb->skb) {
 			if (net_ratelimit())
 				printk(KERN_CRIT DRV_NAME
@@ -4407,7 +4409,7 @@ void iwl4965_rx_replenish(void *data)
 		list_del(element);
 		rxb->dma_addr =
 		    pci_map_single(priv->pci_dev, rxb->skb->data,
-				   IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+			   priv->hw_setting.rx_buf_size, PCI_DMA_FROMDEVICE);
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
 	}
@@ -4430,7 +4432,8 @@ static void iwl4965_rx_queue_free(struct iwl4965_priv *priv, struct iwl4965_rx_q
 		if (rxq->pool[i].skb != NULL) {
 			pci_unmap_single(priv->pci_dev,
 					 rxq->pool[i].dma_addr,
-					 IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+					 priv->hw_setting.rx_buf_size,
+					 PCI_DMA_FROMDEVICE);
 			dev_kfree_skb(rxq->pool[i].skb);
 		}
 	}
@@ -4477,7 +4480,8 @@ void iwl4965_rx_queue_reset(struct iwl4965_priv *priv, struct iwl4965_rx_queue *
 		if (rxq->pool[i].skb != NULL) {
 			pci_unmap_single(priv->pci_dev,
 					 rxq->pool[i].dma_addr,
-					 IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+					 priv->hw_setting.rx_buf_size,
+					 PCI_DMA_FROMDEVICE);
 			priv->alloc_rxb_skb--;
 			dev_kfree_skb(rxq->pool[i].skb);
 			rxq->pool[i].skb = NULL;
@@ -4604,7 +4608,7 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
 		rxq->queue[i] = NULL;
 
 		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->dma_addr,
-					    IWL_RX_BUF_SIZE,
+					    priv->hw_setting.rx_buf_size,
 					    PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl4965_rx_packet *)rxb->skb->data;
 
@@ -4657,7 +4661,8 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
 		}
 
 		pci_unmap_single(priv->pci_dev, rxb->dma_addr,
-				 IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+				 priv->hw_setting.rx_buf_size,
+				 PCI_DMA_FROMDEVICE);
 		spin_lock_irqsave(&rxq->lock, flags);
 		list_add_tail(&rxb->list, &priv->rxq.rx_used);
 		spin_unlock_irqrestore(&rxq->lock, flags);
@@ -9303,6 +9308,8 @@ MODULE_PARM_DESC(queues_num, "number of hw queues.");
 /* QoS */
 module_param_named(qos_enable, iwl4965_param_qos_enable, int, 0444);
 MODULE_PARM_DESC(qos_enable, "enable all QoS functionality");
+module_param_named(amsdu_size_8K, iwl4965_param_amsdu_size_8K, int, 0444);
+MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
 
 module_exit(iwl4965_exit);
 module_init(iwl4965_init);
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
