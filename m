Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2199 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab0HORNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 13:13:20 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 4/6] ath5k: remove monitor check in receive_frame_ok filter
Date: Sun, 15 Aug 2010 13:03:13 -0400
Message-Id: <1281891795-14718-5-git-send-email-me@bobcopeland.com>
In-Reply-To: <1281891795-14718-1-git-send-email-me@bobcopeland.com>
References: <1281891795-14718-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Monitor interfaces are never seen by the driver, so tests based on
that opmode don't make sense.  Also, we already pass all mic
failure packets.

Consequently this code is actually accepting any frames with just
crypto errors and rejecting those with CRC, FIFO, and PHY errors for
all interface types.  Adjust the code and comment accordingly.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9c49b8d..03808b8 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2035,9 +2035,8 @@ ath5k_receive_frame_ok(struct ath5k_softc *sc, struct ath5k_rx_status *rs)
 			return true;
 		}
 
-		/* let crypto-error packets fall through in MNTR */
-		if ((rs->rs_status & ~(AR5K_RXERR_DECRYPT|AR5K_RXERR_MIC)) ||
-		    sc->opmode != NL80211_IFTYPE_MONITOR)
+		/* reject any frames with non-crypto errors */
+		if (rs->rs_status & ~(AR5K_RXERR_DECRYPT))
 			return false;
 	}
 
-- 
1.7.1.1


