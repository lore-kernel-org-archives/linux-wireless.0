Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42616 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbYJXJwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 05:52:45 -0400
Subject: Re: [PATCH] mac80211: allow all interfaces types to handle RX
	action frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4900da4d.0d87460a.2d4b.1120@mx.google.com> (sfid-20081023_221058_192076_2D6A771F)
References: <4900da4d.0d87460a.2d4b.1120@mx.google.com>
	 (sfid-20081023_221058_192076_2D6A771F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IQ6UG+WFRfEoe8Vgs0Pr"
Date: Fri, 24 Oct 2008 10:42:09 +0200
Message-Id: <1224837729.6002.88.camel@johannes.berg> (sfid-20081024_115249_683872_193119D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IQ6UG+WFRfEoe8Vgs0Pr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 13:10 -0700, Andrey Yurovsky wrote:
> Eliminate the vif.type check in ieee80211_rx_h_action.  This check is
> unnecessary (these action frames can be handled by all interface types) a=
nd=20
> currently prevents, for example, AP interfaces from handling BACK action =
frames
> such as ADDBA and DELBA requests.
>=20
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Fine with me.
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index a0db162..59bcbb6 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1552,14 +1552,6 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx=
)
>  	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
>  		return RX_DROP_MONITOR;
> =20
> -	/*
> -	 * FIXME: revisit this, I'm sure we should handle most
> -	 *	  of these frames in other modes as well!
> -	 */
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION &&
> -	    sdata->vif.type !=3D NL80211_IFTYPE_ADHOC)
> -		return RX_CONTINUE;
> -
>  	switch (mgmt->u.action.category) {
>  	case WLAN_CATEGORY_BACK:
>  		switch (mgmt->u.action.u.addba_req.action_code) {
>=20
>=20
>=20

--=-IQ6UG+WFRfEoe8Vgs0Pr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAYpdAAoJEKVg1VMiehFYk5oP/3IksrBFggKR7Rspq0jSIvqo
zV8bKfonU4SG2dD7RVoV5/OYbpXoWJIy4j2A6MB3XA3+DxQkcuTEQ6rfZUu3yMLH
+Xpul4DMGmHfJOYumyX3jQOeHx1XiSZ7XNYVamwOK0eTxJMuJHrZNGiOswap+/1x
dHP6lQhRJc1+rLO2NdCAttl4mfkHiJEou5Jtux1A/RfMhjqcClUQRrkG0Qn6xYMd
mc/itmMcSTGwbFLpDnCGjtXoqRcFXK2s8nM4rF7FxLeXo0taFlfEfNN/8C/w3JOL
iM6LKlYf7ZqmGxvleqO7Nc7nq6NObN31L3TLkGMbaePOhMpHL5RUh0+ncDcYItWu
vGWBHyxSerZHtfF25NHytPzKVEI7gjNU8IgQDM11DsZSO7BWMzlMNSwC9bCBRmvs
DpLIXf24q/RLSjRDDNz8boC2O7WN6DPwhDnAWJHHqt+1lM8IoMsl+u9XcFmln9UZ
QZ48nNPY3uYkcMs79CscMdnT+UCKKppaMI+oFaWcn4XnaXtsig3rYYF9drSYUbXt
RjL5T3mgK8eT3Lnq0P1yapRH+uYdhIXCn9b9mRJv9ZjJFJagt/XA09SZ2xO5HbE2
CVAA8JhnH46GnQglNLMCwKPkYPU9CkM+IlzdXN0pmM7xtPNsbN30I7+YZFiTkZPC
wlLRptDdwd9BfGopZhO4
=Y84P
-----END PGP SIGNATURE-----

--=-IQ6UG+WFRfEoe8Vgs0Pr--

