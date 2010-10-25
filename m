Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38043 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab0JYHQL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 03:16:11 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 00:16:00 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<j@w1.fi>, <Senthilkumar.Balasubramanian@Atheros.com>,
	<Vasanth.Thiagarajan@Atheros.com>, <nbd@openwrt.org>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: Properly assign boolean types Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Date: Mon, 25 Oct 2010 12:46:01 +0530
Message-ID: <1287990961-2619-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

---
 drivers/net/wireless/ath/ath9k/rc.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 0cee90c..0c70839 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1444,12 +1444,15 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		ath_rc_priv->neg_ht_rates.rs_nrates = j;
 	}
 
-	is_cw40 = sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	is_cw40 = (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ?
+		true : false;
 
 	if (is_cw40)
-		is_sgi = sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40;
+		is_sgi = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
+			true : false;
 	else if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_SGI_20)
-		is_sgi = sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20;
+		is_sgi = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
+			true : false
 
 	/* Choose rate table first */
 
-- 
1.7.0.4

