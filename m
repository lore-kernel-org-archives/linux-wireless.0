Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:25152 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752409Ab3DLOMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Apr 2013 10:12:06 -0400
Date: Fri, 12 Apr 2013 16:10:40 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] cfg80211: add get_max_tp() API
Message-ID: <20130412141040.GF4717@open-mesh.com> (sfid-20130412_161218_311419_4FD58131)
References: <1365105442-31876-1-git-send-email-antonio@open-mesh.com>
 <CAGXE3d98a4pBG=gWKUm9A2RJRN+eic4Zi8dh4grTuqQmW3GOsg@mail.gmail.com>
 <20130405083956.GA14463@open-mesh.com>
 <1365168001.8515.28.camel@jlt4.sipsolutions.net>
 <20130406073309.GB14463@open-mesh.com>
 <1365503108.8465.34.camel@jlt4.sipsolutions.net>
 <20130409113406.GC3771@open-mesh.com>
 <1365674217.8272.37.camel@jlt4.sipsolutions.net>
 <1365674261.8272.38.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Zi0sgQQBxRFxMTsj"
In-Reply-To: <1365674261.8272.38.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Zi0sgQQBxRFxMTsj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2013 at 02:57:41AM -0700, Johannes Berg wrote:
> On Thu, 2013-04-11 at 11:56 +0200, Johannes Berg wrote:
> > On Tue, 2013-04-09 at 13:34 +0200, Antonio Quartulli wrote:
> >=20
> > > > Anyway my concern is that you're adding something that's rather min=
strel
> > > > specific. It's not really usable by any other algorithm, you're
> > > > reporting minstrel's estimation of the throughput. If you report the
> > > > current "best" rate, that'll probably get you pretty much the same
> > > > behaviour overall, but be more portable to other algorithms I think.
> > >=20
> > > I understand your concern. My guess was that every algorithm was "som=
ehow" able
> > > to provide such measurement. The point is that the throughput value i=
s computed
> > > so that it also take probability of success into consideration.
> > > This means that two nodes using the same rate may have different thro=
ughputs
> > > (and this is important when building our distributed metric).
> > >=20
> > > However, nothing prevents any algorithm to implement the API the way =
it can do.
> > > I've not looked into other RC implementations yet, but I guess they w=
ould have a
> > > similar value to return too?
> >=20
> > Maybe, yeah.
> >=20
> > Anyway, I think having a separate externally visible API here is
> > overkill. It would seem a lot simpler to return it (to userspace) in the
> > station information, and (separately) allow other kernel modules to
> > request station information as well.

Ok, sounds good!

> >=20
> > Also I'm not sure it should be called "max_tp"? It's more like "expected
> > throughput" or something like that?
>=20
> Hm, no, that's not really it either ... It's maybe more like "current
> usable data rate" (as opposed to PHY rate?)
>=20

Mh..well, it is not a "real" value, so I would not use neither "expected" n=
or
"usable". It is supposed to be the result of a computation giving us an
estimation of the current/last throughput. "estimated throughput" sounds ba=
d?

Well the name is not really important I guess :) I start sending some code =
using
the latter. We may change it at the end before merging (if you decide to do=
 so).

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--Zi0sgQQBxRFxMTsj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRaBXgAAoJEADl0hg6qKeOjhYQAJlezR5dbMM6+wKklo6ld1pw
5cmEEf1Q8oWJYgPjNwk5mzYNKEAVxOPEnyNHi2LZd28dvtDcObrO4UXPTddbUEuG
ShjqPM2Zn9CWGWPJt06HEiqF1Rv/BxvNYUaeafqJbAQL9zx4KeCN+LzHJKO2MLtq
0uIgaTnGdQH5mAnla9UWh+hToZSjAAJQCBvxHYIwVzQoqGxWvLRPQOeXzXioZL7O
KlM/r6eSMC5Zivo9t25zk0Zj99k3cCsnAAlOfYeMJU+LG+6SC5yOWkkWTtNMwz6f
8iDiX8oi3tGgr/dJj7pbD/QZuS2N2d+nXcv0mcs1I0ZYmcRsB9sVenTxcsMu4G7a
IAKYtt9E7LtgmEhv5mHNmBkPfU7432P95qxDbogx5j5U8shH9m2KHd3YapR8tIEY
Apjta3wbTDK8ORevAX33Rrx+3uKzyH/NthMDmWNA5cjZF0M2myGUOADWPe9Dd8jW
OLYrM0eQfs5At2v1hooBdry/vRh+3Upm7dgysQyJMuYeHkxsW6lyxSCInr0a+8Gb
qp56nJsQ6qq1q/6X6jB7jQcjlXAnhiF1SaGzopbEszq3kSPZQ2SfpDSYspVxhVST
ViXithnLQvFCq2xKb6hY9zEYZOn+o7IiZs6d4WYu7QTU0bWMjmKdd7AwjDDYsWIK
XZrb8vwKLUkbKJrrhGL+
=i3lA
-----END PGP SIGNATURE-----

--Zi0sgQQBxRFxMTsj--
