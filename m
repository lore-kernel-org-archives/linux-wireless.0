Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:41053 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757919Ab1DAQeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 12:34:20 -0400
Subject: [2.6.39 PATCH 2/2] zd1211rw: reset rx idle timer from tasklet
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 01 Apr 2011 19:34:16 +0300
Message-ID: <20110401163415.24880.68921.stgit@localhost6.localdomain6>
In-Reply-To: <20110401163408.24880.70537.stgit@localhost6.localdomain6>
References: <20110401163408.24880.70537.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2.6.38 added WARN_ON(in_irq) in del_timer_sync that triggers on zd1211rw when
reseting rx idle timer in urb completion handler.

Move timer reseting to tasklet.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |   14 +++++++++++++-
 drivers/net/wireless/zd1211rw/zd_usb.h |    1 +
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 9b1a26a..ab607bb 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -643,7 +643,7 @@ static void rx_urb_complete(struct urb *urb)
 	usb = urb->context;
 	rx = &usb->rx;
 
-	zd_usb_reset_rx_idle_timer(usb);
+	tasklet_schedule(&rx->reset_timer_tasklet);
 
 	if (length%rx->usb_packet_size > rx->usb_packet_size-4) {
 		/* If there is an old first fragment, we don't care. */
@@ -812,6 +812,7 @@ void zd_usb_disable_rx(struct zd_usb *usb)
 	__zd_usb_disable_rx(usb);
 	mutex_unlock(&rx->setup_mutex);
 
+	tasklet_kill(&rx->reset_timer_tasklet);
 	cancel_delayed_work_sync(&rx->idle_work);
 }
 
@@ -1106,6 +1107,13 @@ static void zd_rx_idle_timer_handler(struct work_struct *work)
 	zd_usb_reset_rx(usb);
 }
 
+static void zd_usb_reset_rx_idle_timer_tasklet(unsigned long param)
+{
+	struct zd_usb *usb = (struct zd_usb *)param;
+
+	zd_usb_reset_rx_idle_timer(usb);
+}
+
 void zd_usb_reset_rx_idle_timer(struct zd_usb *usb)
 {
 	struct zd_usb_rx *rx = &usb->rx;
@@ -1127,6 +1135,7 @@ static inline void init_usb_interrupt(struct zd_usb *usb)
 static inline void init_usb_rx(struct zd_usb *usb)
 {
 	struct zd_usb_rx *rx = &usb->rx;
+
 	spin_lock_init(&rx->lock);
 	mutex_init(&rx->setup_mutex);
 	if (interface_to_usbdev(usb->intf)->speed == USB_SPEED_HIGH) {
@@ -1136,11 +1145,14 @@ static inline void init_usb_rx(struct zd_usb *usb)
 	}
 	ZD_ASSERT(rx->fragment_length == 0);
 	INIT_DELAYED_WORK(&rx->idle_work, zd_rx_idle_timer_handler);
+	rx->reset_timer_tasklet.func = zd_usb_reset_rx_idle_timer_tasklet;
+	rx->reset_timer_tasklet.data = (unsigned long)usb;
 }
 
 static inline void init_usb_tx(struct zd_usb *usb)
 {
 	struct zd_usb_tx *tx = &usb->tx;
+
 	spin_lock_init(&tx->lock);
 	atomic_set(&tx->enabled, 0);
 	tx->stopped = 0;
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index b3df2c8..325d0f9 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -183,6 +183,7 @@ struct zd_usb_rx {
 	spinlock_t lock;
 	struct mutex setup_mutex;
 	struct delayed_work idle_work;
+	struct tasklet_struct reset_timer_tasklet;
 	u8 fragment[2 * USB_MAX_RX_SIZE];
 	unsigned int fragment_length;
 	unsigned int usb_packet_size;

