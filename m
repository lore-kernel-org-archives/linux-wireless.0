Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45574 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbXLJRTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:19:07 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 24/48] libertas: kill adapter->nr_cmd_pending
Message-Id: <E1J1kpT-0006m3-9z@shinybook.infradead.org> (sfid-20071210_171911_618333_F21B0585)
Date: Mon, 10 Dec 2007 10:45:59 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 8 Dec 2007 00:35:00 +0000

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |    6 ++----
 drivers/net/wireless/libertas/cmdresp.c |    5 -----
 drivers/net/wireless/libertas/debugfs.c |    3 ++-
 drivers/net/wireless/libertas/dev.h     |    1 -
 drivers/net/wireless/libertas/main.c    |    4 +---
 5 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index cf1ab8a..092c295 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1009,10 +1009,9 @@ void lbs_queue_cmd(struct lbs_adapter *adapter,
 
 	spin_lock_irqsave(&adapter->driver_lock, flags);
 
-	if (addtail) {
+	if (addtail)
 		list_add_tail(&cmdnode->list, &adapter->cmdpendingq);
-		adapter->nr_cmd_pending++;
-	} else
+	else
 		list_add(&cmdnode->list, &adapter->cmdpendingq);
 
 	spin_unlock_irqrestore(&adapter->driver_lock, flags);
@@ -1078,7 +1077,6 @@ static int DownloadcommandToStation(struct lbs_private *priv,
 		spin_lock_irqsave(&adapter->driver_lock, flags);
 		adapter->cur_cmd_retcode = ret;
 		__lbs_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
-		adapter->nr_cmd_pending--;
 		adapter->cur_cmd = NULL;
 		spin_unlock_irqrestore(&adapter->driver_lock, flags);
 		goto done;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index f6c1016..44865bf 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -791,7 +791,6 @@ int lbs_process_rx_command(struct lbs_private *priv)
 		lbs_deb_host("invalid response!\n");
 		adapter->cur_cmd_retcode = -1;
 		__lbs_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
-		adapter->nr_cmd_pending--;
 		adapter->cur_cmd = NULL;
 		spin_unlock_irqrestore(&adapter->driver_lock, flags);
 		ret = -1;
@@ -848,7 +847,6 @@ int lbs_process_rx_command(struct lbs_private *priv)
 		}
 
 		__lbs_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
-		adapter->nr_cmd_pending--;
 		adapter->cur_cmd = NULL;
 		spin_unlock_irqrestore(&adapter->driver_lock, flags);
 
@@ -872,7 +870,6 @@ int lbs_process_rx_command(struct lbs_private *priv)
 		}
 
 		__lbs_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
-		adapter->nr_cmd_pending--;
 		adapter->cur_cmd = NULL;
 		spin_unlock_irqrestore(&adapter->driver_lock, flags);
 
@@ -892,8 +889,6 @@ int lbs_process_rx_command(struct lbs_private *priv)
 	if (adapter->cur_cmd) {
 		/* Clean up and Put current command back to cmdfreeq */
 		__lbs_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
-		adapter->nr_cmd_pending--;
-		WARN_ON(adapter->nr_cmd_pending > 128);
 		adapter->cur_cmd = NULL;
 	}
 	spin_unlock_irqrestore(&adapter->driver_lock, flags);
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index dde0c37..341ef67 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -321,7 +321,8 @@ static ssize_t lbs_setuserscan(struct file *file,
 
 	lbs_scan_networks(priv, scan_cfg, 1);
 	wait_event_interruptible(priv->adapter->cmd_pending,
-				 priv->adapter->surpriseremoved || !priv->adapter->nr_cmd_pending);
+				 priv->adapter->surpriseremoved || 
+				 (!priv->adapter->cur_cmd && list_empty(&priv->adapter->cmdpendingq)));
 
 	if (priv->adapter->surpriseremoved)
 		goto out_scan_cfg;
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 96a34c5..fb26f18 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -231,7 +231,6 @@ struct lbs_adapter {
 	struct list_head cmdpendingq;
 
 	wait_queue_head_t cmd_pending;
-	u8 nr_cmd_pending;
 	/* command related variables protected by adapter->driver_lock */
 
 	/** Async and Sync Event variables */
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index a5b573c..500357b 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -929,14 +929,13 @@ static int lbs_thread(void *data)
 		/* Wake-up command waiters which can't sleep in
 		 * lbs_prepare_and_send_command
 		 */
-		if (!adapter->nr_cmd_pending)
+		if (!list_empty(&adapter->cmdpendingq))
 			wake_up_all(&adapter->cmd_pending);
 
 		lbs_tx_runqueue(priv);
 	}
 
 	del_timer(&adapter->command_timer);
-	adapter->nr_cmd_pending = 0;
 	wake_up_all(&adapter->cmd_pending);
 
 	lbs_deb_leave(LBS_DEB_THREAD);
@@ -1105,7 +1104,6 @@ static int lbs_init_adapter(struct lbs_private *priv)
 
 	spin_lock_init(&adapter->driver_lock);
 	init_waitqueue_head(&adapter->cmd_pending);
-	adapter->nr_cmd_pending = 0;
 
 	/* Allocate the command buffers */
 	if (lbs_allocate_cmd_buffer(priv)) {
-- 
1.5.3.4

