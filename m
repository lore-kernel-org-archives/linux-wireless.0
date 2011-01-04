Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:40158 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1ADXr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 18:47:59 -0500
Subject: [RFC PATCH 01/17] zd1211rw: fix tx-queue disabling
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Date: Wed, 05 Jan 2011 01:47:54 +0200
Message-ID: <20110104234754.25309.54906.stgit@fate.lan>
In-Reply-To: <20110104234745.25309.72030.stgit@fate.lan>
References: <20110104234745.25309.72030.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When stress testing AP-mode I hit OOPS when unpluging or rmmodding
driver.

It appears that when tx-queue is disabled, tx-urbs might be left pending.
These can cause ehci to call non-existing tx_urb_complete() (after rmmod)
or uninitialized/reseted private structure (after disconnect()). Add skb
queue for submitted packets and unlink pending urbs on zd_usb_disable_tx().

Part of the problem seems to be usb->free_urb_list that isn't always
working as it should, causing machine freeze when trying to free the list
in zd_usb_disable_tx(). Caching free urbs isn't what other drivers seem
to be doing (usbnet for example) so strip free_usb_list.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |  113 ++++++++++++++------------------
 drivers/net/wireless/zd1211rw/zd_usb.h |    3 -
 2 files changed, 51 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 06041cb..ed5379b 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -778,15 +778,34 @@ void zd_usb_disable_rx(struct zd_usb *usb)
 void zd_usb_disable_tx(struct zd_usb *usb)
 {
 	struct zd_usb_tx *tx = &usb->tx;
+	struct sk_buff_head *q = &tx->submitted_queue;
+	struct sk_buff *skb, *skbnext;
 	unsigned long flags;
-	struct list_head *pos, *n;
+	int qlen;
 
 	spin_lock_irqsave(&tx->lock, flags);
-	list_for_each_safe(pos, n, &tx->free_urb_list) {
-		list_del(pos);
-		usb_free_urb(list_entry(pos, struct urb, urb_list));
-	}
 	tx->enabled = 0;
+	spin_unlock(&tx->lock);
+
+	/* unlink all submitted tx-urbs */
+	spin_lock(&q->lock);
+	skb_queue_walk_safe(q, skb, skbnext) {
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+		usb_unlink_urb(info->rate_driver_data[1]);
+	}
+	qlen = skb_queue_len(q);
+	spin_unlock(&q->lock);
+
+	/* wait until unlink has completed */
+	while (qlen > 0) {
+		msleep(20);
+
+		spin_lock(&q->lock);
+		qlen = skb_queue_len(q);
+		spin_unlock(&q->lock);
+	}
+
+	spin_lock(&tx->lock);
 	tx->submitted_urbs = 0;
 	/* The stopped state is ignored, relying on ieee80211_wake_queues()
 	 * in a potentionally following zd_usb_enable_tx().
@@ -814,56 +833,6 @@ void zd_usb_enable_tx(struct zd_usb *usb)
 	spin_unlock_irqrestore(&tx->lock, flags);
 }
 
-/**
- * alloc_tx_urb - provides an tx URB
- * @usb: a &struct zd_usb pointer
- *
- * Allocates a new URB. If possible takes the urb from the free list in
- * usb->tx.
- */
-static struct urb *alloc_tx_urb(struct zd_usb *usb)
-{
-	struct zd_usb_tx *tx = &usb->tx;
-	unsigned long flags;
-	struct list_head *entry;
-	struct urb *urb;
-
-	spin_lock_irqsave(&tx->lock, flags);
-	if (list_empty(&tx->free_urb_list)) {
-		urb = usb_alloc_urb(0, GFP_ATOMIC);
-		goto out;
-	}
-	entry = tx->free_urb_list.next;
-	list_del(entry);
-	urb = list_entry(entry, struct urb, urb_list);
-out:
-	spin_unlock_irqrestore(&tx->lock, flags);
-	return urb;
-}
-
-/**
- * free_tx_urb - frees a used tx URB
- * @usb: a &struct zd_usb pointer
- * @urb: URB to be freed
- *
- * Frees the transmission URB, which means to put it on the free URB
- * list.
- */
-static void free_tx_urb(struct zd_usb *usb, struct urb *urb)
-{
-	struct zd_usb_tx *tx = &usb->tx;
-	unsigned long flags;
-
-	spin_lock_irqsave(&tx->lock, flags);
-	if (!tx->enabled) {
-		usb_free_urb(urb);
-		goto out;
-	}
-	list_add(&urb->urb_list, &tx->free_urb_list);
-out:
-	spin_unlock_irqrestore(&tx->lock, flags);
-}
-
 static void tx_dec_submitted_urbs(struct zd_usb *usb)
 {
 	struct zd_usb_tx *tx = &usb->tx;
@@ -878,7 +847,7 @@ static void tx_dec_submitted_urbs(struct zd_usb *usb)
 	spin_unlock_irqrestore(&tx->lock, flags);
 }
 
-static void tx_inc_submitted_urbs(struct zd_usb *usb)
+static void tx_inc_submitted_urbs(struct zd_usb *usb, struct urb *urb)
 {
 	struct zd_usb_tx *tx = &usb->tx;
 	unsigned long flags;
@@ -929,8 +898,9 @@ free_urb:
 	 */
 	info = IEEE80211_SKB_CB(skb);
 	usb = &zd_hw_mac(info->rate_driver_data[0])->chip.usb;
+	skb_unlink(skb, &usb->tx.submitted_queue);
 	zd_mac_tx_to_dev(skb, urb->status);
-	free_tx_urb(usb, urb);
+	usb_free_urb(urb);
 	tx_dec_submitted_urbs(usb);
 	return;
 resubmit:
@@ -955,11 +925,22 @@ resubmit:
  */
 int zd_usb_tx(struct zd_usb *usb, struct sk_buff *skb)
 {
-	int r;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	int r, enabled;
 	struct usb_device *udev = zd_usb_to_usbdev(usb);
 	struct urb *urb;
+	struct zd_usb_tx *tx = &usb->tx;
+	unsigned long flags;
 
-	urb = alloc_tx_urb(usb);
+	spin_lock_irqsave(&tx->lock, flags);
+	enabled = tx->enabled;
+	spin_unlock_irqrestore(&tx->lock, flags);
+	if (!enabled) {
+		r = -ENOENT;
+		goto out;
+	}
+
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
 		r = -ENOMEM;
 		goto out;
@@ -968,13 +949,18 @@ int zd_usb_tx(struct zd_usb *usb, struct sk_buff *skb)
 	usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_DATA_OUT),
 		          skb->data, skb->len, tx_urb_complete, skb);
 
+	info->rate_driver_data[1] = urb;
+	skb_queue_tail(&tx->submitted_queue, skb);
+
 	r = usb_submit_urb(urb, GFP_ATOMIC);
-	if (r)
+	if (r) {
+		skb_unlink(skb, &tx->submitted_queue);
 		goto error;
-	tx_inc_submitted_urbs(usb);
+	}
+	tx_inc_submitted_urbs(usb, urb);
 	return 0;
 error:
-	free_tx_urb(usb, urb);
+	usb_free_urb(urb);
 out:
 	return r;
 }
@@ -1007,7 +993,7 @@ static inline void init_usb_tx(struct zd_usb *usb)
 	spin_lock_init(&tx->lock);
 	tx->enabled = 0;
 	tx->stopped = 0;
-	INIT_LIST_HEAD(&tx->free_urb_list);
+	skb_queue_head_init(&tx->submitted_queue);
 	tx->submitted_urbs = 0;
 }
 
@@ -1240,6 +1226,7 @@ static void disconnect(struct usb_interface *intf)
 	ieee80211_unregister_hw(hw);
 
 	/* Just in case something has gone wrong! */
+	zd_usb_disable_tx(usb);
 	zd_usb_disable_rx(usb);
 	zd_usb_disable_int(usb);
 
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 1b1655c..b71baa0 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -185,7 +185,6 @@ struct zd_usb_rx {
 /**
  * struct zd_usb_tx - structure used for transmitting frames
  * @lock: lock for transmission
- * @free_urb_list: list of free URBs, contains all the URBs, which can be used
  * @submitted_urbs: atomic integer that counts the URBs having sent to the
  *	device, which haven't been completed
  * @enabled: enabled flag, indicates whether tx is enabled
@@ -193,7 +192,7 @@ struct zd_usb_rx {
  */
 struct zd_usb_tx {
 	spinlock_t lock;
-	struct list_head free_urb_list;
+	struct sk_buff_head submitted_queue;
 	int submitted_urbs;
 	int enabled;
 	int stopped;

