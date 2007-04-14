Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:26307 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752105AbXDNATv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2007 20:19:51 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] mac80211: remove redundant rssi information in scan results
Date: Fri, 13 Apr 2007 20:16:54 -0400
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1997526.Q5WLYMUuz1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704132016.59165.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1997526.Q5WLYMUuz1
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

mac80211: remove redundant rssi information in scan results

=46rom: Michael Wu <flamingice@sourmilk.net>

rssi is already reported in IWEVQUAL. Remove the custom event that also
reported rssi.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/mac80211/ieee80211_sta.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 2678b95..1648c76 100644
=2D-- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -3047,13 +3047,6 @@ ieee80211_sta_scan_result(struct net_device *dev,
=20
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd =3D IWEVCUSTOM;
=2D		sprintf(buf, "rssi=3D%d", bss->rssi);
=2D		iwe.u.data.length =3D strlen(buf);
=2D		current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe,
=2D						  buf);
=2D
=2D		memset(&iwe, 0, sizeof(iwe));
=2D		iwe.cmd =3D IWEVCUSTOM;
 		sprintf(buf, "capab=3D0x%04x", bss->capability);
 		iwe.u.data.length =3D strlen(buf);
 		current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe,

--nextPart1997526.Q5WLYMUuz1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGIB17T3Oqt9AH4aERAi2NAJsHYImRSbzDQpHy3bKzQMvI0gGySwCdFl4h
UIKkQOew4mhij6zkxP0XvbI=
=bwlV
-----END PGP SIGNATURE-----

--nextPart1997526.Q5WLYMUuz1--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
