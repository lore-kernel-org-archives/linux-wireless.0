Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53150 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073AbYEDNAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 09:00:44 -0400
Subject: Re: mac80211 truesize bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20080504125652.GA1618@gondor.apana.org.au>
References: <1209867740.6210.46.camel@johannes.berg>
	 <20080504031652.GA30993@gondor.apana.org.au>
	 <1209890847.6210.51.camel@johannes.berg>
	 <1209892489.6210.56.camel@johannes.berg>
	 <20080504094444.GA541@gondor.apana.org.au>
	 <1209894754.6210.58.camel@johannes.berg>
	 <1209900355.6210.64.camel@johannes.berg>
	 <1209904088.4065.11.camel@johannes.berg>
	 <20080504124542.GA1455@gondor.apana.org.au>
	 <1209905561.4065.23.camel@johannes.berg>
	 <20080504125652.GA1618@gondor.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-n8x1Tr+zdcGduDHjs3vS"
Date: Sun, 04 May 2008 15:00:32 +0200
Message-Id: <1209906032.4065.28.camel@johannes.berg> (sfid-20080504_150011_205650_DF5F8449)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-n8x1Tr+zdcGduDHjs3vS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-05-04 at 20:56 +0800, Herbert Xu wrote:

> Actually this is not as bad as it sounds.  Since you're constructing
> the hardware header anyway, it may turn out to be easier to tack on
> the Ethernet header while you're at it.

We actuall remove the ethernet header and rewrite it to a hardware
header as the 802.11 spec pretty much mandates.

> Please note that the hardware cache is not the same as the neighbour
> cache.  Just because you lose the hardware cache doesn't mean that
> you'd lose the neighbour (ARP) cache.

Ok.

> However, this would mean that you'd no longer have an Ethernet device
> which is both good and bad.

Yeah. I don't think that'll go down well with userspace.

johannes

--=-n8x1Tr+zdcGduDHjs3vS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB2zb6Vg1VMiehFYAQJn/A//QhL2Ff4dkdyPP8m9Jw5Wi6xTYMIgLv43
k4CW+hFqiojO6reC/0M5e8SMWGmF1XFG2ttbAo5vZKZQCjAvveZ8QEVVfpu7JivB
TJSvg/WnftJ5nhrhZyaRXVfYZnd1tBIGt09aii1d7C9SJCJbreT/ncIovqRgJ1tc
17ChYq+2bNWLpwxFhKUoq5BWFaIAfzgoVQEckNjqFKmfSC3WQ5EddEYtx5Eoc1Q8
2msFW845tB3vccE/AYcL7nN/G9wPJ05tHzT0gXBcWMa8hzZ+RVpv1WeG6aIcnqWw
O0bQozHxE4bYO4COCmmx3xuYh8stlQePe7nNoFRR0zA0vXwP0Qqe3y8rDBn00ZNF
ev5JS9fx3L1qAMXYQ1ArG4MOQUhDnP3ac2wEor84TuDwuyytulIARCufXdsWGwpC
UWl0gy86q1jhC0kzVfM+CKEleSwo9tNJ3nRWpTPpOmOspfBplR8nxsypAxXUsjbt
mECOQ9hxiFc0tMmmPnmVQAeyUQErqKTrmMEPPlzcAR7Cu1+3Ir/kxo5QQ7BAIjgb
YkLWCY0lWVOD/5Oxd8xVj/KqTo3dTjm019AvreJRuuB4oxNyd8pmi6yIqq9mSJnI
Jv8JGyfemNSsQ9pJ44g7vGkaVRUWgo1GzHJ7273DuDN/uXWAo/hQ98uVKV5sToyi
2AgrVZ/CLmE=
=5nmC
-----END PGP SIGNATURE-----

--=-n8x1Tr+zdcGduDHjs3vS--

