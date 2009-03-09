Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZCITh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 15:37:58 -0400
Subject: Re: Another "scan handling in mac80211" bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200903091838.16365.helmut.schaa@gmail.com> (sfid-20090309_183906_027999_3D2623DB)
References: <200903091838.16365.helmut.schaa@gmail.com>
	 (sfid-20090309_183906_027999_3D2623DB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8dkIIsQdfmREPscxM7/u"
Date: Mon, 09 Mar 2009 19:48:32 +0100
Message-Id: <1236624512.9658.5.camel@johannes.local> (sfid-20090309_203801_757367_4A7A8E37)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8dkIIsQdfmREPscxM7/u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> I was just unable to scan again after waking up from s2disk.=20

I think I never had such problems because zd1211 doesn't actually
suspend, maybe. Not sure, in any case I always unplug it anyway...

> Luckily I
> still had some debug output in mac80211 from my previous patch:
>=20
> [66796.154861] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [66796.164133] ieee80211_sta_work
> [66796.164142] ieee80211_sta_work 2
> [66796.178069] wlan0: direct probe to AP XX:XX:XX:XX:XX:XX try 1
> [66796.375058] cfg80211_wext_siwscan
>=20
> Ok, someone (I guess wpa_supplicant) triggered a scan.
>=20
> [66796.375065] ieee80211_scan
> [66796.375067] ieee80211_scan: request_scan
> [66796.375070] ieee80211_request_scan
> [66796.375073] ieee80211_request_scan queue_work
>=20
> The scan is not started immediately due to mode =3D=3D STA.
>=20
> [66796.375116] ieee80211_sta_work
> [66796.375120] ieee80211_sta_work 2
>=20
> Good, the sta_work is executed but does not start the scan (I also had
> a debug printk in ieee80211_start_scan).
>=20
> Here's the according part of the code:
>=20
> 1759   if (ifmgd->state !=3D IEEE80211_STA_MLME_DIRECT_PROBE &&
> 1760       ifmgd->state !=3D IEEE80211_STA_MLME_AUTHENTICATE &&
> 1761       ifmgd->state !=3D IEEE80211_STA_MLME_ASSOCIATE &&
> 1762       test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request)) {
> 1763     /*
> 1764      * The call to ieee80211_start_scan can fail but ieee80211_reque=
st_scan
> 1765      * (which queued ieee80211_sta_work) did not return an error. Th=
us, call
> 1766      * ieee80211_scan_failed here if ieee80211_start_scan fails in o=
rder to
> 1767      * notify the scan requester.
> 1768      */
> 1769     if (ieee80211_start_scan(sdata, local->scan_req))
> 1770       ieee80211_scan_failed(local);
> 1771     return;
> 1772   }
>=20
> Ok, we are currently in state IEEE80211_STA_MLME_DIRECT_PROBE and as such
> do not trigger the scan right away. IEEE80211_STA_REQ_SCAN should still b=
e
> set. Seems still fine to me.

Yeah, seems ok so far.

> [66796.375329] cfg80211_wext_siwscan EBUSY
> [66796.376170] ieee80211_sta_work
> [66796.376174] ieee80211_sta_work 2
> [66796.376179] wlan0: direct probe to AP XX:XX:XX:XX:XX:XX try 2
> [66796.576063] ieee80211_sta_work
> [66796.576072] ieee80211_sta_work 2
> [66796.576079] wlan0: direct probe to AP XX:XX:XX:XX:XX:XX try 3
> [66796.776061] ieee80211_sta_work
> [66796.776069] ieee80211_sta_work 2
> [66796.776076] wlan0: direct probe to AP XX:XX:XX:XX:XX:XX timed out
>=20
> Hmm, the direct probe timed out, thus the state moves to
> IEEE80211_STA_MLME_DISABLED but sta_work will only run again when the
> next association attempt is being made. However, we still have
> IEEE80211_STA_REQ_SCAN set.

That's not very good.

> [66816.374308] cfg80211_wext_siwscan EBUSY
> [66823.901663] cfg80211_wext_siwscan EBUSY
>=20
> All subsequent scan requests will fail in cfg80211_wext_siwscan as mac802=
11
> did not notify cfg80211 about the scan result.
>=20
> I guess it should be sufficient to queue one more sta_work after the MLME
> moves to IEEE80211_STA_MLME_DISABLED state. In case IEEE80211_STA_REQ_SCA=
N
> is still set the scan will get started and cfg80211 gets notified about t=
he
> result.
>=20
> Does that seem correct?

Yes, that seems correct to me. IEEE80211_STA_REQ_RUN not being set will
catch the "do nothing with assoc state" part.

johannes

--=-8dkIIsQdfmREPscxM7/u
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJtWR9AAoJEKVg1VMiehFY3jMP/A6cIkzUrUzb7VzVkZL+Omx4
Up9D59jYHPPkwCkAmopIJ5mjr99fyDSfJ2J+uN50RWRlGa+FUp64H0pu+fTJXCZl
Y7yh9x8gXOGM11Tdb3I97JBLqnRjmmbNVgz5l8HbbXnKpFq0C1upvM1ykRKRd9aL
jiqcqCWEL3vcMTXO1NOCgTpPOks1unu0sesJuC4tWoyeJBMsod2pq9fl490gYgwI
gryXcsjuOfIDiH1tAqz1GmSKbuNV2Vg6F3DI1S96oml7xLai9AagTt0oTcZe2ib7
fUzxO8Lbyj+p+Th5hj9M44RHcy7KSyyUv+8Mr/CnkeA7ri04K58JMud6boNIOtIv
HI7s9H+ZiwrsdM/QcPh3LPpf1i4O4fRVVkCF6ij0GEdVPSbJeAideSyqHLFmov9/
TWeuAUtD20IrtswbMQljK6n3rexiaSeu5L7k/K/jiC5OTreo201oOPPJjyYlisgA
fu/SXwN4/86hChVTV7PpqcWB0kWyiugichDjMGC78mnzH4CY1GK9GqnSIcq12t6H
x//4iXhY8erudyJtWJRkmmgg2eMxyTo5yD44vdSqenKko2rsTzZdJFNgbMMBQgtt
fgkG1L+hU1AnyA8aVqjZqDfHoyeQ3Kh5p3DCBZo6W63OTbvZSXPnyReE7R0nvKgH
+U7zXE+KmT6apxOs41Sh
=5Fe7
-----END PGP SIGNATURE-----

--=-8dkIIsQdfmREPscxM7/u--

