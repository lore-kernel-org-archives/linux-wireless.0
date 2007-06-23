Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbXFWVtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2007 17:49:39 -0400
Subject: Re: [WIP] mac80211: kill mgmt interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <467D10BA.80104@warmcat.com>
References: <1182418939.10821.8.camel@johannes.berg>
	 <20070621143558.68fc8e4a@griffin.suse.cz>
	 <1182429920.21939.1.camel@johannes.berg>
	 <20070621151441.500d62d5@griffin.suse.cz>
	 <20070622154545.29eeebdb@griffin.suse.cz>	<467BDCB1.1010604@warmcat.com>
	 <1182526221.21939.94.camel@johannes.berg>
	 <20070622174953.500817e0@griffin.suse.cz>
	 <1182543620.21939.98.camel@johannes.berg>	<467CB691.2090806@warmcat.com>
	 <1182581630.21939.105.camel@johannes.berg>
	 <20070623134451.643dd40c@logostar.upir.cz>  <467D10BA.80104@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3e1nvbqxLdYtjZY4cMYC"
Date: Sat, 23 Jun 2007 23:51:07 +0200
Message-Id: <1182635467.21939.125.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3e1nvbqxLdYtjZY4cMYC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-23 at 13:23 +0100, Andy Green wrote:
> Jiri Benc wrote:
> > On Sat, 23 Jun 2007 08:53:50 +0200, Johannes Berg wrote:
> >> Who started this anti-nl80211 thing anyway? I still don't see what's s=
o
> >> wrong with sending frames down a PF_NETLINK socket rather than a
> >> PF_PACKET socket.
> >=20
> > Perhaps it was just my misunderstanding about the monitor interface tx
> > injection patches; I though this mechanism should be used for hostapd a=
nd
> > user space MLME, which I consider wrong. Johannes' comment about differ=
ent
> > needs (and thus having both injection through monitor iface and through
> > netlink) makes perfectly sense, though.
> >=20
> > Andy, is using a monitor interface (for both injecting and receiving of
> > frames) acceptable for you? If yes, let's drop my proposal (I said it m=
ight
> > turn up to be useless :-)), apply patches for monitor iface injection a=
nd
> > implement a netlink soultion as a replacement of the current management
> > interface.
>=20
> Yes the existing Monitor Mode Try #13 is fine for me and the userland
> projects I know about,=20

:)

> but actually I quite liked your encapsulation
> thing -- in itself is compatible with working in any mode.  The only
> problem with it right now is that it seems when mananged mode interfaces
>  are not associated, they are in a netif_carrier_off() state or similar.

Oh, good point, I forgot about that in my other reply. Yeah, we really
want to go to IFF_DORMANT too and that really stops us from doing
anything. Also, if we do QoS on the interfaces then the qdisc might end
up dropping our packets if we don't do special hacks around that, again
something we cannot accept.

johannes

--=-3e1nvbqxLdYtjZY4cMYC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGfZXL/ETPhpq3jKURAplAAJ9fLLf8WmmxIsUrl7OfhJzf7HXi4wCgrpKI
Yfc7LDhnmK9HqGS5bC9arF4=
=ZhfL
-----END PGP SIGNATURE-----

--=-3e1nvbqxLdYtjZY4cMYC--

