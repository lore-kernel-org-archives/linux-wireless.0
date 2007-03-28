Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965573AbXC1SYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 14:24:16 -0400
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: mohamed <mabbas@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JEyGv9mdABH+HqPQvXwL"
Date: Wed, 28 Mar 2007 20:23:00 +0200
Message-Id: <1175106180.5151.76.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JEyGv9mdABH+HqPQvXwL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-26 at 04:40 -0700, mohamed wrote:

> +	ethertype =3D (payload[6] << 8) | payload[7];
> +
> +	if (likely((memcmp(payload, rfc1042_header, 6) =3D=3D 0 &&
> +		ethertype !=3D ETH_P_AARP && ethertype !=3D ETH_P_IPX) ||
> +		memcmp(payload, bridge_tunnel_header, 6) =3D=3D 0)) {
> +		/* remove RFC1042 or Bridge-Tunnel encapsulation and
> +		* replace EtherType */=09
> +		skb_pull(skb, hdrlen + 6);
> +	} else {
> +		skb_pull(skb, hdrlen);
> +	}
> +
> +	eth =3D (struct ethhdr*)skb->data;

If you put the eth =3D stuff before ethertype =3D you can make this code
something like ethertype =3D be16_to_cpu(eth->h_proto) instead of the
hardcoded endianness conversion. And the memcmp() could be
compare_ether_addr(eth->h_dest, rfc1042_header) instead.

> +	while ((u8*)eth < skb->data + skb->len) {

I don't understand this cast of eth to u8*. That seems wrong given that
there's an ethhdr there where the first byte isn't a length byte.

> +        	unsigned int eth_len =3D sizeof(struct ethhdr) +=20
> +						ntohs(eth->h_proto);
> +       =20
> +		frame =3D dev_alloc_skb(3000);

Maybe there's a way to get an skb that actually points into the payload?
Not sure that is desirable though we really should optimise the receive
path.. it does far too many copies already.


I'll look some things later again, have to go now.

johannes

--=-JEyGv9mdABH+HqPQvXwL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCrKE/ETPhpq3jKURApqoAJ94daebkoXR96E5kikTi2lVxVA2rwCbBmk4
wO5FgyehD0W8VhR54W9YhmM=
=wSey
-----END PGP SIGNATURE-----

--=-JEyGv9mdABH+HqPQvXwL--

