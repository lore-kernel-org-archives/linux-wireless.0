Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40452 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbXLRNf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:35:56 -0500
Subject: Re: [patch (for 2.6.24?) 1/4] ieee80211_rate: missed unlock
From: Johannes Berg <johannes@sipsolutions.net>
To: akpm@linux-foundation.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	gorcunov@gmail.com, flamingice@sourmilk.net
In-Reply-To: <200712180022.lBI0MpTh010069@imap1.linux-foundation.org> (sfid-20071218_002400_882717_90E820B8)
References: <200712180022.lBI0MpTh010069@imap1.linux-foundation.org>
	 (sfid-20071218_002400_882717_90E820B8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-giqpbt/DPt1SldY4GUjr"
Date: Tue, 18 Dec 2007 14:35:14 +0100
Message-Id: <1197984914.4885.139.camel@johannes.berg> (sfid-20071218_133604_341469_F6277C3C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-giqpbt/DPt1SldY4GUjr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-12-17 at 16:22 -0800, akpm@linux-foundation.org wrote:
> From: Cyrill Gorcunov <gorcunov@gmail.com>
>=20
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

My mistake, good catch.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/mac80211/ieee80211_rate.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff -puN net/mac80211/ieee80211_rate.c~ieee80211_rate-missed-unlock net/=
mac80211/ieee80211_rate.c
> --- a/net/mac80211/ieee80211_rate.c~ieee80211_rate-missed-unlock
> +++ a/net/mac80211/ieee80211_rate.c
> @@ -33,6 +33,7 @@ int ieee80211_rate_control_register(stru
>  		if (!strcmp(alg->ops->name, ops->name)) {
>  			/* don't register an algorithm twice */
>  			WARN_ON(1);
> +			mutex_unlock(&rate_ctrl_mutex);
>  			return -EALREADY;
>  		}
>  	}
> _
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-giqpbt/DPt1SldY4GUjr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2fMkaVg1VMiehFYAQJLhA/9HLnTM51d6+zfkpCyQrLlVNAqQ4PCWZf/
lFhBwHy8y+Cut4ZMF8vd/kmRQwyKyWz1fNe4JfU+igpM/5/xqD3fDem3r/8Ggpw6
rjSZjhYsoQ4TSRZ3FfHUlVB/azbSqes2sQyxzAOG3oKFNMQst+6CYWUm6/7QA4dL
OkQv8PWrQycWhZt6VxOJZBsS6+lkoqoFhkDWh3iPXFBsVo5k0b8Ho5CxzmXvQYQc
8IXVcbuR9gDOVkWiAO3hhPaqxY2conwts90/jDnCnCSJ+rxtV3Rg57cgJd2xMHhM
9Z6T0gVMZL019yn4zyuBnc8z4RMDsIfPX6f7GCZ5lVmoPhHpaAKtTm421wG9FvNs
zIh07PS3ElsxtIrG0JZUSap2Yuy+2aW0PStMzT8+2vQZ4fBKX7lwtml0Z4gXi6hj
OREznHbYlJDsqCeQn9Kme5F398OgK5S6N+UvBuGce1a2kWfl9kAi6NwEpcWImrn0
7XREs7USgHCiNLBmcg0Y1RGHOD4C4TgODQVUPzSc4oK7m1Vl2khxC9s/wtuRdE97
FA7ZUtleS56vpa+17a5g21Yn+s1rckb+X9FqhEysr7niiFgLHdCF1BqVvqVXQ7ke
aFqyjRdpcy4QJHtj4XBci09mZ9FQuBr5WFeutFOsE6fAsiJokqi5cQDZFupClu8/
UOAnFOUXulQ=
=jyNG
-----END PGP SIGNATURE-----

--=-giqpbt/DPt1SldY4GUjr--

