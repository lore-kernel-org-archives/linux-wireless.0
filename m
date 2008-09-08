Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYIHOzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 10:55:49 -0400
Subject: Re: [PATCH 1/1] mac80211: scan on IBSS mode like on STA mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1220880686-5620-1-git-send-email-tomas.winkler@intel.com>
References: <1220880686-5620-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jwsPDghcZ07IEehSRBIV"
Date: Mon, 08 Sep 2008 16:55:42 +0200
Message-Id: <1220885742.31304.67.camel@johannes.berg> (sfid-20080908_165552_656021_8FF20D03)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jwsPDghcZ07IEehSRBIV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 16:31 +0300, Tomas Winkler wrote:
> From: Ester Kummer <ester.kummer@intel.com>
>=20
> This patch handle scanning on IBSS mode like on STA mode.
> When queuing the scan work we don't refer to the return value of
> ieee80211_sta_start_scan so if we are in the last scan period, we will
> return 0 to ieee80211_ioctl_siwscan and not -EAGAIN, and then iwlist will
> call ieee80211_ioctl_giwscan to get the scan results and will not fail.


Can you explain why? Or can anybody else explain why we do this
difference at all? And how should mesh behave?

> Signed-off-by: Ester Kummer <ester.kummer@intel.com>
> Acked-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  net/mac80211/mlme.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 2564553..72d5fe2 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -4090,7 +4090,8 @@ int ieee80211_sta_req_scan(struct ieee80211_sub_if_=
data *sdata, u8 *ssid, size_t
>  	struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
>  	struct ieee80211_local *local =3D sdata->local;
> =20
> -	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_STA)
> +	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_STA ||
> +	    sdata->vif.type !=3D IEEE80211_IF_TYPE_IBSS)
>  		return ieee80211_sta_start_scan(sdata, ssid, ssid_len);

This is wrong.

a !=3D 1 || a !=3D 2

has to be true at all times, I think you mean &&.

johannes

--=-jwsPDghcZ07IEehSRBIV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxTzmAAoJEKVg1VMiehFYTY8P/1zbMQm7yMghRQ6Eq0dxxm0T
SJBXcEJ7iz4qrPQyWpx0VKzTkoRHGCHV6/48guxPBqJtKac+RpZq0UVu22xFZIhk
X/M5ys0WbldzyRwx4eqg02ywGOMTPNhSblY5vZpnnyYotqSJPKHCddhPrkzbctAU
7OxbEbi4xabiPaGmNV8Mb9eUG/m/whqgvlpjoNehsbznQ5NHHWBnZZ9WDucTLKI6
uf1yjgNZNmt16l8Sg9TZfYAh/8gtvAwcJvMrbPpuSt+HqjoUk8FBA7uDul9raJmW
WSL+G4FlIFCpW0STNm6a1ATpPfUPWsf9VWkhDLI4JVBGb0PtGrPgPeUNrw6dryGn
UZONaITJ/O2tkru380r4NCcxkr4UmbtQvgWW9BfLF9tusMVRW+H8MbJzdVS6raSl
HEV9Ia2TDuY5RK4tR7mAwH50tyO53IrBn1amfqKiv7ftMbKRPZbdbJccjdrxhs41
xKuCqGaLwac1iVD+0Y4TygQ1Nas8E6JRwy2tiMy9NU94gapF/irh4xCe3hUUEqgP
RIcLUXPs0uYszcC7sygRhHGJa+fmQuiWxSr8IZFzdrhDByagRkpKZfAmQ05XjnUL
itEEkvgg/26ZFisbrTTZvhlGqsfEeXg3/rlnoD6WkIN/9ZymxTYQttE38iN9GUHg
morkXdTVoutx2k+Jg7n+
=gOwL
-----END PGP SIGNATURE-----

--=-jwsPDghcZ07IEehSRBIV--

