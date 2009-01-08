Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbZAHNDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 08:03:03 -0500
Subject: Re: [PATCH 6/6] cfg80211: Fix parsed country IE info for 5 GHz
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1231379017-28363-7-git-send-email-lrodriguez@atheros.com>
References: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-2-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-3-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-4-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-5-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-6-git-send-email-lrodriguez@atheros.com>
	 <1231379017-28363-7-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E6rA+PuZV7f/srWm/15P"
Date: Thu, 08 Jan 2009 14:04:00 +0100
Message-Id: <1231419840.3685.12.camel@johannes> (sfid-20090108_140308_858601_589BE2DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-E6rA+PuZV7f/srWm/15P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 17:43 -0800, Luis R. Rodriguez wrote:
> The country IE number of channels on 5 GHz specifies the number
> of 5 GHz channels, not the number of sequential channel numbers.
> For example, if in a country IEs if the first channel given is 36
> and the number of channels passed is 4 then the individual channel
> numbers defined for the 5 GHz PHY by these parameters
>=20
> are: 36, 40, 44, 48
> not: 36, 37, 38, 39
>=20
> See: http://tinyurl.com/11d-clarification
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |   21 +++++++++++++++++++--
>  1 files changed, 19 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index bea98ed..b34fd84 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -563,6 +563,7 @@ static struct ieee80211_regdomain *country_ie_2_rd(
> =20
>  	/* This time around we fill in the rd */
>  	while (country_ie_len >=3D 3) {
> +		int end_channel =3D 0;
>  		struct ieee80211_country_ie_triplet *triplet =3D
>  			(struct ieee80211_country_ie_triplet *) country_ie;
>  		struct ieee80211_reg_rule *reg_rule =3D NULL;
> @@ -584,6 +585,23 @@ static struct ieee80211_regdomain *country_ie_2_rd(
> =20
>  		reg_rule->flags =3D flags;
> =20
> +		/* 2 GHz */
> +		if (triplet->chans.first_channel <=3D 14)
> +			end_channel =3D triplet->chans.first_channel +
> +				triplet->chans.num_channels;
> +		else
> +			/*
> +			 * 5 GHz -- For example in country IEs if the first
> +			 * channel given is 36 and the number of channels is 4
> +			 * then the individual channel numbers defined for the
> +			 * 5 GHz PHY by these parameters are: 36, 40, 44, and 48
> +			 * and not 36, 37, 38, 39.
> +			 *
> +			 * See: http://tinyurl.com/11d-clarification
> +			 */
> +			end_channel =3D  triplet->chans.first_channel +
> +				(4 * (triplet->chans.num_channels - 1));
> +
>  		/* The +10 is since the regulatory domain expects
>  		 * the actual band edge, not the center of freq for
>  		 * its start and end freqs, assuming 20 MHz bandwidth on
> @@ -593,8 +611,7 @@ static struct ieee80211_regdomain *country_ie_2_rd(
>  				triplet->chans.first_channel) - 10);
>  		freq_range->end_freq_khz =3D
>  			MHZ_TO_KHZ(ieee80211_channel_to_frequency(
> -				triplet->chans.first_channel +
> -					triplet->chans.num_channels) + 10);
> +				end_channel) + 10);
> =20
>  		/* Large arbitrary values, we intersect later */
>  		/* Increment this if we ever support >=3D 40 MHz channels

--=-E6rA+PuZV7f/srWm/15P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZfm+AAoJEKVg1VMiehFYI2AQAKqiNZhywhgls3tYJckHX9qt
kOP3S6UfGn8gjjbHmhE7nSTVMAXnXAlGl+W26gM5tCeTupU04W4vJL3UxBoWonRp
COOWEgcLkOMzGsY8D5Gvy4pjOvZ2R/FHDOHC8DGKfsiven5AAcCJF+kG/HPMRmp1
Fj8aP1c+9axZbRIjayNwXkYb/SqpQcsLHcxI4dXX+pSPnbRZB24VDj1LQ27aND+d
E9iE7P2jjkNTK8VcJLbo/9ahVL43+YEh7TFx3HReB9BnCrfkbjZDPY/hLdyTQP3p
ylyUWthuLd02zVr7CN+++o8YQY/GcmEA5DrbLuvgpPe7klqghZygfitNxGkmX8Ao
u9Pttd79oI3sj+zruYBnYuPpehag2rkD1vR/uIifrE0/Yfs5f2+DI8TrXKwEDUXF
8A8DHLwTg/XKx8+Dr2rjUg0e8JzR9f5TYKLCwbrgD1Vaqwc+6tzTS4bwJ8eRfmmV
1rrI99o4p1Cf5rws+oqtoL5MeYAM4T0/DC/cZh6P7GEJ//LFKi20tFJdVCI0zP6t
jrs+LwWhEryVXBrD+qEm6iqG3T4gmm3Y4BYMIerAFtbnK58XB9que3KRtGO0/iqa
BAoMbrKnigeR7/RAZ8K0x/il+BVPqrUTCitt2+9VJyghBecvG/DZNnBfD3pFXWKK
yF7L341rgpLfTSYj3khX
=iZ0V
-----END PGP SIGNATURE-----

--=-E6rA+PuZV7f/srWm/15P--

