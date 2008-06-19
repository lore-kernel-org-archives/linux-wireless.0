Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35504 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYFSTFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 15:05:20 -0400
Subject: Re: [RFC PATCH 2/2] mac80211: workaround for resetting the tx power
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>
In-Reply-To: <1213900512-21565-2-git-send-email-tomas.winkler@intel.com>
References: <1213900512-21565-1-git-send-email-tomas.winkler@intel.com>
	 <1213900512-21565-2-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EMz+iMkiWslSbFXi3hzc"
Date: Thu, 19 Jun 2008 21:04:08 +0200
Message-Id: <1213902248.8967.79.camel@johannes.berg> (sfid-20080619_210523_528858_8DA49DDE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EMz+iMkiWslSbFXi3hzc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-19 at 21:35 +0300, Tomas Winkler wrote:
> From: Assaf Krauss <assaf.krauss@intel.com>
>=20
> This patch is a workaround for the unreliable disassociation
> flow. The resetting of the tx power is now performed upon
> association/reassociation.
>=20
> Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  net/mac80211/mlme.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 313b02a..378ccd5 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2148,6 +2148,19 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ie=
ee80211_sub_if_data *sdata,
>  	/* AssocResp and ReassocResp have identical structure, so process both
>  	 * of them in this function. */
> =20
> +	/***********************************************************
> +	 * Workaround - Until disassociation flow is trustworthy...
> +	 ***********************************************************/
> +	/* Reset power level. Get the tx power from the current channel/user.*/
> +	if (ifsta->country_max_pwr || local->hw.conf.tpc_pwr_limit) {
> +		ifsta->country_max_pwr =3D 0;
> +		local->hw.conf.tpc_pwr_limit =3D 0;
> +		ieee80211_hw_config(local);
> +	}
> +	/***********************************************************
> +	 * End of Workaround
> +	 ***********************************************************/

Umm, can you explain/fix the problem instead of adding ugly comments
like that?

johannes

--=-EMz+iMkiWslSbFXi3hzc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWq2lAAoJEKVg1VMiehFYF/0P/A+8Gb1z5rAZZPxC/XZk0m1d
QNKnWbX/iAJcFaF6IgEafY5YiRLxrajIe1S9sx8jEXGUOKHXcengfitPQWiD51Ri
hI5xnkvsJr/usGacgk2wm2oTpSEPHvriiRBKGYUtGBaKJVytbK2oZ0Kai8LWFwwE
E2lezPp7QTmabUS1WxnrMljzy4rh4SW952peoNt23tMDClgE8RDZlW++1yZV8InG
6yO0FqsXaXC0FLDAXZHwAA5iqWsCqN6havnhgQqe+UCDf1G/MlfyEyPQjdMOa0XP
56oOCv+pHUWEbiuCwDnzWaR41RqT9eZzRxP6vc6XC54WAg5pcyt88TlJJNJi2LGD
UJDuODgiLAuYVZ0vi7cMqJCJgz3XCz1D23I5cqVj5ESYBteRUIY0PShXZsk/xx1o
xJTXWgw7hpUxUO7ViAU4vr/fp7lEXWJN0YCZtAaERTWNYcE//ZWIEJAO80hWmAhY
rT1UPVH7qXJ3isSILy+egX+8zB1Dg/3Gp8CNsmVrcyzzSoMzYyPiuQ97IAGBDGLa
gtE51LMXzU0QHqlb35UyKfKIzpfSMT8jsx4NBci33Ho3NGJsGntUlnCxVZXABo/D
KgXkNGj8DDbeC716X9kA5HNsvo+ouWGeC39gwEzNA0DVumLTC1CSnC/4iAZf8oYK
gEgKZF0R6FpC7ydtyjVA
=bu+5
-----END PGP SIGNATURE-----

--=-EMz+iMkiWslSbFXi3hzc--

