Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:40774 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932100Ab3CPBsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 21:48:33 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Marco Cesarano <marco@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.9 1/3] mwifiex: fix race when queuing commands
Date: Fri, 15 Mar 2013 18:47:05 -0700
Message-ID: <1363398427-30392-2-git-send-email-bzhao@marvell.com> (sfid-20130316_024836_063700_9A47EBAD)
In-Reply-To: <1363398427-30392-1-git-send-email-bzhao@marvell.com>
References: <1363398427-30392-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Running the following script repeatedly on XO-4 with SD8787
produces command timeout and system lockup.

insmod mwifiex_sdio.ko
sleep 1
ifconfig eth0 up
iwlist eth0 scan &
sleep 0.5
rmmod mwifiex_sdio

mwifiex_send_cmd_async() is called for sync as well as async
commands. (mwifiex_send_cmd_sync() internally calls it for
sync command.)

"adapter->cmd_queued" gets filled inside mwifiex_send_cmd_async()
routine for both types of commands. But it is used only for sync
commands in mwifiex_wait_queue_complete(). This could lead to a
race when two threads try to queue a sync command with another
sync/async command simultaneously.

Get rid of global variable and pass command node as a parameter
to mwifiex_wait_queue_complete() to fix the problem.

Cc: <stable@vger.kernel.org> # 3.8
Reported-by: Daniel Drake <dsd@laptop.org>
Tested-by: Daniel Drake <dsd@laptop.org>
Tested-by: Marco Cesarano <marco@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c    |    5 ++---
 drivers/net/wireless/mwifiex/main.h      |    4 ++--
 drivers/net/wireless/mwifiex/scan.c      |    8 ++++----
 drivers/net/wireless/mwifiex/sta_ioctl.c |   10 ++--------
 4 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index d19a88c..f47ad3a 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -484,8 +484,6 @@ int mwifiex_send_cmd_sync(struct mwifiex_private *priv, uint16_t cmd_no,
 
 	ret = mwifiex_send_cmd_async(priv, cmd_no, cmd_action, cmd_oid,
 				     data_buf);
-	if (!ret)
-		ret = mwifiex_wait_queue_complete(adapter);
 
 	return ret;
 }
@@ -588,9 +586,10 @@ int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
 	if (cmd_no == HostCmd_CMD_802_11_SCAN) {
 		mwifiex_queue_scan_cmd(priv, cmd_node);
 	} else {
-		adapter->cmd_queued = cmd_node;
 		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
 		queue_work(adapter->workqueue, &adapter->main_work);
+		if (cmd_node->wait_q_enabled)
+			ret = mwifiex_wait_queue_complete(adapter, cmd_node);
 	}
 
 	return ret;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 9206575..7255289 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -728,7 +728,6 @@ struct mwifiex_adapter {
 	u16 cmd_wait_q_required;
 	struct mwifiex_wait_queue cmd_wait_q;
 	u8 scan_wait_q_woken;
-	struct cmd_ctrl_node *cmd_queued;
 	spinlock_t queue_lock;		/* lock for tx queues */
 	struct completion fw_load;
 	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
@@ -1023,7 +1022,8 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 			struct mwifiex_multicast_list *mcast_list);
 int mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
 			    struct net_device *dev);
-int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter);
+int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter,
+				struct cmd_ctrl_node *cmd_queued);
 int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		      struct cfg80211_ssid *req_ssid);
 int mwifiex_cancel_hs(struct mwifiex_private *priv, int cmd_type);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index bb60c27..d215b4d 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1388,10 +1388,13 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 			list_del(&cmd_node->list);
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
-			adapter->cmd_queued = cmd_node;
 			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
 							true);
 			queue_work(adapter->workqueue, &adapter->main_work);
+
+			/* Perform internal scan synchronously */
+			if (!priv->scan_request)
+				mwifiex_wait_queue_complete(adapter, cmd_node);
 		} else {
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
@@ -1946,9 +1949,6 @@ int mwifiex_request_scan(struct mwifiex_private *priv,
 		/* Normal scan */
 		ret = mwifiex_scan_networks(priv, NULL);
 
-	if (!ret)
-		ret = mwifiex_wait_queue_complete(priv->adapter);
-
 	up(&priv->async_sem);
 
 	return ret;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 76d31de..8c943b6 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -54,16 +54,10 @@ int mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
  * This function waits on a cmd wait queue. It also cancels the pending
  * request after waking up, in case of errors.
  */
-int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
+int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter,
+				struct cmd_ctrl_node *cmd_queued)
 {
 	int status;
-	struct cmd_ctrl_node *cmd_queued;
-
-	if (!adapter->cmd_queued)
-		return 0;
-
-	cmd_queued = adapter->cmd_queued;
-	adapter->cmd_queued = NULL;
 
 	dev_dbg(adapter->dev, "cmd pending\n");
 	atomic_inc(&adapter->cmd_pending);
-- 
1.7.0.2

