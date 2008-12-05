Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbYLEJpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 04:45:19 -0500
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <rogge@fgan.de>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Henning Rogge <hrogge@googlemail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812050934.07182.rogge@fgan.de>
References: <200811252131.30161.hrogge@googlemail.com>
	 <20081204211201.GL5970@tesla> <1228425635.5692.49.camel@johannes.berg>
	 <200812050934.07182.rogge@fgan.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8OWc4g6JPCANrSNFZNc+"
Date: Fri, 05 Dec 2008 10:45:10 +0100
Message-Id: <1228470310.3970.13.camel@johannes.berg> (sfid-20081205_104524_684303_12CCCBE8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8OWc4g6JPCANrSNFZNc+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-05 at 09:34 +0100, Henning Rogge wrote:
> Am Thursday 04 December 2008 22:20:35 schrieb Johannes Berg:
> > On Thu, 2008-12-04 at 13:12 -0800, Luis R. Rodriguez wrote:
> > > It seems that's the case for ath9k, at least Jouni had pointed out to=
 me.
> >
> > They cannot, we don't even have that in the API.
> Ath9k has it's ***_ratetable which contains a line of data for each=20
> transmission range. 20/40Mhz and guard interval is already contained in t=
his=20
> table (encoded in "phy" variable). Just the MCS number is missing.

Well, yes, but it's not done uniformly across drivers.

> And I think the intel driver has the necessary data too. If I understand =
the=20
> iwl5000 driver, it pushes the rate index (even for 802.11n) through=20
> ieee80211_rx_status into mac80211.

Sort of, yes, but again, in a much different way. We really have to
rename struct ieee80211_tx_rate to struct ieee80211_txrx_rate and embed
it into struct ieee80211_rx_status for doing this properly.

> > > > then we also don't need the values for the number of streams since
> > > > those are perfect multiples (1x, 2x, 3x, 4x for up to 4 streams).
> > >
> > > Well if you have the MCS index and HT mode you get the # of streams. =
Not
> > > sure I understood the perfect multiple stuff.
> >
> > Right, but you don't need to store a bitrate for MCS 0, 8, 16 and 24,
> > the latter three can just use the first multiplied by 2, 3 and 4
> > respectively.
> When I looked at the table in the wiki I noticed it cannot be created jus=
t by=20
> a little bit arithmetric ? Maybe someone can look at the 802.11 draft if =
we=20
> don't need the tables at all but just use a formula ? If yes we could rem=
ove=20
> them from kernelspace and just add a macro for calculating the rate into =
a=20
> userspace-accessable header file.

I checked for a bit, but it's not trivial. Cf.
http://www.dsprelated.com/showmessage/92947/1.php

> > > > and then nest the bitrate information into the STA_INFO_RATE, just =
like
> > > > station flags are nested etc. That way the RATE_INFO things could a=
lso
> > > > be used elsewhere.
> > >
> > > So we'll have to add an enum then too to distinguish which rate this =
is
> > > for.
> >
> > No, we know that based on what "container" attribute it's contained in,
> > in netlink.
> So it's possible to define a substructure in the station info in nl80211 =
?=20
> Sounds like a nice way to construct the tx/rx rate.

Yes, you do that by nesting. nl80211 already does that for phy info and
many other things, you should be able to figure it out, just look for
nla_nest_start/nla_nest_end.

> I will see if I get a "v6" patch ready during the weekend.

Thanks!

johannes

--=-8OWc4g6JPCANrSNFZNc+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOPgjAAoJEKVg1VMiehFYnvwQAIXxOtDyac1V2VOmNLBK/Ngt
F5c9Lny/Nx+M978dtBf3GxKBV1bc/SXNrO4cfQ2WW8xlS+80ww5d0lmaVGAHsgWi
wXoG98s8QQMOaczhWXkQNP8n6rKe7zojgOf9Z3sQ3CEdh3bL1kaE9XLNxXQh+AaQ
W62Jv7S2P0sOy11m/FhlY3eKxwHoJqO1IdberNCAxscqrHQlY4oVvRyn5WhBLxvD
WBPWB8r0Ihe5n1wHB4HIx6XTaad5pPnecIRSgBU/4dv9iZV/8DN1dqZk0yDCPLW4
Z//LqgsupXopXJLgl+DgPpKQTyt+n+wTcI7f9vEFvM+p/O6HC/vPpJQ/gvhwk7C1
Jzq1CpxDuDSAmGrYWgQWacQ8KZv/QHGmPBu64OwGcwMuWLWaZ4LL8UoxkKjZKSdr
gHyaTKD7Z4R05l0mX9q4Q/et4eCCsDtPb25XLrCNQmyysEK8u64987W4R9ppGoij
GYtVAA+InfAZHwWlVWTv+DikMAG2ZCTTRn3UYS/Bjoo97YdiN1QcVlZoQQjE/lGi
HmB6VF9+DOLb0sGOaB4Ayk+NdV8LogYRHXQCRP3anxJK25V3ArYDChiWnQgj3NE+
oI2uSRNRBZ7rYYpxnfZkogHCDSGmtjxvOIovyE2/POXJY5xNU3BUCI5T+SNjDnq1
E6NXVx7wKZ0X4gSGRQoS
=iPDs
-----END PGP SIGNATURE-----

--=-8OWc4g6JPCANrSNFZNc+--

