Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51160 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbXJ2QI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 12:08:26 -0400
Subject: Re: iwl3945 lists supported rates backwards
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: dragoran <drago01@gmail.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <1193644281.27622.12.camel@dv> (sfid-20071029_075130_793419_DFA19205)
References: <1192832109.19766.14.camel@dv> <47192F84.1020101@lwfinger.net>
	 <20071020014040.40pq9hqkw0c4owc8@webmail.spamcop.net>
	 <4719BA96.3010609@gmail.com>  <1193644281.27622.12.camel@dv>
	 (sfid-20071029_075130_793419_DFA19205)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sZYMZ1rDMc70V/pO7vvc"
Date: Mon, 29 Oct 2007 15:12:33 +0100
Message-Id: <1193667153.5197.48.camel@johannes.berg> (sfid-20071029_160829_970924_17BA6409)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sZYMZ1rDMc70V/pO7vvc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> With disable_hw_scan=3D1, probe requests have the same problem as the
> association requests, namely they don't have CCK rates in the supported
> rates:

This is because mac80211 uses the order in which the rates are
registered, and with iwlwifi that is "OFDM, CCK". See
iwl_init_hw_rates() and iwl_init_geos().

I can't find any ordering requirement in the 802.11 documents but I
suppose the lower rates should be in the supported rates (rather than
the extended) element.

I'll keep this in mind for the pending redesign of the rate/mode
registration code; for now I suggest to change the registration order to
be "CCK, OFDM" in the driver, since there are only four CCK rates this
will work even with old APs that don't parse the "extended supported
rates" element.

All other drivers in wireless-2.6#everything behave that way, i.e. they
register CCK rates first and then OFDM rates, thus they can never run
into this problem; this explains why it works for Larry with b43.

dragoran: reproducing with a new AP will be futile since it will parse
the extended supported rates element even in backwards B compatible
mode, to reproduce you need, as far as I understand this problem, an AP
that doesn't understand that element yet.

johannes

--=-sZYMZ1rDMc70V/pO7vvc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyXqT6Vg1VMiehFYAQJLjA/9EdyakQpksKAAulVitzWUjvFbAoySKZ17
q07+hchhZJ8xCx6nE/Zs6n3JV5BonuP+cBvha7Z/lntOxb111BYKEjawodYV7vR2
PlNy8a2ogQRxYXzkrgWSesMxMazs/qYCuQz7IIrQqUwhjpIk6THUKTITFyq68a5n
cqJ+LSxm2xkxrF6B0tqfTFe6SCuz+8tbydEIVfi05/hztcRv+d0b4qn1axCjaAcF
qJ2rNa7677baAzgHmLkXtOZ/NJ5b9hTqx2ossmtOrhCUunI7IjUCD/Pk3WhqsQ5N
Vvsv6Si0xG6SFKb20IAdb4m5nHQCjSv0UARVGOwAlk/kZPvDJLO4jI0g5CWA9aIg
AmBaue15GKEnyrcMG7Hq3UYL2UZ1NJTXdJa7N61lxIobAVnMDQVmIAyNvN43SK5J
MJctXlRYk4X0Vp3YEA18sgHihAtJ9KskRtBAiq0Uj659el25L9f9PtPfREljehSa
Isue2yrDBgxon2keSNOx8SdmMRls96hgr29oWGMbFukqErgiTq7obcBr59fuvmUv
+dlWYbSnXrUh1dWXvxQeFXrh43kJTh9fmv2SyoV4mAvVdcoInDAgDc1wUOA17HOJ
xMw1gMOEHLgTxxpvWBxQa8/gpbAzLooZiPZmBkzBhILSXConbXml2YnqyR3MsE7v
ul3uUIbObRc=
=Zr6x
-----END PGP SIGNATURE-----

--=-sZYMZ1rDMc70V/pO7vvc--

