Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65082 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab1CQS7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:59:19 -0400
Received: by mail-iy0-f174.google.com with SMTP id 26so3126341iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 11:59:19 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Nishant Sarmukadam <nishants@marvell.com>,
	Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH 7/9] mwl8k: Handle the watchdog event from the firmware
Date: Thu, 17 Mar 2011 11:58:47 -0700
Message-Id: <1300388329-15380-7-git-send-email-brian@cozybit.com>
In-Reply-To: <1300388329-15380-1-git-send-email-brian@cozybit.com>
References: <1300388329-15380-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

When an ampdu stream is on, if the firmware rate adaptation
logic decides that the outgoing packet rate to the station needs
to go below 6.5Mbps (non HT rate), it sends an event indicating that
the ampdu stream needs to be destroyed. Handle this event in the driver
and destroy the ampdu stream so that the rate can go below 6.5Mbps

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   77 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ec1190a..b90178d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -63,6 +63,7 @@ MODULE_PARM_DESC(ap_mode_default,
 #define MWL8K_HIU_A2H_INTERRUPT_CLEAR_SEL	0x00000c38
 #define MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK	0x00000c3c
 #define  MWL8K_A2H_INT_DUMMY			 (1 << 20)
+#define  MWL8K_A2H_INT_BA_WATCHDOG		 (1 << 14)
 #define  MWL8K_A2H_INT_CHNL_SWITCHED		 (1 << 11)
 #define  MWL8K_A2H_INT_QUEUE_EMPTY		 (1 << 10)
 #define  MWL8K_A2H_INT_RADAR_DETECT		 (1 << 7)
@@ -82,7 +83,8 @@ MODULE_PARM_DESC(ap_mode_default,
 				 MWL8K_A2H_INT_MAC_EVENT | \
 				 MWL8K_A2H_INT_OPC_DONE | \
 				 MWL8K_A2H_INT_RX_READY | \
-				 MWL8K_A2H_INT_TX_DONE)
+				 MWL8K_A2H_INT_TX_DONE | \
+				 MWL8K_A2H_INT_BA_WATCHDOG)
 
 #define MWL8K_RX_QUEUES		1
 #define MWL8K_TX_WMM_QUEUES	4
@@ -181,6 +183,7 @@ struct mwl8k_priv {
 	u8 num_ampdu_queues;
 	spinlock_t stream_lock;
 	struct mwl8k_ampdu_stream ampdu[MWL8K_MAX_AMPDU_QUEUES];
+	struct work_struct watchdog_ba_handle;
 
 	/* firmware access */
 	struct mutex fw_mutex;
@@ -375,6 +378,7 @@ static const struct ieee80211_rate mwl8k_rates_50[] = {
 #define MWL8K_CMD_ENABLE_SNIFFER	0x0150
 #define MWL8K_CMD_SET_MAC_ADDR		0x0202		/* per-vif */
 #define MWL8K_CMD_SET_RATEADAPT_MODE	0x0203
+#define MWL8K_CMD_GET_WATCHDOG_BITMAP	0x0205
 #define MWL8K_CMD_BSS_START		0x1100		/* per-vif */
 #define MWL8K_CMD_SET_NEW_STN		0x1111		/* per-vif */
 #define MWL8K_CMD_UPDATE_ENCRYPTION	0x1122		/* per-vif */
@@ -420,6 +424,7 @@ static const char *mwl8k_cmd_name(__le16 cmd, char *buf, int bufsize)
 		MWL8K_CMDNAME(UPDATE_ENCRYPTION);
 		MWL8K_CMDNAME(UPDATE_STADB);
 		MWL8K_CMDNAME(BASTREAM);
+		MWL8K_CMDNAME(GET_WATCHDOG_BITMAP);
 	default:
 		snprintf(buf, bufsize, "0x%x", cmd);
 	}
@@ -3320,6 +3325,65 @@ static int mwl8k_cmd_set_rateadapt_mode(struct ieee80211_hw *hw, __u16 mode)
 }
 
 /*
+ * CMD_GET_WATCHDOG_BITMAP.
+ */
+struct mwl8k_cmd_get_watchdog_bitmap {
+	struct mwl8k_cmd_pkt header;
+	u8	bitmap;
+} __packed;
+
+static int mwl8k_cmd_get_watchdog_bitmap(struct ieee80211_hw *hw, u8 *bitmap)
+{
+	struct mwl8k_cmd_get_watchdog_bitmap *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_GET_WATCHDOG_BITMAP);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	if (!rc)
+		*bitmap = cmd->bitmap;
+
+	kfree(cmd);
+
+	return rc;
+}
+
+#define INVALID_BA	0xAA
+static void mwl8k_watchdog_ba_events(struct work_struct *work)
+{
+	int rc;
+	u8 bitmap = 0, stream_index;
+	struct mwl8k_ampdu_stream *streams;
+	struct mwl8k_priv *priv =
+		container_of(work, struct mwl8k_priv, watchdog_ba_handle);
+
+	rc = mwl8k_cmd_get_watchdog_bitmap(priv->hw, &bitmap);
+	if (rc)
+		return;
+
+	if (bitmap == INVALID_BA)
+		return;
+
+	/* the bitmap is the hw queue number.  Map it to the ampdu queue. */
+	stream_index = bitmap - MWL8K_TX_WMM_QUEUES;
+
+	BUG_ON(stream_index >= priv->num_ampdu_queues);
+
+	streams = &priv->ampdu[stream_index];
+
+	if (streams->state == AMPDU_STREAM_ACTIVE)
+		ieee80211_stop_tx_ba_session(streams->sta, streams->tid);
+
+	return;
+}
+
+
+/*
  * CMD_BSS_START.
  */
 struct mwl8k_cmd_bss_start {
@@ -4014,6 +4078,11 @@ static irqreturn_t mwl8k_interrupt(int irq, void *dev_id)
 		tasklet_schedule(&priv->poll_rx_task);
 	}
 
+	if (status & MWL8K_A2H_INT_BA_WATCHDOG) {
+		status &= ~MWL8K_A2H_INT_BA_WATCHDOG;
+		ieee80211_queue_work(hw, &priv->watchdog_ba_handle);
+	}
+
 	if (status)
 		iowrite32(~status, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
 
@@ -4166,6 +4235,7 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 
 	/* Stop finalize join worker */
 	cancel_work_sync(&priv->finalize_join_worker);
+	cancel_work_sync(&priv->watchdog_ba_handle);
 	if (priv->beacon_skb != NULL)
 		dev_kfree_skb(priv->beacon_skb);
 
@@ -5100,7 +5170,8 @@ static int mwl8k_probe_hw(struct ieee80211_hw *hw)
 
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
-	iowrite32(MWL8K_A2H_INT_TX_DONE | MWL8K_A2H_INT_RX_READY,
+	iowrite32(MWL8K_A2H_INT_TX_DONE|MWL8K_A2H_INT_RX_READY|
+		  MWL8K_A2H_INT_BA_WATCHDOG,
 		  priv->regs + MWL8K_HIU_A2H_INTERRUPT_CLEAR_SEL);
 	iowrite32(0xffffffff, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
 
@@ -5258,6 +5329,8 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 
 	/* Finalize join worker */
 	INIT_WORK(&priv->finalize_join_worker, mwl8k_finalize_join_worker);
+	/* Handle watchdog ba events */
+	INIT_WORK(&priv->watchdog_ba_handle, mwl8k_watchdog_ba_events);
 
 	/* TX reclaim and RX tasklets.  */
 	tasklet_init(&priv->poll_tx_task, mwl8k_tx_poll, (unsigned long)hw);
-- 
1.7.1.1

