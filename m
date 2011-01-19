Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:23113 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753885Ab1ASJUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 04:20:11 -0500
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0118318810
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 18:20:10 +0900 (JST)
Subject: [PATCH 1/8] ath5k: Use mac80211 channel mapping function
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jan 2011 18:20:36 +0900
Message-ID: <20110119092036.19628.84273.stgit@localhost6.localdomain6>
In-Reply-To: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use mac80211 channel mapping function instead of own homegrown version.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 09ae4ef..6850112 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -242,18 +242,6 @@ static int ath5k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *re
 \********************/
 
 /*
- * Convert IEEE channel number to MHz frequency.
- */
-static inline short
-ath5k_ieee2mhz(short chan)
-{
-	if (chan <= 14 || chan >= 27)
-		return ieee80211chan2mhz(chan);
-	else
-		return 2212 + chan * 20;
-}
-
-/*
  * Returns true for the channel numbers used without all_channels modparam.
  */
 static bool ath5k_is_standard_channel(short chan)
@@ -274,6 +262,7 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 		unsigned int max)
 {
 	unsigned int i, count, size, chfreq, freq, ch;
+	enum ieee80211_band band;
 
 	if (!test_bit(mode, ah->ah_modes))
 		return 0;
@@ -283,11 +272,13 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 		/* 1..220, but 2GHz frequencies are filtered by check_channel */
 		size = 220 ;
 		chfreq = CHANNEL_5GHZ;
+		band = IEEE80211_BAND_5GHZ;
 		break;
 	case AR5K_MODE_11B:
 	case AR5K_MODE_11G:
 		size = 26;
 		chfreq = CHANNEL_2GHZ;
+		band = IEEE80211_BAND_2GHZ;
 		break;
 	default:
 		ATH5K_WARN(ah->ah_sc, "bad mode, not copying channels\n");
@@ -296,7 +287,10 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 
 	for (i = 0, count = 0; i < size && max > 0; i++) {
 		ch = i + 1 ;
-		freq = ath5k_ieee2mhz(ch);
+		freq = ieee80211_channel_to_frequency(ch, band);
+
+		if (freq == 0) /* mapping failed - not a standard channel */
+			continue;
 
 		/* Check if channel is supported by the chipset */
 		if (!ath5k_channel_ok(ah, freq, chfreq))
@@ -307,8 +301,7 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 
 		/* Write channel info and increment counter */
 		channels[count].center_freq = freq;
-		channels[count].band = (chfreq == CHANNEL_2GHZ) ?
-			IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+		channels[count].band = band;
 		switch (mode) {
 		case AR5K_MODE_11A:
 		case AR5K_MODE_11G:

