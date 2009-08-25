Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3175 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbZHYDBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 23:01:36 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/4] ath5k: clean up filter flags setting
Date: Mon, 24 Aug 2009 23:00:30 -0400
Message-Id: <1251169233-24169-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1251169233-24169-1-git-send-email-me@bobcopeland.com>
References: <1251169233-24169-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The maze of if() statements in configure_filter is confusing.
Reorganizing it as a switch statement makes it more apparent what
is going on and reveals several suspicious settings.  This has no
functional changes, though it does remove some redundant flags
that are set earlier.

Also now that we can sleep, protect sc->filter_flags with the
sc lock.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   39 +++++++++++++++++++-------------
 1 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 5056410..c4adf98 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2918,6 +2918,8 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 	struct ath5k_hw *ah = sc->ah;
 	u32 mfilt[2], rfilt;
 
+	mutex_lock(&sc->lock);
+
 	mfilt[0] = multicast;
 	mfilt[1] = multicast >> 32;
 
@@ -2968,22 +2970,25 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 
 	/* XXX move these to mac80211, and add a beacon IFF flag to mac80211 */
 
-	if (sc->opmode == NL80211_IFTYPE_MONITOR)
-		rfilt |= AR5K_RX_FILTER_CONTROL | AR5K_RX_FILTER_BEACON |
-			AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
-	if (sc->opmode != NL80211_IFTYPE_STATION)
-		rfilt |= AR5K_RX_FILTER_PROBEREQ;
-	if (sc->opmode != NL80211_IFTYPE_AP &&
-		sc->opmode != NL80211_IFTYPE_MESH_POINT &&
-		test_bit(ATH_STAT_PROMISC, sc->status))
-		rfilt |= AR5K_RX_FILTER_PROM;
-	if ((sc->opmode == NL80211_IFTYPE_STATION && sc->assoc) ||
-		sc->opmode == NL80211_IFTYPE_ADHOC ||
-		sc->opmode == NL80211_IFTYPE_AP)
-		rfilt |= AR5K_RX_FILTER_BEACON;
-	if (sc->opmode == NL80211_IFTYPE_MESH_POINT)
-		rfilt |= AR5K_RX_FILTER_CONTROL | AR5K_RX_FILTER_BEACON |
-			AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
+	switch (sc->opmode) {
+	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_MONITOR:
+		rfilt |= AR5K_RX_FILTER_CONTROL |
+			 AR5K_RX_FILTER_BEACON |
+			 AR5K_RX_FILTER_PROBEREQ |
+			 AR5K_RX_FILTER_PROM;
+		break;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
+		rfilt |= AR5K_RX_FILTER_PROBEREQ |
+			 AR5K_RX_FILTER_BEACON;
+		break;
+	case NL80211_IFTYPE_STATION:
+		if (sc->assoc)
+			rfilt |= AR5K_RX_FILTER_BEACON;
+	default:
+		break;
+	}
 
 	/* Set filters */
 	ath5k_hw_set_rx_filter(ah, rfilt);
@@ -2993,6 +2998,8 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 	/* Set the cached hw filter flags, this will alter actually
 	 * be set in HW */
 	sc->filter_flags = rfilt;
+
+	mutex_unlock(&sc->lock);
 }
 
 static int
-- 
1.6.2.5


