Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52432 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbYJGTjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 15:39:05 -0400
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Christoph Hellwig <hch@infradead.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1223408085.3618.2.camel@johannes.berg> (sfid-20081007_213457_543385_F66BFE62)
References: <1223311803.15196.36.camel@johannes.berg>
	 <1ba2fa240810061135t24f2dfbv2a5eb0cd5d9e8cd7@mail.gmail.com>
	 <200810070821.56462.hs4233@mail.mn-solutions.de>
	 <20081007071529.GA5010@infradead.org> <20081007131615.GR3448@tuxdriver.com>
	 <1ba2fa240810070703j471faa30mce3678febf3c20e8@mail.gmail.com>
	 <1223398724.7328.45.camel@johannes.berg>
	 <1ba2fa240810071228m52a60861r5558529426b9b487@mail.gmail.com>
	 (sfid-20081007_212834_461753_187EE1B3)  <1223408085.3618.2.camel@johannes.berg>
	 (sfid-20081007_213457_543385_F66BFE62)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7aaDYxW3vmxnbLCeWk/I"
Date: Tue, 07 Oct 2008 21:39:02 +0200
Message-Id: <1223408342.3618.7.camel@johannes.berg> (sfid-20081007_213910_065177_F4C14705)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7aaDYxW3vmxnbLCeWk/I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 21:34 +0200, Johannes Berg wrote:

> Then tell the HW engineers to fix the HW docs. It makes no sense at all
> to say this is 10 pairs rather than 20 single ones if there's nothing
> that uses a pair, the whole thing entirely uses single entries in the
> numbering etc.

If you need to visualise this, let me draw it:

bytes (with nibbles): | . | . | . | . | . | . || . | . | . | . | . | . |
                      | addr 1          |len1 || addr 2          |len2 |
your forced layout:   |               |                |               |
my layout:            |               |       ||               |       |

Note how this actually matches the border between the border between the
two descriptors, the || border.

_Please_, just fix it, this is _way_ easier than the forced layout
you're doing.

johannes

--=-7aaDYxW3vmxnbLCeWk/I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI67rTAAoJEKVg1VMiehFY/jwQAMEQohM3WOdnu41qNY5b4vei
uJMkqxfVHOOwFmiS98tzfPsBoNpWolafii4mK8dLlHo0CtNO8vWPBvum76NRGsRT
jwCixeNnJYkLCGFgAgJHImhWf01tAPpbP/z+IQbEK7pvyl+KYd87m5Ihe5fFxVBh
ps7M99X70t61HBYwC4nvkK1hVwiPQoRz8aZBmuFbiX7tJPieQ4WpOBKhL8M4fvYx
x92IonMbZKx69S7byClAkYdd8xIc6HpMldYerwyQEHDGkIWkMpsUszzJVmeWQtuo
pi/vukCl497ti+qjx3yLW7okrcX+aQjCEW7bBBsY1n31YBQXqrK4Udk++eA+kfu1
qEhxDATzdcQ5dJwatCw9vJXV6k1V+N1w0tmvQutqsf5D9OiRnlv/byX8DmOWOqdF
YdtgeJcU+kEMAXAmlJEmn6g4vhdpN7U/+D44Yd4lX/kNlvcB3QadtfTOsTRO8+kT
T/eSuxnJnD7JHv7wEfTWMvSonAjmtDBl2GbaDjQICWbJKWHL8KITFaxslZzUDNoO
DxciXTON1nyZjMlakaMWq/cPceDy+iqBea2opNFKPIK1VvfcKvqphYKJBOIpP97x
wAbFdZDy+zkrFE2Ny1u8EcjBTt7+r8RiMDsQX189A4Otxi4pUdQHeeyBOLfHrgiI
a3EDTiHzrbqm7vgucrod
=7qST
-----END PGP SIGNATURE-----

--=-7aaDYxW3vmxnbLCeWk/I--

