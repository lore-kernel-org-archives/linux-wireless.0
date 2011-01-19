Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:18976 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753897Ab1ASJU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 04:20:27 -0500
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0961838826
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 18:20:26 +0900 (JST)
Subject: [PATCH 4/8] ath5k: ath5k_setup_channels cleanup and whitespace
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jan 2011 18:20:52 +0900
Message-ID: <20110119092052.19628.61933.stgit@localhost6.localdomain6>
In-Reply-To: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove useless test_bit - it's not going to happen because of the way this
function is called only when that bit is set.

And fix some whitespace.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9e8b1f4..a28ad58 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -256,21 +256,16 @@ static bool ath5k_is_standard_channel(short chan)
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

