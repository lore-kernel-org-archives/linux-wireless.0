Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3889 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbZD1CNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2009 22:13:04 -0400
Date: Mon, 27 Apr 2009 22:12:43 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.30] ath5k: fix buffer overrun in rate debug code
Message-ID: <20090428021243.GA16292@hash.localnet> (sfid-20090428_041311_963267_86F3DB2F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


char bname[5] is too small for the string "X GHz" when the null
terminator is taken into account.  Thus, turning on rate debugging
can crash unless we have lucky stack alignment.

Cc: stable@kernel.org
Reported-by: Paride Legovini <legovini@spiro.fisica.unipd.it>
Signed-off-by: Bob Copeland <me@bobcopeland.com>

---
John, this patch should probably go for 2.6.30, I'll send a version for
wireless-testing next.

 drivers/net/wireless/ath5k/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index 9770bb3..4904a07 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -424,7 +424,7 @@ ath5k_debug_dump_bands(struct ath5k_softc *sc)
 
 	for (b = 0; b < IEEE80211_NUM_BANDS; b++) {
 		struct ieee80211_supported_band *band = &sc->sbands[b];
-		char bname[5];
+		char bname[6];
 		switch (band->band) {
 		case IEEE80211_BAND_2GHZ:
 			strcpy(bname, "2 GHz");
-- 
1.6.0.6

-- 
Bob Copeland %% www.bobcopeland.com

