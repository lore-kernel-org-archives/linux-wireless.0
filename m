Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33119 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbXIAJfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 05:35:00 -0400
Subject: Re: radiotap injection bugs & extending it
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <46D92EFC.2060007@warmcat.com>
References: <1188609135.7585.105.camel@johannes.berg>
	 <46D92A1C.4050308@warmcat.com> <1188637615.7585.118.camel@johannes.berg>
	 <46D92EFC.2060007@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zcN2l8qWn1/4rY9tQzWb"
Date: Sat, 01 Sep 2007 11:36:20 +0200
Message-Id: <1188639380.7585.130.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zcN2l8qWn1/4rY9tQzWb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-01 at 10:21 +0100, Andy Green wrote:

> > No, sent the mail just before going to sleep :) I'll review your patch
> > and adopt it. Guess I get to rebase my ~70ish patches to after it
> > then ;)
>=20
> Hopefully it's just fuzz...

In fact, it's commutative, not even as much as line offsets. :)

> Well because our frames aren't targeted at any real MAC I'm not sure the
> AP will buffer them for devices in PS or not.  Maybe the client having
> an interface up in hardware promisc should be a sign for it to not go
> into PS mode anyway?

Well, for one, the PS code is only relevant if we're ourselves operating
in IBSS or AP mode. If we're operating in AP/IBSS mode we'll also
automatically buffer your injected multicast frames for after the DTIM
beacon. I think we should just buffer injected unicast frames as well,
it won't hurt your use case (multicast destination) and makes things
more consistent.

> For sure things will be much better and more consistent if we can inject
> down unassociated interfaces reliably, so this is a nice move.

Well, no, that's unrelated, and it's a bug in iwlwifi that it craps out
over that ;)

johannes

--=-zcN2l8qWn1/4rY9tQzWb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2TKU/ETPhpq3jKURAou5AJwOeOFLvxphot1eNb1Z8P11yyDiwQCcDxx7
AS9CTT50Sn2amNxi1E0eFs8=
=R/Of
-----END PGP SIGNATURE-----

--=-zcN2l8qWn1/4rY9tQzWb--

