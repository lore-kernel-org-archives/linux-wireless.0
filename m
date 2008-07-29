Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbYG2Kt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 06:49:27 -0400
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240807290348y58026caag341a7115c0d78083@mail.gmail.com> (sfid-20080729_124835_076703_18832E7D)
References: <1217323927.10489.9.camel@johannes.berg>
	 <1ba2fa240807290348y58026caag341a7115c0d78083@mail.gmail.com>
	 (sfid-20080729_124835_076703_18832E7D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kvfHcWG1dOGoHdsN60NY"
Date: Tue, 29 Jul 2008 12:49:23 +0200
Message-Id: <1217328563.10489.12.camel@johannes.berg> (sfid-20080729_124930_478016_C1413182)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kvfHcWG1dOGoHdsN60NY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 13:48 +0300, Tomas Winkler wrote:
> On Tue, Jul 29, 2008 at 12:32 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > This patch fixes mac80211 to not use the skb->cb over the queue step
> > from virtual interfaces to the master. The patch also, for now,
> > disables aggregation because that would still require requeuing,
> > will fix that in a separate patch. There are two other places (software
> > requeue and powersaving stations) where requeue can happen, but that is
> > not currently used by any drivers/not possible to use respectively.
>=20
> What about about ieee80211_get_rate(hw, const struct ieee80211_tx_info *c=
).
> It's used in tx path in the drivers and info is fetched from cb

So what about it? mac80211 builds the info in skb->cb just fine before
it passes the frame to the driver.

johannes

--=-kvfHcWG1dOGoHdsN60NY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjvWuAAoJEKVg1VMiehFYpL4P+QHWTCrmo1rUztVpU/mWtrE9
r0WczY0IkIzBenfeFEiK+OvMyTjRivAOI1ShyTMo9RyFHGUx/rGr8AUu53zrd9Cg
lZzEgccfPGn1iZeqZh3bp7Rhm0b0cMdOP2A7RT7de613yh1xYRBuEKcTc3xxbnny
bH6eEO1+ivx+z/nTuk0gvZt7fER+zS3ZTS448snfnvlaiUPSgcU5eMQz9JJ2pD+g
4oeMzVinndJ5XvcwD7C928O81FSjFzxtFZB0x8nT72e2rlfJ8iXa2LCQu/oMKvf+
WQh0UxcabMidQvqydnicUTDEvXGh/jRk9H0tCIKwQdGKmgeuscAwh5LP2h3F925O
g30aN5hguGOHecmQpQhAsQ7t0EGk/5jbx8FByhu1R7VZFmSSnighbXP4frfl5Yo2
dskrsWNf/V/LxJWqMWWUq/MaFf3T/N7frhQcr4lkuBDPXDqwFeuYwLAo0VgpfHgO
CNu72aBPE1rfC7NtGY6+PsM26Thv4sAmFLfMfMa6HuIw50uijXOcXREEhcyfjVvc
mmPX2kAFJdf2bwlP8xkS9vPn8PN0eim4ZIashKJ8MDpmm+J+UlhbmdxpTAJi/r/N
b6syboOmPKseuvaR2Y6WiAEE4/in8db835QCiAYNQU+Rd8y2rhsEs4GKnhMR+9Bg
e6n1ZfXELByP1ctYwab6
=HThD
-----END PGP SIGNATURE-----

--=-kvfHcWG1dOGoHdsN60NY--

