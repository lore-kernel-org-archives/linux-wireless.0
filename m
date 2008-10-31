Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYJaVr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 17:47:29 -0400
Subject: Re: crash with rt61pci when resuming with card ejected
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200810312031.03314.IvDoorn@gmail.com> (sfid-20081031_203107_683292_57F3282C)
References: <1225361553.3690.3.camel@johannes.berg>
	 <200810302247.28609.IvDoorn@gmail.com>
	 <1225408055.3535.1.camel@johannes.berg>
	 <200810312031.03314.IvDoorn@gmail.com>
	 (sfid-20081031_203107_683292_57F3282C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MuqqhHhg8+IPdlX1tQ4A"
Date: Fri, 31 Oct 2008 22:47:24 +0100
Message-Id: <1225489644.3550.0.camel@johannes.berg> (sfid-20081031_224734_145434_04B5DF12)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MuqqhHhg8+IPdlX1tQ4A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-31 at 20:31 +0100, Ivo van Doorn wrote:

> Hmm, it looks like CSR base is NULL, after which the H2M_MAILBOX_CSR
> offset is added to it (0x2100)
>=20
> The strange part is thet CSR is freed and set to NULL _after_ the
> rt2x00lib_remove_dev() call...
> Oh wait never mind, I get the picture, I missed the "ejected _while_ susp=
ended"
> part. I think what is happening is that first the suspend handler is call=
ed,
> and during resume not the resume handler but the remove handler is runnin=
g,
> and rt2x00 doesn't protect against that.
>=20
> Could you check if below patch does the trick? If I am not mistaken only =
the
> LED handler actually accesses the hardware to make sure they are off.

Now it crashes in config_pairwise_key or something like that, I can send
you the image if you want.

johannes

--=-MuqqhHhg8+IPdlX1tQ4A
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJC3zoAAoJEKVg1VMiehFYSiEP/2RzVMHS32MHuUqGRdOgMYZL
gKN3Diwl4AOemMEJN1OFUxMoH6bPEgUSjmOb0la8gLX+KVfZHMlH4gH8qgJlqzTT
4RXURgknliTI/iDfoJWA8mEFcOkcALMsSR6N+IYiT7viJuOjMYfIJqLZEBTy+k5E
I/5akKJ6d/5Ngpjny61T0Krviyes06QtZ6buhC/gMn4yUcvI/mq9NeT1xpRMS7Pg
XXCN4W0vACo8xb8LWLqyPT+D59cSwyihqMKOm1j0lI/LY+9A2rUlecw9LMo/txZZ
ySUnP5W2OQk74uQwrMDMY2Juz7/luLqq7ch+3qy5rAyY9+OFLsRL6Ce6OekXGJsK
AZfstrFThM7c0Ajq1vZbM1vPMRB471pq++83xv7u9FdO4WBu/SKNB9k362cVZHEq
NDJtrclIWKI2EibA6tLULiIZb5AnnuN2AyDXdjGdcCocKwA7q0QbDW49NKfbgAtW
ogBCMvN/WhLNoEsb0AjSQ+0H/xJMDeC8gb4GrRze4Lb0uBi2ezbkcxOUr/p5pZzS
x9BKfCZWtTx0n/o7n1EADd7df3YIF5KQ3QmIIiTxzeq8gYr4+7R66TMJvpJABZlK
aMruPA4Q8zyI2UIcUeoC/FXfQ/pyAwvqTS3WdqVNbHj2xRou5WAHgF3fXto4fNKb
3zc3uXf4DCsDDRPNP0cB
=gvfC
-----END PGP SIGNATURE-----

--=-MuqqhHhg8+IPdlX1tQ4A--

