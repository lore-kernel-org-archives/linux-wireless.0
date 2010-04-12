Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:33032 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0DLQ31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 12:29:27 -0400
Received: by qyk9 with SMTP id 9so397644qyk.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 09:29:26 -0700 (PDT)
From: tom.leiming@gmail.com
To: Sujith.Manoharan@atheros.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ming Lei <tom.leiming@gmail.com>
Subject: [PATCHv2 2/4] ath9k-htc:respect usb buffer cacheline alignment in reg in path
Date: Tue, 13 Apr 2010 00:29:05 +0800
Message-Id: <1271089745-7933-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

In ath9k-htc register in path, ath9k-htc will pass skb->data into
usb hcd and usb hcd will do dma mapping and unmapping to the buffer
pointed by skb->data, so we should pass a cache-line aligned address.

This patch replace __dev_alloc_skb with alloc_skb to make skb->data
pointed to a cacheline aligned address simply since ath9k-htc does not
skb_push on the skb and pass it to mac80211, also use kfree_skb to free
the skb allocated by alloc_skb(we can use kfree_skb safely in hardirq
context since skb->destructor is NULL always in the path).

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   10 +++++-----
 drivers/net/wireless/ath/ath9k/htc_hst.c |    7 +++++--
 drivers/net/wireless/ath/ath9k/wmi.c     |    4 ++--
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 178b11a..259de17 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -499,7 +499,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	if (likely(urb->actual_length != 0)) {
 		skb_put(skb, urb->actual_length);
 
-		nskb = __dev_alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
+		nskb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
 		if (!nskb)
 			goto resubmit;
 
@@ -510,7 +510,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 
 		ret = usb_submit_urb(urb, GFP_ATOMIC);
 		if (ret) {
-			dev_kfree_skb_any(nskb);
+			kfree_skb(nskb);
 			goto free;
 		}
 
@@ -530,7 +530,7 @@ resubmit:
 
 	return;
 free:
-	dev_kfree_skb_any(skb);
+	kfree_skb(skb);
 	urb->context = NULL;
 }
 
@@ -670,7 +670,7 @@ static void ath9k_hif_usb_dealloc_reg_in_urb(struct hif_device_usb *hif_dev)
 	if (hif_dev->reg_in_urb) {
 		usb_kill_urb(hif_dev->reg_in_urb);
 		if (hif_dev->reg_in_urb->context)
-			dev_kfree_skb_any((void *)hif_dev->reg_in_urb->context);
+			kfree_skb((void *)hif_dev->reg_in_urb->context);
 		usb_free_urb(hif_dev->reg_in_urb);
 		hif_dev->reg_in_urb = NULL;
 	}
@@ -684,7 +684,7 @@ static int ath9k_hif_usb_alloc_reg_in_urb(struct hif_device_usb *hif_dev)
 	if (hif_dev->reg_in_urb == NULL)
 		return -ENOMEM;
 
-	skb = __dev_alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_KERNEL);
+	skb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_KERNEL);
 	if (!skb)
 		goto err;
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 24d7b88..d1fa5bd 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -374,7 +374,10 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 	epid = htc_hdr->endpoint_id;
 
 	if (epid >= ENDPOINT_MAX) {
-		dev_kfree_skb_any(skb);
+		if (pipe_id != USB_REG_IN_PIPE)
+			dev_kfree_skb_any(skb);
+		else
+			kfree_skb(skb);
 		return;
 	}
 
@@ -403,7 +406,7 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 			break;
 		}
 
-		dev_kfree_skb_any(skb);
+		kfree_skb(skb);
 
 	} else {
 		if (htc_hdr->flags & HTC_FLAGS_RECV_TRAILER)
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 818dea0..acb6654 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -169,7 +169,7 @@ void ath9k_wmi_tasklet(unsigned long data)
 		break;
 	}
 
-	dev_kfree_skb_any(skb);
+	kfree_skb(skb);
 }
 
 static void ath9k_wmi_rsp_callback(struct wmi *wmi, struct sk_buff *skb)
@@ -207,7 +207,7 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 	ath9k_wmi_rsp_callback(wmi, skb);
 
 free_skb:
-	dev_kfree_skb_any(skb);
+	kfree_skb(skb);
 }
 
 static void ath9k_wmi_ctrl_tx(void *priv, struct sk_buff *skb,
-- 
1.6.2.5

