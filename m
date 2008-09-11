Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50545 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYIKRkT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 13:40:19 -0400
Subject: Re: [PATCH 00/18] mac80211 cleanups and fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20080911173335.GD6049@tesla>
References: <20080910220145.707263000@sipsolutions.net>
	 <18632.55008.411078.289830@gargle.gargle.HOWL>
	 <1221139351.6986.26.camel@johannes.berg> <20080911165011.GA6049@tesla>
	 <1221151995.6986.33.camel@johannes.berg>  <20080911173335.GD6049@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BglUD6khmr9FFZykkmzv"
Date: Thu, 11 Sep 2008 19:39:37 +0200
Message-Id: <1221154777.6986.43.camel@johannes.berg> (sfid-20080911_194024_972872_166E0270)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BglUD6khmr9FFZykkmzv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 10:33 -0700, Luis R. Rodriguez wrote:
> On Thu, Sep 11, 2008 at 09:53:15AM -0700, Johannes Berg wrote:
> > On Thu, 2008-09-11 at 09:50 -0700, Luis R. Rodriguez wrote:
> > > > I had actually tried
> > > > (http://johannes.sipsolutions.net/patches/kernel/ath9k-sta-node.pat=
ch)
>=20
> Just a comment so far from the patch.
>=20
> > +     rcu_read_unlock();
> > +
> > +     /* the "!an" here is fine even outside RCU lock */
>=20
> Why is that? I fail to see that.

Well take the larger bit of code:

	struct something *an =3D NULL;

...

	rcu_read_lock();
	sta =3D ieee80211_find_sta(hw, hdr->addr2);
	if (sta)
		an =3D (void *) sta->drv_priv;
=20
 	if (an) {
 		ath_rx_input(sc, an,
 			     hw->conf.ht_conf.ht_supported,
 			     skb, status, &st);
 	}
	rcu_read_unlock();

	/* the "!an" here is fine even outside RCU lock */
 	if (!an || (st !=3D ATH_RX_CONSUMED))
 		__ieee80211_rx(hw, skb, &rx_status);


So at this point it's only checking whether above it had a pointer, it's
not accessing it. Think of the "an" variable, after rcu_read_unlock(),
as a bool indicating whether or not the code that just happened had
access to the node or not.

johannes

--=-BglUD6khmr9FFZykkmzv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyVfUAAoJEKVg1VMiehFYjk4QAI0LvcA5hJbRzSXFB+KAcNSd
SqFUnOhhw7Are6nxc8No1rLF7vq551/GFoqqSj6FLplsOM/zgxvtTWAPwBylcDUz
D0nBDuQjO+LFcNh73MZ72SNdIxnZ0BZMpq3WauhwQaxQVdxcus76Za4OSup7lPmw
lMsPRNH7CoRsf2JfRpZpGcle+kelo9Di2l6ljc7eI0u5upB97bXn8VygQFs8UiP4
TjHXJx6fsIbr+Hk2unVwCFi15oQBQEHgxzVWlKNEYCgjNHJjZWGGE2Wd7mK8+YA+
D9NlNa8KB8+axO+oLP9Lj9QZ4Azvq7Lv/vhEICYTrPigM9R/VvlHhN9f5haQ2SUf
iSBFLBX00T6nG5SO5rRfGRaKaDPcc/ZQAov3Ho0GU/dEjvh8L9CViK5gGlaS3llN
//a7ixfNEzebFqkPOt3O/J9YBJLunFwsgpzp/B1KB16RiBCh4JknIXIyF+st66OG
dujnLhsA2mIl4nxqL6jaXcPZtYcxPXjJD3OAAoAb0JfyvEv9hN5qfR2E9byBMkyF
r9eyX2IaoWe4hA97ARASa/Nb9yr6x42RoRg9/Vwm3ecJiXdI9tzdNP3lFHd9s6pq
zZ/Aqb0ubvT6c1ks+pojvd2vCZ+AMsh9+0ISmWoLnif3lNb0/DU0oxeqv4YcCE3q
4/fVuXmiHX9PUAUzm9i9
=3Adx
-----END PGP SIGNATURE-----

--=-BglUD6khmr9FFZykkmzv--

