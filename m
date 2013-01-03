Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:56404 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753013Ab3ACIBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 03:01:04 -0500
Date: Thu, 3 Jan 2013 13:24:19 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 4/5] mwl8k: Handle watchdog event with highest prioriry
Message-ID: <20130103075415.GA20473@markyou.marvell.com> (sfid-20130103_090107_357112_70C8FA35)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, command path waits till all the tx host queues
are empty. Whenever watchdog event is raised, firmware
expects driver to destroy ampdu queues immediately.

This requires corresponding commands i.e.
mwl8k_cmd_get_watchdog_bitmap and mwl8k_destroy_ba to be
sent without waiting for the tx queues to be completely
empty.

Use "watchdog_event_pending" to ensure the above mentioned
two commands are sent down immediately.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 07b7546..51ae9e9 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -213,6 +213,8 @@ struct mwl8k_priv {
 	int fw_mutex_depth;
 	struct completion *hostcmd_wait;
 
+	atomic_t watchdog_event_pending;
+
 	/* lock held over TX and TX reap */
 	spinlock_t tx_lock;
 
@@ -1527,6 +1529,9 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 			return -EBUSY;
 	}
 
+	if (atomic_read(&priv->watchdog_event_pending))
+		return 0;
+
 	/*
 	 * The TX queues are stopped at this point, so this test
 	 * doesn't need to take ->tx_lock.
@@ -1548,6 +1553,14 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 		spin_unlock_bh(&priv->tx_lock);
 		timeout = wait_for_completion_timeout(&tx_wait,
 			    msecs_to_jiffies(MWL8K_TX_WAIT_TIMEOUT_MS));
+
+		if (atomic_read(&priv->watchdog_event_pending)) {
+			spin_lock_bh(&priv->tx_lock);
+			priv->tx_wait = NULL;
+			spin_unlock_bh(&priv->tx_lock);
+			return 0;
+		}
+
 		spin_lock_bh(&priv->tx_lock);
 
 		if (timeout) {
@@ -3645,6 +3658,7 @@ static void mwl8k_watchdog_ba_events(struct work_struct *work)
 
 	spin_unlock(&priv->stream_lock);
 done:
+	atomic_dec(&priv->watchdog_event_pending);
 	status = ioread32(priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
 	iowrite32((status | MWL8K_A2H_INT_BA_WATCHDOG),
 		  priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
@@ -4346,6 +4360,10 @@ static irqreturn_t mwl8k_interrupt(int irq, void *dev_id)
 	}
 
 	if (status & MWL8K_A2H_INT_BA_WATCHDOG) {
+		iowrite32(~MWL8K_A2H_INT_BA_WATCHDOG,
+			  priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
+
+		atomic_inc(&priv->watchdog_event_pending);
 		status &= ~MWL8K_A2H_INT_BA_WATCHDOG;
 		ieee80211_queue_work(hw, &priv->watchdog_ba_handle);
 	}
@@ -5518,6 +5536,7 @@ static int mwl8k_probe_hw(struct ieee80211_hw *hw)
 	priv->sniffer_enabled = false;
 	priv->wmm_enabled = false;
 	priv->pending_tx_pkts = 0;
+	atomic_set(&priv->watchdog_event_pending, 0);
 
 	rc = mwl8k_rxq_init(hw, 0);
 	if (rc)
-- 
1.8.0.3

