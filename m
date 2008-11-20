Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbYKTT3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 14:29:25 -0500
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Steuerwald <salsasepp@googlemail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <f76a32050811201121r27ba1d82ma788e5a55bfd422b@mail.gmail.com> (sfid-20081120_202146_459597_36951BC6)
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <f76a32050811200050u48bc150en34e94c7671672ae6@mail.gmail.com>
	 <f76a32050811200544p3c647cb3t392025feef02c8f9@mail.gmail.com>
	 <200811201537.19047.hs4233@mail.mn-solutions.de>
	 <f76a32050811201121r27ba1d82ma788e5a55bfd422b@mail.gmail.com>
	 (sfid-20081120_202146_459597_36951BC6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mbgJ1vnYk9edZD7i579O"
Date: Thu, 20 Nov 2008 20:29:20 +0100
Message-Id: <1227209360.3766.42.camel@johannes.berg> (sfid-20081120_202928_923853_0C4EBF82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mbgJ1vnYk9edZD7i579O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-20 at 20:21 +0100, Stefan Steuerwald wrote:
> Now I'm learning something! Seems like Johannes' initial question
> about powersaving might have been right on the mark, and Holger's
> explanation set that straight in my brain. Thank you for that!

:)

> I have attached some traces. Connected my iPod to the XG-601 AP and to
> my fritzbox 7170.
> I'm not sure about the interpretation of the beacon flags, but I never
> see beacon flags other than 0x0, does that mean the AP is saying "stay
> awake, no sleeping" to the client?

beacon flags are useless, APs are always awake. No, the AP isn't saying
that to the clients, it's saying that about itself :)

> The iPod alternates Null Functions with the PWR MGT bit on and off -
> whatever that means. Is it ignoring the AP and snoring away?

See above :)

> @Johannes:
> I was not able to find any indicated traffic in any of the beacon TIMs.

Indeed. But did the problem happen during the trace here? It looks like
there is no traffic for the ipod between it going to sleep and waking up
again at all, should there be? If there should be, then there's
definitely a bug in p54/mac80211 somewhere. However, I can't find
anything in the other dumps either, so it seems like there was no
traffic.

Can you try a better test:

(1) start monitoring
(2) connect your ipod to the AP
(3) add the ipod's MAC address to arp (arp -i wlan0 -s 123.456.789.000 gg:j=
j:kk:ll:mm:nn)
(3) ping it from the network so that it'll be asleep and need to be
    woken

johannes

--=-mbgJ1vnYk9edZD7i579O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJbqMAAoJEKVg1VMiehFYkrMP/i4fP2qSHGTDrh8SFP84bFIJ
CfKZ9gURRNLeuVUJsRlwkT91tIhLMZlIPtpmqMygl6n8nkj0ZT/qYiAC2D1DDpz4
HvwXqtEfDMJ3zoj/Ol4X0J1NToiPvaqI6QB7xDHOYLjzJpHrkkl4LIQTr8iBELkl
TosgcuqXSt4d4kTpLBjJ7IstbJnKPFWFvTrEeD1YoJw7Bh54mLdqMWdFCC1Mhpnm
euBCJmH95vp6qetbiNNEaKq8FAmViwEkznfRUjw9yKwGnpvfY7nMTXOsvgpHchhw
tos2LkP5Qy1wQAg2xIsW4CbfMWp4RNN07+V/c+4i3Jmxl3JjY/jCU55ySYiChlfT
Rq0g1CoQVOPsK4f0o2zB03eC4oIG+qZ1OlBtNdAzUWo/sByP1ocw/f72P1QN6pvO
PdHt+q4yh+9nt4TROQVdz8hqfVtwbN+236/+qeOGnyN5K7m/R/oo44VcF7+r8fnY
/tqNt0ssp0YBSN2Yd+NBMnqmpIR3npOWqY8apmPpACmaatv9XLmwGAk38KDVZ+8c
546H4cJCuozTVNzbyJOJdTcRdlw3+5BB+6Pm1qOkubakNFoSPLuAsK3lL8bVBgTZ
QfAU1S5L4xhdYgKoHoItEQhWIDTn2cwt4rFCYabhioD5uwvuJOEwBNJ7zyezFqCk
WtzkpIBlzKqjaFLCiLSn
=3LSU
-----END PGP SIGNATURE-----

--=-mbgJ1vnYk9edZD7i579O--

