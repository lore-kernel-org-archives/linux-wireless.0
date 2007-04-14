Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:21285 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754170AbXDNBmG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2007 21:42:06 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] mac80211: Always report supported rates in scan results
Date: Fri, 13 Apr 2007 21:39:07 -0400
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3873556.pkFQHF5SQA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704132139.12080.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3873556.pkFQHF5SQA
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

mac80211: Always report supported rates in scan results

=46rom: Michael Wu <flamingice@sourmilk.net>

This makes mac80211 always report supported rates in the scan results.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/mac80211/ieee80211_sta.c |   38 ++++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 1648c76..fc43b24 100644
=2D-- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -3013,6 +3013,25 @@ ieee80211_sta_scan_result(struct net_device *dev,
 						  bss->rsn_ie);
 	}
=20
+	if (bss && bss->supp_rates_len > 0) {
+		/* display all supported rates in readable format */
+		char *p =3D current_ev + IW_EV_LCP_LEN;
+		int i;
+
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd =3D SIOCGIWRATE;
+		/* Those two flags are ignored... */
+		iwe.u.bitrate.fixed =3D iwe.u.bitrate.disabled =3D 0;
+
+		for (i =3D 0; i < bss->supp_rates_len; i++) {
+			iwe.u.bitrate.value =3D ((bss->supp_rates[i] &
+							0x7f) * 500000);
+			p =3D iwe_stream_add_value(current_ev, p,
+					end_buf, &iwe, IW_EV_PARAM_LEN);
+		}
+		current_ev =3D p;
+	}
+
 	if (bss) {
 		char *buf;
 		buf =3D kmalloc(30, GFP_ATOMIC);
@@ -3028,8 +3047,7 @@ ieee80211_sta_scan_result(struct net_device *dev,
 	}
=20
 	do {
=2D		char *buf, *p;
=2D		int i;
+		char *buf;
=20
 		if (!(local->scan_flags & IEEE80211_SCAN_EXTRA_INFO))
 			break;
@@ -3052,22 +3070,6 @@ ieee80211_sta_scan_result(struct net_device *dev,
 		current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe,
 						  buf);
=20
=2D		/* dispaly all support rates in readable format */
=2D		p =3D current_ev + IW_EV_LCP_LEN;
=2D		iwe.cmd =3D SIOCGIWRATE;
=2D		/* Those two flags are ignored... */
=2D		iwe.u.bitrate.fixed =3D iwe.u.bitrate.disabled =3D 0;
=2D
=2D		for (i =3D 0; i < bss->supp_rates_len; i++) {
=2D			iwe.u.bitrate.value =3D ((bss->supp_rates[i] &
=2D							0x7f) * 500000);
=2D			p =3D iwe_stream_add_value(current_ev, p,
=2D					end_buf, &iwe, IW_EV_PARAM_LEN);
=2D		}
=2D		/* Check if we added any rate */
=2D		if((p - current_ev) > IW_EV_LCP_LEN)
=2D			current_ev =3D p;
=2D
 		kfree(buf);
 		break;
 	} while (0);

--nextPart3873556.pkFQHF5SQA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGIDDAT3Oqt9AH4aERAkx3AJ0bu3h4MUtnkGT10FaLBIImZzuirACeP4z4
tB9VnUlGEmectvHwpvTRoVQ=
=b2qT
-----END PGP SIGNATURE-----

--nextPart3873556.pkFQHF5SQA--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
