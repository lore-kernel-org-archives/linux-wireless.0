Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58194 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbZJ1UZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 16:25:09 -0400
Subject: Re: odd state reached when AP deauths you after assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20091028183726.GA4952@tux>
References: <20091028183726.GA4952@tux>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JDVFNuxq4Lnfdy8SG5BN"
Date: Wed, 28 Oct 2009 21:24:45 +0100
Message-ID: <1256761485.4237.260.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JDVFNuxq4Lnfdy8SG5BN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-28 at 11:37 -0700, Luis R. Rodriguez wrote:
> I ran into this when ath5k with wpa_supplicant with config file with
> a wrong password against a Cisco AP. It seems the Cisco AP auths you
> and lets you assoc but later it deauths you -- I guess after it
> determines you are auth credentials failed. When this happens I get:
>=20
> mcgrof@tux ~ $ iw dev wlan0 link
> Authenticated with 00:0b:85:5b:8d:6c (on wlan0)
> Not connected.

I'm guessing that you're using -Dnl80211. You need this patch, or
equivalent:
http://johannes.sipsolutions.net/patches/hostap/all/2009-10-26-12%3a59/deau=
th-on-disassoc.patch

johannes

--=-JDVFNuxq4Lnfdy8SG5BN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK6KiJAAoJEODzc/N7+Qma1SEP/0uG6m6TC+OzRSOqvws8hYx+
yjveheFNA73BgUNetRnRo/T9ULVc9vh5wC51vJDri53pBROweeWZPk/MaxQOXbPk
D8OphV+o00Rco8JhysuQXrmqWEnYPZ4+oY0wp0Vof+kEty3LF30tIcELlJZQD07v
JUWNAhCDUUxeGVNKP3Cpt0W6Tu4uCtcnJoQXEpFlmiWibgt4lm/nO6tZU0sTVtGy
/Xstmf15V8UkGcBoJsysZUVy6PLZqKgTPyFEE9ldzkEU4ew30nH9yrrXKVrWg4R+
+cQDimwcwXg78iV0rTj+sQzMZ1G5H8nxeHAgw0QsVtmyLcynkTbHq2hFeTbo6b3r
hB06xsUxG/WtgV1X4+SAFHSVz/5sc9kr97P3Rg/sYXof/MHoQFmAR4L84O72p2bR
xJRucPJdRlipLVifuXYgiPfq+ARewzaLY1xwgc3swhpAW00vPd9yLWe4UMT3/ig/
/4zgqJJed8TUwXLjcm3W5l7PSJIwqh3nyxGS1BvCqH/mzEA9o7n7CSLbmL3RFQdt
hMgMOxLwplf/XSzUf4fE9TFSWXQYKjyxTgMxxvqEbAdlMR8SmX0eVlISBijGk+CT
PQuuwg4ozJiKflfj5eG/LzDbHATus/3yyWgEsIRgSOUSJwOSeT3pVOgfjBrq0B0x
/ymuSlGCsoqgBD4VAKl0
=fnPT
-----END PGP SIGNATURE-----

--=-JDVFNuxq4Lnfdy8SG5BN--

