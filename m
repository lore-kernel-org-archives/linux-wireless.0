Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:42732 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab3BTRUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 12:20:05 -0500
Date: Wed, 20 Feb 2013 18:19:55 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Antonio Quartulli <antonio@open-mesh.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
Message-ID: <20130220171955.GA1556@pandem0nium> (sfid-20130220_182011_583951_3AB30DB6)
References: <1361197831.8555.23.camel@jlt4.sipsolutions.net>
 <1361197982.8555.24.camel@jlt4.sipsolutions.net>
 <20130218144622.GA4162@open-mesh.com>
 <1361201387.8555.32.camel@jlt4.sipsolutions.net>
 <20130218153833.GB4162@open-mesh.com>
 <1361202206.8555.34.camel@jlt4.sipsolutions.net>
 <20130218154906.GC4162@open-mesh.com>
 <1361203098.8555.35.camel@jlt4.sipsolutions.net>
 <20130218160705.GD4162@open-mesh.com>
 <1361206302.8555.36.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
In-Reply-To: <1361206302.8555.36.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 18, 2013 at 05:51:42PM +0100, Johannes Berg wrote:
> On Mon, 2013-02-18 at 17:07 +0100, Antonio Quartulli wrote:
> > On Mon, Feb 18, 2013 at 07:58:18 -0800, Johannes Berg wrote:
> > > On Mon, 2013-02-18 at 16:49 +0100, Antonio Quartulli wrote:
> > > > On Mon, Feb 18, 2013 at 07:43:26 -0800, Johannes Berg wrote:
> > > > > > I did not like this approach because the sta_info struct is so =
big that
> > > > > > when we want to fill the stats substruct only we will waste a l=
ot of bytes.
> > > > >=20
> > > > > I don't understand your point.
> > > > >=20
> > > > > struct sta_info {
> > > > >    ...
> > > > >    struct stats stats;
> > > > > };
> > > >=20
> > > > My concern is about those "..." that we are allocating within the s=
ta_info struct
> > > > that we will never use for every non-peer station.
> > > >=20
> > > > While if we used the struct below (with its own hash table), we wou=
ld allocate
> > > > only the space needed for the stats.
> > > >=20
> > > > >=20
> > > > > struct stats_entry {
> > > > >    struct hash/list/whatever;
> > > > >    struct stats stats;
> > > > > };
> > > > >=20
> > > >=20
> > > >=20
> > > > no?
> > > > Maybe I misunderstood your idea?
> > >=20
> > > But I'm not saying that these are mutually exclusive, I'm saying both
> > > should exist.
> >=20
> > Ah ok..Sorry, but I did not take this as an option :)
> >=20
> > So, if I understood correctly, this means one table lookup for peer sta=
tions,
> > while two table lookups for non peers (first in sta_hash, which will fa=
il). Right?
> >=20
> > This would save one look up for each peer, since we have to do perform =
one of
> > them anyway (now I fully understood your previous statement!).
>=20
> Right... But the failing sta lookup has to happen anyway, so it really
> adds practically no cost in the peer case, and a singe lookup in the
> "non-peer already exists" case.

To sum from this discussion (I think it's a good idea):

 * embed the stats_entry into the sta_info
 * update peer-stats by modifying the embedded stats_entry (we do the looku=
p anyway
 * keep the non-peer stats in a seperate hash, and only keep stats_entry fo=
r them (we don't need
   the full sta_info after all).

We should consider some corner cases here, e.g. adding stas, then we have to
copy+remove the stats from the non-peer hash, or removing stas, then we have
to copy the so-far collected stats to the non-peer hash.

If you are okay with it, we can use the NL80211_CMD_GET_STATION command
(as in iw station dump), and add a seperate flag to give info for non-peer =
sta.

What about the other commands I suggested (read+reset, start, stop)? For re=
ad+reset,
we could just send yet another flag (RESET_STATS) with the GET_STATION comm=
and, but
for start/stop we would need new commands? Or would you have any better ide=
a?

@Thomas: Is there anything to consider for 802.11s?

Thanks for your input,
	Simon

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlElBbsACgkQrzg/fFk7axZVvgCeM5yOSCnV06KTcx1yWhQ+HntX
QRQAnjG4iw+7wevlGEPvLRnrdxyVr/LT
=97hE
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
