Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:17035 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753884Ab3BRPjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 10:39:32 -0500
Date: Mon, 18 Feb 2013 16:38:33 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
Message-ID: <20130218153833.GB4162@open-mesh.com> (sfid-20130218_163936_674123_8F150723)
References: <20130215171938.GA4140@pandem0nium>
 <1361197831.8555.23.camel@jlt4.sipsolutions.net>
 <1361197982.8555.24.camel@jlt4.sipsolutions.net>
 <20130218144622.GA4162@open-mesh.com>
 <1361201387.8555.32.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
In-Reply-To: <1361201387.8555.32.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 18, 2013 at 07:29:47 -0800, Johannes Berg wrote:
> On Mon, 2013-02-18 at 15:46 +0100, Antonio Quartulli wrote:
>=20
> > In my current implementation I created a "twin hash-table". It contains
> > statistics for *all* the stations (peer and non-peer).
> >=20
> > I think that instead of embedding this new struct (let's call it sta_st=
ats) into
> > the sta_info one, it would be easier to let them be independent (this i=
s why I
> > created the twin hash) and then create
> > a pointer from the sta_info to the related sta_stats.
>=20
> I don't really see value in that, it would only make the implementation
> less efficient, because either you follow another pointer (sta->stats)
> or you have to look in the other hash table. That's why I prefer
> embedding it, we have to do the station hash table lookup anyway.

I did not like this approach because the sta_info struct is so big that
when we want to fill the stats substruct only we will waste a lot of bytes.

I think this is the usual space vs. time tread-off :).
However, since this struct is accessed on the critical path, it may be wort=
h to
save time and go for the "embed" approach. Let's see what the other thinks =
about
it....

>=20
> > For the API I think we should create a new nl80211 command.
> > If we simply add a
> > flag to the normal "station dump" command, we would not have all the at=
tributes
> > to print (keep in mind station dump prints attributes that are in sta_i=
nfo and
> > that are not in sta_stats).
>=20
> station dump can just print all attributes that exist, some stations
> would have more/different attributes than other stations. But I don't
> really think it makes a big difference either way, reusing it would be
> fine if the default is to not include the stats-only entries.

yeah, the default behaviour should remain the same (print peer stations
only).


Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRIkr5AAoJEADl0hg6qKeO6G4P/0xCaTJIQjD8/2/bSeEvCPNr
x6vFTHpKulO963ykQAjp/9pLmuHtXhf4hub5MPMFLERf86oGfIcQqLxviJceDaIW
VLvR1pTN6AkykuRI7C0e9VDBQ4myZ0t71BxzvR4Kyq9RrTUaAKwTZerx7MUZ6waJ
m7rZ9yOE3i7yj80Dkg6tXrQiB15hQ9nVLIH/zhJyXRVWsHUqqPVgQ9iK0Vu0LRnt
0vvR58QctPFBo8IMyLWwbF6B8lHOXEmdtrY693xOsceUjrH7woxa/RG3RGKjro4a
9po/zwHy0qWsIh7KQb9OmkBoKfFIwCIENjjTMmDdNsmspaaC8Ga0sF4CM8lwuffw
JpkZSeAh1CBGHFlYUMQ52cgMr91HMXB2CAHrZK6Ysdse8GWmLh4d55F5CXPy8Cpq
te/iWjA+oxpV3A1YP2cbO6S6NLc3vRrpcrN67gnCpEIV97q3V/ORZLaFrEH756O2
+rho9sItRduTmFxpofeh12m+Wv2jB82B3zpiKkP01CmXyGPwsnIOnqu9FzbjnSut
QgMNP4ZAP14F5XjCGbXaD8h0FYhDuGN7iIZ53tpgBk7MvDkkFcwcb2mHsj45LvZQ
qoaLgsHWFOOCVDnrwmJhfrPzWpkOnCoVOkZc+bDEeZPXf8f7c+yrdHcG/509Y/iH
6fvDB12uCL1MPfms9CS7
=omka
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
