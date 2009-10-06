Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280AbZJFNrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 09:47:20 -0400
Subject: Re: [PATCH] mac80211: use kfree_skb() to free struct sk_buff
 pointers
From: Johannes Berg <johannes@sipsolutions.net>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4ACB4BA3.9090406@gmail.com>
References: <4ACB4BA3.9090406@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-b29mnAxBK9qmTMjVuxyk"
Date: Tue, 06 Oct 2009 15:46:09 +0200
Message-Id: <1254836769.22426.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-b29mnAxBK9qmTMjVuxyk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-06 at 15:52 +0200, Roel Kluin wrote:
> kfree_skb() should be used to free struct sk_buff pointers.
>=20
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Indeed, thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index dd65643..aeb65b3 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -339,7 +339,7 @@ void ieee80211_add_pending_skb(struct ieee80211_local=
 *local,
>  	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> =20
>  	if (WARN_ON(!info->control.vif)) {
> -		kfree(skb);
> +		kfree_skb(skb);
>  		return;
>  	}
> =20
> @@ -367,7 +367,7 @@ int ieee80211_add_pending_skbs(struct ieee80211_local=
 *local,
>  		struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> =20
>  		if (WARN_ON(!info->control.vif)) {
> -			kfree(skb);
> +			kfree_skb(skb);
>  			continue;
>  		}
> =20
>=20


--=-b29mnAxBK9qmTMjVuxyk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKy0ocAAoJEODzc/N7+QmaKrUQAIXi0SGF4ilDDgklTo9Je+UY
2mUnVA5mab8U4JhqjPjsRnWoRXKGMPJGrsEBGVI78dJqR385PDBA6/+M8z7IX8Hh
KTufGvYnUn2rFJv+KQkqr+cbXXio36pv/P1Qv7Ln6+Bp9c9ZrjTkJBi7xJBGbP3c
nHhfYaL0cv35pxFcPHX7ggVDRSUIOtWB7H5cygYhNDfgwa+8/uTU9ELbliPjo4E8
3BZeXW0OAYsQGOH0HkhYNVvBrpAFdMhv44KPMTEj49oeQVQ5J1REaqBvWsQZL/RK
gqAD5OnEKMzDlm930l/BjrH/TqHHjvqOQDMSqbX6XY/aPMoAebqiezIKPxUDh+Sl
nBF/yApiHc5zPbDdLjbrlgzI1bQAuTXZHVY0o6/WuLBvF5sGCFqcHU9vMeHPzeUQ
I7XnRj+eoqUpVpRf4j49HuMfSoUYODPBnbju0fej2XhgPOY7s55KRNUYy3SBZ5gC
jhD170eXt2CofuqmIhk4LjWZw89Ds0Wqs76skEkcHjFOwTT3pg+HsgEb15pbYudL
+eDP/fDeRoOtoY4cMbc7I+R1N+c8OGUW5JVv/qfrwWSZYuTI8KfnCTkOByVTMCUF
FFfeHyCwI530we737t0LA3hFsfR2akzqLOOrS2iGXpzxsD9bm6grwcZ4Cnfueolr
Vv2cFUJoIL2zER1Bxf5f
=AoDq
-----END PGP SIGNATURE-----

--=-b29mnAxBK9qmTMjVuxyk--

