Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34820 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbZHCTZZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:25 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:26 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 21/24] ath9k: set sc->sc_ah to NULL after freeing it
Date: Mon, 3 Aug 2009 12:24:53 -0700
Message-ID: <1249327496-24629-22-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 91bffc9..d3d2cb6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1278,6 +1278,7 @@ void ath_detach(struct ath_softc *sc)
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
 	ath9k_hw_detach(sc->sc_ah);
+	sc->sc_ah = NULL;
 	ath9k_exit_debug(sc);
 }
 
@@ -1521,6 +1522,7 @@ bad2:
 bad:
 	if (ah)
 		ath9k_hw_detach(ah);
+	sc->sc_ah = NULL;
 bad_no_ah:
 	ath9k_exit_debug(sc);
 
@@ -1631,6 +1633,7 @@ error_attach:
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
 	ath9k_hw_detach(sc->sc_ah);
+	sc->sc_ah = NULL;
 	ath9k_exit_debug(sc);
 
 	return error;
-- 
1.6.3.3

