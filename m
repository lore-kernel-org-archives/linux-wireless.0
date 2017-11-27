Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45482 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751180AbdK0HJm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 02:09:42 -0500
From: Xinming Hu <huxm@marvell.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH v2 3/3] mwifiex: debugfs: trigger device dump for usb interface
Date: Mon, 27 Nov 2017 15:09:15 +0800
Message-ID: <1511766555-30780-3-git-send-email-huxm@marvell.com> (sfid-20171127_080945_664394_208170F1)
In-Reply-To: <1511766555-30780-1-git-send-email-huxm@marvell.com>
References: <1511766555-30780-1-git-send-email-huxm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch extend device_dump debugfs function to make it
works for usb interface.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
v2: Same as v1
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c  | 11 +++++++----
 drivers/net/wireless/marvell/mwifiex/debugfs.c |  9 +++++----
 drivers/net/wireless/marvell/mwifiex/fw.h      |  1 +
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c |  4 ++++
 4 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index dcc529e..8746600 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -290,13 +290,16 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	adapter->dbg.last_cmd_act[adapter->dbg.last_cmd_index] =
 			get_unaligned_le16((u8 *)host_cmd + S_DS_GEN);
 
+	/* Setup the timer after transmit command, except that specific
+	 * command might not have command response.
+	 */
+	if (cmd_code != HostCmd_CMD_FW_DUMP_EVENT)
+		mod_timer(&adapter->cmd_timer,
+			  jiffies + msecs_to_jiffies(MWIFIEX_TIMER_10S));
+
 	/* Clear BSS_NO_BITS from HostCmd */
 	cmd_code &= HostCmd_CMD_ID_MASK;
 
-	/* Setup the timer after transmit command */
-	mod_timer(&adapter->cmd_timer,
-		  jiffies + msecs_to_jiffies(MWIFIEX_TIMER_10S));
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index 6f4239b..5d476de 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -168,10 +168,11 @@
 {
 	struct mwifiex_private *priv = file->private_data;
 
-	if (!priv->adapter->if_ops.device_dump)
-		return -EIO;
-
-	priv->adapter->if_ops.device_dump(priv->adapter);
+	if (priv->adapter->iface_type == MWIFIEX_USB)
+		mwifiex_send_cmd(priv, HostCmd_CMD_FW_DUMP_EVENT,
+				 HostCmd_ACT_GEN_SET, 0, NULL, true);
+	else
+		priv->adapter->if_ops.device_dump(priv->adapter);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 4d5e686..9c2cdef 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -409,6 +409,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_TDLS_CONFIG                       0x0100
 #define HostCmd_CMD_MC_POLICY                         0x0121
 #define HostCmd_CMD_TDLS_OPER                         0x0122
+#define HostCmd_CMD_FW_DUMP_EVENT		      0x0125
 #define HostCmd_CMD_SDIO_SP_RX_AGGR_CFG               0x0223
 #define HostCmd_CMD_CHAN_REGION_CFG		      0x0242
 #define HostCmd_CMD_PACKET_AGGR_CTRL		      0x0251
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index fb09014..211e47d 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -2206,6 +2206,10 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 	case HostCmd_CMD_CHAN_REGION_CFG:
 		ret = mwifiex_cmd_chan_region_cfg(priv, cmd_ptr, cmd_action);
 		break;
+	case HostCmd_CMD_FW_DUMP_EVENT:
+		cmd_ptr->command = cpu_to_le16(cmd_no);
+		cmd_ptr->size = cpu_to_le16(S_DS_GEN);
+		break;
 	default:
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "PREP_CMD: unknown cmd- %#x\n", cmd_no);
-- 
1.9.1
