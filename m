Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:60041 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1ADXuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 18:50:06 -0500
Subject: [RFC PATCH 16/17] zd1211rw: add tx watchdog
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Date: Wed, 05 Jan 2011 01:50:01 +0200
Message-ID: <20110104235001.25309.43201.stgit@fate.lan>
In-Reply-To: <20110104234745.25309.72030.stgit@fate.lan>
References: <20110104234745.25309.72030.stgit@fate.lan>
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
 drivers/net/wireless/zd1211rw/zd_mac.c  |    6 +
 drivers/net/wireless/zd1211rw/zd_mac.h  |    4 +
 drivers/net/wireless/zd1211rw/zd_usb.c  |  157 +++++++++++++++++++++++++++++++
 drivers/net/wireless/zd1211rw/zd_usb.h  |    9 ++
 5 files changed, 173 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 8a286b8..bcc8ffc 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -1449,6 +1449,7 @@ int zd_chip_enable_rxtx(struct zd_chip *chip)
 	mutex_lock(&chip->mutex);
 	zd_usb_enable_tx(&chip->usb);
 	r = zd_usb_enable_rx(&chip->usb);
+	zd_tx_watchdog_enable(&chip->usb);
 	mutex_unlock(&chip->mutex);
 	return r;
 }
@@ -1456,6 +1457,7 @@ int zd_chip_enable_rxtx(struct zd_chip *chip)
 void zd_chip_disable_rxtx(struct zd_chip *chip)
 {
 	mutex_lock(&chip->mutex);
+	zd_tx_watchdog_disable(&chip->usb);
 	zd_usb_disable_rx(&chip->usb);
 	zd_usb_disable_tx(&chip->usb);
 	mutex_unlock(&chip->mutex);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 4c3e92a..1fc733c 100644
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
@@ -342,7 +342,7 @@ static void zd_op_stop(struct ieee80211_hw *hw)
 		dev_kfree_skb_any(skb);
 }
 
-static int zd_restore_settings(struct zd_mac *mac)
+int zd_restore_settings(struct zd_mac *mac)
 {
 	struct sk_buff *beacon;
 	struct zd_mc_hash multicast_hash;
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index 155d4b8..d769490 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -316,6 +316,10 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length);
 void zd_mac_tx_failed(struct urb *urb);
 void zd_mac_tx_to_dev(struct sk_buff *skb, int error);
 
+int zd_op_start(struct ieee80211_hw *hw);
+void zd_op_stop(struct ieee80211_hw *hw);
+int zd_restore_settings(struct zd_mac *mac);
+
 #ifdef DEBUG
 void zd_dump_rx_status(const struct rx_status *status);
 #else
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index b709a9d..1ed7e12 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -605,6 +605,7 @@ static void rx_urb_complete(struct urb *urb)
 	struct zd_usb_rx *rx;
 	const u8 *buffer;
 	unsigned int length;
+	int r;
 
 	switch (urb->status) {
 	case 0:
@@ -654,7 +655,9 @@ static void rx_urb_complete(struct urb *urb)
 	}
 
 resubmit:
-	usb_submit_urb(urb, GFP_ATOMIC);
+	r = usb_submit_urb(urb, GFP_ATOMIC);
+	if (r)
+		dev_dbg_f(urb_dev(urb), "urb %p resubmit error %d\n", urb, r);
 }
 
 static struct urb *alloc_rx_urb(struct zd_usb *usb)
@@ -950,6 +953,7 @@ int zd_usb_tx(struct zd_usb *usb, struct sk_buff *skb)
 		          skb->data, skb->len, tx_urb_complete, skb);
 
 	info->rate_driver_data[1] = urb;
+	info->rate_driver_data[2] = (void *)jiffies;
 	skb_queue_tail(&tx->submitted_queue, skb);
 
 	r = usb_submit_urb(urb, GFP_ATOMIC);
@@ -965,6 +969,75 @@ out:
 	return r;
 }
 
+static bool zd_tx_timeout(struct zd_usb *usb)
+{
+	struct zd_usb_tx *tx = &usb->tx;
+	struct sk_buff_head *q = &tx->submitted_queue;
+	struct sk_buff *skb, *skbnext;
+	struct ieee80211_tx_info *info;
+	unsigned long trans_start;
+	bool have_timedout = false;
+
+	spin_lock_irq(&tx->lock);
+	spin_lock(&q->lock);
+	skb_queue_walk_safe(q, skb, skbnext) {
+		info = IEEE80211_SKB_CB(skb);
+		trans_start = (unsigned long)info->rate_driver_data[2];
+
+		if (time_is_before_jiffies(trans_start + ZD_TX_TIMEOUT)) {
+			have_timedout = true;
+			break;
+		}
+	}
+	spin_unlock(&q->lock);
+	spin_unlock_irq(&tx->lock);
+
+	return have_timedout;
+}
+
+static void tx_watchdog_handler(struct work_struct *work)
+{
+	struct zd_usb *usb =
+		container_of(work, struct zd_usb, tx_watchdog_work.work);
+	struct zd_usb_tx *tx = &usb->tx;
+
+	if (!usb->watchdog_enabled || !tx->enabled)
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
+	queue_delayed_work(zd_workqueue, &usb->tx_watchdog_work,
+			   ZD_TX_WATCHDOG_INTERVAL);
+}
+
+void zd_tx_watchdog_enable(struct zd_usb *usb)
+{
+	if (!usb->watchdog_enabled) {
+		dev_dbg_f(zd_usb_dev(usb), "\n");
+		queue_delayed_work(zd_workqueue, &usb->tx_watchdog_work,
+				   ZD_TX_WATCHDOG_INTERVAL);
+		usb->watchdog_enabled = 1;
+	}
+}
+
+void zd_tx_watchdog_disable(struct zd_usb *usb)
+{
+	if (usb->watchdog_enabled) {
+		dev_dbg_f(zd_usb_dev(usb), "\n");
+		usb->watchdog_enabled = 0;
+		cancel_rearming_delayed_workqueue(zd_workqueue,
+						  &usb->tx_watchdog_work);
+	}
+}
+
 static inline void init_usb_interrupt(struct zd_usb *usb)
 {
 	struct zd_usb_interrupt *intr = &usb->intr;
@@ -1006,6 +1079,7 @@ void zd_usb_init(struct zd_usb *usb, struct ieee80211_hw *hw,
 	init_usb_interrupt(usb);
 	init_usb_tx(usb);
 	init_usb_rx(usb);
+	INIT_DELAYED_WORK(&usb->tx_watchdog_work, tx_watchdog_handler);
 }
 
 void zd_usb_clear(struct zd_usb *usb)
@@ -1242,11 +1316,92 @@ static void disconnect(struct usb_interface *intf)
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
index b71baa0..31ca686 100644
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
@@ -206,7 +209,8 @@ struct zd_usb {
 	struct zd_usb_rx rx;
 	struct zd_usb_tx tx;
 	struct usb_interface *intf;
-	u8 is_zd1211b:1, initialized:1;
+	struct delayed_work tx_watchdog_work;
+	u8 is_zd1211b:1, initialized:1, watchdog_enabled:1, was_running:1;
 };
 
 #define zd_usb_dev(usb) (&usb->intf->dev)
@@ -233,6 +237,9 @@ void zd_usb_clear(struct zd_usb *usb);
 
 int zd_usb_scnprint_id(struct zd_usb *usb, char *buffer, size_t size);
 
+void zd_tx_watchdog_enable(struct zd_usb *usb);
+void zd_tx_watchdog_disable(struct zd_usb *usb);
+
 int zd_usb_enable_int(struct zd_usb *usb);
 void zd_usb_disable_int(struct zd_usb *usb);
 

