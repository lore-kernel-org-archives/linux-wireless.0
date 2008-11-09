Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39065 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYKIIwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 03:52:45 -0500
Subject: Re: [PATCH 1/1] mac80211: rc80211_pid eliminate sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1226181055-713-1-git-send-email-tomas.winkler@intel.com>
References: <1226181055-713-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0EwKMUucWapNDZhRz+sh"
Date: Sun, 09 Nov 2008 09:52:42 +0100
Message-Id: <1226220762.3614.12.camel@johannes.berg> (sfid-20081109_095304_403699_EF1DDFBD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0EwKMUucWapNDZhRz+sh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-08 at 23:50 +0200, Tomas Winkler wrote:
> This patch eliminates sparse warnings in pid rate scale algorithm
> 'debugfs: allow access to signed values' patch hit the dead end
> year ago w/o much echo so I guess there is no real need to address this
> properly.

And I guess nobody uses these debugfs knobs anyway :)
Looks like an acceptable workaround.

> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/rc80211_pid_algo.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_a=
lgo.c
> index 2328ba5..96ceb7e 100644
> --- a/net/mac80211/rc80211_pid_algo.c
> +++ b/net/mac80211/rc80211_pid_algo.c
> @@ -403,11 +403,11 @@ static void *rate_control_pid_alloc(struct ieee8021=
1_hw *hw,
>  						 S_IRUSR | S_IWUSR, debugfsdir,
>  						 &pinfo->sampling_period);
>  	de->coeff_p =3D debugfs_create_u32("coeff_p", S_IRUSR | S_IWUSR,
> -					 debugfsdir, &pinfo->coeff_p);
> +					 debugfsdir, (u32 *)&pinfo->coeff_p);
>  	de->coeff_i =3D debugfs_create_u32("coeff_i", S_IRUSR | S_IWUSR,
> -					 debugfsdir, &pinfo->coeff_i);
> +					 debugfsdir, (u32 *)&pinfo->coeff_i);
>  	de->coeff_d =3D debugfs_create_u32("coeff_d", S_IRUSR | S_IWUSR,
> -					 debugfsdir, &pinfo->coeff_d);
> +					 debugfsdir, (u32 *)&pinfo->coeff_d);
>  	de->smoothing_shift =3D debugfs_create_u32("smoothing_shift",
>  						 S_IRUSR | S_IWUSR, debugfsdir,
>  						 &pinfo->smoothing_shift);

--=-0EwKMUucWapNDZhRz+sh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFqTWAAoJEKVg1VMiehFYnmkQAI94Aly/8q+SFOUk1wJq+2xC
vZ76Eo3eTgzHh0sGqD4gBgLSz2nACQrwhzwrlQqxlfVLtHcBYvdmxwGb1z6UUvAj
KDIDxfUck3fggcCVpRcKzZ8sI6pXYCIAYQnhkTPIyjb4XC7Td5s372QJ6RkrEmNa
cHSuHnPNEplxnt0YbJJLep2Ua/r+fFxhZH61lywKVphZU1iPMdbg5HtUSgLsVJk7
uqVMApkqK/yQ9/B8OI84LWgPNhAfy+zt00yxHc16n/PwyM6H9JUpbLkIw0ED6elU
DdwNCxmAwGzsDFXaWxEJ13G14h7sKGS3s9dyUht1F47qINtXDbVE9yCf2khfT3q8
AAfxey8KK+N0duqPzSGatjshjxmwNR9mz/npoTCDU+F8zE36BHg2kYebv1MH1j/9
WXTSvZ7O3zUsVD8V6IlAEjMJV59Dt8h9hidz924sFxgMGwm51dvZBIWKdL4ST7xW
vJ6dU7Asria8s8gJJKrm6zMaDs+9OTJPQjJ+DB6CF/8EJgSQaFgL8G6jX40CQlUy
GUkrigLvcyyZvoEo4ttxKYbIEuEaq6JleQpA8bM3hSYkD1/G1hq4XeF5XFuknYhX
+9IrbU3EuZhWgwSaJZPPypdO75TtDYfabb4h66jKkxkd18nj3tsPfwHwMKOwMNEw
vOe0eUHTqWhYptnoXKby
=H1Xy
-----END PGP SIGNATURE-----

--=-0EwKMUucWapNDZhRz+sh--

