Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZHHWx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 18:53:59 -0400
Subject: Re: [PATCH] mac80211: remove max_bandwidth
From: Johannes Berg <johannes@sipsolutions.net>
To: Pat Erley <pat-lkml@erley.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1249768399-16855-1-git-send-email-pat-lkml@erley.org>
References: <1249768399-16855-1-git-send-email-pat-lkml@erley.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ym9jIeQqBuDsffOhpCtR"
Date: Sun, 09 Aug 2009 00:53:54 +0200
Message-Id: <1249772034.4636.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ym9jIeQqBuDsffOhpCtR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-08-08 at 17:53 -0400, Pat Erley wrote:
> This removes the max_bandwidth attribute.  It is only ever
> written to, and is duplicated by max_bandwidth_khz in the
> regulatory code.
>=20
> Signed-off-by: Pat Erley <pat-lkml@erley.org>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/net/cfg80211.h |    2 --
>  net/wireless/reg.c     |    3 ---
>  2 files changed, 0 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index d5756c9..2239134 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -80,7 +80,6 @@ enum ieee80211_channel_flags {
>   * with cfg80211.
>   *
>   * @center_freq: center frequency in MHz
> - * @max_bandwidth: maximum allowed bandwidth for this channel, in MHz
>   * @hw_value: hardware-specific value for the channel
>   * @flags: channel flags from &enum ieee80211_channel_flags.
>   * @orig_flags: channel flags at registration time, used by regulatory
> @@ -97,7 +96,6 @@ enum ieee80211_channel_flags {
>  struct ieee80211_channel {
>  	enum ieee80211_band band;
>  	u16 center_freq;
> -	u8 max_bandwidth;
>  	u16 hw_value;
>  	u32 flags;
>  	int max_antenna_gain;
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 0f61ae6..fc7a484 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1018,7 +1018,6 @@ static void handle_channel(struct wiphy *wiphy, enu=
m ieee80211_band band,
>  			map_regdom_flags(reg_rule->flags) | bw_flags;
>  		chan->max_antenna_gain =3D chan->orig_mag =3D
>  			(int) MBI_TO_DBI(power_rule->max_antenna_gain);
> -		chan->max_bandwidth =3D KHZ_TO_MHZ(desired_bw_khz);
>  		chan->max_power =3D chan->orig_mpwr =3D
>  			(int) MBM_TO_DBM(power_rule->max_eirp);
>  		return;
> @@ -1027,7 +1026,6 @@ static void handle_channel(struct wiphy *wiphy, enu=
m ieee80211_band band,
>  	chan->flags =3D flags | bw_flags | map_regdom_flags(reg_rule->flags);
>  	chan->max_antenna_gain =3D min(chan->orig_mag,
>  		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
> -	chan->max_bandwidth =3D KHZ_TO_MHZ(desired_bw_khz);
>  	if (chan->orig_mpwr)
>  		chan->max_power =3D min(chan->orig_mpwr,
>  			(int) MBM_TO_DBM(power_rule->max_eirp));
> @@ -1329,7 +1327,6 @@ static void handle_channel_custom(struct wiphy *wip=
hy,
> =20
>  	chan->flags |=3D map_regdom_flags(reg_rule->flags) | bw_flags;
>  	chan->max_antenna_gain =3D (int) MBI_TO_DBI(power_rule->max_antenna_gai=
n);
> -	chan->max_bandwidth =3D KHZ_TO_MHZ(desired_bw_khz);
>  	chan->max_power =3D (int) MBM_TO_DBM(power_rule->max_eirp);
>  }
> =20


--=-ym9jIeQqBuDsffOhpCtR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKfgH+AAoJEODzc/N7+QmaQyEP/AvzDKUW8k9M0FoZiH72quDk
Fdpq68UI+wqTkEzTkzdxc7J9JtP6SFlbDJY8adNoFleA2qRDIiCHbnAKoO6htFnq
6P4FcM6jcBfioJBe6XgkdVkKfQO6I2JzPgRTZZvCAHJ40scLA+NIYUTIXtEf5MLO
yzy4b6iTwH6DOKhZmb4dVXd7igRPGQ87hxE1Ei9nJPdxiJBWYTafdqNUhE+zI8Ry
yak1Hqlb8bIMxvzzF7VMNAJY8JphkOvCwnceUMz2de5sT4tBIqVgY17CCrIIXLSv
bODZpZHLokNozWUv94unAR6r7/u94dkMNtkPKDOK+3NgwMnHo4G9ZvW/Tykn+baG
4FNDX2UVMbJXCEiyJdgxMBMtj1W+DoidDlBv7Eb/RUUYOfm37FpN1eJNLRU1QwLf
/XpMYAROE0nWr7fnOuEwg2SvKGTRCTZr0S1PBAEnkiRFdg8XpNlHb0Dw3NFA00KD
JmdrhZSpNDU3ib6jw3Al3AuLdyfKlvtMiHwYHQRy49T7nqoVJOGOMbNO6dszhywe
pP8d2DDePJ4EqYUmLPuaMXi/pAONOLDwmXqndf4QgFg7QudMgoHtIDmTTAAmjzno
3xvwo0I8alSGEFSly5tw/Ns6DVXrQe2aKDdizVnSQPOfRRIUQThrR6GsRp/aGJbY
mDqi9k2vM34oupAmTfqQ
=NHeF
-----END PGP SIGNATURE-----

--=-ym9jIeQqBuDsffOhpCtR--

