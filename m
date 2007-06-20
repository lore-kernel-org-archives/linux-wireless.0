Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40861 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbXFUKme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 06:42:34 -0400
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: mabbas <mabbas@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <46137FF2.6020203@linux.intel.com>
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <1175111599.5151.123.camel@johannes.berg>
	 <46137FF2.6020203@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W1W1EwvSAAdEKlOdzs4o"
Date: Wed, 20 Jun 2007 23:13:39 +0200
Message-Id: <1182374019.3714.87.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W1W1EwvSAAdEKlOdzs4o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Mohamed,

> +		padding =3D calc_pad_len(subframe_len);
> +		/* the last MSDU has no padding */
> +		if (subframe_len > remaining)
> +			return TXRX_DROP;
> +
> +		frame =3D dev_alloc_skb(local->hw.extra_tx_headroom +=20
> +				      subframe_len);
> +
> +		if (frame =3D=3D NULL)=20
> +			return TXRX_DROP;
> +
> +		memcpy(skb_put(frame, subframe_len), (u8*)eth, subframe_len);
> +		frame->mac.raw =3D frame->data;
> +		skb2 =3D NULL;

Here you allocate a new frame which can be sent back to the device when
one of the aggregated frames was a multicast frame and we're an AP
device. You also correctly add extra_tx_headroom, but it seems that this
is missing some skb_reserve(extra_tx_headroom), no? Could you make a
patch adding it? I'm not sure I fully understand the code there.

johannes

--=-W1W1EwvSAAdEKlOdzs4o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGeZiC/ETPhpq3jKURAguRAKCFNbO3GCv9W9nZ0uP6oekaZZc6QgCdFpUd
QIDUNS3YEo8ztPMPXSrKupU=
=Nr7N
-----END PGP SIGNATURE-----

--=-W1W1EwvSAAdEKlOdzs4o--

