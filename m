Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42947 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbZGJNT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 09:19:26 -0400
Subject: Re: [PATCH v2] mac80211: monitor the connection
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <87eiso23ee.fsf@litku.valot.fi>
References: <1247186507.1905.14.camel@johannes.local>
	 <1247187640.1905.16.camel@johannes.local>  <87eiso23ee.fsf@litku.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-l46rL+DtI1WjBF8E8ET/"
Date: Fri, 10 Jul 2009 15:17:47 +0200
Message-Id: <1247231867.1905.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l46rL+DtI1WjBF8E8ET/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-10 at 14:17 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > With the recent MLME rework I accidentally removed the connection
> > monitoring code. In order to add it back, this patch will add new
> > code to monitor both for beacon loss and for the connection actually
> > working, with possibly separate triggers.
> >
> > When no unicast frames have been received from the AP for (currently)
> > two seconds, we will send the AP a probe request.
>=20
> I think this is too short, but we can change it later.=20

That's why I kept it separate (well, also to change the beacon stuff to
be dependent on the beacon interval later)

> I quickly looked at the patch and it looks ok for me. Unfortunately I
> can't test it right now because N800 support is broken in 2.6.31. I'm
> fixing that currently.

One thing is actually broken -- I start the monitoring even when
hardware is doing beacon filtering/monitoring.

johannes

--=-l46rL+DtI1WjBF8E8ET/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKVz94AAoJEODzc/N7+QmadEcQAKWwNicCwmrgqoxtodVngjYd
j7+mau7W99f1WIDfTuhGD02G9HiDdOTgr9zY12A0ZyAZKCap8sShJhikizJnjwxF
KBdyQRf7z/6xNhTHUZdkeQxXeobpjw1RUHMuqQHyNTaMk33yyOCXC5kHKYzc9v4f
xmP3+BkTX06pFmxOR6lGDMUb/9aKPy7KOI7fv2Br+hQiLSo2mXoKUGtMP3ScdxCH
vSpZbV2CEtQC0APsMwxzCnw4Vn2U0Asc8UOiQmWoEe0yIFH5AgYNmyBlLceHSgN1
VqFlM7C2coXS9NUqra+uSlJx6IZ4S8hs2uG/TKYkEenuVTWsjddICvBU7hurR3yH
+ThnJIKZxCEFeRvBfg/fH9kLOf/eOzWqonl6BP/Poqhdf+Qp0kUq4OSPStVXYvwa
ixZaESZdbxK7AVECbdIAFcW6YySES1neyWI6P0LpkkQIECGMw9m0342a4wdMjiEg
eiWb6WolOdwNVtVU5nVQxt0VQZyjFRXtlk9shmQkDvl4LYhbc/xcIQr+9PdSUHTI
SX8Ht8PYcZbnJPXrBgxpv7R3PT297gFmzeiVEpGlRcL/8e2d2OQu6slxPes211vf
seGPRCmseeM6OKJk3pA4F7k1SOZc1Z9b74Kkz1CD/IEkHAIE0SZ6rEe+IOMHpZPe
N/5/xwORm9O9JTzKWlED
=99dO
-----END PGP SIGNATURE-----

--=-l46rL+DtI1WjBF8E8ET/--

