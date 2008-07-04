Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46152 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbYGDLnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 07:43:04 -0400
Subject: Re: [PATCH 4/4] rt2x00: Report RX end time for rt2400pci
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807041341.57998.IvDoorn@gmail.com> (sfid-20080704_133819_349513_2A0E44DE)
References: <200807041340.28103.IvDoorn@gmail.com>
	 <200807041340.53147.IvDoorn@gmail.com>
	 <200807041341.31830.IvDoorn@gmail.com>
	 <200807041341.57998.IvDoorn@gmail.com>
	 (sfid-20080704_133819_349513_2A0E44DE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yENkYCkFCwXbMYZi5LmL"
Date: Fri, 04 Jul 2008 13:42:03 +0200
Message-Id: <1215171723.19862.4.camel@johannes.berg> (sfid-20080704_134309_884350_B0FE92F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yENkYCkFCwXbMYZi5LmL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  	rt2x00_desc_read(entry_priv->desc, 0, &word0);
>  	rt2x00_desc_read(entry_priv->desc, 2, &word2);
>  	rt2x00_desc_read(entry_priv->desc, 3, &word3);
> +	rt2x00_desc_read(entry_priv->desc, 4, &word4);
> =20
>  	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
>  		rxdesc->flags |=3D RX_FLAG_FAILED_FCS_CRC;
> @@ -1106,6 +1108,7 @@ static void rt2400pci_fill_rxdone(struct queue_entr=
y *entry,
>  	 * The signal is the PLCP value, and needs to be stripped
>  	 * of the preamble bit (0x08).
>  	 */
> +	rxdesc->timestamp =3D rt2x00_get_field32(word4, RXD_W4_RX_END_TIME);

You really should extend that, like this it's going to cause trouble as
soon as it has overflowed 32 bits once.

johannes

--=-yENkYCkFCwXbMYZi5LmL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIbgyGAAoJEKVg1VMiehFYg/EQAJPTcp6LAU1ONQhXipOpIGaU
Z539eD6fT/FM6sDV9qrC/O5WzJBrdcdWNYqS4EkMTA93H5qEiaIfP02qUPhGX8IQ
r4iKtTA9K1gq1nIZ3CGDexbFcSZIa8JkjLG7qYS3QV0brmH+kbUeQzaA3H5lLwpk
VQqVWowC4utHdpv3DRG9vq/InWct7rz+j5bIHM71lfFs8roYxgZgjNLsrFDzULzp
926bomTQ9UlHqNpHA2UnEJcF5IpQjiMozWNfGHqoiZp4qQ4yLgfVPZ5VOUNTCqsO
petNhzjCvcpEhlvOG+sAj5F0AZ/AYe2uDDhQynIrdY7jwCSWrURYikHXJ4B+OwK0
zuPSOv1aa/TFCX88h6NYlngFsZTZs+K4KciDXO2VgopoNQODooigMe7NtU/HhQ7m
1V/LbdBMP/sf5YL7MgSdSmfqP3NT/KjQltAYYNwdoamnA66KsIAgVOdFuFv9oAkk
0Jut1ZzK1aWqPmdlnszYpQc/3XJSopQPWjF9CPiUD1rJjSMhnxcp8nhx7mY8efEh
iOCOLvEh48y/SbTmWdv3JzxhI1q/viXreTY4lSrpHAQeP8jlPjYW+GUx1YeOe/3r
Z9AiAtkUwmvxSaaXXS10wF4WCAY6iTP22b3s9s24HtM8H8/3UeHEkl0Q/b16WY2L
jfJ/uvX0zxBvDb3X2Anz
=cCsH
-----END PGP SIGNATURE-----

--=-yENkYCkFCwXbMYZi5LmL--

