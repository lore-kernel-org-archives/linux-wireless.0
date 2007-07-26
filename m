Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14873 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbXGZD3E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 23:29:04 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] iwlwifi: cleanup tx queue allocation
Date: Thu, 26 Jul 2007 11:26:44 +0800
Message-Id: <11854204113166-git-send-email-yi.zhu@intel.com>
In-Reply-To: <118542040911-git-send-email-yi.zhu@intel.com>
References: <11854204053593-git-send-email-yi.zhu@intel.com>
 <11854204073964-git-send-email-yi.zhu@intel.com>
 <118542040911-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

The following patch cleans up tx queue allocation.  Change txq bd
from u8* to struct iwl_tdf_frame. This allows kill
txq->q.element_size and do strong type changing.  Most importantly
in increasing number of slots from 64 to 256 for TX queues. This is
crucial for good TX performance in HT aggregation.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945.c |   15 +++++++--------
 drivers/net/wireless/iwl-4965.c |    6 +++---
 drivers/net/wireless/iwl-base.c |   31 +++++++++++++++----------------
 drivers/net/wireless/iwl-hw.h   |    2 +-
 drivers/net/wireless/iwlwifi.h  |    3 +--
 5 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index 6683778..eb8226a 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -842,7 +842,7 @@ static int iwl3945_tx_reset(struct iwl_priv *priv)
 static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 {
 	int rc;
-	int i, num_slots;
+	int txq_id, slots_num;
 
 	iwl_hw_txq_ctx_free(priv);
 
@@ -852,13 +852,14 @@ static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 		goto error;
 
 	/* Tx queue(s) */
-	for (i = 0; i < TFD_QUEUE_MAX; i++) {
-		num_slots =
-		    (i == IWL_CMD_QUEUE_NUM) ? TFD_CMD_SLOTS :
+	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++) {
+		slots_num =
+		    (txq_id == IWL_CMD_QUEUE_NUM) ? TFD_CMD_SLOTS :
 			TFD_TX_CMD_SLOTS;
-		rc = iwl_tx_queue_init(priv, &priv->txq[i], num_slots, i);
+		rc = iwl_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
+					txq_id);
 		if (rc) {
-			IWL_ERROR("Tx %d queue init failed\n", i);
+			IWL_ERROR("Tx %d queue init failed\n", txq_id);
 			goto error;
 		}
 	}
@@ -2109,8 +2110,6 @@ int iwl_hw_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 
 	shared_data->tx_base_ptr[txq_id] = (u32) txq->q.dma_addr;
 
-	txq->q.element_size = sizeof(struct iwl_tfd_frame);
-
 	spin_lock_irqsave(&priv->lock, flags);
 	rc = iwl_grab_restricted_access(priv);
 	if (rc) {
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 3f1a339..03e3708 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -366,7 +366,7 @@ static void iwl4965_kw_free(struct iwl_priv *priv)
 static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
 {
 	int rc = 0;
-	int txq_id, num_slots;
+	int txq_id, slots_num;
 	unsigned long flags;
 
 	iwl4965_kw_free(priv);
@@ -401,9 +401,9 @@ static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
 
 	/* Tx queue(s) */
 	for (txq_id = 0; txq_id < priv->hw_setting.max_queue_number; txq_id++) {
-		num_slots = (txq_id == IWL_CMD_QUEUE_NUM) ?
+		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		rc = iwl_tx_queue_init(priv, &priv->txq[txq_id], num_slots,
+		rc = iwl_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
 				       txq_id);
 		if (rc) {
 			IWL_ERROR("Tx %d queue init failed\n", txq_id);
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 1437f66..82470f1 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -179,10 +179,10 @@ static inline u8 get_next_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
 }
 
 static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
-			  int count, int size, u32 id)
+			  int count, int slots_num, u32 id)
 {
 	q->n_bd = count;
-	q->n_window = size;
+	q->n_window = slots_num;
 	q->id = id;
 
 	q->low_mark = q->n_window / 4;
@@ -199,7 +199,7 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 }
 
 static int iwl_tx_queue_alloc(struct iwl_priv *priv,
-			      struct iwl_tx_queue *txq, int count, u32 id)
+			      struct iwl_tx_queue *txq, u32 id)
 {
 	struct pci_dev *dev = priv->pci_dev;
 
@@ -215,13 +215,12 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 		txq->txb = NULL;
 
 	txq->bd = pci_alloc_consistent(dev,
-			sizeof(struct iwl_tfd_frame) * TFD_QUEUE_SIZE_MAX,
+			sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX,
 			&txq->q.dma_addr);
 
-	txq->q.element_size = sizeof(struct iwl_tfd_frame);
 	if (!txq->bd) {
 		IWL_ERROR("pci_alloc_consistent(%zd) failed\n",
-			  sizeof(txq->bd[0]) * count);
+			  sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX);
 		goto error;
 	}
 	txq->q.id = id;
@@ -238,7 +237,7 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 }
 
 int iwl_tx_queue_init(struct iwl_priv *priv,
-		      struct iwl_tx_queue *txq, int count, u32 txq_id)
+		      struct iwl_tx_queue *txq, int slots_num, u32 txq_id)
 {
 	struct pci_dev *dev = priv->pci_dev;
 	int len;
@@ -247,14 +246,14 @@ int iwl_tx_queue_init(struct iwl_priv *priv,
 	/* alocate command space + one big command for scan since scan
 	 * command is very huge the system will not have two scan at the
 	 * same time */
-	len = sizeof(struct iwl_cmd) * count;
+	len = sizeof(struct iwl_cmd) * slots_num;
 	if (txq_id == IWL_CMD_QUEUE_NUM);
 		len +=  IWL_MAX_SCAN_SIZE;
 	txq->cmd = pci_alloc_consistent(dev, len, &txq->dma_addr_cmd);
 	if (!txq->cmd)
 		return -ENOMEM;
 
-	rc = iwl_tx_queue_alloc(priv, txq, count, txq_id);
+	rc = iwl_tx_queue_alloc(priv, txq, txq_id);
 	if (rc) {
 		pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
 
@@ -262,7 +261,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv,
 	}
 
 	txq->need_update = 0;
-	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, count, txq_id);
+	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
 	iwl_hw_tx_queue_init(priv, txq);
 
 	return 0;
@@ -551,7 +550,7 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
-	u8 *tfd;
+	struct iwl_tfd_frame *tfd;
 	u32 *control_flags;
 	struct iwl_cmd *out_cmd;
 	u32 idx = 0;
@@ -573,8 +572,8 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		IWL_ERROR("No space for Tx\n");
 		return -ENOSPC;
 	}
-	tfd = &txq->bd[q->first_empty * q->element_size];
-	memset(tfd, 0, q->element_size);
+	tfd = &txq->bd[q->first_empty];
+	memset(tfd, 0, sizeof(*tfd));
 
 	control_flags = (u32 *) tfd;
 
@@ -2754,7 +2753,7 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 		      struct sk_buff *skb, struct ieee80211_tx_control *ctl)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	u8 *tfd;
+	struct iwl_tfd_frame *tfd;
 	u32 *control_flags;
 	int txq_id = ctl->queue;
 	struct iwl_tx_queue *txq = NULL;
@@ -2845,8 +2844,8 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 	q = &txq->q;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	tfd = (u8 *) (&txq->bd[q->first_empty * q->element_size]);
-	memset(tfd, 0, q->element_size);
+	tfd = &txq->bd[q->first_empty];
+	memset(tfd, 0, sizeof(*tfd));
 	control_flags = (u32 *) tfd;
 	idx = get_next_cmd_index(q, q->first_empty, 0);
 
diff --git a/drivers/net/wireless/iwl-hw.h b/drivers/net/wireless/iwl-hw.h
index 4b3cd37..3f7e5bd 100644
--- a/drivers/net/wireless/iwl-hw.h
+++ b/drivers/net/wireless/iwl-hw.h
@@ -1231,7 +1231,7 @@ struct statistics {
 #define TFD_CTL_PAD_SET(n)         (n<<28)
 #define TFD_CTL_PAD_GET(ctl)       (ctl>>28)
 
-#define TFD_TX_CMD_SLOTS 64
+#define TFD_TX_CMD_SLOTS 256
 #define TFD_CMD_SLOTS 32
 
 #define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_cmd) - \
diff --git a/drivers/net/wireless/iwlwifi.h b/drivers/net/wireless/iwlwifi.h
index 58e3ea6..d0403d0 100644
--- a/drivers/net/wireless/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi.h
@@ -134,7 +134,6 @@ struct iwl_queue {
 	dma_addr_t dma_addr;   /* physical addr for BD's */
 	int n_window;	       /* safe queue window */
 	u32 id;
-	u32 element_size;
 	int low_mark;	       /* low watermark, resume queue if free
 				* space more than this */
 	int high_mark;         /* high watermark, stop queue if free
@@ -157,7 +156,7 @@ struct iwl_tx_info {
  */
 struct iwl_tx_queue {
 	struct iwl_queue q;
-	u8 *bd;
+	struct iwl_tfd_frame *bd;
 	struct iwl_cmd *cmd;
 	dma_addr_t dma_addr_cmd;
 	struct iwl_tx_info *txb;
-- 
1.5.2
