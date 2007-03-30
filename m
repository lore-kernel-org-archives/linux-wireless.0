Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58029 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945972AbXC3KiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2007 06:38:24 -0400
Subject: Re: cfg80211 wext compat w/o wext code changes, rtnl locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	James Ketrenos <jketreno@linux.intel.com>
In-Reply-To: <200703301211.05261.mb@bu3sch.de>
References: <1175122815.8807.21.camel@johannes.berg>
	 <200703301211.05261.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-b/gPFxq4OCwGfyPamR2a"
Date: Fri, 30 Mar 2007 12:37:31 +0200
Message-Id: <1175251051.19085.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-b/gPFxq4OCwGfyPamR2a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-30 at 12:11 +0200, Michael Buesch wrote:
> On Thursday 29 March 2007 01:00, Johannes Berg wrote:
> > -			if(handler !=3D NULL) {
> > +			if (handler) {
> > +				if (!dev->wireless_handlers->no_locking)
> > +					rtnl_lock();
>=20
> Is sparse OK with this conditional locking?

I also thought it wasn't but it didn't complain. The only reason why I
didn't just duplicate the code was the deep indentation here...

johannes

--=-b/gPFxq4OCwGfyPamR2a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGDOhr/ETPhpq3jKURAgoAAJ9Yn2wIWyMZXiCHKHCeR5b3bd8WdwCePF0s
zH5194wlkuy9Lb2fRWMNWSA=
=pwQt
-----END PGP SIGNATURE-----

--=-b/gPFxq4OCwGfyPamR2a--

