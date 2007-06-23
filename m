Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55748 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbXFWVjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2007 17:39:49 -0400
Subject: Re: [WIP] mac80211: kill mgmt interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <467CD9EC.1020405@warmcat.com>
References: <1182418939.10821.8.camel@johannes.berg>
	 <20070621143558.68fc8e4a@griffin.suse.cz>
	 <1182429920.21939.1.camel@johannes.berg>
	 <20070621151441.500d62d5@griffin.suse.cz>
	 <20070622154545.29eeebdb@griffin.suse.cz>	<467BDCB1.1010604@warmcat.com>
	 <20070622173940.30280046@griffin.suse.cz> <467C003C.30803@warmcat.com>
	 <467CD9EC.1020405@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-a6wsAFO8pUalsMIv1LKF"
Date: Sat, 23 Jun 2007 23:41:15 +0200
Message-Id: <1182634875.21939.114.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-a6wsAFO8pUalsMIv1LKF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-23 at 09:29 +0100, Andy Green wrote:

> I've converted the injection patches and packetspammer[1] to use this
> encapsulation method.  I added
>=20
> #define ETH_P_80211_RT	0x001B		/* Radiotap + 80211 encapsulation */
>=20
> to ./include/linux/if_ether.h to define the new ethtype.
>=20
> My results at the moment are that my encapsulated injected packets are
> dropped before reaching wlan0's dev->hard_start_xmit(), but if I send
> them to a second network interface for the same device configured into
> monitor mode, then they are injected correctly and go out on the air.
>=20
> Any ideas about where to look or what to do about the packets getting
> dropped on wlan0?

Possibly the reframing code simply doesn't udnerstand and thus kills the
packets?

johannes

--=-a6wsAFO8pUalsMIv1LKF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGfZN7/ETPhpq3jKURAiBEAJ4kiU2M+Bf5/jwnrTgbl7itV5K82gCfTpmo
UddGJYQedzB10aUzH7lj3DE=
=D9MD
-----END PGP SIGNATURE-----

--=-a6wsAFO8pUalsMIv1LKF--

