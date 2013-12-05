Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48563 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab3LEOVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 09:21:08 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sw@simonwunderlich.de
Subject: [PATCH 3.13] ath9k: fix duration calculation for non-aggregated packets
Date: Thu,  5 Dec 2013 15:20:53 +0100
Message-Id: <1386253253-73378-1-git-send-email-nbd@openwrt.org> (sfid-20131205_152111_898128_17A32FEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When not aggregating packets, fi->framelen should be passed in as length
to calculate the duration. Before the tx path rework, ath_tx_fill_desc
was called for either one aggregate, or one single frame, with the
length of the packet or the aggregate as a parameter.
After the rework, ath_tx_sched_aggr can pass a burst of single frames to
ath_tx_fill_desc and sets len=0.
Fix broken duration calculation by overriding the length in ath_tx_fill_desc
before passing it to ath_buf_set_rate.

Cc: stable@vger.kernel.org
Reported-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 09cdbcd..b5a19e0 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1276,6 +1276,10 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 				if (!rts_thresh || (len > rts_thresh))
 					rts = true;
 			}
+
+			if (!aggr)
+				len = fi->framelen;
+
 			ath_buf_set_rate(sc, bf, &info, len, rts);
 		}
 
-- 
1.8.3.4 (Apple Git-47)

