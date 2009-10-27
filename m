Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60083 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbZJ0LhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 07:37:19 -0400
Subject: Re: cfg80211 / libertas: an unusual race
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1256201277.12174.17.camel@johannes.local>
References: <200910131055.31739.hs4233@mail.mn-solutions.de>
	 <1255687030.4095.327.camel@johannes.local>
	 <200910161403.37660.hs4233@mail.mn-solutions.de>
	 <1256201277.12174.17.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ib5t6J0pPQA5XFPPNs+U"
Date: Tue, 27 Oct 2009 11:15:15 +0100
Message-ID: <1256638515.4237.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ib5t6J0pPQA5XFPPNs+U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-22 at 10:47 +0200, Johannes Berg wrote:
> On Fri, 2009-10-16 at 14:03 +0200, Holger Schurig wrote:
> > > I don't see this happening that way -- how are you even getting=20
> > to
> > > __cfg80211_disconnected() if not through _send_deauth()?
> >=20
> > See step 7a in the second table.  We got there via=20
> > _send_deauth().
> >=20
> > But later, step 3b in the second table (I kept the original=20
> > numbers, so 3b happens after 7a time-wise!) we got into=20
> > WARN_ON().
>=20
> Still not making sense to me, since cfg80211_mlme_deauth() never does
> anything after calling you.

Ok, so I can see that this might happen as a result of a call to
__cfg80211_disconnect(), and I think the patch is correct.

johannes

--=-ib5t6J0pPQA5XFPPNs+U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5sgrAAoJEODzc/N7+QmapFkP/3gSgHOl8R3kcuuBRB1fteSd
MiMrky6/nDOgCvw1Xgm+6BsUTRQ/awnqStCQFfLrAsTIZp427r4Sd6ndhDKEci5t
ZrOmAOq0r6B5bkZ/bRR+5DaMAQ5xfYZSkqaHG4BgZgegJIbst6Z7dCIiONDqLNzZ
FyELT81tOH2Er2Nq4QE/00obJVrhwJnfweHAqq7DPuT713Yga3SuB5jn0DWkOBU+
IEtUReiXqycfFyZooqNmLyFU1bJfToexEDe2oUTge8MGugcHlrAxTnFBoI0SWnUy
Lw9lgg5hY4xX4AgkZMCsWSdRJhi4dK8IqAzXxGgiCav+Ng+ibZx0eIEOUsi5MsOp
gvML0A6X5kervjyKpOAEbTIvuZ7vZXBcEqf6ZNBmWR7XqXPZ+1BQvgR8txgO+wyA
iACHjbrc8dn/fLx5sQpVyiCUFb/sSFplijTOvXG2JqqkIxkQmL2PCuHYGBR3xmVp
0uXIqkVYDM78+knZAyy0j1Y4VEZc4I1Pz5jmURDOqO4qnKVQ9AV6GTsJ2e6tnNiN
IbNBiprxnKS2YZSmA72IQwCWveec0OVT/Bu/gthNgIPkPyYkEyo2MhwaEht0de6z
2Z6va4mVDQMlxxegvDzYNpriJVD3Clvcn8qEFHC8pVJ8m8597cUWLFlhvchttZPO
zY10OoNwBYbvJCCii3JL
=r3/J
-----END PGP SIGNATURE-----

--=-ib5t6J0pPQA5XFPPNs+U--

