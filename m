Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48208 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbXIFOMp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 10:12:45 -0400
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ian Schram <ischram@telenet.be>, linux-wireless@vger.kernel.org,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@nbd.name>
In-Reply-To: <1ba2fa240709060704g4a5044beu298bb1d5ae42703d@mail.gmail.com>
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070831205524.GA11128@tuxdriver.com>
	 <1188872746.13078.411.camel@debian.sh.intel.com>
	 <1188915229.9942.29.camel@johannes.berg> <46DF5894.70909@telenet.be>
	 <1189080026.28781.58.camel@johannes.berg>
	 <1ba2fa240709060704g4a5044beu298bb1d5ae42703d@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-icJ/J2Gxrd4S7T0uA69r"
Date: Thu, 06 Sep 2007 16:14:02 +0200
Message-Id: <1189088042.28781.86.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-icJ/J2Gxrd4S7T0uA69r
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-06 at 17:04 +0300, Tomas Winkler wrote:

> There is nothing NOT general in 3945 rate scaling algorithm just the
> current interfaces of rate scaling algorithm is a bit awkward, not
> extensible. The struct ieee80211_tx_status is tight to mac80211 and
> not to rate scale algorithm so if you create your own crazy rate scale
> algorithm you cannot decide what parameters you need.

Yeah, I agree, we need to improve this. "minstrel" really wants more
retry rates too than just two.

> 4965 is 11n card and rate scale algorithm is totally different.
> One aspect is that rate scaling works  with much more parameters. MIMO
> rates are rather 2 dimensional table, therefore the algorithm is
> essentially different, but so far no interface change is needed.
> Actually it covers also legacy rate scaling.

Right. Maybe we can orthogonalize this into a rate control interface
for .11n and one for "legacy"?

> The second aspect of HT is the aggregation. Bunch of packets at once
> and they are also ACKed at once so regular TX status path of updating
> rate scale algorithm is not so natural. Mostly because it is combined
> with reclaiming the packet.

This is something you need to work on in mac80211 anyway. I don't like
how your driver does all the decisions about when to aggregate etc. This
should be in the per-sta code in mac80211.

> Third part and this is 4965 specific is that  TX rate is not attached
> to packet but rate table is updated when need on it's own path. This
> is device specific.

It seemed like the rate was attached to each station. This is a bit and
I don't really know how to handle it.

> Forth is that the aggregation. In general this involves some handshake
> on protocol level i.e. MLME but efficiency of aggregation is kind of
> rate scaling decision in addition  it might be enabled only for MIMO
> rates (different plcp header)

Right. I think you mentioned aggregation as number two already :)

> 1. rs_update_event(sta, struct rs_data *)  - function that brings rate
> scaling statistics not connected to packet reclaim path
>   struct rs_data is specific to rate scaling and opaque to mac80211

What sort of statistics would it bring, and when?

> 2. rs_add_sta/rs_init(sta)  - create new instance of rate scaling for
> added station including AP in STA mode

That's what we have now afaict.

> 3. rs_compute(sta/sta_addr) - actual computation of rate scaling
> algorithm possible also from RX path (tx reclaim)

Where would it be called?

> 4.  rs_get_rate - for regular TX path setting of rates

Right.

> 5. void (*rs_apply_rates)(sta_addr)  - driver supplied handler for
> applying rate not through TX path.

This needs more parameters, no?

johannes

--=-icJ/J2Gxrd4S7T0uA69r
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4Asq/ETPhpq3jKURAqv0AJ4nwIn7PaArpAoQrWCvzngBCLsqfwCgu2V4
cmrCoX0Jv9X0UGoKoRnRtiU=
=lRz0
-----END PGP SIGNATURE-----

--=-icJ/J2Gxrd4S7T0uA69r--

