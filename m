Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43945 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbZAGPIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 10:08:54 -0500
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for
	management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
In-Reply-To: <20090107140956.GA22424@jm.kir.nu>
References: <20090107112346.369581673@atheros.com>
	 <20090107112707.370907962@atheros.com> <1231330118.3545.28.camel@johannes>
	 <20090107122427.GA20019@jm.kir.nu> <1231332428.3545.33.camel@johannes>
	 <20090107140956.GA22424@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rF18+Yd0HCJ27jM02iwE"
Date: Wed, 07 Jan 2009 16:09:04 +0100
Message-Id: <1231340944.3545.38.camel@johannes> (sfid-20090107_160858_753438_4A124742)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rF18+Yd0HCJ27jM02iwE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 16:09 +0200, Jouni Malinen wrote:
> On Wed, Jan 07, 2009 at 01:47:08PM +0100, Johannes Berg wrote:
>=20
> > Ok, I guess in that case it doesn't really matter much, though it'd be
> > good to not randomly associate to an AP that has MFP enabled when we
> > don't know the hardware can handle it.
>=20
> Yes and that why I was considering of a flag to notify hostapd and
> wpa_supplicant about the capability.. But that would mean modifying WEXT
> even more ;-).

Or just adding it to nl80211, are we ever expecting to have pure wext
drivers with MFP capabilities??

> > You seem to be concerned only about AP mode, while I'm not much
> > concerned about that, there it's always tested explicitly by the person
> > setting up the AP, but someone who's just using STA mode would now
> > suddenly potentially run into problems when using an AP that is
> > MFP-enabled, no?
>=20
> It is similar for both ends.. For example, wpa_supplicant does not
> enable MFP on the client side by default, i.e., both hostapd and
> wpa_supplicant behave the same in the sense that MFP needs to be
> explicitly enabled.
>=20
> > Hence, I think adding an explicit flag (whether it needs to be exported
> > to userspace I don't know) would probably be good so if the driver/hw
> > really cannot handle MFP at all then we don't associate using it, no?
>=20
> MFP is negotiated in RSN IE and in case of mac80211, it would need to be
> going to userspace since wpa_supplicant builds the RSN IE (and well,
> hostapd obviously does the same for Authenticator side). We could a new
> WEXT capability (e.g., IW_ENC_CAPA_MFP) for this, if desired.. It would
> also be possible already with the current patchset to probe for this by
> setting IW_AUTH_MFP and see whether the driver returns EOPNOTSUPP, so in
> that sense, wpa_supplicant (and hostapd) could already figure this out
> before trying to associate.

Generally, the thing is that we don't really want to require people to
manually enable MFP, but rather have NM set it to "enable whenever
possible". That seems not workable unless we know which driver/hw
supports it.

johannes

--=-rF18+Yd0HCJ27jM02iwE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZMWNAAoJEKVg1VMiehFYXBUP/RguzEXzCCFgnfjEjm1dSXS7
n5ZgaOqU2hxpaKDv9iPuEHW5aGmSFqcpkCzpLznc3HV0T3fVaVG99q6BhmH1v2RC
AQzqkElAY5dR5itrxiEqezSLlhVq8wVt34IMWRBeId3ALHcu4l8EwMZeYgVKO19s
thRNvSg9RRZu4MpwTX6SCDSRMxZTLFS8QAYO04fukemQmm+gZdTmxB4/8Mcx/gzV
et8s8jKiQU95zn3GkC4E+8/7LTPODytRhQfHb5GM3rctKj6kHDW2HYEuJq2wNSuX
EE1g37qOjUQsm+yyC96G3g7OfMolvpCZtY/pudPTjIRWlCDYWfWg0TdNZkS41jQ9
qEK48sfXHB+vKtkZ0QbMq2BbWvpOLie2ZJVCnjUxFv276nY1buO6dxNT+rYMe9z7
DiKZQELBj6ZuavCsDrazTuwtCZy7dmFiU3r++pBX6GkQe8F3ZBWjlSygNsPM9Reb
i93Y/70qefT+6aWG6usM5A0JgGPPBsZIOyUswMRQMDyU1NYIZPFA5YyhTLlwTENQ
A6FqUn33qn/L+gt4z0QC5yB1Mb57qgUJzmLSi0Cofj3NPlYc1m8wAwc26Ervcr3b
psdmsAxNOGRRUbB9c/DJr8aINPPtDyUGCsTsYQKdTAj3sC5Ws/nKpfx+vpVeUJS+
nZkcFLQWljyA2+cS3VgE
=A64Z
-----END PGP SIGNATURE-----

--=-rF18+Yd0HCJ27jM02iwE--

