Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59945 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbXITNuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 09:50:18 -0400
Subject: Re: [PATCH 3/3] adm8211: Adapt to filter configuration API
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200709181742.33948.flamingice@sourmilk.net>
References: <20070918213833.8850.90828.stgit@magic.sourmilk.net>
	 <200709181742.33948.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hf072rxP7j0f3oonwHLI"
Date: Thu, 20 Sep 2007 03:09:20 +0200
Message-Id: <1190250560.18521.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hf072rxP7j0f3oonwHLI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-18 at 17:42 -0400, Michael Wu wrote:

> +	} else if ((*total_flags & FIF_ALLMULTI) || (mc_count > 32)) {

Why the > 32 btw? The other branch below:

> +	} else {
> +		priv->nar &=3D ~(ADM8211_NAR_MM | ADM8211_NAR_PR);
> +		mc_filter[1] =3D mc_filter[0] =3D 0;
> +		for (i =3D 0; i < mc_count; i++) {
> +			if (!mclist)
> +				break;
> +			bit_nr =3D ether_crc(ETH_ALEN, mclist->dmi_addr) >> 26;
> +
> +			bit_nr &=3D 0x3F;
> +			mc_filter[bit_nr >> 5] |=3D 1 << (bit_nr & 31);
> +			mclist =3D mclist->next;
> +		}

looks like it's a simple hashing algorithm to filter for the multicast
address, so any number of addresses should be ok as far as I can tell,
you just see all multicast frames in a given class of the 64 classes you
have. And if many of the >32 addresses hash to the same value, it might
still be advantageous to use the filter.

johannes

--=-hf072rxP7j0f3oonwHLI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8chA/ETPhpq3jKURAh5FAJ0cMguJ/x+Jd7gHOzs1vkcpN/9hdQCgmNIh
CQV3hAS8NLqVTQpRI/f+ZVY=
=fvlk
-----END PGP SIGNATURE-----

--=-hf072rxP7j0f3oonwHLI--

