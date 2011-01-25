Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:23710 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752559Ab1AYEP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 23:15:28 -0500
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0369478923
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 13:15:26 +0900 (JST)
Subject: [PATCH 1/6] ath5k: ath5k_setup_channels cleanup and whitespace
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 25 Jan 2011 13:15:22 +0900
Message-ID: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove useless test_bit - it's not going to happen because of the way this
function is called only when that bit is set.

And fix some whitespace.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Acked-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>

---

Has this been lost from my last series?
---
 drivers/net/wireless/ath/ath5k/base.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 14377ac..dae0bdc 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -262,21 +262,16 @@ static bool ath5k_is_standard_channel(short chan, enum ieee80211_band band)
 }
 
 static unsigned int
-ath5k_setup_channels(struct ath5k_hw *ah,
-		struct ieee80211_channel *channels,
-		unsigned int mode,
-		unsigned int max)
+ath5k_setup_channels(struct ath5k_hw *ah, struct ieee80211_channel *channels,
+		unsigned int mode, unsigned int max)
 {
 	unsigned int count, size, chfreq, freq, ch;
 	enum ieee80211_band band;
 
-	if (!test_bit(mode, ah->ah_modes))
-		return 0;
-
 	switch (mode) {
 	case AR5K_MODE_11A:
 		/* 1..220, but 2GHz frequencies are filtered by check_channel */
-		size = 220 ;
+		size = 220;
 		chfreq = CHANNEL_5GHZ;
 		band = IEEE80211_BAND_5GHZ;
 		break;

