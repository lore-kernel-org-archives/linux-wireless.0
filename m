Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbXIKK2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 06:28:30 -0400
Subject: Re: zd-mac80211: Fix TX status reports.
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200709111220.31700.mb@bu3sch.de>
References: <200709082341.31720.mb@bu3sch.de>
	 <1ba2fa240709102050l75402df4w19ef746d6243dbab@mail.gmail.com>
	 <1189505821.6161.1.camel@johannes.berg>  <200709111220.31700.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lLN7ebcHYe2KjyCY64Ja"
Date: Tue, 11 Sep 2007 12:29:56 +0200
Message-Id: <1189506596.6161.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lLN7ebcHYe2KjyCY64Ja
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-11 at 12:20 +0200, Michael Buesch wrote:

> What about the following:
> We have a "the packet failed" IRQ. so we know that if that didn't
> raise for a packet, it must have succeed.
> So currently we already maintain a queue of TX packets. What about
> changing the handling of this queue? Instead of dropping (and
> telling mac80211 success) on an ACK RX, simply do a timeout.
> We can calculate the time (plus some additional msecs to be sure)
> by when an ACK must have arrived, no?=20

That's tricky though, because multiple retry rates mean that it can
possibly take quite a while for the packet to go through. And ath5k
wants to support up to 7 different rates for each packet.

> So, if that times out,
> signal a success. Wouldn't that be reliable? Given that the "tx failed"
> IRQ actually _is_ reliable.

Yeah, and in-order would have to be guaranteed as well so we can match
which packet failed and assume all previous ones were OK.

johannes

--=-lLN7ebcHYe2KjyCY64Ja
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5m4k/ETPhpq3jKURArJEAJwJdy47X03Rs6GITnwgWQvL8x/cRwCgk/op
0SBFRzdHdkhFKAPrQM9bzQ4=
=bHY2
-----END PGP SIGNATURE-----

--=-lLN7ebcHYe2KjyCY64Ja--

