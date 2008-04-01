Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbYDAMBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 08:01:31 -0400
Subject: Re: [PATCH] mac80211: fix spinlock recursion on sta expiration
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47f1899c.02578c0a.0489.586f@mx.google.com> (sfid-20080401_020224_391860_0D7DFAD8)
References: <47f1899c.02578c0a.0489.586f@mx.google.com>
	 (sfid-20080401_020224_391860_0D7DFAD8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4xMxrvyWzA4B99jGlYGN"
Date: Tue, 01 Apr 2008 14:01:26 +0200
Message-Id: <1207051286.5143.54.camel@johannes.berg> (sfid-20080401_130134_742086_DFCC642A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4xMxrvyWzA4B99jGlYGN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-03-31 at 15:21 -0700, Luis Carlos Cobo wrote:
> Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>

Woah. Good catch. I hope it doesn't conflict with the other fixes I just
posted.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/ieee80211_sta.c |    2 +-
>  net/mac80211/sta_info.c      |    2 +-
>  net/mac80211/sta_info.h      |    1 +
>  3 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index f9cf2f1..cfe6fcc 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -3081,7 +3081,7 @@ static void ieee80211_sta_expire(struct net_device =
*dev, unsigned long exp_time)
>  		if (time_after(jiffies, sta->last_rx + exp_time)) {
>  			printk(KERN_DEBUG "%s: expiring inactive STA %s\n",
>  			       dev->name, print_mac(mac, sta->addr));
> -			sta_info_unlink(&sta);
> +			__sta_info_unlink(&sta);
>  			if (sta)
>  				list_add(&sta->list, &tmp_list);
>  		}
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index f708367..ba02b43 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -409,7 +409,7 @@ static struct sta_info *__sta_info_unpin(struct sta_i=
nfo *sta)
>  	return ret;
>  }
> =20
> -static void __sta_info_unlink(struct sta_info **sta)
> +void __sta_info_unlink(struct sta_info **sta)
>  {
>  	struct ieee80211_local *local =3D (*sta)->local;
>  	struct ieee80211_sub_if_data *sdata =3D (*sta)->sdata;
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 5e39a41..d4d6dcb 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -347,6 +347,7 @@ int sta_info_insert(struct sta_info *sta);
>   * has already unlinked it.
>   */
>  void sta_info_unlink(struct sta_info **sta);
> +void __sta_info_unlink(struct sta_info **sta);
> =20
>  void sta_info_destroy(struct sta_info *sta);
>  void sta_info_set_tim_bit(struct sta_info *sta);

--=-4xMxrvyWzA4B99jGlYGN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/IkFaVg1VMiehFYAQKsLRAAniry8vSOKVJAz77y+e64x8fyjHNoMALy
SR01SuluT7uDLF9wyPGEHwjI6tVLGqalD5Sd8zxQGceLwyBe4dzp+4Pk+4EmPKBd
Bt5Vd/5Ctib2GvUVuy5+PVNz/2jIVKfhVyXL7LVVcQ7ZDpwOKo92MtnE+2VJ51pu
dqpD7rfaFSSL+LtpBJIiSWYA+JO6GYn3ZAJ6P/mMClmNqgRE91pRFQ7KFpskpzYw
T5sdQQW6ackRe6hviKrUaKMenOczK54n9w9jHT1/I+AHffw3J57PuDN8IV61Jobo
l1mQRJT7Btc5qJGOq2DOCu/OLGd5ncJqmaeWhSqrrHBkHYAEXTljle5t48DWTmww
QxWwFOe+bTUmkafGp6onF1cQhKAHNDdNa8CCJmmcmzIbPtvRpDpiVZ7AgoR5VOvX
T19rcY2AziW0BsAR1WN2tZpWPJtNUJSKImUF4rFkPhO5BC+Uaz5DQsCgtfGCpqhe
bkp5R7jb+ltMJm8XTy1iJB9obOoTgLjd5koZBEAnA4LsLamhVRrBzWtuL3BB4SSE
WFqGbDOz4Nh5cnVcOBjxNgEzq0BnwDPf5bIcMD5l7IjzZwA2V7QMa1dX/VEjFLE2
kGlpCtc751nJQGENfuDcby3ikvSiIgklxRIL1B36IgfjPFQScR4O9Q5IPHE4dzKu
6m3/cruDbp8=
=JtT6
-----END PGP SIGNATURE-----

--=-4xMxrvyWzA4B99jGlYGN--

