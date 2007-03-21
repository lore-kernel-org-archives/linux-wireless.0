Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54224 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934083AbXCVKE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2007 06:04:58 -0400
Subject: Re: [PATCH 2/4] mac80211: Add radiotap support for Monitor mode RX
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070320104104.318699229@warmcat.com>
References: <20070320103955.600509703@warmcat.com>
	 <20070320104104.318699229@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-InCrHSJarn2Y74P+KDCm"
Date: Wed, 21 Mar 2007 19:51:31 +0100
Message-Id: <1174503091.3944.42.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-InCrHSJarn2Y74P+KDCm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	/* Driver supports radiotap. */
> +#define IEEE80211_HW_RADIOTAP_SUPPORTED (1<<10)

> +	if (local->monitors &&
> +	    local->hw.flags & IEEE80211_HW_RADIOTAP_SUPPORTED) {
> +		radiotap_len =3D ieee80211_get_radiotap_len(skb);
> +		skb_pull(skb, radiotap_len);
> +	}

I don't think that can work.=20

 1) it needs a lot more documentation on what a driver needs to do for
    this (for example that it should only add radiotap headers if a
    monitor interface was added)

 2) afaik local->monitors is increased even for soft monitor interfaces,
    thus this will really fall on its nose when the driver supports
    radiotap but not monitor during operation.

johannes

--=-InCrHSJarn2Y74P+KDCm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGAX6z/ETPhpq3jKURAgg4AJwJXi5N1bM3W/dNVmKydEeSD7KfZgCfcGCJ
ccIW2/SiLfpzv6ukVHhDVvU=
=069G
-----END PGP SIGNATURE-----

--=-InCrHSJarn2Y74P+KDCm--

