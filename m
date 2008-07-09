Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYGIVDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 17:03:09 -0400
Subject: Re: [PATCH] libertas: fix memory alignment problems on the blackfin
From: Johannes Berg <johannes@sipsolutions.net>
To: Ihar Hrachyshka <ihar.hrachyshka@gmail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org,
	Ihar Hrachyshka <ihar.hrachyshka@promwad.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <fce2a370807091355o47f38f6ei3ce83b4b27466bf8@mail.gmail.com> (sfid-20080709_225542_937607_E9D9FEE5)
References: <20080709031850.2e7bf50f@promwad.com>
	 <200807091521.04520.hs4233@mail.mn-solutions.de>
	 <fce2a370807091303m4699e7dbl336eddd86735619e@mail.gmail.com>
	 <1215634044.3246.50.camel@johannes.berg>
	 <fce2a370807091355o47f38f6ei3ce83b4b27466bf8@mail.gmail.com>
	 (sfid-20080709_225542_937607_E9D9FEE5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0BbG/OFJstRpJuJXd52o"
Date: Wed, 09 Jul 2008 23:02:20 +0200
Message-Id: <1215637340.3246.53.camel@johannes.berg> (sfid-20080709_230313_226174_6888F5F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0BbG/OFJstRpJuJXd52o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 23:55 +0300, Ihar Hrachyshka wrote:
> On Wed, Jul 9, 2008 at 11:07 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2008-07-09 at 23:03 +0300, Ihar Hrachyshka wrote:
> >> On Wed, Jul 9, 2008 at 4:21 PM, Holger Schurig
> >> <hs4233@mail.mn-solutions.de> wrote:
> >> >> Fixing unaligned memory access on the blackfin architecture
> >> >> (maybe on the ARM also).
> >> >
> >> > You can delete the "maybe", on ARM (more specificially, on a
> >> > PXA255, which is ARMv5TE) I didn't had a problem.
> >>
> >> Ok, just blackfin. Is it a joke or should I resend the patch with
> >> another description?..
> >
> > I'm sure arm has that problem too and sparc and others, but it may not
> > always show up because the frame might actually be aligned sometimes.
> >
> > OTOH, why are you getting unaligned frames in the first place? This is
> > the beacon interval, so it's at a fixed modulo-two position from the
> > start of the frame.
>=20
> Do you mean that we should add __attribute__ ((aligned (2))) for our
> 'bss_descriptor' structure definition rather align particular fields
> at runtime?

Oh, no, sorry, I got confused. The firmware apparently lays out the BSS
structure in that way, I was thinking you were getting the beacon/probe
response frame itself. The patch is correct.

johannes

--=-0BbG/OFJstRpJuJXd52o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdSdYAAoJEKVg1VMiehFYv7oP/0OtZLkQdvYhMvjdJRJXn0bM
FP7y9rP1q5zUsjx3JdigiyRdDzsJlyoDHYYRi/738BchUgjuHPSe9KMMkyBqkVQJ
/08ptqMB5CakZm/DFzBDyRC+FybMSOjn5ho97lu8b4EuEmtxAPYu0CjOVXBGxeQJ
8d0wMRe2zYJITSIMdFMofLThaamA/oyYnQirZxp43SeDh3KslSvHfldrPNYvEEDw
uUQKcriKM9Da2xTEy5UhSr6DuR5XzIwCXjekbgS+X454k4WhoblsF1lXtshBHCAb
KbB8XV/ppxkI0vHxK4rbk54r49PUMNd/n7YZSHocqsposkqaoxbtqctf0X0aA44Q
dLYFzxY3Nx11lVeEQNybMSn05i0BAcpSMs0VGak5ZSYCaCx/FzYasgWB4XkLaTCt
nSleuQf7gIzWDqolNfYDjrGaqCMlCvbgN9hivS/1GTso+Tu8k8o6QD8swug6MUQK
caZOQA/WkbYpwI4NeavM2AbLNd3FtMejFZtzVWEpYtVhKGMG3v3Oe28gLr496uXX
9CDZw6Is5VAKakMOi3XtRddtUSOCqYnmROVgtU7/AJ+arFGqil+VX22eDEXiG1Oi
6VBi1ur7xeqjwSM6MUE9iyo30Dx1yD13Ap3ICMcnFOe7u0E012vG9v/jzpMV3NXn
cHH6TAc634ZYkR7eXANt
=xKGz
-----END PGP SIGNATURE-----

--=-0BbG/OFJstRpJuJXd52o--

