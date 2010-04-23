Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65016 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab0DWE6j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 00:58:39 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 21:58:39 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19409.10473.482170.515511@gargle.gargle.HOWL>
Date: Fri, 23 Apr 2010 10:28:17 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/11] ath9k_htc: Process command data properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When handling the REGIN callback, processing
the incoming data first should be the preferred
mode of operation. Allocation of a new SKB may fail,
in which case, the URB will not be resubmitted.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 31665c5..49b7a89 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -510,9 +510,18 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	if (likely(urb->actual_length != 0)) {
 		skb_put(skb, urb->actual_length);
 
+		/* Process the command first */
+		ath9k_htc_rx_msg(hif_dev->htc_handle, skb,
+				 skb->len, USB_REG_IN_PIPE);
+
+
 		nskb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
-		if (!nskb)
-			goto resubmit;
+		if (!nskb) {
+			dev_err(&hif_dev->udev->dev,
+				"ath9k_htc: REG_IN memory allocation failure\n");
+			urb->context = NULL;
+			return;
+		}
 
 		usb_fill_int_urb(urb, hif_dev->udev,
 				 usb_rcvintpipe(hif_dev->udev, USB_REG_IN_PIPE),
@@ -522,12 +531,9 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 		ret = usb_submit_urb(urb, GFP_ATOMIC);
 		if (ret) {
 			kfree_skb(nskb);
-			goto free;
+			urb->context = NULL;
 		}
 
-		ath9k_htc_rx_msg(hif_dev->htc_handle, skb,
-				 skb->len, USB_REG_IN_PIPE);
-
 		return;
 	}
 
-- 
1.7.0.5

