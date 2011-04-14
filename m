Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43664 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758918Ab1DNOpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 10:45:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: avoid using trinary operator w/ TX_STAT_INC
Date: Thu, 14 Apr 2011 10:41:34 -0400
Message-Id: <1302792094-13770-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise, you get this:

  CC [M]  drivers/net/wireless/ath/ath9k/hif_usb.o
drivers/net/wireless/ath/ath9k/hif_usb.c: In function ‘ath9k_skb_queue_complete’:
drivers/net/wireless/ath/ath9k/hif_usb.c:230:12: error: expected expression before ‘do’
make[2]: *** [drivers/net/wireless/ath/ath9k/hif_usb.o] Error 1
make[1]: *** [drivers/net/wireless/ath/ath9k] Error 2
make: *** [drivers/net/wireless/ath/] Error 2

The TX_STAT_INC macro should probably be changed to accomodate such
usage, although using a trinary operator in place of an if-else seems
questionable to me anyway.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 5686711..2e3a33a 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -227,7 +227,10 @@ static inline void ath9k_skb_queue_complete(struct hif_device_usb *hif_dev,
 	while ((skb = __skb_dequeue(queue)) != NULL) {
 		ath9k_htc_txcompletion_cb(hif_dev->htc_handle,
 					  skb, txok);
-		(txok) ? TX_STAT_INC(skb_success) : TX_STAT_INC(skb_failed);
+		if (txok)
+			TX_STAT_INC(skb_success);
+		else
+			TX_STAT_INC(skb_failed);
 	}
 }
 
-- 
1.7.4.2

