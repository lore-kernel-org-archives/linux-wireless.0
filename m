Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:25028 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062Ab1JCLVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 07:21:33 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
Cc: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Subject: [PATCH v2] libertas: detect TX lockups and reset hardware
Message-Id: <20111003103302.644D79D401D@zog.reactivated.net> (sfid-20111003_132137_189331_44DE1CF0)
Date: Mon,  3 Oct 2011 11:33:02 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent patches added support for resetting the SD8686 hardware when
commands time out, which seems to happen quite frequently soon after
resuming the system from a Wake-on-WLAN-triggered resume.

At http://dev.laptop.org/ticket/10969 we see the same thing happen
with transmits. In this case, the hardware will fail to respond to
a frame passed for transmission, and libertas (correctly) will block
all further commands and transmissions as the hardware can only
deal with one thing at a time. This results in a lockup while the
system waits indefinitely for the dead card to respond.

Hook up a TX lockup timer to detect this and reset the hardware.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/dev.h  |    1 +
 drivers/net/wireless/libertas/main.c |   35 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

v2: regenerated against wireless-next.git. Compared to the first version,
minor changes were needed to the way the timer is stopped when the interface
is brought down (these routines changed as a result of other recent work).

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index fb3e40b..f3fd447 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -158,6 +158,7 @@ struct lbs_private {
 	/* protected by hard_start_xmit serialization */
 	u8 txretrycount;
 	struct sk_buff *currenttxskb;
+	struct timer_list tx_lockup_timer;
 
 	/* Locks */
 	struct mutex lock;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index d62d1fb..6a32623 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -188,6 +188,7 @@ int lbs_stop_iface(struct lbs_private *priv)
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	cancel_work_sync(&priv->mcast_work);
+	del_timer_sync(&priv->tx_lockup_timer);
 
 	/* Disable command processing, and wait for all commands to complete */
 	lbs_deb_main("waiting for commands to complete\n");
@@ -243,6 +244,7 @@ void lbs_host_to_card_done(struct lbs_private *priv)
 	lbs_deb_enter(LBS_DEB_THREAD);
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
+	del_timer(&priv->tx_lockup_timer);
 
 	priv->dnld_sent = DNLD_RES_RECEIVED;
 
@@ -585,6 +587,9 @@ static int lbs_thread(void *data)
 			if (ret) {
 				lbs_deb_tx("host_to_card failed %d\n", ret);
 				priv->dnld_sent = DNLD_RES_RECEIVED;
+			} else {
+				mod_timer(&priv->tx_lockup_timer,
+					  jiffies + (HZ * 5));
 			}
 			priv->tx_pending_len = 0;
 			if (!priv->currenttxskb) {
@@ -601,6 +606,7 @@ static int lbs_thread(void *data)
 	}
 
 	del_timer(&priv->command_timer);
+	del_timer(&priv->tx_lockup_timer);
 	del_timer(&priv->auto_deepsleep_timer);
 
 	lbs_deb_leave(LBS_DEB_THREAD);
@@ -735,6 +741,32 @@ out:
 }
 
 /**
+ * lbs_tx_lockup_handler - handles the timeout of the passing of TX frames
+ * to the hardware. This is known to frequently happen with SD8686 when
+ * waking up after a Wake-on-WLAN-triggered resume.
+ *
+ * @data: &struct lbs_private pointer
+ */
+static void lbs_tx_lockup_handler(unsigned long data)
+{
+	struct lbs_private *priv = (struct lbs_private *)data;
+	unsigned long flags;
+
+	lbs_deb_enter(LBS_DEB_TX);
+	spin_lock_irqsave(&priv->driver_lock, flags);
+
+	netdev_info(priv->dev, "TX lockup detected\n");
+	if (priv->reset_card)
+		priv->reset_card(priv);
+
+	priv->dnld_sent = DNLD_RES_RECEIVED;
+	wake_up_interruptible(&priv->waitq);
+
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
+	lbs_deb_leave(LBS_DEB_TX);
+}
+
+/**
  * auto_deepsleep_timer_fn - put the device back to deep sleep mode when
  * timer expires and no activity (command, event, data etc.) is detected.
  * @data:	&struct lbs_private pointer
@@ -820,6 +852,8 @@ static int lbs_init_adapter(struct lbs_private *priv)
 
 	setup_timer(&priv->command_timer, lbs_cmd_timeout_handler,
 		(unsigned long)priv);
+	setup_timer(&priv->tx_lockup_timer, lbs_tx_lockup_handler,
+		(unsigned long)priv);
 	setup_timer(&priv->auto_deepsleep_timer, auto_deepsleep_timer_fn,
 			(unsigned long)priv);
 
@@ -857,6 +891,7 @@ static void lbs_free_adapter(struct lbs_private *priv)
 	lbs_free_cmd_buffer(priv);
 	kfifo_free(&priv->event_fifo);
 	del_timer(&priv->command_timer);
+	del_timer(&priv->tx_lockup_timer);
 	del_timer(&priv->auto_deepsleep_timer);
 
 	lbs_deb_leave(LBS_DEB_MAIN);
-- 
1.7.6.4

