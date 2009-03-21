Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbZCUH7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 03:59:51 -0400
Subject: Re: [PATCH v2] mac80211: resume properly, add suspend/resume test
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <20090320160308.GB28965@jm.kir.nu>
References: <1236939917.5235.7.camel@johannes.local>
	 <1236941058.5235.12.camel@johannes.local>
	 <20090320160308.GB28965@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-b2shg3bMJVdKzzXH9VVI"
Date: Sat, 21 Mar 2009 08:59:43 +0100
Message-Id: <1237622383.5100.162.camel@johannes.local> (sfid-20090321_090041_607407_0925679B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-b2shg3bMJVdKzzXH9VVI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-20 at 18:03 +0200, Jouni Malinen wrote:
> On Fri, Mar 13, 2009 at 11:44:18AM +0100, Johannes Berg wrote:
>=20
> > --- wireless-testing.orig/net/mac80211/debugfs.c	2009-03-13 11:36:57.00=
0000000 +0100
> > +++ wireless-testing/net/mac80211/debugfs.c	2009-03-13 11:41:53.0000000=
00 +0100
> > +static ssize_t reset_write(struct file *file, const char __user *user_=
buf,
> > +			   size_t count, loff_t *ppos)
>=20
> > +	__ieee80211_suspend(&local->hw);
> > +	__ieee80211_resume(&local->hw);
>=20
> This seems to have broken build if CONFIG_PM is not defined: pm.c, with
> these functions, is not included.

Indeed, this file should depend on CONFIG_PM too I suppose, will fix
that. OTOH, a future patch I have will require _resume to always be
present, so I'm inclined to just always put the code in. I'll come up
with a fix in any case.

johannes

--=-b2shg3bMJVdKzzXH9VVI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxJ5bAAoJEKVg1VMiehFYZNcP/1YAgg4M9DFBEZTrmnU4y071
C4HcwRjC5rwTn+nXPtyfWMX3VfraJCg8Cskn2gwzh5exPqmCiOr7svHlx2QwByx1
GOAKDT8YgwwGAu5qHO9yzXWNQTKdZ+6OezBQ9Aj0sSQhAp2akB8IIzJvQ41Ce4NF
oneQliWY2FWdYCAD2rVJwOwuieypBKxmHHCS8Qyeqek3hshk38qtZfrLT+5XP04p
lIufvw4Qbe+ffja9xCBOq5AhgSrZEtHZxJhatczZCI5N2QA+Jpy68LyTKbPCXNdT
014GvulBP8vR17PRJpEjVH80GqKMp3mYN8ieQWTwOM3aPYIcqbwluamcSxyESfPP
YEf2DCD5K6TTQJVcLfzaketAPMozxzZPspvU6G/x/B6OHQ/ktCH2z+z1OBweQrAb
HEwTwAxCT2P2rHNEDfVgCOJskw2tUNIqkTrdifXoXFQdVwcYcmPiquOfrMYTwtMb
7dEg//DtZNT30TerckMmV/cKvf5zCp390AD5wgwBvpU1NmmWg3PRy/tdP/5neSrA
cFUBDnxEKPD3DGzHZYMFWgfw9AodpZ8rD0n0Rd6ITnxxc7mFXT+k6qJxm20tNoq6
7OaMzE0+yAh8KvVcOXJcEkHHik3cmjnwrMYoCPqK1yJ0vcerRdQA+3KK9wiCH5M7
4nsF1/Hph58g4wBohpnu
=0czU
-----END PGP SIGNATURE-----

--=-b2shg3bMJVdKzzXH9VVI--

