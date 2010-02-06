Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38237 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab0BFN7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2010 08:59:09 -0500
Subject: Re: [RFC 0/2] cfg80211: Retrieve missing BSS info after connect
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com,
	sameo@linux.intel.com, dcbw@redhat.com
In-Reply-To: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com>
References: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lrP9IAwEENXRu9+VEeRS"
Date: Sat, 06 Feb 2010 14:51:43 +0100
Message-ID: <1265464303.4041.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lrP9IAwEENXRu9+VEeRS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-06 at 13:20 +0000, David Kilroy wrote:
> This patchset attempts to address the issue where a driver that uses
> the cfg80211 connect operation connects to an AP before the scan result
> for the AP is available. This triggers a WARN_ON in sme.c, and the
> connection fails.

With technical comments out of the way (see other emails) I guess I want
to know whether this really makes sense.

Yes, we definitely need the right BSS struct when the driver signals
that it connected, but we also need the same information when it roamed
for example. Does it really make sense to scan after the fact, instead
of asking the driver to provide the information? This is a genuine
question -- I can see value in this if more than one driver needs it,
but if the devices can just provide BSS information right before the
connected call that would be a lot simpler here.

johannes

--=-lrP9IAwEENXRu9+VEeRS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLbXPsAAoJEODzc/N7+QmaPNwQAJHIWiNJh6V3g//W92F0lV/3
DK0eJHlFLvtWd7i5kS9SPb5Ds2pcBqJJLWh7PXpiqYBfTDy4OXnnYM+Q8oPbtg5o
n0DQg7Vp9R665NS307DXq3deoCkBH4Lc99RsJsKwP9ZhFI6EpJBRz63voMsATwC6
8EImKTdzHX/XGfnMHB6sJIBLNSk7LkT3is/kR6j1I9xiq1rrYj00HkoA7zXIfx03
NbrStBjV4Tm7oIPJKa4qBtSnKO3Dw/X6pSzhbZle3WUrWiuR7wbN8MWIBwpoJm5B
FcZrB1hwFwuzuzZK7/YPBGFCi+uCyGrKzHlmiiF4896JbEi8vstbAl0Jh9nDF6F+
J5lRwHntKMEGAQhMzgm/NugaufJ7vyw9eBCRIh4uOwzgad4xg7njFV92FatHGOgw
65J43sHc2x97I2tJdG81aLOkiYHcNdeTkRUmYe3LEcKDYV8BJbAk8ua7UViDcgzs
Uk3ANTWmj39vzcYiNl/dX0h24gMoS4C6sXt7GmYmwLXJKOJipcC/uiaZSUB7L6q+
HTX1aqflEyxFAkiN/IQ/beDdrnaRfcdgLXKZDauQkaXTxkqXlGy+Ubj3bEYQYEcY
pBn1YbTtYn3HeRGhcQvgXykKeN9RFCSggnphN3MYGEeU7Pf+MkkWQwf5T7tnhE2g
Hoq8MMEtkIPH8eNNKi1F
=F8UJ
-----END PGP SIGNATURE-----

--=-lrP9IAwEENXRu9+VEeRS--

