Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45253 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbZBPIt3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 03:49:29 -0500
Subject: Re: [PATCH 04/10] nl80211: disallow user requests prior to
	regulatory_init()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902160013q48912fa1if1db7155e4fee1f1@mail.gmail.com> (sfid-20090216_091405_943523_1350B502)
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-5-git-send-email-lrodriguez@atheros.com>
	 <1234695526.4219.46.camel@johannes.local>
	 <43e72e890902160013q48912fa1if1db7155e4fee1f1@mail.gmail.com>
	 (sfid-20090216_091405_943523_1350B502)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DxWaYN0/FpxxGKV1wqS4"
Date: Mon, 16 Feb 2009 09:49:23 +0100
Message-Id: <1234774163.4219.100.camel@johannes.local> (sfid-20090216_094937_986515_66C600B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DxWaYN0/FpxxGKV1wqS4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-16 at 00:13 -0800, Luis R. Rodriguez wrote:

> >> +     if (!cfg80211_regdomain)
> >> +             return -EINPROGRESS;
> >> +
> >
> > But that variable access here is racy too.
>=20
> Right.
>=20
> > It might be ok anyway because
> > the variable can never be NULL again after the first assignment
>=20
> That's what I was going for.
>=20
> >  but in
> > that case the assignment needs to take care to assign something fully
> > created ...
>=20
> Can you elaborate on what you mean?

It'd have to be done in a RCU-like fashion, unless we only ever use it
as a bool here?

johannes

--=-DxWaYN0/FpxxGKV1wqS4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmSiQAAoJEKVg1VMiehFYEB8P/jnQ8XqRIQOn81xhhmb4HbPk
SvgKvwzU7eLoKwWqSqoIuflYUlm8zV1TlpuhI2imkW3GrEJ/cOyhrbOFElVe30Mo
XVB87YE8Ym0Q0L7n5lBi3uS7WyRghcJ9avL7PrQC9fBBLjZk+pwHVfVW1OSGgfRi
G0iHo1NdXP0Np0RYj/tX3EzlTH71FkcL3+NU79FjbbLiTDOspWj9HWLWSk+8ZejM
ztpppxMgbkJOyx2x7ztXO5H/RxB0wg2tmuAZvfvSq/WtHRznwXTNIUqXeEEV1bdX
+w7XhVU/TfM/xRONdVyHI4OLMa9DfzSsOwtSnwJeR8Q2wAtakcFM7WVDHPr21HpM
8LZGU3qCy7oKyYEYyYJHm5deguvhhGxxk+EjK9JGiExeMkymPv2Y1NfBrU6XvCi6
IvAqqS9/QpMddcspfTogpxTceobCVrK9CMHRCzLkO780R/otkdk64GT4FO1B1bBo
RS/dKm1WcyFPW6zYuWiW3KxtQTGMNcGx9DYWgMMV8f6OxrTNzmHBuK0nBlUFo/yp
80OUYphSUuLblH44Z+m5UsMcF+b7MXzbT9AyqxHcM0D/KP7+KyIB+XiSVW0xiQ5M
8jUVzTPE8S2Yp++Q4nWdaL9eBOiNV0aMxftGfuMeFerSosuNLnOA0xfKk8sO2o8i
egewoaMKtujdbe6fy8nb
=xLsx
-----END PGP SIGNATURE-----

--=-DxWaYN0/FpxxGKV1wqS4--

