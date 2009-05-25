Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZEYVmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 17:42:53 -0400
Subject: Re: [PATCH] ath5k: avoid leaking mutex in ath5k_config
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	Alan Jenkins <sourcejedi.lkml@googlemail.com>
In-Reply-To: <1243280050-3755-1-git-send-email-linville@tuxdriver.com>
References: <1243280050-3755-1-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vn4/jVIlAm0hIOBHLEQc"
Date: Mon, 25 May 2009 23:42:43 +0200
Message-Id: <1243287763.29222.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vn4/jVIlAm0hIOBHLEQc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-25 at 21:34 +0200, John W. Linville wrote:
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> I lost track of the related bug report -- Johannes, do you recall?

Thanks for fixing -- the report is Alan's (CC'ed) at
http://article.gmane.org/gmane.linux.kernel.wireless.general/33449

johannes

>  drivers/net/wireless/ath/ath5k/base.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless=
/ath/ath5k/base.c
> index fb51937..dd6dc8d 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2779,7 +2779,7 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
> =20
>  	ret =3D ath5k_chan_set(sc, conf->channel);
>  	if (ret < 0)
> -		return ret;
> +		goto unlock;
> =20
>  	if ((changed & IEEE80211_CONF_CHANGE_POWER) &&
>  	(sc->power_level !=3D conf->power_level)) {
> @@ -2808,8 +2808,9 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
>  	 */
>  	ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_DEFAULT);
> =20
> +unlock:
>  	mutex_unlock(&sc->lock);
> -	return 0;
> +	return ret;
>  }
> =20
>  #define SUPPORTED_FIF_FLAGS \

--=-vn4/jVIlAm0hIOBHLEQc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKGxDPAAoJEODzc/N7+Qma8xkQAIcLYUUViLznRFdC0jYJRoBa
vw+r7SjrreSlmjKQUxrZ14MsIgVEHvaUbRclkjvaKsssXmvUe49wdw5bLeaybG4B
WyVOXdJYkmvKhyctfYbHqkVC6zwcYjjqaQSGxorPBTuyKy3WlHVAI9NkzL9VeJHS
NkWJGklZpe/4ZouQVi0is8P1L7YSFNzX11MJcBIisTR9wYJXY0pn5uBWV9ovo2TU
zvqlyKPs/N6El01aFccNtUeBar0b8z3TFutxDV+aBZfGjWlFNKwGaKKiE70Stt/i
PsNfY0eXJP7rzsTwbwp2H2NmVa1Xa5gWbcV2OqWNFyCdGc0DLp2DK2qNBekDf1cO
aDGy68SKZ7w9Vo6d3tI4MjeIsQQZFM1wouSDnTQyq1E5CzIsdnIkdGC1t7cXhdlE
s2SKNYIk3TCguhqyCFUC6wsOcqTLJvh3O7ivD6IfVuVw39D/oa5fi4WsWeTI5Ctj
vm/WiRP12R7VHQe301n5dBOZxgE39Jz82JevhLHm9/+vuRMGR6GpfGfL5CfscBbw
ioWlDnTWVhGKg98n8Xa7qQcWMScLXVmbPbjmezng9E0KUlSQTVmc4kxcQDq7jKwc
9TNjiu5zoql5YkDEapUzUMMsBz/9/adMROuHZJoIDJvjpnj8gWYj2jz9up0I1cjz
8ejqK0lagNidOL/Af9dQ
=w7bM
-----END PGP SIGNATURE-----

--=-vn4/jVIlAm0hIOBHLEQc--

