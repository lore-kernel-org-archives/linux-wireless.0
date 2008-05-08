Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbYEHJB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 05:01:28 -0400
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, mb@bu3sch.de,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ron.rindjunsky@intel.com, tomasw@gmail.com, ivdoorn@gmail.com,
	peter.p.waskiewicz.jr@intel.com
In-Reply-To: <20080507.202606.242037993.davem@davemloft.net>
References: <20080507130548.GA26977@gondor.apana.org.au>
	 <200805071548.06693.mb@bu3sch.de>
	 <20080508032208.GA401@gondor.apana.org.au>
	 <20080507.202606.242037993.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Un9wz/dxjpXOKf97hvmx"
Date: Thu, 08 May 2008 11:00:30 +0200
Message-Id: <1210237230.3547.35.camel@johannes.berg> (sfid-20080508_110029_602249_52A29970)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Un9wz/dxjpXOKf97hvmx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-05-07 at 20:26 -0700, David Miller wrote:

> > You're supposed to stop the queue before the ring overflows.
>=20
> Right, and this is why drivers choose a TX wakeup threshold such
> that they can accept an arbitrarily sized TSO frame.
>=20
> For example, from drivers/net/tg3.c's ->hard_start_xmit():
>=20
> 	if (unlikely(tg3_tx_avail(tp) <=3D (MAX_SKB_FRAGS + 1))) {
> 		netif_stop_queue(dev);
> 		if (tg3_tx_avail(tp) > TG3_TX_WAKEUP_THRESH(tp))
> 			netif_wake_queue(tp->dev);
> 	}
>=20
> The driver is responsible for stopping the queue _before_ it
> enters a state where there is not enough space in the queue
> to accept a packet.

Yes yes yes I know :) It's just quite awkward to handle when your
hard_start_xmit() actually increases the number of packets, you don't
really know how deep the queue is etc. I'll add an assertion like that
to mac80211 for the non-fragmented case and clean up the fragmented case
to retry by itself without upper layer involvement after the tx->cb
patch.

johannes

--=-Un9wz/dxjpXOKf97hvmx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCLBLaVg1VMiehFYAQIrSxAAsLTLB0w33ETzgW9RDm36f34scQnMa+of
OG5fL0atoZ97vX7ajxB+FPopAKMuL+301Phsn2JcrodoU8XmqgZ2VjxuZ9Zh6hw2
q16QuvPiaucjOoZg1yR5qAwBl+nImagZZl6eHDXyscfX4FdVXti8tIqyNBUUx0tc
nc5cTX/S8+ZrbLXn7Huo3PqYySSO+aQeAXoaK7TFe6TFDjp9ZstuZySwYm4ybBJd
SLeYS7HivTt+Yx38tgwk5kga28ITy27ZART8SjwV0PbNSO07ECJF5VOq3G4msFCS
Q4U9L5DvIb+KOLnueZGiB+Zc25f0ThlDM+7SiaJ49fb2cCBI71xEBSFf96b4FbEK
yZFsaE7Y9w47Np/73bObC9memh4gIydsgi+vb2HhyN0ggz/8pbq+ADCN8GDTJWFn
myvjqT8FN0hi3sjKADDXLOhfyCPeS5Vlayub0dvKPw8EaxTs+gRWjkA/QNWfARK2
ybsj4GCfG8Pi8/KBp4NfIT2sneFxpDW3mh511rfTXbm9+HH600oP7+kvwDDpc+kc
TVh2u9TnJ2663MO9UtMLD1XC8qQl0mKuOP8QHE2n3+JwxSVMsK64+GxyTQnzmlYl
doKxb04kabG+sf8rFbmlCyHw+A17Y0Oq1VZ991YjnNemSD2VnZZ36cgVMeUS4Gax
7jb3beGn5gc=
=CihV
-----END PGP SIGNATURE-----

--=-Un9wz/dxjpXOKf97hvmx--

