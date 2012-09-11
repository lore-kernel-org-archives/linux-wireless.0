Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:43518 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756478Ab2IKBbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 21:31:35 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 01/10] mwifiex: remove get operation code for SUBSCRIBE EVENT command
Date: Mon, 10 Sep 2012 18:30:40 -0700
Message-Id: <1347327049-13665-2-git-send-email-bzhao@marvell.com> (sfid-20120911_033137_545541_AFCBCB02)
In-Reply-To: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
References: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We don't send this command with GET action. Redundant code in
mwifiex_ret_subsc_evt() is removed in this patch.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 675c00b..364b608 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -776,8 +776,7 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
  * This function handles the command response for subscribe event command.
  */
 static int mwifiex_ret_subsc_evt(struct mwifiex_private *priv,
-				 struct host_cmd_ds_command *resp,
-				 struct mwifiex_ds_misc_subsc_evt *sub_event)
+				 struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_802_11_subsc_evt *cmd_sub_event =
 		&resp->params.subsc_evt;
@@ -787,10 +786,6 @@ static int mwifiex_ret_subsc_evt(struct mwifiex_private *priv,
 	dev_dbg(priv->adapter->dev, "Bitmap of currently subscribed events: %16x\n",
 		le16_to_cpu(cmd_sub_event->events));
 
-	/*Return the subscribed event info for a Get request*/
-	if (sub_event)
-		sub_event->events = le16_to_cpu(cmd_sub_event->events);
-
 	return 0;
 }
 
@@ -938,7 +933,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_PCIE_DESC_DETAILS:
 		break;
 	case HostCmd_CMD_802_11_SUBSCRIBE_EVENT:
-		ret = mwifiex_ret_subsc_evt(priv, resp, data_buf);
+		ret = mwifiex_ret_subsc_evt(priv, resp);
 		break;
 	case HostCmd_CMD_UAP_SYS_CONFIG:
 		break;
-- 
1.7.0.2

