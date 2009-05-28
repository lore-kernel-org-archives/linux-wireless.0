Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:57675 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759988AbZE1PE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 11:04:29 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ar9170usb: more minor fixes
Date: Thu, 28 May 2009 17:04:27 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200905281704.28362.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch contains a few more mostly random fixes for the USB front-end.

1. handle irq command response, instead of printing it to the console.

2. remove fixed FIXME.
    (real fix: "ar9170usb: reset device on resume". )

3. some more one-liner.
	- get rid of a useless "return;"
	- add a few branch prediction hints in hot-paths
	etc.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index 396b240..4c4b08f 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -207,6 +207,7 @@ void ar9170_rx(struct ar9170 *ar, struct sk_buff *skb);
 void ar9170_unregister(struct ar9170 *ar);
 void ar9170_handle_tx_status(struct ar9170 *ar, struct sk_buff *skb,
 			     bool update_statistics, u16 tx_status);
+void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len);
 
 /* MAC */
 int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 63528f1..b889fda 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -370,8 +370,7 @@ static void ar9170_tx_status_janitor(struct work_struct *work)
 				   msecs_to_jiffies(100));
 }
 
-static void ar9170_handle_command_response(struct ar9170 *ar,
-					   void *buf, u32 len)
+void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len)
 {
 	struct ar9170_cmd_response *cmd = (void *) buf;
 
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index d7c13c0..a54d49b 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -93,7 +93,7 @@ static void ar9170_usb_tx_urb_complete_free(struct urb *urb)
 	struct ar9170_usb *aru = (struct ar9170_usb *)
 	      usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 
-	if (!aru) {
+	if (unlikely(!aru)) {
 		dev_kfree_skb_irq(skb);
 		return ;
 	}
@@ -126,8 +126,8 @@ static void ar9170_usb_irq_completed(struct urb *urb)
 		goto resubmit;
 	}
 
-	print_hex_dump_bytes("ar9170 irq: ", DUMP_PREFIX_OFFSET,
-			     urb->transfer_buffer, urb->actual_length);
+	ar9170_handle_command_response(&aru->common, urb->transfer_buffer,
+				       urb->actual_length);
 
 resubmit:
 	usb_anchor_urb(urb, &aru->rx_submitted);
@@ -177,16 +177,15 @@ resubmit:
 
 	usb_anchor_urb(urb, &aru->rx_submitted);
 	err = usb_submit_urb(urb, GFP_ATOMIC);
-	if (err) {
+	if (unlikely(err)) {
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
@@ -337,7 +336,7 @@ static int ar9170_usb_exec_cmd(struct ar9170 *ar, enum ar9170_cmd cmd,
 
 	usb_anchor_urb(urb, &aru->tx_submitted);
 	err = usb_submit_urb(urb, GFP_ATOMIC);
-	if (err) {
+	if (unlikely(err)) {
 		usb_unanchor_urb(urb);
 		usb_free_urb(urb);
 		goto err_unbuf;
@@ -418,7 +417,7 @@ static void ar9170_usb_callback_cmd(struct ar9170 *ar, u32 len , void *buffer)
 	unsigned long flags;
 	u32 in, out;
 
-	if (!buffer)
+	if (unlikely(!buffer))
 		return ;
 
 	in = le32_to_cpup((__le32 *)buffer);
@@ -691,7 +690,7 @@ static int ar9170_usb_probe(struct usb_interface *intf,
 
 #ifdef CONFIG_PM
 	udev->reset_resume = 1;
-#endif
+#endif /* CONFIG_PM */
 	err = ar9170_usb_reset(aru);
 	if (err)
 		goto err_freehw;
@@ -776,11 +775,6 @@ static int ar9170_resume(struct usb_interface *intf)
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
