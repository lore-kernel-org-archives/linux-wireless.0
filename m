Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:63950 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935371Ab3DILfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 07:35:31 -0400
Date: Tue, 9 Apr 2013 13:34:06 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] cfg80211: add get_max_tp() API
Message-ID: <20130409113406.GC3771@open-mesh.com> (sfid-20130409_133535_204382_86173273)
References: <1365105442-31876-1-git-send-email-antonio@open-mesh.com>
 <CAGXE3d98a4pBG=gWKUm9A2RJRN+eic4Zi8dh4grTuqQmW3GOsg@mail.gmail.com>
 <20130405083956.GA14463@open-mesh.com>
 <1365168001.8515.28.camel@jlt4.sipsolutions.net>
 <20130406073309.GB14463@open-mesh.com>
 <1365503108.8465.34.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
In-Reply-To: <1365503108.8465.34.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 09, 2013 at 03:25:08 -0700, Johannes Berg wrote:
>=20
> > But the reported_rate field would just contain the index of the selecte=
d rate,
> > not the throughput. As far as I can tell the latter is an RC private in=
formation
> > (it not exported anywhere outside of the RC algorithm) and that is why =
I made
> > this API which would directly talk to minstrel and get this value.
>=20
> Actually it would contain the entire rate configuration.
>=20
> Anyway my concern is that you're adding something that's rather minstrel
> specific. It's not really usable by any other algorithm, you're
> reporting minstrel's estimation of the throughput. If you report the
> current "best" rate, that'll probably get you pretty much the same
> behaviour overall, but be more portable to other algorithms I think.

I understand your concern. My guess was that every algorithm was "somehow" =
able
to provide such measurement. The point is that the throughput value is comp=
uted
so that it also take probability of success into consideration.
This means that two nodes using the same rate may have different throughputs
(and this is important when building our distributed metric).

However, nothing prevents any algorithm to implement the API the way it can=
 do.
I've not looked into other RC implementations yet, but I guess they would h=
ave a
similar value to return too?

Cheers,

>=20
> johannes
>=20

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRY/yuAAoJEADl0hg6qKeOdvIQAIb7hTPy3ckWg/7Bf6fdcGPu
PEk8CbjSmQefUwHbQ+ELRvM6NWQmcQlDlO3lJbW0da1UWGcb3LCJecFbVwJbLc7U
8ggtKGQSEm2Pe5gfcEPgi/bbCPtYGcX49kOesXHaTkhoZnSng1BvTg0GjX+D679v
ljTN+IiutpeWAyYpGaZZFfrdV3K+qfOVvAv046SmaoepVfgy7yjIKp+aOCNfz2RE
X0e54hczCTLeRWkQpV4JSGWydpGA9lKX5eH93/PYpEjD5dBPBQrcXAtyYyeP8Yzm
COmHtb0i69qy39knYzbR1u6Ig02/7XDazBsKDDvhIndDH2p3Jq2OlKzCDAsUYbSu
LM3o5nBrG4n1CIA506JrKFTlFEHo8YVr0HBqGkRn9LDtLcch234Ah/Ns3snq9ESO
W/E+gqzlWT8rLzkZeG3YPFWuLnAbLy+snkP/+GYUWq8Jc506P9XGIojUKrFTJIsP
hO2GI510UmEd4wLrkKcEwTp+p9GETGrnKqwGWJqREfO6Ot744pu9iC2ohjMECCsw
H07ChhNy9iKNJqjf4hAjIC0tB5hMwomtNObNceKWSRfoXM+ikWMSTCbCtPuCxf2C
MF8ILAyuBBr7rRbrB9x3iIllJB2smzP01HJ266fyDMjCnOwOb+SLQWtjZx0IzNVJ
Lf1XN4YZ5hVne0IsnFi4
=nWLk
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
