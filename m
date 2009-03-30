Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25188 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267AbZC3KC7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:02:59 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:02:58 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38872.5661.745853@gargle.gargle.HOWL> (sfid-20090330_120318_101694_47BEA5E9)
Date: Mon, 30 Mar 2009 15:28:48 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 14/17] ath9k: Trivial fix to handle AMPDU params properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle aggregation params only when aggregation is
supported.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 6db2131..d8b7993 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -434,12 +434,12 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 
 	an = (struct ath_node *)sta->drv_priv;
 
-	if (sc->sc_flags & SC_OP_TXAGGR)
+	if (sc->sc_flags & SC_OP_TXAGGR) {
 		ath_tx_node_init(sc, an);
-
-	an->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
-			     sta->ht_cap.ampdu_factor);
-	an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
+		an->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
+				     sta->ht_cap.ampdu_factor);
+		an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
+	}
 }
 
 static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
-- 
1.6.2.1

