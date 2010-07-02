Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:64101 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759261Ab0GBSof (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:44:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/8] iwlwifi: add mac80211 flush callback support
Date: Fri,  2 Jul 2010 11:45:36 -0700
Message-Id: <1278096340-2546-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding flush callback support in the driver. Two type of flush can be
issued by mac80211:
1. drop = true: frame drop is ok, issue REPLY_TXFIFO_FLUSH host command
to uCode to drop all the frames in tx fifo queues; then return the
control back to mac80211
2. drop = false: wait for either all the frames in tx fifo queues been
transmitted, or timeout; then return the control back to mac80211

If the flush request coming from mac80211, mac80211 will make sure there
are no additional frames push down to driver before flush operation is
completed.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   63 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   39 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 8 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 1daf159..00808ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -226,6 +226,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
 	.check_ack_health = iwl_good_ack_health,
+	.txfifo_flush = iwlagn_txfifo_flush,
 };
 
 static const struct iwl_ops iwl1000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b8f3e20..1182498 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -402,6 +402,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
 	.check_ack_health = iwl_good_ack_health,
+	.txfifo_flush = iwlagn_txfifo_flush,
 };
 
 static struct iwl_lib_ops iwl5150_lib = {
@@ -465,6 +466,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
 	.check_ack_health = iwl_good_ack_health,
+	.txfifo_flush = iwlagn_txfifo_flush,
 };
 
 static const struct iwl_ops iwl5000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 8577664..e1959fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -327,6 +327,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
 	.check_ack_health = iwl_good_ack_health,
+	.txfifo_flush = iwlagn_txfifo_flush,
 };
 
 static const struct iwl_ops iwl6000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 5f1e7d8..95666e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1435,3 +1435,66 @@ void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 		priv->stations[sta_id].tid[tid].tfds_in_queue = 0;
 	}
 }
+
+#define IWL_FLUSH_WAIT_MS	2000
+
+int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv)
+{
+	struct iwl_tx_queue *txq;
+	struct iwl_queue *q;
+	int cnt;
+	unsigned long now = jiffies;
+	int ret = 0;
+
+	/* waiting for all the tx frames complete might take a while */
+	for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
+		if (cnt == IWL_CMD_QUEUE_NUM)
+			continue;
+		txq = &priv->txq[cnt];
+		q = &txq->q;
+		while (q->read_ptr != q->write_ptr && !time_after(jiffies,
+		       now + msecs_to_jiffies(IWL_FLUSH_WAIT_MS)))
+				msleep(1);
+
+		if (q->read_ptr != q->write_ptr) {
+			IWL_ERR(priv, "fail to flush all tx fifo queues\n");
+			ret = -ETIMEDOUT;
+			break;
+		}
+	}
+	return ret;
+}
+
+#define IWL_TX_QUEUE_MSK	0xfffff
+
+/**
+ * iwlagn_txfifo_flush: send REPLY_TXFIFO_FLUSH command to uCode
+ *
+ * pre-requirements:
+ *  1. acquire mutex before calling
+ *  2. make sure rf is on and not in exit state
+ */
+int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
+{
+	struct iwl_txfifo_flush_cmd flush_cmd;
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_TXFIFO_FLUSH,
+		.len = sizeof(struct iwl_txfifo_flush_cmd),
+		.flags = CMD_SYNC,
+		.data = &flush_cmd,
+	};
+
+	might_sleep();
+
+	memset(&flush_cmd, 0, sizeof(flush_cmd));
+	flush_cmd.fifo_control = IWL_TX_FIFO_VO_MSK | IWL_TX_FIFO_VI_MSK |
+				 IWL_TX_FIFO_BE_MSK | IWL_TX_FIFO_BK_MSK;
+	if (priv->cfg->sku & IWL_SKU_N)
+		flush_cmd.fifo_control |= IWL_AGG_TX_QUEUE_MSK;
+
+	IWL_DEBUG_INFO(priv, "fifo queue control: 0X%x\n",
+		       flush_cmd.fifo_control);
+	flush_cmd.flush_control = cpu_to_le16(flush_control);
+
+	return iwl_send_cmd(priv, &cmd);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 22c0149..c735a39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3639,6 +3639,44 @@ out_exit:
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
+static void iwl_mac_flush(struct ieee80211_hw *hw, bool drop)
+{
+	struct iwl_priv *priv = hw->priv;
+
+	mutex_lock(&priv->mutex);
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	/* do not support "flush" */
+	if (!priv->cfg->ops->lib->txfifo_flush)
+		goto done;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
+		IWL_DEBUG_TX(priv, "Aborting flush due to device shutdown\n");
+		goto done;
+	}
+	if (iwl_is_rfkill(priv)) {
+		IWL_DEBUG_TX(priv, "Aborting flush due to RF Kill\n");
+		goto done;
+	}
+
+	/*
+	 * mac80211 will not push any more frames for transmit
+	 * until the flush is completed
+	 */
+	if (drop) {
+		IWL_DEBUG_MAC80211(priv, "send flush command\n");
+		if (priv->cfg->ops->lib->txfifo_flush(priv, IWL_DROP_ALL)) {
+			IWL_ERR(priv, "flush request fail\n");
+			goto done;
+		}
+	}
+	IWL_DEBUG_MAC80211(priv, "wait transmit/flush all frames\n");
+	iwlagn_wait_tx_queue_empty(priv);
+done:
+	mutex_unlock(&priv->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+}
+
 /*****************************************************************************
  *
  * driver setup and teardown
@@ -3812,6 +3850,7 @@ static struct ieee80211_ops iwl_hw_ops = {
 	.sta_add = iwlagn_mac_sta_add,
 	.sta_remove = iwl_mac_sta_remove,
 	.channel_switch = iwl_mac_channel_switch,
+	.flush = iwl_mac_flush,
 };
 
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index be9d298..0298642 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -147,6 +147,8 @@ const u8 *iwlagn_eeprom_query_addr(const struct iwl_priv *priv,
 void iwlagn_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwlagn_hw_nic_init(struct iwl_priv *priv);
+int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv);
+int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 
 /* rx */
 void iwlagn_rx_queue_restock(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index b28cb4f..0844955 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1216,6 +1216,10 @@ struct iwl_rem_sta_cmd {
 #define IWL_TX_FIFO_VO_MSK		cpu_to_le32(BIT(3))
 #define IWL_AGG_TX_QUEUE_MSK		cpu_to_le32(0xffc00)
 
+#define IWL_DROP_SINGLE		0
+#define IWL_DROP_SELECTED	1
+#define IWL_DROP_ALL		2
+
 /*
  * REPLY_TXFIFO_FLUSH = 0x1e(command and response)
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index bfa3456..db315b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -205,6 +205,8 @@ struct iwl_lib_ops {
 	/* check for ack health */
 	bool (*check_ack_health)(struct iwl_priv *priv,
 					struct iwl_rx_packet *pkt);
+	int (*txfifo_flush)(struct iwl_priv *priv, u16 flush_control);
+
 	struct iwl_debugfs_ops debugfs_ops;
 };
 
-- 
1.7.0.4

