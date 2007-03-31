Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:41872 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751978AbXCaVCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2007 17:02:36 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "dragoran dragoran" <drago01@gmail.com>
Subject: Re: mac80211 does not support WPA when used with wext
Date: Sat, 31 Mar 2007 17:00:47 -0400
Cc: "Dan Williams" <dcbw@redhat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John Linville" <linville@redhat.com>, "Jiri Benc" <jbenc@suse.cz>
References: <460E2B8C.4030002@gmail.com> <200703311503.53445.flamingice@sourmilk.net> <f6ca9fed0703311256m1b14ec35p836a62de532dd804@mail.gmail.com>
In-Reply-To: <f6ca9fed0703311256m1b14ec35p836a62de532dd804@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1873477.a29C2aeIqI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703311700.52792.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1873477.a29C2aeIqI
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 31 March 2007 15:56, dragoran dragoran wrote:
> also networkmanager and hal think that the card only supports wep...
> thx for the patch...
> does it adress this issues?
No, this has nothing to do with that. The following patch should address th=
at=20
issue, but my copy of networkmanager already does WPA fine so I can't say f=
or=20
sure whether it will help or not. A quick look through the networkmanager=20
code seems to suggest this will work.

=2D-

mac80211: set enc_capa

=46rom: Michael Wu <flamingice@sourmilk.net>

Update we_version_source and set enc_capa in iw_range.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/mac80211/ieee80211_ioctl.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index b28e794..d139d97 100644
=2D-- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -1583,7 +1583,7 @@ static int ieee80211_ioctl_giwrange(struct net_device=
=20
*dev,
 	memset(range, 0, sizeof(struct iw_range));
=20
 	range->we_version_compiled =3D WIRELESS_EXT;
=2D	range->we_version_source =3D 14;
+	range->we_version_source =3D 21;
 	range->retry_capa =3D IW_RETRY_LIMIT;
 	range->retry_flags =3D IW_RETRY_LIMIT;
 	range->min_retry =3D 0;
@@ -1603,6 +1603,9 @@ static int ieee80211_ioctl_giwrange(struct net_device=
=20
*dev,
 	range->avg_qual.noise =3D 0;
 	range->avg_qual.updated =3D local->wstats_flags;
=20
+	range->enc_capa =3D IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
+			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
+
 	return 0;
 }
=20

--nextPart1873477.a29C2aeIqI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGDswET3Oqt9AH4aERAvmoAKCy+IutvFlpXWYMzVZtHSm4EeMoOACgtN8g
PlB0DM0nxqrSfJlp2Z6l15Q=
=P8ye
-----END PGP SIGNATURE-----

--nextPart1873477.a29C2aeIqI--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
