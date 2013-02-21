Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:49366 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab3BURTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 12:19:42 -0500
Date: Thu, 21 Feb 2013 18:19:34 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <antonio@open-mesh.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
Message-ID: <20130221171934.GA6662@pandem0nium> (sfid-20130221_181956_097140_85FDF6A3)
References: <20130218144622.GA4162@open-mesh.com>
 <1361201387.8555.32.camel@jlt4.sipsolutions.net>
 <20130218153833.GB4162@open-mesh.com>
 <1361202206.8555.34.camel@jlt4.sipsolutions.net>
 <20130218154906.GC4162@open-mesh.com>
 <1361203098.8555.35.camel@jlt4.sipsolutions.net>
 <20130218160705.GD4162@open-mesh.com>
 <1361206302.8555.36.camel@jlt4.sipsolutions.net>
 <20130220171955.GA1556@pandem0nium>
 <CAG6hwVPF_kvqCOtWJTWpLChOGbo+P8Du=y6Js0MDiF19_QR=ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
In-Reply-To: <CAG6hwVPF_kvqCOtWJTWpLChOGbo+P8Du=y6Js0MDiF19_QR=ag@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 20, 2013 at 11:10:14AM -0800, Thomas Pedersen wrote:
> Hi Simon,
>=20
> On Wed, Feb 20, 2013 at 9:19 AM, Simon Wunderlich
> <simon.wunderlich@s2003.tu-chemnitz.de> wrote:
>=20
> > To sum from this discussion (I think it's a good idea):
> >
> >  * embed the stats_entry into the sta_info
> >  * update peer-stats by modifying the embedded stats_entry (we do the l=
ookup anyway
> >  * keep the non-peer stats in a seperate hash, and only keep stats_entr=
y for them (we don't need
> >    the full sta_info after all).
> >
> > We should consider some corner cases here, e.g. adding stas, then we ha=
ve to
> > copy+remove the stats from the non-peer hash, or removing stas, then we=
 have
> > to copy the so-far collected stats to the non-peer hash.
> >
> > If you are okay with it, we can use the NL80211_CMD_GET_STATION command
> > (as in iw station dump), and add a seperate flag to give info for non-p=
eer sta.
> >
> > What about the other commands I suggested (read+reset, start, stop)? Fo=
r read+reset,
> > we could just send yet another flag (RESET_STATS) with the GET_STATION =
command, but
> > for start/stop we would need new commands? Or would you have any better=
 idea?
> >
> > @Thomas: Is there anything to consider for 802.11s?
>=20
> I can't think of anything that would be specifically useful for
> 802.11s right now, and we can always extend the statistics in the
> future. One case where this might be useful is if the driver has a
> limited number of station slots, the MPM could monitor neighbor
> stations for a more "suitable" peer candidate, but your existing stats
> should cover that.

OK, that sounds good. If there are any other requirements we should conside=
r,
please let us know.

>=20
> Turning on this feature would add some sort of (internal to mac80211)
> monitor interface, or just disable all frame filters on a given PHY?
> How does it work now?

Right now we use a monitor interface to get frames from other BSS and
signal info via radiotap. I'm not sure yet if any "virtual" monitor
interface or disabling RX filters is required. If anyone has a good idea
please let me know, otherwise I will try out.

Thanks,
	Simon

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEmVyYACgkQrzg/fFk7axZsOgCaA51F28bILu76hdKA9YvlcHoE
OcgAoJJ5ZEq4HK6ZirKhNUXdC3Osvq/R
=9NNN
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
