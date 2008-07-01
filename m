Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbYGALah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 07:30:37 -0400
Subject: Re: rt61 and TSF reporting?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200807011315.09296.IvDoorn@gmail.com> (sfid-20080701_131114_239318_0C1B911B)
References: <1214907990.7763.40.camel@johannes.berg>
	 <200807011305.18802.IvDoorn@gmail.com>
	 <1214910405.29181.0.camel@johannes.berg>
	 <200807011315.09296.IvDoorn@gmail.com>
	 (sfid-20080701_131114_239318_0C1B911B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XyBEpQigtei1xNHtPMbL"
Date: Tue, 01 Jul 2008 13:29:54 +0200
Message-Id: <1214911794.29181.3.camel@johannes.berg> (sfid-20080701_133040_297306_D2EDD458)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XyBEpQigtei1xNHtPMbL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-01 at 13:15 +0200, Ivo van Doorn wrote:
> On Tuesday 01 July 2008, Johannes Berg wrote:
> >=20
> > > > > Note that these undocumented fields only are present in rt2500pci=
 and rt61pci.
> > > >=20
> > > > Ok cool, I'll play with that, I should be able to make a patch myse=
lf,
> > > > thanks.
> > >=20
> > > Oh wait, just found a reference about those RXD words:
> > >=20
> > >  * The following fields are for DMA block and HOST usage only.
> > >  * Can't be touched by ASIC MAC block.
> > >=20
> > > In other words, they are for driver usage only. :S
> >=20
> > The only ones that are ever non-zero are 0, 1, 4 and 5. Guess not then.
>=20
> 4 contains data?
> 2 and 3 I understand since HW crypto is disabled in wireless-testing,
> but that should mean that 4 should also be 0 unless my estimation about
> it being the ICV field is wrong...
>=20
> What data is in there?

Heh. I was connected to an encrypted AP with a different device and
monitoring the traffic no that channel, and got the following:

[139528.433872] rt61pci rx word 4: 0x60483004
[139528.433882] rt61pci rx word 5: 0x012c30a8
[139528.468947] rt61pci rx word 4: 0x60483004
[139528.468956] rt61pci rx word 5: 0x01566138
[139528.571350] rt61pci rx word 4: 0x60483004
[139528.571361] rt61pci rx word 5: 0x1dba1048
[139528.673744] rt61pci rx word 4: 0x60483004
[139528.673753] rt61pci rx word 5: 0x18e02078
[139528.776153] rt61pci rx word 4: 0x60483004
[139528.776165] rt61pci rx word 5: 0x01568018
[139528.878538] rt61pci rx word 4: 0x60483004
[139528.878549] rt61pci rx word 5: 0x072a9048

In fact, through the whole uptime of the card word 4 never changed, so
maybe it's just bogus data from the disabled hwcrypto engine.

johannes

--=-XyBEpQigtei1xNHtPMbL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIahUvAAoJEKVg1VMiehFYJ6YP+wZYmJiEcFagram0OCxsnwmb
tGbFXT8DZb1gWluXg0AE8HdS5oVfvvELLPP08LQP7o6P27GKdpT/kcgj1W0nYeAo
0sh3KWiK2hiJfDVqhCrzsPXOEDmLsrnHB8vdOMoB07SVcO2GVFLXqev+1FMVNZzA
Eqp/kgmwSby2V6LTMgf0YP68DRa1yqA9K4XO4Sv6XyLLGPzXv2DISZkJhtTMVinY
JHzw5ltQ77y98VRly3WKMAGBEE0z4RfF//LSo3pugHE4Gvkdnvk7nZ3U8BPUmhNN
vJSI7p2PqK6f14LdVx0xMNLVO9NRIFjFkJnij6ParlBZzVC427XtJBG/4e4vo1+d
9szyih74kWZTeXgmlN/S8CWSDzpMXtU1NVI6Osj72wQAFXMc6BAKIrqmC7vsHHGH
Gs2EmQ47iAwo1OxkMpQNVIsLZszPQYDvXjYEpd+gZe7SvTc0C3Mbp+7GLCyKoCU5
SEB1KOkxcXeQOy5pld8nOHTXMPpzUM8Jue/GE1N8W0L9WmCEI2RAT8qce5en0HgJ
hEJ8tL3oeeXekCW+lubpg4sfoYdcHUohzlM7fXXB4DU+xJJA1U1+gzojgZAk4qgK
ukwpFLzSqbjg2X3k22eyqus37yZoUkEquorIGoD2JT0J84mWCIb/QU4S7eLzdRut
hoiRJ64oa/iKRsiLaYNs
=vh5s
-----END PGP SIGNATURE-----

--=-XyBEpQigtei1xNHtPMbL--

