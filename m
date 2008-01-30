Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43481 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbYA3Mlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 07:41:32 -0500
Subject: Re: [PATCH 1/1] mac80211: adjustable number of bits for qdisc pool
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <12016907253540-git-send-email-ron.rindjunsky@intel.com>
References: <12016907253540-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WuDbRQcOiJ9fcM5dihZv"
Date: Wed, 30 Jan 2008 13:29:06 +0100
Message-Id: <1201696146.4014.7.camel@johannes.berg> (sfid-20080130_124145_471160_1A8DD450)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WuDbRQcOiJ9fcM5dihZv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-01-30 at 12:58 +0200, Ron Rindjunsky wrote:
> This fix allows to control the number of bits that qdiscs book keeping ca=
n be done
> for with respect to the qdisc pool

Yeah this is what I was thinking.

> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/wme.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
> index 7bbc793..f12e044 100644
> --- a/net/mac80211/wme.c
> +++ b/net/mac80211/wme.c
> @@ -25,7 +25,7 @@ const int ieee802_1d_to_ac[8] =3D { 2, 3, 3, 2, 1, 1, 0=
, 0 };
> =20
>  struct ieee80211_sched_data
>  {
> -	unsigned long qdisc_pool;
> +	unsigned long qdisc_pool[BITS_TO_LONGS(TC_80211_MAX_QUEUES)];
>  	struct tcf_proto *filter_list;
>  	struct Qdisc *queues[TC_80211_MAX_QUEUES];
>  	struct sk_buff_head requeued[TC_80211_MAX_QUEUES];

--=-WuDbRQcOiJ9fcM5dihZv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6BtkaVg1VMiehFYAQKg3xAAsWvY4PF+vk6sWpcB/8w4XWf2wMAJ5FNS
+2o+nekGPWILf8s5Cdvmhvmm2ivpbExzsUN/Z/rg/sJet1gl4zUQdOIzuqonCH4Q
uL8wKWarFnhX/dG9q1aPPRddNbSslWbzfIP/FAB8TkjXv3PCjtdzWeOMK42kMz1k
NvmMaTnKkDUytGz3KjsG0quV914Tsz3ijWdP5hTHq5Z9nr9iFwVgO3qC1FS919TM
KQluBmp+ecGuWO2EKFHFcUCY6sQaTUgPFxuY2gU1LfGsEAT0ns2cUi8PLB1t+jad
W7LnvFPsPz6bX+H1fkaGxmsSTXFeK3ynJUR6wFuBDjxahAxAuPGXHY7gZVxE2rr3
KpJjjaZ4GimdaTgL6m4eKBxU9DGBthluNpp9o3V2YCWBqPBf64BXP0MOCx1WaiRN
Qy3KxxD+2A91ek659G1pjp4C7G4eAYgj17NZFtYdz0pScoGekJjtc8yEFYPwAEk4
JBp+N9J1vwbUQBdH9HH6y1JzJJXcY043+H+FuvFn1zHyKehlknUk5DSps0mvp493
JJnVqrGP0BoC87mh77fsH9xzNvsWbASLktAh/dHUU5TsOkZ9qCAaKx8Z7EEyggec
0mCgP2hakIDWK4by8IJ7t6/vKExELhcXJFUGz86y/A3UWrux9rL08dviJyoPvQiP
sqIOFLX6LbU=
=rMjU
-----END PGP SIGNATURE-----

--=-WuDbRQcOiJ9fcM5dihZv--

