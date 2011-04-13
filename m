Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62387 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab1DMFyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:54:36 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so275754iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:54:35 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15146.867297.651758@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:26:58 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 39/40] ath9k_htc: Add detailed firmware statistics
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

New debugfs files:

<debugfs_root>/ath9k_htc/<phy#>/tgt_int_stats
<debugfs_root>/ath9k_htc/<phy#>/tgt_tx_stats
<debugfs_root>/ath9k_htc/<phy#>/tgt_rx_stats

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h           |   36 ++++-
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |  185 ++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/wmi.c           |   19 +--
 drivers/net/wireless/ath/ath9k/wmi.h           |    7 +-
 4 files changed, 195 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index b413b46..cc5d0a4 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -175,12 +175,31 @@ struct ath9k_htc_target_rate {
 	struct ath9k_htc_rate rates;
 };
 
-struct ath9k_htc_target_stats {
-	__be32 tx_shortretry;
-	__be32 tx_longretry;
-	__be32 tx_xretries;
-	__be32 ht_txunaggr_xretry;
-	__be32 ht_tx_xretries;
+struct ath9k_htc_target_int_stats {
+	__be32 rx;
+	__be32 rxorn;
+	__be32 rxeol;
+	__be32 txurn;
+	__be32 txto;
+	__be32 cst;
+} __packed;
+
+struct ath9k_htc_target_tx_stats {
+	__be32 xretries;
+	__be32 fifoerr;
+	__be32 filtered;
+	__be32 timer_exp;
+	__be32 shortretries;
+	__be32 longretries;
+	__be32 qnull;
+	__be32 encap_fail;
+	__be32 nobuf;
+} __packed;
+
+struct ath9k_htc_target_rx_stats {
+	__be32 nobuf;
+	__be32 host_send;
+	__be32 host_done;
 } __packed;
 
 #define ATH9K_HTC_MAX_VIF 2
@@ -340,14 +359,15 @@ struct ath_rx_stats {
 
 struct ath9k_debug {
 	struct dentry *debugfs_phy;
-	struct dentry *debugfs_tgt_stats;
+	struct dentry *debugfs_tgt_int_stats;
+	struct dentry *debugfs_tgt_tx_stats;
+	struct dentry *debugfs_tgt_rx_stats;
 	struct dentry *debugfs_xmit;
 	struct dentry *debugfs_recv;
 	struct dentry *debugfs_slot;
 	struct dentry *debugfs_queue;
 	struct ath_tx_stats tx_stats;
 	struct ath_rx_stats rx_stats;
-	u32 txrate;
 };
 
 #else
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 961bec2..8d0de60 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -24,39 +24,108 @@ static int ath9k_debugfs_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
-				   size_t count, loff_t *ppos)
+static ssize_t read_file_tgt_int_stats(struct file *file, char __user *user_buf,
+				       size_t count, loff_t *ppos)
 {
 	struct ath9k_htc_priv *priv = file->private_data;
-	struct ath9k_htc_target_stats cmd_rsp;
+	struct ath9k_htc_target_int_stats cmd_rsp;
 	char buf[512];
 	unsigned int len = 0;
 	int ret = 0;
 
 	memset(&cmd_rsp, 0, sizeof(cmd_rsp));
 
-	WMI_CMD(WMI_TGT_STATS_CMDID);
+	WMI_CMD(WMI_INT_STATS_CMDID);
 	if (ret)
 		return -EINVAL;
 
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "RX",
+			be32_to_cpu(cmd_rsp.rx));
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "RXORN",
+			be32_to_cpu(cmd_rsp.rxorn));
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "RXEOL",
+			be32_to_cpu(cmd_rsp.rxeol));
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "TXURN",
+			be32_to_cpu(cmd_rsp.txurn));
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "TXTO",
+			be32_to_cpu(cmd_rsp.txto));
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "CST",
+			be32_to_cpu(cmd_rsp.cst));
+
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_tgt_int_stats = {
+	.read = read_file_tgt_int_stats,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t read_file_tgt_tx_stats(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
+	struct ath9k_htc_target_tx_stats cmd_rsp;
+	char buf[512];
+	unsigned int len = 0;
+	int ret = 0;
+
+	memset(&cmd_rsp, 0, sizeof(cmd_rsp));
+
+	WMI_CMD(WMI_TX_STATS_CMDID);
+	if (ret)
+		return -EINVAL;
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "Xretries",
+			be32_to_cpu(cmd_rsp.xretries));
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "FifoErr",
+			be32_to_cpu(cmd_rsp.fifoerr));
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "Filtered",
+			be32_to_cpu(cmd_rsp.filtered));
 
 	len += snprintf(buf + len, sizeof(buf) - len,
-			"%19s : %10u\n", "TX Short Retries",
-			be32_to_cpu(cmd_rsp.tx_shortretry));
+			"%20s : %10u\n", "TimerExp",
+			be32_to_cpu(cmd_rsp.timer_exp));
+
 	len += snprintf(buf + len, sizeof(buf) - len,
-			"%19s : %10u\n", "TX Long Retries",
-			be32_to_cpu(cmd_rsp.tx_longretry));
+			"%20s : %10u\n", "ShortRetries",
+			be32_to_cpu(cmd_rsp.shortretries));
+
 	len += snprintf(buf + len, sizeof(buf) - len,
-			"%19s : %10u\n", "TX Xretries",
-			be32_to_cpu(cmd_rsp.tx_xretries));
+			"%20s : %10u\n", "LongRetries",
+			be32_to_cpu(cmd_rsp.longretries));
+
 	len += snprintf(buf + len, sizeof(buf) - len,
-			"%19s : %10u\n", "TX Unaggr. Xretries",
-			be32_to_cpu(cmd_rsp.ht_txunaggr_xretry));
+			"%20s : %10u\n", "QueueNull",
+			be32_to_cpu(cmd_rsp.qnull));
+
 	len += snprintf(buf + len, sizeof(buf) - len,
-			"%19s : %10u\n", "TX Xretries (HT)",
-			be32_to_cpu(cmd_rsp.ht_tx_xretries));
+			"%20s : %10u\n", "EncapFail",
+			be32_to_cpu(cmd_rsp.encap_fail));
+
 	len += snprintf(buf + len, sizeof(buf) - len,
-			"%19s : %10u\n", "TX Rate", priv->debug.txrate);
+			"%20s : %10u\n", "NoBuf",
+			be32_to_cpu(cmd_rsp.nobuf));
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
@@ -64,8 +133,48 @@ static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
-static const struct file_operations fops_tgt_stats = {
-	.read = read_file_tgt_stats,
+static const struct file_operations fops_tgt_tx_stats = {
+	.read = read_file_tgt_tx_stats,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t read_file_tgt_rx_stats(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
+	struct ath9k_htc_target_rx_stats cmd_rsp;
+	char buf[512];
+	unsigned int len = 0;
+	int ret = 0;
+
+	memset(&cmd_rsp, 0, sizeof(cmd_rsp));
+
+	WMI_CMD(WMI_RX_STATS_CMDID);
+	if (ret)
+		return -EINVAL;
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "NoBuf",
+			be32_to_cpu(cmd_rsp.nobuf));
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "HostSend",
+			be32_to_cpu(cmd_rsp.host_send));
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "HostDone",
+			be32_to_cpu(cmd_rsp.host_done));
+
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_tgt_rx_stats = {
+	.read = read_file_tgt_rx_stats,
 	.open = ath9k_debugfs_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
@@ -286,29 +395,29 @@ static ssize_t read_file_queue(struct file *file, char __user *user_buf,
 	char buf[512];
 	unsigned int len = 0;
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
 			"Mgmt endpoint", skb_queue_len(&priv->tx.mgmt_ep_queue));
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
 			"Cab endpoint", skb_queue_len(&priv->tx.cab_ep_queue));
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
 			"Data BE endpoint", skb_queue_len(&priv->tx.data_be_queue));
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
 			"Data BK endpoint", skb_queue_len(&priv->tx.data_bk_queue));
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
 			"Data VI endpoint", skb_queue_len(&priv->tx.data_vi_queue));
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
 			"Data VO endpoint", skb_queue_len(&priv->tx.data_vo_queue));
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
 			"Failed queue", skb_queue_len(&priv->tx.tx_failed));
 
 	spin_lock_bh(&priv->tx.tx_lock);
-	len += snprintf(buf + len, sizeof(buf) - len, "%16s : %3d\n",
+	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
 			"Queued count", priv->tx.queued_cnt);
 	spin_unlock_bh(&priv->tx.tx_lock);
 
@@ -339,12 +448,26 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 	if (!priv->debug.debugfs_phy)
 		goto err;
 
-	priv->debug.debugfs_tgt_stats = debugfs_create_file("tgt_stats", S_IRUSR,
-						    priv->debug.debugfs_phy,
-						    priv, &fops_tgt_stats);
-	if (!priv->debug.debugfs_tgt_stats)
+	priv->debug.debugfs_tgt_int_stats = debugfs_create_file("tgt_int_stats",
+							S_IRUSR,
+							priv->debug.debugfs_phy,
+							priv, &fops_tgt_int_stats);
+	if (!priv->debug.debugfs_tgt_int_stats)
 		goto err;
 
+	priv->debug.debugfs_tgt_tx_stats = debugfs_create_file("tgt_tx_stats",
+						       S_IRUSR,
+						       priv->debug.debugfs_phy,
+						       priv, &fops_tgt_tx_stats);
+	if (!priv->debug.debugfs_tgt_tx_stats)
+		goto err;
+
+	priv->debug.debugfs_tgt_rx_stats = debugfs_create_file("tgt_rx_stats",
+						       S_IRUSR,
+						       priv->debug.debugfs_phy,
+						       priv, &fops_tgt_rx_stats);
+	if (!priv->debug.debugfs_tgt_rx_stats)
+		goto err;
 
 	priv->debug.debugfs_xmit = debugfs_create_file("xmit", S_IRUSR,
 						       priv->debug.debugfs_phy,
@@ -386,7 +509,9 @@ void ath9k_htc_exit_debug(struct ath_hw *ah)
 	debugfs_remove(priv->debug.debugfs_slot);
 	debugfs_remove(priv->debug.debugfs_recv);
 	debugfs_remove(priv->debug.debugfs_xmit);
-	debugfs_remove(priv->debug.debugfs_tgt_stats);
+	debugfs_remove(priv->debug.debugfs_tgt_int_stats);
+	debugfs_remove(priv->debug.debugfs_tgt_tx_stats);
+	debugfs_remove(priv->debug.debugfs_tgt_rx_stats);
 	debugfs_remove(priv->debug.debugfs_phy);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 697e5af..8f095ad 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -67,12 +67,18 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_RC_RATE_UPDATE_CMDID";
 	case WMI_TARGET_IC_UPDATE_CMDID:
 		return "WMI_TARGET_IC_UPDATE_CMDID";
-	case WMI_TGT_STATS_CMDID:
-		return "WMI_TGT_STATS_CMDID";
 	case WMI_TX_AGGR_ENABLE_CMDID:
 		return "WMI_TX_AGGR_ENABLE_CMDID";
 	case WMI_TGT_DETACH_CMDID:
 		return "WMI_TGT_DETACH_CMDID";
+	case WMI_NODE_UPDATE_CMDID:
+		return "WMI_NODE_UPDATE_CMDID";
+	case WMI_INT_STATS_CMDID:
+		return "WMI_INT_STATS_CMDID";
+	case WMI_TX_STATS_CMDID:
+		return "WMI_TX_STATS_CMDID";
+	case WMI_RX_STATS_CMDID:
+		return "WMI_RX_STATS_CMDID";
 	case WMI_AGGR_LIMIT_CMD:
 		return "WMI_AGGR_LIMIT_CMD";
 	}
@@ -134,9 +140,6 @@ void ath9k_wmi_event_tasklet(unsigned long data)
 	struct sk_buff *skb = NULL;
 	unsigned long flags;
 	u16 cmd_id;
-#ifdef CONFIG_ATH9K_HTC_DEBUGFS
-	__be32 txrate;
-#endif
 
 	do {
 		spin_lock_irqsave(&wmi->wmi_lock, flags);
@@ -160,12 +163,6 @@ void ath9k_wmi_event_tasklet(unsigned long data)
 			ieee80211_queue_work(wmi->drv_priv->hw,
 					     &wmi->drv_priv->fatal_work);
 			break;
-		case WMI_TXRATE_EVENTID:
-#ifdef CONFIG_ATH9K_HTC_DEBUGFS
-			txrate = ((struct wmi_event_txrate *)wmi_event)->txrate;
-			wmi->drv_priv->debug.txrate = be32_to_cpu(txrate);
-#endif
-			break;
 		case WMI_TXSTATUS_EVENTID:
 			spin_lock_bh(&priv->tx.tx_lock);
 			if (priv->tx.flags & ATH9K_HTC_OP_TX_DRAIN) {
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 310d94e..02ecb9f 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -17,7 +17,6 @@
 #ifndef WMI_H
 #define WMI_H
 
-
 struct wmi_event_txrate {
 	__be32 txrate;
 	struct {
@@ -106,9 +105,12 @@ enum wmi_cmd_id {
 	WMI_RC_STATE_CHANGE_CMDID,
 	WMI_RC_RATE_UPDATE_CMDID,
 	WMI_TARGET_IC_UPDATE_CMDID,
-	WMI_TGT_STATS_CMDID,
 	WMI_TX_AGGR_ENABLE_CMDID,
 	WMI_TGT_DETACH_CMDID,
+	WMI_NODE_UPDATE_CMDID,
+	WMI_INT_STATS_CMDID,
+	WMI_TX_STATS_CMDID,
+	WMI_RX_STATS_CMDID,
 	WMI_AGGR_LIMIT_CMD = 0x0026,
 };
 
@@ -119,7 +121,6 @@ enum wmi_event_id {
 	WMI_TXTO_EVENTID,
 	WMI_BMISS_EVENTID,
 	WMI_DELBA_EVENTID,
-	WMI_TXRATE_EVENTID,
 	WMI_TXSTATUS_EVENTID,
 };
 
-- 
1.7.4.4

