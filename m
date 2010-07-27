Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab0G0SPb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 14:15:31 -0400
Subject: [wt PATCH 16/16] libertas: remove unused cmd_pending waitq
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 13:17:03 -0700
Message-ID: <1280261823.19686.41.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/dev.h  |    1 -
 drivers/net/wireless/libertas/main.c |    8 --------
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 85cdc9a..3c7e255 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -111,7 +111,6 @@ struct lbs_private {
 	struct cmd_ctrl_node *cur_cmd;
 	struct list_head cmdfreeq;    /* free command buffers */
 	struct list_head cmdpendingq; /* pending command buffers */
-	wait_queue_head_t cmd_pending;
 	struct timer_list command_timer;
 	int cmd_timed_out;
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 960799f..2b2dbb0 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -502,12 +502,6 @@ static int lbs_thread(void *data)
 		if (!priv->dnld_sent && !priv->cur_cmd)
 			lbs_execute_next_command(priv);
 
-		/* Wake-up command waiters which can't sleep in
-		 * lbs_prepare_and_send_command
-		 */
-		if (!list_empty(&priv->cmdpendingq))
-			wake_up_all(&priv->cmd_pending);
-
 		spin_lock_irq(&priv->driver_lock);
 		if (!priv->dnld_sent && priv->tx_pending_len > 0) {
 			int ret = priv->hw_host_to_card(priv, MVMS_DAT,
@@ -533,7 +527,6 @@ static int lbs_thread(void *data)
 
 	del_timer(&priv->command_timer);
 	del_timer(&priv->auto_deepsleep_timer);
-	wake_up_all(&priv->cmd_pending);
 
 	lbs_deb_leave(LBS_DEB_THREAD);
 	return 0;
@@ -739,7 +732,6 @@ static int lbs_init_adapter(struct lbs_private *priv)
 	INIT_LIST_HEAD(&priv->cmdpendingq);
 
 	spin_lock_init(&priv->driver_lock);
-	init_waitqueue_head(&priv->cmd_pending);
 
 	/* Allocate the command buffers */
 	if (lbs_allocate_cmd_buffer(priv)) {
-- 
1.7.1.1


