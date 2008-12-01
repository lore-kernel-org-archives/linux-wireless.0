Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbYLALx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 06:53:56 -0500
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <20081202011754.GA9382@myhost.users.atheros.com> (sfid-20081201_124427_646417_122C4B13)
References: <20081202011754.GA9382@myhost.users.atheros.com>
	 (sfid-20081201_124427_646417_122C4B13)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wUeTVzdRdUMFek+jXcCG"
Date: Mon, 01 Dec 2008 12:53:51 +0100
Message-Id: <1228132431.3478.21.camel@johannes.berg> (sfid-20081201_125400_561242_07D8C4AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wUeTVzdRdUMFek+jXcCG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-01 at 17:17 -0800, Vivek Natarajan wrote:
> This patch is based on Kalle's initial RFC patches on dynamic power save.
> Since ath9k/ath5k,stlc45xx and b43 need the driver to send the null
> frame, it is appropriate to do it from mac80211.=20
> This patch enables mac80211 to send a null frame and also to
> check for tim in the beacon if power save is enabled.

Nice! Looks pretty much good to me, but could use some documentation
(Kalle will hopefully add some too). For instance, a casual observer
might wonder how the hardware can be saving power when the host software
has to parse beacons -- obviously things will only fall into place once
we support beacon miss offload.

> +static bool check_tim(struct ieee802_11_elems *elems, u16 aid, bool *is_=
mc)
> +{
> +	u8 mask;
> +	u8 index, indexn1, indexn2;
> +	struct ieee80211_tim_ie *tim =3D (struct ieee80211_tim_ie *) elems->tim=
;
> +
> +	aid &=3D 0x3fff;
> +	index =3D aid / 8;
> +	mask  =3D 1 << (aid & 7);
> +
> +	indexn1 =3D tim->bitmap_ctrl & 0xfe;
> +	indexn2 =3D elems->tim_len + indexn1 - 4;
> +
> +	if (index < indexn1 || index > indexn2)
> +		return false;
> +
> +	index -=3D indexn1;
> +
> +	if (tim->bitmap_ctrl & 0x01)
> +		*is_mc =3D true;

Shouldn't you update *is_mc before the above return false? And also set
it to false in the other case, I think.

> +	return (bool)(tim->virtual_map[index] & mask);

I think
	return !!(... & mask);
would be more appropriate.

> @@ -1734,6 +1759,15 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80=
211_sub_if_data *sdata,
>  	ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
>  				 elems.wmm_param_len);
> =20
> +	directed_tim =3D check_tim(&elems, ifsta->aid, &is_mc);
> +
> +	if (directed_tim || is_mc) {
> +		if (local->hw.conf.flags && IEEE80211_CONF_PS) {
> +			local->hw.conf.flags &=3D ~IEEE80211_CONF_PS;
> +			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> +			ieee80211_send_nullfunc(local, sdata, 0);
> +		}
> +	}

How will we get back into PS mode after=20
=20
> @@ -2616,13 +2650,15 @@ void ieee80211_mlme_notify_scan_completed(struct =
ieee80211_local *local)
> =20
>  void ieee80211_ps_enable_work(struct work_struct *work)
>  {
> -	struct ieee80211_local *local =3D container_of(work,
> +	struct ieee80211_local *local =3D	container_of(work,
>  						     struct ieee80211_local,
>  						     ps_enable_work);

Huh, what's the change here?

> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 9e74e9f..254fb4e 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -985,12 +985,18 @@ set:
>  	local->powersave =3D ps;
> =20
>  	if (ifsta->flags && IEEE80211_STA_ASSOCIATED) {
> -		if (local->powersave)
> +		if (local->powersave) {
> +			ieee80211_send_nullfunc(local, sdata, 1);
>  			conf->flags |=3D IEEE80211_CONF_PS;
> -		else
> +			ret =3D ieee80211_hw_config(local,
> +						  IEEE80211_CONF_CHANGE_PS);
> +			}
> +		else {

The indentation here looks a bit odd, please put the closing brace
before the else

johannes

--=-wUeTVzdRdUMFek+jXcCG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJM9BLAAoJEKVg1VMiehFY7KMP/RCvNmskpS21HYkAcAY8wNbI
GQW/YNeoDayecVxIeLQVYITli6dGnBA/DguXfu52jxHx37Luz0FvLSNoQQn5Hjn8
avDFNF487BKr9etb68zn1uoWvAjwrUcI9XIfIyextbkZYUqGL/D+AedFbIbQEKhy
K8n/Lsd/YoJNixeo1MOiHWCqT+/g7UxxFsN0LhcNlDyBPv5KcuIu8Qnw92pL8Xp5
tegRLWYcbPv9mjOEIDAWPVIt0YFODsID+eITXJL/eq1eJQ/yIQwo2+R5nLCv3H6W
DbcMmx8bzaTrMEN1Slz2gA15EXcTF3M+p9HO5QKfkKuD8foptJicvqjk4eDLg0Y5
DvDawEi4ToUWZsVzm+DgUl0NwgnNZMe2pRC/eBgKXmrwB1wrPc6VAXyT4aCs3z9e
/O5Gr5Bn362bDDY6zBBn/it1tuubutthf+v9oTut2mWC3JdI3Ix4qPzBVhz7IZS4
ZszXZY78kcvlKJup4hTWUp3KUlBWMVjE4k/cWi0DubdP2Zze7Y4N7pyewGeWOA51
9Pntz3rcmx1ZjGNX6vThW32spj610NZsH1hMSUDJ7G8mK0LtC9J0D6KhpuOxkOQ3
dpF2zFtkcLUYX6M1yxsxGOEBJIPRVtEQmHI+5dJUYRndeqM1c+/tetWd50JasDOe
NTabyZU1TsAj+2feKNE6
=fVj+
-----END PGP SIGNATURE-----

--=-wUeTVzdRdUMFek+jXcCG--

