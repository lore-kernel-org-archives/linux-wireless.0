Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbYLHX1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 18:27:14 -0500
Subject: Re: Userspace tools: Roadmap?
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan E <trg_info@mailhaven.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1228778295.10662.1288975589@webmail.messagingengine.com>
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>
	 <1228778295.10662.1288975589@webmail.messagingengine.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aiUH+MisgN2S4BFtM3Ov"
Date: Tue, 09 Dec 2008 00:26:41 +0100
Message-Id: <1228778801.22164.156.camel@johannes.berg> (sfid-20081209_002718_557906_B78690DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aiUH+MisgN2S4BFtM3Ov
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-08 at 18:18 -0500, Dan E wrote:

> > > Userspace tools.  I want to proceed as if Wireless Extensions never
> > > existed.  Is that even possible?
> >=20
> > No, it's not.
>=20
> My fault for assuming too much about the urgency to get away from WE.

Well, nobody seems to really want to work on replacing already working
features... I have a patch for scanning with iw though.

> > Yes, it should, and nl80211 even supports it, but iw itself doesn't yet=
.
> > That's fairly easy to fix, too, but then iw won't support actually
> > telling mac80211 to scan and associate etc.
>=20
> Right.  I had a few early problems with iw.  For instance, the Linux
> Wireless web pages say you need "at least" libnl-1.0-pre8, but it won't
> build with libnl-1.2 or 2.0.  I had to go with libnl-1.1 to make it
> happy.  iw seems to be like a redheaded stepchild.

There's libnl 1.2 and 2.0? That's news to me! Patches welcome. Sorry, I
guess it needs 1.0 or 1.1, will fix the page.

> That's what I thought but I wasn't seeing any callbacks at all through
> my ieee80211_ops pointers.  I did see the channel frequency change with
> 'iwconfig wlan0', but no callbacks.  My fault, again, for not RTFM.  I
> haven't gotten to the point yet on my driver where I expect 'ip link set
> up dev wlan0' (or 'ifconfig wlan0 up', if you prefer) and now I see
> that's why the config callback never happened. =20

Ah. Yes, if the hw isn't started mac80211 won't try to configure it :)

> If I had RTFM I might
> have noticed adding 'commit' at the end of the iwconfig command would
> have done it without the 'up'.

No, it wouldn't, commit is pointless, don't worry about it, you'll never
need to use it with mac80211.

johannes

--=-aiUH+MisgN2S4BFtM3Ov
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPa0tAAoJEKVg1VMiehFYfz8P/iJAcBVXjITHYRC8eBVnA5Uf
mo/ahrezu+NMrc7O/Yy4fXHycU1xtmrr4vbk9wtLy1Hu1YCBPhgkmS1oD6WTjXmg
m9QXZli71rILw3ccQiHC9OwOR7bctqR12QwKneKM8kLkmm5yLmBvF5le3MLqQ8jw
zY1actzMnL6zXDgoo2WF7blTAxgmrLtdvhVqFuFvNr6KuhcURujnoD8TxAZTrhyn
6tnnvHjcU5P5tASbcUMO5bt+q2YWiRcifme0cYsB9owxkiWrZU93L/XIZbILQZkV
sAafTk7DMC3CLrIgWW7mG6DWymAClMNpzZ/i5NwtwzZO60mnYL3HJgpM7LrDS/sq
IDxEFgGGwkDBPKYFnc6xvH/NK71e6ee3Q8AWBCY7yxmat5+Www2bb5lXX7Orjwzs
YW06u7FJzQhnN1e622IAvfZqr0ykEglg9zTpDL5AdKRA43AAY/YT361fPKhXMZl1
QQLeEPprcllW93dNwxjF1jZQbQjlAv426ab7T6wY3n/nYtYVoxH5CcKbzwEDYFVB
4TXnvZ/9QXWkEBjVq8WclNiPG337L2aWyfd7asXroei4bk+6QmUH2RaGrfMq6gZD
sgmVRFghJ7s/THAq92iJaUsGkFdvHW7SESzUWAPgQohxHj9UnFmY2WgBp8vxO09v
9noPqKrF9+WwZSOe+Q/6
=B1gg
-----END PGP SIGNATURE-----

--=-aiUH+MisgN2S4BFtM3Ov--

