Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965540AbXC1Lfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 07:35:37 -0400
Subject: Re: rx racing against removing interfaces?
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200703281332.40879.mb@bu3sch.de>
References: <1174950322.25887.59.camel@johannes.berg>
	 <200703281259.55764.mb@bu3sch.de> <1175080054.5151.50.camel@johannes.berg>
	 <200703281332.40879.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VhgKhNUrBcRaWvibtuIm"
Date: Wed, 28 Mar 2007 13:34:25 +0200
Message-Id: <1175081665.5151.58.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VhgKhNUrBcRaWvibtuIm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-28 at 13:32 +0200, Michael Buesch wrote:
> On Wednesday 28 March 2007 13:07, Johannes Berg wrote:
> > On Wed, 2007-03-28 at 12:59 +0200, Michael Buesch wrote:
> >=20
> > > Oh, you mean virtual interfaces.. yeah, there's probably a race. I do=
n't
> > > know the locking there.
> >=20
> > Yes, I mean virtual interfaces, when the thing is in progress while we
> > iterate through.
> >=20
> > > But my comment about the non-irqsafe-variants-should-be-hidden still =
applies :)
> >=20
> > I'll reread it ;)
> >=20
> > But I'm not sure I fully agree. If the driver calls __ieee80211_rx in
> > softirq context that should be good without requiring to reschedule in
> > mac80211.
>=20
> I'm not sure there is an easy and non-racy way to drop the driver IRQ loc=
k
> while calling __ieee80211_rx synchronously.

Depends on the driver, I guess. rt* seem to reschedule already and call
__ieee80211_rx.

johannes

--=-VhgKhNUrBcRaWvibtuIm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGClLB/ETPhpq3jKURAjkkAJsEQVZnWJ17DvLJyG4msIZdZzTPVgCghBHl
SvxH1Ciy0Ya0f2NrWMKYox4=
=qe6o
-----END PGP SIGNATURE-----

--=-VhgKhNUrBcRaWvibtuIm--

