Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:45161 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932236Ab2F1C7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 22:59:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] mwifiex: wakeup main thread to handle command queued
Date: Wed, 27 Jun 2012 19:57:56 -0700
Message-Id: <1340852279-24964-2-git-send-email-bzhao@marvell.com> (sfid-20120628_045922_058529_6AC81F1F)
In-Reply-To: <1340852279-24964-1-git-send-email-bzhao@marvell.com>
References: <1340852279-24964-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We miss to wakeup main thread after adding command to cmd pending
queue at follwing places. These commands are handled later when
main thread is woken up for handling an interrupt for sleep event
from firmware. This adds worst case delay of 50msec.

1) We don't wakeup main thread when asynchronous command is added
to cmd pending queue. Move queue_work() call from
mwifiex_wait_queue_complete() to mwifiex_send_cmd_async() to wakeup
main thread for sync as well as async commands.

2) Scan operation is triggered due to following reasons
   a) request from user (ex. "iw scan" command)
   b) Scan performed by driver internally.
   In first case main thread is woken up when first scan command is
queued in cmd pending queue (we don't need to wakeup main thread for
subsequent scan commands, because they are queued in scan command
response handler), but it is not done for second case. queue_work()
is moved inside mwifiex_scan_networks() to handle both the cases.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |    2 +-
 drivers/net/wireless/mwifiex/cmdevt.c    |    1 +
 drivers/net/wireless/mwifiex/main.h      |    4 ++--
 drivers/net/wireless/mwifiex/scan.c      |   25 +++----------------------
 drivers/net/wireless/mwifiex/sta_ioctl.c |    3 ---
 5 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ef5a88b..8f64b33 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1422,7 +1422,7 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
 
 		priv->user_scan_cfg->chan_list[i].scan_time = 0;
 	}
-	if (mwifiex_set_user_scan_ioctl(priv, priv->user_scan_cfg))
+	if (mwifiex_scan_networks(priv, priv->user_scan_cfg))
 		return -EFAULT;
 
 	if (request->ie && request->ie_len) {
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index ea37b88..c68adec 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -578,6 +578,7 @@ int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
 	} else {
 		adapter->cmd_queued = cmd_node;
 		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
+		queue_work(adapter->workqueue, &adapter->main_work);
 	}
 
 	return ret;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 0b3b5aa..7cd95cc 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -949,8 +949,8 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 			      struct mwifiex_rate_cfg *rate);
 int mwifiex_request_scan(struct mwifiex_private *priv,
 			 struct cfg80211_ssid *req_ssid);
-int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
-				struct mwifiex_user_scan_cfg *scan_req);
+int mwifiex_scan_networks(struct mwifiex_private *priv,
+			  const struct mwifiex_user_scan_cfg *user_scan_in);
 int mwifiex_set_radio(struct mwifiex_private *priv, u8 option);
 
 int mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, u16 channel);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index efaf26c..884ed63 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1296,8 +1296,8 @@ mwifiex_radio_type_to_band(u8 radio_type)
  * order to send the appropriate scan commands to firmware to populate or
  * update the internal driver scan table.
  */
-static int mwifiex_scan_networks(struct mwifiex_private *priv,
-		const struct mwifiex_user_scan_cfg *user_scan_in)
+int mwifiex_scan_networks(struct mwifiex_private *priv,
+			  const struct mwifiex_user_scan_cfg *user_scan_in)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -1362,6 +1362,7 @@ static int mwifiex_scan_networks(struct mwifiex_private *priv,
 			adapter->cmd_queued = cmd_node;
 			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
 							true);
+			queue_work(adapter->workqueue, &adapter->main_work);
 		} else {
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
@@ -1378,26 +1379,6 @@ static int mwifiex_scan_networks(struct mwifiex_private *priv,
 }
 
 /*
- * Sends IOCTL request to start a scan with user configurations.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- *
- * Upon completion, it also generates a wireless event to notify
- * applications.
- */
-int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
-				struct mwifiex_user_scan_cfg *scan_req)
-{
-	int status;
-
-	status = mwifiex_scan_networks(priv, scan_req);
-	queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
-
-	return status;
-}
-
-/*
  * This function prepares a scan command to be sent to the firmware.
  *
  * This uses the scan command configuration sent to the command processing
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 106c449..f2fd242 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -66,9 +66,6 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 	dev_dbg(adapter->dev, "cmd pending\n");
 	atomic_inc(&adapter->cmd_pending);
 
-	/* Status pending, wake up main process */
-	queue_work(adapter->workqueue, &adapter->main_work);
-
 	/* Wait for completion */
 	wait_event_interruptible(adapter->cmd_wait_q.wait,
 				 *(cmd_queued->condition));
-- 
1.7.0.2

