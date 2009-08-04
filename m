Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbZHDGz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 02:55:59 -0400
Subject: Re: [DISCUSS] Implement non standard channel widths
From: Johannes Berg <johannes@sipsolutions.net>
To: Pat Erley <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A77D1F5.5050706@erley.org>
References: <4A74D5F5.8090409@erley.org>
	 <1249201869.2007.45.camel@johannes.local>  <4A77D1F5.5050706@erley.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XdEE+J6UOjWNnzaNSar/"
Date: Tue, 04 Aug 2009 08:55:26 +0200
Message-Id: <1249368926.4561.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XdEE+J6UOjWNnzaNSar/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-04 at 02:15 -0400, Pat Erley wrote:

> > Also keep in mind that there _are_ standard uses for smaller bandwidth
> > channels, Jouni has helpfully collected them on
> > http://wireless.kernel.org/en/developers/Documentation/ChannelList
>=20
> Yeah, I fully understand that there are other frequency ranges that this
> will be useful in.  My actual goal is using it in the 900mhz spectrum.

Right. But then I think your hw can _only_ operate in 900mhz, so I
suppose you're just saying 'channel 5' anyway, and the hardware has an
offset of, say, 1500 MHz.

> Great, Thanks for the input.  I'm busy tonight, but I'll take a look=20
> tomorrow and try to start this, at least in a pseudo mock-up.  I have
> a basic idea how I'll attack this:
>=20
> 1. add bitfield
> 2. duplicate all functionality as pertains to bitfield
> 3. update drivers to use bitfield/export their supported modes
> 4. remove old functionality, rename bitfield
>=20
>=20
> That of course simplifies the actual amount of work it encompases, but
> I believe going with this sort of approach will prevent breaking git
> bisection.

As long as you do it all in one go it won't break bisection either, but
you're welcome to do it this way instead :)

> Would we want the bitfield sparse, to allow for the insertion of other
> modes of operation we hadn't thought of?

I think so, yeah.

>   Also, should it be used like
> how the NL80211_IF_TYPE_* flags are used, in that ALL supported features
> should be added if it's to be used?  Specifically, we're going to assume
> that if a driver exports it's supported modes, it will include stuff like
> NO_HT if it supports operation without HT (which I think ALL devices that
> comply with the 802.11{a,b,g,n} specs would support.  It should probably
> be a long term goal to then add this to all drivers, period, so that
> we won't have to make any assumptions about what a driver supports from
> the mac80211 layer. =20

Yes. I just think that's a HUGE amount of work to be doing, hence
proposing the "if (types =3D=3D 0) types =3D ..." thing. That way only driv=
ers
who need the new channel types need updating, and we can print a message
there asking drivers to be updated, or so. You could even print the
driver name by following the wiphy's parent device, if present :)

> Also, would we want to add a log message when switching from/to=20
> non-standard operating modes?  Something like have a bit that marks the
> highest standard mode, then any additional modes(currently 5/10 mhz only
> could later be extended to adding HT/bonding/xspan in narrower channels)
> would come after that and have something like:
>=20
>=20
> if(mode > MAX_OPMODE)
> 	printk(some facility, "Switching to opmode %s "
>                               "which is not standardized", mode);
>=20
> (Of course, greatly simplified).

I don't know -- most of these modes _are_ (being) standardised.

The biggest issue I see is scanning -- but that currently gives you the
frequency list, so I guess we could extend that to pass the frequency
and channel width, and assume 20mhz if not given. Unfortunately, I used
an array of u32's there so we'd need to introduce a new nl80211
attribute for that.

Also, the channel passed to scan results needs to include the width, so
we don't try to connect to a 20mhz BSS with 5mhz channel width.

johannes

--=-XdEE+J6UOjWNnzaNSar/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKd9tbAAoJEODzc/N7+QmaOI4P/2kN+OdKeR6pdgauXmSTggr6
8HRu0IqKebebBKHzzolq77aGOba660bnB7Ce3CEwHIxzHJw+StBcoQ2EreCoDFSg
wOq2Wji47U9gQ5JFK61WS74J9Xr0WN7NPCeW+WZUI/jD4jyyDTIkPvfrTQcKiaPx
5KZzst0DSptCgoLCKLM4uvirwoYnJtJU+CmqkCCDnMypkXuaZbYs+k6Akht6utZR
HjBxlQIcpzUfVLKODXWQXrq/9SBqRZuU+KiAeEAcnWxJzkqTK5VnBcLolXka35lU
5606Ej/Vn75Xm6qoTf3Gc3Yg8QYIME0tzfqMVIH2jQ+xe/8t2b2avM7bQkFVFQcB
xgp9Wtt9/NsGLiAH2eDJCCljM+SA8ZbGSAUsNKqr8UW2Td/FDfy3cMVi66uPsy2T
MtRKR3OsVLHoCFd2e3Ppfjlw1J4tOtt3nxgIZLkPKwV2ASDomx38NRUGfgBAtvCF
OqaPDAvsYHzswJzXlMaMb+A0D1YFtrA3BlrqTXrx7+woQW/VVBE27boxo+PHes6A
qaArllcLqGWJ25U+GvfC3vZgFfTdqQSwpwM0VmgZvYyqfX7RocWRS+d512LlP+Dt
InLnQgacfBmpDhqKDJVm2DggIV0M2ahdDzPC5Rd3ZHUfNUv1s3wpyjYknQfwcJxb
KV7N/R34ny5QNXSsOjfM
=Ybbr
-----END PGP SIGNATURE-----

--=-XdEE+J6UOjWNnzaNSar/--

