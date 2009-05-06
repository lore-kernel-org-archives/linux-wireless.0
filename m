Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbZEFQTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 12:19:12 -0400
Subject: Re: ath5k: scanning while transmitting causes oops on 802.11a
 capable card
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <1241626486.30590.13.camel@mj>
References: <1241626486.30590.13.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dM+mp1l/5NNyhTMPF3Q6"
Date: Wed, 06 May 2009 18:19:07 +0200
Message-Id: <1241626747.4274.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dM+mp1l/5NNyhTMPF3Q6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> If I scan by "iw dev wlan0 scan" while sending data through the
> interface, I get a BUG in net/mac80211/tx.c:
>=20
>                 /* RC is busted */
>                 if (WARN_ON_ONCE(info->control.rates[i].idx >=3D
>                                  sband->n_bitrates)) {
>                         info->control.rates[i].idx =3D -1;
>                         continue;
>                 }
>=20
> I added this statement inside the condition:
>=20
> printk("idx =3D %d, bitrates =3D %d, i =3D %d\n", info->control.rates[i].=
idx,
> sband->n_bitrates, i);
>=20
> The result is:
>=20
> idx =3D 9, bitrates =3D 8, i =3D 0
> idx =3D 10, bitrates =3D 8, i =3D 1
> idx =3D 9, bitrates =3D 8, i =3D 2
>=20
> The card is 802.11a capable.  My interpretation is that scanning
> switches to the 802.11a band temporarily, but doesn't stop transmission.
> When transmitting, the rate indices for 2.4 GHz band are checked against
> the number of rates in the 5 GHz band, which is indeed 8.  There are 12
> rates in the 2.4 GHz band.
>=20
> ath5k 0000:0b:00.0: PCI INT A disabled
> ath5k 0000:0b:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ath5k 0000:0b:00.0: setting latency timer to 64
> ath5k 0000:0b:00.0: registered as 'phy2'
> ath: Country alpha2 being used: US
> ath: Regpair detected: 0x3a
> phy2: Selected rate control algorithm 'minstrel'
> ath5k phy2: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)
>=20
> I actually had to patch the kernel, or the oops would escalate to a
> panic.  Perhaps it's a good idea to have that check:

I don't think it's just ath5k... I had an oops too. I think some of the
pid/minstrel "fixes" broke it but don't know yet.

johannes

--=-dM+mp1l/5NNyhTMPF3Q6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKAbhtAAoJEODzc/N7+QmarhYQAKMJK8smy06G09sEThtO2dzO
LelfY7ECy8SGqOLAWAaNn15Hzr4981N+77OlIIGmUFKpZjygBvWYjVhhmaOoytvr
Uq1q6RQ3boIWMfJrIeB6ccqxTZIIqag72YAG0brVbND25QlSMWc9qx/YEHnowXZw
8DJ8mC9vWVE2HqpTMad+3LwDakn/XXExYGpe14zJfP37QPhVjKIZLpGtcsAK2Kcy
+gA7XlB/H2cil7eaUAOdDWiWLr6e/qbfLxiTWHM75mjsLAvowkxd2rYZHi7iHyIv
I0YN/+5/pd2PchduYWCL4Sek7aQwbQ6jHOcbnK4Y1AmveUlLIAsWFGLBXGstrQkI
ELySdKMQI/6V0uIMTjYMM+KfNy192JrjfqiryaPtF3Kpdk/7NT9/pUR/1xooJwht
MEU/xs6xSD8KEecXLlIDH+rFHS9M5wb6t0kOw1Kq81+iaZHstBlBN6rN6dzstUTL
RjFIK26XvEhntjmUpsi6Pqxr1oL5Lp9sp4Ra+QyKWArPCbYE7VTwILinWCYtrNfL
i5Ra6IPTPs87jVRV5sbFgSxAoFaIcSjWWv8C3ECyHFtoIbHiLwC6y5TReK3hAB9d
t2xThiCvqdRkd7RimUEKL3iiuX6ZN/uW6AgRPd1JGDjNxZEAKJLzQuD7FgN0ipMi
YGsmfDXK3/ZbsTt7RVU8
=8Qg2
-----END PGP SIGNATURE-----

--=-dM+mp1l/5NNyhTMPF3Q6--

