Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758330AbZDGTib (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 15:38:31 -0400
Subject: Re: mac80211: changing number of queues in ops->start
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200904072133.21296.mb@bu3sch.de>
References: <200904072024.41910.mb@bu3sch.de>
	 <1239132567.7187.1.camel@johannes.local>  <200904072133.21296.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JWQyr7REuQd/6TQg3mfo"
Date: Tue, 07 Apr 2009 21:37:58 +0200
Message-Id: <1239133078.7187.3.camel@johannes.local> (sfid-20090407_213850_057838_35001BE1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JWQyr7REuQd/6TQg3mfo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 21:33 +0200, Michael Buesch wrote:

> > Well, I suppose you could register with the max and later reduce and
> > stop the remaining queues you're not using... Or not stop them and drop
> > packets on them. That's somewhat fragile, gives people who look at tc a
> > wrong idea, and I can't imagine supporting it, but it should work.
>=20
> mkay, I'll try this. thanks :)
>=20
> I wonder, however, will mac80211 try to queue packets on queues that are =
stopped?
> And I think just dropping them is not an option, because this will cause =
breakage.
>=20
> What about just queueing everything on a single queue, no matter what que=
ue mac80211
> puts the frame into? Would this cause ordering issues?
> Or the other way around, is there anything that _depends_ on the higher p=
riority queues
> to get sent before the higher priority queues?

mac80211 won't try to select a queue higher than hw->queues at
select_queue time, so it shouldn't try to put packets onto that queue,
look in wme.c.

johannes

--=-JWQyr7REuQd/6TQg3mfo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ26uUAAoJEKVg1VMiehFY6TEP/3m5mLIzuDJYEAVA/w+ypPgw
+5naB7HN6dTv2NWvjTfb9O28FcobUkKdDYxHfN2nXMcHsfPO6haWiSUb33mDakia
z4jH72Ir8il0fqs0B8vFwkyWrF/jzfCUmvks9sfufB7B9iQYA6P3XllqyXv3CtaN
y88h/3M+2kk6ujsoicHS8EDmkghV2sFqs+81um2R5/vJZfmFTw5T9NEvOXR0Rert
D6qce+KD3QZgYAChNUfv2IT0Xk3vTv9BdT/dTUIDygGi91xArEdEjz1SmD0hRK7j
uo3rFyHJwuEQeZVTvj01gU7qrv7yUgUAfv++tFXj5CtOcMM1C4mK9nc8J9wK1EcJ
ipk2qxaJEn2LAZrHUyJE6MCJyT3qPP+oP1RZ6UQJAF+a528SlT1huk3sdOZNJKrD
WAUCFfS889KPxMbsCHNtcJqye+7tMv3MXihlImTVkwwMJXpjNO4/6WyXjROI9tsE
WZTdeyTDS3tRc0Mc/H1lwZh/DQKusTi/3opAhSHtmbjWT0aUUXdJCcIoA8aAKUk2
2p1TvzJWh/0JlY4omOjnRd1QJ348B42RzoUqfq4p1XOCmeaxxgAETtUnar3ZtqRi
9E3w5mPbORWAK4xRvLufaayT2ywYf1ueIwPTZLCptZ5aSdFt+bvld8QM513zepbp
8TrXrvviP5DGhEgPOy/z
=+eFe
-----END PGP SIGNATURE-----

--=-JWQyr7REuQd/6TQg3mfo--

