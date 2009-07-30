Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbZG3Phm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 11:37:42 -0400
Subject: Re: Ath5k/mac80211 triggers WARN_ON in kernel/softirq.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Michael Buesch <mb@bu3sch.de>, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <b6c5339f0907300745l3e7ec63eu9819503c4e7766bb@mail.gmail.com>
References: <200907301631.50780.mb@bu3sch.de>
	 <b6c5339f0907300745l3e7ec63eu9819503c4e7766bb@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vSths7oaWnqtS777acmC"
Date: Thu, 30 Jul 2009 17:37:09 +0200
Message-Id: <1248968229.16129.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vSths7oaWnqtS777acmC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 10:45 -0400, Bob Copeland wrote:
> On Thu, Jul 30, 2009 at 10:31 AM, Michael Buesch<mb@bu3sch.de> wrote:
> > Ath5k from today's compat-wireless triggers the following WARNing
> > on hostapd startup.
> > [ 1669.799870] ------------[ cut here ]------------
> > [ 1669.799934] WARNING: at kernel/softirq.c:141 local_bh_enable_ip+0x8b=
/0xb0()
>=20
> because ath5k calls ieee80211_beacon_get inside a spin_lock_irqsave()
> and this is WARN_ON_ONCE(in_irq() || irqs_disabled).

> > [ 1669.800493]  [<ffffffff807e0fef>] _spin_unlock_bh+0xf/0x20
> > [ 1669.800564]  [<ffffffffa0040b92>] ieee80211_beacon_get+0x2c2/0x2d0 [=
mac80211]
>=20
> I guess this is the first victim of spin_lock_bh conversion?

Indeed. I think this means we need to convert the local->sta_lock back
to _irqsave/restore.

John, can you revert the BH patch ("mac80211: do not use irq locks where
not necessary") and I'll send a new one with those changes removed?

johannes

--=-vSths7oaWnqtS777acmC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcb4iAAoJEODzc/N7+QmaydIQAMnuSGXiPhcBfvc1ouPjD0Zw
zdFg9cxTuKPgy8WsBuBwvY8e+WkJWnv4F+w9WsyJHVQtrQ4KYBRc6uFWQW3Z02u6
dJpbbpIklIKen1IWXo3h693nGvHum2edoVa6u7fQxmCgN6Qq0+Mev0nWixcrceFn
t098RSr5hbAkBAlviM8xiHSb1Zyo3ZrMZVZfsiWqII+sFTJtBAEN41jCPM+wT6r5
3E7035cv1T+LmVQhhTitn55b4XRSpTaEJ4kMmfyqUlJnR6y4G6tKryGJEcwE6ZRv
XiEd15q8tPGKVi7AZydzYk1NwIXPYIE0fx1NI28ZFVvjhzUeEW1Jafv8nvuIty2y
DwhA1s/3VHhFiU6rRTiPBGIsUwZ3TJK9My0sevWFlZXiDC21jTVUAZSySpqSGIFL
P2iFnNfPXno1iKinOeiet1qKfzD5KyqL6FsaGbgqkIAOhcfGd4R0ACh5DcUKua5T
vPQZZPK6yjgcBI2j1olZ4yL/D9SLWY+1MlhifRYzOo9VroDuCSdHqxeJDkCKGj1A
G05KNiDzF4EPNMnk2s0qTIjrYdrDs/z5I6XRGVNhz/7oIQZ6g8cHmUB+XxDppPDJ
Mmm670fIiXsm9+6AzmtCm877KgpdejtMDUv2MeJwOZxSF5Mi2ojIpy4t1G5Hn9xS
nuuRI/ZOFihQWDISFX5w
=f/jJ
-----END PGP SIGNATURE-----

--=-vSths7oaWnqtS777acmC--

