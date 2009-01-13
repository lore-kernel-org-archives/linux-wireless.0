Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401AbZAMXYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 18:24:04 -0500
Subject: Re: [PATCH 00/12] cfg80211/mac80211: fixes/enhancements for
	reg_notifier()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090113231741.GU4416@tesla>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
	 <1231887621.3728.12.camel@johannes>  <20090113231741.GU4416@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jt90HWjuFFJ6Wl6iOieq"
Date: Wed, 14 Jan 2009 00:23:34 +0100
Message-Id: <1231889014.3728.19.camel@johannes> (sfid-20090114_002413_399021_5FEC95EE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jt90HWjuFFJ6Wl6iOieq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 at 15:17 -0800, Luis R. Rodriguez wrote:
> > (2) you
> > should not do via the regulatory code and the notifier but rather by no=
t
> > registering those channels to start with
>=20
> I did a lot of this work because you had opposed to allow drivers dynamic=
ally register
> their channels.=20

I think we may have had some miscommunication here? I didn't like
registering the channels dynamically with new calls, but I certainly
don't care how you arrive at your channel array, you can kmalloc it if
you want.

> The size of the code also increases considerably by using static set of
> channels for each custom regulatory domain, its possible though.

You don't have to.

> >, or setting the disabled flag
> > before registration if that's easier.
>=20
> You'll still need some sort of table. Either way -- all these are options=
 of how to
> accomplish the same task. I did this as part of cfg80211 as I figured it =
could be
> used by other drivers.

In what form do you have this data? Is it "valid 2412-2472 and 4950-5250
MHz"? If so, can we just have a function that marks all channel that
would fall outside these ranges as invalid, and you call that function
with a specific band and channel before registering your wiphy?

johannes

--=-jt90HWjuFFJ6Wl6iOieq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJbSJ0AAoJEKVg1VMiehFYgpUP/3RA/w5i++IaeCVLGDyPMEqr
q0urvKisexSunUNQVtgiMaW+vcJAOTY1EtvYwOIl9etmdm9NJfa0rP7IBY90rFz+
zdtndz6d7IYZx1zVlazfqYKk4WCPbIHpKhDo1YbQ7KV/0Io+RTV0GC5wEa1a8LgM
bG4ByvLlNoD0eM562x3oyfAyYUh2JDD5AvfzwjW6nQrIGDmojpL8PHMXN1my3zo3
HuHwIBkfKna0izCRB1VtF/ilIVW8dntvwN/zDrheEjLit0DvI4pWftIPSKWNu5n1
NU6lJ5qsszg96uwa/7RcdCLCQAOstAyMy1D6QDOLD0PLYHsOLvuB73x77b+2HQ7x
8u//r+66SbdQQd8u3ucWLJRu9yGgUhFkHBnW+X74kjcU2ggWaaYwpvQ8ryoOHKsk
0p+9vz3Ws5d0U9+J/uxh4Q49rtQGzAizH8fFp3rJUnERAuf81pV9b0r6c6DRaL7u
yBfF1KUjZRoR8b/meqBFp4CAuS2UXnlL8CbHeoSkUQM+qMrWHUGnr6A4T6Y/Q2Bs
g5MyZwLbd1RfrLS/rbUCmremBdRbyWDcHQsb7fuMBict3KDLs0NdsJVYuJ67jBfA
+Qo9BI7xJZbUDVICpm+H5E9obZM0zz3KAgSVWe4Nk3F6sUyesukjsHkcqgjHHOpA
/bLBbK9i9YFDCWlbqdib
=5Tvy
-----END PGP SIGNATURE-----

--=-jt90HWjuFFJ6Wl6iOieq--

