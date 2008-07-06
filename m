Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39391 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYGFIqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2008 04:46:05 -0400
Subject: Re: mac80211 ad-hoc problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: wireless <linux-wireless@vger.kernel.org>, bruno@thinktube.com,
	vlado@work.ksp.sk
In-Reply-To: <4870556A.5050002@gentoo.org> (sfid-20080706_061831_175291_526004F6)
References: <486EA910.80408@gentoo.org>  <4870556A.5050002@gentoo.org>
	 (sfid-20080706_061831_175291_526004F6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MdZ3/N1gBYEyasvp6tVo"
Date: Sun, 06 Jul 2008 10:45:46 +0200
Message-Id: <1215333946.9610.4.camel@johannes.berg> (sfid-20080706_104612_945560_180C421F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MdZ3/N1gBYEyasvp6tVo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Oh, I misread the code. I thought it was only looking for a=20
> user-specified BSSID (but I had not specified one). Actually it is=20
> checking that we aren't attempting to join the same network that we are=20
> already on.
>=20
> The problem that was preventing me from getting connectivity was=20
> channel. It was only accepting IBSSes on local->hw.conf.channel, so I=20
> was required to do "iwconfig wlan0 channel X" first.

Heh. I might have done that, yeah.

> Is this by design, or is automatic channel selection a desirable=20
> feature? see attached patch, which seems to be working

Seems we should do automatic selection, the patch looks ok to me.

I wonder though, if we decide to create a new IBSS, which channel will
we choose?

> Daniel
> plain text document attachment (ibss-channel.txt)
> [PATCH] mac80211: automatic IBSS channel selection
>=20
> When joining an ad-hoc network, the user is currently required to specify
> the channel. The network will not be joined otherwise, unless it happens
> to be sitting on the currently active channel.
>=20
> This patch implements automatic channel selection when the user has not
> locked the interface onto a specific channel.
>=20
> Signed-off-by: Daniel Drake <dsd@gentoo.org>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

>=20
> Index: linux-2.6.26-rc8/net/mac80211/mlme.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.26-rc8.orig/net/mac80211/mlme.c
> +++ linux-2.6.26-rc8/net/mac80211/mlme.c
> @@ -3582,6 +3582,7 @@ static int ieee80211_sta_find_ibss(struc
>  	int found =3D 0;
>  	u8 bssid[ETH_ALEN];
>  	int active_ibss;
> +	int search_freq;
>  	DECLARE_MAC_BUF(mac);
>  	DECLARE_MAC_BUF(mac2);
> =20
> @@ -3614,11 +3615,21 @@ static int ieee80211_sta_find_ibss(struc
>  	printk(KERN_DEBUG "   sta_find_ibss: selected %s current "
>  	       "%s\n", print_mac(mac, bssid), print_mac(mac2, ifsta->bssid));
>  #endif /* CONFIG_MAC80211_IBSS_DEBUG */
> -	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) !=3D 0 &&
> -	    (bss =3D ieee80211_rx_bss_get(dev, bssid,
> -					local->hw.conf.channel->center_freq,
> -					ifsta->ssid, ifsta->ssid_len))) {
> +
> +	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) !=3D 0) {
>  		int ret;
> +		int search_freq;
> +
> +		if (ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL)
> +			search_freq =3D bss->freq;
> +		else
> +			search_freq =3D local->hw.conf.channel->center_freq;
> +
> +		bss =3D ieee80211_rx_bss_get(dev, bssid, search_freq,
> +					   ifsta->ssid, ifsta->ssid_len);
> +		if (!bss)
> +			goto dont_join;
> +
>  		printk(KERN_DEBUG "%s: Selected IBSS BSSID %s"
>  		       " based on configured SSID\n",
>  		       dev->name, print_mac(mac, bssid));
> @@ -3626,6 +3637,8 @@ static int ieee80211_sta_find_ibss(struc
>  		ieee80211_rx_bss_put(dev, bss);
>  		return ret;
>  	}
> +
> +dont_join:
>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
>  	printk(KERN_DEBUG "   did not try to join ibss\n");
>  #endif /* CONFIG_MAC80211_IBSS_DEBUG */

--=-MdZ3/N1gBYEyasvp6tVo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIcIY1AAoJEKVg1VMiehFY4LQP/09AoMNGs7/l9SdIRWa2Vjrt
3R12gTYFlgEF9KbRb/YJuBinA9uB2BX7i0g0yLoKnKTxdlgsmqdW03t/bHq+TD6a
xkyZ7yXQsRN/6uCH9I3u/6b0dWhxK65Nrms6JHX1v4rQvl22dKSTpPbBFUG9CX/e
Q0jxTwiIYnWppi13XHsxw/8CoCdLuIAqgDOr3VNsCcVulwHC4AVyZCJHOSIIs4gi
GW9PYIM6WfLGrXePd7ug3UpGs7ivwO9g2ERTL/8XBZ9oUZ2ixV9EYMeQVxOrBHHq
YCXvMenPvcfcVnCJu5kRWAiVs57Gw41Mw4aqvFDyP6/jviSbIC3weci6XDBwNxvZ
B4VHUthb6sb8TjT6Crc12wCtJ3NRgc7761j6m+sQafvKlTr5mEfJVdGAVwWkhbVg
XOpQhWeBLd8Ba+xI97xXQs+0AIWXcOWmLsPMa5laBEUY+F9K1HijYIR8NN/LYP5F
yiQZQnc6XMluymAbZ7DX8iGLOk/hH3xF1knDo84UYe+AjOatbjh2idBRKvWQexxv
qLEOxLCsygJ+aMcI+S4+hev5Vf+5fcLyFrYqUlWfG2vmLwefVhAFZyhTPQQyA3xv
SzLVT8PPJoqLtXnv47JjaXFsYBpMQHSEwWQOn5NEttON/JSiAxSe5uoZ/M/fNYd8
zvbUA+QbwA2vBymRR7Pq
=vt9H
-----END PGP SIGNATURE-----

--=-MdZ3/N1gBYEyasvp6tVo--

