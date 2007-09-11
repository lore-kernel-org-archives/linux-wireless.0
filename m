Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58099 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761753AbXIKKQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 06:16:14 -0400
Subject: Re: zd-mac80211: Fix TX status reports.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240709102050l75402df4w19ef746d6243dbab@mail.gmail.com>
References: <200709082341.31720.mb@bu3sch.de>
	 <200709091259.00237.mb@bu3sch.de> <1189421542.4506.46.camel@johannes.berg>
	 <200709101258.39619.mb@bu3sch.de> <1189422611.4506.58.camel@johannes.berg>
	 <1ba2fa240709102050l75402df4w19ef746d6243dbab@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vJFvsy4sHij6zsf58sdH"
Date: Tue, 11 Sep 2007 12:17:01 +0200
Message-Id: <1189505821.6161.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vJFvsy4sHij6zsf58sdH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-11 at 06:50 +0300, Tomas Winkler wrote:

> Receiving all ACKs packets will degraded performance greatly for sure,
> even on PCI interface.

Well, b43 gives you another way to get transmit status indication, you
don't have to receive ACKs

> Receving ACK can maybe allowed selectively only for management packets
> including EAPOLS in some synchronous way, yet this is still error
> prone.

Yeah that's the thing...

> It looks strange to me that there is no other HW mechanism that does that=
?
> Is this driver reverse engineered?

Sort of, from the driver they had published.

> However I liked the idea about
>=20
> "An alternative option could be that the mac80211 stack would call
> a non-atomic function of the driver to report the total count of
> transmitted packets and the number of successful transmissions."
>=20
> This mechanism will help us to implement aggregation rate scaling
> I would actually prefer if such statistics will be pushed by driver
> rather then pulled by mac though.

It doesn't help knowing whether the relevant packets were acked though.

johannes

--=-vJFvsy4sHij6zsf58sdH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5msd/ETPhpq3jKURAq5sAKCUZ+4y/3Qtx1DQvOSmJVh6DDdh0ACfVdoo
WkP9suZ4L0oEiCU1P0xpII8=
=ee2r
-----END PGP SIGNATURE-----

--=-vJFvsy4sHij6zsf58sdH--

