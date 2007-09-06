Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32997 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbXIFOja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 10:39:30 -0400
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ian Schram <ischram@telenet.be>, linux-wireless@vger.kernel.org,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@nbd.name>
In-Reply-To: <1ba2fa240709060731n59d76023s61ac9c6f7152d631@mail.gmail.com>
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070831205524.GA11128@tuxdriver.com>
	 <1188872746.13078.411.camel@debian.sh.intel.com>
	 <1188915229.9942.29.camel@johannes.berg> <46DF5894.70909@telenet.be>
	 <1189080026.28781.58.camel@johannes.berg>
	 <1ba2fa240709060704g4a5044beu298bb1d5ae42703d@mail.gmail.com>
	 <1189088042.28781.86.camel@johannes.berg>
	 <1ba2fa240709060731n59d76023s61ac9c6f7152d631@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f13V008kmjLPb79/cNCA"
Date: Thu, 06 Sep 2007 16:40:47 +0200
Message-Id: <1189089647.28781.93.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f13V008kmjLPb79/cNCA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-06 at 17:31 +0300, Tomas Winkler wrote:

> 11n should cover also legacy rate scaling, and legacy mode in general.

Ok so we just extend the rate control to include .11n, fine with me too.
Have you thought about .11e stuff too? This seems related (aggregation
etc)

> We have solved that it just as I said it is not rebased  against
> latest wireless-dev so you don't see this code. I will probably
> release some RFC patches first so nobody will accuse me of selling FUD
> :)

Sounds good :)

> > > Third part and this is 4965 specific is that  TX rate is not attached
> > > to packet but rate table is updated when need on it's own path. This
> > > is device specific.
> >
> > It seemed like the rate was attached to each station. This is a bit and
> > I don't really know how to handle it.

> ???

Well some comments in the code say that the rate retry stuff is attached
to the notion of station the firmware has. If so, this will most likely
require some different interaction between rate control/firmware rather
than just the rate control passing you the rates with each frame.

> > > Forth is that the aggregation. In general this involves some handshak=
e
> > > on protocol level i.e. MLME but efficiency of aggregation is kind of
> > > rate scaling decision in addition  it might be enabled only for MIMO
> > > rates (different plcp header)
> >
> > Right. I think you mentioned aggregation as number two already :)
> >
> Number 2 is the rate scaling update path this is rate scaling decision pa=
th

Oh, ok. I think you need to elaborate on the split into these paths
though, I don't think I've fully understood it yet.

> In legacy TX it will be the same as current implementation, actual
> rate, number of retries, etc
> For aggregation it need rate and number of packets ACKed and NACked.

Right.

> The whole aggregation is sent in one rate. Theoreticaly multi rate
> aggregation might be sent, but no vendor creates such radios yet.

We can add it when we need it then.

> > > 3. rs_compute(sta/sta_addr) - actual computation of rate scaling
> > > algorithm possible also from RX path (tx reclaim)
> >
> > Where would it be called?
>=20
> This can be run in reclaim path (RX) as now  but for 4965 I would
> create period work

Basically we have three paths:
 (1) tx
 (2) rx
 (3) tx status (tx reclaim)

I suppose you're thinking of TX reclaim here? Which is sort of like
RX-ack but I think of it as related to TX. If we can handle the decision
about aggregation in higher layers shouldn't the periodic work also be
in mac80211?

> Sure, the rates themselves. Currently I have in vision only 4965 rate
> table. Need to find something more general probably.

Yeah I'm not aware what it does there. If you can describe what your
hardware does I can possibly compare a bit to Broadcom (partially
started to reverse engineer it) and then see if we can come up with
something more generic.

johannes

--=-f13V008kmjLPb79/cNCA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4BFv/ETPhpq3jKURAjRtAJ0RNlWsHoI3Ud68tTrCI3TfRcO6AgCfVPa6
gFtlNFC4UnP5PQNA2EQaKwM=
=MMr2
-----END PGP SIGNATURE-----

--=-f13V008kmjLPb79/cNCA--

