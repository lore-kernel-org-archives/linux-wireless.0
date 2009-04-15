Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3426 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbZDOL6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 07:58:38 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 5/5] ath5k: manipulate rxlink and descriptor address under rxbuf lock
Date: Wed, 15 Apr 2009 07:57:36 -0400
Message-Id: <1239796656-20646-6-git-send-email-me@bobcopeland.com> (sfid-20090415_135847_082656_78E4E78D)
In-Reply-To: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
References: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grabbing an ath5k_buf then dropping the lock is racy because the
referenced descriptor can be obtained in another thread and released
before the buffer is handed to the hardware.  Likewise, manipulating
sc->rxlink without the lock can lead to having multiple self-linked
hardware descriptors.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 1a6e72f..c8c658b 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1618,9 +1618,8 @@ ath5k_rx_start(struct ath5k_softc *sc)
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rxbufsize %u\n",
 		sc->cachelsz, sc->rxbufsize);
 
-	sc->rxlink = NULL;
-
 	spin_lock_bh(&sc->rxbuflock);
+	sc->rxlink = NULL;
 	list_for_each_entry(bf, &sc->rxbuf, list) {
 		ret = ath5k_rxbuf_setup(sc, bf);
 		if (ret != 0) {
@@ -1629,9 +1628,9 @@ ath5k_rx_start(struct ath5k_softc *sc)
 		}
 	}
 	bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
+	ath5k_hw_set_rxdp(ah, bf->daddr);
 	spin_unlock_bh(&sc->rxbuflock);
 
-	ath5k_hw_set_rxdp(ah, bf->daddr);
 	ath5k_hw_start_rx_dma(ah);	/* enable recv descriptors */
 	ath5k_mode_setup(sc);		/* set filters, etc. */
 	ath5k_hw_start_rx_pcu(ah);	/* re-enable PCU/DMA engine */
-- 
1.6.0.6


