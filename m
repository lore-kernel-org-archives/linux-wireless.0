Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57520 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbZGMLaa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 07:30:30 -0400
Subject: Re: [PATCH] rfkill: fix rfkill_set_states() to set the hw state
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4A5A0941.2000408@tuffmail.co.uk>
References: <4A5A0941.2000408@tuffmail.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CzZzrhydI0JH1aO1UevH"
Date: Mon, 13 Jul 2009 13:30:26 +0200
Message-Id: <1247484626.4166.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CzZzrhydI0JH1aO1UevH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-07-12 at 17:03 +0100, Alan Jenkins wrote:
> The point of this function is to set the software and hardware state at
> the same time.  When I tried to use it, I found it was only setting the
> software state.

Oops, thanks.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

This is for 2.6.31, obviously.

> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> ---
> net/rfkill/core.c |    4 ++++
> 1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index 79693fe..db9948e 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -549,6 +549,10 @@ void rfkill_set_states(struct rfkill *rfkill, bool=20
> sw, bool hw)
> 	swprev =3D !!(rfkill->state & RFKILL_BLOCK_SW);
> 	hwprev =3D !!(rfkill->state & RFKILL_BLOCK_HW);
> 	__rfkill_set_sw_state(rfkill, sw);
> +	if (hw)
> +		rfkill->state |=3D RFKILL_BLOCK_HW;
> +	else
> +		rfkill->state &=3D ~RFKILL_BLOCK_HW;
>=20
> 	spin_unlock_irqrestore(&rfkill->lock, flags);
>=20

--=-CzZzrhydI0JH1aO1UevH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKWxrOAAoJEODzc/N7+QmaIuwQAINilqiMmFpYOGb4WyOeRDVi
QsNOfy+Ta3v4/sTC5KfJcnpoM4dZPxc7SV/Q5/u0oNKZZ3WeedID+qcrn/zubf4Y
62h7qEHpcaWjbPMLI9wUKWw7mewhJgUcqoiMMKQOh122Mbv2LKw93LDx3TSbRHoT
tEeSS6mPXUubBNCNoIF9hnTS/HykSTjXUlCocq1p2oU831lbjxVPQSSgH/JSStZV
beU0oDsjCGc1goktthjZFZzoYQwpJ98tzuQE2UVMGIEWE/cFfrlrP3Zz/u6jZdml
Ab1BrGMFbmM+B76mKwC8HlC8VcGs6R3CjTguXI5ModI7fUWe17WXXAL38usfeXTy
8/FMDdtGqlrWBEq/pVRD5KCqPfE9fdJiy+E8AdnGw9kJuOYf5EZGkPsd5VU2qKqT
8+cUkJ7LPP3h9NUNKrigcuTAZ4XetRl78YNSc7C2K0Zb5RhshhSHzsJqvJ7dSKaZ
Tb5RTcFfSXVxIkNuau3/JFGEOaLKV45W6Zu4v+vrtYBZYlWJpKODQQ1kRQWYlzQx
W+p9OyEM2cVfoJzNfDqA5H3cmf3yG3mWcOISjdrv/uZ3H8VYFFg8eHy7DUs0fS/M
Lc68Ojjhf2Q32Z8UTVp2eEQnZ5t9lH9klyu85hA0TZsMAuZG1WkniMhXHHVcZsso
7IJbtnOfUDe+ouN4jzzg
=MACD
-----END PGP SIGNATURE-----

--=-CzZzrhydI0JH1aO1UevH--

