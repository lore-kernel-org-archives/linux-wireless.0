Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52332 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab1CGCPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:15:04 -0500
Received: by gyh20 with SMTP id 20so1494682gyh.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:15:04 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16287.414555.471688@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:44:55 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 21/34] ath9k_htc: Increase URB count for REG_IN pipe
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Using a single URB for receiving WMI events is
insufficient, increase it to 64 to not lose
WMI events in high throughput situations.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   99 ++++++++++++++++++------------
 drivers/net/wireless/ath/ath9k/hif_usb.h |    4 +-
 2 files changed, 61 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index d56a10c..a8134f8 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -568,6 +568,9 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	case -ESHUTDOWN:
 		goto free;
 	default:
+		skb_reset_tail_pointer(skb);
+		skb_trim(skb, 0);
+
 		goto resubmit;
 	}
 
@@ -592,23 +595,15 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 						 USB_REG_IN_PIPE),
 				 nskb->data, MAX_REG_IN_BUF_SIZE,
 				 ath9k_hif_usb_reg_in_cb, nskb);
-
-		ret = usb_submit_urb(urb, GFP_ATOMIC);
-		if (ret) {
-			kfree_skb(nskb);
-			urb->context = NULL;
-		}
-
-		return;
 	}
 
 resubmit:
-	skb_reset_tail_pointer(skb);
-	skb_trim(skb, 0);
-
+	usb_anchor_urb(urb, &hif_dev->reg_in_submitted);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
-	if (ret)
+	if (ret) {
+		usb_unanchor_urb(urb);
 		goto free;
+	}
 
 	return;
 free:
@@ -749,43 +744,67 @@ err_urb:
 	return ret;
 }
 
-static void ath9k_hif_usb_dealloc_reg_in_urb(struct hif_device_usb *hif_dev)
+static void ath9k_hif_usb_dealloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 {
-	if (hif_dev->reg_in_urb) {
-		usb_kill_urb(hif_dev->reg_in_urb);
-		if (hif_dev->reg_in_urb->context)
-			kfree_skb((void *)hif_dev->reg_in_urb->context);
-		usb_free_urb(hif_dev->reg_in_urb);
-		hif_dev->reg_in_urb = NULL;
-	}
+	usb_kill_anchored_urbs(&hif_dev->reg_in_submitted);
 }
 
-static int ath9k_hif_usb_alloc_reg_in_urb(struct hif_device_usb *hif_dev)
+static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 {
-	struct sk_buff *skb;
+	struct urb *urb = NULL;
+	struct sk_buff *skb = NULL;
+	int i, ret;
 
-	hif_dev->reg_in_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (hif_dev->reg_in_urb == NULL)
-		return -ENOMEM;
+	init_usb_anchor(&hif_dev->reg_in_submitted);
 
-	skb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_KERNEL);
-	if (!skb)
-		goto err;
+	for (i = 0; i < MAX_REG_IN_URB_NUM; i++) {
 
-	usb_fill_bulk_urb(hif_dev->reg_in_urb, hif_dev->udev,
-			 usb_rcvbulkpipe(hif_dev->udev,
-					 USB_REG_IN_PIPE),
-			 skb->data, MAX_REG_IN_BUF_SIZE,
-			 ath9k_hif_usb_reg_in_cb, skb);
+		/* Allocate URB */
+		urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (urb == NULL) {
+			ret = -ENOMEM;
+			goto err_urb;
+		}
 
-	if (usb_submit_urb(hif_dev->reg_in_urb, GFP_KERNEL) != 0)
-		goto err;
+		/* Allocate buffer */
+		skb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_KERNEL);
+		if (!skb) {
+			ret = -ENOMEM;
+			goto err_skb;
+		}
+
+		usb_fill_bulk_urb(urb, hif_dev->udev,
+				  usb_rcvbulkpipe(hif_dev->udev,
+						  USB_REG_IN_PIPE),
+				  skb->data, MAX_REG_IN_BUF_SIZE,
+				  ath9k_hif_usb_reg_in_cb, skb);
+
+		/* Anchor URB */
+		usb_anchor_urb(urb, &hif_dev->reg_in_submitted);
+
+		/* Submit URB */
+		ret = usb_submit_urb(urb, GFP_KERNEL);
+		if (ret) {
+			usb_unanchor_urb(urb);
+			goto err_submit;
+		}
+
+		/*
+		 * Drop reference count.
+		 * This ensures that the URB is freed when killing them.
+		 */
+		usb_free_urb(urb);
+	}
 
 	return 0;
 
-err:
-	ath9k_hif_usb_dealloc_reg_in_urb(hif_dev);
-	return -ENOMEM;
+err_submit:
+	kfree_skb(skb);
+err_skb:
+	usb_free_urb(urb);
+err_urb:
+	ath9k_hif_usb_dealloc_reg_in_urbs(hif_dev);
+	return ret;
 }
 
 static int ath9k_hif_usb_alloc_urbs(struct hif_device_usb *hif_dev)
@@ -802,7 +821,7 @@ static int ath9k_hif_usb_alloc_urbs(struct hif_device_usb *hif_dev)
 		goto err_rx;
 
 	/* Register Read */
-	if (ath9k_hif_usb_alloc_reg_in_urb(hif_dev) < 0)
+	if (ath9k_hif_usb_alloc_reg_in_urbs(hif_dev) < 0)
 		goto err_reg;
 
 	return 0;
@@ -817,7 +836,7 @@ err:
 static void ath9k_hif_usb_dealloc_urbs(struct hif_device_usb *hif_dev)
 {
 	usb_kill_anchored_urbs(&hif_dev->regout_submitted);
-	ath9k_hif_usb_dealloc_reg_in_urb(hif_dev);
+	ath9k_hif_usb_dealloc_reg_in_urbs(hif_dev);
 	ath9k_hif_usb_dealloc_tx_urbs(hif_dev);
 	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index f82b32b..8b98d64 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -40,7 +40,7 @@
 #define MAX_PKT_NUM_IN_TRANSFER 10
 
 #define MAX_REG_OUT_URB_NUM  1
-#define MAX_REG_OUT_BUF_NUM  8
+#define MAX_REG_IN_URB_NUM   64
 
 #define MAX_REG_IN_BUF_SIZE 64
 
@@ -90,9 +90,9 @@ struct hif_device_usb {
 	const struct firmware *firmware;
 	struct htc_target *htc_handle;
 	struct hif_usb_tx tx;
-	struct urb *reg_in_urb;
 	struct usb_anchor regout_submitted;
 	struct usb_anchor rx_submitted;
+	struct usb_anchor reg_in_submitted;
 	struct sk_buff *remain_skb;
 	const char *fw_name;
 	int rx_remain_len;
-- 
1.7.4.1

