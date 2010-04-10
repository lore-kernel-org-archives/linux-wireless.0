Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f193.google.com ([209.85.222.193]:40429 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0DJPFP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Apr 2010 11:05:15 -0400
Received: by pzk31 with SMTP id 31so817455pzk.33
        for <linux-wireless@vger.kernel.org>; Sat, 10 Apr 2010 08:05:14 -0700 (PDT)
From: tom.leiming@gmail.com
To: Sujith.Manoharan@atheros.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/3] ath9k-htc: replace __dev_alloc_skb with alloc_skb in ath9k_hif_usb_alloc_rx_urbs
Date: Sat, 10 Apr 2010 23:04:47 +0800
Message-Id: <1270911887-5717-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

In ath9k_hif_usb_alloc_rx_urbs, ath9k-htc will pass skb->data into
usb hcd and usb hcd will do dma mapping and unmapping to the buffer
pointed by skb->data, so we should pass a cache-line aligned address.

This patch replace __dev_alloc_skb with alloc_skb to make skb->data
pointed to a cacheline aligned address simply since ath9k-htc does not
skb_push on the skb.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index e2117e7..a498815 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -625,7 +625,7 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 		}
 
 		/* Allocate buffer */
-		skb = __dev_alloc_skb(MAX_RX_BUF_SIZE, GFP_KERNEL);
+		skb = alloc_skb(MAX_RX_BUF_SIZE, GFP_KERNEL);
 		if (!skb) {
 			ret = -ENOMEM;
 			goto err_skb;
-- 
1.6.2.5

