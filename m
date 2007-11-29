Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757013AbXK2DLT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:11:19 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 34/36] iwlwifi: fix ucode assertion for RX queue overrun
Date: Thu, 29 Nov 2007 11:10:14 +0800
Message-Id: <1196305816-23023-35-git-send-email-yi.zhu@intel.com> (sfid-20071129_033539_523184_1EFA2927)
In-Reply-To: <1196305816-23023-34-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-10-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-11-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-12-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-14-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-15-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-16-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-17-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-18-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-19-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-20-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-21-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-22-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-23-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-24-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-25-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-26-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-27-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-28-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-29-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-30-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-31-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-32-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-33-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-34-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

This patch allows the driver to restock the RX queue early if the RX
queue is almost empty. This will help on avoiding any ucode assert
for the RX overrun problem.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   37 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   38 +++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 82e4e1c..5bef76d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4123,9 +4123,8 @@ static int iwl3945_rx_queue_restock(struct iwl3945_priv *priv)
  * Also restock the Rx queue via iwl3945_rx_queue_restock.
  * This is called as a scheduled work item (except for during initialization)
  */
-void iwl3945_rx_replenish(void *data)
+static void iwl3945_rx_allocate(struct iwl3945_priv *priv)
 {
-	struct iwl3945_priv *priv = data;
 	struct iwl3945_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
 	struct iwl3945_rx_mem_buffer *rxb;
@@ -4158,6 +4157,26 @@ void iwl3945_rx_replenish(void *data)
 		rxq->free_count++;
 	}
 	spin_unlock_irqrestore(&rxq->lock, flags);
+}
+
+/*
+ * this should be called while priv->lock is locked
+ */
+void __iwl3945_rx_replenish(void *data)
+{
+	struct iwl3945_priv *priv = data;
+
+	iwl3945_rx_allocate(priv);
+	iwl3945_rx_queue_restock(priv);
+}
+
+
+void iwl3945_rx_replenish(void *data)
+{
+	struct iwl3945_priv *priv = data;
+	unsigned long flags;
+
+	iwl3945_rx_allocate(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl3945_rx_queue_restock(priv);
@@ -4335,12 +4354,16 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 	u32 r, i;
 	int reclaim;
 	unsigned long flags;
+	u8 fill_rx = 0;
+	u32 count = 0;
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
 	r = iwl3945_hw_get_rx_read(priv);
 	i = rxq->read;
 
+	if (iwl3945_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
+		fill_rx = 1;
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
 		IWL_DEBUG(IWL_DL_RX | IWL_DL_ISR, "r = %d, i = %d\n", r, i);
@@ -4411,6 +4434,16 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 		list_add_tail(&rxb->list, &priv->rxq.rx_used);
 		spin_unlock_irqrestore(&rxq->lock, flags);
 		i = (i + 1) & RX_QUEUE_MASK;
+		/* If there are a lot of unused frames,
+		 * restock the Rx queue so ucode won't assert. */
+		if (fill_rx) {
+			count++;
+			if (count >= 8) {
+				priv->rxq.read = i;
+				__iwl3945_rx_replenish(priv);
+				count = 0;
+			}
+		}
 	}
 
 	/* Backtrack one entry */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f806e70..c9e5b95 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4477,9 +4477,8 @@ static int iwl4965_rx_queue_restock(struct iwl4965_priv *priv)
  * Also restock the Rx queue via iwl4965_rx_queue_restock.
  * This is called as a scheduled work item (except for during initialization)
  */
-void iwl4965_rx_replenish(void *data)
+static void iwl4965_rx_allocate(struct iwl4965_priv *priv)
 {
-	struct iwl4965_priv *priv = data;
 	struct iwl4965_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
 	struct iwl4965_rx_mem_buffer *rxb;
@@ -4512,6 +4511,26 @@ void iwl4965_rx_replenish(void *data)
 		rxq->free_count++;
 	}
 	spin_unlock_irqrestore(&rxq->lock, flags);
+}
+
+/*
+ * this should be called while priv->lock is locked
+*/
+void __iwl4965_rx_replenish(void *data)
+{
+	struct iwl4965_priv *priv = data;
+
+	iwl4965_rx_allocate(priv);
+	iwl4965_rx_queue_restock(priv);
+}
+
+
+void iwl4965_rx_replenish(void *data)
+{
+	struct iwl4965_priv *priv = data;
+	unsigned long flags;
+
+	iwl4965_rx_allocate(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl4965_rx_queue_restock(priv);
@@ -4689,6 +4708,8 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
 	u32 r, i;
 	int reclaim;
 	unsigned long flags;
+	u8 fill_rx = 0;
+	u32 count = 0;
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
@@ -4699,6 +4720,9 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
 	if (i == r)
 		IWL_DEBUG(IWL_DL_RX | IWL_DL_ISR, "r = %d, i = %d\n", r, i);
 
+	if (iwl4965_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
+		fill_rx = 1;
+
 	while (i != r) {
 		rxb = rxq->queue[i];
 
@@ -4768,6 +4792,16 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
 		list_add_tail(&rxb->list, &priv->rxq.rx_used);
 		spin_unlock_irqrestore(&rxq->lock, flags);
 		i = (i + 1) & RX_QUEUE_MASK;
+		/* If there are a lot of unused frames,
+		 * restock the Rx queue so ucode wont assert. */
+		if (fill_rx) {
+			count++;
+			if (count >= 8) {
+				priv->rxq.read = i;
+				__iwl4965_rx_replenish(priv);
+				count = 0;
+			}
+		}
 	}
 
 	/* Backtrack one entry */
-- 
1.5.3.6
