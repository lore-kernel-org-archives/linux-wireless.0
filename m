Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbXB0I2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 03:28:41 -0500
Subject: Re: [PATCH] d80211: fix sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1172539109.5835.28.camel@dv>
References: <1172530759.3870.205.camel@johannes.berg>
	 <1172539109.5835.28.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tXfkSju1LBNhPKzQvUhY"
Date: Tue, 27 Feb 2007 09:28:19 +0100
Message-Id: <1172564899.3870.222.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tXfkSju1LBNhPKzQvUhY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-26 at 20:18 -0500, Pavel Roskin wrote:

> That's subtraction of pointers to types with sizes that are not power of
> two.  This could lead to expensive division operations.  In may cases,
> this warning indicates that using array indices instead of pointers
> would be more effective (and probably safer).

Yeah, figured that out after I sent it but then went to bed instead. The
fix in that case is pretty easy, just replace the looping through with
an index-based loop and then you already have rateidx.

> > net/d80211/ieee80211_ioctl.c:779:4: warning: incorrect type in argument=
 6 (different signedness)
> > net/d80211/ieee80211_ioctl.c:779:4:    expected int *err
> > net/d80211/ieee80211_ioctl.c:779:4:    got unsigned int *<noident>
>=20
> ieee80211_set_encryption() expects a pointer to (signed) integer, be the
> code is giving it a pointer to u32.  Please decide what type "err"
> should have, and change the function accordingly.
>=20
> I think "u32" would be better, since it's a part of the hostapd
> compatibility code and we don't want to touch the userspace now.  This
> code is going to be obsoleted with the rest of hostapd interface.  For
> now, it's better to do exactly what the userspace expects.

I guess. The argument appears to also not be used in any case other than
this one.

> In case you are wondering, the test case is:

Yeah, I thought it'd be due to the locked flag. But Linus is perfectly
right, we should have a _locked version instead of using a flag.

But on the topic of sparse/locks: Does anybody know how to make sparse
recognise that I provide my own locking wrapper? If you check out
bcm43xx-d80211, it'll complain about the phy lock function since it just
locks, and then complain about phy unlock since it only unlocks. Would
be nice if it could be told that these are opaque, correct, and lock a
certain lock that it should check for in the callers.

johannes

--=-tXfkSju1LBNhPKzQvUhY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF4+ui/ETPhpq3jKURAlCUAKCyhrhRnnvlAYmZX35o5LroHKVarACfRGOp
t/O85DYuj4A4kitII/9r6G8=
=SWas
-----END PGP SIGNATURE-----

--=-tXfkSju1LBNhPKzQvUhY--

