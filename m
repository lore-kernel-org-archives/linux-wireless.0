Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:20800 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751731Ab3BRPuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 10:50:06 -0500
Date: Mon, 18 Feb 2013 16:49:06 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
Message-ID: <20130218154906.GC4162@open-mesh.com> (sfid-20130218_165013_514034_EC36D7B6)
References: <20130215171938.GA4140@pandem0nium>
 <1361197831.8555.23.camel@jlt4.sipsolutions.net>
 <1361197982.8555.24.camel@jlt4.sipsolutions.net>
 <20130218144622.GA4162@open-mesh.com>
 <1361201387.8555.32.camel@jlt4.sipsolutions.net>
 <20130218153833.GB4162@open-mesh.com>
 <1361202206.8555.34.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="PuGuTyElPB9bOcsM"
In-Reply-To: <1361202206.8555.34.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 18, 2013 at 07:43:26 -0800, Johannes Berg wrote:
> > I did not like this approach because the sta_info struct is so big that
> > when we want to fill the stats substruct only we will waste a lot of by=
tes.
>=20
> I don't understand your point.
>=20
> struct sta_info {
>    ...
>    struct stats stats;
> };

My concern is about those "..." that we are allocating within the sta_info =
struct
that we will never use for every non-peer station.

While if we used the struct below (with its own hash table), we would alloc=
ate
only the space needed for the stats.

>=20
> struct stats_entry {
>    struct hash/list/whatever;
>    struct stats stats;
> };
>=20


no?
Maybe I misunderstood your idea?

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--PuGuTyElPB9bOcsM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRIk1yAAoJEADl0hg6qKeOMAUP/Rik1gZ0TQlerXHIGakWVwV1
b4XxX6tsv/x4pCKeamKDU2xEAbmeWYtv3p6IPNPTL+boZh59cBoKQhKHYYOFD8dw
bo2bTRjW3JVinVYojzJiU4RhAZ+oUREeUsEGjinjXc7ihhT8erWKMBvmtvPrdfB2
tgSL9k5MEEYBe/wZSG6LQz5TYpIQO4NWgE386cGY2grEuTzDkj0ErPwQZ+U9DmOW
Zh1tCCgIe4nT++REZQcnsrLwmdqW5opvq/G5I5/eEBjCq8SqEi7+rFLiUD4aYE5H
gqs3vK/g/eFtTIS3AZvx9Pc1xRzZoOH26lYBFfwV+UmdWD2w+smcsc6Ry8DOMZH4
G9MZkKRupkfwxaEavaS4X4ZJ8XU6RWAyjqahSXWnug+0A20rJhSYgrV3W6EogoOk
FjiNi8vUF8nSbahpwje6vHPetblKm0feovDvZsP2/97K9Y9ILKSSqGoFOhsF1QPj
nFcvaSWkO0w547KBaqp9CMCRzvUcmMjGtysr73Hv6U2MfyksV32tVn8NkQ/hbvrg
QlEAP6DWoaC0OmkTUI21Z7glVkzr7fnoSmNsfj6uwBHpneb3yFEtNohH7iqzvA8m
MBg/NYfN0LSIX1BpAHjFIqAOxEtqYS6RIgHy235JIbxpt0ZDHBaczqvz7zjW/eQo
VRtQ0ljzgT8vQh32Lst/
=9YIA
-----END PGP SIGNATURE-----

--PuGuTyElPB9bOcsM--
