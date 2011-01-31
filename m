Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:48939 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab1AaSt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:49:58 -0500
Subject: [PATCH 18/22] zd1211rw: add TX watchdog and device resetting
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:49:52 +0200
Message-ID: <20110131184952.10044.47065.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When doing transfers at high speed for long time, tx queue can freeze. So add
tx watchdog. TX-watchdog checks for locked tx-urbs and reset hardware when
such is detected. Merely unlinking urb was not enough, device have to be
reseted. Hw settings are restored so that any open link will stay on after
reset.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |    2 
 drivers/net/wireless/zd1211rw/zd_mac.c  |    8 +-
 drivers/net/wireless/zd1211rw/zd_mac.h  |    2 
 drivers/net/wireless/zd1211rw/zd_usb.c  |  161 +++++++++++++++++++++++++++++++
 drivers/net/wireless/zd1211rw/zd_usb.h  |   12 ++
 5 files changed, 181 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 907e656..54f68f1 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -1448,6 +1448,7 @@ int zd_chip_enable_rxtx(struct zd_chip *chip)
 	mutex_lock(&chip->mutex);
 	zd_usb_enable_tx(&chip->usb);
 	r = zd_usb_enable_rx(&chip->usb);
+	zd_tx_watchdog_enable(&chip->usb);
 	mutex_unlock(&chip->mutex);
 	return r;
 }
@@ -1455,6 +1456,7 @@ int zd_chip_enable_rxtx(struct zd_chip *chip)
 void zd_chip_disable_rxtx(struct zd_chip *chip)
 {
 	mutex_lock(&chip->mutex);
+	zd_tx_watchdog_disable(&chip->usb);
 	zd_usb_disable_rx(&chip->usb);
 	zd_usb_disable_tx(&chip->usb);
 	mutex_unlock(&chip->mutex);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index e82f007..a590a94 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -264,7 +264,7 @@ static int set_mc_hash(struct zd_mac *mac)
 	return zd_chip_set_multicast_hash(&mac->chip, &hash);
 }
 
-static int zd_op_start(struct ieee80211_hw *hw)
+int zd_op_start(struct ieee80211_hw *hw)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
@@ -314,7 +314,7 @@ out:
 	return r;
 }
 
-static void zd_op_stop(struct ieee80211_hw *hw)
+void zd_op_stop(struct ieee80211_hw *hw)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
@@ -1409,6 +1409,9 @@ static void link_led_handler(struct work_struct *work)
 	int is_associated;
 	int r;
 
+	if (!test_bit(ZD_DEVICE_RUNNING, &mac->flags))
+		goto requeue;
+
 	spin_lock_irq(&mac->lock);
 	is_associated = mac->associated;
 	spin_unlock_irq(&mac->lock);
@@ -1418,6 +1421,7 @@ static void link_led_handler(struct work_struct *work)
 	if (r)
 		dev_dbg_f(zd_mac_dev(mac), "zd_chip_control_leds error %d\n", r);
 
+requeue:
 	queue_delayed_work(zd_workqueue, &mac->housekeeping.link_led_work,
 		           LINK_LED_WORK_DELAY);
 }
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index c0f239e..f8c93c3 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -314,6 +314,8 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length);
 void zd_mac_tx_failed(struct urb *urb);
 void zd_mac_tx_to_dev(struct sk_buff *skb, int error);
 
+int zd_op_start(struct ieee80211_hw *hw);
+void zd_op_stop(struct ieee80211_hw *hw);
 int zd_restore_settings(struct zd_mac *mac);
 
 #ifdef DEBUG
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 442c636..00c333f 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -798,6 +798,7 @@ void zd_usb_disable_tx(struct zd_usb *usb)
 	usb_kill_anchored_urbs(&tx->submitted);
 
 	spin_lock_irqsave(&tx->lock, flags);
+	WARN_ON(!skb_queue_empty(&tx->submitted_skbs));
 	WARN_ON(tx->submitted_urbs != 0);
 	tx->submitted_urbs = 0;
 	spin_unlock_irqrestore(&tx->lock, flags);
@@ -895,6 +896,7 @@ static void tx_urb_complete(struct urb *urb)
 		goto resubmit;
 	}
 free_urb:
+	skb_unlink(skb, &usb->tx.submitted_skbs);
 	zd_mac_tx_to_dev(skb, urb->status);
 	usb_free_urb(urb);
 	tx_dec_submitted_urbs(usb);
@@ -924,6 +926,7 @@ resubmit:
 int zd_usb_tx(struct zd_usb *usb, struct sk_buff *skb)
 {
 	int r;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct usb_device *udev = zd_usb_to_usbdev(usb);
 	struct urb *urb;
 	struct zd_usb_tx *tx = &usb->tx;
@@ -942,10 +945,14 @@ int zd_usb_tx(struct zd_usb *usb, struct sk_buff *skb)
 	usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_DATA_OUT),
 		          skb->data, skb->len, tx_urb_complete, skb);
 
+	info->rate_driver_data[1] = (void *)jiffies;
+	skb_queue_tail(&tx->submitted_skbs, skb);
 	usb_anchor_urb(urb, &tx->submitted);
+
 	r = usb_submit_urb(urb, GFP_ATOMIC);
 	if (r) {
 		usb_unanchor_urb(urb);
+		skb_unlink(skb, &tx->submitted_skbs);
 		goto error;
 	}
 	tx_inc_submitted_urbs(usb);
@@ -956,6 +963,76 @@ out:
 	return r;
 }
 
+static bool zd_tx_timeout(struct zd_usb *usb)
+{
+	struct zd_usb_tx *tx = &usb->tx;
+	struct sk_buff_head *q = &tx->submitted_skbs;
+	struct sk_buff *skb, *skbnext;
+	struct ieee80211_tx_info *info;
+	unsigned long flags, trans_start;
+	bool have_timedout = false;
+
+	spin_lock_irqsave(&q->lock, flags);
+	skb_queue_walk_safe(q, skb, skbnext) {
+		info = IEEE80211_SKB_CB(skb);
+		trans_start = (unsigned long)info->rate_driver_data[1];
+
+		if (time_is_before_jiffies(trans_start + ZD_TX_TIMEOUT)) {
+			have_timedout = true;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return have_timedout;
+}
+
+static void zd_tx_watchdog_handler(struct work_struct *work)
+{
+	struct zd_usb *usb =
+		container_of(work, struct zd_usb, tx.watchdog_work.work);
+	struct zd_usb_tx *tx = &usb->tx;
+
+	if (!atomic_read(&tx->enabled) || !tx->watchdog_enabled)
+		goto out;
+	if (!zd_tx_timeout(usb))
+		goto out;
+
+	/* TX halted, try reset */
+	dev_warn(zd_usb_dev(usb), "TX-stall detected, reseting device...");
+
+	usb_queue_reset_device(usb->intf);
+
+	/* reset will stop this worker, don't rearm */
+	return;
+out:
+	queue_delayed_work(zd_workqueue, &tx->watchdog_work,
+			   ZD_TX_WATCHDOG_INTERVAL);
+}
+
+void zd_tx_watchdog_enable(struct zd_usb *usb)
+{
+	struct zd_usb_tx *tx = &usb->tx;
+
+	if (!tx->watchdog_enabled) {
+		dev_dbg_f(zd_usb_dev(usb), "\n");
+		queue_delayed_work(zd_workqueue, &tx->watchdog_work,
+				   ZD_TX_WATCHDOG_INTERVAL);
+		tx->watchdog_enabled = 1;
+	}
+}
+
+void zd_tx_watchdog_disable(struct zd_usb *usb)
+{
+	struct zd_usb_tx *tx = &usb->tx;
+
+	if (tx->watchdog_enabled) {
+		dev_dbg_f(zd_usb_dev(usb), "\n");
+		tx->watchdog_enabled = 0;
+		cancel_delayed_work_sync(&tx->watchdog_work);
+	}
+}
+
 static inline void init_usb_interrupt(struct zd_usb *usb)
 {
 	struct zd_usb_interrupt *intr = &usb->intr;
@@ -984,8 +1061,11 @@ static inline void init_usb_tx(struct zd_usb *usb)
 	spin_lock_init(&tx->lock);
 	atomic_set(&tx->enabled, 0);
 	tx->stopped = 0;
+	skb_queue_head_init(&tx->submitted_skbs);
 	init_usb_anchor(&tx->submitted);
 	tx->submitted_urbs = 0;
+	tx->watchdog_enabled = 0;
+	INIT_DELAYED_WORK(&tx->watchdog_work, zd_tx_watchdog_handler);
 }
 
 void zd_usb_init(struct zd_usb *usb, struct ieee80211_hw *hw,
@@ -1233,11 +1313,92 @@ static void disconnect(struct usb_interface *intf)
 	dev_dbg(&intf->dev, "disconnected\n");
 }
 
+static void zd_usb_resume(struct zd_usb *usb)
+{
+	struct zd_mac *mac = zd_usb_to_mac(usb);
+	int r;
+
+	dev_dbg_f(zd_usb_dev(usb), "\n");
+
+	r = zd_op_start(zd_usb_to_hw(usb));
+	if (r < 0) {
+		dev_warn(zd_usb_dev(usb), "Device resume failed "
+			 "with error code %d. Retrying...\n", r);
+		if (usb->was_running)
+			set_bit(ZD_DEVICE_RUNNING, &mac->flags);
+		usb_queue_reset_device(usb->intf);
+		return;
+	}
+
+	if (mac->type != NL80211_IFTYPE_UNSPECIFIED) {
+		r = zd_restore_settings(mac);
+		if (r < 0) {
+			dev_dbg(zd_usb_dev(usb),
+				"failed to restore settings, %d\n", r);
+			return;
+		}
+	}
+}
+
+static void zd_usb_stop(struct zd_usb *usb)
+{
+	dev_dbg_f(zd_usb_dev(usb), "\n");
+
+	zd_op_stop(zd_usb_to_hw(usb));
+
+	zd_usb_disable_tx(usb);
+	zd_usb_disable_rx(usb);
+	zd_usb_disable_int(usb);
+
+	usb->initialized = 0;
+}
+
+static int pre_reset(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = usb_get_intfdata(intf);
+	struct zd_mac *mac;
+	struct zd_usb *usb;
+
+	if (!hw || intf->condition != USB_INTERFACE_BOUND)
+		return 0;
+
+	mac = zd_hw_mac(hw);
+	usb = &mac->chip.usb;
+
+	usb->was_running = test_bit(ZD_DEVICE_RUNNING, &mac->flags);
+
+	zd_usb_stop(usb);
+
+	mutex_lock(&mac->chip.mutex);
+	return 0;
+}
+
+static int post_reset(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = usb_get_intfdata(intf);
+	struct zd_mac *mac;
+	struct zd_usb *usb;
+
+	if (!hw || intf->condition != USB_INTERFACE_BOUND)
+		return 0;
+
+	mac = zd_hw_mac(hw);
+	usb = &mac->chip.usb;
+
+	mutex_unlock(&mac->chip.mutex);
+
+	if (usb->was_running)
+		zd_usb_resume(usb);
+	return 0;
+}
+
 static struct usb_driver driver = {
 	.name		= KBUILD_MODNAME,
 	.id_table	= usb_ids,
 	.probe		= probe,
 	.disconnect	= disconnect,
+	.pre_reset	= pre_reset,
+	.post_reset	= post_reset,
 };
 
 struct workqueue_struct *zd_workqueue;
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 24db0dd..98f09c2 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -32,6 +32,9 @@
 #define ZD_USB_TX_HIGH  5
 #define ZD_USB_TX_LOW   2
 
+#define ZD_TX_TIMEOUT		(HZ * 5)
+#define ZD_TX_WATCHDOG_INTERVAL	round_jiffies_relative(HZ)
+
 enum devicetype {
 	DEVICE_ZD1211  = 0,
 	DEVICE_ZD1211B = 1,
@@ -196,9 +199,11 @@ struct zd_usb_rx {
 struct zd_usb_tx {
 	atomic_t enabled;
 	spinlock_t lock;
+	struct delayed_work watchdog_work;
+	struct sk_buff_head submitted_skbs;
 	struct usb_anchor submitted;
 	int submitted_urbs;
-	int stopped;
+	u8 stopped:1, watchdog_enabled:1;
 };
 
 /* Contains the usb parts. The structure doesn't require a lock because intf
@@ -210,7 +215,7 @@ struct zd_usb {
 	struct zd_usb_tx tx;
 	struct usb_interface *intf;
 	u8 req_buf[64]; /* zd_usb_iowrite16v needs 62 bytes */
-	u8 is_zd1211b:1, initialized:1;
+	u8 is_zd1211b:1, initialized:1, was_running:1;
 };
 
 #define zd_usb_dev(usb) (&usb->intf->dev)
@@ -237,6 +242,9 @@ void zd_usb_clear(struct zd_usb *usb);
 
 int zd_usb_scnprint_id(struct zd_usb *usb, char *buffer, size_t size);
 
+void zd_tx_watchdog_enable(struct zd_usb *usb);
+void zd_tx_watchdog_disable(struct zd_usb *usb);
+
 int zd_usb_enable_int(struct zd_usb *usb);
 void zd_usb_disable_int(struct zd_usb *usb);
 

