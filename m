Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34825 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbZHCTZ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:27 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:29 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 23/24] ath9k: remove dangling error check on keycache reset on hw init
Date: Mon, 3 Aug 2009 12:24:55 -0700
Message-ID: <1249327496-24629-24-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The keycache reset will not fail as right above we ensure
to set the sc->keymax to be <= ah->caps.keycache_size. Just remove
this dangling check.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a5475b7..7f412dd 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1363,9 +1363,6 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc)
 	for (i = 0; i < sc->keymax; i++)
 		ath9k_hw_keyreset(ah, (u16) i);
 
-	if (r)
-		goto bad;
-
 	/* default to MONITOR mode */
 	sc->sc_ah->opmode = NL80211_IFTYPE_MONITOR;
 
-- 
1.6.3.3

