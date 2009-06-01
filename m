Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60447 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672AbZFAO5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 10:57:14 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243867620.3015.17.camel@localhost.localdomain>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
	 <1243763887.19302.29.camel@johannes.local>
	 <1243796509.6570.35.camel@localhost.localdomain>
	 <1243841639.5299.8.camel@johannes.local>  <4A238EA2.4040106@tuffmail.co.uk>
	 <1243858256.5299.14.camel@johannes.local>
	 <1243867620.3015.17.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sg6guAj3SZv8pIgx9doq"
Date: Mon, 01 Jun 2009 16:57:10 +0200
Message-Id: <1243868230.5299.28.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sg6guAj3SZv8pIgx9doq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-01 at 16:47 +0200, Marcel Holtmann wrote:

> > This adds the two following things to /dev/rfkill:
> >  1) notification to userspace with a new operation
> >     RFKILL_OP_NVS_REPORT about default states restored
> >     from platform non-volatile storage
>=20
> I really don't understand why this is needed. What benefit does it give
> us compared to just sent OP_CHANGE and OP_CHANGE as an update. My X200
> for example does this anyway on suspend/resume.
>=20
> So what is rfkilld suppose to be doing when receiving this report? What
> is the expected behavior? Why do we bother with multi-OS crap here? I am
> really unclear what are we trying to solve here.

Well, apparently people want to use the BIOS to store the current rfkill
state -- this lets them do that. Now, I don't care if you implement it
or not, but now they could.

The point really is that when rfkilld starts up it has to impose a
policy, and the question is what that policy is and where it is stored,
if desired, across shutdowns.

johannes

--=-sg6guAj3SZv8pIgx9doq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKI+xDAAoJEODzc/N7+QmaLm4QAJjNu6Tw7L8FF3jV0XbwQzeD
chTb/iApzxrEHO79UqzLhPp6RpuRnYnFG3KLXxmID9mwa+asIqC39bcj3YJa28zO
PX1/jxsSHmUO3rEyKV8aDrgsCK796p3GeIsWk3j3cpXbXwL3DdMrjOMLOiJzOGjm
od7xrtcy7wg/tpeUCzSk/z/JzV1fyV2gGJA19kPHZNLfFUAM1H9A/6nC4iZZokbm
BICggVWgSuPewzdAXGj2lTu0uQU1PdbcDtae7F04FlpirKiRkBMTJeSTfiOIFzf8
sSGb65C3XMZQFj3y/JbRCs95mbJvcP6j6fmR0Bbx4DPpuw063iVFQYkt2gdNz1GN
kahprezbmERsivwC8jILkz+XARw4yB9zcEE8Fqqz6xLwQHDPz3adAFMCL03MLkS1
P9aeIX2oGoqiuWZnxCGeItqthN2cPeeemFnPD2oTBHHGrIhgEn0LZOjmXEvzx+bA
+u/kjPJEqMfaVRwHmlqoOWTMaBhLxnl6hx1/rd46605sWGpt4E4S/X05sFAr/9xg
YU+uBYeu8IjlcoHUg5j2lWbCnF9ZEmylN/xsdPRxrijJg6BuorOnTIAkF2v6kL7S
v1taOno9vH0ozJcoIKnDVPak5IDIFUunRZrpmj09Co+CRAA4sMW5kuHJqYZoTtjB
v/8J1DoC0ELfx1c3q0Qp
=9DJL
-----END PGP SIGNATURE-----

--=-sg6guAj3SZv8pIgx9doq--

