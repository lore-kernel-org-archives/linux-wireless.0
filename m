Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39115 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaDUXPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 19:15:04 -0400
Received: by mail-pa0-f42.google.com with SMTP id fb1so4247368pad.15
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2014 16:15:04 -0700 (PDT)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, nbd@openwrt.org
Subject: [PATCH 1/2] ath9k: fix possible hang on flush
Date: Mon, 21 Apr 2014 16:14:56 -0700
Message-Id: <1398122097-23544-1-git-send-email-tharvey@gateworks.com> (sfid-20140422_011539_945924_2FDB891E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a flush is requested, make sure to clear the descriptor once we've
processed it.

This resolves a hang that will occur if all RX descriptors are full when a
flush is requested.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6c9accd..e77a253 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1113,14 +1113,13 @@ requeue_drop_frag:
 		}
 requeue:
 		list_add_tail(&bf->list, &sc->rx.rxbuf);
-		if (flush)
-			continue;
 
 		if (edma) {
 			ath_rx_edma_buf_link(sc, qtype);
 		} else {
 			ath_rx_buf_relink(sc, bf);
-			ath9k_hw_rxena(ah);
+			if (!flush)
+				ath9k_hw_rxena(ah);
 		}
 	} while (1);
 
-- 
1.8.3.2

