Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2151 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZCQDHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 23:07:21 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>, stable@kernel.org
Subject: [PATCH 1/2] ath5k: disable MIB interrupts
Date: Mon, 16 Mar 2009 22:34:02 -0400
Message-Id: <1237257243-18660-1-git-send-email-me@bobcopeland.com> (sfid-20090317_040722_604624_5586CD67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MIB interrupt fires whenever counters overflow; however without
support for automatic noise immunity, we can sometimes get an interrupt
storm.  The get_stats() callback reads the counters anyway so we can
disable the interrupt for now until ANI is implemented.  This fixes
the issue reported in http://bugzilla.kernel.org/show_bug.cgi?id=12647.

Changes-licensed-under: 3-Clause-BSD

Cc: stable@kernel.org
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index cad3ccf..8eec155 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2305,7 +2305,7 @@ ath5k_init(struct ath5k_softc *sc)
 	sc->curband = &sc->sbands[sc->curchan->band];
 	sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
 		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
-		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;
+		AR5K_INT_FATAL | AR5K_INT_GLOBAL;
 	ret = ath5k_reset(sc, false, false);
 	if (ret)
 		goto done;
-- 
1.6.0.6


