Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbXIYNjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 09:39:12 -0400
Subject: Re: API to regulatory control (1)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <43e72e890709241518h1cc694d9of8f8a8d216a7906b@mail.gmail.com>
References: <1190456574.18521.220.camel@johannes.berg>
	 <43e72e890709221416o25bf3287v5d8d7bb5c2fe15ab@mail.gmail.com>
	 <1190624554.18521.261.camel@johannes.berg>
	 <43e72e890709241255v1f044f9dh4af1e00fcaba03b0@mail.gmail.com>
	 <1190669783.18521.301.camel@johannes.berg>
	 <43e72e890709241518h1cc694d9of8f8a8d216a7906b@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r7/i6D2Ls/bJ2SvCqtcI"
Date: Tue, 25 Sep 2007 15:40:24 +0200
Message-Id: <1190727624.18521.310.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r7/i6D2Ls/bJ2SvCqtcI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-24 at 18:18 -0400, Luis R. Rodriguez wrote:

> I saw complaints on the z1211 move thread to upstream about large
> patches and driver developers not being able to keep up as mac80211 is
> a 'moving target'.

It'll always be. Everything in Linux is a moving target. That's the pain
associated with maintaining a driver out of tree. This change in
particular isn't even hard to follow and I'd happily help change all the
drivers that are in tree.

> Another option here is just speak to the driver in a hardware-agnostic
> sense and just let drivers map this out however they want. I guess it
> provides for a cleaner API if we keep this in our own structs though.

We could, but unless the hardware operates with frequencies like b43
it'll likely need a big switch() statement which doesn't seem too nice.

> > > ACK -- but, since cfg80211 *can* be in charge of updating the, either
> > > central channel struct, or each driver's channel struct, we can also
> > > have it update power restrictions upon regulatory domain change. Same
> > > as above. What do you think?
> >
> > Well, but the driver must actually change the power level and hence it
> > must be notified of the change after it has occurred so it is able to
> > adjust.
>=20
> Only if the new power restrictions makes he current one invalid.

Right.

> > I don't think I want to call into some cfg80211 call for this, a
> > specific notifier seems more appropriate.
>=20
> Well what if cfg80211  generates a notification if a possible conflict
> has been found? Is there a need to generate a notification on power
> reg changes to the driver besides this?

Well, that'd mean that cfg80211 would need to keep track of the current
power level. I've intentionally made cfg80211 keep track of as few
things as possible so that drivers are free to change things when
necessary without having synchronisation problems. I would prefer if it
stayed this way.

Also, just providing the hook is much simpler and we can leave it up to
drivers to implement this logic.

johannes

--=-r7/i6D2Ls/bJ2SvCqtcI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+Q/I/ETPhpq3jKURAm7cAJ4wGZqoOFkk6qYjLA3Jf2Nb1omkzgCePZdf
Dkcxo6D9ArdzwKcvGrkz5Ew=
=2NN5
-----END PGP SIGNATURE-----

--=-r7/i6D2Ls/bJ2SvCqtcI--

