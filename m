Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764785AbXHXKJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 06:09:07 -0400
Subject: Re: [RFC 06/11] mac80211: remove HW_KEY_IDX_INVALID
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200708232301.17562.mb@bu3sch.de>
References: <20070823164500.998912000@sipsolutions.net>
	 <20070823164523.418272000@sipsolutions.net>
	 <200708232301.17562.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WFzpXERsSEZcMwJhjTmW"
Date: Fri, 24 Aug 2007 12:09:02 +0200
Message-Id: <1187950142.24933.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WFzpXERsSEZcMwJhjTmW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-23 at 23:01 +0200, Michael Buesch wrote:
> On Thursday 23 August 2007 18:45:07 Johannes Berg wrote:
> > longer relies on HW_KEY_IDX_INVALID either this removes it, changes
> > the key index to be an integer in all places and makes the full
> > range of the value available to drivers.
>=20
> Why's that needed? It increases the tx control struct size,
> which is created and destroyed with every packet.
> Isn't 127 keys enough? If not, probably do a s16. But I think
> an int if overkill.

Ah, but it's an int in the key_conf structure. I'm fine with making it a
u8 in both places too.

johannes

--=-WFzpXERsSEZcMwJhjTmW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGzq4+/ETPhpq3jKURApplAKCBqzVMuddz6Eb4yCD8gZ0eDy5bQwCfZmIy
1ds7OHzSz8DeFDVGrivCMGE=
=LL3T
-----END PGP SIGNATURE-----

--=-WFzpXERsSEZcMwJhjTmW--

