Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:24178 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752393AbYASJSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 04:18:30 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 3/3] ath5k: configure backoff for IBSS beacon queue
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Sat, 19 Jan 2008 18:18:41 +0900
Message-ID: <20080119091841.31251.16946.stgit@one> (sfid-20080119_091838_045369_2DB45280)
In-Reply-To: <20080119091759.31251.60264.stgit@one>
References: <20080119091759.31251.60264.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

in "11.1.2.2 Beacon generation in an IBSS" the IEEE802.11 standard says=
, each
STA should... "b) Calculate a random delay uniformly distributed in the=
 range
between zero and twice aCWmin =C3=97 aSlotTime,".

configure cwmin and cwmax of the beacon queue in IBSS mode according to=
 this.
unfortunately beacon backoff does not work reliably yet, so i suspect w=
e have a
problem somewhere else, since the same settings (and similar beacon tim=
er
configuration) work for madwifi.

drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Claus=
e-BSD

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 drivers/net/wireless/ath5k/base.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)


diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/a=
th5k/base.c
index a47e0f3..5bb1b04 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1447,8 +1447,7 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 	ret =3D ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
 	if (ret)
 		return ret;
-	if (sc->opmode =3D=3D IEEE80211_IF_TYPE_AP ||
-	    sc->opmode =3D=3D IEEE80211_IF_TYPE_IBSS) {
+	if (sc->opmode =3D=3D IEEE80211_IF_TYPE_AP) {
 		/*
 		 * Always burst out beacon and CAB traffic
 		 * (aifs =3D cwmin =3D cwmax =3D 0)
@@ -1456,8 +1455,19 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 		qi.tqi_aifs =3D 0;
 		qi.tqi_cw_min =3D 0;
 		qi.tqi_cw_max =3D 0;
+	} else if (sc->opmode =3D=3D IEEE80211_IF_TYPE_IBSS) {
+		/*
+		 * Adhoc mode; backoff between 0 and (2 * cw_min).
+		 */
+		qi.tqi_aifs =3D 0;
+		qi.tqi_cw_min =3D 0;
+		qi.tqi_cw_max =3D 2 * ah->ah_cw_min;
 	}
=20
+	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
+		"beacon queueprops tqi_aifs:%d tqi_cw_min:%d tqi_cw_max:%d\n",
+		qi.tqi_aifs, qi.tqi_cw_min, qi.tqi_cw_max);
+
 	ret =3D ath5k_hw_setup_tx_queueprops(ah, sc->bhalq, &qi);
 	if (ret) {
 		ATH5K_ERR(sc, "%s: unable to update parameters for beacon "

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
