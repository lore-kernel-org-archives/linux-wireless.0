Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbXLDQ74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 11:59:56 -0500
Subject: Re: questions regarding removing the depencency on CONFIG_IEEE80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1196782188.26155.49.camel@localhost.localdomain> (sfid-20071204_153556_825699_9BDA6661)
References: <200712041140.07516.hs4233@mail.mn-solutions.de>
	 <200712041153.24896.hs4233@mail.mn-solutions.de>
	 <1196780198.26155.17.camel@localhost.localdomain>
	 <20071204152538.GF19911@tuxdriver.com>
	 <1196782188.26155.49.camel@localhost.localdomain>
	 (sfid-20071204_153556_825699_9BDA6661)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JdKK4mwHU4+JpSbJJouj"
Date: Tue, 04 Dec 2007 17:59:28 +0100
Message-Id: <1196787568.10274.26.camel@johannes.berg> (sfid-20071204_165958_628360_236F9D34)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JdKK4mwHU4+JpSbJJouj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I was thinking about lib80211 this morning too; specifically the code
> that everyone has to write to convert local BSS entries into WEXT scan
> results.  The problem is that drivers have different ideas of what a BSS
> is.  I think the _first_ thing to do is to define a BSS structure (I
> used the ipw2x00 bss structure in libertas when doing this) that all the
> fullmac drivers can use (airo, atmel, libertas, orinoco, etc).  Then,
> each driver can fill out that structure from it's internal scan result,
> and hand that off to the lib80211 bss list handling code.  We could have
> a help that these driver's get_scan calls to convert the internal list
> into WEXT scan results.  The important thing is getting these drivers to
> fill out the common bss structure when their firmware returns a scan
> result.  We could even make the lib80211 code handle scan result aging
> internally.  Could have helper functions to allocate and dispose of the
> bss list instead of having to duplicate that code in every driver (it's
> already in airo & libertas, and I posted a patch that dupes it again for
> orinoco).

Sounds good though I think this in particular is cfg80211 functionality
because over time that will want to export scan results via nl80211 too.

johannes

--=-JdKK4mwHU4+JpSbJJouj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1WHb6Vg1VMiehFYAQLZpQ/+K0uXGWNSjX7vJyQ/venjiQQOicNjSrBN
Nu3FMWGcL4c+GQE6mftbtGJA/8IR6rVvETtTW/G9AD4NY/tBk3ihsyUPYw0WfsEh
bQHyKXSHreXaMwChTq8PHSDWnD6rIy9ZMSMRlIg5HNCTd30K7SiC5GzJPLFF6UEv
8NwQo+VpOuh7PTAN4sXKlO98O6IOTHvRqJJuSTjo8Td93Nuado/qCrGEmXv/KW10
rYygngCF5D4bp/cqlRGLZzFY6yKn1SMCJh+HYkl/Co1iO23thFttYnwH4JEouHCv
yAFaDbUJLHCP5n/d2mAQLuLR4xpm6atBbic1nCo68+w11oA/WVqRW0FQB1l1/AeZ
9BWKGIkk5SXtCrdlZvxJqeLoDN1veJdDOXEUUwceRs3NC2Q8+WLLxus2ygqrAJb9
JPrINKnjzcpgNnF3iSm3KdXbsOrFrUpptueLOqddkzUshVyKBFeD9Xd99J+lnkHS
xkvFV9O4BZpMcrjst0xv2goewMa8In8twwe8IjsTVQHUddXura6wbgHUz6//I+g3
B6QxohiUWMB59pz58MG4Ok+oqjsTuVuUIVSew8CGPbno3/18pUtjrTL63aOBE390
NrzeACSLYLBAGVgEE0m6yeeiPzsdaCedVjFMH94oYBJOwQ/gCaCbHdL/rfrsejYs
aEZX80a9Fic=
=2aA8
-----END PGP SIGNATURE-----

--=-JdKK4mwHU4+JpSbJJouj--

