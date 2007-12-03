Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54550 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbXLCLpg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:36 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>
Subject: [PATCH 32/34] iwlwifi: fix ucode assertion for RX queue overrun
Date: Mon,  3 Dec 2007 13:43:44 +0200
Message-Id: <11966822332622-git-send-email-tomas.winkler@intel.com> (sfid-20071203_120553_317645_D44495D8)
In-Reply-To: <1196682232185-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
 <11966822291143-git-send-email-tomas.winkler@intel.com>
 <11966822301152-git-send-email-tomas.winkler@intel.com>
 <11966822302864-git-send-email-tomas.winkler@intel.com>
 <1196682230902-git-send-email-tomas.winkler@intel.com>
 <11966822302932-git-send-email-tomas.winkler@intel.com>
 <11966822302681-git-send-email-tomas.winkler@intel.com>
 <11966822301936-git-send-email-tomas.winkler@intel.com>
 <11966822302007-git-send-email-tomas.winkler@intel.com>
 <1196682230754-git-send-email-tomas.winkler@intel.com>
 <1196682231211-git-send-email-tomas.winkler@intel.com>
 <11966822313647-git-send-email-tomas.winkler@intel.com>
 <11966822312049-git-send-email-tomas.winkler@intel.com>
 <11966822311588-git-send-email-tomas.winkler@intel.com>
 <11966822314158-git-send-email-tomas.winkler@intel.com>
 <11966822311498-git-send-email-tomas.winkler@intel.com>
 <11966822311945-git-send-email-tomas.winkler@intel.com>
 <11966822312882-git-send-email-tomas.winkler@intel.com>
 <11966822323269-git-send-email-tomas.winkler@intel.com>
 <11966822321249-git-send-email-tomas.winkler@intel.com>
 <11966822324036-git-send-email-tomas.winkler@intel.com>
 <11966822321616-git-send-email-tomas.winkler@intel.com>
 <1196682232443-git-send-email-tomas.winkler@intel.com>
 <11966822323588-git-send-email-tomas.winkler@intel.com>
 <11966822321066-git-send-email-tomas.winkler@intel.com>
 <1196682232185-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
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
index 4c2b037..8abde7e 100644
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
+static void __iwl3945_rx_replenish(void *data)
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
index e9cdf70..bcc65ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4493,9 +4493,8 @@ static int iwl4965_rx_queue_restock(struct iwl4965_priv *priv)
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
@@ -4529,6 +4528,26 @@ void iwl4965_rx_replenish(void *data)
 		rxq->free_count++;
 	}
 	spin_unlock_irqrestore(&rxq->lock, flags);
+}
+
+/*
+ * this should be called while priv->lock is locked
+*/
+static void __iwl4965_rx_replenish(void *data)
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
@@ -4708,6 +4727,8 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
 	u32 r, i;
 	int reclaim;
 	unsigned long flags;
+	u8 fill_rx = 0;
+	u32 count = 0;
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
@@ -4718,6 +4739,9 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
 	if (i == r)
 		IWL_DEBUG(IWL_DL_RX | IWL_DL_ISR, "r = %d, i = %d\n", r, i);
 
+	if (iwl4965_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
+		fill_rx = 1;
+
 	while (i != r) {
 		rxb = rxq->queue[i];
 
@@ -4788,6 +4812,16 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
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
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
