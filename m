Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085AbZDSOdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 10:33:44 -0400
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090419142631.158790@gmx.net> (sfid-20090419_162703_506410_10175D69)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240147370.898.0.camel@johannes.local>
	 <20090419142631.158790@gmx.net> (sfid-20090419_162703_506410_10175D69)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ykBOYMVN5llVr30ZMuxV"
Date: Sun, 19 Apr 2009 16:33:41 +0200
Message-Id: <1240151621.898.13.camel@johannes.local> (sfid-20090419_163346_662878_5F0F1754)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ykBOYMVN5llVr30ZMuxV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[resend with list]

On Sun, 2009-04-19 at 16:26 +0200, Alina Friedrichsen wrote:
> > Hmm, I forgot one thing -- you may want to create an IBSS on a specific
> > channel, but still allow it scan for other IBSSes. I guess we need a
> > flag for that and not make "channel set" imply fixed channel.
>=20
> In cfg80211 an indication for channel auto select is needed for IBSS
> and _STA_ mode, to implement with it the old wext interface. If not
> set the channel shouldn't be changed. If you not want store this flag
> in cfg80211, you must store it in the channel functions of wext to
> have the same behavior like now.

That's not what I was referring to -- and wext doesn't actually allow
what I'm referring to afaik.

When you want to create an IBSS on channel 5, what do you do?

I think you have to
	iwconfig wlan0 essid test
	iwconfig wlan0 channel 5
	iwconfig wlan0 ap off # clear fixed channel bit

which is ... weird. OTOH with mac80211 you can also say
	iconfig wlan0 channel -1

but that's even more strange.

johannes

--=-ykBOYMVN5llVr30ZMuxV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6zZDAAoJEKVg1VMiehFYXIQQAL6qTtIV9UD+iYnG2feLr2a1
qxHbBuWTq10t8E/TOL4hMEfaupVWLhdrHNylA+fbDV2sb6pvdtwfqm+oFUW9Y75f
Qil/b4RzARx0srswDiZBpdBouLMBmh0zE6pPImG/Qre0/fHVCaEhOPj6EJiXSGQy
lnJMSBmCffmYxAAfhbhy8xN8+tR1oHyIGc2cQI9TbkTupa12kNNTFkDawGBQ3hD8
Zf17fWRWQJou0axmeZ5nz6SUFRUWLt3Roc1cl2qKl7lKYDaiEJCDve4xLhhlSQRW
krjRPlHLMJP3nLaGym1imXlTR32vSbb589XjgH63hCGG/hevqaAl3ox7QhmQH8sc
C3TZDXuTTfqIgHyIQ38hDvB9flzVHrah6CLQYTnMBUNDNjUqPdwp4hZzJmvbEpvT
ykAhj5U0N4ZOVmr7KuUvUs5/2e9AGyB6kE+5oG2Z133qRxuo/V3J/sQ7Ori/i2V2
fn3KR0Tzq7/dLWJgAbTgfo9Euz1iAyawPYYFUpC2qL0a6sjqePEzKgCDVAAt2KV/
PlJHIB32Bkfp2MM9DeR7JIthSqbUPfZhYu50zjPZ/PGWwmdq2eGmXADaQ3dth9ys
sqmemgjwMtW6HzQBZ7BhIsXy0vmzzJ5wyK3NLEVi+p5xGHSmNkck5FfC0ikT/M/V
KwXMbYtv/n1WDSaB/Y34
=6J/+
-----END PGP SIGNATURE-----

--=-ykBOYMVN5llVr30ZMuxV--

