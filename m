Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14852 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083Ab0JTXHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 19:07:12 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 16:07:02 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Kyungwan Nam <kyungwan.nam@atheros.com>
Subject: [PATCH 1/6] ath9k: add locking for stopping RX
Date: Wed, 20 Oct 2010 16:07:03 -0700
Message-ID: <1287616028-12547-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
References: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k locks for starting RX but not for stopping RX. We could
potentially run into a situation where tried to stop RX
but immediately started RX. This allows for races on the
the RX engine deciding what buffer we last left off on
and could potentially cause ath9k to DMA into already
free'd memory or in the worst case at a later time to
already given memory to other drivers.

Fix this by locking stopping RX.

This is part of a series that will help resolve the bug:

https://bugzilla.kernel.org/show_bug.cgi?id=14624

For more details about this issue refer to:

http://marc.info/?l=linux-wireless&m=128629803703756&w=2

Cc: stable@kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 2b2c318..3b19bbb 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -306,10 +306,8 @@ static void ath_edma_start_recv(struct ath_softc *sc)
 
 static void ath_edma_stop_recv(struct ath_softc *sc)
 {
-	spin_lock_bh(&sc->rx.rxbuflock);
 	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_HP);
 	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_LP);
-	spin_unlock_bh(&sc->rx.rxbuflock);
 }
 
 int ath_rx_init(struct ath_softc *sc, int nbufs)
@@ -518,6 +516,7 @@ bool ath_stoprecv(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	bool stopped;
 
+	spin_lock_bh(&sc->rx.rxbuflock);
 	ath9k_hw_stoppcurecv(ah);
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah);
@@ -526,6 +525,7 @@ bool ath_stoprecv(struct ath_softc *sc)
 		ath_edma_stop_recv(sc);
 	else
 		sc->rx.rxlink = NULL;
+	spin_unlock_bh(&sc->rx.rxbuflock);
 
 	return stopped;
 }
-- 
1.7.0.4

