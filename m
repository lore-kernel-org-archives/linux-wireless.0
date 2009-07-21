Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbZGUWbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 18:31:35 -0400
Subject: Re: Slow roaming in mac80211 (2.6.30).
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1B3FCF72EBBC44A39F5A80B8FFBF6402@gotws1589>
References: <1B3FCF72EBBC44A39F5A80B8FFBF6402@gotws1589>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kb0bKEaBL9Cun8J1Z9bo"
Date: Wed, 22 Jul 2009 00:30:54 +0200
Message-Id: <1248215454.11735.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kb0bKEaBL9Cun8J1Z9bo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Lars,

> A first analysis gives that the two delays are the ieee80211_sta_work()
> timeout.  There are many events trigging ieee80211_sta_work(), but
> since only the timer sets IEEE80211_STA_REQ_RUN, nothing will happen.

TBH I really no longer know the 2.6.30 code well, so I don't know.

> Questions;=20
> - Why does mac80211 tells the wpa_supplicant that the AP
> is gone (87.632965), and then blocks/delays the actions taken by the
> wpa_supplicant? =20

The real question is: why the hell is it probing the AP?

> [   87.632965] wlan0: deauthenticated (Reason: 1)
> [   87.733979] [B] LaE: SCANRQUEST: SSID=3DAGV
> [   88.629931] wlan0: direct probe to AP 00:40:96:a0:e7:e7 try 1
> [   88.829932] wlan0: direct probe to AP 00:40:96:a0:e7:e7 try 2
> [   89.029944] wlan0: direct probe to AP 00:40:96:a0:e7:e7 try 3
> [   89.230016] wlan0: direct probe to AP 00:40:96:a0:e7:e7 timed out

It doesn't really block actions, but it delays the scan because it's
busy doing the probing. So only after the probing fails will it start
the scan, and complete it within about 1.4 seconds.

> - Why are some wpa_supplicant actions (90.702325)
> not event driven?
>=20
> It looks to me as if we have to decision makers here. For me the
> wpa_supplicant is the one that make the decision. Once the mac80211
> gives up and feedback that the AP is gone, it should just sit=20
> and wait for next decision from the wpa_supplicant.

I agree -- the spurious probing is strange. But I also have to admit
that basically I don't care as long as it works -- most of this is just
a side effect of how wireless extensions work.

> I had a few patches for this for .26, but since the code is changed
> they do not apply. Before I create new patches I would like to get
> your opinion on this.

I would suggest you just use wpa_supplicant -Dnl80211, which should help
a lot with this kind of things.

johannes

--=-kb0bKEaBL9Cun8J1Z9bo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKZkGYAAoJEODzc/N7+Qma1QQP+QFpUTeKb8YyRS/k0V6O+mXh
tbHNjdRyact+A1WjBi6HQ3GJRbz9Q6sUborrgbYHAYaxXGdUS/RCoYLfglHjf1zT
HMSxOvRAxk58KC3TEBAaUAChozQLJqKwbtwSE6VDzi+R3Hf3vpRRPElUkoBs959y
vKV/9IN8cizS2B0vsAypocKGuYJQPRhdROo5iVxJg4HTRXrpuB9kwWoAe3PMr9yK
K2CQffJQJ4YuM5Zo5qEu/GGFPGGMubXiYy3xkyIqe+JzLDEI/uY2xO7PcXlP/1p5
j5YmOx8pFZLI0zN6XGh/4S4m48fTUGahY/NdhRPZwzI/Ue/4BGZn1X0aVwMZCIzf
w0lI/bEH4jeQuYryauhjzni8aPcEaG3K7XuE5hPqpk9YIw9kn9rPNWxOFH6JeV36
ErlQYgtchf//v0NcMla4iLZtXIk14CzIJeG5JmcNLxtGz8p1i4Kn1bEln0GjNRkV
pPlymY2KtLdmrsK3uxmD6jPiqRXJFwD+T4jibCjLfyA+X6f+Ly3cxeajBHTLAwuv
g6QqAqnqCiBpedCh/wi8kWGg9/NGpqhypq3R/AYNk/3zXgUsrwxx/zxm13MDYRCy
kEYpU3+2NQZPK8ngUBQ7PrRsAkFuSOYEcnenoWq6y9cQIC/HlW7TNhq/v23qSI9s
zw+0mk5LLYOKookmpftV
=er5e
-----END PGP SIGNATURE-----

--=-kb0bKEaBL9Cun8J1Z9bo--

