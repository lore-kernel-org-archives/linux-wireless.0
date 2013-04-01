Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:36738 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759445Ab3DATtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 15:49:07 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Stone Piao <piaoyun@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.9 RESEND] mwifiex: complete last internal scan
Date: Mon, 1 Apr 2013 12:44:45 -0700
Message-ID: <1364845486-1074-1-git-send-email-bzhao@marvell.com> (sfid-20130401_214911_241795_EE3955BA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are waiting on first scan command of internal scan request
before association, so we should complete on last internal scan
command response.

Cc: <stable@vger.kernel.org> # 3.8
Tested-by: Daniel Drake <dsd@laptop.org>
Tested-by: Marco Cesarano <marco@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index d215b4d..e7f6dea 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1393,8 +1393,10 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 			queue_work(adapter->workqueue, &adapter->main_work);
 
 			/* Perform internal scan synchronously */
-			if (!priv->scan_request)
+			if (!priv->scan_request) {
+				dev_dbg(adapter->dev, "wait internal scan\n");
 				mwifiex_wait_queue_complete(adapter, cmd_node);
+			}
 		} else {
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
@@ -1793,7 +1795,12 @@ check_next_scan:
 		/* Need to indicate IOCTL complete */
 		if (adapter->curr_cmd->wait_q_enabled) {
 			adapter->cmd_wait_q.status = 0;
-			mwifiex_complete_cmd(adapter, adapter->curr_cmd);
+			if (!priv->scan_request) {
+				dev_dbg(adapter->dev,
+					"complete internal scan\n");
+				mwifiex_complete_cmd(adapter,
+						     adapter->curr_cmd);
+			}
 		}
 		if (priv->report_scan_result)
 			priv->report_scan_result = false;
-- 
1.7.0.2

