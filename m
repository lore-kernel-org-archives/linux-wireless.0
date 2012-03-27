Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10207 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2C0Ejl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 00:39:41 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20337.17503.790777.715110@gargle.gargle.HOWL> (sfid-20120327_063944_595706_EA0A017B)
Date: Tue, 27 Mar 2012 10:08:55 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Use HW HT capabilites properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k: Remove aggregation flags" changed how
nodes were being initialized. Use the HW HT cap bits
to initialize/de-initialize nodes, else we would be
accessing an uninitialized entry during a suspend/resume cycle,
resulting in a panic.

Reported-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3879485..215eb25 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -640,7 +640,7 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 	an->sta = sta;
 	an->vif = vif;
 
-	if (sta->ht_cap.ht_supported) {
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		ath_tx_node_init(sc, an);
 		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
 				     sta->ht_cap.ampdu_factor);
@@ -659,7 +659,7 @@ static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 	an->sta = NULL;
 #endif
 
-	if (sta->ht_cap.ht_supported)
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		ath_tx_node_cleanup(sc, an);
 }
 
-- 
1.7.9.4

