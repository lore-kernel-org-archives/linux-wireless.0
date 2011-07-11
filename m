Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15408 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1GKOoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 10:44:22 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k: remove an unnecessary function declaration
Date: Mon, 11 Jul 2011 20:14:14 +0530
Message-ID: <1310395454-2645-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110711_164426_654250_62F1363D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   50 ++++++++++++++++------------------
 1 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index e7fe4d9..c04a6c3 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -379,7 +379,30 @@ static const struct ath_rate_table ar5416_11g_ratetable = {
 };
 
 static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
-				struct ieee80211_tx_rate *rate);
+				struct ieee80211_tx_rate *rate)
+{
+	int rix = 0, i = 0;
+	static const int mcs_rix_off[] = { 7, 15, 20, 21, 22, 23 };
+
+	if (!(rate->flags & IEEE80211_TX_RC_MCS))
+		return rate->idx;
+
+	while (i < ARRAY_SIZE(mcs_rix_off) && rate->idx > mcs_rix_off[i]) {
+		rix++; i++;
+	}
+
+	rix += rate->idx + rate_table->mcs_start;
+
+	if ((rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
+	    (rate->flags & IEEE80211_TX_RC_SHORT_GI))
+		rix = rate_table->info[rix].ht_index;
+	else if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
+		rix = rate_table->info[rix].sgi_index;
+	else if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		rix = rate_table->info[rix].cw40index;
+
+	return rix;
+}
 
 static void ath_rc_sort_validrates(const struct ath_rate_table *rate_table,
 				   struct ath_rate_priv *ath_rc_priv)
@@ -1080,31 +1103,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 
 }
 
-static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
-				struct ieee80211_tx_rate *rate)
-{
-	int rix = 0, i = 0;
-	static const int mcs_rix_off[] = { 7, 15, 20, 21, 22, 23 };
-
-	if (!(rate->flags & IEEE80211_TX_RC_MCS))
-		return rate->idx;
-
-	while (i < ARRAY_SIZE(mcs_rix_off) && rate->idx > mcs_rix_off[i]) {
-		rix++; i++;
-	}
-
-	rix += rate->idx + rate_table->mcs_start;
-
-	if ((rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
-	    (rate->flags & IEEE80211_TX_RC_SHORT_GI))
-		rix = rate_table->info[rix].ht_index;
-	else if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
-		rix = rate_table->info[rix].sgi_index;
-	else if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-		rix = rate_table->info[rix].cw40index;
-
-	return rix;
-}
 
 static void ath_rc_tx_status(struct ath_softc *sc,
 			     struct ath_rate_priv *ath_rc_priv,
-- 
1.7.0.4

