Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62387 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1DMFyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:54:01 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so275754iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:54:01 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15114.129438.59097@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:26:26 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 34/40] ath9k_htc: Add a debugfs file to dump TX slot
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
 information

Location: ath9k_htc/phy#/slot

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h           |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |   42 ++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 6c103ed..b9c7bec 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -338,6 +338,7 @@ struct ath9k_debug {
 	struct dentry *debugfs_tgt_stats;
 	struct dentry *debugfs_xmit;
 	struct dentry *debugfs_recv;
+	struct dentry *debugfs_slot;
 	struct ath_tx_stats tx_stats;
 	struct ath_rx_stats rx_stats;
 	u32 txrate;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 91a486c..119cc54 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -244,6 +244,41 @@ static const struct file_operations fops_recv = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_slot(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
+	char buf[512];
+	unsigned int len = 0;
+
+	spin_lock_bh(&priv->tx.tx_lock);
+
+	len += snprintf(buf + len, sizeof(buf) - len, "TX slot bitmap : ");
+
+	len += bitmap_scnprintf(buf + len, sizeof(buf) - len,
+			       priv->tx.tx_slot, MAX_TX_BUF_NUM);
+
+	len += snprintf(buf + len, sizeof(buf) - len, "\n");
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"Used slots     : %d\n",
+			bitmap_weight(priv->tx.tx_slot, MAX_TX_BUF_NUM));
+
+	spin_unlock_bh(&priv->tx.tx_lock);
+
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_slot = {
+	.read = read_file_slot,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath9k_htc_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -276,6 +311,12 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 	if (!priv->debug.debugfs_recv)
 		goto err;
 
+	priv->debug.debugfs_slot = debugfs_create_file("slot", S_IRUSR,
+						       priv->debug.debugfs_phy,
+						       priv, &fops_slot);
+	if (!priv->debug.debugfs_slot)
+		goto err;
+
 	return 0;
 
 err:
@@ -288,6 +329,7 @@ void ath9k_htc_exit_debug(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) common->priv;
 
+	debugfs_remove(priv->debug.debugfs_slot);
 	debugfs_remove(priv->debug.debugfs_recv);
 	debugfs_remove(priv->debug.debugfs_xmit);
 	debugfs_remove(priv->debug.debugfs_tgt_stats);
-- 
1.7.4.4

