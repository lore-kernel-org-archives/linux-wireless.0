Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:46422 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754105Ab3AaD61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 22:58:27 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: remove max_tx_buf_size
Date: Wed, 30 Jan 2013 19:56:02 -0800
Message-Id: <1359604562-23777-2-git-send-email-bzhao@marvell.com> (sfid-20130131_045835_842466_87ACF974)
In-Reply-To: <1359604562-23777-1-git-send-email-bzhao@marvell.com>
References: <1359604562-23777-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

max_tx_buf_size is not used any more after reconfiguration of
tx buffer size has been removed.

Also add missing curr_tx_buf_size update while dumping debug info
via debugfs.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/README        |    1 -
 drivers/net/wireless/mwifiex/debugfs.c     |    2 --
 drivers/net/wireless/mwifiex/init.c        |    1 -
 drivers/net/wireless/mwifiex/ioctl.h       |    1 -
 drivers/net/wireless/mwifiex/main.h        |    1 -
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    5 ++---
 drivers/net/wireless/mwifiex/util.c        |    2 +-
 7 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index b55bade..3d64613 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -121,7 +121,6 @@ info
 	wmm_ac_vi = <number of packets sent to device from WMM AcVi queue>
 	wmm_ac_be = <number of packets sent to device from WMM AcBE queue>
 	wmm_ac_bk = <number of packets sent to device from WMM AcBK queue>
-	max_tx_buf_size = <maximum Tx buffer size>
 	tx_buf_size = <current Tx buffer size>
 	curr_tx_buf_size = <current Tx buffer size>
 	ps_mode = <0/1, CAM mode/PS mode>
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 46e34aa..753b568 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -58,8 +58,6 @@ static struct mwifiex_debug_data items[] = {
 	 item_addr(packets_out[WMM_AC_BE]), 1},
 	{"wmm_ac_bk", item_size(packets_out[WMM_AC_BK]),
 	 item_addr(packets_out[WMM_AC_BK]), 1},
-	{"max_tx_buf_size", item_size(max_tx_buf_size),
-	 item_addr(max_tx_buf_size), 1},
 	{"tx_buf_size", item_size(tx_buf_size),
 	 item_addr(tx_buf_size), 1},
 	{"curr_tx_buf_size", item_size(curr_tx_buf_size),
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index e00b806..820a19c 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -317,7 +317,6 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 
 	adapter->pm_wakeup_fw_try = false;
 
-	adapter->max_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
 	adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
 	adapter->curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
 
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 6095b3e..f3d9d04 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -178,7 +178,6 @@ struct mwifiex_ds_tx_ba_stream_tbl {
 struct mwifiex_debug_info {
 	u32 int_counter;
 	u32 packets_out[MAX_NUM_TID];
-	u32 max_tx_buf_size;
 	u32 tx_buf_size;
 	u32 curr_tx_buf_size;
 	u32 tx_tbl_num;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 51044e3..ac799a0 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -631,7 +631,6 @@ struct mwifiex_adapter {
 	/* spin lock for main process */
 	spinlock_t main_proc_lock;
 	u32 mwifiex_processing;
-	u16 max_tx_buf_size;
 	u16 tx_buf_size;
 	u16 curr_tx_buf_size;
 	u32 ioport;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 65c12eb..8470564 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -935,9 +935,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 					/ MWIFIEX_SDIO_BLOCK_SIZE)
 				       * MWIFIEX_SDIO_BLOCK_SIZE;
 		adapter->curr_tx_buf_size = adapter->tx_buf_size;
-		dev_dbg(adapter->dev,
-			"cmd: max_tx_buf_size=%d, tx_buf_size=%d\n",
-			adapter->max_tx_buf_size, adapter->tx_buf_size);
+		dev_dbg(adapter->dev, "cmd: curr_tx_buf_size=%d\n",
+			adapter->curr_tx_buf_size);
 
 		if (adapter->if_ops.update_mp_end_port)
 			adapter->if_ops.update_mp_end_port(adapter,
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 0982375..2155397 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -91,7 +91,7 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 		memcpy(info->packets_out,
 		       priv->wmm.packets_out,
 		       sizeof(priv->wmm.packets_out));
-		info->max_tx_buf_size = (u32) adapter->max_tx_buf_size;
+		info->curr_tx_buf_size = (u32) adapter->curr_tx_buf_size;
 		info->tx_buf_size = (u32) adapter->tx_buf_size;
 		info->rx_tbl_num = mwifiex_get_rx_reorder_tbl(priv,
 							      info->rx_tbl);
-- 
1.7.0.2

