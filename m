Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZG0PK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 11:10:58 -0400
Subject: Re: [PATCH] dell-laptop: Fix rfkill state setting
From: Johannes Berg <johannes@sipsolutions.net>
To: Tim Gardner <timg@tpi.com>
Cc: mjg@redhat.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090727144747.E7F4EF891B@sepang.rtg.net>
References: <20090727144747.E7F4EF891B@sepang.rtg.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MtwlRJFtkbhy0UfulYQy"
Date: Mon, 27 Jul 2009 17:10:18 +0200
Message-Id: <1248707418.8500.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MtwlRJFtkbhy0UfulYQy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-27 at 08:47 -0600, Tim Gardner wrote:
> Matthew,
>=20
> I think the rfkill state change logic is inverted. I've tried the origina=
l
> code on 3 different Dell models. Once 'rfkill block all' is run, then you
> can never unblock 'dell-wifi: Wireless LAN'. With this change you can get
> it unblocked, but you need to run 'rfkill unblock all' twice (which is
> likely an issue with rfkill).
>=20
> rtg
>=20
> From 778aec563a251418e455d63f711aab1c936bff73 Mon Sep 17 00:00:00 2001
> From: Tim Gardner <tim.gardner@canonical.com>
> Date: Mon, 27 Jul 2009 08:30:54 -0600
> Subject: [PATCH] UBUNTU: [Upstream] dell-laptop: Fix rfkill state setting=
.
>=20
> rfkill enable/disable transitions are predicated on the state of the
> external hardware switch, i.e., if the external switch is in the on posit=
ion,
> then no rfkill state transitions are allowed.
>=20
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/platform/x86/dell-laptop.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/de=
ll-laptop.c
> index 74909c4..cf40c4e 100644
> --- a/drivers/platform/x86/dell-laptop.c
> +++ b/drivers/platform/x86/dell-laptop.c
> @@ -197,8 +197,11 @@ static void dell_rfkill_query(struct rfkill *rfkill,=
 void *data)
>  	dell_send_request(&buffer, 17, 11);
>  	status =3D buffer.output[1];
> =20
> -	if (status & BIT(bit))
> -		rfkill_set_hw_state(rfkill, !!(status & BIT(16)));
> +	/*
> +	 * Don't change state unless the read-only HW rfkill switch is disabled=
.
> +	 */
> +	if (status & BIT(16))
> +		rfkill_set_hw_state(rfkill, !!(status & BIT(bit)));

Hmm. The previous code was

-       if (status & (1<<16))
-               new_state =3D RFKILL_STATE_SOFT_BLOCKED;
-
-       if (status & (1<<bit))
-               *state =3D new_state;
-       else
-               *state =3D RFKILL_STATE_UNBLOCKED;
-
-       return 0;

where new_state was initialised to RFKILL_STATE_HARD_BLOCKED.

So doesn't that mean that 1<<bit is the hard-block bit? Or was the
previous code just bogus, but happened to work since rfkill didn't
separate the hard/soft kill concepts?

johannes

--=-MtwlRJFtkbhy0UfulYQy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbcNVAAoJEODzc/N7+QmabhgQALpyP/Nz4s6XQXCwJ48GSUKa
r9xmuzVJAFgOKCRK6tOTXDqyt00T2EWsI8n/eLaa6n0rvJ8tfmor9p474iVOKIKQ
LGXJP9wdMyHVjuoc8M3oD61KPbOncLXS8mIcjZo4leeiZcXfyonUpy1Edy/uE13A
epQWfKA9wQ3ruXJ4aYlU5mF5VGUosV0xcA3gaipCIqL4eMJbKsPahRIXp/fQCHwG
kNZGCYRb5woMT/izcVJkejcNLDkAaExNJU2XWIkHxA3/AEOU2uh6u3tRn2yBMn7+
XTKI6D36HHW0w3ELVYE2/21snErO2z2n0+qG/B4RWZPPU9363CeY0Uh0SfTns3vH
jttPyu0Iv/vKN9aoi1d0aq7mseqKFha3HrOWrG+pvOdt7hxnKQDPmo8umxDzYQpk
sDnz9UFmOOyO1+0Rk+MEGk4wkxgTmf0RUmH/0bvSha//VDTpoe0n12wCG3VerVJS
aFXwfcSse96vnljyyxTaA27+BpgX/9s4f4C3ivCI6xUb+qxF9mJzYHG9VoYrbiut
3CrfdM3iNo/fM5Nq5qiEQCRZ/ba6dpVvzWucXeY44gJuIJQJO6yIs8acKlj2/8Xn
xS4UT75pHF4wvsjn5MWVZca2yXQV7kmypY3uILtC513QelgnItHKB0LdYPjsMEQE
OPOQ1NAJqYpFJ5QMHmgS
=Onqp
-----END PGP SIGNATURE-----

--=-MtwlRJFtkbhy0UfulYQy--

