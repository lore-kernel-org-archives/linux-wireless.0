Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52021 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbZC3RaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 13:30:16 -0400
Subject: Re: rfkill-input madness
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <20090330172131.GA23749@khazad-dum.debian.net>
References: <1238159196.4452.1.camel@johannes.local>
	 <20090327143007.GA24288@khazad-dum.debian.net>
	 <1238188237.4452.17.camel@johannes.local>
	 <20090328005214.GA7439@khazad-dum.debian.net>
	 <1238262651.4217.21.camel@johannes.local>
	 <20090330132344.GA11934@khazad-dum.debian.net>
	 <1238422292.5970.9.camel@johannes.local>
	 <20090330172131.GA23749@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-H39yl5mXMuaT1sdCDGiO"
Date: Mon, 30 Mar 2009 19:29:41 +0200
Message-Id: <1238434181.5970.14.camel@johannes.local> (sfid-20090330_193032_353815_4C3AB309)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H39yl5mXMuaT1sdCDGiO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 14:21 -0300, Henrique de Moraes Holschuh wrote:

> Here's what is (was :-) ) in rfkill-input:

Heh :) I've been refactoring rfkill-input too -- but I haven't actually
changed it.

> 1. There are per-type global switches (and no "all" switch)
> 2. There is a flag, EPO (emergency power off).
>=20
> rfkill-input translates any "EV_SW SW_RFKILL_ALL ACTIVE" events into "ena=
ble
> EPO".  It saves the states of the switches beforehand, so that it can
> optionally restore them.
>=20
> When something enables the EPO, all switches go into block.  And they ref=
use
> to go out of block until the EPO flag is cleared.   I.e. it has the prope=
r
> semantics for a safety device.
>=20
> What happens when you clear EPO isn't much.  The rfkill core doesn't care
> much, all that it knows is that switches are not prohibited to go out of
> block anymore once the EPO flag is clear.
>=20
> rfkill-input, OTOH, can be configured to do one of three things when it g=
ets
> "EV_SW SW_RFKILL_ALL INACTIVE":
>=20
> 1. just clear the EPO flag (the user will have to go and manually unblock
> the switches through sysfs or normal events that rfkill-input processes)
>=20
> 2. clear the EPO flag, and restore the global switches to the state previ=
ous
> to the EPO
>=20
> 3. clear the EPO, and unblock all switches.

Ok, that makes sense, and I think I understood this much already from
cleaning out rfkill-input.c (which killed a few dozen lines of code w/o
any functionality changes)

> So, there is NOT an "all" switch.  But there is the handling of the
> SW_RFKILL_ALL event by rfkill-input.
>=20
> > > I can't say I strongly want it, since I am happy enough with rfkill-i=
nput,
> > > though.  But the API to userspace _is_ incomplete if the global state=
s and
> > > global functionality are not exposed.
> >=20
> > I've kinda removed the entire userspace API part from rfkill, mostly ou=
t
> > of laziness (so I guess I'll add it back) but also because I don't quit=
e
> > see the point. Has anyone come up with a usecase for it?
>=20
> I'd talk that over with our Network Manager maintainer, he is the one who
> might want it.

As far as I understood him (he was giving an example), Dan doesn't care.
But let's ask :) (CC'ed)
Dan, would you want to have NM control rfkill from userspace, instead of
using rfkill-input?

johannes

--=-H39yl5mXMuaT1sdCDGiO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0QGDAAoJEKVg1VMiehFYJVcP/0iCF9ELy2hSsKvRFreT05c8
DgS7WmVGws/NtHDRkrK8ctWBfY5mGxvLlcg5pEmqqSqDfXn3tpyhumGOhp1l8/zV
58EjhiZ5vgqAqUqZ8Boq9MO/1QbAaxhlUoHKLrf9TKgYZBcg6X+h7sCQ7liNRLUT
FdbsB9UP8Pc2Djgxh+NpCLlidsvAZ45bGqbWN8DdyseJg3SbCqcU8EhqKZzU6yAP
C8WJuXuZbxCyP+cMcqV2TpSqvFz3H2hOpNxAT+sM//2M9TKPh92W2wKNiGSc5qZT
zks5lnM5OSzXv7SYZ+vzfKDCEH96MPeTFnKD0u+unpVSWdGsUYRSmlnnOW78HgMg
4naEUDNTE9gLMUvIKmbRSpliWUUybhXY/x6EyvWei/YP3cmRRdCeW9+Nq9vBuSfR
LddFl6DQF732IoRnJ14cKQN8g/J0+4JSRlhT1+fW5HZHPsFVApcFZb67zSFqKrZe
eFKVSUUGH1j+65Mp/H1jfYU3DUPMP4Us5gedKGWOP5gHNPryUp6x5X9BUpaeCcUV
EIvcbOj2bPJii1FrNN4rl6md+qQZvjdnPVg6EDkDpGitdFqWPFzrtuZUOBJbkIJe
uB7r8YSfwVLjBKebXVhoLNxKn9t5O8KBOZ9Xb4zHYIXR3e+bQF6qYVkwaB40wORi
5z7eFu0Eqid03oaIx5dJ
=f39/
-----END PGP SIGNATURE-----

--=-H39yl5mXMuaT1sdCDGiO--

