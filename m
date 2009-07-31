Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbZGaHnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 03:43:41 -0400
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1249024097.7653.6.camel@maxim-laptop>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <1249024097.7653.6.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SBhPfznsD7UpAXeKCSea"
Date: Fri, 31 Jul 2009 09:43:01 +0200
Message-Id: <1249026181.29587.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SBhPfznsD7UpAXeKCSea
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-31 at 10:08 +0300, Maxim Levitsky wrote:
> On Wed, 2009-07-29 at 14:32 -0700, Reinette Chatre wrote:
> > From: Reinette Chatre <reinette.chatre@intel.com>
> >=20
> > The connection monitor currently relies on probe requests paired
> > with probe responses to ensure that a connection is alive. This is
> > fragile in some environments where probe responses can get lost.
> > When we receive beacons we can also consider the connection to be
> > alive, so cancel connection poll instance when we receive a beacon.
> >=20
> > The debug message "cancelling probereq poll due to a received beacon"
> > is removed as part of this change as this case is hit very often after
> > the above change and debug log receives significant number of these mes=
sages.
>=20
> In my opinion this is the correct solution
> I did plenty of wireless monitoring, and I see that nobody sends probe
> requests at that rate (1 per second it seems). This is ridiculous.

Fix it then. Offer an implementation of your superior solution. We've
done pretty much exactly what you're all pointing out _forever_ in
mac80211, ever since it was initially merged. Now that it's more
explicit in the code, people are complaining?

johannes

--=-SBhPfznsD7UpAXeKCSea
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcqCCAAoJEODzc/N7+Qma4H0QALaif+wUE1IEVj7pTCfxy9dH
oAG4LNd/UYetxOJ0gfL9az133qL6qxEqBrZbEFmZb4YxeqzCfay0nixkZvULU6xo
vFlHpFgaZTj+sjdYP1qEEX7P77VOTqu5L7dNHO1WWm1UVxY45a1ivoZCTg3YyiB8
jIuM2Tfc3lcg1MiYrdgqs8UIxb6NBMMSfHCqEpRD5sh8YGrCPjyIpvA9ntSJcN7X
m+tAu5LZ/a946ZTMJwZNkss7HvcHIE4FBcOD9lJ+DXo0gF1gZq04PP6rleWQFKaE
YdM9nJ0wdxvf7c0/vbtAYvsjHaiDBQpxQ11Nu2Wt2eIST6m9t/sej4gxyxDYMmoG
iW2H3KbFKaSaFBJI0i2e9b4+MGsV6dH/9D5or8V05efUrMRNOA60v90+nob9s81f
9mUDFfOmt+PoQC30REjaT2Nnfs3VkzO1PIDa2D5GgAtxkSYl85NPN3YwkmVRX9gQ
EEgTeP+PcQvHnkhOowyOnNq3NCwlsFODO7HbGKOP5dn8cmEq/hetBhQoC4kwr9+H
VIhjef4YN4KS30pLVikHEfWQYHezfgHyz12nTzBdC3cu0qKUXasxvzIqugDX8VlY
yY1dan2xbMjf+7RtsHnplmZQm7hHCC/BhoIe9zdjUwcBP/mA70g3ZmIfqpI0Hb3v
sU41n9vGXWM8MjQywZ3p
=LaJB
-----END PGP SIGNATURE-----

--=-SBhPfznsD7UpAXeKCSea--

