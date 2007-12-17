Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbXLQRqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 12:46:37 -0500
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
	default
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071217012550.213561122@gmx.de>> (sfid-20071217_012738_361990_F4488E8A)
References: <20071217012517.882216322@gmx.de> >
	  <20071217012550.213561122@gmx.de>> (sfid-20071217_012738_361990_F4488E8A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S42x8WIXDFNrBMssxtXG"
Date: Mon, 17 Dec 2007 12:52:42 +0100
Message-Id: <1197892362.4885.23.camel@johannes.berg> (sfid-20071217_174641_935501_302300B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S42x8WIXDFNrBMssxtXG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +config MAC80211_RCSIMPLE
> +	bool "'simple' rate control algorithm (DEPRECATED)"
> +	default n
> +	depends on MAC80211
> +	---help---

I'm pretty sure just "help" is preferred style these days.

And I already said that I'd rather see a single patch that replaces
_SIMPLE with _PID.

I'd split up the patch series as follows:
 1) API cleanup, including all rate control algorithms
 2) PID replace SIMPLE
 3..N) PID improvements

Although since this is all new code 2..N should probably be collapsed
into a single patch.

johannes

--=-S42x8WIXDFNrBMssxtXG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2ZjCKVg1VMiehFYAQIRhA/+IuLqPU0d67LwRFk4e52XBYAgr6KNbTeF
AhHBN1zTcdVG1U5pPOmENPIRLRlJgzOH2xWMNNo6OUqH1as8hqWEXyHxu2G40KO6
sKvukBvuo9jzMPhVK+6GOrJ1lRj+HUhTgaSc1TK9+4m5ECWf25Y10iBdzkuQLRPA
m3KabhfwzKOoBVNk+wYmAFBqoFLqI3L9AlELX+wXpfF/F0nCiqIAw8nri2w9BYX8
quTUbMtT5ulCRosGc5Fn1XaznfwnGzzgDYBJuVbQ0NJTS4pt2Xtju+oRh6ChUphl
e7spkJv4yRkFiqKKgWJ5FFWgQFVsxfznAcHK/1QA73ggcYvDDBW/W4n00L9EjrXh
dvdaIqhcPREJaV3vFefMCkigiJjMOOGQEMIOpmc3jTxS1iXkXLTSEwXM2EKgThnH
cffHt/0TmB7e6LlyaoiuvPrT8YZgT0r1hSl6v1RRhPwV94Ih0r2KPgaK63eqNUKi
00RyGjdtgjosdWVcVg5liy0DrPbi1QPlsOPTDxaAZLsoluPP1deg+bqrj78+yMBX
3fBnzq7AWEj9eJmv0n1eCSEHsv8y3OXcfNrsAYojuQ9wNswGbOSPoZK3kRyzyP2i
YxS1FGsRXR02QvcsNUWRM+4QWzzK9YlQFLhrULVvhjdkCWdFLtNKZGUxds7w1Fn9
tDr2z+Y+3Fs=
=Aggv
-----END PGP SIGNATURE-----

--=-S42x8WIXDFNrBMssxtXG--

