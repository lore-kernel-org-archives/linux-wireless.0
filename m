Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbXHHJOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 05:14:10 -0400
Subject: Re: [RFC] allow device to stop packet mirror behaviour
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, andy@warmcat.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070807.180607.116354128.davem@davemloft.net>
References: <1186475155.4067.17.camel@johannes.berg>
	 <20070807.180607.116354128.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zqmS7C6YYBPr5fhexhkT"
Date: Wed, 08 Aug 2007 11:14:01 +0200
Message-Id: <1186564441.11717.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zqmS7C6YYBPr5fhexhkT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-07 at 18:06 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Tue, 07 Aug 2007 10:25:55 +0200
>=20
> > The only way to solve this problem therefore seems to be to suppress th=
e
> > mirroring out of the packet by dev_queue_xmit_nit(). The patch below
> > does that by way of adding a new netdev flag.
>=20
> Multicast packets also get looped back in a similar manner in the ipv4
> code.  These will also be seen twice due to this issue.

I don't think these other places are of any interest because of the
radiotap+802.11 framing on the devices where it is relevant to us; you
can't actually add an IP route to a monitor interface as far as I can
tell.

johannes

--=-zqmS7C6YYBPr5fhexhkT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGuYlZ/ETPhpq3jKURAlZTAJ4vllyzg0QZCC6vIPFcUoBnfTCndgCgnLR8
dY0FGxSmBgMolwL3nMAI3z8=
=fAR9
-----END PGP SIGNATURE-----

--=-zqmS7C6YYBPr5fhexhkT--

