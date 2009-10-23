Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZJWQjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 12:39:35 -0400
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for
 libertas+cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1256315496.2164.47.camel@localhost.localdomain>
References: <20091022133043.185554096@mail.mn-solutions.de>
	 <20091022133425.317619132@mail.mn-solutions.de>
	 <1256307572.12174.33.camel@johannes.local>
	 <1256312995.2164.7.camel@localhost.localdomain>
	 <1256313851.12174.131.camel@johannes.local>
	 <1256315335.2164.44.camel@localhost.localdomain>
	 <1256315496.2164.47.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3shGXhT5yV3ACvOsNHW4"
Date: Fri, 23 Oct 2009 18:39:31 +0200
Message-Id: <1256315972.12174.168.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3shGXhT5yV3ACvOsNHW4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-23 at 09:31 -0700, Dan Williams wrote:

> > > I just don't understand why he thinks that wext and cfg80211 need to =
be
> > > mutually exclusive. cfg80211 has exported its handlers for exactly th=
is
> > > purpose, so that you could have everything that cfg80211 supports via
> > > it, and everything else directly.
> >=20
> > I thought about it more, and I think we can go all cfg80211 with a smal=
l
> > WEXT handler for the mesh bits (it only cares about 4 of the WEXT
> > operations and redirected the rest to the STA interface handlers).  The
> > mesh stuff is actually quite simple operationally.
>=20
> Which should allow us to use cfg80211 by default, and then have only the
> LIBERTAS_MESH Kconfig option depend on WEXT.  Maybe?

Well if you want to push the mesh wext bits through to cfg80211
(temporarily) you wouldn't even need to depend on WEXT. I'd prefer,
however, to not do this, and just use the cfg80211 wext handlers in
libertas and depend on WEXT for now.

johannes

--=-3shGXhT5yV3ACvOsNHW4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK4dw7AAoJEODzc/N7+QmaudEQAJ+fQkSXfFEn7Y/wgFtVWtJY
XDmWWQfZDgc+aEmrieHVzz14t1TG1hFvyednLfhZ8081erQbPqT4CD3gUcxg/tZ3
Sv6skCTBOzl1Vf+p/9RugJefakf9cLorTxrDTFzrlWdeu5maOuyz8H2HJvGbc2/1
Jvkop7/ZdcAcgB/QdZ/S00OWh3fArYymadJ3PQta4sMUhmBZuMA4F8oUZYaTcLfJ
dMzaFGB0VEQqD+/aWT6LroBAhsoq7NTdCzGmhhuz75aegYDnVB/w35uRaNmDIbmP
CxGIQKvLxQHodwMGBIo9EH0BWf5zXBL6RUslxLxkcRvMLQo0QknacJiGPFsW+dXL
FaFRENqiDMVtzoTrneKLO4pDpKTbtV+DxFg67TIMMo6Wud6mN82rQKrWZTcGGGE0
OKiEECFRR8shPe3iRx4fBKKeNn83fDb8fz1TlbhY4ox2jR2FJynIBtWu4LeGJSvB
tmhI8TeCbRJXhcywNicWWnZj8NTtfg89Us/PqKq1tNNceP1fF84g1GmrFxHyQRw5
cw7a9M62PXMUNoyq+d+amD+2cohi+cOPod3F9obvEmGuo4wcfJfA8gd8ysfTOEXj
jp0zci62kRRgRKKMGcx0Nz2eEEiGlt36ygHEyaZx/0JgX0dUpPjG28mpTHDV/+sB
JR5mp3kIqDizzOvwPr6/
=V5Xi
-----END PGP SIGNATURE-----

--=-3shGXhT5yV3ACvOsNHW4--

