Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539AbZC1Ru5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 13:50:57 -0400
Subject: Re: rfkill-input madness
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090328005214.GA7439@khazad-dum.debian.net>
References: <1238159196.4452.1.camel@johannes.local>
	 <20090327143007.GA24288@khazad-dum.debian.net>
	 <1238188237.4452.17.camel@johannes.local>
	 <20090328005214.GA7439@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-w3uoiY0u2uphtTnRrnwL"
Date: Sat, 28 Mar 2009 18:50:51 +0100
Message-Id: <1238262651.4217.21.camel@johannes.local> (sfid-20090328_185107_960355_4543BE76)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-w3uoiY0u2uphtTnRrnwL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-27 at 21:52 -0300, Henrique de Moraes Holschuh wrote:

> > Indeed, but that's useless since almost all drivers disable userspace
> > claiming... I'll re-implement it later for only the software state.
>=20
> I think we can remove the "disable userspace claiming" stuff entirely,
> and retain user_claim.  user_claim just means rfkill_input won't touch
> a rfkill controller, there is no problem if the state changes because
> the rfkill controller's driver had to do a rfkill_force_state() for
> some reason.

No -- the problem here is that despite the driver having hard-killed it
still needs to be able to handle the soft state thingie. Which is why
user_claim_unsupported was added. Yes, agree with you, but only a little
-- we just need to make the rfkill core smarter.

> Sure: all that matters is that you won't have two different actors
> trying to implement handling for, e.g. EV_KEY KEY_BLUETOOTH, by
> complementing the state of a rfkill switch.  If you do, actor A
> complements, then B complements, and the net effect is that no change
> happened :)

Indeed. But by disabling user claiming we have removed that problem
entirely ;) No, like I said, I don't disagree, but the implementation
sucks. I'm going to add this back in a way that drivers don't need to do
special handling.

> > > Anyway, I got sidetracked because I was Not Happy with the userspace =
ABI but
> > > couldn't come up with anything better.
> >=20
> > It's not like we can change it now...
>=20
> I don't mean the rfkill core API that is already in place...  I mean
> the new one in the "RFC" patchset I just posted.

Ok so you want to add "global" states mostly -- that's fine, but not all
that useful since userspace cannot really claim globally. I also don't
see a point -- if userspace wanted to do global stuff it might just as
well do nothing.

> Yes.  But the exclusive grab _is_ needed for regular keyboards,
> otherwise anyone can snoop on what you type.  But it is not what one
> would like to happen to hotkey input devices... most of the time.
> It is confusing as heck.

I see you've figured this out already over in another part of the
thread.

johannes

--=-w3uoiY0u2uphtTnRrnwL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzmN4AAoJEKVg1VMiehFYeboP/0WRpkqWPhf2K+SlB0Zbs32q
uHorDwfoGPPBDHZGPbBfeer4qv6mvloXnJ+nKpIl0/nhSzXOtyVTc6eZDd3aqOmH
g/1czTEX00JnPwrQJAct+NihCrVEOjgRHNoMAN8pw/vh0iFit5Emwqz6Q8LCNq3o
UdaALiU0VYbpzTUKbAr6oe6S3Atn1ZdW2JH1jkt7Y29nWg0xNTcEDvDOTA3mooxe
oXsL2xhzJYAHuvgcGyyA74bQ+dBPc97SfoWZHaKf5w1sBMmNOx+4o7L9DksZ2fd6
U5pFxs8PpfuKw25Qmg5ZGANTwCR8W+oywLo5PBPLnAmiu0U5sdI08c4g6pTTa0GQ
lYDTb2t3F6R4eBJWVOuqpzEi5kmWQM6SASUylLw08RqickZ7VfxEOJLjPJtyiAoA
hlUBccZxWr8ogmvjcDTaiQ3jumg7Bl3AYbu5gFrbgsKMj7/cOZ+hns6af0y7Xwd0
cfkaesTk/GUVktpCrGrXMZGJmTnl438KqaMT6kE5xbdrRyeMtnPyt9mijY9a9CoK
HMT4SZNeWiyFs7wVJnFYXX1We2Kjd25UogJMoqpd3D1dYdxd09+VYc0mfUVUgKgD
0LuwifCGpGo1H60XoHaVteUQ3HOJGvsgFbghiuEfNnZd/T0mMw6HPhkzJ92SR9fb
1iGc7jZ4hlO9FKmThG6c
=sou5
-----END PGP SIGNATURE-----

--=-w3uoiY0u2uphtTnRrnwL--

