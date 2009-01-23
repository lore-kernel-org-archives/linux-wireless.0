Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34247 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851AbZAWVmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:49 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/15] iwlwifi: make iwl_tx_queue->tfds void*
Date: Fri, 23 Jan 2009 13:45:13 -0800
Message-Id: <1232747123-7261-6-git-send-email-reinette.chatre@intel.com> (sfid-20090123_224257_667467_BFC5F2E3)
In-Reply-To: <1232747123-7261-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-4-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

Instead of having both tfds and tfds39, we can just have a void *tfds.
It makes the tx_queue structure nicer, and the code cleaner. It also helps
with further TX queues management code merging.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 +--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   12 ++++++------
 5 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 602a3a9..22770f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -730,10 +730,11 @@ int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 {
 	int count;
 	struct iwl_queue *q;
-	struct iwl3945_tfd *tfd;
+	struct iwl3945_tfd *tfd, *tfd_tmp;
 
 	q = &txq->q;
-	tfd = &txq->tfds39[q->write_ptr];
+	tfd_tmp = (struct iwl3945_tfd *)txq->tfds;
+	tfd = &tfd_tmp[q->write_ptr];
 
 	if (reset)
 		memset(tfd, 0, sizeof(*tfd));
@@ -764,7 +765,7 @@ int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
  */
 void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
-	struct iwl3945_tfd *tfd_tmp = (struct iwl3945_tfd *)&txq->tfds39[0];
+	struct iwl3945_tfd *tfd_tmp = (struct iwl3945_tfd *)txq->tfds;
 	struct iwl3945_tfd *tfd = &tfd_tmp[txq->q.read_ptr];
 	struct pci_dev *dev = priv->pci_dev;
 	int i;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 61788a5..4ce3d6a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -520,7 +520,7 @@ static inline u8 iwl_tfd_get_num_tbs(struct iwl_tfd *tfd)
  */
 void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
-	struct iwl_tfd *tfd_tmp = (struct iwl_tfd *)&txq->tfds[0];
+	struct iwl_tfd *tfd_tmp = (struct iwl_tfd *)txq->tfds;
 	struct iwl_tfd *tfd;
 	struct pci_dev *dev = priv->pci_dev;
 	int index = txq->q.read_ptr;
@@ -563,11 +563,12 @@ int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 				 u8 reset, u8 pad)
 {
 	struct iwl_queue *q;
-	struct iwl_tfd *tfd;
+	struct iwl_tfd *tfd, *tfd_tmp;
 	u32 num_tbs;
 
 	q = &txq->q;
-	tfd = &txq->tfds[q->write_ptr];
+	tfd_tmp = (struct iwl_tfd *)txq->tfds;
+	tfd = &tfd_tmp[q->write_ptr];
 
 	if (reset)
 		memset(tfd, 0, sizeof(*tfd));
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 79f2d45..78ce4f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -149,8 +149,7 @@ struct iwl_tx_info {
 
 struct iwl_tx_queue {
 	struct iwl_queue q;
-	struct iwl_tfd *tfds;
-	struct iwl3945_tfd *tfds39;
+	void *tfds;
 	struct iwl_cmd *cmd[TFD_TX_CMD_SLOTS];
 	struct iwl_tx_info *txb;
 	u8 need_update;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 1a2cfbe..83e9f32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -295,12 +295,12 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
 	txq->tfds = pci_alloc_consistent(dev,
-			sizeof(txq->tfds[0]) * TFD_QUEUE_SIZE_MAX,
+			sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX,
 			&txq->q.dma_addr);
 
 	if (!txq->tfds) {
 		IWL_ERR(priv, "pci_alloc_consistent(%zd) failed\n",
-			  sizeof(txq->tfds[0]) * TFD_QUEUE_SIZE_MAX);
+			  sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX);
 		goto error;
 	}
 	txq->q.id = id;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c7bb9c1..bc10e2a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -172,13 +172,13 @@ static int iwl3945_tx_queue_alloc(struct iwl_priv *priv,
 
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
-	txq->tfds39 = pci_alloc_consistent(dev,
-			sizeof(txq->tfds39[0]) * TFD_QUEUE_SIZE_MAX,
-			&txq->q.dma_addr);
+	txq->tfds = pci_alloc_consistent(dev,
+				sizeof(struct iwl3945_tfd) * TFD_QUEUE_SIZE_MAX,
+				&txq->q.dma_addr);
 
-	if (!txq->tfds39) {
+	if (!txq->tfds) {
 		IWL_ERR(priv, "pci_alloc_consistent(%zd) failed\n",
-			  sizeof(txq->tfds39[0]) * TFD_QUEUE_SIZE_MAX);
+			  sizeof(struct iwl3945_tfd) * TFD_QUEUE_SIZE_MAX);
 		goto error;
 	}
 	txq->q.id = id;
@@ -287,7 +287,7 @@ void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
 		pci_free_consistent(dev, sizeof(struct iwl3945_tfd) *
-				    txq->q.n_bd, txq->tfds39, txq->q.dma_addr);
+				    txq->q.n_bd, txq->tfds, txq->q.dma_addr);
 
 	/* De-alloc array of per-TFD driver data */
 	kfree(txq->txb);
-- 
1.5.4.3

