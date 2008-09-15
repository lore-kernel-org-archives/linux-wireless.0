Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46233 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbYIOTrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 15:47:23 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221507551.4511.89.camel@localhost> (sfid-20080915_213946_840165_74EE062B)
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <200809151911.32834.IvDoorn@gmail.com> <1221501417.4511.49.camel@localhost>
	 (sfid-20080915_195731_733752_74D2117C)  <1221501786.3700.68.camel@johannes.berg>
	 <1221505251.4511.77.camel@localhost>
	 (sfid-20080915_210128_632488_FB448E33)  <1221506496.3700.81.camel@johannes.berg>
	 <1221507551.4511.89.camel@localhost> (sfid-20080915_213946_840165_74EE062B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gebR43x3E9L61aABVdLe"
Date: Mon, 15 Sep 2008 21:46:28 +0200
Message-Id: <1221507988.3700.84.camel@johannes.berg> (sfid-20080915_214729_424968_E5FAF927)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gebR43x3E9L61aABVdLe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-15 at 21:39 +0200, Mattias Nissler wrote:

> > Yes, but we could also make the ack queue processing part of mac80211,
> > i.e. we stick the packet on the queue before ->tx() and add a few new
> > flags to the status callback which can then process the queue.
>=20
> Just to get this straight: By queue you mean the to-be-introduced
> unknown status queue?

Yes.

> Of course you can do it that way, but then you'll have all the flags and
> data structures built into mac80211 unconditionally instead of letting
> the driver developer decide.

Oh, I'm fine with building them in there as long as the code paths
aren't actually used for drivers that don't need them. This isn't a big
thing.

> > > Good point :-) So I suggest we have one function that adds new packet=
s
> > > to the ACK queue (which is represented by a struct an instance of whi=
ch
> > > a driver can keep in its queue information) and another one that matc=
hes
> > > a received ACK with the queue, reports the status to mac80211 and pur=
ges
> > > the queue entries up to the match (reporting them as failed).
> >=20
> > can we stop talking about "ACK queue"? It really is a "unknown status
> > queue" or something like that.
>=20
> Ok, I don't really care how it's called as long as the one writing that
> stuff chooses an appropriate name in the code :-)

:)
But ACK is getting confusing, we're just reporting status based on
reception (or non-reception!) of ACKs :) How about retries in the hw?

johannes

--=-gebR43x3E9L61aABVdLe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIzruQAAoJEKVg1VMiehFYNsEQALxO3vs0GzCQ2cPGZWAYS/no
VhUtPPZCS6v0sM533MZ9Naz0qONap7lgysRcK788UnzIO8U4LXweI3Zd+LN/kLWf
0iUpo8aNiq4czGaTcw9u1DG2bSGxEOWVSkPrQZXaheiRy26MHVhhrhL+xDJ63RB9
GbgKtjapQukAPjK/jO6NPSDK4Cxp0CJyWEYBW4MBL42tJYQXzio0Sl9uy5BbGGqU
ey+3G4+1rEzudbUEYslwdZDUZAfE5cqvuaVkF2/QVyl1dYI/LTmoYRhwQM12QyOA
cZYxa7qMorwvAqh7/WX2exCtLQTlGMSGOZ/ecV75j60bTQfXQu8qQQ3+uw71uota
t3IWAkHDePqBjTNR5eImFCgOUIzTGizJ3/bF7Z+STqhxLjc8Uua9JQbiTTfDsTrX
SqTLNxSdsmVxjMgKUTJvPHXYBAaTKHjVJ9rR6FCB++t6BkRdjLayF/GNc5k4Tf7g
YDqW+NtBB+jRB9gEFKCgEZn+VxtuP/a4DRh5znERuVGo54M5EFzWSWqAjs8ud0mX
gpr/rgcrV8KI7n2kDB72LUYCUicSDnDM6MT12dtoMmCWJBiKaqnePumSMmOkXH6u
7jApE2A0531WBaRw+RK7iEdf1liMAPmfCaCiiTBjypmRaCVqqcxc3XYqQ5rsWsPP
nhsfOeToVjNmuGeEh3eg
=SrVu
-----END PGP SIGNATURE-----

--=-gebR43x3E9L61aABVdLe--

