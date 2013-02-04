Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:40817 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab3BDKJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 05:09:40 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ath9k: Fix ATH9K_HW_CAP_HT usage
Date: Mon,  4 Feb 2013 15:38:23 +0530
Message-Id: <1359972504-8900-2-git-send-email-sujith@msujith.org> (sfid-20130204_110945_189040_201E3B87)
In-Reply-To: <1359972504-8900-1-git-send-email-sujith@msujith.org>
References: <1359972504-8900-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

There are a few places where the station's HT capabilities
should be checked instead of ATH9K_HW_CAP_HT, which is a global
feature for the driver. Fix this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 13 +++++--------
 drivers/net/wireless/ath/ath9k/xmit.c |  5 ++---
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5432f12..6e66f9c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -320,28 +320,25 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 			    struct ieee80211_vif *vif)
 {
 	struct ath_node *an;
-	u8 density;
 	an = (struct ath_node *)sta->drv_priv;
 
 	an->sc = sc;
 	an->sta = sta;
 	an->vif = vif;
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
-		ath_tx_node_init(sc, an);
+	ath_tx_node_init(sc, an);
+
+	if (sta->ht_cap.ht_supported) {
 		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
 				     sta->ht_cap.ampdu_factor);
-		density = ath9k_parse_mpdudensity(sta->ht_cap.ampdu_density);
-		an->mpdudensity = density;
+		an->mpdudensity = ath9k_parse_mpdudensity(sta->ht_cap.ampdu_density);
 	}
 }
 
 static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 {
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
-
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
-		ath_tx_node_cleanup(sc, an);
+	ath_tx_node_cleanup(sc, an);
 }
 
 void ath9k_tasklet(unsigned long data)
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index feacaaf..89a6441 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1233,7 +1233,7 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 	 * in HT IBSS when a beacon with HT-info is received after the station
 	 * has already been added.
 	 */
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
+	if (sta->ht_cap.ht_supported) {
 		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
 				     sta->ht_cap.ampdu_factor);
 		density = ath9k_parse_mpdudensity(sta->ht_cap.ampdu_density);
@@ -1904,8 +1904,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 	struct ath_buf *bf;
 	u8 tidno;
 
-	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) && txctl->an &&
-		ieee80211_is_data_qos(hdr->frame_control)) {
+	if (txctl->an && ieee80211_is_data_qos(hdr->frame_control)) {
 		tidno = ieee80211_get_qos_ctl(hdr)[0] &
 			IEEE80211_QOS_CTL_TID_MASK;
 		tid = ATH_AN_2_TID(txctl->an, tidno);
-- 
1.8.1.2

