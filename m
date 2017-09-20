Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34148 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdITGoY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 02:44:24 -0400
Received: by mail-pg0-f66.google.com with SMTP id u18so1158432pgo.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Sep 2017 23:44:24 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: add device specific ioctl handler
Date: Wed, 20 Sep 2017 06:44:13 +0000
Message-Id: <1505889853-20493-1-git-send-email-huxinming820@gmail.com> (sfid-20170920_084428_888483_6F13B835)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Add net_dev ndo_do_ioctl handler, which could be used for
downloading host command by utility in manufactory test

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 59 +++++++++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.c   | 23 +++++++++++
 drivers/net/wireless/marvell/mwifiex/main.h   |  7 +++-
 3 files changed, 88 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 0edc5d6..86ee399 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -839,6 +839,8 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 			hostcmd = adapter->curr_cmd->data_buf;
 			hostcmd->len = size;
 			memcpy(hostcmd->cmd, resp, size);
+			adapter->hostcmd_resp_data.len = size;
+			memcpy(adapter->hostcmd_resp_data.cmd, resp, size);
 		}
 	}
 	orig_cmdresp_no = le16_to_cpu(resp->command);
@@ -1221,6 +1223,63 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 }
 EXPORT_SYMBOL_GPL(mwifiex_process_hs_config);
 
+/* This function get hostcmd data from userspace and construct a cmd
+ * to be download to FW.
+ */
+int mwifiex_process_host_command(struct mwifiex_private *priv,
+				 struct ifreq *req)
+{
+	struct mwifiex_ds_misc_cmd *hostcmd_buf;
+	struct host_cmd_ds_command *cmd;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int ret;
+
+	hostcmd_buf = kzalloc(sizeof(*hostcmd_buf), GFP_KERNEL);
+	if (!hostcmd_buf)
+		return -ENOMEM;
+
+	cmd = (void *)hostcmd_buf->cmd;
+
+	if (copy_from_user(cmd, req->ifr_data,
+			   sizeof(cmd->command) + sizeof(cmd->size))) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+	hostcmd_buf->len = le16_to_cpu(cmd->size);
+	if (hostcmd_buf->len > MWIFIEX_SIZE_OF_CMD_BUFFER) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	if (copy_from_user(cmd, req->ifr_data, hostcmd_buf->len)) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+	if (mwifiex_send_cmd(priv, 0, 0, 0, hostcmd_buf, true)) {
+		dev_err(priv->adapter->dev, "Failed to process hostcmd\n");
+		ret = -EFAULT;
+		goto done;
+	}
+
+	if (adapter->hostcmd_resp_data.len > hostcmd_buf->len) {
+		ret = -EFBIG;
+		goto done;
+	}
+
+	if (copy_to_user(req->ifr_data, adapter->hostcmd_resp_data.cmd,
+			 adapter->hostcmd_resp_data.len)) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+	ret = 0;
+done:
+	kfree(hostcmd_buf);
+	return ret;
+}
+
 /*
  * This function handles the command response of a sleep confirm command.
  *
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index ee40b73..3e7700f 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1265,12 +1265,35 @@ static struct net_device_stats *mwifiex_get_stats(struct net_device *dev)
 	return mwifiex_1d_to_wmm_queue[skb->priority];
 }
 
+static int mwifiex_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	int ret;
+
+	if (!priv->adapter->mfg_mode)
+		return -EINVAL;
+
+	mwifiex_dbg(priv->adapter, "ioctl cmd = 0x%x\n", cmd);
+
+	switch (cmd) {
+	case MWIFIEX_HOSTCMD_IOCTL:
+		ret = mwifiex_process_host_command(priv, req);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 /* Network device handlers */
 static const struct net_device_ops mwifiex_netdev_ops = {
 	.ndo_open = mwifiex_open,
 	.ndo_stop = mwifiex_close,
 	.ndo_start_xmit = mwifiex_hard_start_xmit,
 	.ndo_set_mac_address = mwifiex_ndo_set_mac_address,
+	.ndo_do_ioctl = mwifiex_do_ioctl,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_tx_timeout = mwifiex_tx_timeout,
 	.ndo_get_stats = mwifiex_get_stats,
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index a76bd79..4639f49 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -160,6 +160,9 @@ enum {
 /* Threshold for tx_timeout_cnt before we trigger a card reset */
 #define TX_TIMEOUT_THRESHOLD	6
 
+/* IOCTL number used for hostcmd process*/
+#define MWIFIEX_HOSTCMD_IOCTL (SIOCDEVPRIVATE + 1)
+
 #define MWIFIEX_DRV_INFO_SIZE_MAX 0x40000
 
 /* Address alignment */
@@ -912,6 +915,7 @@ struct mwifiex_adapter {
 	u8 event_received;
 	u8 data_received;
 	u16 seq_num;
+	struct mwifiex_ds_misc_cmd hostcmd_resp_data;
 	struct cmd_ctrl_node *cmd_pool;
 	struct cmd_ctrl_node *curr_cmd;
 	/* spin lock for command */
@@ -1611,7 +1615,8 @@ int mwifiex_get_tdls_list(struct mwifiex_private *priv,
 u8 mwifiex_get_center_freq_index(struct mwifiex_private *priv, u8 band,
 				 u32 pri_chan, u8 chan_bw);
 int mwifiex_init_channel_scan_gap(struct mwifiex_adapter *adapter);
-
+int mwifiex_process_host_command(struct mwifiex_private *priv,
+				 struct ifreq *req);
 int mwifiex_tdls_check_tx(struct mwifiex_private *priv, struct sk_buff *skb);
 void mwifiex_flush_auto_tdls_list(struct mwifiex_private *priv);
 void mwifiex_auto_tdls_update_peer_status(struct mwifiex_private *priv,
-- 
1.9.1
