Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21709 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab0IPOZl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 10:25:41 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 07:25:34 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: Fix register read through bulk pipe
Date: Thu, 16 Sep 2010 19:56:55 +0530
Message-ID: <1284647215-30185-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To optimize register read/write operations, the HTC firmwares were patched
to change EP3 and EP4 pipe types from Interrupt to Bulk. So register writes
are submitted as bulk urbs, but register reads are not. Also changing the
register read endpoint pipe as bulk type when URBs are filled improves the
register reads considerably which results in reduced scan time and CPU
utilization.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 27f88a0..728d904 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -541,7 +541,8 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 		}
 
 		usb_fill_int_urb(urb, hif_dev->udev,
-				 usb_rcvintpipe(hif_dev->udev, USB_REG_IN_PIPE),
+				 usb_rcvbulkpipe(hif_dev->udev,
+						 USB_REG_IN_PIPE),
 				 nskb->data, MAX_REG_IN_BUF_SIZE,
 				 ath9k_hif_usb_reg_in_cb, nskb, 1);
 
@@ -720,7 +721,8 @@ static int ath9k_hif_usb_alloc_reg_in_urb(struct hif_device_usb *hif_dev)
 		goto err;
 
 	usb_fill_int_urb(hif_dev->reg_in_urb, hif_dev->udev,
-			 usb_rcvintpipe(hif_dev->udev, USB_REG_IN_PIPE),
+			 usb_rcvbulkpipe(hif_dev->udev,
+					 USB_REG_IN_PIPE),
 			 skb->data, MAX_REG_IN_BUF_SIZE,
 			 ath9k_hif_usb_reg_in_cb, skb, 1);
 
-- 
1.7.2.3

