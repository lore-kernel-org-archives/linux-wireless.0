Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403AbYARMii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 07:38:38 -0500
Subject: Re: led support in mac80211 and drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tomas Carnecky <tom@dbservice.com>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240801170840i10c6bc9fp24eebbe1110df93@mail.gmail.com> (sfid-20080117_165305_003743_0FF9C237)
References: <478DF297.9020904@dbservice.com>
	 <1ba2fa240801160832g611d5763gcb3d681353019d4f@mail.gmail.com>
	 <478E465A.2030003@dbservice.com>
	 <1ba2fa240801161038t235f9ae4m3b1f7e1963b592ef@mail.gmail.com>
	 <20080116200126.GA3164@tuxdriver.com>
	 <1200584782.8007.59.camel@johannes.berg>
	 <1ba2fa240801170840i10c6bc9fp24eebbe1110df93@mail.gmail.com>
	 (sfid-20080117_165305_003743_0FF9C237)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aIXi1pV/E6Pj9CPTN3kW"
Date: Fri, 18 Jan 2008 02:01:08 +0100
Message-Id: <1200618068.5716.22.camel@johannes.berg> (sfid-20080118_123842_594719_09298D9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aIXi1pV/E6Pj9CPTN3kW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> What we do is translate throughputs  - to  8 patterns if I remember corre=
ctly.
> Only when the throughput  cross threshold level NIC is disturbed with
> changing blinking pattern.

Huh ok. I suppose you want a throughput notification from mac80211 for
that. And you want to define blinking within the LED framework, rather
than just intensity.

> Not for traffic but for example some laptops vendors wants slow blink
> in unassociated state some wants led to be off.
>=20
> The problem is that led behavior in clean design would be defined by
> trigger. So I would prefer to put flexibility of LED behavior in that
> level.

I'm not so sure. I think it'd make more sense to define state triggers
(associated) and do whatever behaviour based on the state. Dunno.

> Most of todays laptop has only one led for Wifi that's a problem.

> I agree it  has a lot of benefits to use LED framework, but it can be
> pushed to driver or some module. Unfortunately I'm not sure myself

Maybe an intermediate level in the LED framework could be written,
something that itself has multiple LED "inputs" (LED devices) and takes
multiple triggers, translating it into a new trigger that the single
laptop wifi LED can be bound to. Sounds like too much complexity
though...

I don't really care much, but I definitely don't want to add new
callbacks for LEDs to mac80211. If you need something special please do
it within the LED framework.

johannes

--=-aIXi1pV/E6Pj9CPTN3kW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4/6U6Vg1VMiehFYAQIm3w/+PeKGs0VB6E7qgsnvYBjYq+uHkcud83ph
aByc5R8VcalrGBBBfTtoAb2xa5hV5mu69YO4HtzHanDhluoLywpb2jE2p3KTKLWR
/vy69N9s9mlXbtjeIWrIyui03Sqwg9+bVvsL4pUmw4JRq2vDUp/2ZypUwmi6WbHk
h0MczcCYONGQnMq4Fo3Z+u4ZDWsPw170UQukvGmztBdVPS9IKqFDIKePHAq4K8KG
/sNp9co53Pg/szhsIjIS6+ByoJysyBBGhm3dWoYo7PT+jD62yeeA2sJeVw3kLQaW
m2MEASk3PkBthR0xY/jda9EODFTb0g+dR9J4+0A13E1nlMkmzzf5TyQJ+RjqHgYG
zkJkuJwWBami4QUA3S5tzdtWPoRmAGWZ0yBMTRFnULrkvC3FlSvnZ3igfnFD+B8k
HsRqFx5lOKUDbMaeiHfLWeyRt66QE2x2H/w8chUh60oIUEWfTqM3wXvQaPnqF3VR
xklk5SIqmNfW0DWKXVtUDwCMrQTLNoTHo1MxARc1DcQzhggcX6IBwpR6mkF7XIhC
Y/VAZl/cCroDXjWOljuAhlPxaS5bYSKSt3p8KuYfQ/qIt/NX5fHjLVKxNHwISFhn
RI1uLVNSFsdxy5jFaafsALypiyreUlEnMDPAo+IgBqi/qX6YnQBMkqv3fEPVfo2e
mgJpBWycGSY=
=KYFf
-----END PGP SIGNATURE-----

--=-aIXi1pV/E6Pj9CPTN3kW--

