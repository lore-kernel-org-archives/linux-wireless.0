Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35840 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab1DMFyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:54:08 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so276432iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:54:08 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15119.906565.930041@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:26:31 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 35/40] ath9k_htc: Add a debugfs file showing endpoint status
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Location: ath9k_htc/phy#/queue

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h           |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |   54 ++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index b9c7bec..b40753c 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -339,6 +339,7 @@ struct ath9k_debug {
 	struct dentry *debugfs_xmit;
 	struct dentry *debugfs_recv;
 	struct dentry *debugfs_slot;
+	struct dentry *debugfs_queue;
 	struct ath_tx_stats tx_stats;
 	struct ath_rx_stats rx_stats;
 	u32 txrate;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 119cc54..961bec2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -279,6 +279,53 @@ static const struct file_operations fops_slot = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_queue(struct file *file, char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
+	char buf[512];
+	unsigned int len = 0;
+
+	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+			"Mgmt endpoint", skb_queue_len(&priv->tx.mgmt_ep_queue));
+
+	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+			"Cab endpoint", skb_queue_len(&priv->tx.cab_ep_queue));
+
+	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+			"Data BE endpoint", skb_queue_len(&priv->tx.data_be_queue));
+
+	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+			"Data BK endpoint", skb_queue_len(&priv->tx.data_bk_queue));
+
+	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+			"Data VI endpoint", skb_queue_len(&priv->tx.data_vi_queue));
+
+	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+			"Data VO endpoint", skb_queue_len(&priv->tx.data_vo_queue));
+
+	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+			"Failed queue", skb_queue_len(&priv->tx.tx_failed));
+
+	spin_lock_bh(&priv->tx.tx_lock);
+	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+			"Queued count", priv->tx.queued_cnt);
+	spin_unlock_bh(&priv->tx.tx_lock);
+
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+}
+
+static const struct file_operations fops_queue = {
+	.read = read_file_queue,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath9k_htc_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -317,6 +364,12 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 	if (!priv->debug.debugfs_slot)
 		goto err;
 
+	priv->debug.debugfs_queue = debugfs_create_file("queue", S_IRUSR,
+							priv->debug.debugfs_phy,
+							priv, &fops_queue);
+	if (!priv->debug.debugfs_queue)
+		goto err;
+
 	return 0;
 
 err:
@@ -329,6 +382,7 @@ void ath9k_htc_exit_debug(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) common->priv;
 
+	debugfs_remove(priv->debug.debugfs_queue);
 	debugfs_remove(priv->debug.debugfs_slot);
 	debugfs_remove(priv->debug.debugfs_recv);
 	debugfs_remove(priv->debug.debugfs_xmit);
-- 
1.7.4.4

