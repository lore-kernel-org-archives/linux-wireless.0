Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:31758 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783Ab1IUPzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 11:55:50 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: detect TX lockups and reset hardware
Message-Id: <20110921153017.8FDAE9D401D@zog.reactivated.net> (sfid-20110921_175553_548819_FE0CA963)
Date: Wed, 21 Sep 2011 16:30:17 +0100 (BST)
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

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index adb3490..7487b5e 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -146,6 +146,7 @@ struct lbs_private {
 	/* protected by hard_start_xmit serialization */
 	u8 txretrycount;
 	struct sk_buff *currenttxskb;
+	struct timer_list tx_lockup_timer;
 
 	/* Locks */
 	struct mutex lock;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 94652c5..5aabe8f 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -163,6 +163,7 @@ void lbs_host_to_card_done(struct lbs_private *priv)
 	lbs_deb_enter(LBS_DEB_THREAD);
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
+	del_timer(&priv->tx_lockup_timer);
 
 	priv->dnld_sent = DNLD_RES_RECEIVED;
 
@@ -504,6 +505,9 @@ static int lbs_thread(void *data)
 			if (ret) {
 				lbs_deb_tx("host_to_card failed %d\n", ret);
 				priv->dnld_sent = DNLD_RES_RECEIVED;
+			} else {
+				mod_timer(&priv->tx_lockup_timer,
+					  jiffies + (HZ * 5));
 			}
 			priv->tx_pending_len = 0;
 			if (!priv->currenttxskb) {
@@ -520,6 +524,7 @@ static int lbs_thread(void *data)
 	}
 
 	del_timer(&priv->command_timer);
+	del_timer(&priv->tx_lockup_timer);
 	del_timer(&priv->auto_deepsleep_timer);
 
 	lbs_deb_leave(LBS_DEB_THREAD);
@@ -654,6 +659,32 @@ out:
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
@@ -739,6 +770,8 @@ static int lbs_init_adapter(struct lbs_private *priv)
 
 	setup_timer(&priv->command_timer, lbs_cmd_timeout_handler,
 		(unsigned long)priv);
+	setup_timer(&priv->tx_lockup_timer, lbs_tx_lockup_handler,
+		(unsigned long)priv);
 	setup_timer(&priv->auto_deepsleep_timer, auto_deepsleep_timer_fn,
 			(unsigned long)priv);
 
@@ -776,6 +809,7 @@ static void lbs_free_adapter(struct lbs_private *priv)
 	lbs_free_cmd_buffer(priv);
 	kfifo_free(&priv->event_fifo);
 	del_timer(&priv->command_timer);
+	del_timer(&priv->tx_lockup_timer);
 	del_timer(&priv->auto_deepsleep_timer);
 
 	lbs_deb_leave(LBS_DEB_MAIN);
@@ -995,6 +1029,7 @@ void lbs_stop_card(struct lbs_private *priv)
 
 	/* Delete the timeout of the currently processing command */
 	del_timer_sync(&priv->command_timer);
+	del_timer_sync(&priv->tx_lockup_timer);
 	del_timer_sync(&priv->auto_deepsleep_timer);
 
 	/* Flush pending command nodes */
-- 
1.7.6.2

