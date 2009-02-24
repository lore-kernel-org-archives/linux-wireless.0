Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbZBXCKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:10:14 -0500
Subject: Re: SIOCGIWSCAN-race
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lars Ericsson <Lars_Ericsson@telia.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090223211155.GA8814@tuxdriver.com>
References: <B944EEED4BC94818AF57142C1687A0A0@gotws1589>
	 <20090223211155.GA8814@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UrKMyZey9zhWaEdc0GsM"
Date: Mon, 23 Feb 2009 17:48:12 -0800
Message-Id: <1235440092.4455.40.camel@johannes.local> (sfid-20090224_031019_483079_BFB08D77)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UrKMyZey9zhWaEdc0GsM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 16:11 -0500, John W. Linville wrote:
> On Sat, Feb 21, 2009 at 08:33:06AM +0100, Lars Ericsson wrote:
> > Hi Johannes,
> >=20
> > I have discovered and patched a race in the scanning function since a c=
ouple
> > of releases.
> > To day I checked the current Linux git and the problem is still there.
> >=20
> > The problem is the sequence of events when the scan result is reported =
back.
> > The wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);=20
> > is called before ieee80211_hw_config(local);
> >=20
> > ieee80211_hw_config(local) will trig the wpa_supplicant to select an AP=
.=20
> > That may happen before the ieee80211_hw_config() is executed since the
> > wpa_supplicant
> > generated actions is executed by an other thread (wpa_supplicant).
> >=20
> > The result is that:
> > - wpa_supplicant setup for an association to an ap using correct channe=
l.
> > - ieee80211_hw_config() reset the channel to the value before the SCAN
> > started.
> > - the association request will be sent out using the wrong channel.
> >=20
> >=20
> > Attached you will find the patch for 2.6.27.=20
> > It is not a perfect patch since the code is duplicated but it works :)
>=20
> Looks like the patch would need to be reworked -- the code in 2.6.29
> and later is different. =20

and the new code with cfg80211 is even more different ;)

> Also, any reason we can't just move the
> wireless_send_event() down to done:?

seems fine

> Still, this doesn't feel quite right.  Shouldn't we be able to queue
> the userland-driven channel change until after the scan completes?

?
we do that, well, we set it here:
        local->sw_scanning =3D false;
        ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);

but we claim to be on the user requested channel at all times, so that
should be ok

johannes

> John
>=20
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index f5c7c33..8c13a91 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -437,15 +437,6 @@ void ieee80211_scan_completed(struct ieee80211_hw *h=
w)
>  	local->last_scan_completed =3D jiffies;
>  	memset(&wrqu, 0, sizeof(wrqu));
> =20
> -	/*
> -	 * local->scan_sdata could have been NULLed by the interface
> -	 * down code in case we were scanning on an interface that is
> -	 * being taken down.
> -	 */
> -	sdata =3D local->scan_sdata;
> -	if (sdata)
> -		wireless_send_event(sdata->dev, SIOCGIWSCAN, &wrqu, NULL);
> -
>  	if (local->hw_scanning) {
>  		local->hw_scanning =3D false;
>  		/*
> @@ -486,6 +477,15 @@ void ieee80211_scan_completed(struct ieee80211_hw *h=
w)
>  	rcu_read_unlock();
> =20
>   done:
> +	/*
> +	 * local->scan_sdata could have been NULLed by the interface
> +	 * down code in case we were scanning on an interface that is
> +	 * being taken down.
> +	 */
> +	sdata =3D local->scan_sdata;
> +	if (sdata)
> +		wireless_send_event(sdata->dev, SIOCGIWSCAN, &wrqu, NULL);
> +
>  	ieee80211_mlme_notify_scan_completed(local);
>  	ieee80211_mesh_notify_scan_completed(local);
>  }
>=20

--=-UrKMyZey9zhWaEdc0GsM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1HaAAoJEKVg1VMiehFYqiIP/julu9tkwimLJbXMJ8eGXmPn
wGQLqQNY3Y0wUyAfI27JchsJhZGD+I9xhN5qP8zASfzuBfUmwt9pfHcWms9nSju+
czX+GsLscv2jHD6LmLkBAEyJiqJuH4qO5PybFGGohx8azV+rqQ6781ANg6LP9hCU
lFBfGpR+vy6EmdJvLTqvHVVXGvy0mYmbtSnTUcgamvuzWioSijoZA+2bkdEiBzU1
EVAqr0PT3v+qPdhEmmCtMT/XsVJsB9MVhB2SkY88ULsNSIIqSWWW3OHDTc1Z7s69
oam4QcsGqa3CeAmUOb9jN7WofS3vtkXRQx4nG/DIqxqEJS5jtrg19y4bYIk3HOdJ
eIE2YaInIJk4tihdhyfQRx0azclj+7Q+LnytoUoiFqXl9c5/Hx9Z/4VEIPKIv5gb
p6RdRnTiTcEUim2iOB5EmvOZS1C9i7urlxMl04Jvqt2mbMIFrrp/BBBgmerOJ9Yv
Am78okx9z1LC/Eb8lfSYwT/cYQA5gt4umIwslkLgop+e+FJKIjrRwhPS+t4/Y55J
D082LxyPButNLEpIQEnIf4FmgNmeGHNwxAjoVphNe30vXBxiDtxea23XoegGKyVR
BZPPVwjuUOYfQ25SGkbu4Tb1mPVtI25mHLUnWPMswaEwSpVaOf5GIpfmnMs1Ivr1
H2iq5MyTa5c2VOB5r/mC
=SAue
-----END PGP SIGNATURE-----

--=-UrKMyZey9zhWaEdc0GsM--

