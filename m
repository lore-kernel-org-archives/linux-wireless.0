Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48129 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331Ab0LCER6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 23:17:58 -0500
Received: by eye27 with SMTP id 27so4781530eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 20:17:57 -0800 (PST)
Date: Fri, 3 Dec 2010 06:05:19 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Subject: [PATCH 2/6] ath5k: Always free tx buffers before reset
Message-ID: <20101203040519.GB2988@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Always free tx buffers before reset, since we also empty hw queues.
 If we don't and a queue gets stuck, we'll never decrease txq_len and sw
 will keep thinking the queue is still stuck even after reset.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath/ath5k/base.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a8d380a..047b2a0 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2512,9 +2512,11 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 	synchronize_irq(sc->pdev->irq);
 	stop_tasklets(sc);
 
+	/* We are going to empty hw queues
+	 * so we should also free any remaining
+	 * tx buffers */
+	ath5k_drain_tx_buffs(sc);
 	if (chan) {
-		ath5k_drain_tx_buffs(sc);
-
 		sc->curchan = chan;
 		sc->curband = &sc->sbands[chan->band];
 	}
