Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48806 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbZDGM6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 08:58:30 -0400
Subject: Re: [PATCH v2 3/5] mac80211: check if HT40+/- is allowed before
 sending assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1239048958-11775-4-git-send-email-lrodriguez@atheros.com>
References: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com>
	 <1239048958-11775-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zfBBVk6tuAPghgdihpCj"
Date: Tue, 07 Apr 2009 12:11:11 +0200
Message-Id: <1239099071.22453.12.camel@johannes.local> (sfid-20090407_145834_901947_5BBE5624)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zfBBVk6tuAPghgdihpCj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-04-06 at 16:15 -0400, Luis R. Rodriguez wrote:
> We weren't checking this at all.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/mac80211/ht.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
> index 4e3c72f..967367c 100644
> --- a/net/mac80211/ht.c
> +++ b/net/mac80211/ht.c
> @@ -122,10 +122,14 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_dat=
a *sdata,
>  		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
>  			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
>  			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
> -				channel_type =3D NL80211_CHAN_HT40PLUS;
> +				if (!(local->hw.conf.channel->flags &
> +				    IEEE80211_CHAN_NO_HT40PLUS))
> +					channel_type =3D NL80211_CHAN_HT40PLUS;

This patch is not sufficient -- you also need to modify
ieee80211_send_assoc. Otherwise we end up telling the AP that we support
HT40, but tuning the hardware to HT20.

johannes

--=-zfBBVk6tuAPghgdihpCj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ2ya8AAoJEKVg1VMiehFYFDcQAIKDWh3ghamD43lAxJJSH6CU
QEeX3mFAH2GQoXEpmgAamsmQa6U036MfiYxHo+m3Z+qcExlnlxPlSHlbBaQzrVuX
ItHRrtgaWeB2lwJ3QSgWg2LbY9q2g8Hx1rAxDwgJE8NG/UuGoWb/Zp5CCOwC0GbO
e0GZO58/Gty43XUA5t5G8Xgm67AQKbZK0lmXtkT2yb18Jdya519l8S+Nff8FVp6K
alblU/GWNy2zL50WnqcLWEp5dz4Nxgme4cXWTUz1GJyFfXD4rpiMAjxw6PcUhUEm
VGkJItGi/brtg6lwPHzjqLeWWs09v2D9CMWHJEP/dBuJ4YfbqMj2YDO471LYU3gl
yBliMAUkvQ0P9LredJ8fwA4oDQNCxBBHF8Tv3lOjE2M79/VrjwzOR6vYt1gK2bUL
pJd8kIsMi2Jd3/x507Rb9U/Ybfn+B8egjYA/BbuwchN2eQrSrtuEdlk0LRBfD3h4
JlchzK/HqbS3SHsrMnLpUYh9XiD17QTGqJqYDXE6+z/MafeBH+q6kaZDd68qnUMQ
QlE0Pb95PghTNbnkwMflDRgk3EPru/2qnYGlCq6K4POan4jUxL9o4oLD1L9bD0cp
wIY+Go1SlXYy98nDHuyIgAs8dUAOTp4kHcj7lCqr0n/xC2LF8p/aOi5MTlh4CLze
MvtTlbAL3mgiTizEax2h
=N3YB
-----END PGP SIGNATURE-----

--=-zfBBVk6tuAPghgdihpCj--

