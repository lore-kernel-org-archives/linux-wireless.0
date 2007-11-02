Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55280 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbXKBJs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2007 05:48:28 -0400
Subject: Re: [RFC] mac80211: use IW_AUTH_PRIVACY_INVOKED rather than
	IW_AUTH_KEY_MGMT
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Dan Williams <dcbw@redhat.com>, dragoran <drago01@gmail.com>
In-Reply-To: <200711011523.03063.flamingice@sourmilk.net>
References: <1193671155.5197.71.camel@johannes.berg>
	 <200711011523.03063.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CZ/dfuQDSaCekgi+M6cY"
Date: Fri, 02 Nov 2007 10:49:46 +0100
Message-Id: <1193996986.12078.32.camel@johannes.berg> (sfid-20071102_094840_102694_6460C3FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CZ/dfuQDSaCekgi+M6cY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > -	if (ieee80211_sta_wep_configured(dev) !=3D
> > -	    !!(bss->capability & WLAN_CAPABILITY_PRIVACY))
> > +	privacy =3D !!(bss->capability & WLAN_CAPABILITY_PRIVACY);
> > +	if ((ieee80211_sta_wep_configured(dev) !=3D privacy) &&
> > +	    !!((ifsta->flags & IEEE80211_STA_PRIVACY_INVOKED) !=3D privacy))
> !! for the wrong set of parenthesis, AFAICT.

Oops, you're right, will resend.

johannes

--=-CZ/dfuQDSaCekgi+M6cY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyryuaVg1VMiehFYAQJyjg//QDNnVSGQNiTB1bu4+Kn5v9uNIDMkBDfp
F+OgNYDdo2vTg9SYmKhkj5lUiuaBY4e2d1VXE4Bm5PvKQ9ph+xOO5O0sQG41kxs1
V6tW0K4m/1IiStKfwAc3NgWRxGSkkYgj4oLf8zRpk2UOLe4CztnfSPJyfcLTkW5U
7IV7hiDBOzW/enrIoE7J6jsVAmz4A7seUWCs6Pxfmc8pfGTrZ28wBUwF9Dr3e3KA
w1O4JEj0ITcFTpS5BgReA1uRsPtH7lquczQEa0wnlBy8ioaa+L+zLY7PmsIVzgxn
/byvkdBsE3BnFpmYnedwb/nZ3Pj3pT2FSI+bk93tgOaslliDf5WH8uS032ZT6GzJ
Yr58bdhucKwCgWYBsldiFVMUSVCcdZLFIHOLWUUPSw3Hhxmh3pzY56YIQ0SeGBPG
MQz9dvw9Xerq5A8ePgOnc4p1jvWFYKl0RZMxazrgdKOo7CF2rjStq3DPhfojT/rz
hpHG6pZhzvXgvlyT+xPpKC/MzAmmXe6kr4Q1rss3o6lMAFSNWLL06dUK3foT1eMw
vF0IK7o+xlhv8j+qojHtillJ6s1vDpg+G8FQb3zKhBWqa/XEH45bOYZ79+Aazubx
X3Ca4fGP8ElydF8wCCeWf+Qz3Uy61ssWj+HZ9LY2oC3nOzsrKzrA+AyhSziQ+OTw
DK+2c2ePSjc=
=BtAm
-----END PGP SIGNATURE-----

--=-CZ/dfuQDSaCekgi+M6cY--

