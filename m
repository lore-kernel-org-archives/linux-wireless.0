Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859AbXFQJKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jun 2007 05:10:22 -0400
Subject: Re: [RFC PATCH] bcm43xx QoS support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	Joseph Jezak <josejx@gentoo.org>
In-Reply-To: <1ba2fa240706161630r1fdb2ac1m87039a088c7d6bfd@mail.gmail.com>
References: <200706161328.53726.mb@bu3sch.de>
	 <1ba2fa240706161438lfd629e4j7317bb62340c82a3@mail.gmail.com>
	 <1182032257.23681.1.camel@johannes.berg>
	 <1ba2fa240706161630r1fdb2ac1m87039a088c7d6bfd@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cP+5Z+K5seoVV3WygVkI"
Date: Sun, 17 Jun 2007 11:10:44 +0200
Message-Id: <1182071444.23681.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cP+5Z+K5seoVV3WygVkI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-06-17 at 02:30 +0300, Tomas Winkler wrote:

> > > There is also a discussion about supporting hardware queues in qdisc
> > > in netdev.
> >
> > Which isn't really a concern to the driver since only mac80211 will nee=
d
> > to be changed for that.
> >
> I'm not sure it's only mac80211 problem as driver is responsible for
> stopping and waking up the queues. Only driver knows whether hw queue
> is full or not.

Of course, but we already have that API in mac80211, hence well-written
drivers already tell mac80211 about it so all we'd need to do is change
mac80211 to tell the net layer :)

> > I suppose the question is: what are we missing in mac80211 now? It seem=
s
> > that we have no way of sending out QoS-data frames and that seems weird=
..
>=20
> QoS frame are send just fine by mac80211 (at least under iwlwifi),
> only the sequence numbers has to be overwritten in driver since the
> current handler doesn't advance them per TID.

Oh, you're right, I missed that wme_qdiscop_enqueue does that.

> > Nor do we parse TXOP information etc. Possibly this is because we
> > support WME and that's based on an early 802.11e draft?
>=20
> I addition wme.c qdisc scheduler is rather naive one, it only
> statically assign priorities, it wouldn't pass WMM certification I
> guess.

I have no idea what WMM certification contains. All I've been trying to
say is that this area really needs some work to be useful.

For the problem at hand, namely some QoS support in bcm43xx, we'll just
have to hardcode some QoS parameters for now, I'd think, but I don't
know what those would be.

johannes

--=-cP+5Z+K5seoVV3WygVkI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGdPqT/ETPhpq3jKURAmaAAJ9sorbZEI0qjh7ErTtibh6zDwsvQgCePTlX
YEnNxuR8Y4BWJrpYgMrd4vc=
=L2uH
-----END PGP SIGNATURE-----

--=-cP+5Z+K5seoVV3WygVkI--

