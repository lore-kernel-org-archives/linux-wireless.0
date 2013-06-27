Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:55877 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab3F0Mom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 08:44:42 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4 14/18] ath9k: set 5/10 MHz supported channels and fix bitrate
Date: Thu, 27 Jun 2013 14:44:20 +0200
Message-Id: <1372337064-19254-15-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130627_144504_707181_9FF937C8)
In-Reply-To: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/init.c |   24 ++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/rc.c   |    6 ++++++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index d0d3d2a..96b0d29 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -146,14 +146,22 @@ static struct ieee80211_rate ath9k_legacy_rates[] = {
 	RATE(20, 0x1a, IEEE80211_RATE_SHORT_PREAMBLE),
 	RATE(55, 0x19, IEEE80211_RATE_SHORT_PREAMBLE),
 	RATE(110, 0x18, IEEE80211_RATE_SHORT_PREAMBLE),
-	RATE(60, 0x0b, 0),
-	RATE(90, 0x0f, 0),
-	RATE(120, 0x0a, 0),
-	RATE(180, 0x0e, 0),
-	RATE(240, 0x09, 0),
-	RATE(360, 0x0d, 0),
-	RATE(480, 0x08, 0),
-	RATE(540, 0x0c, 0),
+	RATE(60, 0x0b, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(90, 0x0f, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(120, 0x0a, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			 IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(180, 0x0e, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			 IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(240, 0x09, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			 IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(360, 0x0d, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			 IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(480, 0x08, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			 IEEE80211_RATE_SUPPORTS_10MHZ)),
+	RATE(540, 0x0c, (IEEE80211_RATE_SUPPORTS_5MHZ |
+			 IEEE80211_RATE_SUPPORTS_10MHZ)),
 };
 
 #ifdef CONFIG_MAC80211_LEDS
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index e41f563..028a376 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1282,9 +1282,15 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
 	int i, j = 0;
+	int divisor = ieee80211_chandef_get_divisor(sc->hw->conf.chandef);
+	u32 rate_flags = ieee80211_chandef_rate_flags(&sc->hw->conf.chandef);
 
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if (sta->supp_rates[sband->band] & BIT(i)) {
+			if ((rate_flags & sband->bitrates[i].flags)
+			    != rate_flags)
+				continue;
+
 			ath_rc_priv->neg_rates.rs_rates[j]
 				= (sband->bitrates[i].bitrate * 2) / 10;
 			j++;
-- 
1.7.10.4

