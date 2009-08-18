Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45752 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbZHRDx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:53:56 -0400
Date: Tue, 18 Aug 2009 05:53:57 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 18/29] mwl8k: fix firmware command serialisation
Message-ID: <20090818035357.GW18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current mwl8k_priv->fw_lock spinlock doesn't actually protect
against multiple commands being submitted at once, as it is not kept
held over the entire firmware command submission.  And since waiting
for command completion sleeps, we can't use a spinlock anyway.

To fix mwl8k firmware command serialisation properly, we have the
following requirements:
- Some commands require that the packet transmit path is idle when
  the command is issued.  (For simplicity, we'll just quiesce the
  transmit path for every command.)
- There are certain sequences of commands that need to be issued to
  the hardware sequentially, with no other intervening commands.

This leads to an implementation of a "firmware lock" as a mutex that
can be taken recursively, and which is taken by both the low-level
command submission function (mwl8k_post_cmd) as well as any users of
that function that require issuing of an atomic sequence of commands,
and quiesces the transmit path whenever it's taken.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  154 ++++++++++++++++++++++++------------------
 1 files changed, 89 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 905f750..5516058 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -139,13 +139,18 @@ struct mwl8k_priv {
 
 	struct pci_dev *pdev;
 	u8 name[16];
-	/* firmware access lock */
-	spinlock_t fw_lock;
 
 	/* firmware files and meta data */
 	struct mwl8k_firmware fw;
 	u32 part_num;
 
+	/* firmware access */
+	struct mutex fw_mutex;
+	struct task_struct *fw_mutex_owner;
+	int fw_mutex_depth;
+	struct completion *tx_wait;
+	struct completion *hostcmd_wait;
+
 	/* lock held over TX and TX reap */
 	spinlock_t tx_lock;
 
@@ -179,9 +184,6 @@ struct mwl8k_priv {
 	bool radio_short_preamble;
 	bool wmm_enabled;
 
-	/* Set if PHY config is in progress */
-	bool inconfig;
-
 	/* XXX need to convert this to handle multiple interfaces */
 	bool capture_beacon;
 	u8 capture_bssid[ETH_ALEN];
@@ -200,8 +202,6 @@ struct mwl8k_priv {
 
 	/* Work thread to serialize configuration requests */
 	struct workqueue_struct *config_wq;
-	struct completion *hostcmd_wait;
-	struct completion *tx_wait;
 };
 
 /* Per interface specific private data */
@@ -1113,6 +1113,9 @@ static int mwl8k_scan_tx_ring(struct mwl8k_priv *priv,
 	return ndescs;
 }
 
+/*
+ * Must be called with hw->fw_mutex held and tx queues stopped.
+ */
 static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
@@ -1122,9 +1125,6 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 
 	might_sleep();
 
-	if (priv->tx_wait != NULL)
-		printk(KERN_ERR "WARNING Previous TXWaitEmpty instance\n");
-
 	spin_lock_bh(&priv->tx_lock);
 	count = mwl8k_txq_busy(priv);
 	if (count) {
@@ -1140,7 +1140,7 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 		int newcount;
 
 		timeout = wait_for_completion_timeout(&cmd_wait,
-					msecs_to_jiffies(1000));
+					msecs_to_jiffies(5000));
 		if (timeout)
 			return 0;
 
@@ -1149,7 +1149,7 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 		newcount = mwl8k_txq_busy(priv);
 		spin_unlock_bh(&priv->tx_lock);
 
-		printk(KERN_ERR "%s(%u) TIMEDOUT:1000ms Pend:%u-->%u\n",
+		printk(KERN_ERR "%s(%u) TIMEDOUT:5000ms Pend:%u-->%u\n",
 		       __func__, __LINE__, count, newcount);
 
 		mwl8k_scan_tx_ring(priv, txinfo);
@@ -1228,10 +1228,10 @@ static void mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int force)
 
 		ieee80211_tx_status_irqsafe(hw, skb);
 
-		wake = !priv->inconfig && priv->radio_on;
+		wake = 1;
 	}
 
-	if (wake)
+	if (wake && priv->radio_on && !mutex_is_locked(&priv->fw_mutex))
 		ieee80211_wake_queue(hw, index);
 }
 
@@ -1360,6 +1360,60 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 
 
 /*
+ * Firmware access.
+ *
+ * We have the following requirements for issuing firmware commands:
+ * - Some commands require that the packet transmit path is idle when
+ *   the command is issued.  (For simplicity, we'll just quiesce the
+ *   transmit path for every command.)
+ * - There are certain sequences of commands that need to be issued to
+ *   the hardware sequentially, with no other intervening commands.
+ *
+ * This leads to an implementation of a "firmware lock" as a mutex that
+ * can be taken recursively, and which is taken by both the low-level
+ * command submission function (mwl8k_post_cmd) as well as any users of
+ * that function that require issuing of an atomic sequence of commands,
+ * and quiesces the transmit path whenever it's taken.
+ */
+static int mwl8k_fw_lock(struct ieee80211_hw *hw)
+{
+	struct mwl8k_priv *priv = hw->priv;
+
+	if (priv->fw_mutex_owner != current) {
+		int rc;
+
+		mutex_lock(&priv->fw_mutex);
+		ieee80211_stop_queues(hw);
+
+		rc = mwl8k_tx_wait_empty(hw);
+		if (rc) {
+			ieee80211_wake_queues(hw);
+			mutex_unlock(&priv->fw_mutex);
+
+			return rc;
+		}
+
+		priv->fw_mutex_owner = current;
+	}
+
+	priv->fw_mutex_depth++;
+
+	return 0;
+}
+
+static void mwl8k_fw_unlock(struct ieee80211_hw *hw)
+{
+	struct mwl8k_priv *priv = hw->priv;
+
+	if (!--priv->fw_mutex_depth) {
+		ieee80211_wake_queues(hw);
+		priv->fw_mutex_owner = NULL;
+		mutex_unlock(&priv->fw_mutex);
+	}
+}
+
+
+/*
  * Command processing.
  */
 
@@ -1384,28 +1438,28 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 	if (pci_dma_mapping_error(priv->pdev, dma_addr))
 		return -ENOMEM;
 
-	if (priv->hostcmd_wait != NULL)
-		printk(KERN_ERR "WARNING host command in progress\n");
+	rc = mwl8k_fw_lock(hw);
+	if (rc)
+		return rc;
 
-	spin_lock_irq(&priv->fw_lock);
 	priv->hostcmd_wait = &cmd_wait;
 	iowrite32(dma_addr, regs + MWL8K_HIU_GEN_PTR);
 	iowrite32(MWL8K_H2A_INT_DOORBELL,
 		regs + MWL8K_HIU_H2A_INTERRUPT_EVENTS);
 	iowrite32(MWL8K_H2A_INT_DUMMY,
 		regs + MWL8K_HIU_H2A_INTERRUPT_EVENTS);
-	spin_unlock_irq(&priv->fw_lock);
 
 	timeout = wait_for_completion_timeout(&cmd_wait,
 				msecs_to_jiffies(MWL8K_CMD_TIMEOUT_MS));
 
+	priv->hostcmd_wait = NULL;
+
+	mwl8k_fw_unlock(hw);
+
 	pci_unmap_single(priv->pdev, dma_addr, dma_size,
 					PCI_DMA_BIDIRECTIONAL);
 
 	if (!timeout) {
-		spin_lock_irq(&priv->fw_lock);
-		priv->hostcmd_wait = NULL;
-		spin_unlock_irq(&priv->fw_lock);
 		printk(KERN_ERR "%s: Command %s timeout after %u ms\n",
 		       priv->name,
 		       mwl8k_cmd_name(cmd->code, buf, sizeof(buf)),
@@ -2336,17 +2390,14 @@ static irqreturn_t mwl8k_interrupt(int irq, void *dev_id)
 	}
 
 	if (status & MWL8K_A2H_INT_OPC_DONE) {
-		if (priv->hostcmd_wait != NULL) {
+		if (priv->hostcmd_wait != NULL)
 			complete(priv->hostcmd_wait);
-			priv->hostcmd_wait = NULL;
-		}
 	}
 
 	if (status & MWL8K_A2H_INT_QUEUE_EMPTY) {
-		if (!priv->inconfig &&
-			priv->radio_on &&
-			mwl8k_txq_busy(priv))
-				mwl8k_tx_start(priv);
+		if (!mutex_is_locked(&priv->fw_mutex) &&
+		    priv->radio_on && mwl8k_txq_busy(priv))
+			mwl8k_tx_start(priv);
 	}
 
 	return IRQ_HANDLED;
@@ -2400,41 +2451,13 @@ static void mwl8k_config_thread(struct work_struct *wt)
 {
 	struct mwl8k_work_struct *worker = (struct mwl8k_work_struct *)wt;
 	struct ieee80211_hw *hw = worker->hw;
-	struct mwl8k_priv *priv = hw->priv;
 	int rc = 0;
-	int iter;
 
-	spin_lock_irq(&priv->tx_lock);
-	priv->inconfig = true;
-	spin_unlock_irq(&priv->tx_lock);
-
-	ieee80211_stop_queues(hw);
-
-	/*
-	 * Wait for host queues to drain before doing PHY
-	 * reconfiguration. This avoids interrupting any in-flight
-	 * DMA transfers to the hardware.
-	 */
-	iter = 4;
-	do {
-		rc = mwl8k_tx_wait_empty(hw);
-		if (rc)
-			printk(KERN_ERR "%s() txwait timeout=1000ms "
-				"Retry:%u/%u\n", __func__, 4 - iter + 1, 4);
-	} while (rc && --iter);
-
-	rc = iter ? 0 : -ETIMEDOUT;
-
-	if (!rc)
+	rc = mwl8k_fw_lock(hw);
+	if (!rc) {
 		rc = worker->wfunc(wt);
-
-	spin_lock_irq(&priv->tx_lock);
-	priv->inconfig = false;
-	if (priv->pending_tx_pkts && priv->radio_on)
-		mwl8k_tx_start(priv);
-	spin_unlock_irq(&priv->tx_lock);
-
-	ieee80211_wake_queues(hw);
+		mwl8k_fw_unlock(hw);
+	}
 
 	if (worker->sleep) {
 		worker->rc = rc;
@@ -3163,15 +3186,10 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	priv = hw->priv;
 	priv->hw = hw;
 	priv->pdev = pdev;
-	priv->hostcmd_wait = NULL;
-	priv->tx_wait = NULL;
-	priv->inconfig = false;
 	priv->wmm_enabled = false;
 	priv->pending_tx_pkts = 0;
 	strncpy(priv->name, MWL8K_NAME, sizeof(priv->name));
 
-	spin_lock_init(&priv->fw_lock);
-
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	pci_set_drvdata(pdev, hw);
 
@@ -3237,6 +3255,12 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		goto err_iounmap;
 	rxq_refill(hw, 0, INT_MAX);
 
+	mutex_init(&priv->fw_mutex);
+	priv->fw_mutex_owner = NULL;
+	priv->fw_mutex_depth = 0;
+	priv->tx_wait = NULL;
+	priv->hostcmd_wait = NULL;
+
 	spin_lock_init(&priv->tx_lock);
 
 	for (i = 0; i < MWL8K_TX_QUEUES; i++) {
-- 
1.5.6.4
