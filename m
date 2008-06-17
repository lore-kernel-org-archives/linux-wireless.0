Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbYFQS5C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 14:57:02 -0400
Subject: Re: [RFC PATCH 3/7] 802.11w: Add BIP (AES-128-CMAC)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080617185045.GH4974@jm.kir.nu>
References: <20080617154008.883383150@localhost>
	 <20080617155904.082926456@localhost>
	 <1213721714.3803.83.camel@johannes.berg> <20080617180610.GC4974@jm.kir.nu>
	 <1213726753.3803.103.camel@johannes.berg> <20080617185045.GH4974@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-h/veIRblu1sqHU5t/Nbl"
Date: Tue, 17 Jun 2008 20:56:11 +0200
Message-Id: <1213728971.3803.116.camel@johannes.berg> (sfid-20080617_205708_378369_4DD0870F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-h/veIRblu1sqHU5t/Nbl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Yeah, true, and we actually have that in another place too. If we then
> > remove the MMIE, the IE sanity checks should catch the bad frame anyway=
,
> > when/if it is parsed. Except we removed those because APs were sending
> > bogus information. I'm fine with this, but we should be aware of the
> > consequence.
>=20
> As long as we get the RX path implemented properly, this will only hit
> if there is a bug in an MFP-enabled AP or someone is trying to attack
> the network and both cases are very good candidates for dropping the
> frame anyway. The key selection is supposed to pick BIP key only if the
> sender (AP) has negotiated MFP and as such, all valid broadcast robust
> management frames are guaranteed to have MMIE in the end.

True. I was more thinking of somebody intentionally doing it in the AP
to implement "802.11w in vendor IEs" or something like that but I guess
that's unlikely to happen. And yeah, an attack won't work anyway since
those frames would be rejected based on the wrong MIC.

johannes

--=-h/veIRblu1sqHU5t/Nbl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWAjIAAoJEKVg1VMiehFYkuoQAJTLe/InVm00zuYrhZkMWUCi
xGd1k6FTaJofDSl9r8M3aHXgPmLmpitRXjbVX9gC/6jhc7bOS3B/ERxJQNcwKvYP
cUsbfo5S8yze3fV5+HJz2muQTpLNGv+NkPHeM6qBmZDk0JMN0JlKvA/L11xUuN2o
JbjDLdxfPlevio9ZrbpoKqpEJE7Dak1jYn7DjBd1ZBslLv/B11co2TjAu0Z8uNSx
jDFg0B6Ba6bsJovfeg3IuySRURanio6NUD64OMpvuWqUQx96d+jpxckMZ3xjg+6L
3b88vRUGJEEMBL5xy6kg0Pes0238dkrENIA2Lg7g2w7yoZlJBzsLLRpR0OmfvmBH
Ag5PeQchZVae2/VxOtLNC68lpf8wjq4h/hYZDPz8uEjyInRPUrl+OG8xr9B92z+u
UhSqCqMSiu4URaXqjHXkpglXFAT9/264df0u+oyyKL2YOmEVTSx3TuBxDr5n0yu6
Tzwer3cIO/N3mnP6mhihramaULsHvaL0Bi5VudGFeN9Olu3MERDFwD4WcDzQ7q6j
bEPED43bj99/hDadDkmIG069YkqhQm/Ogbx7t1Zfaxs3EjpQanxwBn7F6zeNEd3K
IwMYulbNklrW3LADg3AyIawk6K/LRu8FkLlbN+eg5YkZuCbTF9mE1+YIdBNiSdm0
Paq+if+i9szGs1dii/E2
=lH4u
-----END PGP SIGNATURE-----

--=-h/veIRblu1sqHU5t/Nbl--

