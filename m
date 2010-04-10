Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f193.google.com ([209.85.222.193]:40429 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0DJPFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Apr 2010 11:05:34 -0400
Received: by mail-pz0-f193.google.com with SMTP id 31so817455pzk.33
        for <linux-wireless@vger.kernel.org>; Sat, 10 Apr 2010 08:05:33 -0700 (PDT)
From: tom.leiming@gmail.com
To: Sujith.Manoharan@atheros.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/3] ath9k-htc: replace __dev_alloc_skb with alloc_skb in reg in path
Date: Sat, 10 Apr 2010 23:05:09 +0800
Message-Id: <1270911909-5750-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

In ath9k-htc register in path, ath9k-htc will pass skb->data into
usb hcd and usb hcd will do dma mapping and unmapping to the buffer
pointed by skb->data, so we should pass a cache-line aligned address.

This patch replace __dev_alloc_skb with alloc_skb to make skb->data
pointed to a cacheline aligned address simply since ath9k-htc does not
skb_push on the skb.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index a498815..be4dfbd 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -499,7 +499,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	if (likely(urb->actual_length != 0)) {
 		skb_put(skb, urb->actual_length);
 
-		nskb = __dev_alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
+		nskb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_ATOMIC);
 		if (!nskb)
 			goto resubmit;
 
@@ -684,7 +684,7 @@ static int ath9k_hif_usb_alloc_reg_in_urb(struct hif_device_usb *hif_dev)
 	if (hif_dev->reg_in_urb == NULL)
 		return -ENOMEM;
 
-	skb = __dev_alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_KERNEL);
+	skb = alloc_skb(MAX_REG_IN_BUF_SIZE, GFP_KERNEL);
 	if (!skb)
 		goto err;
 
-- 
1.6.2.5

