Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXHCOrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 10:47:07 -0400
Subject: Re: [PATCH 18/24] rt2x00: Add Multicast/Broadcast filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200707312037.33060.IvDoorn@gmail.com>
References: <200707312037.33060.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cPrZK2OZshx/6rqg4dJn"
Date: Fri, 03 Aug 2007 16:01:16 +0200
Message-Id: <1186149676.4647.42.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cPrZK2OZshx/6rqg4dJn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-07-31 at 20:37 +0200, Ivo van Doorn wrote:

> +	if (is_monitor_present(intf)) {
> +		filter =3D IFF_PROMISC | IFF_MULTICAST | IFF_BROADCAST;
> +		if (intf->filter !=3D filter)
> +			__set_bit(PACKET_FILTER_PENDING, &rt2x00dev->flags);
> +	}

Don't do that. There's no requirement that monitor mode interfaces
always be promisc. Also, earlier in the code:


> +       int promisc =3D !!(filter & IFF_PROMISC);
> +       int multicast =3D !!(filter & IFF_MULTICAST);
> +       int broadcast =3D !!(filter & IFF_BROADCAST);
>         u32 reg;
> =20
>         rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
>         rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME, !promisc);
> +       rt2x00_set_field32(&reg, RXCSR0_DROP_MCAST, !multicast);
> +       rt2x00_set_field32(&reg, RXCSR0_DROP_BCAST, !broadcast);
>         rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);

Depending on how the hardware behaves I think promisc should imply the
other two, it seems likely that even with DROP_NOT_TO_ME turned off you
won't be getting multicast traffic and promisc should see that too.

johannes

--=-cPrZK2OZshx/6rqg4dJn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGszUs/ETPhpq3jKURAkWDAKCBm/I0hEvDOZc7ulOrmu+l05XowwCfUcoU
KHPyH5Y2FzwCZwGzF8CS7JI=
=7WnP
-----END PGP SIGNATURE-----

--=-cPrZK2OZshx/6rqg4dJn--

