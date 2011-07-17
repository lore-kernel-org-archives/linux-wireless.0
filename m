Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:65011 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756064Ab1GQRDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 13:03:14 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Subject: [PATCH 1/4] libertas: remove auto_deep_sleep functionality
Message-Id: <20110717170310.CAD139D401C@zog.reactivated.net> (sfid-20110717_190318_089926_46F6C8DA)
Date: Sun, 17 Jul 2011 18:03:10 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is unused and I'm not really sure in what context it was designed to
be used.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/cmd.c  |   14 ++-----
 drivers/net/wireless/libertas/decl.h |    3 --
 drivers/net/wireless/libertas/dev.h  |    3 --
 drivers/net/wireless/libertas/main.c |   64 ----------------------------------
 4 files changed, 4 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index dbd24a4..627bdf4 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1024,10 +1024,6 @@ static void lbs_submit_command(struct lbs_private *priv,
 	}
 
 	if (command == CMD_802_11_DEEP_SLEEP) {
-		if (priv->is_auto_deep_sleep_enabled) {
-			priv->wakeup_dev_required = 1;
-			priv->dnld_sent = 0;
-		}
 		priv->is_deep_sleep = 1;
 		lbs_complete_command(priv, cmdnode, 0);
 	} else {
@@ -1614,12 +1610,10 @@ struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
 	/* No commands are allowed in Deep Sleep until we toggle the GPIO
 	 * to wake up the card and it has signaled that it's ready.
 	 */
-	if (!priv->is_auto_deep_sleep_enabled) {
-		if (priv->is_deep_sleep) {
-			lbs_deb_cmd("command not allowed in deep sleep\n");
-			cmdnode = ERR_PTR(-EBUSY);
-			goto done;
-		}
+	if (priv->is_deep_sleep) {
+		lbs_deb_cmd("command not allowed in deep sleep\n");
+		cmdnode = ERR_PTR(-EBUSY);
+		goto done;
 	}
 
 	cmdnode = lbs_get_free_cmd_node(priv);
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index da0b05b..cfe3272 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -54,9 +54,6 @@ int lbs_resume(struct lbs_private *priv);
 void lbs_queue_event(struct lbs_private *priv, u32 event);
 void lbs_notify_command_response(struct lbs_private *priv, u8 resp_idx);
 
-int lbs_enter_auto_deep_sleep(struct lbs_private *priv);
-int lbs_exit_auto_deep_sleep(struct lbs_private *priv);
-
 u32 lbs_fw_index_to_data_rate(u8 index);
 u8 lbs_data_rate_to_fw_index(u32 rate);
 
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 76d018b..094e1f2 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -74,12 +74,9 @@ struct lbs_private {
 	/* Deep sleep */
 	int is_deep_sleep;
 	int deep_sleep_required;
-	int is_auto_deep_sleep_enabled;
 	int wakeup_dev_required;
 	int is_activity_detected;
-	int auto_deep_sleep_timeout; /* in ms */
 	wait_queue_head_t ds_awake_q;
-	struct timer_list auto_deepsleep_timer;
 
 	/* Host sleep*/
 	int is_host_sleep_configured;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index c79aac4..4b086cd 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -520,7 +520,6 @@ static int lbs_thread(void *data)
 	}
 
 	del_timer(&priv->command_timer);
-	del_timer(&priv->auto_deepsleep_timer);
 
 	lbs_deb_leave(LBS_DEB_THREAD);
 	return 0;
@@ -653,64 +652,6 @@ out:
 	lbs_deb_leave(LBS_DEB_CMD);
 }
 
-/**
- * auto_deepsleep_timer_fn - put the device back to deep sleep mode when
- * timer expires and no activity (command, event, data etc.) is detected.
- * @data:	&struct lbs_private pointer
- * returns:	N/A
- */
-static void auto_deepsleep_timer_fn(unsigned long data)
-{
-	struct lbs_private *priv = (struct lbs_private *)data;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (priv->is_activity_detected) {
-		priv->is_activity_detected = 0;
-	} else {
-		if (priv->is_auto_deep_sleep_enabled &&
-		    (!priv->wakeup_dev_required) &&
-		    (priv->connect_status != LBS_CONNECTED)) {
-			struct cmd_header cmd;
-
-			lbs_deb_main("Entering auto deep sleep mode...\n");
-			memset(&cmd, 0, sizeof(cmd));
-			cmd.size = cpu_to_le16(sizeof(cmd));
-			lbs_cmd_async(priv, CMD_802_11_DEEP_SLEEP, &cmd,
-					sizeof(cmd));
-		}
-	}
-	mod_timer(&priv->auto_deepsleep_timer , jiffies +
-				(priv->auto_deep_sleep_timeout * HZ)/1000);
-	lbs_deb_leave(LBS_DEB_CMD);
-}
-
-int lbs_enter_auto_deep_sleep(struct lbs_private *priv)
-{
-	lbs_deb_enter(LBS_DEB_SDIO);
-
-	priv->is_auto_deep_sleep_enabled = 1;
-	if (priv->is_deep_sleep)
-		priv->wakeup_dev_required = 1;
-	mod_timer(&priv->auto_deepsleep_timer ,
-			jiffies + (priv->auto_deep_sleep_timeout * HZ)/1000);
-
-	lbs_deb_leave(LBS_DEB_SDIO);
-	return 0;
-}
-
-int lbs_exit_auto_deep_sleep(struct lbs_private *priv)
-{
-	lbs_deb_enter(LBS_DEB_SDIO);
-
-	priv->is_auto_deep_sleep_enabled = 0;
-	priv->auto_deep_sleep_timeout = 0;
-	del_timer(&priv->auto_deepsleep_timer);
-
-	lbs_deb_leave(LBS_DEB_SDIO);
-	return 0;
-}
-
 static int lbs_init_adapter(struct lbs_private *priv)
 {
 	int ret;
@@ -726,7 +667,6 @@ static int lbs_init_adapter(struct lbs_private *priv)
 	priv->psmode = LBS802_11POWERMODECAM;
 	priv->psstate = PS_STATE_FULL_POWER;
 	priv->is_deep_sleep = 0;
-	priv->is_auto_deep_sleep_enabled = 0;
 	priv->deep_sleep_required = 0;
 	priv->wakeup_dev_required = 0;
 	init_waitqueue_head(&priv->ds_awake_q);
@@ -739,8 +679,6 @@ static int lbs_init_adapter(struct lbs_private *priv)
 
 	setup_timer(&priv->command_timer, lbs_cmd_timeout_handler,
 		(unsigned long)priv);
-	setup_timer(&priv->auto_deepsleep_timer, auto_deepsleep_timer_fn,
-			(unsigned long)priv);
 
 	INIT_LIST_HEAD(&priv->cmdfreeq);
 	INIT_LIST_HEAD(&priv->cmdpendingq);
@@ -776,7 +714,6 @@ static void lbs_free_adapter(struct lbs_private *priv)
 	lbs_free_cmd_buffer(priv);
 	kfifo_free(&priv->event_fifo);
 	del_timer(&priv->command_timer);
-	del_timer(&priv->auto_deepsleep_timer);
 
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
@@ -995,7 +932,6 @@ void lbs_stop_card(struct lbs_private *priv)
 
 	/* Delete the timeout of the currently processing command */
 	del_timer_sync(&priv->command_timer);
-	del_timer_sync(&priv->auto_deepsleep_timer);
 
 	/* Flush pending command nodes */
 	spin_lock_irqsave(&priv->driver_lock, flags);
-- 
1.7.6

