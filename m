Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34176 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbXGPJgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2007 05:36:43 -0400
Subject: Re: [PATCH] rtl8187: ensure priv->hwaddr is always valid
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200707151709.55429.flamingice@sourmilk.net>
References: <200707151709.55429.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-whRVofKXcO4UietYs1o9"
Date: Mon, 16 Jul 2007 11:34:22 +0200
Message-Id: <1184578463.3773.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-whRVofKXcO4UietYs1o9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-07-15 at 17:09 -0700, Michael Wu wrote:
> =20
> -	priv->hwaddr =3D conf->mac_addr;
> +	priv->hwaddr =3D conf->mac_addr ? conf->mac_addr : dev->wiphy->perm_add=
r;

Do you allow monitor mode? If so, this isn't correct unless the hardware
is explicitly told to not do anything (most hw doesn't and we use a zero
mac addr for that). conf->mac_addr is NULL in monitor mode for a reason:
we don't want to have any mac address so we don't ACK packets.

johannes

--=-whRVofKXcO4UietYs1o9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGmzue/ETPhpq3jKURAttZAJsEe9yidzdI1pelJEwoX5rDbcxEFQCfVepv
4RMiuWASdHmu5qIokzIoJK0=
=xD6j
-----END PGP SIGNATURE-----

--=-whRVofKXcO4UietYs1o9--

