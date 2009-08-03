Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbZHCOZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 10:25:42 -0400
Subject: Re: ar9170usb crashes during iwconfig for ad-hoc mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Albert <jal2@gmx.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090803123642.242160@gmx.net>
References: <4A759341.1090006@gmx.de>  <4A7612F8.80802@gmx.de>
	 <1249289084.2007.54.camel@johannes.local>
	 <1249289274.4561.0.camel@johannes.local>  <20090803123642.242160@gmx.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OEd7uNA366W8ih2q0QKV"
Date: Mon, 03 Aug 2009 16:25:06 +0200
Message-Id: <1249309506.4561.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OEd7uNA366W8ih2q0QKV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-03 at 14:36 +0200, Joerg Albert wrote:
>=20
> > On Mon, 2009-08-03 at 10:44 +0200, Johannes Berg wrote:
> >=20
> > > > >     ifconfig wlan1 down
> > > > >     iwconfig wlan1 mode managed essid huhu
> > > > >     ifconfig wlan1 up
> > > > >     ifconfig wlan1 down
> > > > >     iwconfig wlan1 mode ad-hoc essid huhu_a channel 1
> >=20
> > > No, it's a bug in cfg80211 :)
> >=20
> > But it's not making sense to me. I'll have to try to reproduce it. In
> > any case, we shouldn't be calling in to mac80211 from cfg80211 while th=
e
> > interface is down.
>=20
> I guess this is caused by the call to __cfg80211_leave_ibss()
> in  net/wireless/ibss.c::cfg80211_ibss_wext_siwfreq() trying to
> disable the beacon via net/mac80211::ieee80211_ibss_leave().

But it only does that if (wdev->ssid_len) which should be false, so I'm
confused.

johannes

--=-OEd7uNA366W8ih2q0QKV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKdvM8AAoJEODzc/N7+Qma45cP/A3x2tBo4zdl/VKVAfGtinL+
Jo024ZdVe/oQbxYdkcS+bM9rRwhn2+Tv21ssJO5rl+hg4bxunCYQeMsK73Ovxj88
6vHXiJSd5hJ3cYtXlVa1TGCFyi1rpMbjtLG3aUqp72rW4XelDgB8s6/wYq8Zz4EG
pDJxT5a1qI4+yn36DF+DUtFPWPlo8EktmCm+Cfi63jGI8t6ie6i2GNJlGM8USsOr
yBTu8FTKgLlJL+B3oF+64wpXCkBzUzOd9ciRtTLbdIhWrunuv5q3ohkMkbUQsxn7
hC8oLAWLdcQpzvLJBv8l3ezXksP4oJyFLpkvQKIZjHbPg9Lbb7/ntJoWN2Tj2fhM
1YyPfvVFUaDGZgc+DZ2kvqGGM5yt4F63xR7rNcaG5z/76+7EwdrFgROwz4rU4mhm
InqnZiS2RJYGcmTdwY4ImkixItzVSmQN8jzbRAfAy/3H3sYkchnLgU1WwZ1VlLQT
ZU5EjeaMsZXsAMECXPrgGK2JzaqF2O+4RBrTxTK41VoR1YqyI7Fj2ZTGFAMruozb
CUJQAy6dO4b9XpaqHMtZa0YjYbs6Sd+thbT/9clo/8NH5VT9naT6ecpOlhTEPwog
jmwB8jd6wAIMeQ9R17Ja9rXdE50Vm69QvUAVG/dxgQYBmiHOxsjsmywGOGDuU15w
+9WIqUXUWZbY/IJw9uQ3
=56B7
-----END PGP SIGNATURE-----

--=-OEd7uNA366W8ih2q0QKV--

