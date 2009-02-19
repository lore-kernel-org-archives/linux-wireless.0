Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56286 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754443AbZBSWqd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 17:46:33 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Thu, 19 Feb 2009 23:46:31 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090219224631.322560@gmx.net> (sfid-20090219_234639_207886_DD521032)
MIME-Version: 1.0
Subject: [PATCH] ath9k: Don't reset TSF after scanning automatically
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reset automatically the TSF on re-enabling beaconing after scanning in =
IBSS mode causes several problems. For example a new created IBSS netwo=
rk can't age before an other node has joined, because scans are done au=
tomatically in that case. And several other strange bugs more...

The TSF reset is done manually in the higher level mac80211 code in the=
 cases were it's needed, so we don't need to do it here.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless=
/ath9k/beacon.c
index 390d510..18bda36 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -790,8 +790,6 @@ void ath_beacon_config(struct ath_softc *sc, int if=
_id)
 		u64 tsf;
 		u32 tsftu;
 		ath9k_hw_set_interrupts(ah, 0);
-		if (nexttbtt =3D=3D intval)
-			intval |=3D ATH9K_BEACON_RESET_TSF;
 		if (sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_ADHOC) {
 			/*
 			 * Pull nexttbtt forward to reflect the current
@@ -825,6 +823,9 @@ void ath_beacon_config(struct ath_softc *sc, int if=
_id)
 				sc->imask |=3D ATH9K_INT_SWBA;
 			ath_beaconq_config(sc);
 		} else if (sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_AP) {
+			if (nexttbtt =3D=3D intval)
+				intval |=3D ATH9K_BEACON_RESET_TSF;
+
 			/*
 			 * In AP mode we enable the beacon timers and
 			 * SWBA interrupts to prepare beacon frames.

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
