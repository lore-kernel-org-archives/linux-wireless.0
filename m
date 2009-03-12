Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16888 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbZCLGdL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 02:33:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2009 23:33:10 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18872.43949.609938.833705@gargle.gargle.HOWL> (sfid-20090312_073315_159443_D751B78E)
Date: Thu, 12 Mar 2009 11:59:01 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH/REVIEW] ath9k: Fix bug in handling single stream stations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP mode currently sets up the dual stream capability
for all stations. This patch fixes it by checking if the
associated station supports dual stream MCS rates (8-15).

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 8327356..9bc4f72 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1468,16 +1468,18 @@ static void ath_rc_init(struct ath_softc *sc,
 		ath_rc_priv->ht_cap);
 }
 
-static u8 ath_rc_build_ht_caps(struct ath_softc *sc, bool is_ht, bool is_cw40,
-			       bool is_sgi40)
+static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta,
+			       bool is_cw40, bool is_sgi40)
 {
 	u8 caps = 0;
 
-	if (is_ht) {
+	if (sta->ht_cap.ht_supported) {
 		caps = WLAN_RC_HT_FLAG;
 		if (sc->sc_ah->caps.tx_chainmask != 1 &&
-		    ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_DS, 0, NULL))
-			caps |= WLAN_RC_DS_FLAG;
+		    ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_DS, 0, NULL)) {
+			if(sta->ht_cap.mcs.rx_mask[1])
+				caps |= WLAN_RC_DS_FLAG;
+		}
 		if (is_cw40)
 			caps |= WLAN_RC_40_FLAG;
 		if (is_sgi40)
@@ -1624,8 +1626,7 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		rate_table = sc->cur_rate_table;
 	}
 
-	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta->ht_cap.ht_supported,
-						   is_cw40, is_sgi40);
+	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta, is_cw40, is_sgi40);
 	ath_rc_init(sc, priv_sta, sband, sta, rate_table);
 }
 
@@ -1659,8 +1660,7 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 			rate_table = ath_choose_rate_table(sc, sband->band,
 						   sta->ht_cap.ht_supported,
 						   oper_cw40);
-			ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc,
-						   sta->ht_cap.ht_supported,
+			ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta,
 						   oper_cw40, oper_sgi40);
 			ath_rc_init(sc, priv_sta, sband, sta, rate_table);
 
-- 
1.6.2

