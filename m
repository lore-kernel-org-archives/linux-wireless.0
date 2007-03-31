Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:40608 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753186AbXCaTFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2007 15:05:44 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: mac80211 does not support WPA when used with wext
Date: Sat, 31 Mar 2007 15:03:45 -0400
Cc: Johannes Berg <johannes@sipsolutions.net>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@redhat.com>, Jiri Benc <jbenc@suse.cz>
References: <460E2B8C.4030002@gmail.com> <1175335211.23438.45.camel@johannes.berg> <1175363333.9349.10.camel@localhost.localdomain>
In-Reply-To: <1175363333.9349.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2453519.gNGMR0HAli";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703311503.53445.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2453519.gNGMR0HAli
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 31 March 2007 13:48, Dan Williams wrote:
> On Sat, 2007-03-31 at 12:00 +0200, Johannes Berg wrote:
> > On Sat, 2007-03-31 at 11:36 +0200, dragoran wrote:
> > > Hello
> > > While testing the iwlwifi driver I noticed that the mac80211 does
> > > provide a wext interface but does not support wpa with it.
> >
> > You must have done something wrong, it works well.
>
> Nope!  This time it's really mac80211 :)
>
> Take a look at ieee80211_sta_scan_result() in mac80211/ieee80211_sta.c.
> Note that it returns custom events for the WPA & RSN IEs.  That's just
> wrong.  We should be using already-defined events.
>
What does that have to do with WPA not working? wpa_supplicant works fine w=
ith=20
the custom events on my system. Also works fine with the standard events=20
which the following patch makes mac80211 use.

=2D-

mac80211: use IWEVGENIE

=46rom: Michael Wu <flamingice@sourmilk.net>

Use IWEVGENIE which was defined in WE-18.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/mac80211/ieee80211_sta.c |   40 ++++++++++----------------------------=
=2D-
 1 files changed, 10 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 087f176..a227c38 100644
=2D-- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2839,39 +2839,19 @@ ieee80211_sta_scan_result(struct net_device *dev,
 	current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe, "");
=20
 	if (bss && bss->wpa_ie) {
=2D		char *buf, *p;
=2D		int i;
=2D		buf =3D kmalloc(30 + bss->wpa_ie_len * 2, GFP_ATOMIC);
=2D		if (buf) {
=2D			p =3D buf;
=2D			p +=3D sprintf(p, "wpa_ie=3D");
=2D			for (i =3D 0; i < bss->wpa_ie_len; i++)
=2D				p+=3D sprintf(p, "%02x", bss->wpa_ie[i]);
=2D			memset(&iwe, 0, sizeof(iwe));
=2D			iwe.cmd =3D IWEVCUSTOM;
=2D			iwe.u.data.length =3D strlen(buf);
=2D			current_ev =3D iwe_stream_add_point(current_ev, end_buf,
=2D							  &iwe, buf);
=2D			kfree(buf);
=2D		}
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd =3D IWEVGENIE;
+		iwe.u.data.length =3D bss->wpa_ie_len;
+		current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe,
+						  bss->wpa_ie);
 	}
=20
 	if (bss && bss->rsn_ie) {
=2D		char *buf, *p;
=2D		int i;
=2D		buf =3D kmalloc(30 + bss->rsn_ie_len * 2, GFP_ATOMIC);
=2D		if (buf) {
=2D			p =3D buf;
=2D			p +=3D sprintf(p, "rsn_ie=3D");
=2D			for (i =3D 0; i < bss->rsn_ie_len; i++)
=2D				p+=3D sprintf(p, "%02x", bss->rsn_ie[i]);
=2D			memset(&iwe, 0, sizeof(iwe));
=2D			iwe.cmd =3D IWEVCUSTOM;
=2D			iwe.u.data.length =3D strlen(buf);
=2D			current_ev =3D iwe_stream_add_point(current_ev, end_buf,
=2D							  &iwe, buf);
=2D			kfree(buf);
=2D		}
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd =3D IWEVGENIE;
+		iwe.u.data.length =3D bss->rsn_ie_len;
+		current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe,
+						  bss->rsn_ie);
 	}
=20
 	if (bss) {

--nextPart2453519.gNGMR0HAli
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGDrCZT3Oqt9AH4aERAgWlAJ40YsNh6yZw5rB2DsYzxcIKCKjJ/wCfVBJp
UwWs4BIDHkcxjeboexUxdGw=
=YEQA
-----END PGP SIGNATURE-----

--nextPart2453519.gNGMR0HAli--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
