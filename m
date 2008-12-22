Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35331 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYLVGtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 01:49:50 -0500
Subject: Re: [PATCH] [RFC v2] mac80211: Scale down to non-HT association
	with TKIP/WEP as pairwise cipher
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linux-wireless@vger.kernel.org, jouni.Malinen@atheros.com,
	linville@tuxdriver.com
In-Reply-To: <1229927497-30923-1-git-send-email-vasanth@atheros.com>
References: <1229927497-30923-1-git-send-email-vasanth@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-amvThwbVpjNXgDWLRSUD"
Date: Mon, 22 Dec 2008 07:49:45 +0100
Message-Id: <1229928585.3087.1.camel@johannes> (sfid-20081222_074956_319506_3A00750E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-amvThwbVpjNXgDWLRSUD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-22 at 12:01 +0530, Vasanthakumar Thiagarajan wrote:
> As TKIP is not updated to new security needs which arise when
> TKIP is used to encrypt A-MPDU aggregated data frames, IEEE802.11n
> does not allow any cipher other than CCMP (Which has new extensions
> defined) as pairwise cipher between HT peers.
>=20
> When such configuration (TKIP/WEP in HT) is forced, we still
> associate in non-HT mode (11a/b/g).

> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -873,12 +873,22 @@ static int ieee80211_ioctl_siwauth(struct net_devic=
e *dev,
> =20
>  	switch (data->flags & IW_AUTH_INDEX) {
>  	case IW_AUTH_WPA_VERSION:
> -	case IW_AUTH_CIPHER_PAIRWISE:
>  	case IW_AUTH_CIPHER_GROUP:
>  	case IW_AUTH_WPA_ENABLED:
>  	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
>  	case IW_AUTH_KEY_MGMT:
>  		break;
> +	case IW_AUTH_CIPHER_PAIRWISE:
> +		if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
> +			if (data->value & (IW_AUTH_CIPHER_WEP40 |
> +			    IW_AUTH_CIPHER_WEP104 | IW_AUTH_CIPHER_TKIP))
> +				sdata->u.sta.flags |=3D
> +					IEEE80211_STA_TKIP_WEP_USED;
> +			else
> +				sdata->u.sta.flags &=3D
> +					~IEEE80211_STA_TKIP_WEP_USED;
> +		}
> +		break;

I still think you might need to put something into cfg.c. Can't we check
the key algorithm for the pairwise key associated with the AP's sta_info
directly in _send_assoc?

johannes

--=-amvThwbVpjNXgDWLRSUD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJTziEAAoJEKVg1VMiehFYoBYP/2L8hm8r5Uqyl7y4/vyW2PWo
jY6AFFcdTHw7DMwcQjuuxFNZh3pPrwT2tgviOqzoVJJujb0DLMSahhyoI+SPsvUO
8iUAwVhMK/otVAbDWxHOpBpvYTc+FfkjNAM0KSZbVXcPKkNtrAt5tgbOxcn9GPMO
txNk+iyBJ2o1bRqf10+mkxTCZltIL4Q4io6xuYQU3CjeT7wKjiivblZV+/NgwMpY
b7g8NqYlaQ7h1ncPbPZ63FcbDN1BU2VA/OkS2PcNIcjq+vuPOd9Cs44OjwbOesKD
7DWiZnwCAhvfkdglIxS4gXa7XdljjdQrkjir5qmEyRrQF15eQhhNfsBQ1XsxaUNc
DEyU+FZ/7Iq8wiTefvTPc7UkXyJaFxg9pfYbnkTP3nrYFA9nbBiyg/jEFdgVOs8V
JnIIWs7ycWhSR3kWbj3K4obo05yVVjLZpxw9Bqh7fSKONDYNkxagA/L43Md9eUqP
Ff2maukK22X7eHWHFqZmuvUjx/+ZDRbV204eT7Mfn4aTsrjZM1yTlPnpUkyfKBxr
woOCL38B78MxtuW3L+QRuCqBgr8fihtUe4B1pE3OTRwPZBkgNH/nbaD8oldSu3z9
M1ZyzjGwi7Ehi5VByaktpWYhz3/DkdtPm65OyHbEL3h5EmLbIg+VvF/C9+xtpXZL
Lm5Z0kwFUnhgggfs3e7G
=24ef
-----END PGP SIGNATURE-----

--=-amvThwbVpjNXgDWLRSUD--

