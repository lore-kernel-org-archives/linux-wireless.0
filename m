Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60348 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYFSTEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 15:04:20 -0400
Subject: Re: [RFC PATCH 1/2] mac80211: 11d Handling - Country Information
	Element
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>
In-Reply-To: <1213900512-21565-1-git-send-email-tomas.winkler@intel.com>
References: <1213900512-21565-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+cY9RrF12TjBdj0/aQpZ"
Date: Thu, 19 Jun 2008 21:03:36 +0200
Message-Id: <1213902216.8967.78.camel@johannes.berg> (sfid-20080619_210424_609575_5DC5F847)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+cY9RrF12TjBdj0/aQpZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +static void ieee80211_calculate_power_level(struct ieee80211_local *loca=
l)
> +{
> +	struct ieee80211_channel *chan =3D local->hw.conf.channel;
> +
> +	local->hw.conf.power_level =3D chan->max_power;
> +	if (local->hw.conf.user_pwr_limit)
> +		local->hw.conf.power_level =3D min(local->hw.conf.user_pwr_limit,
> +			local->hw.conf.power_level);
> +	if (local->hw.conf.tpc_pwr_limit)
> +		local->hw.conf.power_level =3D min(local->hw.conf.tpc_pwr_limit,
> +			local->hw.conf.power_level);
> +}
> +
>  int ieee80211_hw_config(struct ieee80211_local *local)
>  {
>  	struct ieee80211_channel *chan;
> @@ -1040,13 +1053,7 @@ int ieee80211_hw_config(struct ieee80211_local *lo=
cal)
> =20
>  	local->hw.conf.channel =3D chan;
> =20
> -	if (!local->hw.conf.power_level)
> -		local->hw.conf.power_level =3D chan->max_power;
> -	else
> -		local->hw.conf.power_level =3D min(chan->max_power,
> -					       local->hw.conf.power_level);
> -
> -	local->hw.conf.max_antenna_gain =3D chan->max_antenna_gain;
> +	ieee80211_calculate_power_level(local);

Lost antenna gain setting?
=20

> +	if (country_ie_len < 6) {
> +		printk(KERN_ERR "%s: country information element shorter (%d)"
> +			" than expected.\n", __func__, country_ie_len);

Remotely exploitable security bug.


> -	if (local->hw.conf.power_level !=3D new_power_level) {
> -		local->hw.conf.power_level =3D new_power_level;
> +		 local->hw.conf.user_pwr_limit =3D 0;

whitespace damage.

johannes

--=-+cY9RrF12TjBdj0/aQpZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWq2EAAoJEKVg1VMiehFYdFQP/jG5RPBOhuZA7SpBckcT5PBP
PXwt0OMC0+JXDHHjLwNaBTGrTRHjpQlJfjXr4awJmXzd/B+rxyT9pA74nHcjW9ra
BFm3DYk0jYXnlegDy8h+D3Xree0T0LF0NztZODN4QHcG9PJ1JsLdAHDdVgDS6+Uy
J0Css50miznlJ/G9XPwvjtR5k7Ql/wDrVJSyAOfhpF0x5Pwx+bycegx31IqwVBsy
5Jy4rs6rrZw+Hd3Bwd7D2Fwe/TF2RW2qxKYHIhnQ5eZjkKxaNjF8kmvhABjCuKKT
K1ZzrFgHOSA7e6TOa7FKcs32UMTUr/lC0+UXgpdhnbL5GjV5iAeASg+aae1l4DF+
tZB+jL/Q2RDn/rZANfDjpeBfLMjVk1mA3Thv9AOkGt3cOopoB9fqrpZSpSI1wNYj
1JSO7tfTkJTSdylGuMnBNOM4382DMP/xcQBiiyfdrpag9saVO0eWaYKvD854Ozzj
CVfRQuWbS+0MJJbAWvHp3b0Q/KTzqsaNWAWRw9JEFaJGB+n0NYCLVVMhYQVRYVHd
+ou/9uYC0kFPDwl4qefI9a9rdnvGIlfFmboJCYudJLhoxKbL6f0bQ7PyrO3gUrak
KFwpRNnYABoxuOvyDh1TMwVlLDJ42CAFbDlXvab3AsGyMFKWTGejy892zQ4tWrKA
KBcNnzZ0Z+yVsBs8Y3wq
=Gq5q
-----END PGP SIGNATURE-----

--=-+cY9RrF12TjBdj0/aQpZ--

