Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbYIHUeI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 16:34:08 -0400
Subject: [PATCH] libertas: clear current command on card removal
From: Dan Williams <dcbw@redhat.com>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, cjb@laptop.org, stable@kernel.org
Content-Type: text/plain
Date: Mon, 08 Sep 2008 16:34:40 -0400
Message-Id: <1220906080.1618.20.camel@localhost.localdomain> (sfid-20080908_223411_121270_A8BCA75B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If certain commands were in-flight when the card was pulled or the
driver rmmod-ed, cleanup would block on the work queue stopping, but the
work queue was in turn blocked on the current command being canceled,
which didn't happen.  Fix that.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
John, this is 2.6.27 material if there's still time.

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 2436634..73dc8c7 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1205,7 +1205,13 @@ void lbs_remove_card(struct lbs_private *priv)
 	cancel_delayed_work_sync(&priv->scan_work);
 	cancel_delayed_work_sync(&priv->assoc_work);
 	cancel_work_sync(&priv->mcast_work);
+
+	/* worker thread destruction blocks on the in-flight command which
+	 * should have been cleared already in lbs_stop_card().
+	 */
+	lbs_deb_main("destroying worker thread\n");
 	destroy_workqueue(priv->work_thread);
+	lbs_deb_main("done destroying worker thread\n");
 
 	if (priv->psmode == LBS802_11POWERMODEMAX_PSP) {
 		priv->psmode = LBS802_11POWERMODECAM;
@@ -1323,14 +1329,26 @@ void lbs_stop_card(struct lbs_private *priv)
 		device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
 	}
 
-	/* Flush pending command nodes */
+	/* Delete the timeout of the currently processing command */
 	del_timer_sync(&priv->command_timer);
+
+	/* Flush pending command nodes */
 	spin_lock_irqsave(&priv->driver_lock, flags);
+	lbs_deb_main("clearing pending commands\n");
 	list_for_each_entry(cmdnode, &priv->cmdpendingq, list) {
 		cmdnode->result = -ENOENT;
 		cmdnode->cmdwaitqwoken = 1;
 		wake_up_interruptible(&cmdnode->cmdwait_q);
 	}
+
+	/* Flush the command the card is currently processing */
+	if (priv->cur_cmd) {
+		lbs_deb_main("clearing current command\n");
+		priv->cur_cmd->result = -ENOENT;
+		priv->cur_cmd->cmdwaitqwoken = 1;
+		wake_up_interruptible(&priv->cur_cmd->cmdwait_q);
+	}
+	lbs_deb_main("done clearing commands\n");
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	unregister_netdev(dev);


