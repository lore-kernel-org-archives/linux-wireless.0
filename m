Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767352AbXDEVur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 17:50:47 -0400
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Theo de Raadt <deraadt@cvs.openbsd.org>
Cc: Michael Buesch <mb@bu3sch.de>, Jeff Garzik <jeff@garzik.org>,
	Marcus Glocker <mglocker@openbsd.org>,
	Jon Simola <jsimola@gmail.com>,
	Theo de Raadt <deraadt@theos.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Martin Langer <martin-langer@gmx.de>,
	Danny van Dyk <kugelfang@gentoo.org>,
	Andreas Jaggi <andreas.jaggi@waterwave.ch>,
	Larry Finger <larry.finger@lwfinger.net>, Quaker.Fang@sun.com,
	Joseph Jezak <josejx@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	Greg kh <greg@kroah.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	license-violation@gpl-violations.org
In-Reply-To: <200704052133.l35LXmZA032186@cvs.openbsd.org>
References: <200704052133.l35LXmZA032186@cvs.openbsd.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MAwf0tFQxcc66dnMG1dZ"
Date: Thu, 05 Apr 2007 23:49:59 +0200
Message-Id: <1175809799.3489.31.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MAwf0tFQxcc66dnMG1dZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-05 at 15:33 -0600, Theo de Raadt wrote:

> Those were just 'EXAMPLES'?  So you had no evidence?  Why would you
> show examples of white space and variable naming when you had real
> evidence?  Or did you think that the examples would be evidence?

Of course you're putting things out of context and order again, which
we've all seen enough in this thread; but let me set this straight:

When we discovered that the driver looked similar, we first looked for
instances of code that were apparently copied (as Marcus claims "a lot
of lines in bcw are written in a way with a too close eye to your
code.") At that point we still assumed they actually were just rewritten
versions of the same functions.

However, discovering, for example, an implementation (!) of an abstract
state machine (yes, don't explain to me again how you cannot copyright a
state machine) that is exactly identical to the implementation in
bcm43xx when the description in the specs basically looks like an
octagon, we decided to look further, and discovered things like:

http://www.openbsd.org/cgi-bin/cvsweb/src/sys/dev/ic/Attic/bcw.c.diff?r1=3D=
1.77&r2=3D1.78

where original code that Jon Simola wrote from the specs (!) is ripped
out and replaced by something that comes straight from bcm43xx.

And at that point, still wondering if it was just written similarly,
Stefano started comparing it on a much lower level and discovered that
there's just no way that the seemingly similar code could have been
rewritten and not copied since that would imply that there's at least
some difference except for a quick s/bcm43xx/bcw/g and re-editing of
some strings.

So that's how we got to whitespace. For the record.

johannes

--=-MAwf0tFQxcc66dnMG1dZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGFW8H/ETPhpq3jKURAs5iAKC0t2ZwCcU84HuRi6RFreoCTfIliQCdG908
U+ib1VMtjjutsWMcvxcSz7c=
=Iiem
-----END PGP SIGNATURE-----

--=-MAwf0tFQxcc66dnMG1dZ--

