Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44947 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbZAPJ1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:27:43 -0500
Subject: Re: [PATCH 11/13] cfg80211: move check for ignore_reg_update() on
	wiphy_update_regulatory()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1232064746-17134-12-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-9-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-10-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-11-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-12-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XftvceJ7o1ZOtp7Xo7T7"
Date: Fri, 16 Jan 2009 10:27:11 +0100
Message-Id: <1232098031.3854.33.camel@johannes> (sfid-20090116_102749_013318_ECB30FE7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XftvceJ7o1ZOtp7Xo7T7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> This ensures that the initial REGDOM_SET_BY_CORE upon wiphy registration
> respects the wiphy->custom_regulatory setting. Without this and if OLD_RE=
G
> is disabled (which will be default soon as we remove it) the
> wiphy->custom_regulatory is simply ignored.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 6c45832..271b54a 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1017,13 +1017,15 @@ static void update_all_wiphy_regulatory(enum reg_=
set_by setby)
>  	struct cfg80211_registered_device *drv;
> =20
>  	list_for_each_entry(drv, &cfg80211_drv_list, list)
> -		if (!ignore_reg_update(&drv->wiphy, setby))
> -			wiphy_update_regulatory(&drv->wiphy, setby);
> +		wiphy_update_regulatory(&drv->wiphy, setby);
>  }
> =20
>  void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
>  {
>  	enum ieee80211_band band;
> +
> +	if (ignore_reg_update(wiphy, setby))
> +		return;
>  	for (band =3D 0; band < IEEE80211_NUM_BANDS; band++) {
>  		if (wiphy->bands[band])
>  			handle_band(wiphy, band);

--=-XftvceJ7o1ZOtp7Xo7T7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcFLsAAoJEKVg1VMiehFYDmIP/Aw2BVUU43NyKNB7Ip8EwuKH
jsWvv4JzO9z/QH9pJTFan+0qZqKioScD3pwXy6kGuJL19uRLbBGMABiv0+NuapxL
juxWLOKMKrEWTnHfeNbyIwve/UAXb9uzhVXe3rEZpXSUX6ZSb/ifOqM056s1Ulpx
7v9b+Phn0lv4GP3JRWHQmtrmOJRkF0TJwasMXOIAQB+e6utI0Z+1YRULFwE/toVg
XMyAHEuPbkt991FECXGSYAWUg6wSpvOav7za+u0rwj3YOmaln5DPuV6858iBMIvh
wp7Y3ZjitU68XQX415ZhYCJx8Yd8pBp2yjM/f6HsiUyUjZM9h9EWHI7+XeQ6Z37V
vjD0Fqnlt/KEYXsVOj7HhPNLhOW/te+4MDCaZ3GyFaFSAQOkWt+5IdIjfnSFb0yX
zNd+qFfLxU6smNC6w8xUqXIER/6kFmZBT3FJgKZhU6Xrjmfg27XhxcrmHyYvNQYO
SJ8OnsYbdkyUwJjxfaXQxC6eD6SlVmIdCoC8cZ6Yf8Da5yesHC2373pN49NEsFgz
Bk3rlslIx2Kd5R+Uf+DkgwUe4MYMEjeq4tVqpE32XjsJJ4yvJsWWzrlifvIBjxZH
hR/78IznSUtcgpiBh11FWwEhkjs4KmIaLzcbnIdLi5WvwXQgvHLAMezT/rE4cVjV
yhZI/ZNHXN+o1FdDZ3L1
=LNYn
-----END PGP SIGNATURE-----

--=-XftvceJ7o1ZOtp7Xo7T7--

