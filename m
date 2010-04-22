Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43134 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab0DVDn7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 23:43:59 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 20:43:59 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19407.50663.38092.47170@gargle.gargle.HOWL>
Date: Thu, 22 Apr 2010 09:13:35 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 8/9] ath9k_htc: Process command data properly
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
index ce13e08..6e34852 100644
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

