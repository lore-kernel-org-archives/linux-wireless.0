Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36679 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751332AbZA1PaP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 10:30:15 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Wed, 28 Jan 2009 16:30:12 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090128153012.138700@gmx.net> (sfid-20090128_163020_284083_7710C01F)
MIME-Version: 1.0
Subject: [PATCH v2] mac80211: Creating new IBSS with fixed BSSID
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a bug when creating a new IBSS network with a fixed BSSID. T=
he fixed BSSID situation is now with one of my last patches handled in =
ieee80211_sta_find_ibss() function.

It's more robust to test against (ifsta->flags & IEEE80211_STA_PREV_BSS=
ID_SET), because ifsta->state is not seted right in every situation and=
 so the creating of the new IBSS network sometimes hangs after the firs=
t try to scan for a network to merge.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urN wireless-testing.orig/net/mac80211/mlme.c wireless-testing/ne=
t/mac80211/mlme.c
--- wireless-testing.orig/net/mac80211/mlme.c	2009-01-27 05:12:43.00000=
0000 +0000
+++ wireless-testing/net/mac80211/mlme.c	2009-01-28 15:47:19.000000000 =
+0000
@@ -2720,9 +2720,8 @@
=20
 	if (sdata && sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC) {
 		ifsta =3D &sdata->u.sta;
-		if (!(ifsta->flags & IEEE80211_STA_BSSID_SET) ||
-		    (!(ifsta->state =3D=3D IEEE80211_STA_MLME_IBSS_JOINED) &&
-		    !ieee80211_sta_active_ibss(sdata)))
+		if ((!(ifsta->flags & IEEE80211_STA_PREV_BSSID_SET)) ||
+		    !ieee80211_sta_active_ibss(sdata))
 			ieee80211_sta_find_ibss(sdata, ifsta);
 	}
=20

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
