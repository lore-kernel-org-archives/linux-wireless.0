Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYGIPuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 11:50:17 -0400
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807091748.49796.IvDoorn@gmail.com> (sfid-20080709_174000_972007_A27DDD5C)
References: <200807091511.14288.IvDoorn@gmail.com>
	 <200807091736.55061.IvDoorn@gmail.com>
	 <1215617595.3246.26.camel@johannes.berg>
	 <200807091748.49796.IvDoorn@gmail.com>
	 (sfid-20080709_174000_972007_A27DDD5C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ewJgcICKW95whcwEuL5O"
Date: Wed, 09 Jul 2008 17:49:30 +0200
Message-Id: <1215618570.3246.30.camel@johannes.berg> (sfid-20080709_175024_447098_AC2954E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ewJgcICKW95whcwEuL5O
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 17:48 +0200, Ivo van Doorn wrote:
> On Wednesday 09 July 2008, Johannes Berg wrote:
> > On Wed, 2008-07-09 at 17:36 +0200, Ivo van Doorn wrote:
> >=20
> > > True, I have to double check it, but the legacy drivers use per-queue=
 locking as well.
> > > And it would still be possible for the driver to send out frames with=
 a higher
> > > sequence number before one with a lower number.
> >=20
> > The legacy drivers hopefully also implement proper sequence numbering
> > per TID. I'll send another mail on the topic.
>=20
> Heh, I seriously doubt that. As far as I know it is working using a singl=
e
> counter in the main interface structure. Just the same way it currently
> works in mac80211 (which isn't surprising, since I based the mac80211 pat=
ch
> on the legacy driver implementation).

Ok so the thing is this: 802.11-2007 7.1.3.4.1 requires that we keep
sequence counters per TID (and one for "not QoS"), which we only assign
rather late in the wme code. Because even b43 hardware only keeps track
of a single sequence counter, it requires not using that counter for QoS
frames. =EF=BB=BFI suspect no driver except the overly smart iwlwifi gets t=
his
right.

Do you have flags to turn off hwseq support for the other ralink
devices?

johannes

--=-ewJgcICKW95whcwEuL5O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdN4GAAoJEKVg1VMiehFY8pwP/AinQgaGLNcCD15BUlEbayuR
4Q5tJnKRxHL/6xynqndN8mvoEn/K8uA19b3512/r56dhI8qPePjfWptAaMsA0aH5
EO1S4GgVGHfOpw7p5VS0ctHZuaUDAPSst114syRGuhGF4Mjp84GczGgfoeffP8hd
j3oIVmF/e1acLCmHjQVD7vbASc+Pu81oiUwv1cBZhERNexiZMJ90nDNp3y0MYSv5
i3UDQfbb31ZJuwz+/f+PBA8Jgkq4X7cxHxf7AgvXS4ZF/7IT7CFYVzbQxnRNT4pr
k6jw7too0rSERrEmThZk85v7Q++BdTdeEoiBGL2VWDD28+j8l3H9QoXPcfgiqhah
ai4v6AvTrPNdiWaBBOHbFJ5Ed3oiebFPKqRZO1q030np/UM8iGhYN0gdgTztG2gX
KZvj0jypZxVdJTXPMslIjpWjUzyNixhKq8WnY9bT3xgYg+FHCGXm9GoHg7qEdarf
mS9tCPMQ5Dj1DTD5qZ8w5b1pLQwM6NbEBaZQbfeC6aX2FiYj6wlAfBtvb1+vnDo4
xJ5l6TXuB3CgtdTnzdNjZCMKHYC3tObSBgWVscYdH6C/UeEdGF6gInTD9lVVZxc7
wb+DPGyN6AITtgWJgW629JQPGzUfFHoarHJN2v/3wM6ceXxkxdOr4tHcLtmyq/jC
A/O2Tsfjh4YyuCDhmeJ/
=5Qn6
-----END PGP SIGNATURE-----

--=-ewJgcICKW95whcwEuL5O--

