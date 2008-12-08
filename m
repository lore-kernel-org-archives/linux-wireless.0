Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYLHUOO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 15:14:14 -0500
Subject: Re: [RFT] mac80211: clean up set_key callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>, Chr <chunkeey@web.de>,
	Tomas Winkler <tomasw@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <200812082111.22996.mb@bu3sch.de>
References: <1228757035.22164.94.camel@johannes.berg>
	 <200812082111.22996.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D2yswY6ekquLmh0fiN6r"
Date: Mon, 08 Dec 2008 21:13:41 +0100
Message-Id: <1228767221.22164.130.camel@johannes.berg> (sfid-20081208_211418_235694_914833A2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D2yswY6ekquLmh0fiN6r
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-08 at 21:11 +0100, Michael Buesch wrote:

> > -		if (is_broadcast_ether_addr(addr)) {
> > +		if (!sta) {
> >  			/* addr is FF:FF:FF:FF:FF:FF for default keys */
>=20
> Please also remove this comment.

Ok.

> > @@ -3604,10 +3600,12 @@ out_unlock:
> >  	spin_unlock_irqrestore(&wl->irq_lock, flags);
> >  	mutex_unlock(&wl->mutex);
> >  	if (!err) {
> > +		static const u8 bcast_addr[ETH_ALEN] =3D
> > +			{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
> >  		b43dbg(wl, "%s hardware based encryption for keyidx: %d, "
> >  		       "mac: %s\n",
> >  		       cmd =3D=3D SET_KEY ? "Using" : "Disabling", key->keyidx,
> > -		       print_mac(mac, addr));
> > +		       print_mac(mac, sta ? sta->addr : bcast_addr));
>=20
> Will throw "unused variable bcast_addr" for !DEBUG.
> Use something like
> 		sta ? print_mac(mac, sta->addr) : "group/tx-only");

Crap. What you're proposing won't work well either because then this
code cannot be converted to %pM... I guess I'll have mark the variable
__maybe_unused or #ifdef it.

johannes

--=-D2yswY6ekquLmh0fiN6r
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPX/yAAoJEKVg1VMiehFYZocP/jdmAe4qSleG149swJXmEpId
KWcK87EoOoyIRo7XzBTdPIA2SX6C3rUG2vHygP778XNVd7SG59MegM9L+AR/Mbgq
uzR1/N4KE8PdAXIpLni3AlyZHzLWjGpp/eT/IXmTm8omEfMiA+lGDUbm+moRP20x
W4P4p0uL2xlm74gu0lV3kmCKeLXoTpTmOewcL4xtmIxzUNuhopnHwlRDWocZzKxo
F2hqUOQCmohSEhggBDiFBjOoyMVvrolphz2b9wL4hbVI7DHlI+wnxLxnbsfXyMMV
am9FUHJ7sUSKZPw8NccG299DqbEuhVE9oqghn4fM4HgxEw4/N3VdHLeJyERxmcWJ
cGR5kVDQPVz2dz55wu5qj67wGPCp+7lHwFR8BAy/lh47IaisfuxnJwjeB/YQ7ZqZ
3nx2gjhzZ3oJjpzOxL5NxuedG6iVUZS9u0Kbbl52rhdWnw9iLii01KclCsfRpvaP
5ODWrLSSwnZxjXYGGjx/KCeUuR2yKtFuV/mtlso/HC+Ivo9Hm/8odNjTUfHEhcOB
ZiEv2KoF/Vbenhst2QS3Gzc4M2ly1rjFhEAQeuf9CVrMujm5X84LA6rMS0W8djVj
hIwbS4J1sSVYuhfsAab3wKgE4Ro/jEYfohNt2GpyWNkyvhe6/5ES1HA+3IzO0Ld7
1vs6Zyna51X9fMDLs2II
=hdjb
-----END PGP SIGNATURE-----

--=-D2yswY6ekquLmh0fiN6r--

