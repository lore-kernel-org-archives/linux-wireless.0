Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51630 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXFWVrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2007 17:47:06 -0400
Subject: Re: [WIP] mac80211: kill mgmt interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <467CE130.2080306@warmcat.com>
References: <1182418939.10821.8.camel@johannes.berg>
	 <20070621143558.68fc8e4a@griffin.suse.cz>
	 <1182429920.21939.1.camel@johannes.berg>
	 <20070621151441.500d62d5@griffin.suse.cz>
	 <20070622154545.29eeebdb@griffin.suse.cz> <467BDCB1.1010604@warmcat.com>
	 <1182526221.21939.94.camel@johannes.berg>
	 <20070622174953.500817e0@griffin.suse.cz>
	 <1182543620.21939.98.camel@johannes.berg>  <467CB691.2090806@warmcat.com>
	 <1182581630.21939.105.camel@johannes.berg>  <467CE130.2080306@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TEsFXOkthTIHb0rqCFf7"
Date: Sat, 23 Jun 2007 23:48:33 +0200
Message-Id: <1182635313.21939.122.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TEsFXOkthTIHb0rqCFf7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-23 at 10:00 +0100, Andy Green wrote:
> Johannes Berg wrote:
>=20
> > On the other hand, I do consider userspace MLME needs slightly
> > different; it needs to be able to have frames encrypted, needs to see
> > frames that have been decrypted even though they would otherwise be
> > dropped [and this is very different to what you want], and probably
> > more.
>=20
> Fair enough, but injection is a separate issue from RX, despite one
> usually needs both.  That there is no standard way to inject on
> mac80211, regardless of the RX situation is a major lack.  If injection
> is not treated as a separate valid action then it will constantly be
> delayed as part of some larger effort, when it is valuable in itself.

Don't get me wrong, I fully support your patches. I can see usefulness
in what you're doing there, I even based my recent patch-frenzy on top
of your patches ;) But I'm not fully convinced that this will be the
best path for the userspace MLME (in whatever form); I do however think
that it is the best option for wireless analysis/hacking/... tools or
something like your penumbra.

> But Jiri's encapsulation method is an improvement if it can be
> implemented okay for unassociated interfaces and so on.

Not convinced; it solves only a minor part of the problem, the hard
things aren't solved (like that we need to see the decrypted frames that
would normally be dropped by the kernel). Hence, I don't see any value
in it by itself without solving the harder parts as well (or better even
first), when solving that may end up using netlink for frames anyway.

> I don't have anything against it, but for me the packets I am injecting
> are normal network traffic and sending them like that seems the most
> natural way.  For RX down in userspace it is marginally simpler to use
> libpcap monitoring and the same handle for injection and rx.

Right; I see that your situation wildly differs from the userspace MLME
and that in that situation this is the best and easiest thing to do.

>  I
> definitely think having two paths to injection is not necessary, but for
> splitting out normally invisible management packets to go down a
> separate netlink socket instead of encapsulating them I don't mind
> either way.

I think what we need to accept is that the long-touted concept of a
"userspace MLME" isn't really that, while it's dead simple to do
*everything* in userspace by using a monitor interface with injection
and then a tun interface that isn't really what we want. We want to push
parts of the complexity to userspace while still having it
kernel-assisted for various reasons like performance.

johannes

--=-TEsFXOkthTIHb0rqCFf7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGfZUx/ETPhpq3jKURAjHbAJ0a6RXnA9icCrHVs0L7BjTfsyWisQCcCV0e
QZgOhpT4yvSpl38N4VO/JiY=
=NATs
-----END PGP SIGNATURE-----

--=-TEsFXOkthTIHb0rqCFf7--

