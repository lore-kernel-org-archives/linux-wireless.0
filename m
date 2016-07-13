Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33089 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbcGMLVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 07:21:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6DBH1On015083
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 04:20:55 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 242xmm70w3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 04:20:54 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 2/2] mwifiex: add hostcmd wext ioctl support
Date: Wed, 13 Jul 2016 16:49:06 +0530
Message-ID: <1468408746-28376-2-git-send-email-akarwar@marvell.com> (sfid-20160713_132256_723539_4EE8C566)
In-Reply-To: <1468408746-28376-1-git-send-email-akarwar@marvell.com>
References: <1468408746-28376-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch adds ndo_ioctl support to mwifiex netdev handlers.
This will be used to download hostcmds to firmware from userspace.
This is needed for manufacturing mode support in mwifiex. ndo_ioctl
is allowed only when mfg mode is enabled via module load parameters.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
Changes in v2:
 1) Sequence of these two patches are changed to resolve compilation
    error seen if only 1/2 is applied.
 2) Add "select WEXT_PRIV" in Kconfig to resolve warnings reported by
    kbuild test robot.
---
 drivers/net/wireless/marvell/mwifiex/Kconfig  |  3 ++
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 59 +++++++++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.c   | 38 +++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.h   |  9 +++-
 4 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/Kconfig b/drivers/net/wireless/marvell/mwifiex/Kconfig
index 279167d..5b1d52a 100644
--- a/drivers/net/wireless/marvell/mwifiex/Kconfig
+++ b/drivers/net/wireless/marvell/mwifiex/Kconfig
@@ -13,6 +13,7 @@ config MWIFIEX_SDIO
 	depends on MWIFIEX && MMC
 	select FW_LOADER
 	select WANT_DEV_COREDUMP
+	select WEXT_PRIV
 	---help---
 	  This adds support for wireless adapters based on Marvell
 	  8786/8787/8797/8887/8897/8997 chipsets with SDIO interface.
@@ -25,6 +26,7 @@ config MWIFIEX_PCIE
 	depends on MWIFIEX && PCI
 	select FW_LOADER
 	select WANT_DEV_COREDUMP
+	select WEXT_PRIV
 	---help---
 	  This adds support for wireless adapters based on Marvell
 	  8766/8897/8997 chipsets with PCIe interface.
@@ -36,6 +38,7 @@ config MWIFIEX_USB
 	tristate "Marvell WiFi-Ex Driver for USB8766/8797/8997"
 	depends on MWIFIEX && USB
 	select FW_LOADER
+	select WEXT_PRIV
 	---help---
 	  This adds support for wireless adapters based on Marvell
 	  8797/8997 chipset with USB interface.
diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 8d57493..d961305 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -826,6 +826,8 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 			hostcmd = adapter->curr_cmd->data_buf;
 			hostcmd->len = size;
 			memcpy(hostcmd->cmd, resp, size);
+			adapter->hostcmd_resp_data.len = size;
+			memcpy(adapter->hostcmd_resp_data.cmd, resp, size);
 		}
 	}
 	orig_cmdresp_no = le16_to_cpu(resp->command);
@@ -1208,6 +1210,63 @@ mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
 				   false);
 }
 EXPORT_SYMBOL_GPL(mwifiex_process_hs_config);
+/* This function get hostcmd data from userspace and construct a cmd
+   * to be download to FW.
+  */
+int mwifiex_process_host_command(struct mwifiex_private *priv,
+				 struct iwreq *wrq)
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
+	if (copy_from_user(cmd, wrq->u.data.pointer,
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
+	if (copy_from_user(cmd, wrq->u.data.pointer, hostcmd_buf->len)) {
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
+	if (copy_to_user(wrq->u.data.pointer, adapter->hostcmd_resp_data.cmd,
+			 adapter->hostcmd_resp_data.len)) {
+		ret = -EFAULT;
+		goto done;
+	}
+	wrq->u.data.length = adapter->hostcmd_resp_data.len;
+
+	ret = 0;
+done:
+	kfree(hostcmd_buf);
+	return ret;
+}
 
 /*
  * This function handles the command response of a sleep confirm command.
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index b54edf4..e3e1fe9 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1238,17 +1238,54 @@ mwifiex_netdev_select_wmm_queue(struct net_device *dev, struct sk_buff *skb,
 	return mwifiex_1d_to_wmm_queue[skb->priority];
 }
 
+static int mwifiex_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct iwreq *wrq = (struct iwreq *)req;
+	int ret;
+
+	if (!priv->adapter->mfg_mode)
+		return -EINVAL;
+
+	dev_dbg(priv->adapter->dev, "ioctl cmd = 0x%x\n", cmd);
+
+	switch (cmd) {
+	case MWIFIEX_HOSTCMD_IOCTL:
+		ret = mwifiex_process_host_command(priv, wrq);
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
 	.ndo_set_mac_address = mwifiex_set_mac_address,
+	.ndo_do_ioctl = mwifiex_do_ioctl,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_tx_timeout = mwifiex_tx_timeout,
 	.ndo_get_stats = mwifiex_get_stats,
 	.ndo_set_rx_mode = mwifiex_set_multicast_list,
 	.ndo_select_queue = mwifiex_netdev_select_wmm_queue,
+	};
+
+static const struct iw_priv_args mwifiex_iwpriv_args[] = {
+	{       MWIFIEX_HOSTCMD_IOCTL,
+		IW_PRIV_TYPE_BYTE | 2047,
+		IW_PRIV_TYPE_BYTE | 2047,
+		"hostcmd"
+	},
+};
+
+static struct iw_handler_def mwifiex_iwpriv_handler_def = {
+	.num_private_args = ARRAY_SIZE(mwifiex_iwpriv_args),
+	.private_args = (struct iw_priv_args *)mwifiex_iwpriv_args,
 };
 
 /*
@@ -1276,6 +1313,7 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 {
 	dev->netdev_ops = &mwifiex_netdev_ops;
 	dev->destructor = free_netdev;
+	dev->wireless_handlers = &mwifiex_iwpriv_handler_def;
 	/* Initialize private structure */
 	priv->current_key_index = 0;
 	priv->media_connected = false;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index ee71e4a..5713fe5 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -48,6 +48,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/of_irq.h>
+#include <linux/wireless.h>
+#include <net/iw_handler.h>
 
 #include "decl.h"
 #include "ioctl.h"
@@ -160,6 +162,9 @@ enum {
 /* Threshold for tx_timeout_cnt before we trigger a card reset */
 #define TX_TIMEOUT_THRESHOLD	6
 
+/* IOCTL number used for hostcmd process*/
+#define MWIFIEX_HOSTCMD_IOCTL (SIOCIWFIRSTPRIV + 17)
+
 #define MWIFIEX_DRV_INFO_SIZE_MAX 0x40000
 
 /* Address alignment */
@@ -895,6 +900,7 @@ struct mwifiex_adapter {
 	u8 event_received;
 	u8 data_received;
 	u16 seq_num;
+	struct mwifiex_ds_misc_cmd hostcmd_resp_data;
 	struct cmd_ctrl_node *cmd_pool;
 	struct cmd_ctrl_node *curr_cmd;
 	/* spin lock for command */
@@ -1557,7 +1563,8 @@ bool mwifiex_is_bss_in_11ac_mode(struct mwifiex_private *priv);
 u8 mwifiex_get_center_freq_index(struct mwifiex_private *priv, u8 band,
 				 u32 pri_chan, u8 chan_bw);
 int mwifiex_init_channel_scan_gap(struct mwifiex_adapter *adapter);
-
+int mwifiex_process_host_command(struct mwifiex_private *priv,
+				 struct iwreq *wrq);
 int mwifiex_tdls_check_tx(struct mwifiex_private *priv, struct sk_buff *skb);
 void mwifiex_flush_auto_tdls_list(struct mwifiex_private *priv);
 void mwifiex_auto_tdls_update_peer_status(struct mwifiex_private *priv,
-- 
1.9.1

