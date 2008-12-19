Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbYLSCpX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:23 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 25/43] iwl3945: use iwl_rx_queue in iwl3945
Date: Fri, 19 Dec 2008 10:37:25 +0800
Message-Id: <1229654263-21454-26-git-send-email-yi.zhu@intel.com> (sfid-20081219_034610_436991_D85DF2DB)
In-Reply-To: <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

The patch replaces iwl3945_rx_queue with iwl_rx_queue.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   33 ++------------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   16 ++++++------
 3 files changed, 13 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index bbba509..0192a88 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -962,7 +962,7 @@ static int iwl3945_nic_set_pwr_src(struct iwl3945_priv *priv, int pwr_max)
 	return rc;
 }
 
-static int iwl3945_rx_init(struct iwl3945_priv *priv, struct iwl3945_rx_queue *rxq)
+static int iwl3945_rx_init(struct iwl3945_priv *priv, struct iwl_rx_queue *rxq)
 {
 	int rc;
 	unsigned long flags;
@@ -1083,7 +1083,7 @@ int iwl3945_hw_nic_init(struct iwl3945_priv *priv)
 	u8 rev_id;
 	int rc;
 	unsigned long flags;
-	struct iwl3945_rx_queue *rxq = &priv->rxq;
+	struct iwl_rx_queue *rxq = &priv->rxq;
 
 	iwl3945_power_init_handle(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 410a8bd..c4d56ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -213,33 +213,6 @@ struct iwl3945_host_cmd {
 #define SUP_RATE_11B_MAX_NUM_CHANNELS  4
 #define SUP_RATE_11G_MAX_NUM_CHANNELS  12
 
-/**
- * struct iwl3945_rx_queue - Rx queue
- * @processed: Internal index to last handled Rx packet
- * @read: Shared index to newest available Rx buffer
- * @write: Shared index to oldest written Rx packet
- * @free_count: Number of pre-allocated buffers in rx_free
- * @rx_free: list of free SKBs for use
- * @rx_used: List of Rx buffers with no SKB
- * @need_update: flag to indicate we need to update read/write index
- *
- * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
- */
-struct iwl3945_rx_queue {
-	__le32 *bd;
-	dma_addr_t dma_addr;
-	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
-	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
-	u32 processed;
-	u32 read;
-	u32 write;
-	u32 free_count;
-	struct list_head rx_free;
-	struct list_head rx_used;
-	int need_update;
-	spinlock_t lock;
-};
-
 #define IWL_SUPPORTED_RATES_IE_LEN         8
 
 #define SCAN_INTERVAL 100
@@ -333,7 +306,7 @@ extern int iwl3945_power_init_handle(struct iwl3945_priv *priv);
 extern int iwl3945_eeprom_init(struct iwl3945_priv *priv);
 extern int iwl3945_rx_queue_alloc(struct iwl3945_priv *priv);
 extern void iwl3945_rx_queue_reset(struct iwl3945_priv *priv,
-			       struct iwl3945_rx_queue *rxq);
+			       struct iwl_rx_queue *rxq);
 extern int iwl3945_calc_db_from_ratio(int sig_ratio);
 extern int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm);
 extern int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
@@ -347,7 +320,7 @@ extern int __must_check iwl3945_send_cmd(struct iwl3945_priv *priv,
 extern unsigned int iwl3945_fill_beacon_frame(struct iwl3945_priv *priv,
 					struct ieee80211_hdr *hdr,int left);
 extern int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv,
-					 struct iwl3945_rx_queue *q);
+					 struct iwl_rx_queue *q);
 extern int iwl3945_send_statistics_request(struct iwl3945_priv *priv);
 extern void iwl3945_set_decrypted_flag(struct iwl3945_priv *priv, struct sk_buff *skb,
 				   u32 decrypt_res,
@@ -564,7 +537,7 @@ struct iwl3945_priv {
 	int activity_timer_active;
 
 	/* Rx and Tx DMA processing queues */
-	struct iwl3945_rx_queue rxq;
+	struct iwl_rx_queue rxq;
 	struct iwl3945_tx_queue txq[IWL39_MAX_NUM_QUEUES];
 
 	unsigned long status;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 73587fe..c3ffbec 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3364,7 +3364,7 @@ static void iwl3945_tx_cmd_complete(struct iwl3945_priv *priv,
 /**
  * iwl3945_rx_queue_space - Return number of free slots available in queue.
  */
-static int iwl3945_rx_queue_space(const struct iwl3945_rx_queue *q)
+static int iwl3945_rx_queue_space(const struct iwl_rx_queue *q)
 {
 	int s = q->read - q->write;
 	if (s <= 0)
@@ -3379,7 +3379,7 @@ static int iwl3945_rx_queue_space(const struct iwl3945_rx_queue *q)
 /**
  * iwl3945_rx_queue_update_write_ptr - Update the write pointer for the RX queue
  */
-int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv, struct iwl3945_rx_queue *q)
+int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv, struct iwl_rx_queue *q)
 {
 	u32 reg = 0;
 	int rc = 0;
@@ -3444,7 +3444,7 @@ static inline __le32 iwl3945_dma_addr2rbd_ptr(struct iwl3945_priv *priv,
  */
 static int iwl3945_rx_queue_restock(struct iwl3945_priv *priv)
 {
-	struct iwl3945_rx_queue *rxq = &priv->rxq;
+	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
 	unsigned long flags;
@@ -3496,7 +3496,7 @@ static int iwl3945_rx_queue_restock(struct iwl3945_priv *priv)
  */
 static void iwl3945_rx_allocate(struct iwl3945_priv *priv)
 {
-	struct iwl3945_rx_queue *rxq = &priv->rxq;
+	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
 	unsigned long flags;
@@ -3568,7 +3568,7 @@ void iwl3945_rx_replenish(void *data)
  * This free routine walks the list of POOL entries and if SKB is set to
  * non NULL it is unmapped and freed
  */
-static void iwl3945_rx_queue_free(struct iwl3945_priv *priv, struct iwl3945_rx_queue *rxq)
+static void iwl3945_rx_queue_free(struct iwl3945_priv *priv, struct iwl_rx_queue *rxq)
 {
 	int i;
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
@@ -3587,7 +3587,7 @@ static void iwl3945_rx_queue_free(struct iwl3945_priv *priv, struct iwl3945_rx_q
 
 int iwl3945_rx_queue_alloc(struct iwl3945_priv *priv)
 {
-	struct iwl3945_rx_queue *rxq = &priv->rxq;
+	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct pci_dev *dev = priv->pci_dev;
 	int i;
 
@@ -3612,7 +3612,7 @@ int iwl3945_rx_queue_alloc(struct iwl3945_priv *priv)
 	return 0;
 }
 
-void iwl3945_rx_queue_reset(struct iwl3945_priv *priv, struct iwl3945_rx_queue *rxq)
+void iwl3945_rx_queue_reset(struct iwl3945_priv *priv, struct iwl_rx_queue *rxq)
 {
 	unsigned long flags;
 	int i;
@@ -3730,7 +3730,7 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 {
 	struct iwl_rx_mem_buffer *rxb;
 	struct iwl_rx_packet *pkt;
-	struct iwl3945_rx_queue *rxq = &priv->rxq;
+	struct iwl_rx_queue *rxq = &priv->rxq;
 	u32 r, i;
 	int reclaim;
 	unsigned long flags;
-- 
1.5.3.6

