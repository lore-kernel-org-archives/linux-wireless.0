Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55761 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXI1QVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 12:21:32 -0400
Subject: prism2 "next mode" and its implications
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-V2r8PLHAe5yi76AF6qTE"
Date: Fri, 28 Sep 2007 18:22:51 +0200
Message-Id: <1190996571.22960.12.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V2r8PLHAe5yi76AF6qTE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

Just was discussing this with Luis as he's implementing all the new
regulatory stuff.

We used to have a prism2 ioctl to set "next mode" for channel selection
so that when selecting a channel you'd be able to select, say, channel 5
(freq 2412 MHz) on B mode.

Then, when thinking about nl80211, I figured that any "set channel"
command/attribute should go along with a "mode" attribute so we can
distinguish this.

Now, however, I'm no longer convinced this is the right thing to do. If
we're a station, then the supported bitrates are determined by the
hardware and the AP anyway. And if we're an AP, wouldn't it make more
sense to set the bitrates explicitly? We already need to set the basic
rates anyway, and we also already set the slot timing, so I don't see
what setting the mode buys us.

johannes

--=-V2r8PLHAe5yi76AF6qTE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG/Spb/ETPhpq3jKURAueWAJ9Zi4vfzpW+G6/1vsUXm0pzJKTFkgCgoadZ
P99w03bkr8m0S3aHu5ZSw18=
=821F
-----END PGP SIGNATURE-----

--=-V2r8PLHAe5yi76AF6qTE--

