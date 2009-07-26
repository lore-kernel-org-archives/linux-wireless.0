Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56971 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbZGZGVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 02:21:37 -0400
Subject: Re: new lockdep warning in 2.6.31-rc3-wl
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890907251221rdf7d247yc81d7bc7cb23f255@mail.gmail.com>
References: <1248461132.1216.53.camel@rc-desk>
	 <1248513231.32151.60.camel@johannes.local>
	 <43e72e890907251221rdf7d247yc81d7bc7cb23f255@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FysQAff2POpyQ1Zu9q4X"
Date: Sun, 26 Jul 2009 08:21:31 +0200
Message-Id: <1248589291.19945.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FysQAff2POpyQ1Zu9q4X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-25 at 12:21 -0700, Luis R. Rodriguez wrote:
> On Sat, Jul 25, 2009 at 2:13 AM, Johannes Berg<johannes@sipsolutions.net>=
 wrote:
> > Obviously 3) is my favourite solution, not only because it's the only
> > one that seems feasible at all, but it's somewhat more complex, and I
> > don't really have time to do that today.
>=20
> Hm yeah this seems very appealing, it should be noted that this is
> called *very* often too right now because we call this for every
> beacon.=20

Actually, no, because I added filtering in mac80211 to make it behave
similarly with and without hardware beacon filtering.

> If we want to merge beacon hint and 11d stuff with the added
> advantage to make new functionality available to cfg80211 it would
> seem then to make sense to add some sort of beacon parser so we can
> extend it later if needed.

True.

> But can fullmac cards send full beacon stuff somehow to cfg80211? Can
> they send 11d stuff or would they have to try to build one? Or can
> they realistically only send alpha2 stuff?

They are supposed to send us at least the IEs from the beacon frame,
which we can process similarly. Otherwise, they cannot even support WPA.

johannes

--=-FysQAff2POpyQ1Zu9q4X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKa/XlAAoJEODzc/N7+Qman9sP/304lZ0T2DQRd4it9cZqCX6n
vm74Ne21KHM8Lg0LZMha9JHnUis5fZyr0GVO/yZ93lyU01OP1KbKgL/eTtZG50ao
QKI/10EFRaHVNgm3GTeOTJFrYSdC+acgZxNpCF0ixN7KbgkPktbSY7OhBtmHZETw
uhNwjsQToZESkWtOfe64PkLGANvFY54+Hv8Eu1+B3a0t1uae6Go7wMokFAtDsNk9
hTwug8TyS4MOGH1AFB0GWlosBxftL5punpa3THZ1pcrByI3/irKphhyUwb81oBD7
W8Kb/u0yOCb1ABnpI3Vto2wueqlkGj1EL4m5c/B+LOZCh4gJXyItCHF9ZYXGwf0A
Lnams2yX0OE2VPmjRdBZe0sNw4dn2H9eOi9FhxUp6F+KEJ/fl2xzfh9p1Jcj/zk3
vmbDh40pczhdtPA20wjaq8/FtjKEKu6ulbTok4wy2O9/d1AzALPCnV3qQp8Hu0Zm
M+2Ff7pqnoIc5REI/XvVdHJ5iQeGkaZf2i/OhUdFYLtUEYuWXC1txWqYqvapA7SK
v4AGpCfqHbHsMJZZzY2SJPU2uAAP1KJIFI1erFVC6nvsKn+6L1174+fy8gsNiy/h
Y2VFE2V5xNtqACJsA99+/OZ5aEE3G5OdCk53KtliR5MRbDVx1zzNm29/pO6G2NP/
SdBBmzHyPPg0OJ23YL5U
=SON1
-----END PGP SIGNATURE-----

--=-FysQAff2POpyQ1Zu9q4X--

