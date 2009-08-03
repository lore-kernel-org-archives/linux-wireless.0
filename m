Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34789 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbZHCTZE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:04 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:05 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 06/24] ath9k: move cache setting of softc ah prior to attach
Date: Mon, 3 Aug 2009 12:24:38 -0700
Message-ID: <1249327496-24629-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do this in case attach and friends try to get back to
ah from the softc somehow.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index fa2c230..605d328 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1332,6 +1332,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 
 	ah->ah_sc = sc;
 	ah->hw_version.devid = devid;
+	sc->sc_ah = ah;
 
 	r = ath9k_hw_attach(ah, sc);
 	if (r) {
@@ -1340,7 +1341,6 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 			"initialization status: %d\n", r);
 		goto bad;
 	}
-	sc->sc_ah = ah;
 
 	/* Get the hardware key cache size. */
 	sc->keymax = ah->caps.keycache_size;
-- 
1.6.3.3

