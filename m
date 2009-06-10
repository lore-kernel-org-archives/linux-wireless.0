Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54575 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759112AbZFJPta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 11:49:30 -0400
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910906100822q6eae8b29p2381220b23b4f4b1@mail.gmail.com>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com>
	 <f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com>
	 <3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com>
	 <69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com>
	 <3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com>
	 <1244619027.18481.55.camel@johannes.local>
	 <3ace41890906100639gb800904td06d86efef90e656@mail.gmail.com>
	 <69e28c910906100822q6eae8b29p2381220b23b4f4b1@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-A0ag9wgQmS22D0HAVGg6"
Date: Wed, 10 Jun 2009 17:49:28 +0200
Message-Id: <1244648968.4178.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-A0ag9wgQmS22D0HAVGg6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-10 at 17:22 +0200, G=C3=A1bor Stefanik wrote:
> On Wed, Jun 10, 2009 at 3:39 PM, Hin-Tak Leung<hintak.leung@gmail.com> wr=
ote:

> > I was talking about the client suspending/resuming (i.e. the client
> > disappearing).

Which isn't relevant for answering the question why there's no AP mode
in zd1211rw, regardless of whether it has problems or not.

> (Note that I'm also for allowing such "buggy" AP mode on devices
> without a HW multicast buffer, perhaps with hostapd spitting out a
> big, fat warning on startup; but Johannes has the final say in
> mac80211-related questions.)
>=20
> (To Johannes: exactly why is it required for the multicast buffer to
> be in hardware?)

It isn't required, ath5k/9k don't have it there, they have the notorious
"CAB" queue for sending frames directly after the beacon. So does b43,
and probably other designs. The problem really is that powersave mode is
very important for small clients like your mobile phone or digital
camera, or even bluetooth3 device, and not doing multicast buffering
correctly means that either those devices get into weird unreachable
states, or you need to turn off powersaving features on them which makes
the battery drain unbearable.

Now, it may or may not be possible to work around this in software by
sending out the multicast frames on a high-priority queue right after
the beacon, or something like that, but frankly I'm not interested in
working on zd1211rw myself, so that will have to be somebody who is (a)
familiar with 802.11 powersaving and multicast buffering, (b) wants
zd1211rw to work, and finally (c) has a lot of time to play with the
device.

johannes

--=-A0ag9wgQmS22D0HAVGg6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKL9YEAAoJEODzc/N7+QmahxIQAJED5DQwfwuFaPpmoSYtfqLs
C0i34sjR6zlVJYuDryd3UVOc1Vm8AWN4t+9z/b8CKR7zhdQ5f+X+WFqvQzh3TJMW
14B1J/qyVVvOTrtgY2QzsYowRYaLP/7YYfn5vk4pBFDUwu8FLGKSXMXlJ6g5sUJN
0xrBifxBsWJbw0BUwL5S9ClEUEv9gznUizOqgjEhnqj+y2qKId+pYW1prXHfrkVT
EbLRWbF8rYFq4QzuQPhOLO3KlWJrf5y9kTv4ceYt30a724ae2EqvpUhhcwQbxbrP
LAFH6OpUabL0+99EgmVYcjhmaO8ycmJTwLbNGmdvFdXUhg3kVnVom2wATG0Vm6K4
uGorod5DT6s+xNXtQWs2Fm56bIkxS2dYv+J1XQBzvJSkegFMtxybfHq6tkX170k5
/o+xauzdPNqtdslQ2R+svHGRqa06gmhLr0JM+k/l4aCZOiOR8r4oStdJp8TrV8HK
B9kMJeKpJ4DlJsWTReMfs1qQIPBNNDzFek96BaiX9EqUqJVR1sJlc3K62o04ECdK
Cfl2RcJW3ClJHo1at8139xTEgNRl1uuJizTD8t+gM7WJj4c5w7sU1a0Z/Xknet7E
R+IjKMbBEwlI0PqDT0GH0Pu+xEb5KNbqSWSQKdrOAjWUxb7pxQtwtYpNnadbDtbY
tGTRjNSorEkmJv3YV5LD
=+OHa
-----END PGP SIGNATURE-----

--=-A0ag9wgQmS22D0HAVGg6--

