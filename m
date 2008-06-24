Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56785 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYFXKs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 06:48:26 -0400
Subject: Re: [PATCH 1/4] mac80211: don't return -EINVAL upon iwconfig wlan0
	rts auto
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1214303881-31525-2-git-send-email-tomas.winkler@intel.com>
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-2-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r9U7A1GnkGF/KLftmGMl"
Date: Tue, 24 Jun 2008 12:47:43 +0200
Message-Id: <1214304463.8967.279.camel@johannes.berg> (sfid-20080624_124828_741982_B07FE4F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r9U7A1GnkGF/KLftmGMl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-24 at 13:37 +0300, Tomas Winkler wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>=20
> This patch avoids returning -EINVAL upon iwconfig wlan0 rts auto. If
> rts->fixed is 0, then we should choose a default value instead of failing=
.
>=20
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/wext.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 5af3862..53f8767 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -721,6 +721,9 @@ static int ieee80211_ioctl_siwrts(struct net_device *=
dev,
> =20
>  	if (rts->disabled)
>  		local->rts_threshold =3D IEEE80211_MAX_RTS_THRESHOLD;
> +	else if (!rts->fixed)
> +		/* if the rts value is not fixed, then take default */
> +		local->rts_threshold =3D IEEE80211_MAX_RTS_THRESHOLD;
>  	else if (rts->value < 0 || rts->value > IEEE80211_MAX_RTS_THRESHOLD)
>  		return -EINVAL;
>  	else

--=-r9U7A1GnkGF/KLftmGMl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYNDLAAoJEKVg1VMiehFYHjoQAIUxmndJ6MlH8edhcZp0uIJI
AzuG0mqRdpRFNw6o3fJcLbw5wFVzvl95Z16ygumFiDp6MzVcmw+056+7NNxOelGy
jnAfLFm0gI0u1h9GUG5EDwWJTRTmJsRgg96TzKWhP8CQnCcrddP1Ri30OH6OljR4
q5R929M0JAADfiRzAMUUM7gzGGND3dadHzOvLTA9NGEsClS3pZK5Jfiorr5QeZBD
h9gR+H4pYdncxS7D5CatMYM1S1rgDyCqMxfujAuzqBDLG/LyEG3cCvWK9p6ofYVf
i/a2W0OCj2HkwCvmA9NS8RrmcMt5NonQNxi++2tVIvThQ3MwuDZx35ZNiHKEl570
deySQgvvMjiwqgCUrAkMvd2NyLrwMKoiy5Y2gJYiuv+0ANTcf31cgCg2hiR0KXyf
zI5V050eB/q4h/lOxAVmJsZ9hNpYlSTEqHxcURt8+t+QeMOhrCTepGe40w+Vy0NW
Sl/LoKB5/C3UANJeGq/+akyr2uMNURGkDpw2mak9zuChkd9WVCHHfnOJmy5E5iLo
y5wvL9LO9QVupnzRDvIfVvds0E3axa/zeyoZx702Qy/LZpo0ggWE3smqPhbHct0a
xztYaRuWfxyihCKcixvTBIHebiN1KMtrkSsy+dty86eOIPmN0s311k6MxaXWg6jj
cidh1L+oLflEExDOptNj
=XePq
-----END PGP SIGNATURE-----

--=-r9U7A1GnkGF/KLftmGMl--

