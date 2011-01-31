Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:58512 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754943Ab1AaSuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:50:18 -0500
Subject: [PATCH 20/22] zd1211rw: reset rx urbs after idle period of 30 seconds
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:50:12 +0200
Message-ID: <20110131185012.10044.21341.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX appears to freeze while idle. Resetting rx-urbs appears to be enough to fix
this. Do reset 30 seconds after last rx.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |   79 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/zd1211rw/zd_usb.h |    7 ++-
 2 files changed, 83 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 00c333f..5cedfea 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -638,6 +638,8 @@ static void rx_urb_complete(struct urb *urb)
 	usb = urb->context;
 	rx = &usb->rx;
 
+	zd_usb_reset_rx_idle_timer(usb);
+
 	if (length%rx->usb_packet_size > rx->usb_packet_size-4) {
 		/* If there is an old first fragment, we don't care. */
 		dev_dbg_f(urb_dev(urb), "*** first fragment ***\n");
@@ -702,7 +704,7 @@ static void free_rx_urb(struct urb *urb)
 	usb_free_urb(urb);
 }
 
-int zd_usb_enable_rx(struct zd_usb *usb)
+static int __zd_usb_enable_rx(struct zd_usb *usb)
 {
 	int i, r;
 	struct zd_usb_rx *rx = &usb->rx;
@@ -754,7 +756,21 @@ error:
 	return r;
 }
 
-void zd_usb_disable_rx(struct zd_usb *usb)
+int zd_usb_enable_rx(struct zd_usb *usb)
+{
+	int r;
+	struct zd_usb_rx *rx = &usb->rx;
+
+	mutex_lock(&rx->setup_mutex);
+	r = __zd_usb_enable_rx(usb);
+	mutex_unlock(&rx->setup_mutex);
+
+	zd_usb_reset_rx_idle_timer(usb);
+
+	return r;
+}
+
+static void __zd_usb_disable_rx(struct zd_usb *usb)
 {
 	int i;
 	unsigned long flags;
@@ -781,6 +797,40 @@ void zd_usb_disable_rx(struct zd_usb *usb)
 	spin_unlock_irqrestore(&rx->lock, flags);
 }
 
+void zd_usb_disable_rx(struct zd_usb *usb)
+{
+	struct zd_usb_rx *rx = &usb->rx;
+
+	mutex_lock(&rx->setup_mutex);
+	__zd_usb_disable_rx(usb);
+	mutex_unlock(&rx->setup_mutex);
+
+	cancel_delayed_work_sync(&rx->idle_work);
+}
+
+static void zd_usb_reset_rx(struct zd_usb *usb)
+{
+	bool do_reset;
+	struct zd_usb_rx *rx = &usb->rx;
+	unsigned long flags;
+
+	mutex_lock(&rx->setup_mutex);
+
+	spin_lock_irqsave(&rx->lock, flags);
+	do_reset = rx->urbs != NULL;
+	spin_unlock_irqrestore(&rx->lock, flags);
+
+	if (do_reset) {
+		__zd_usb_disable_rx(usb);
+		__zd_usb_enable_rx(usb);
+	}
+
+	mutex_unlock(&rx->setup_mutex);
+
+	if (do_reset)
+		zd_usb_reset_rx_idle_timer(usb);
+}
+
 /**
  * zd_usb_disable_tx - disable transmission
  * @usb: the zd1211rw-private USB structure
@@ -1033,6 +1083,29 @@ void zd_tx_watchdog_disable(struct zd_usb *usb)
 	}
 }
 
+static void zd_rx_idle_timer_handler(struct work_struct *work)
+{
+	struct zd_usb *usb =
+		container_of(work, struct zd_usb, rx.idle_work.work);
+	struct zd_mac *mac = zd_usb_to_mac(usb);
+
+	if (!test_bit(ZD_DEVICE_RUNNING, &mac->flags))
+		return;
+
+	dev_dbg_f(zd_usb_dev(usb), "\n");
+
+	/* 30 seconds since last rx, reset rx */
+	zd_usb_reset_rx(usb);
+}
+
+void zd_usb_reset_rx_idle_timer(struct zd_usb *usb)
+{
+	struct zd_usb_rx *rx = &usb->rx;
+
+	cancel_delayed_work(&rx->idle_work);
+	queue_delayed_work(zd_workqueue, &rx->idle_work, ZD_RX_IDLE_INTERVAL);
+}
+
 static inline void init_usb_interrupt(struct zd_usb *usb)
 {
 	struct zd_usb_interrupt *intr = &usb->intr;
@@ -1047,12 +1120,14 @@ static inline void init_usb_rx(struct zd_usb *usb)
 {
 	struct zd_usb_rx *rx = &usb->rx;
 	spin_lock_init(&rx->lock);
+	mutex_init(&rx->setup_mutex);
 	if (interface_to_usbdev(usb->intf)->speed == USB_SPEED_HIGH) {
 		rx->usb_packet_size = 512;
 	} else {
 		rx->usb_packet_size = 64;
 	}
 	ZD_ASSERT(rx->fragment_length == 0);
+	INIT_DELAYED_WORK(&rx->idle_work, zd_rx_idle_timer_handler);
 }
 
 static inline void init_usb_tx(struct zd_usb *usb)
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 98f09c2..2d688f4 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -34,6 +34,7 @@
 
 #define ZD_TX_TIMEOUT		(HZ * 5)
 #define ZD_TX_WATCHDOG_INTERVAL	round_jiffies_relative(HZ)
+#define ZD_RX_IDLE_INTERVAL	round_jiffies_relative(30 * HZ)
 
 enum devicetype {
 	DEVICE_ZD1211  = 0,
@@ -180,7 +181,9 @@ static inline struct usb_int_regs *get_read_regs(struct zd_usb_interrupt *intr)
 
 struct zd_usb_rx {
 	spinlock_t lock;
-	u8 fragment[2*USB_MAX_RX_SIZE];
+	struct mutex setup_mutex;
+	struct delayed_work idle_work;
+	u8 fragment[2 * USB_MAX_RX_SIZE];
 	unsigned int fragment_length;
 	unsigned int usb_packet_size;
 	struct urb **urbs;
@@ -251,6 +254,8 @@ void zd_usb_disable_int(struct zd_usb *usb);
 int zd_usb_enable_rx(struct zd_usb *usb);
 void zd_usb_disable_rx(struct zd_usb *usb);
 
+void zd_usb_reset_rx_idle_timer(struct zd_usb *usb);
+
 void zd_usb_enable_tx(struct zd_usb *usb);
 void zd_usb_disable_tx(struct zd_usb *usb);
 

