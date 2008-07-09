Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44440 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYGIHpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 03:45:06 -0400
Subject: Re: [PATCH 2/3] mac80211: use ieee80211 frame control directly
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1215568845.476.67.camel@brick> (sfid-20080709_040049_850302_67F9F0D2)
References: <1215568845.476.67.camel@brick>
	 (sfid-20080709_040049_850302_67F9F0D2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hYYJi8pYtlwIErzvGQbT"
Date: Wed, 09 Jul 2008 09:44:20 +0200
Message-Id: <1215589460.3670.30.camel@johannes.berg> (sfid-20080709_094510_381131_5B15FCF8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hYYJi8pYtlwIErzvGQbT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> --- a/net/mac80211/wep.c
> +++ b/net/mac80211/wep.c
> @@ -291,9 +291,10 @@ u8 * ieee80211_wep_is_weak_iv(struct sk_buff *skb, s=
truct ieee80211_key *key)
>  ieee80211_rx_result
>  ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
>  {
> -	if ((rx->fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_DATA &&
> -	    ((rx->fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_MGMT ||
> -	     (rx->fc & IEEE80211_FCTL_STYPE) !=3D IEEE80211_STYPE_AUTH))
> +	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)rx->skb->data;
> +
> +	if (ieee80211_is_data(hdr->frame_control) &&
> +	    ieee80211_is_auth(hdr->frame_control))
>  		return RX_CONTINUE;

That one seems impossible to hit now and should be !is_data && !is_auth
I think.

johannes

--=-hYYJi8pYtlwIErzvGQbT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdGxQAAoJEKVg1VMiehFYX/AP/0K8ECGizDdh9mjsfoOs3JZ1
3YdHR3iHL2w3WtIuOdKuVOr05zP/BRb+dQ85UXHb9RXy11FVvKAtyPoN49elqoUi
cFrvDZZph8NJoq7Z0vKHGdRTncBNXWvJ2kYGRpr6E6ewrpBp768TJrXxiGA3SZis
XI56aqRTYTX19UNhr27aOJ+ykfwqOZIbbTG3t31TvfbpiR/Q32IoiWzo79Octg4N
sH75/nI9ag7Mvy8VklNbHflB7KNjdDgU/KmdsPdeE/VzKWKPawllqONTV6TVldD1
gY1S5STEiCOKvty/bLHTKv3UoSt+GOYIuDpkd2V5rTEPLAAPg6JANQtvKSZYkB1c
YrYbSay4GeiIzcQhkzcFk/Azyc3+iWO/Ckh9SNwsEHucCR+00k3WtEQf9U2LPj3f
ggMonyo39E3rDMLEZBhy/jD9y3TGGI1dfLK/j+7iwVimF0MxUOYQ+rQBgvuthSeE
OI2RU77in86oDcQd6Yi1C8M94rC0b3Y044LKkcCUbm1HKSD8y7gXVchWVz0WyCNK
N5pLNQ0lyN93G2V8clq8JYIbOAvlaJEzouGJoVCprRAuKde5TQeglvBWvC/yF05S
Lf23OOqdSgMGyfXgcZcXKuEoM25xWKY2zSXny2bRJYJLRIjqS/3Ziy+0fRgv/1MC
ejc/zUWCr9OaWuHxjvs0
=eN+T
-----END PGP SIGNATURE-----

--=-hYYJi8pYtlwIErzvGQbT--

