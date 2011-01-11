Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.resortinternet.net ([65.114.208.136]:42873 "EHLO
	smtp.resortinternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab1AKAVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 19:21:11 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 1/4] ath9k: fix bogus sequence number increases on aggregation tid flush
Date: Mon, 10 Jan 2011 17:05:47 -0700
Message-Id: <1294704350-50621-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a tid pointer is passed to ath_tx_send_normal(), it increases the
starting sequence number for the next AMPDU action frame, which should
only be done if the sequence number assignment is fresh. In this case
it is clearly not.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 332d1fe..1adfebc 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -169,7 +169,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 			ath_tx_update_baw(sc, tid, fi->seqno);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
 		} else {
-			ath_tx_send_normal(sc, txq, tid, &bf_head);
+			ath_tx_send_normal(sc, txq, NULL, &bf_head);
 		}
 		spin_lock_bh(&txq->axq_lock);
 	}
-- 
1.7.3.2

