Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:44027 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZELXAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 19:00:24 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/6 v3] ar9170usb: introduce tx urb queue
Date: Wed, 13 May 2009 01:00:24 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
References: <200905121659.05977.chunkeey@web.de>
In-Reply-To: <200905121659.05977.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200905130100.24937.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is a back-port of some tx-aggregation code.

In the past, we didn't limit the amount of active tx_urb.
However, ar9170 only has a limited buffer reserved for
pending data frames.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
Changes
v3-> v2:
	- run diff against a clean tree... sorry!

 v2 -> v1:
	- removed leaky auto reset. It will be enabled again,
	  once the tx-aggregation code is ready for action. 
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index 77dc647..cd3d1ed 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -121,6 +121,8 @@ struct ar9170 {
 	int (*exec_cmd)(struct ar9170 *, enum ar9170_cmd, u32 ,
 			void *, u32 , void *);
 	void (*callback_cmd)(struct ar9170 *, u32 , void *);
+	void (*reset)(struct ar9170 *);
+	int (*flush)(struct ar9170 *);
 
 	/* interface mode settings */
 	struct ieee80211_vif *vif;
@@ -206,6 +208,7 @@ void ar9170_rx(struct ar9170 *ar, struct sk_buff *skb);
 void ar9170_unregister(struct ar9170 *ar);
 void ar9170_handle_tx_status(struct ar9170 *ar, struct sk_buff *skb,
 			     bool update_statistics, u16 tx_status);
+void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len);
 
 /* MAC */
 int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index df83883..a66aa7d 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -374,8 +374,8 @@ static void ar9170_tx_status_janitor(struct work_struct *work)
 	mutex_unlock(&ar->mutex);
 }
 
-static void ar9170_handle_command_response(struct ar9170 *ar,
-					   void *buf, u32 len)
+void ar9170_handle_command_response(struct ar9170 *ar,
+				    void *buf, u32 len)
 {
 	struct ar9170_cmd_response *cmd = (void *) buf;
 
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index d7c13c0..09e9f28 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -87,6 +87,37 @@ static struct usb_device_id ar9170_usb_ids[] = {
 };
 MODULE_DEVICE_TABLE(usb, ar9170_usb_ids);
 
+static void ar9170_usb_send_urb(struct ar9170_usb *aru)
+{
+	struct urb *urb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&aru->tx_urb_lock, flags);
+	if (aru->tx_submitted_urbs >= AR9170_NUM_TX_URBS) {
+		spin_unlock_irqrestore(&aru->tx_urb_lock, flags);
+		return ;
+	}
+	aru->tx_submitted_urbs++;
+	spin_unlock_irqrestore(&aru->tx_urb_lock, flags);
+
+	urb = usb_get_from_anchor(&aru->tx_pending);
+	if (!urb)
+		return ;
+
+	aru->tx_pending_urbs--;
+
+	usb_anchor_urb(urb, &aru->tx_submitted);
+
+	if (usb_submit_urb(urb, GFP_ATOMIC)) {
+		spin_lock_irqsave(&aru->tx_urb_lock, flags);
+		aru->tx_submitted_urbs--;
+		spin_unlock_irqrestore(&aru->tx_urb_lock, flags);
+		usb_unanchor_urb(urb);
+	}
+
+	usb_free_urb(urb);
+}
+
 static void ar9170_usb_tx_urb_complete_free(struct urb *urb)
 {
 	struct sk_buff *skb = urb->context;
@@ -98,10 +129,26 @@ static void ar9170_usb_tx_urb_complete_free(struct urb *urb)
 		return ;
 	}
 
+	aru->tx_submitted_urbs--;
+
+	if (!usb_anchor_empty(&aru->tx_pending))
+		ar9170_usb_send_urb(aru);
+
 	ar9170_handle_tx_status(&aru->common, skb, false,
 				AR9170_TX_STATUS_COMPLETE);
 }
 
+static void ar9170_usb_tx_urb_complete_cnt(struct urb *urb)
+{
+	struct ar9170_usb *aru = (struct ar9170_usb *)
+	      usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
+
+	aru->tx_submitted_urbs--;
+
+	if (!usb_anchor_empty(&aru->tx_pending))
+		ar9170_usb_send_urb(aru);
+}
+
 static void ar9170_usb_tx_urb_complete(struct urb *urb)
 {
 }
@@ -126,8 +173,9 @@ static void ar9170_usb_irq_completed(struct urb *urb)
 		goto resubmit;
 	}
 
-	print_hex_dump_bytes("ar9170 irq: ", DUMP_PREFIX_OFFSET,
-			     urb->transfer_buffer, urb->actual_length);
+	ar9170_handle_command_response(&aru->common,
+				       urb->transfer_buffer,
+				       urb->actual_length);
 
 resubmit:
 	usb_anchor_urb(urb, &aru->rx_submitted);
@@ -179,14 +227,13 @@ resubmit:
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err) {
 		usb_unanchor_urb(urb);
-		dev_kfree_skb_irq(skb);
+		goto free;
 	}
 
 	return ;
 
 free:
 	dev_kfree_skb_irq(skb);
-	return;
 }
 
 static int ar9170_usb_prep_rx_urb(struct ar9170_usb *aru,
@@ -282,21 +329,39 @@ err_out:
 	return err;
 }
 
-static void ar9170_usb_cancel_urbs(struct ar9170_usb *aru)
+static int ar9170_usb_flush(struct ar9170 *ar)
 {
-	int ret;
+	struct ar9170_usb *aru = (void *) ar;
+	int ret, err = 0;
 
-	aru->common.state = AR9170_UNKNOWN_STATE;
+	ret = usb_wait_anchor_empty_timeout(&aru->tx_pending,
+					    msecs_to_jiffies(500));
+	if (ret == 0)
+		err = -EBUSY;
 
-	usb_unlink_anchored_urbs(&aru->tx_submitted);
+	usb_scuttle_anchored_urbs(&aru->tx_pending);
 
-	/* give the LED OFF command and the deauth frame a chance to air. */
+	/* lets wait a while until the tx - queues are dried out */
 	ret = usb_wait_anchor_empty_timeout(&aru->tx_submitted,
 					    msecs_to_jiffies(100));
 	if (ret == 0)
-		dev_err(&aru->udev->dev, "kill pending tx urbs.\n");
-	usb_poison_anchored_urbs(&aru->tx_submitted);
+		err = -ETIMEDOUT;
+
+	usb_kill_anchored_urbs(&aru->tx_submitted);
+	return err;
+}
+
+static void ar9170_usb_cancel_urbs(struct ar9170_usb *aru)
+{
+	int err;
+
+	aru->common.state = AR9170_UNKNOWN_STATE;
 
+	err = ar9170_usb_flush(&aru->common);
+	if (err)
+		dev_err(&aru->udev->dev, "stuck tx urbs!\n");
+
+	usb_poison_anchored_urbs(&aru->tx_submitted);
 	usb_poison_anchored_urbs(&aru->rx_submitted);
 }
 
@@ -337,7 +402,7 @@ static int ar9170_usb_exec_cmd(struct ar9170 *ar, enum ar9170_cmd cmd,
 
 	usb_anchor_urb(urb, &aru->tx_submitted);
 	err = usb_submit_urb(urb, GFP_ATOMIC);
-	if (err) {
+	if (unlikely(err)) {
 		usb_unanchor_urb(urb);
 		usb_free_urb(urb);
 		goto err_unbuf;
@@ -385,7 +450,6 @@ static int ar9170_usb_tx(struct ar9170 *ar, struct sk_buff *skb,
 {
 	struct ar9170_usb *aru = (struct ar9170_usb *) ar;
 	struct urb *urb;
-	int err;
 
 	if (unlikely(!IS_STARTED(ar))) {
 		/* Seriously, what were you drink... err... thinking!? */
@@ -399,17 +463,18 @@ static int ar9170_usb_tx(struct ar9170 *ar, struct sk_buff *skb,
 	usb_fill_bulk_urb(urb, aru->udev,
 			  usb_sndbulkpipe(aru->udev, AR9170_EP_TX),
 			  skb->data, skb->len + extra_len, (txstatus_needed ?
-			  ar9170_usb_tx_urb_complete :
+			  ar9170_usb_tx_urb_complete_cnt :
 			  ar9170_usb_tx_urb_complete_free), skb);
 	urb->transfer_flags |= URB_ZERO_PACKET;
 
-	usb_anchor_urb(urb, &aru->tx_submitted);
-	err = usb_submit_urb(urb, GFP_ATOMIC);
-	if (unlikely(err))
-		usb_unanchor_urb(urb);
+	usb_anchor_urb(urb, &aru->tx_pending);
+	aru->tx_pending_urbs++;
 
 	usb_free_urb(urb);
-	return err;
+
+	ar9170_usb_send_urb(aru);
+
+	return 0;
 }
 
 static void ar9170_usb_callback_cmd(struct ar9170 *ar, u32 len , void *buffer)
@@ -592,10 +657,8 @@ static void ar9170_usb_stop(struct ar9170 *ar)
 	if (IS_ACCEPTING_CMD(ar))
 		aru->common.state = AR9170_STOPPED;
 
-	/* lets wait a while until the tx - queues are dried out */
-	ret = usb_wait_anchor_empty_timeout(&aru->tx_submitted,
-					    msecs_to_jiffies(1000));
-	if (ret == 0)
+	ret = ar9170_usb_flush(ar);
+	if (ret)
 		dev_err(&aru->udev->dev, "kill pending tx urbs.\n");
 
 	usb_poison_anchored_urbs(&aru->tx_submitted);
@@ -656,6 +719,43 @@ err_out:
 	return err;
 }
 
+static void ar9170_usb_reset_work(struct work_struct *work)
+{
+	struct ar9170_usb *aru = container_of(work, struct ar9170_usb,
+					      reset_work);
+	int err;
+
+	ar9170_usb_cancel_urbs(aru);
+
+	/* let it cool down */
+	msleep(200);
+
+	usb_unpoison_anchored_urbs(&aru->rx_submitted);
+	usb_unpoison_anchored_urbs(&aru->tx_submitted);
+
+	err = ar9170_usb_init_device(aru);
+	if (err)
+		goto err_unrx;
+
+	err = ar9170_usb_open(&aru->common);
+	if (err)
+		goto err_unrx;
+
+	ieee80211_restart_hw(aru->common.hw);
+	return ;
+
+err_unrx:
+	dev_err(&aru->udev->dev, "reinitialization failed (%d)!\n", err);
+	ar9170_usb_cancel_urbs(aru);
+}
+
+static void ar9170_usb_schedule_reset(struct ar9170 *ar)
+{
+	struct ar9170_usb *aru = (void *) ar;
+
+	queue_work(ar->hw->workqueue, &aru->reset_work);
+}
+
 static int ar9170_usb_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
@@ -678,12 +778,20 @@ static int ar9170_usb_probe(struct usb_interface *intf,
 
 	usb_set_intfdata(intf, aru);
 	SET_IEEE80211_DEV(ar->hw, &udev->dev);
+	INIT_WORK(&aru->reset_work, ar9170_usb_reset_work);
 
 	init_usb_anchor(&aru->rx_submitted);
+	init_usb_anchor(&aru->tx_pending);
 	init_usb_anchor(&aru->tx_submitted);
 	init_completion(&aru->cmd_wait);
+	spin_lock_init(&aru->tx_urb_lock);
+
+	aru->tx_pending_urbs = 0;
+	aru->tx_submitted_urbs = 0;
 
 	aru->common.stop = ar9170_usb_stop;
+	aru->common.flush = ar9170_usb_flush;
+	aru->common.reset = ar9170_usb_schedule_reset;
 	aru->common.open = ar9170_usb_open;
 	aru->common.tx = ar9170_usb_tx;
 	aru->common.exec_cmd = ar9170_usb_exec_cmd;
@@ -691,7 +799,7 @@ static int ar9170_usb_probe(struct usb_interface *intf,
 
 #ifdef CONFIG_PM
 	udev->reset_resume = 1;
-#endif
+#endif /* CONFIG_PM */
 	err = ar9170_usb_reset(aru);
 	if (err)
 		goto err_freehw;
@@ -738,6 +846,8 @@ static void ar9170_usb_disconnect(struct usb_interface *intf)
 	if (!aru)
 		return;
 
+	cancel_work_sync(&aru->reset_work);
+
 	aru->common.state = AR9170_IDLE;
 	ar9170_unregister(&aru->common);
 	ar9170_usb_cancel_urbs(aru);
@@ -759,6 +869,7 @@ static int ar9170_suspend(struct usb_interface *intf,
 	if (!aru)
 		return -ENODEV;
 
+	cancel_work_sync(&aru->reset_work);
 	aru->common.state = AR9170_IDLE;
 	ar9170_usb_cancel_urbs(aru);
 
@@ -776,11 +887,6 @@ static int ar9170_resume(struct usb_interface *intf)
 	usb_unpoison_anchored_urbs(&aru->rx_submitted);
 	usb_unpoison_anchored_urbs(&aru->tx_submitted);
 
-	/*
-	 * FIXME: firmware upload will fail on resume.
-	 * but this is better than a hang!
-	 */
-
 	err = ar9170_usb_init_device(aru);
 	if (err)
 		goto err_unrx;
diff --git a/drivers/net/wireless/ath/ar9170/usb.h b/drivers/net/wireless/ath/ar9170/usb.h
index ac42586..d75e6ee 100644
--- a/drivers/net/wireless/ath/ar9170/usb.h
+++ b/drivers/net/wireless/ath/ar9170/usb.h
@@ -51,6 +51,7 @@
 #include "ar9170.h"
 
 #define AR9170_NUM_RX_URBS			16
+#define AR9170_NUM_TX_URBS			8
 
 struct firmware;
 
@@ -60,15 +61,21 @@ struct ar9170_usb {
 	struct usb_interface *intf;
 
 	struct usb_anchor rx_submitted;
+	struct usb_anchor tx_pending;
 	struct usb_anchor tx_submitted;
 
-	spinlock_t cmdlock;
+	spinlock_t tx_urb_lock;
+	unsigned int tx_submitted_urbs;
+	unsigned int tx_pending_urbs;
+
 	struct completion cmd_wait;
 	int readlen;
 	u8 *readbuf;
 
 	const struct firmware *init_values;
 	const struct firmware *firmware;
+
+	struct work_struct reset_work;
 };
 
 #endif /* __USB_H */

