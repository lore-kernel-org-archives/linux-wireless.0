Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab0BWPZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 10:25:13 -0500
Subject: Re: [RFC] Improve software scan timing
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <201002231619.55189.helmut.schaa@googlemail.com>
References: <201002231619.55189.helmut.schaa@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8+bI3ZX0NoJH8TSfC3dJ"
Date: Tue, 23 Feb 2010 16:25:10 +0100
Message-ID: <1266938710.3934.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8+bI3ZX0NoJH8TSfC3dJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-02-23 at 16:19 +0100, Helmut Schaa wrote:

> However I've got a few open questions:
>=20
> Does anybody know if pm_qos is already used by any applications? At
> least on my system it seems that nothing sets any latency requirements.

Yeah, it doesn't seem to be used...

> Should we also consider the current listen_interval for deciding how
> long
> we could stay away from the operating channel? That should prevent us
> from losing too many frames but since most drivers don't register a
> max_listen_interval we usually end up with a listen_interval of
> 1 which is quite short (which means only scanning one channel in a
> row).
>=20
> Kalle, Johannes, how is the listen_interval handled in the powersave
> code?
> Are we only sleeping for one beacon interval or are we ignoring the
> listen_interval currently.

I figured this listen interval stuff would come back to bite us at some
point. I don't think we should negotiate a listen interval of 1. OTOH,
I'm not convinced that all APs would reject it with a status code of 51
if it's too large? Or is that tested anywhere like WFA?

In any case, right now the powersave code pretty much ignores it,
although that's not really a good plan.

johannes

--=-8+bI3ZX0NoJH8TSfC3dJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLg/NTAAoJEODzc/N7+Qma6YUP/3carR0rUYBCSK6TZUU0r+mM
4UIKhnaI20VkaLqoaG73EMROnBaQYyHeuEKJi/gfUl13JRSai4gAQ9XXRm3Ew7qy
w+3OlYWV2KPRCaDb50cyyGx5LoQN6X9w/I6UGiBezGsebxv0Q/w6lq3qBN+4g5Gu
HmsNtrHX9xYB14G+ESbrT27/MvNNQ2xwo+KUsKrc1LR2k62VYvIKEMXo73xP0n5s
HCFlqNzepNzdmujFo+wr6MCPh8Sdq2zAKV7AY6stymuHqvAWimReXgEn3RcBoprf
Caj4w8Dy+zWozoPGUhnDB+24/wR8/yMQp3Q9vW3mNwrv8cIYBysT32aNrM0h7IJs
7irGQLh/jqZz9OHl9ln/EJcAFxKEIwGKlIAbpEWm0oRT96vTG4Qgzmboq+xzrf9B
6neMTUowV8Exp17V7bvghFMNPP8W5j8NJcymYvXJyQSwx3p9ni6GBfeYPbysgYU+
m4/wLNc9zua1WXZwutOzMbQ0F66hmnQa6JXgM6P2sqj7c56dttYiNP3Ve4QVcy/s
OgYESLG3f0c6vuUzJs044UffzpMqbx3h5dmZe6e+UQtGEXu90VFp3ju1R3H914BG
rqprR1gZIPxKyTvtL1eUEgURVkzel9lLrUEscEX36o3/5Qzq5ziEusmNgE9cXrKD
eUkPcnjAfUAMyai0c2Z4
=Hpgf
-----END PGP SIGNATURE-----

--=-8+bI3ZX0NoJH8TSfC3dJ--

