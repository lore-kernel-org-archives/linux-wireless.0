Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23002 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab0JZP7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 11:59:05 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 08:58:54 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<greearb@candelatech.com>, <me@bobcopeland.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH v2] ath9k: Properly assign boolean types
Date: Tue, 26 Oct 2010 21:28:57 +0530
Message-ID: <1288108737-27781-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

This takes care that boolean types are properly assigned

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 0cee90c..69d54fa 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1444,12 +1444,12 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		ath_rc_priv->neg_ht_rates.rs_nrates = j;
 	}
 
-	is_cw40 = sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	is_cw40 = !!(sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40);
 
 	if (is_cw40)
-		is_sgi = sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40;
+		is_sgi = !!(sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40);
 	else if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_SGI_20)
-		is_sgi = sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20;
+		is_sgi = !!(sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20);
 
 	/* Choose rate table first */
 
@@ -1468,10 +1468,8 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
 	const struct ath_rate_table *rate_table = NULL;
 	bool oper_cw40 = false, oper_sgi;
-	bool local_cw40 = (ath_rc_priv->ht_cap & WLAN_RC_40_FLAG) ?
-		true : false;
-	bool local_sgi = (ath_rc_priv->ht_cap & WLAN_RC_SGI_FLAG) ?
-		true : false;
+	bool local_cw40 = !!(ath_rc_priv->ht_cap & WLAN_RC_40_FLAG);
+	bool local_sgi = !!(ath_rc_priv->ht_cap & WLAN_RC_SGI_FLAG);
 
 	/* FIXME: Handle AP mode later when we support CWM */
 
-- 
1.7.0.4

