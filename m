Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14855 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150Ab0JTXHO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 19:07:14 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 16:07:04 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Kyungwan Nam <kyungwan.nam@atheros.com>
Subject: [PATCH 2/6] ath9k: add locking for starting the PCU on RX
Date: Wed, 20 Oct 2010 16:07:04 -0700
Message-ID: <1287616028-12547-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
References: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was some locking for starting some parts of
RX but not for starting the PCU. Include this otherwise
we can content against stopping the PCU.

This can potentially lead to races against different
buffers on the PCU which can lead to to the DMA RX
engine writing to buffers which are already freed.

This is part of a series that will help resolve the bug:

https://bugzilla.kernel.org/show_bug.cgi?id=14624

For more details about this issue refer to:

http://marc.info/?l=linux-wireless&m=128629803703756&w=2

Cc: stable@kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 3b19bbb..944fb59 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -297,11 +297,11 @@ static void ath_edma_start_recv(struct ath_softc *sc)
 	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_LP,
 			      sc->rx.rx_edma[ATH9K_RX_QUEUE_LP].rx_fifo_hwsize);
 
-	spin_unlock_bh(&sc->rx.rxbuflock);
-
 	ath_opmode_init(sc);
 
 	ath9k_hw_startpcureceive(sc->sc_ah, (sc->sc_flags & SC_OP_OFFCHANNEL));
+
+	spin_unlock_bh(&sc->rx.rxbuflock);
 }
 
 static void ath_edma_stop_recv(struct ath_softc *sc)
@@ -504,10 +504,11 @@ int ath_startrecv(struct ath_softc *sc)
 	ath9k_hw_rxena(ah);
 
 start_recv:
-	spin_unlock_bh(&sc->rx.rxbuflock);
 	ath_opmode_init(sc);
 	ath9k_hw_startpcureceive(ah, (sc->sc_flags & SC_OP_OFFCHANNEL));
 
+	spin_unlock_bh(&sc->rx.rxbuflock);
+
 	return 0;
 }
 
-- 
1.7.0.4

