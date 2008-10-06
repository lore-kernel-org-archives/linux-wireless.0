Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYJFTwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 15:52:37 -0400
Subject: Re: [PATCH v2] iwlwifi: fix DMA code and bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20081006192304.GF3448@tuxdriver.com>
References: <1223308831.15196.28.camel@johannes.berg>
	 <1223309405.15196.32.camel@johannes.berg>
	 <1ba2fa240810060949w5404944dud9f7b6b373542981@mail.gmail.com>
	 <1223311876.15196.38.camel@johannes.berg>
	 <1223312084.15196.41.camel@johannes.berg>
	 <1ba2fa240810061130w6b1a2282ga80156e7d756c74@mail.gmail.com>
	 <20081006192304.GF3448@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-p74MPAoAQYs9XKl3uN8U"
Date: Mon, 06 Oct 2008 21:52:06 +0200
Message-Id: <1223322726.3778.22.camel@johannes.berg> (sfid-20081006_215240_484864_9D7D90F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p74MPAoAQYs9XKl3uN8U
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 15:23 -0400, John W. Linville wrote:
> On Mon, Oct 06, 2008 at 08:30:29PM +0200, Tomas Winkler wrote:
> > On Mon, Oct 6, 2008 at 6:54 PM, Johannes Berg <johannes@sipsolutions.ne=
t> wrote:
> > > On Mon, 2008-10-06 at 18:51 +0200, Johannes Berg wrote:
> > >
> > >> > >  * therefore, all the is_odd junk goes away
> > >> > >  * fix a bug in iwl_hcmd_queue_reclaim where it would reclaim al=
l the
> > >> > >   fragments of a descriptor rather than all descriptors (this ma=
y be
> > >> > >   the cause of the dma unmapping problem I reported)
> > >> > >  * some more cleanups
> > >> >
> > >> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > >> > > --
> > >> >
> > >> >
> > >> > > Tested on 5000 hw, please apply.
> > >> >
> > >> > Great job,  however do not apply this before I review it I had str=
ong
> > >> > feeling this will not
> > >> > work with aggregation flows.
> > >>
> > >> I cannot imagine why you think that, care to explain?
> >=20
> > Yep, no connection I thought at the first glance you've thatched more c=
ode.
> > >
> > > Of course, I would very much appreciate you review the actual bug fix=
 in
> > > iwl_hcmd_queue_reclaim, which consist of the addition of the line
> > >
> > > +               bd =3D &txq->bd[index];
> >=20
> > Okay I found the source of the evil, with your big pointer :)
> > The bug caused by this memory optimization juggling we've done and
> > very  bad cut and paste coding
> > We moved for command buffers from pcI_alloc consitent to kmalloc which
> > required pci mapping that that was coded wrongly. Now this kmalloc
> > stuff is not good as well since we have this 36 bit memory limitation
> > on 64 bit platforms.
> > This is the issue I'm trying to address recently I'm not sure what yet
> > what allocation schema would be best yet.
>=20
> What if we just revert that patch?

Doesn't help, still crashes right away with 64k pages. Not sure that
even is a regression though.

johannes

--=-p74MPAoAQYs9XKl3uN8U
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6mxiAAoJEKVg1VMiehFYcg8P/iam6fMFjYUVj2eMPP1LQh+u
3DTdjmfkz2bxjZjUk4VtZegXFhNgYuWddkiqjKRYnVQRSkUKSieZjju4GFNAThxU
VYRJetMAs4a+3XRVwrO3iG62Tvh5nOKgPUlrZz9iCNvt9oeUZgubrGNrJMoH4TWI
F7xcJJjAjlLomldU/w2f8MYFdukBJFSLgoAiM8HfLjkGotHQ2aiUd1RoL/ziwoJw
CRaXQUPHawtb4+X/Qu8rbaY9X/pcWwPj/0SnBRzZscADLJJnnq1XCBfNJC+O6t6M
FIwUchmIi6mJO4ttwuEHMr4vihazaaAtY3kbeKTuj5QjzZQXOQIH5D4v0gL6aH2G
wDLihUQRi34fOTGuShudjcM5fy8Zq23arL6AyDGOKk+2KbDXRoqjjI4YTeZEsMqY
dqoQh9PcF+7hkJADsBlYf4p3mPEUCkULGclEbG1KbJkft0l0jFgh59IKLttAKuls
vhAby8zTpKJHQnoYn4eKw9/+mytGJf1xT5dOp54Uh1/g7QjDEVBflSpdLivd93V/
T6qssUt7np9qD/XGf/i4Aqw3f+eDtAWRYAicCLoOVuByJ88F5PQtj0voVblnCqlI
qH2WpjtomMHJtVEQpM2IHmVCdjabHkLQEFZtwPHQMEDtlprUgZ/dhG534M2zD5J5
KlCrI4tY26raz1ceOH8M
=5kym
-----END PGP SIGNATURE-----

--=-p74MPAoAQYs9XKl3uN8U--

