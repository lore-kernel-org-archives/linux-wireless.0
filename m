Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44134 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYEVTQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 15:16:37 -0400
Subject: Re: [PATCH] mac80211: do not alter injected seq numbers
From: Johannes Berg <johannes@sipsolutions.net>
To: JMF <tolas_feup@hotmail.com>
Cc: linux-wireless@vger.kernel.org,
	Alejandro Grijalba =?ISO-8859-1?Q?Mart=EDnez?=
	<sud@latinsud.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <loom.20080522T185920-107@post.gmane.org> (sfid-20080522_211000_297449_6D1BE157)
References: <47FAB829.9010304@latinsud.com>
	 <200804081025.39645.mb@bu3sch.de> <loom.20080522T171937-155@post.gmane.org>
	 <69e28c910805221115g6290e5e9nef4444efca07aea@mail.gmail.com>
	 <69e28c910805221121v1a34901co35ec41bff41bd1ec@mail.gmail.com>
	 (sfid-20080522_202122_300727_51A7210B) <1211481278.3698.58.camel@johannes.berg>
	 <loom.20080522T185920-107@post.gmane.org>
	 (sfid-20080522_211000_297449_6D1BE157)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Lw2dHWnj7fOdYW0Nj4k2"
Date: Thu, 22 May 2008 21:15:23 +0200
Message-Id: <1211483723.3698.69.camel@johannes.berg> (sfid-20080522_211640_532186_4FA9CED9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Lw2dHWnj7fOdYW0Nj4k2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[don't drop CCs, restored]

> Are you really sure the flag is IEEE80211_TX_INJECTED?
> For the current (today, 22 May) wireless-testing, it seems it's been
>  renamed to IEEE80211_TX_CTL_INJECTED. Also, not tx->flags anymore, but
>  info->flags instead.
> Can you confirm that?

Yeah both of those are correct, due to a recent patch of mine.

> I was going to say something else, but I saw another post by Johannes... =
Strange
> that hostapd uses injection in monitor mode interfaces, I thought it woul=
d be
> only  AP mode interfaces.

No, it uses monitor for a bunch of things, including getting access to
management frames (before a station has associated.)

> And it is also strange that iwlwifi developers wanted to disallow injecti=
on in
> monitor mode, with hostapd apparently needing it!

No, not strange either, for one iwlwifi doesn't seem to support AP yet,
and secondly the monitor interface would be secondary so iwlwifi
wouldn't even notice it.

johannes

--=-Lw2dHWnj7fOdYW0Nj4k2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDXGSaVg1VMiehFYAQIxaA//RGEzkmC5TCoQcitKWopEF10kA2a/x9N7
3fhdNqtzA79YOJRlvn6r8k2xBmhKqsrlUOra/Y1INYIBeNZLfTiurUzhCgWYR+gO
diR2xAKGtCQzr4AyL1dVUE08Y6TLcMVxrIzUZY0NU0p2bB17USvLqvaoWKx4ESmq
e+1DdCTzW/InIsolcBNzfO6TBHe4C4XF4v0j3pqiPH6BlO4y/DEAdqzGYbz771KA
P14o6EoOXX8fSyLREKiML+p8UpC+AAEggGJ+rLL0oV7hP1SlyaJPG6i7krhbozG3
DwigwihXH4myoQDzQPpIURRWL9DvbyJGr6l+nUm97605Xn1v20KXZzBccFv9HKfL
/dCcpSleFtkr3jLFQCVg3ChB47YE5UCVazIlHvrXT9u4hh1ysyvh5enCwcWxTGwm
Po3fgF6KIXEmALe5fQsYOKFcD+kEsqpTlYvEVTq+wVyUmyV5fgabCuBCh50OT99y
TmnFYcluV4vta5M9cB0cyzBvM6zz+xpjjyolKlcVsElzSoc8NgxXbwP4ZfqfIaeZ
bug5yu5rj2uGxK/ULdAG6uPLdUBzrOAnN47Sgtutz0DXTwhFAXuh9wMR7yApKt+b
Xfbj0muFAwFqPVMpy4THCuMMjKbcHQ+m1UUQWJR9O4t+e8LOtZza2rkGJz8/EUAR
5+ssEtpyh+0=
=HUNA
-----END PGP SIGNATURE-----

--=-Lw2dHWnj7fOdYW0Nj4k2--

