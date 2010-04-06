Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22584 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab0DFJhs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 05:37:48 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 02:37:48 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19387.1465.547642.713923@gargle.gargle.HOWL>
Date: Tue, 6 Apr 2010 15:28:17 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/5] ath9k_htc: Use anchors for REGOUT pipe
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hif_usb_regout_cb() frees the given URB, which is
borked by design. Use an anchor to simplify URB
management.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   30 ++++++++++++++----------------
 drivers/net/wireless/ath/ath9k/hif_usb.h |    1 +
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 69bef1d..e2117e7 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -32,27 +32,15 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev);
 static void hif_usb_regout_cb(struct urb *urb)
 {
 	struct cmd_buf *cmd = (struct cmd_buf *)urb->context;
-	struct hif_device_usb *hif_dev = cmd->hif_dev;
-
-	if (!hif_dev) {
-		usb_free_urb(urb);
-		if (cmd) {
-			if (cmd->skb)
-				dev_kfree_skb_any(cmd->skb);
-			kfree(cmd);
-		}
-		return;
-	}
 
 	switch (urb->status) {
 	case 0:
 		break;
 	case -ENOENT:
 	case -ECONNRESET:
-		break;
 	case -ENODEV:
 	case -ESHUTDOWN:
-		return;
+		goto free;
 	default:
 		break;
 	}
@@ -61,8 +49,12 @@ static void hif_usb_regout_cb(struct urb *urb)
 		ath9k_htc_txcompletion_cb(cmd->hif_dev->htc_handle,
 					  cmd->skb, 1);
 		kfree(cmd);
-		usb_free_urb(urb);
 	}
+
+	return;
+free:
+	dev_kfree_skb_any(cmd->skb);
+	kfree(cmd);
 }
 
 static int hif_usb_send_regout(struct hif_device_usb *hif_dev,
@@ -90,11 +82,13 @@ static int hif_usb_send_regout(struct hif_device_usb *hif_dev,
 			 skb->data, skb->len,
 			 hif_usb_regout_cb, cmd, 1);
 
+	usb_anchor_urb(urb, &hif_dev->regout_submitted);
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret) {
-		usb_free_urb(urb);
+		usb_unanchor_urb(urb);
 		kfree(cmd);
 	}
+	usb_free_urb(urb);
 
 	return ret;
 }
@@ -711,6 +705,9 @@ err:
 
 static int ath9k_hif_usb_alloc_urbs(struct hif_device_usb *hif_dev)
 {
+	/* Register Write */
+	init_usb_anchor(&hif_dev->regout_submitted);
+
 	/* TX */
 	if (ath9k_hif_usb_alloc_tx_urbs(hif_dev) < 0)
 		goto err;
@@ -719,7 +716,7 @@ static int ath9k_hif_usb_alloc_urbs(struct hif_device_usb *hif_dev)
 	if (ath9k_hif_usb_alloc_rx_urbs(hif_dev) < 0)
 		goto err;
 
-	/* Register Read/Write */
+	/* Register Read */
 	if (ath9k_hif_usb_alloc_reg_in_urb(hif_dev) < 0)
 		goto err;
 
@@ -816,6 +813,7 @@ err_fw_req:
 
 static void ath9k_hif_usb_dealloc_urbs(struct hif_device_usb *hif_dev)
 {
+	usb_kill_anchored_urbs(&hif_dev->regout_submitted);
 	ath9k_hif_usb_dealloc_reg_in_urb(hif_dev);
 	ath9k_hif_usb_dealloc_tx_urbs(hif_dev);
 	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 179cea4..7d49a8a 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -88,6 +88,7 @@ struct hif_device_usb {
 	struct htc_target *htc_handle;
 	struct hif_usb_tx tx;
 	struct urb *reg_in_urb;
+	struct usb_anchor regout_submitted;
 	struct usb_anchor rx_submitted;
 	struct sk_buff *remain_skb;
 	int rx_remain_len;
-- 
1.7.0.3

