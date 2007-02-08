Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:51710 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423292AbXBHTss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 14:48:48 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] d80211: fix authentication issues
Date: Thu, 8 Feb 2007 14:48:15 -0500
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2847179.fGS6o7AlEG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702081448.19664.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2847179.fGS6o7AlEG
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

d80211: fix authentication issues

This patch prevents the MLME in d80211 from getting stuck when there is no
reply to authentication frames. It also allows the bssid to be correctly
set during IEEE80211_AUTHENTICATE.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/d80211/ieee80211_sta.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index feba62b..64dbc79 100644
=2D-- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -453,6 +453,7 @@ static void ieee80211_authenticate(struc
 		printk(KERN_DEBUG "%s: authentication with AP " MAC_FMT
 		       " timed out\n",
 		       dev->name, MAC_ARG(ifsta->bssid));
+		ifsta->state =3D IEEE80211_DISABLED;
 		return;
 	}
=20
@@ -668,6 +669,7 @@ static void ieee80211_associate(struct n
 		printk(KERN_DEBUG "%s: association with AP " MAC_FMT
 		       " timed out\n",
 		       dev->name, MAC_ARG(ifsta->bssid));
+		ifsta->state =3D IEEE80211_DISABLED;
 		return;
 	}
=20
@@ -677,6 +679,7 @@ static void ieee80211_associate(struct n
 	if (ieee80211_privacy_mismatch(dev, ifsta)) {
 		printk(KERN_DEBUG "%s: mismatch in privacy configuration and "
 		       "mixed-cell disabled - abort association\n", dev->name);
+		ifsta->state =3D IEEE80211_DISABLED;
 		return;
 	}
=20
@@ -2355,7 +2358,7 @@ int ieee80211_sta_set_bssid(struct net_d
 		ifsta->bssid_set =3D 0;
 	else
 		ifsta->bssid_set =3D 1;
=2D	if (ifsta->ssid_set && ifsta->state !=3D IEEE80211_AUTHENTICATE)
+	if (ifsta->ssid_set)
 		ieee80211_sta_new_auth(dev, ifsta);
=20
 	return 0;

--nextPart2847179.fGS6o7AlEG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFy36DT3Oqt9AH4aERAhd3AKCd3Tlm/cUmrjmNfm7H3vDVoq2TBgCfTylE
tl+tgcHWSCcjOhH68jWHzhA=
=bb+9
-----END PGP SIGNATURE-----

--nextPart2847179.fGS6o7AlEG--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
