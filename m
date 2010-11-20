Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39440 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303Ab0KTCIw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 21:08:52 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/3] ath9k: fix recursive locking in the tx flush path
Date: Sat, 20 Nov 2010 03:08:46 +0100
Message-Id: <1290218928-87475-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Tested-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c63e283..495432e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -163,6 +163,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
 		list_move_tail(&bf->list, &bf_head);
 
+		spin_unlock_bh(&txq->axq_lock);
 		fi = get_frame_info(bf->bf_mpdu);
 		if (fi->retries) {
 			ath_tx_update_baw(sc, tid, fi->seqno);
@@ -170,6 +171,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		} else {
 			ath_tx_send_normal(sc, txq, tid, &bf_head);
 		}
+		spin_lock_bh(&txq->axq_lock);
 	}
 
 	spin_unlock_bh(&txq->axq_lock);
-- 
1.7.3.2

