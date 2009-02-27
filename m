Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46482 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760729AbZB0WCS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 17:02:18 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 27 Feb 2009 23:02:15 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090227220215.254900@gmx.net> (sfid-20090227_230235_228364_84EE0888)
MIME-Version: 1.0
Subject: [PATCH] ath9k: Fix FIF_BCN_PRBRESP_PROMISC handling
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So that a new created IBSS network
doesn't break on the first scan.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath=
9k/hw.c
index 2acbb84..cedf00a 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -3696,9 +3696,18 @@ void ath9k_hw_setbssidmask(struct ath_softc *sc)
=20
 void ath9k_hw_write_associd(struct ath_softc *sc)
 {
-	REG_WRITE(sc->sc_ah, AR_BSS_ID0, get_unaligned_le32(sc->curbssid));
-	REG_WRITE(sc->sc_ah, AR_BSS_ID1, get_unaligned_le16(sc->curbssid + 4)=
 |
-		  ((sc->curaid & 0x3fff) << AR_BSS_ID1_AID_S));
+	const u8 *curbssid =3D sc->curbssid;
+	u16 curaid =3D sc->curaid;
+
+	/* implement FIF_BCN_PRBRESP_PROMISC handling */
+	if(sc->sc_ah->bcn_prbresp_promisc) {
+		curbssid =3D ath_bcast_mac;
+		curaid =3D 0;
+	}
+
+	REG_WRITE(sc->sc_ah, AR_BSS_ID0, get_unaligned_le32(curbssid));
+	REG_WRITE(sc->sc_ah, AR_BSS_ID1, get_unaligned_le16(curbssid + 4) |
+		  ((curaid & 0x3fff) << AR_BSS_ID1_AID_S));
 }
=20
 u64 ath9k_hw_gettsf64(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath=
9k/hw.h
index 5ec416b..4d930c7 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -441,6 +441,7 @@ struct ath_hw {
 	u32 btactive_gpio;
 	u32 wlanactive_gpio;
 	u32 ah_flags;
+	bool bcn_prbresp_promisc;
=20
 	enum nl80211_iftype opmode;
 	enum ath9k_power_mode power_mode;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/a=
th9k/main.c
index f5f5739..c0d5336 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2397,11 +2397,12 @@ static void ath9k_configure_filter(struct ieee8=
0211_hw *hw,
 	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
=20
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
-			memcpy(sc->curbssid, ath_bcast_mac, ETH_ALEN);
-			sc->curaid =3D 0;
-			ath9k_hw_write_associd(sc);
-		}
+		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
+			sc->sc_ah->bcn_prbresp_promisc =3D true;
+		else
+			sc->sc_ah->bcn_prbresp_promisc =3D false;
+
+		ath9k_hw_write_associd(sc);
 	}
=20
 	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", sc->rx.rxfilt=
er);

--=20
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
f=FCr nur 17,95 =BF/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
