Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56723 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYHGOT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 10:19:28 -0400
Subject: Re: [RFC] mac80211/cfg80211: Add BSS configuration options for AP
	mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <20080807141508.GB5138@jm.kir.nu>
References: <20080807134043.GA5138@jm.kir.nu>
	 <1218116906.23048.179.camel@johannes.berg>
	 <20080807141508.GB5138@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ocrx9nwrdHdmgQ40qkuI"
Date: Thu, 07 Aug 2008 16:18:52 +0200
Message-Id: <1218118732.23048.183.camel@johannes.berg> (sfid-20080807_161931_818317_BFB38514)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ocrx9nwrdHdmgQ40qkuI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 17:15 +0300, Jouni Malinen wrote:
> On Thu, Aug 07, 2008 at 03:48:26PM +0200, Johannes Berg wrote:
>=20
> > I used to have a patch to move the short-slot stuff in mac80211 to the
> > BSS info struct so that drivers that support different slot timing for
> > each frame can use it for different virtual BSSes. It no longer applies
> > though:
> >=20
> > http://johannes.sipsolutions.net/patches/kernel/all/2008-08-04-12%3a26/=
013-BROKEN-mac80211-bss-slot-time.patch
>=20
> I'll take a look at this. I hoped I would not need to go through all
> drivers to update the API ;-), but let's see.

Yeah, that was a sticky point... But if you want per-BSS information you
really have to because right now it's per-hw.

> > I think you may need to handle the case where dev is a VLAN? Or do we
> > want to have these settings per VLAN too? And should we reject them for
> > other modes than AP where the AP controls the settings?
>=20
> I was thinking about this a bit, but since ieee80211_sub_if_data had
> them shared for all types on interfaces and there might be some testing
> uses for these even outside AP mode, I did not bother adding extra
> validation here. At least the three parameters added here won't be
> per-VLAN since they are advertised in Beacon frames. Though, maybe the
> easiest option would be to limit this for IEEE80211_IF_TYPE_AP for now..

Ok, they can't be per VLAN then, true, but then I think we should limit
it to _AP just so nobody tries setting them without effect on other
devices or overrides, for _STA, what the AP said. For mesh I don't know
(adding Luis) and for IBSS I'm not sure either. I suspect you could use
it for IBSS too?

> > > + * @NL80211_CMD_SET_BSS: Set BSS attributes for BSS identified by
> > > + *	%NL80211_ATTR_IFINDEX.
> >=20
> > Maybe we should have a way to retrieve the settings as well, and that
> > could even work in STA mode to see what the AP asked us to do.
>=20
> I did not see any normal use case for this, i.e., this would be more
> like debug information. CTS protection is already exported via debugfs
> and the other parameters could fit in there better, too.

True, there's little value in this information for regular use.

johannes

--=-Ocrx9nwrdHdmgQ40qkuI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImwRIAAoJEKVg1VMiehFYMsAQAIyCK20ZO/5aJ2Mjx+6cyoe4
zgRV5Tl7/u7V+/WSIudGEOBXQR1iefOsYr1LtJTx7PvMfMElUkcbVF5tqVJom5Ri
rZnK466eKcqXs5jZZLWKwfzNAhKfI3BbZB4+4HgUMG4ewiQhF3gigqa42dBOSFod
puk1LU6RratFokkajzgJ5bQMO5z8ak9TMHptDWB6TlUPAyHskjHR5y5Swy1ybnVy
XFISxzz0M0G2dRJBSReKtxoF5HviustDZ0QP6T5v1tPF41gwojCcvq8sAuVy+bdZ
soxi5HSHF4/S+v/NS9Q1GIhiAZFWkUjDEtmszqLnbN+POTmmKjZqrshdZlme9oTV
/prK7rml5W8/NYm6dIYqg30VG5dRgcp65YCPrqpotzEk8L7RxhLWG7pVGK8Er+ff
V/AxuhzjbcChoPv+fpC7iqkooiTK3OBTrSR0/NKbxM29x6K06DZpPJNy42danaJh
qYdXI1m+gG00KmN5fJJaN+/WaRW+d8ck7OIU4Q1eU9OQknkTMecE3bSFLxDe3sUr
OpT9xjbZIhcxm3tANsklFD93JezmAyVTi0rJuIC+cGZsg5ABwdEf0unyYSOUPF87
QKNS7hnd7l15X3QChryHqqWIbkuqQIcfQ8q6CBDRklTXndwD1opnbMeSjZubV59/
ssmXc1uRWyRAzvKi5XRh
=qpKd
-----END PGP SIGNATURE-----

--=-Ocrx9nwrdHdmgQ40qkuI--

