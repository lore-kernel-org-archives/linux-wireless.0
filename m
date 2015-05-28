Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39843 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbbE1OQu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 10:16:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4SEF355003981
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 07:16:49 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 1unvy5s3t1-1
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 07:16:49 -0700
From: Avinash Patil <patila@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 03/17] mwifiex: support AP reset after bss_stop
Date: Thu, 28 May 2015 14:16:47 +0000
Message-ID: <1432842406790.81429@marvell.com> (sfid-20150528_161653_767182_12049E80)
References: <1432817552-25866-1-git-send-email-patila@marvell.com>,<1432817552-25866-4-git-send-email-patila@marvell.com>
In-Reply-To: <1432817552-25866-4-git-send-email-patila@marvell.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Please ignore this series. Looks like some of the patches are duplicated because of email client issue.
I will resend v2.

Thanks,
Avinash

________________________________________
From: Avinash Patil <patila@marvell.com>
Sent: Thursday, May 28, 2015 6:22 PM
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar; Cathy Luo; Xinming Hu; Avinash Patil
Subject: [PATCH 03/17] mwifiex: support AP reset after bss_stop

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

+       if (mwifiex_send_cmd(priv, HOST_CMD_APCMD_SYS_RESET,
+                            HostCmd_ACT_GEN_SET, 0, NULL, true)) {
+               mwifiex_dbg(priv->adapter, ERROR,
+                           "Failed to reset BSS\n");
+               return -1;
+       }
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
+               case HOST_CMD_APCMD_SYS_RESET:
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
+       case HOST_CMD_APCMD_SYS_RESET:
+               break;
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
+       case HOST_CMD_APCMD_SYS_RESET:
                cmd->command = cpu_to_le16(cmd_no);
                cmd->size = cpu_to_le16(S_DS_GEN);
                break;
@@ -811,8 +812,13 @@ int mwifiex_config_start_uap(struct mwifiex_private *priv,

        if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
                             HostCmd_ACT_GEN_SET, 0, NULL, true)) {
-               mwifiex_dbg(priv->adapter, ERROR,
-                           "Failed to stop the BSS\n");
+               mwifiex_dbg(priv->adapter, ERROR, "Failed to stop the BSS\n");
+               return -1;
+       }
+
+       if (mwifiex_send_cmd(priv, HOST_CMD_APCMD_SYS_RESET,
+                            HostCmd_ACT_GEN_SET, 0, NULL, true)) {
+               mwifiex_dbg(priv->adapter, ERROR, "Failed to reset BSS\n");
                return -1;
        }

--
1.8.1.4

