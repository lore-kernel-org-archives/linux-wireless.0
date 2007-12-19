Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbXLSPuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:50:10 -0500
Subject: RE: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1879838866982C46A9CB3D56BA49ADEB0431391B@hasmsx411.ger.corp.intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782762-git-send-email-ron.rindjunsky@intel.com>
	 <1197915515.4885.86.camel@johannes.berg>
	 <c85cb4470712180544m682a93b1v9a7a34d2148a770b@mail.gmail.com>
	 (sfid-20071218_134457_890406_A2932F58) <1197986248.4885.149.camel@johannes.berg>
	 <1879838866982C46A9CB3D56BA49ADEB0431391B@hasmsx411.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JIpq/jF0NrXxNcHK4kZx"
Date: Wed, 19 Dec 2007 16:47:00 +0100
Message-Id: <1198079220.4747.10.camel@johannes.berg> (sfid-20071219_155020_068728_87ADD046)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JIpq/jF0NrXxNcHK4kZx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I'm just not sure why you'd want to. As far as I can the frames
> already
> > passed __ieee80211_rx(), no? Maybe only as part of the aggregation?
>=20
> No, not passed it yet, they are still queued for reordering, but as
> aggregation is being tear down I am expected to drop the frames
> that are still not in order.

But haven't they passed through __ieee80211_rx() as the aggregate frame?

> Again, if you see any performance issue with it, although this may
> occur only once per session, do tell, if not, I would prefer to
> leave it that way, as this will 1 - give more accurate statistics
> of dropped frames, 2 - I don't want to drop frames in places
> people will have trouble finding, other then the in the handlers.

No I guess it's ok I'm just trying to understand it better.

johannes

--=-JIpq/jF0NrXxNcHK4kZx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2k886Vg1VMiehFYAQLwPg/+ID2o2Nxsee6++OLO8JCY3Bks8JfaByMw
dRwL0qsCJshnwdusAJsE2jpf9hnaYVzi2KgVmrhYuq4TPdJTHq02VtI3j0TTgF5e
s59oy3seS+Yz2YlCGaQaQ/mo5r5Q+X/26rGLR7bJfheNIMhBOR2b8zAsaq04bx9U
F4abCj4tUFs/IVLNXS6w9bAEu64Kmz2gIW3AVgZzIWhAgyMsARWT0izhCRGot8dT
FPcQg/nvVBio/GcHegfMq18NmdU2uNwU7c57oW+B52yL5kCqMRapKFUB1ibS7v0j
S0eqgrszo3j9Op3Uq8ycsEfRWKP+SwBTttteJcvcjSFg3VkQOXg/PQ3Gs4esv35j
WnFJ5WR8aBxk1jJvHOcJKo+NY1gwQwdiVKvRayImdKrxuQqHtvN+xEWpOaiWnvSS
KDmwDZT+vXDMKYOUnDdiCG87s4r4IIA4c8pDsmEgAD2EkGtLUVzAsVUaPhLeFNBx
XjHMalcizTmG23RGCs46sTd1IKyRgTdtNPi/xW7vlZ4a3Zw18vInK5NrbuzGLeO7
Gg/i2Kk6BT7zAZIAeSasbBgTtOfH0N0wC6OlKcHn/YOrGCNGklxccbgx4uT/6N6S
ul2/v9JmyROoLyUNX7sF9+H5gK7ed9yq5hgbsd4qPs3MUcaccu64KSfShwmNxHhu
0qcn8ogFyBY=
=bBI7
-----END PGP SIGNATURE-----

--=-JIpq/jF0NrXxNcHK4kZx--

