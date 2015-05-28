Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62200 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221AbbE1M7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 08:59:45 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4SCxj4K014926
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 05:59:45 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1unvy5rwuk-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 05:59:45 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 03/17] mwifiex: support AP reset after bss_stop
Date: Thu, 28 May 2015 23:58:53 +0530
Message-ID: <1432837747-2075-4-git-send-email-patila@marvell.com> (sfid-20150528_145949_844624_A8592BB8)
In-Reply-To: <1432837747-2075-1-git-send-email-patila@marvell.com>
References: <1432837747-2075-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This would enable clearing of FW bss data structures when AP
operations are stopped.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    |  7 +++++++
 drivers/net/wireless/mwifiex/cmdevt.c      |  1 +
 drivers/net/wireless/mwifiex/fw.h          |  1 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  2 ++
 drivers/net/wireless/mwifiex/uap_cmd.c     | 10 ++++++++--
 5 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 3a14d3a..d47799a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1725,6 +1725,13 @@ static int mwifiex_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		return -1;
 	}
 
+	if (mwifiex_send_cmd(priv, HOST_CMD_APCMD_SYS_RESET,
+			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Failed to reset BSS\n");
+		return -1;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index a1de83f..b5033d1 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -574,6 +574,7 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 		case HostCmd_CMD_UAP_BSS_START:
 		case HostCmd_CMD_UAP_BSS_STOP:
 		case HostCmd_CMD_UAP_STA_DEAUTH:
+		case HOST_CMD_APCMD_SYS_RESET:
 			ret = mwifiex_uap_prepare_cmd(priv, cmd_no, cmd_action,
 						      cmd_oid, data_buf,
 						      cmd_ptr);
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 6a062dd..124120d 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -330,6 +330,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_RSSI_INFO                         0x00a4
 #define HostCmd_CMD_FUNC_INIT                         0x00a9
 #define HostCmd_CMD_FUNC_SHUTDOWN                     0x00aa
+#define HOST_CMD_APCMD_SYS_RESET                      0x00af
 #define HostCmd_CMD_UAP_SYS_CONFIG                    0x00b0
 #define HostCmd_CMD_UAP_BSS_START                     0x00b1
 #define HostCmd_CMD_UAP_BSS_STOP                      0x00b2
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index aa5b9a3..f20a09e 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -1159,6 +1159,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	case HostCmd_CMD_UAP_STA_DEAUTH:
 		break;
+	case HOST_CMD_APCMD_SYS_RESET:
+		break;
 	case HostCmd_CMD_MEF_CFG:
 		break;
 	case HostCmd_CMD_COALESCE_CFG:
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index a4ae283..0a3297e 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -754,6 +754,7 @@ int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, u16 cmd_no,
 		break;
 	case HostCmd_CMD_UAP_BSS_START:
 	case HostCmd_CMD_UAP_BSS_STOP:
+	case HOST_CMD_APCMD_SYS_RESET:
 		cmd->command = cpu_to_le16(cmd_no);
 		cmd->size = cpu_to_le16(S_DS_GEN);
 		break;
@@ -811,8 +812,13 @@ int mwifiex_config_start_uap(struct mwifiex_private *priv,
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
 			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
-		mwifiex_dbg(priv->adapter, ERROR,
-			    "Failed to stop the BSS\n");
+		mwifiex_dbg(priv->adapter, ERROR, "Failed to stop the BSS\n");
+		return -1;
+	}
+
+	if (mwifiex_send_cmd(priv, HOST_CMD_APCMD_SYS_RESET,
+			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
+		mwifiex_dbg(priv->adapter, ERROR, "Failed to reset BSS\n");
 		return -1;
 	}
 
-- 
1.8.1.4

