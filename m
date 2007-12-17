Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59500 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbXLQRnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 12:43:24 -0500
Subject: Re: [patch 3/9] mac80211: Add PID controller based rate control
	algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071217012550.127484236@gmx.de>> (sfid-20071217_012722_935905_F6E718EA)
References: <20071217012517.882216322@gmx.de> >
	  <20071217012550.127484236@gmx.de>> (sfid-20071217_012722_935905_F6E718EA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bB70v4TUo5Tn+OPb0D1A"
Date: Mon, 17 Dec 2007 12:50:10 +0100
Message-Id: <1197892210.4885.21.camel@johannes.berg> (sfid-20071217_174333_619195_57D75E1D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bB70v4TUo5Tn+OPb0D1A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	/* We need to do an arithmetic right shift. ISO C says this is
> +	 * implementation defined for negative left operands. Hence, be
> +	 * careful to get it right, also for negative values. */
> +	adj =3D (adj < 0) ? -((-adj) >> (2 * RC_PID_ARITH_SHIFT)) :
> +			  adj >> (2 * RC_PID_ARITH_SHIFT);

That looks... weird.

As far as I know all compilers the kernel can use will do an arithmetic
right shift if the data type is signed.

johannes

--=-bB70v4TUo5Tn+OPb0D1A
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2ZicaVg1VMiehFYAQLTHxAAtDoMH1bYLor+AbMFDQY8lamcGY6KXpnB
u+Qn5FSipn7CFEn9W9JZK12k7oWNE2iRCmAf7HWeRLYACw7l/IWH7d7C6pIjUr6k
dZ5M3OnMRuNzc/imEse462nPfQUtAicFid4I0KLf37W3ayW5mQAsM1uDH8LmLswG
4alCXjZ3+cAynyU8stQt+rSz7s8ZZh7bBjKda7LBlQKtMKlL9x+7EFIROi3WKc00
sS6Gf4Vt7Eaq4B8GkV8gxWRTyRMIWg3O7Qmu4rKPi5qrGytO/bidr59BdWjLSc+s
wJGHf6QfSOAnaJx884ZlL1uDoepBfCelQ+EJ6QjCJ/DLd+UpESRWHcUgWdcq3Yzy
E4iviRZeODBMgNYVliiU3MBHXr/2qR8YD5jFUozC5B3ynX2vSgG7M8166o8DRiFO
ChdWF4mOF1sVZMQ7ZPM6qcYFlW8sE64VB9E/0+I2O5l32MxK3zLb0gp8BPOHUCOq
Ohbgr2/eJcGabJ2G3DvgSogjhRxFEonMosTRR0txi5uWJaJc6bK8z63AHwcGN6X6
P+maSzyjGOr/XgGkxLDukWO0Mkes7KxSTSvgF+B8kb9bw9PHGgXQ7Vq/SAvJzHZr
zzjnsliabu/7LwVJheCQta8S2qfhtXYiInQLgaburKyR8xqd0DO6gcg3S5+q0Qhb
PwZ3T3yeB6c=
=X5Ge
-----END PGP SIGNATURE-----

--=-bB70v4TUo5Tn+OPb0D1A--

