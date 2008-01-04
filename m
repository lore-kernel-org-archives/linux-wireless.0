Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56787 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbYADAer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2008 19:34:47 -0500
Subject: Re: ath5k oops (recent regression, I think)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: bruno randolf <bruno@thinktube.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Andrew Lutomirski <luto@myrealbox.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890801031602q38a8f57fv3ba56a0f44e7e2c6@mail.gmail.com> (sfid-20080104_000230_516005_448F48AB)
References: <cb0375e10712241906u198c695br1e2120e6cfee3b0d@mail.gmail.com>
	 <200712251804.13693.bruno@thinktube.com>
	 <40f31dec0712250623yb2bfeahfa1b7024e1fb67f3@mail.gmail.com>
	 <200712261117.33992.bruno@thinktube.com>
	 <43e72e890801031602q38a8f57fv3ba56a0f44e7e2c6@mail.gmail.com>
	 (sfid-20080104_000230_516005_448F48AB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UtiNZ1Is30lYE4z6SICU"
Date: Fri, 04 Jan 2008 01:34:14 +0100
Message-Id: <1199406854.4172.139.camel@johannes.berg> (sfid-20080104_003454_156111_5C480504)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UtiNZ1Is30lYE4z6SICU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> We use ieee80211_generic_frame_duration() to compute what we believe
> is the ACK timeout and set it on the rate duration registers, and we
> need this value set during reset, as we up the interface. The *real*
> problem here is we need mac80211 to provide an exported routine which
> drivers can use even if they don't have an up'd interface yet IMHO.
> This can be easily fixed by making ieee80211_generic_frame_duration()
> not rely on sdata and letting the user pass manually if short preamble
> is desired in the calculation as an arg. I have to go now but will try
> to address this as soon as I have time unless someone beats me.

That'd be wrong as well because w/o a virtual interface you can't be
associated and hence you have no way of knowing whether the frame
duration should be for short preamble or not.

Besides, the old behaviour was to return 0 from the frame_duration()
function when an invalid interface ID was passed which would always
happen in this function.

I think you need to rethink what this piece of code is trying to
accomplish and fix it accordingly.

johannes

--=-UtiNZ1Is30lYE4z6SICU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR31/BaVg1VMiehFYAQKU1hAAlvUcZ25bAcghantzaMdLKxeBhCPig9ib
28p02ViuApaxUelJrlDH6Kz2gP9O+1LBRk9EEe8Qt0+Ogeom1RiYpmlomvOG9fm4
CTSqV8INnwZCxmdAogPpepEbaZU7mXABMZBGrH5I9dN93F0kXJ+mVgi6EYRgrglP
HBX7pCcIalrjypJQ47VZrlI5bAlcidISqD6gCuog2tEEBiTBkX7g8IHeBbup1QX5
4HXSQIZIgQm+2cblKAkOSoV9zmFStm2M9xZZh8eAL0HKwBg1kkBqjGP/65s4ZLfa
chNwjvKg+4EU6QhMHUyIBeJEOEzRIdU3FfvV7K2mxOA7CkkWdd9UogIzJbqI9icu
9rBq8rdHtjzAvLc4qb2T7Yli/8hnt/TD2Cp2N5//+snynfKzbpjLeoNHDTcnKwUv
8PYWjgRP5IeItpgeHhrScNVsidsw4oYcSJg/ZDDW3PI+wun818uK/sqCiROI57DY
aWJJ7URbDmkc60LffyPoCNl/haJCEJvazTwpB30GtB1vkSGtrTna1J0Bv3mFN6f1
nKqYbmJP81851jMsbBhRPwmc2h7zcGkYRvVfHvf+SuAaLqSf3FqdW0JSQYWwnHLl
NPsESoCW2YMbEeg/VPsjAFFGL6FDGxnYz4PL9ixJ40cfFBSj1bcmV1WKOFYKjwtW
eCCNspcnm/4=
=gpe5
-----END PGP SIGNATURE-----

--=-UtiNZ1Is30lYE4z6SICU--

