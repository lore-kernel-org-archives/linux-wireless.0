Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:35416 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756336Ab2EIBdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 21:33:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 07/18] mwifiex: add bss start and bss stop commands for AP
Date: Tue,  8 May 2012 18:30:19 -0700
Message-Id: <1336527030-2045-8-git-send-email-bzhao@marvell.com> (sfid-20120509_033316_964447_74767CBC)
In-Reply-To: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
References: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

1. separate file for preparing uAP command buffer
2. definition of bss_start and bss_stop commands being sent to
firmware

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/Makefile      |    1 +
 drivers/net/wireless/mwifiex/cmdevt.c      |   16 ++++++++-
 drivers/net/wireless/mwifiex/fw.h          |    3 ++
 drivers/net/wireless/mwifiex/main.h        |    3 ++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    8 +++++
 drivers/net/wireless/mwifiex/uap_cmd.c     |   46 ++++++++++++++++++++++++++++
 6 files changed, 75 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/uap_cmd.c

diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index 5c1a46b..3ec71ae 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -29,6 +29,7 @@ mwifiex-y += scan.o
 mwifiex-y += join.o
 mwifiex-y += sta_ioctl.o
 mwifiex-y += sta_cmd.o
+mwifiex-y += uap_cmd.o
 mwifiex-y += sta_cmdresp.o
 mwifiex-y += sta_event.o
 mwifiex-y += sta_tx.o
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index d9f30c5..51e023e 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -545,8 +545,20 @@ int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
 
 	/* Prepare command */
 	if (cmd_no) {
-		ret = mwifiex_sta_prepare_cmd(priv, cmd_no, cmd_action,
-					      cmd_oid, data_buf, cmd_ptr);
+		switch (cmd_no) {
+		case HostCmd_CMD_UAP_SYS_CONFIG:
+		case HostCmd_CMD_UAP_BSS_START:
+		case HostCmd_CMD_UAP_BSS_STOP:
+			ret = mwifiex_uap_prepare_cmd(priv, cmd_no, cmd_action,
+						      cmd_oid, data_buf,
+						      cmd_ptr);
+			break;
+		default:
+			ret = mwifiex_sta_prepare_cmd(priv, cmd_no, cmd_action,
+						      cmd_oid, data_buf,
+						      cmd_ptr);
+			break;
+		}
 	} else {
 		ret = mwifiex_cmd_host_cmd(priv, cmd_ptr, data_buf);
 		cmd_node->cmd_flag |= CMD_F_HOSTCMD;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 3996918..5caa826 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -210,6 +210,9 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_RSSI_INFO                         0x00a4
 #define HostCmd_CMD_FUNC_INIT                         0x00a9
 #define HostCmd_CMD_FUNC_SHUTDOWN                     0x00aa
+#define HostCmd_CMD_UAP_SYS_CONFIG                    0x00b0
+#define HostCmd_CMD_UAP_BSS_START                     0x00b1
+#define HostCmd_CMD_UAP_BSS_STOP                      0x00b2
 #define HostCmd_CMD_11N_CFG                           0x00cd
 #define HostCmd_CMD_11N_ADDBA_REQ                     0x00ce
 #define HostCmd_CMD_11N_ADDBA_RSP                     0x00cf
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index ed978de..24db86f 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -762,6 +762,9 @@ int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 int mwifiex_sta_prepare_cmd(struct mwifiex_private *, uint16_t cmd_no,
 			    u16 cmd_action, u32 cmd_oid,
 			    void *data_buf, void *cmd_buf);
+int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
+			    u16 cmd_action, u32 cmd_oid,
+			    void *data_buf, void *cmd_buf);
 int mwifiex_process_sta_cmdresp(struct mwifiex_private *, u16 cmdresp_no,
 				struct host_cmd_ds_command *resp);
 int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *,
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 3aa5424..a79ed9b 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -944,6 +944,14 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_802_11_SUBSCRIBE_EVENT:
 		ret = mwifiex_ret_subsc_evt(priv, resp, data_buf);
 		break;
+	case HostCmd_CMD_UAP_SYS_CONFIG:
+		break;
+	case HostCmd_CMD_UAP_BSS_START:
+		priv->bss_started = 1;
+		break;
+	case HostCmd_CMD_UAP_BSS_STOP:
+		priv->bss_started = 0;
+		break;
 	default:
 		dev_err(adapter->dev, "CMD_RESP: unknown cmd response %#x\n",
 			resp->command);
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
new file mode 100644
index 0000000..97002a4
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -0,0 +1,46 @@
+/*
+ * Marvell Wireless LAN device driver: AP specific command handling
+ *
+ * Copyright (C) 2012, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "main.h"
+
+/* This function prepares the AP specific commands before sending them
+ * to the firmware.
+ * This is a generic function which calls specific command preparation
+ * routines based upon the command number.
+ */
+int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, u16 cmd_no,
+			    u16 cmd_action, u32 cmd_oid,
+			    void *data_buf, void *cmd_buf)
+{
+	struct host_cmd_ds_command *cmd = cmd_buf;
+
+	switch (cmd_no) {
+	case HostCmd_CMD_UAP_BSS_START:
+	case HostCmd_CMD_UAP_BSS_STOP:
+		cmd->command = cpu_to_le16(cmd_no);
+		cmd->size = cpu_to_le16(S_DS_GEN);
+		break;
+	default:
+		dev_err(priv->adapter->dev,
+			"PREP_CMD: unknown cmd %#x\n", cmd_no);
+		return -1;
+	}
+
+	return 0;
+}
-- 
1.7.0.2

