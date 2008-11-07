Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYKGVFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 16:05:04 -0500
Subject: Re: [PATCH v2 1/3] cfg80211: call_crda() won't tell us if CRDA was
	present
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1226004327-10290-2-git-send-email-lrodriguez@atheros.com>
References: <1226004327-10290-1-git-send-email-lrodriguez@atheros.com>
	 <1226004327-10290-2-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qq3RqlKDG0LwsZyrHIpU"
Date: Fri, 07 Nov 2008 22:05:03 +0100
Message-Id: <1226091903.11203.10.camel@johannes.berg> (sfid-20081107_220512_059439_B0F7E2CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qq3RqlKDG0LwsZyrHIpU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-06 at 12:45 -0800, Luis R. Rodriguez wrote:
> kobject_uevent_env() can return an error but it just tells us
> if the uvent was built/sent or not, it doesn't tell us anything
> about what happened in userspace, whether the udev rule was present
> nor does it tell us if CRDA was present or not. So remove
> the informative complaint about it assuming it will tell us
> such things.
>=20
> Note that you can determine if CRDA is present after loading cfg80211
> by using:
>=20
> is_old_static_regdom(cfg80211_regdomain)
>=20
> but this doesn't account for possible user install after initial
> boot, and also for when the user uses the static EU regulatory
> domain.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Less code! :))

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |    9 +--------
>  1 files changed, 1 insertions(+), 8 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index f062b8b..f8e7beb 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -711,14 +711,7 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_=
set_by set_by,
> =20
>  	kfree(last_request);
>  	last_request =3D request;
> -	r =3D call_crda(alpha2);
> -
> -#ifndef CONFIG_WIRELESS_OLD_REGULATORY
> -	if (r)
> -		printk(KERN_ERR "cfg80211: Failed calling CRDA\n");
> -#endif
> -
> -	return r;
> +	return call_crda(alpha2);
>  }
> =20
>  void regulatory_hint(struct wiphy *wiphy, const char *alpha2)

--=-qq3RqlKDG0LwsZyrHIpU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFK18AAoJEKVg1VMiehFYvZgP/11/B3zKp7f0DhDP7ATrZkvO
sDOv6DmAyffQyWCspcLz3tMUyePSsSkJyq+nJFNihsGPqPHXXKC2+HkLUE4KwhIF
47ipIpThVZHH2/WAQKvCkklNp1KsTfb/YpO0r3VgQ8Wd6jL8LF1rIUofvvujA4dc
CDRZqrbYbOC08puWBpgoF33GQ4dnbiNBzXWzmeZV1cwzpPYbEYGorwwZV3ceayJt
Kr4YBLvCii086cllU1rlRID/cd1G4CW8E2kZburlxnvT4gpTWvVT2e/Sz4e5j9qC
88z9DKW47LXEoHIZLfYQ3B5kqRT7mn/fAbkF1vw1fCtrYhCAJr3eHJsh7VZgZQmM
Baai6LCvFPyRX54v1Z7ZDlDJvvtCLROpQhh8TPR6YlYcWIUMMnx6w3xLR2xWtBIC
+wdmfxy+d4GQfP8UZWLEEFKoRAfZZ9cguABt1xtAOXkzbb8RxZG7F5422r2xJ6DN
Cs4SWQzqX6yqdxwzC8HDdC3uJduWnBLIKjIN54dP11Jby/G6lVg/MpfTh2Izp7p1
OdEhNV05CMvbw5fJAiMKd1xPq4/CF35FNH35CITGAMo6KjrJLrr+ph2Xc2fCuDL0
29wJT9T1IVWHQaXIbQ7QhpfxbA0KH2oOi6XwxxKTIrpT/P+EwQWKAxlCvtRAp/7B
zuL12OaTKuHpQvZmTBHt
=q0Yt
-----END PGP SIGNATURE-----

--=-qq3RqlKDG0LwsZyrHIpU--

