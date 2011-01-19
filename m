Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:15291 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753899Ab1ASJUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 04:20:32 -0500
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0962258831
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 18:20:31 +0900 (JST)
Subject: [PATCH 5/8] ath5k: Add 802.11j 4.9GHz channels to allowed channels
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jan 2011 18:20:57 +0900
Message-ID: <20110119092057.19628.9296.stgit@localhost6.localdomain6>
In-Reply-To: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the 802.11j (20MHz channel width) channels to the allowed channels. This
still does not enable 802.11j in ath5k since these frequencies are out of the
configured range. A later patch will deal with that.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a28ad58..6900543 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -244,15 +244,21 @@ static int ath5k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *re
 /*
  * Returns true for the channel numbers used without all_channels modparam.
  */
-static bool ath5k_is_standard_channel(short chan)
+static bool ath5k_is_standard_channel(short chan, enum ieee80211_band band)
 {
-	return ((chan <= 14) ||
-		/* UNII 1,2 */
-		((chan & 3) == 0 && chan >= 36 && chan <= 64) ||
+	if (band == IEEE80211_BAND_2GHZ && chan <= 14)
+		return true;
+
+	return	/* UNII 1,2 */
+		(((chan & 3) == 0 && chan >= 36 && chan <= 64) ||
 		/* midband */
 		((chan & 3) == 0 && chan >= 100 && chan <= 140) ||
 		/* UNII-3 */
-		((chan & 3) == 1 && chan >= 149 && chan <= 165));
+		((chan & 3) == 1 && chan >= 149 && chan <= 165) ||
+		/* 802.11j 5.030-5.080 GHz (20MHz) */
+		(chan == 8 || chan == 12 || chan == 16) ||
+		/* 802.11j 4.9GHz (20MHz) */
+		(chan == 184 || chan == 188 || chan == 192 || chan == 196));
 }
 
 static unsigned int
@@ -291,7 +297,8 @@ ath5k_setup_channels(struct ath5k_hw *ah, struct ieee80211_channel *channels,
 		if (!ath5k_channel_ok(ah, freq, chfreq))
 			continue;
 
-		if (!modparam_all_channels && !ath5k_is_standard_channel(ch))
+		if (!modparam_all_channels &&
+		    !ath5k_is_standard_channel(ch, band))
 			continue;
 
 		/* Write channel info and increment counter */

