Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbZAPUhz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 15:37:55 -0500
Subject: Re: [PATCH 03/13] cfg80211: add wiphy_apply_custom_regulatory()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090116163646.GG29609@tesla>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232097659.3854.20.camel@johannes>  <20090116163646.GG29609@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8xVh2pmbKwHytR0p8xFi"
Date: Fri, 16 Jan 2009 21:37:50 +0100
Message-Id: <1232138270.3745.11.camel@johannes> (sfid-20090116_213759_885123_EA2DF750)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8xVh2pmbKwHytR0p8xFi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 08:36 -0800, Luis R. Rodriguez wrote:

> > Also, I don't think calling the notifier is
> > appropriate since the driver just called this function.
>=20
> Calling the notifier is why we want REGDOM_SET_BY_PROBE. We also technica=
lly
> do not need to call the notifier unless we want to allow for tricks like =
the
> one I am using in ath9k to condense the regulatory domains to 5 based on =
frequency
> and to let a helper sort out the flags. Without this I believe we'd be fo=
rced to
> use 12 full blown regds.

I just don't see why the driver couldn't be like this:

static void helper(...) {...}

static void ath9k_reg_notifier(...) {
	helper(...)
}

static void ath9k_something(...) {
	apply_custom_regulatory(..)
	helper(..)
}

so cfg80211 doesn't call back into it but it does it itself. It's
usually deadlock prone if some called code calls back into the caller
code.

johannes

--=-8xVh2pmbKwHytR0p8xFi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcPAcAAoJEKVg1VMiehFYgA4P+gPs02SE6/XYi2sjQSGhMHPw
cP6vgM/c4EQqWPMvU76Nr6SjaKiCiy7XTu58ierS3YLLV0fBmjtlDu+O4u55Tp1U
pyEUjsz8mgoYLzQoBki4RqqJj5VqWkNUW1cTvqVIuZs7cTA4IXbbtocN28Q9h9zR
5pn+Ztc5jDKaSyTsw3uOdKXa1YbI+Kum/8OPHKOMM+S5u0bT8JPfPH4fFrEn29II
El+wqf+UVB5Xr8YthA4RaHxS2uuquNtzwYIN6oJOXrJ6KFq4mL0vvM4zH07G5Bpl
w3D6JIFIEub9l/ymWg44cE3kdT6Om8RCCwNxPd1hw3aZ/BdDaWCvyKHuOpuBL2U4
zKxwu4CBehm9x+xr8DO+3hP5D3J7vWPmRQs2HHfgRvdhe8PYKO3r12zdUVb/RlDU
MBjDqijVjp89WCLb2EHbsuBHl23x0Gv/t0peLEJXPI8TPNvbKXifphm6H8Y0Mg2B
NgUCYyGxX8OpxaS4FZZsYWe9qx4M5o3iKjejXNdRMQ3uzqgoBO6FAd69jm2N2luZ
7mKc3UlsoElJJi7n731jv0eBh6Jto05gGKV9X4UbdgIrzpGgkquCwzURf/lJsjo2
+bELwywlGiRcsBFtCB/3v+oS47fcd4t5shcodIP293H47BkYAUzVTkwG/7l8GW13
I7M6T0ihU4IeuTDAGCcC
=rU8x
-----END PGP SIGNATURE-----

--=-8xVh2pmbKwHytR0p8xFi--

