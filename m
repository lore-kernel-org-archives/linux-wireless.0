Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbZBOLEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 06:04:23 -0500
Subject: Re: [PATCH 08/10] cfg80211: make regulatory_request use wiphy_idx
	instead of wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1234589627-16977-9-git-send-email-lrodriguez@atheros.com>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-9-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Hs8JQAaO4NQbq0UC8vaV"
Date: Sun, 15 Feb 2009 12:04:18 +0100
Message-Id: <1234695858.4219.54.camel@johannes.local> (sfid-20090215_120425_678747_C8E76CE0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hs8JQAaO4NQbq0UC8vaV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-13 at 21:33 -0800, Luis R. Rodriguez wrote:

> +static inline
> +int wiphy_idx(struct wiphy *wiphy)
> +{
> +	struct cfg80211_registered_device *drv;
> +	if (!wiphy)
> +		return WIPHY_IDX_STALE;
> +	drv =3D wiphy_to_dev(wiphy);
> +	return drv->wiphy_idx;
> +}

I neither like the name of this function (same as the variable name) nor
the function -- you're using it in exactly one place where you cannot
ever pass NULL afaict.

johannes

--=-Hs8JQAaO4NQbq0UC8vaV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJl/avAAoJEKVg1VMiehFYdsEQAIFRXyDvbat0r12mQyF7SfHM
81CRWdZtXXUgwGm77i6Enhc+jQ/Ob/nSfPlVCcK2qsIg89uD0wNN18LoCS1DYiUP
UFxBUpwfyPRaBcf+mqVK4jgSxhLg5PNuox63tKe/LuMMoKxGIiNyU+TwCqmof0TU
k9P1q5YuQacryhJJZqpM4ell5OSiHI6pHI+6CJe5eGzNGFD2ggbSyWAiHiCjV3qf
2NNBxrxARP924VTYzl5ii0J8EIhZTaS/K0RqGoxG0mAxonyR6XwAxYEnW997lroA
1N6YAeqmDjHRsOCRq+TFe08IeOXzbEMMwaOXzAhDhHfnbGZBfoXtX1gL0TpXC7ll
3oDi95h2DBkTZAT/tsqRH3fbln++35I4h6CZhPD0o+3Fp52guFvadGO8ezOOQejq
XbG4TBPfq5NpRDH4fFr1kflGUfyT9ExrzUc9kl9cnhqC6u9h8R3Nprrn6xxDQdvh
y2mCldsYVrm3V8HHLvxDrRv6A/XB5hBE4whqDTC1etL9r/hz4C+hCvDI5pQ2g8Jd
rRpIQmc7qTWd3WGabCmTr+V5A6d73V16nkZYWXRFDC37VmNHC9Sb6o8Q96WBW8wq
uaado7OqhFEIbQGftvfKk02Umg0dnFG2xlCmSGXK5aUcuWx4C1cAZz5ShG88wGnu
ZRCuktBAg9evTsTghigh
=Ap5V
-----END PGP SIGNATURE-----

--=-Hs8JQAaO4NQbq0UC8vaV--

