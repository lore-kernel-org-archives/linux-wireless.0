Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42673 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759193AbXIXVfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 17:35:07 -0400
Subject: Re: API to regulatory control (1)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <43e72e890709241255v1f044f9dh4af1e00fcaba03b0@mail.gmail.com>
References: <1190456574.18521.220.camel@johannes.berg>
	 <43e72e890709221416o25bf3287v5d8d7bb5c2fe15ab@mail.gmail.com>
	 <1190624554.18521.261.camel@johannes.berg>
	 <43e72e890709241255v1f044f9dh4af1e00fcaba03b0@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2Emrpt7FV/acUnbOYXH6"
Date: Mon, 24 Sep 2007 23:36:23 +0200
Message-Id: <1190669783.18521.301.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2Emrpt7FV/acUnbOYXH6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-24 at 15:55 -0400, Luis R. Rodriguez wrote:

> > But I then thought we'd be calling this function a lot during scanning
> > so discarded this idea. However, with all the complexity here, maybe we
> > can revive it and provide some sort of "for each allowed channel" loop
> > or something too.
>=20
> At scan time we can just check the channel flags, those are always
> supposed to be up to date if cfg80211 is in charge of updating all
> wiphys with the new rules upon regulatory domain change.

Right, that's why I figured we should have them, I was considering
discarding them to make the structure smaller.

> No, you're right, It seems like we don't, yeah I don't think we do..
> but I was just basing the model on the current mac80211 driver API,
> which does have modes... if we are going to get rid of struct
> ieee80211_hw_mode this is a pretty serious cleanup on the both
> mac80211 and driver side. It'll be good, make driver code smaller but
> it seems like a lot of work right now.
>=20
> Hmm, it seems if we take this approach we'll need to stage this into
> separate development parts to not cause too enforce too many changes
> on drivers. Instead of the 2-series I suggested how about 3 series:
>=20
> * I - Introduce new regdomain modules integrate with cfg80211
> * II - Minimal mac80211 support with current driver infrastructure
> * III - Start optimizing to remove all unnecessary materials
>=20
> We may just want to go directly to series III but based on the amount
> of complaints from current driver writers I think its best to use 3
> stages for this... Comments?

I dunno. Did we get that many complaints? I think the filter flags
change went rather well. In any case, I don't really have a plan and I
don't see how we can change any of this without breaking drivers at
least once.

> We introduce very specific rates for each mode which drivers can use
> for the minimal support from what we know IEEE-802.11 defines.. Then
> we can simply use the current mode/rate work for vendor modes and
> vendor rates? We have the part of the code already, we just need to
> adjust it. This will make introduction a lot easier too. If the driver
> doesn't use specify its using the 'stack' modes an rates, we can then
> check its linked list of modes.

Not sure. Some drivers actually do need the hardware-specific value in
the struct there that was pass around when setting channel/rate. Also,
vendor-modes really has more a problem of the userspace API rather than
the in-kernel API.

> Scanning won't require this update if we can assume a driver's channel
> list flags are *always* up to date. Since cfg80211 is in charge of
> updating the central regdomain it wil *know* when it gets updated and
> as such can, for example, 'lock' the channel structs. This will assure
> we don't allow channel change, scan, or any other nasty thing which
> may break regulatory laws, during a regulatory change. Note that
> regulatory domain change should be a rare thing though :-)

Obviously.

>=20
> > > > At this point, however, the regulatory agent API only starts. First=
 of
> > > > all, the channel list has already been registered with cfg80211 bec=
ause
> > > > a pointer is part of struct wiphy
> > >
> > > If we take this approach, sure.
> >
> > No need to, of course, we could register it explicitly as well.
>=20
> I think we'll need a writeup of what we want and agree on it as a path
> to take so everyone is on the same page.

Well I see basically two options:
 * register it with each wiphy and document that you can re-use the same
   array if you wish because it's updated only in an idempotent fashion
   (i.e. two updates don't matter)
 * register the array structure itself

> > Well, I think it's not too important when you think of channels, but sa=
y
> > you have an AP open and for some reason move into a new regulatory
> > domain, the TX power might need to be adjusted. This isn't important,
> > but implementing the hook to allow (notifier chain) is trivial so I
> > figured we might as well do it.
>=20
> ACK -- but, since cfg80211 *can* be in charge of updating the, either
> central channel struct, or each driver's channel struct, we can also
> have it update power restrictions upon regulatory domain change. Same
> as above. What do you think?

Well, but the driver must actually change the power level and hence it
must be notified of the change after it has occurred so it is able to
adjust. I don't think I want to call into some cfg80211 call for this, a
specific notifier seems more appropriate.

> Oh sure. Unless we want to be freaks and support different regulatory
> domains for each device... This may apply later for Software Defined
> Radios.. but not for now ;)

Why would that be a different domain? It'd be a different set of
restrictions but I don't think you can really manage to have a machine
in two countries at the same time, physically :) [corner cases with
directional antennas excluded]

> Well I think we can come to a compromise. If we use the strategy above
> of moving modes to 'vendor_modes' and add a central mode, with the
> option of letting the driver specify it it wants to use the central
> modes, we can move any driver slowly at any time to the new API
> without breaking a single thing.

Aha, but I don't think that strategy can work since there's this
hw-specific value in the structs. But I already said that above.

johannes

--=-2Emrpt7FV/acUnbOYXH6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+C3X/ETPhpq3jKURAllHAJ9Efkls+s3hKlDj7IIYLpEtprtqEACggMzC
FISB/AUxKDh7ktgHGN43nLs=
=Ft7S
-----END PGP SIGNATURE-----

--=-2Emrpt7FV/acUnbOYXH6--

