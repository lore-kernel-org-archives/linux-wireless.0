Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbZHGSBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 14:01:49 -0400
Subject: Re: [PATCH] mac80211: allow DMA optimisation
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200908071855.38921.IvDoorn@gmail.com>
References: <1249656135.7194.6.camel@johannes.local>
	 <200908071855.38921.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3jWhuawD6JcrxrQyte8D"
Date: Fri, 07 Aug 2009 20:01:46 +0200
Message-Id: <1249668106.7194.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3jWhuawD6JcrxrQyte8D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-07 at 18:55 +0200, Ivo van Doorn wrote:

> > If we have a lot of frames to transmit at once, for
> > instance with fragmentation, it can be an optimisation
> > to only tell the DMA engine about them on the last
> > fragment/frame to avoid banging the IO too much. This
> > patch allows implementation such an optimisation by
> > telling the driver when more frames can be expected.
>=20
> Wouldn't this be the same as the
> 	if (ieee80211_has_morefrags())
> 		.. kick queue ...

Initially, yes, but I think we should eventually use it for sending out
multiple frames after restarting queues etc. For instance after
scanning, we could send out a bunch of frames at once.

> > Currently, this is used by mac80211 only on fragmented
> > frames, but could also be used in the future on other
> > frames when the queue was full and there are multiple
> > frames pending.
> >
> > Note that drivers need to be careful when using this
> > flag, they need to kick their DMA engines not just
> > when this flag is clear, but also when the queue gets
> > full so that progress can be made.
>=20
> What would a good value be for the threshold?
> rt2x00 currently uses 10% of the queue, which means that
> 2 or 3 entries are kept available at all times.

Well, for fragmentation I think the maximum number of fragments is 9.

johannes

--=-3jWhuawD6JcrxrQyte8D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKfGwHAAoJEODzc/N7+QmahOoP/3turWD21exYGd//ZkRDmZPb
P/GQTxqZScSma5T3sCby3TWmvd0sxixhAkg3ecNKhSNOIVJj93mo4GemgkfMEfDK
zW5Kl4U/F0cMTQ5KkGaaTjcvG6tutIECXtBXAswNk49vEd6D+EfVWmTL9rxEkQot
O8sz/n6tteoAwqCI1z6hvZLb9QXTdwwqNmeosI/wv+xImL968+dwrqAmHSbybZgb
Bo9GOQnd0oSLaFKHmXOMw7kmd9S3PsFsf7chzto0xQLke4VK5ICr65nWUIeJsm7U
nPLcnImmPVicDdiRUAs/Xoy1OKNuHWXYu6jpaLLuP5atiFpwB+3PMvkWw4rypEu0
XPblJG3K5Kiv2+3yviLoTeKmvRhuLD37OQva5UWpU+0mRWPH/zXwy+w8vrNt8DMO
FrbxBTSmJYp4C+rYXfReyX8rgtENnLpGgWlJYR2hU969eJD/0dU/2pGXARlZ0rnl
C7YS40cKXOpHypFb7CRYE7pWK0Hryows0xkf0fU51T+apyoZf3PtraQfmnI6LDmt
XHiXLTIjhJCHzMq+Qq96nXZZiyaPoOO5HMY+FiVHG9qAZG4ApPXues8gNio1bUeD
25wBDoMRDE+gdmNLjCioGg74pc4uNgt8C/iPiVpXpv0fbSzprD0T9g/+EL7QseSb
Gk6krMf4qNWSBSUvE0QG
=i5n6
-----END PGP SIGNATURE-----

--=-3jWhuawD6JcrxrQyte8D--

