Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:38966 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1AaSrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:47:14 -0500
Subject: [PATCH 01/22] zd1211rw: use urb anchors for tx and fix tx-queue
	disabling
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:47:08 +0200
Message-ID: <20110131184708.10044.23351.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
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

Patch makes tx-urb handling saner with use of urb anchors.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |  108 +++++++++++---------------------
 drivers/net/wireless/zd1211rw/zd_usb.h |    8 +-
 2 files changed, 41 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 06041cb..c32a247 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -779,19 +779,20 @@ void zd_usb_disable_tx(struct zd_usb *usb)
 {
 	struct zd_usb_tx *tx = &usb->tx;
 	unsigned long flags;
-	struct list_head *pos, *n;
+
+	atomic_set(&tx->enabled, 0);
+
+	/* kill all submitted tx-urbs */
+	usb_kill_anchored_urbs(&tx->submitted);
 
 	spin_lock_irqsave(&tx->lock, flags);
-	list_for_each_safe(pos, n, &tx->free_urb_list) {
-		list_del(pos);
-		usb_free_urb(list_entry(pos, struct urb, urb_list));
-	}
-	tx->enabled = 0;
+	WARN_ON(tx->submitted_urbs != 0);
 	tx->submitted_urbs = 0;
+	spin_unlock_irqrestore(&tx->lock, flags);
+
 	/* The stopped state is ignored, relying on ieee80211_wake_queues()
 	 * in a potentionally following zd_usb_enable_tx().
 	 */
-	spin_unlock_irqrestore(&tx->lock, flags);
 }
 
 /**
@@ -807,63 +808,13 @@ void zd_usb_enable_tx(struct zd_usb *usb)
 	struct zd_usb_tx *tx = &usb->tx;
 
 	spin_lock_irqsave(&tx->lock, flags);
-	tx->enabled = 1;
+	atomic_set(&tx->enabled, 1);
 	tx->submitted_urbs = 0;
 	ieee80211_wake_queues(zd_usb_to_hw(usb));
 	tx->stopped = 0;
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
@@ -905,6 +856,16 @@ static void tx_urb_complete(struct urb *urb)
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *info;
 	struct zd_usb *usb;
+	struct zd_usb_tx *tx;
+
+	skb = (struct sk_buff *)urb->context;
+	info = IEEE80211_SKB_CB(skb);
+	/*
+	 * grab 'usb' pointer before handing off the skb (since
+	 * it might be freed by zd_mac_tx_to_dev or mac80211)
+	 */
+	usb = &zd_hw_mac(info->rate_driver_data[0])->chip.usb;
+	tx = &usb->tx;
 
 	switch (urb->status) {
 	case 0:
@@ -922,20 +883,15 @@ static void tx_urb_complete(struct urb *urb)
 		goto resubmit;
 	}
 free_urb:
-	skb = (struct sk_buff *)urb->context;
-	/*
-	 * grab 'usb' pointer before handing off the skb (since
-	 * it might be freed by zd_mac_tx_to_dev or mac80211)
-	 */
-	info = IEEE80211_SKB_CB(skb);
-	usb = &zd_hw_mac(info->rate_driver_data[0])->chip.usb;
 	zd_mac_tx_to_dev(skb, urb->status);
-	free_tx_urb(usb, urb);
+	usb_free_urb(urb);
 	tx_dec_submitted_urbs(usb);
 	return;
 resubmit:
+	usb_anchor_urb(urb, &tx->submitted);
 	r = usb_submit_urb(urb, GFP_ATOMIC);
 	if (r) {
+		usb_unanchor_urb(urb);
 		dev_dbg_f(urb_dev(urb), "error resubmit urb %p %d\n", urb, r);
 		goto free_urb;
 	}
@@ -958,8 +914,14 @@ int zd_usb_tx(struct zd_usb *usb, struct sk_buff *skb)
 	int r;
 	struct usb_device *udev = zd_usb_to_usbdev(usb);
 	struct urb *urb;
+	struct zd_usb_tx *tx = &usb->tx;
 
-	urb = alloc_tx_urb(usb);
+	if (!atomic_read(&tx->enabled)) {
+		r = -ENOENT;
+		goto out;
+	}
+
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
 		r = -ENOMEM;
 		goto out;
@@ -968,13 +930,16 @@ int zd_usb_tx(struct zd_usb *usb, struct sk_buff *skb)
 	usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_DATA_OUT),
 		          skb->data, skb->len, tx_urb_complete, skb);
 
+	usb_anchor_urb(urb, &tx->submitted);
 	r = usb_submit_urb(urb, GFP_ATOMIC);
-	if (r)
+	if (r) {
+		usb_unanchor_urb(urb);
 		goto error;
+	}
 	tx_inc_submitted_urbs(usb);
 	return 0;
 error:
-	free_tx_urb(usb, urb);
+	usb_free_urb(urb);
 out:
 	return r;
 }
@@ -1005,9 +970,9 @@ static inline void init_usb_tx(struct zd_usb *usb)
 {
 	struct zd_usb_tx *tx = &usb->tx;
 	spin_lock_init(&tx->lock);
-	tx->enabled = 0;
+	atomic_set(&tx->enabled, 0);
 	tx->stopped = 0;
-	INIT_LIST_HEAD(&tx->free_urb_list);
+	init_usb_anchor(&tx->submitted);
 	tx->submitted_urbs = 0;
 }
 
@@ -1240,6 +1205,7 @@ static void disconnect(struct usb_interface *intf)
 	ieee80211_unregister_hw(hw);
 
 	/* Just in case something has gone wrong! */
+	zd_usb_disable_tx(usb);
 	zd_usb_disable_rx(usb);
 	zd_usb_disable_int(usb);
 
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 1b1655c..233ce82 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -184,18 +184,18 @@ struct zd_usb_rx {
 
 /**
  * struct zd_usb_tx - structure used for transmitting frames
+ * @enabled: atomic enabled flag, indicates whether tx is enabled
  * @lock: lock for transmission
- * @free_urb_list: list of free URBs, contains all the URBs, which can be used
+ * @submitted: anchor for URBs sent to device
  * @submitted_urbs: atomic integer that counts the URBs having sent to the
  *	device, which haven't been completed
- * @enabled: enabled flag, indicates whether tx is enabled
  * @stopped: indicates whether higher level tx queues are stopped
  */
 struct zd_usb_tx {
+	atomic_t enabled;
 	spinlock_t lock;
-	struct list_head free_urb_list;
+	struct usb_anchor submitted;
 	int submitted_urbs;
-	int enabled;
 	int stopped;
 };
 

