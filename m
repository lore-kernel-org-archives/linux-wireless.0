Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59310 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab0KAOcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 10:32:39 -0400
Received: by iwn10 with SMTP id 10so7100523iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 07:32:39 -0700 (PDT)
From: tom.leiming@gmail.com
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] ath9k-htc: fix probe failure
Date: Mon,  1 Nov 2010 22:32:30 +0800
Message-Id: <1288621950-13918-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

Obviously, we should set the transfer type consitent with
endpoint descriptor type to urb, this patch fixes the probe
failure below:

[    8.018768] PM: Removing info for No Bus:1-2.2
[    8.019470] usb 1-2.2: BOGUS urb xfer, pipe 3 != type 1
[    8.031707] usb 1-2.2: ath9k_htc: Unable to allocate URBs
[    8.037506] ath9k_hif_usb: probe of 1-2.2:1.0 failed with error -22
[    8.044250] usbcore: registered new interface driver ath9k_hif_usb

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 728d904..04242bc 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -541,7 +541,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 		}
 
 		usb_fill_int_urb(urb, hif_dev->udev,
-				 usb_rcvbulkpipe(hif_dev->udev,
+				 usb_rcvintpipe(hif_dev->udev,
 						 USB_REG_IN_PIPE),
 				 nskb->data, MAX_REG_IN_BUF_SIZE,
 				 ath9k_hif_usb_reg_in_cb, nskb, 1);
@@ -721,7 +721,7 @@ static int ath9k_hif_usb_alloc_reg_in_urb(struct hif_device_usb *hif_dev)
 		goto err;
 
 	usb_fill_int_urb(hif_dev->reg_in_urb, hif_dev->udev,
-			 usb_rcvbulkpipe(hif_dev->udev,
+			 usb_rcvintpipe(hif_dev->udev,
 					 USB_REG_IN_PIPE),
 			 skb->data, MAX_REG_IN_BUF_SIZE,
 			 ath9k_hif_usb_reg_in_cb, skb, 1);
-- 
1.7.3

