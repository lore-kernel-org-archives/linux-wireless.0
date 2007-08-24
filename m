Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60252 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbXHXK1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 06:27:10 -0400
Subject: Re: [patch 7/7] b43: Fix and cleanup hwcrypto
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200708241216.50441.mb@bu3sch.de>
References: <20070823222153.073035000@bu3sch.de>
	 <20070823222157.102919000@bu3sch.de>
	 <1187950112.24933.3.camel@johannes.berg>  <200708241216.50441.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GJ4mUO2uSXG9NttD7Xus"
Date: Fri, 24 Aug 2007 12:27:56 +0200
Message-Id: <1187951276.24933.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GJ4mUO2uSXG9NttD7Xus
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-24 at 12:16 +0200, Michael Buesch wrote:
> On Friday 24 August 2007 12:08:32 Johannes Berg wrote:
> > On Fri, 2007-08-24 at 00:22 +0200, Michael Buesch wrote:
> >=20
> > >  struct b43_key {
> > > -	void *keyconf;
> > > -	bool enabled;
> > > +	/* If keyconf is NULL, this key is disabled.
> > > +	 * keyconf is a cookie. Don't derefenrence it outside of the set_ke=
y
> > > +	 * path, because b43 doesn't own it. */
> > > +	struct ieee80211_key_conf *keyconf;
> >=20
> > Just for clarification, you're allowed to dereference it as well if you
> > wish but most things you can do with it (e.g. change hw key index) are
> > racy.
>=20
> That's what "because b43 doesn't own it" means. :)

I missed the "outside of the set_key" part, sorry.

johannes

--=-GJ4mUO2uSXG9NttD7Xus
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGzrKs/ETPhpq3jKURAr/mAJ9L19unLAzPFXHqQ2jja/HZbPgS1wCgs2jT
rQLl2Ce0fOyI9F3Amx8EP8o=
=3k5F
-----END PGP SIGNATURE-----

--=-GJ4mUO2uSXG9NttD7Xus--

