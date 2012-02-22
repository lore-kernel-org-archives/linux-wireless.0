Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:21730 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2BVHw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:52:57 -0500
Date: Wed, 22 Feb 2012 10:54:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Harry Wei <harryxiyou@gmail.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] Staging: wlan-ng: memsetting the wrong amount of data
Message-ID: <20120222075438.GA3680@mwanda> (sfid-20120222_085302_020015_97DEBF14)
References: <20120221141838.GA7998@elgon.mountain>
 <4F43C8CE.8060602@bfs.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
In-Reply-To: <4F43C8CE.8060602@bfs.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 21, 2012 at 05:39:42PM +0100, walter harms wrote:
> > -	memset(&(msg1.bssid.data), 0xFF, sizeof(p80211item_pstr6_t));
> > +	memset(&msg1.bssid.data, 0xFF, sizeof(msg1.bssid.data));
> >  	msg1.bssid.data.len =3D 6;
>=20
> maybe msg1.bssid.data.len is related to msg1.bssid.data ?
> I guess sizeof(msg1.bssid.data)-1 (why -1).
>=20
> perhaps you can fix both ?
>=20

It's an interesting point.  The problem is that I don't actually
have this hardware.  On the patch which I sent, it was obvious what
the intent.  My guess is that msg1.bssid.data[] should have 6
elements instead of 7, but I don't feel confident enough to sign off
on that.

Let's fix this bug which is obvious and let someone who knows how to
fix that other question address it.

regards,
dan carpenter

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRJ8+AAoJEOnZkXI/YHqRua0QAIrwSKR//PUB7xueKBQ/BBkP
4X0pcMRysq4CNzqKzbj5SzOL1Heuw7xcn4YYEs7J5VqcgWsdKIPENSxnOhl/laQC
FjUAn8oO+18kXUqdYJBCfOTFVBzZ7n02/sEcgbc74AIo/A6jlaJHz9CX8P08wPuc
rVUcRpPzeWq0YwWNKf230Ss/UI6mcsG3JT00O+gT6Xy8xrYAfwLM/2E86UUNE9Uh
sU+oMkRnSoFlDBh2ry3DUzA6cSVyVlBzDVDbLNsrDzg4lpQk48EXlPSpOLplyKt4
huFS3c6IOmlwJRRUDkILCxLdW9IczOm6kpYKJ5qNvaAIaeJdHA/SmTwJkhPu2i7G
hNdh4qaRzaUL6mDXTYcUk2aEZw8xAZiAOYI8nLxRqBXwODrnwSg4DgPY/Wt66gQL
tMw//GhdbrFLkCwm11NyHMnMLwvUUnh2h6bJ3CRep7SPI4sv344TzFUpbf9iFAkZ
ieqgPHK6g6Vq50vjlycz64wIB2RqZUYomZIoolxCyaVEonRCWrGAN738Ojpi5Uv5
KpKQrcgkhEiFdZyO19t7b3aMOzz0mEwR2LSTHsJp/NrjMOvuoX1fFnOWjDEr8TVR
a4lRIblcOMIny9W4DoiV4GPOZgm7ck8gz+SZU36pyOQi8npTdYWTjMIdUtDoymMx
Nmj3PgGVfxy6wvBtV5tE
=RQTe
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
