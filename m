Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:50550 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab2AJRwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 12:52:09 -0500
Date: Tue, 10 Jan 2012 18:52:07 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: update oper_channel on ibss join
Message-ID: <20120110175207.GC19790@pandem0nium> (sfid-20120110_185214_033528_4F1C6355)
References: <1326201594-4748-1-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gr/z0/N6AeWAPJVB"
In-Reply-To: <1326201594-4748-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--gr/z0/N6AeWAPJVB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Eliad,

this looks right, this line seems to be accidently removed - although
it also (accidently?) worked while I did my tests. :)

Anyway, thanks!

Acked-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>

On Tue, Jan 10, 2012 at 03:19:54PM +0200, Eliad Peller wrote:
> Commit 13c40c5 ("mac80211: Add HT operation modes for IBSS") broke
> ibss operation by mistakenly removing the local->oper_channel
> update (causing ibss to start on the wrong channel). fix it.
>=20
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  net/mac80211/ibss.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index f8a32bf..765072d 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -106,6 +106,7 @@ static void __ieee80211_sta_join_ibss(struct ieee8021=
1_sub_if_data *sdata,
> =20
>  	sdata->drop_unencrypted =3D capability & WLAN_CAPABILITY_PRIVACY ? 1 : =
0;
> =20
> +	local->oper_channel =3D chan;
>  	channel_type =3D ifibss->channel_type;
>  	if (channel_type > NL80211_CHAN_HT20 &&
>  	    !cfg80211_can_beacon_sec_chan(local->hw.wiphy, chan, channel_type))
> --=20
> 1.7.6.401.g6a319
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--gr/z0/N6AeWAPJVB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8MescACgkQrzg/fFk7axYbLACfcDpaFX/xwqMEfL7oCkw4uvDx
L0wAn2Fn/1GtLAxCkLWxA2ErtHzyy9ok
=R73q
-----END PGP SIGNATURE-----

--gr/z0/N6AeWAPJVB--
