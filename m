Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:41755 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3LWHT1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 02:19:27 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [RFC 1/9] ath9k: Fix max AMPDU size calculation
Date: Mon, 23 Dec 2013 12:44:18 +0530
Message-Id: <1387782866-19847-2-git-send-email-sujith@msujith.org> (sfid-20131223_081931_900425_9CE8F66E)
In-Reply-To: <1387782866-19847-1-git-send-email-sujith@msujith.org>
References: <1387782866-19847-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The maximum A-MPDU size is calculated in ath_tx_aggr_start(),
so there is no need to do it in node_attach() too. Also, make
sure that the correct size is calculated as described in
8.4.2.58.3.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 6 ------
 drivers/net/wireless/ath/ath9k/xmit.c | 9 ++-------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 21b764b..dd9bad2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -427,12 +427,6 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 	an->vif = vif;
 
 	ath_tx_node_init(sc, an);
-
-	if (sta->ht_cap.ht_supported) {
-		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
-				     sta->ht_cap.ampdu_factor);
-		an->mpdudensity = ath9k_parse_mpdudensity(sta->ht_cap.ampdu_density);
-	}
 }
 
 static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 9d735c5..e8d0e7f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -774,11 +774,6 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	if (bt_aggr_limit)
 		aggr_limit = bt_aggr_limit;
 
-	/*
-	 * h/w can accept aggregates up to 16 bit lengths (65535).
-	 * The IE, however can hold up to 65536, which shows up here
-	 * as zero. Ignore 65536 since we  are constrained by hw.
-	 */
 	if (tid->an->maxampdu)
 		aggr_limit = min(aggr_limit, tid->an->maxampdu);
 
@@ -1403,8 +1398,8 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 	 * has already been added.
 	 */
 	if (sta->ht_cap.ht_supported) {
-		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
-				     sta->ht_cap.ampdu_factor);
+		an->maxampdu = (1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
+				      sta->ht_cap.ampdu_factor)) - 1;
 		density = ath9k_parse_mpdudensity(sta->ht_cap.ampdu_density);
 		an->mpdudensity = density;
 	}
-- 
1.8.5.2

