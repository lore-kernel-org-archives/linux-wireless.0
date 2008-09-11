Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYIKQx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 12:53:58 -0400
Subject: Re: [PATCH 00/18] mac80211 cleanups and fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20080911165011.GA6049@tesla>
References: <20080910220145.707263000@sipsolutions.net>
	 <18632.55008.411078.289830@gargle.gargle.HOWL>
	 <1221139351.6986.26.camel@johannes.berg>  <20080911165011.GA6049@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N3vTCgefIUUc4e4hHgV2"
Date: Thu, 11 Sep 2008 18:53:15 +0200
Message-Id: <1221151995.6986.33.camel@johannes.berg> (sfid-20080911_185400_856894_0A69A9DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-N3vTCgefIUUc4e4hHgV2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 09:50 -0700, Luis R. Rodriguez wrote:

> > I had actually tried
> > (http://johannes.sipsolutions.net/patches/kernel/ath9k-sta-node.patch)
> > but you're using refcounting for the nodes while mac80211 RCU-protects
> > them, so I didn't get very far.
>=20
> Good thing I read RCU docs yesterday.

Heh.

> We should be able to remove ref counts and simply use RCU and
> sychronize_rcu() before deletion.

Well you don't get to control deletion then, that's another thing.

> > It needs a bit more effort to make sure
> > you don't have node pointers stick around in some tx descriptor after
> > mac80211 decides to remove a node (which may very well happen while
> > frames are queued)
>=20
> We can call_rcu() here no, and let the driver deal with what it needs to
> prior to deletion?

The driver already gets notified via sta_notify() that the sta is about
to be deleted, it must make sure that no matter what sort of references
it kept, the sta will not be accessed after that sta_notify call.

johannes

--=-N3vTCgefIUUc4e4hHgV2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyUz3AAoJEKVg1VMiehFYf6oQAK5pCshWMuXpJRNj3BCOdslQ
MWaoz8BqiSEa3TMeyqmSFIPwRw2KmnA631tTDbTk+4MEnb8zRO7YUbpC09Kn25GD
hzGimk5fkVPxxlhg1thtoWRDksegjlbhq5BhDVrt02dXjX3c8dKuYJdvIRJZM4UT
P7NBVrAkb8F6VYaUa1RWITs8SgjO/mA0vxESYAMD2HHcnicPZSzF4M3ujhF7yd9c
EjYSVlzkqSK8+k3LIOHW7pyoFMGo9FOfdB6TNdwhpiSOH3NAmjLBdHL+8C5NXENI
A0YPinPK7FFj20bhtq7S2lMhX3mLUQIWhwzSYio+3Fwcuq3L8genfjq/I5GG0KoZ
Gqv7SbU/h5qRZqGSaXQKCdQPDGzKC8eB/prajfUcDzyFzyFLHZwx3xpNCzIYImb0
jGr5IgmrjKs1zNsO+rgsb79Uvp7E2/lAo5NCdxei9XKgKz4o9ZsOMKQ3dldrVvVL
y/xbGDH926PUfgTgVIDltKIPI7W99AiLjmxQVnUUrV5wfUamXqRN3kRtC3iJNbCy
8FOl41snNpqSETUSEowEmWLiQIfduMHgiifUUwPaYHe3qaETneqVuRkTUjA2U20O
BgQcofXzsyYA04ih5nTk8YhRCdtFYRTPEVZ4n6RUPsPE1iThqqEBrbBHUujTiN1R
yprXOEOUqHvkgcQi9tJf
=Pq06
-----END PGP SIGNATURE-----

--=-N3vTCgefIUUc4e4hHgV2--

