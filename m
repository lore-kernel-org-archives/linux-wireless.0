Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49721 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755687AbZCBWNo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 17:13:44 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Mon, 02 Mar 2009 23:13:40 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090302221340.76770@gmx.net> (sfid-20090302_231348_924791_483067F8)
MIME-Version: 1.0
Subject: [PATCH v2] ath9k: Fix FIF_BCN_PRBRESP_PROMISC handling
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So that a new created IBSS network
doesn't break on the first scan.

It seems to Sujith and me that this
stupid code unnecessary, too.

So remove it...

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/a=
th9k/main.c
index f5f5739..e242852 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2396,14 +2396,6 @@ static void ath9k_configure_filter(struct ieee80=
211_hw *hw,
 	rfilt =3D ath_calcrxfilter(sc);
 	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
=20
-	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
-			memcpy(sc->curbssid, ath_bcast_mac, ETH_ALEN);
-			sc->curaid =3D 0;
-			ath9k_hw_write_associd(sc);
-		}
-	}
-
 	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", sc->rx.rxfilt=
er);
 }
=20

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
