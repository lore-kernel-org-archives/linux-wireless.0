Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44801 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763434AbZAPJXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:23:31 -0500
Subject: Re: [PATCH 06/13] cfg80211: process user requests only after
	previous user/driver/core requests
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-58cW0M3R+1EpNl3Wv8ou"
Date: Fri, 16 Jan 2009 10:22:57 +0100
Message-Id: <1232097777.3854.23.camel@johannes> (sfid-20090116_102336_116803_BD6ADA0F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-58cW0M3R+1EpNl3Wv8ou
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> This prevents user regulatory changes to be considered prior to previous
> pending user, core or driver requests which have not be applied.

This seems appropriate, given that we don't actually keep track of
requests that were successful or not.

> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/reg.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 0cc19e7..b7c6de1 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1119,6 +1119,16 @@ static int ignore_request(struct wiphy *wiphy, enu=
m reg_set_by set_by,
>  		if (last_request->initiator =3D=3D REGDOM_SET_BY_USER &&
>  			  last_request->intersect)
>  			return -EOPNOTSUPP;
> +		if (last_request->initiator =3D=3D REGDOM_SET_BY_CORE ||
> +		    last_request->initiator =3D=3D REGDOM_SET_BY_DRIVER ||
> +		    last_request->initiator =3D=3D REGDOM_SET_BY_USER) {
> +			if (alpha2_equal(last_request->alpha2,
> +			    cfg80211_regdomain->alpha2))
> +				return 0;
> +			else
> +				return -EAGAIN;
> +		}
> +
>  		return 0;
>  	}
> =20

--=-58cW0M3R+1EpNl3Wv8ou
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcFHrAAoJEKVg1VMiehFYmzUP/0UzePvLmwYAoFVbZeQmmH9P
78MF6LBXwhlJCq01sRFNXAevDPU+BwvyV2JOuRDF4ZTl/e6Xud9PpjdOkyoQ062p
Q0YADgoJ+AQHMkCHJfj/SfP3SI0kqYuU5BSYIfgMDPYXn3achz+o0Trb4bLlrhUI
RkXXgYcMX+/UXC6PMeSBtcWGVhGiqAMBun0uk4Xln4O4T2/1xn/UZjj4uZKyqwhc
LtiNhLzE6VHqsxwe/nn4vLePU6oEW3jNGxAqbGFomAfo1teofK9/hCVdvFbDmvCU
633UUq0kl0j71bcyas2DeDIZueRCJkAgGvcgG2Wm3RP69Bw27gTWDM1qCBkf/rxj
8UjBbeWafMDKwojvokYrRpasox9NbIl8GkECFfNpXZXDpbAbnzVmwj7tXkyWtohP
Uux3spsm1uSN3qj9EN98Tx6+27r5c5EQgknU7Vq8/G9R3MJswSCMN9o8cPR9DV02
nUpGWwEaueJJkpNYKcrpPt+9CzBqdUwFnAEbG0dAZOtEjlHOiajjoL77FtF8Lyd1
Y9wTw10trrJK92ERBDWZK+WYELpizClJFIGc3BKK8R8kSfG5q1vknbvdGLctIp+n
h9zJGyP08qGVsXYiOkOCtXcPCdL9g57L4W+vp1c+81VabtQ5R1QDx76CcEyfYcIU
iWkvmGIA85kMwBhcnoDc
=D0CA
-----END PGP SIGNATURE-----

--=-58cW0M3R+1EpNl3Wv8ou--

