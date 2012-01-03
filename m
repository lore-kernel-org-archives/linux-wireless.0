Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:54742 "HELO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753461Ab2ACAS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 19:18:59 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.2] mwifiex: fix crash during simultaneous scan and connect
Date: Mon,  2 Jan 2012 16:18:40 -0800
Message-Id: <1325549920-22474-1-git-send-email-bzhao@marvell.com> (sfid-20120103_011903_567394_8DE51FEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

If 'iw connect' command is fired when driver is already busy in
serving 'iw scan' command, ssid specific scan operation for connect
is skipped. In this case cmd wait queue handler gets called with no
command in queue (i.e. adapter->cmd_queued = NULL).

This patch adds a NULL check in mwifiex_wait_queue_complete()
routine to fix crash observed during simultaneous scan and assoc
operations.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---

Hi John,

Hope it can catch up the 3.2 train. Otherwise please apply it for 3.3.
Thanks!


 drivers/net/wireless/mwifiex/sta_ioctl.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index e40196d..470ca75 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -55,9 +55,14 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 {
 	bool cancel_flag = false;
 	int status = adapter->cmd_wait_q.status;
-	struct cmd_ctrl_node *cmd_queued = adapter->cmd_queued;
+	struct cmd_ctrl_node *cmd_queued;
 
+	if (!adapter->cmd_queued)
+		return 0;
+
+	cmd_queued = adapter->cmd_queued;
 	adapter->cmd_queued = NULL;
+
 	dev_dbg(adapter->dev, "cmd pending\n");
 	atomic_inc(&adapter->cmd_pending);
 
-- 
1.7.0.2

