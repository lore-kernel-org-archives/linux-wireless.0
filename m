Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54400 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab1CLALd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 19:11:33 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k: fix aggregation related interoperability issues
Date: Sat, 12 Mar 2011 01:11:28 +0100
Message-Id: <1299888688-25201-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some clients seems to keep track of their reorder window even after an
aggregation session has been disabled. This causes issues if there are
still retried but not completed frames pending for the TID.
To ensure that rx does not stall in such situations, set sendbar to 1
for any frame purged from the TID queue on teardown.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index f977f80..ef22096 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -166,7 +166,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		fi = get_frame_info(bf->bf_mpdu);
 		if (fi->retries) {
 			ath_tx_update_baw(sc, tid, fi->seqno);
-			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 1);
 		} else {
 			ath_tx_send_normal(sc, txq, NULL, &bf_head);
 		}
-- 
1.7.3.2

