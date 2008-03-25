Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48624 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbYCYPje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 11:39:34 -0400
Subject: Re: IBSS RTNL assertion
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1ba2fa240803250241q7a1e9f4eta9565371d83772c9@mail.gmail.com> (sfid-20080325_094116_014823_D34D3F40)
References: <1ba2fa240803240921h44321705s923ecac89427196e@mail.gmail.com>
	 <1ba2fa240803250241q7a1e9f4eta9565371d83772c9@mail.gmail.com>
	 (sfid-20080325_094116_014823_D34D3F40)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YkVdKq12iNY6s2Sz7piw"
Date: Tue, 25 Mar 2008 16:39:31 +0100
Message-Id: <1206459571.16475.289.camel@johannes.berg> (sfid-20080325_153937_280492_4CFDCD05)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YkVdKq12iNY6s2Sz7piw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Looks like there is number of places in the code where
> sta_info_destroy(sta); is not called under rtnl_lock nether under rcu
> lock...

sta_info_destroy() may not be called under RCU lock. I'll take a look at
this, it seems simply a missing rtnl_lock() in some of the IBSS code.
IBSS is a bit of a special case unfortunately.

johannes

--=-YkVdKq12iNY6s2Sz7piw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+kcsqVg1VMiehFYAQKQ5xAAjGlOWpNRpq3haGDUc2lLFuQE/rYmra0q
No/jXFpFsDUnl56BzQwy4KHnno3S43M34MoRRVPCU8qArmM6GdpnRAK2AtS4kbzZ
SvGK9FmVukTf1Dp/AOpYTmcFtJuEBkrx8zJ04A+M6KdtuPwmGOlB4BritPbm8E4u
A/9Lfl48Tnyr54FZCTjgXqulz+M5i+qirhfRq7mjueoqmSBYdifKhMwo5bKNPCVy
JfCS4lGX9cJrxEKawzmDQXJDoWsI7KLy8PzIfHPY5w+G2EvTlXnmS+7ARADPlUQ6
N6/b4J7euoyplgt4uOnHH71zDWFgq3d8qBsh4bGGxmLhJ8vKDCDzTDc05uC3A49j
3yrBIYSpmQ1QWBhKCp+L15vkEJNQPpUCq4cg7zlFQXYb7OhGMFlmPzlgUlX3hkPJ
Ncg6YvGvpcR4mKvnYk+O2cq3WgTePQHJvA5S4V3vDWSS/j3oLCCuJPTmHSlbepkX
+bhS7uebGSvC7KIQtZsMVox8Stmyls02doD3yIxOi5PctYVyWPEHOy8GMXt3wo4j
0xySnVeFuqstUsLZDakcjZl3v+nfzpYDFIg/fa6iNWzra8x3drbtn1+4MMK8Ph3f
JtQP3PrkHja5f5tQdIMKwDBg+bKoU2Y7Ag3feSPNg1ihDE8xt3RIuP1MBqEP4ia5
DrE2opGitl0=
=g8fe
-----END PGP SIGNATURE-----

--=-YkVdKq12iNY6s2Sz7piw--

