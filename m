Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42535 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab0GGJtZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 05:49:25 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 07 Jul 2010 02:49:25 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: fix memory leak in ath9k_hif_usb_alloc_urbs
Date: Wed, 7 Jul 2010 15:19:18 +0530
Message-ID: <1278496158-3077-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Failure cases within ath9k_hif_usb_alloc_urbs are failed
to release allocated memory.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index ad9134b..61c1bee 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -745,13 +745,17 @@ static int ath9k_hif_usb_alloc_urbs(struct hif_device_usb *hif_dev)
 
 	/* RX */
 	if (ath9k_hif_usb_alloc_rx_urbs(hif_dev) < 0)
-		goto err;
+		goto err_rx;
 
 	/* Register Read */
 	if (ath9k_hif_usb_alloc_reg_in_urb(hif_dev) < 0)
-		goto err;
+		goto err_reg;
 
 	return 0;
+err_reg:
+	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
+err_rx:
+	ath9k_hif_usb_dealloc_tx_urbs(hif_dev);
 err:
 	return -ENOMEM;
 }
-- 
1.7.0.4

