Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37099 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbZGOL7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 07:59:17 -0400
Subject: Re: [PATCH 01/21] mac80211: drop frames for sta with no valid rate
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
In-Reply-To: <1247616853-11221-2-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
	 <1247616853-11221-2-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-H29o7tzm8VWSNYJDaQWq"
Date: Wed, 15 Jul 2009 13:58:41 +0200
Message-Id: <1247659121.2477.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H29o7tzm8VWSNYJDaQWq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-14 at 20:13 -0400, Luis R. Rodriguez wrote:

> +	if (unlikely((tx->local->sw_scanning) &&
> +	    (sta_flags & WLAN_STA_ASSOC) &&
> +	    !rate_usable_index_exists(sband, &tx->sta->sta))) {
> +#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> +		printk(KERN_DEBUG "%s: dropped data frame -- no "
> +		       "supported rate for station %pM on %c GHz band\n",
> +		       tx->dev->name, hdr->addr1,
> +		       tx->channel->band ? '5' : '2');
> +#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
> +		WARN_ON(1);
> +		return TX_DROP;

Can you use WARN(), and put it into the if() please?

johannes

--=-H29o7tzm8VWSNYJDaQWq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXcRuAAoJEODzc/N7+QmasgsP/jPgl/8/uFgGwOATI6ItFGbZ
x8jZiUurDUIN08Fjom5AqJr/rs9kXHdRBK9bbl+JzInOez176AVsXpRAl+JcKYea
5BQOKtz9bVTw5toR+2E/IaqUPi9yvuYsuUXLQpMPZ991wTvO/h+3fNCEfPNdwuBC
HxzM6ksTGihBt5LoKN+O2aBpCvwf15D9gcfnMmBM5MEHHCjtgkN6UZRJW0FPwjpx
tdNSstUPFB3i5Err7R90Dfe7c0O8QIz31ct7duTvHPLdMTQjl4MsDz/0S7/nvvp6
qdVawKJthaFiO2x0++WZPj3Scdw1ijNgAjl3pQTrfuM90j5qUyHDZeHWcwUiD2On
U0mXgSzUPyw6Gs2Bnl5Ei4w9RwjNZgltRyMfP9izbfZhWNakFU/JoPuEguZF5nk5
pyyYL67AQ3EOJlqfrlmL3FX+x7Sz3rIb1InB0n7eE/LSatswaFnbu+WKchSU2m1K
qGiNEK2+mtgzke7YB2o7osIG+k3lAti3JbzARJGEmktIFaKpQuRmSbdYuVB+uIdF
b/0Um4+wMkeV3EAekjQnQD2jTF4XxNjvh6b6EdF4YAsc9TvxgGbxvnTw7FR5mIP6
rOfYi9S1GupoSCI9bfmmF0rywiNXlBfuem3/EAOjMOsDs4G155QuyKE8aBKFF0oo
m21WJRdv3ieio/X7NYch
=+xDU
-----END PGP SIGNATURE-----

--=-H29o7tzm8VWSNYJDaQWq--

