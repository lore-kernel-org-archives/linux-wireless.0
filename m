Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbYHGTsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 15:48:02 -0400
Subject: Re: [RFC] cfg80211: keep track of supported interface modes
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1218132788.15728.15.camel@localhost.localdomain>
References: <1218122495.3630.2.camel@johannes.berg>
	 <1218132788.15728.15.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zDFkscLqKODSR5rSatoy"
Date: Thu, 07 Aug 2008 21:47:45 +0200
Message-Id: <1218138465.3630.60.camel@johannes.berg> (sfid-20080807_214806_937269_D976A02E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zDFkscLqKODSR5rSatoy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 14:13 -0400, Dan Williams wrote:
> On Thu, 2008-08-07 at 17:21 +0200, Johannes Berg wrote:
> > It is obviously good for userspace to know up front which interface mod=
es
> > a given piece of hardware might support (even if adding such an interfa=
ce
> > might fail later because of concurrency issues), so let's make cfg80211
> > aware of that. For good measure, disallow adding interfaces in all othe=
r
> > modes so drivers don't forget to announce support for one mode when the=
y
> > add it.
>=20
> This makes me happy.

We discussed this in Ottawa, didn't we? It just slipped my mind and I
remembered earlier today.

No somebody just needs to go through and add the corresponding hunks for
all drivers. *hint* :) (it mostly consists in seeing what the
add_interface callback will accept, which is correct for all drivers but
iwlwifi as far as I know)

johannes

--=-zDFkscLqKODSR5rSatoy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIm1FbAAoJEKVg1VMiehFYw30QAMHM0M4xTVSncyvqzHsmM3Qy
kJsy7ZX1qCpIrNsg6L6MI9SSQPiC7DJPOYWVfvTSbvQhhBC8BYpEo4qDIvkdDO5R
WilJy8eh3RrEYJ21pOag0s74Gv0Qe6DpEDAlQ3GW3y7XSeHF+Kh577R/YLg9d8bI
RQDc7f+purKh2G8vGQQdpZsFiDiEePqctFfUlAFuVxfhnluhKRsDL9eWnuo4Lr3y
KRs6ff8Ki/934QE0/rgdsAkl8eYWHs6jEJLdYRqo35i4JLx1+JAksoRz69yWwvtq
1j27PUKvXj6oYItUzUiLyg7V1sABeT29a8++kpwn5unoAcpLM9JaILNTRSMc/4Fb
JknUqQvJt+CY4b9DRyg/SAjT1LfumpHQjpUb37TTTz9AkXxRLfFBtN0jr8qcaaJz
GpkjgVg9qNB9BeGOkFwYdr9YXFbN2YBMjfMWym6mk1JNAHbLf1E84+ssW9MbW1j7
OjfZvBDow9P4zwd/V8MrXyQSqrdf+6qX6o+TMbofj1ng9yy7wWGe6WlZE6QQKquT
oqKLP7CUOpNmKBM5LigJiaTm2Xjlq/qvIgcKrlcXHLXyJPJv1UcRmULqEX4JGQ70
aRB7edhofWq8o5KeFvkwqxdUQ14OCFls4awOpNzVg0b/QIGMHZZg3yYeUPAktY52
C9V3aMMAxXZw4T9TDqeg
=r5yN
-----END PGP SIGNATURE-----

--=-zDFkscLqKODSR5rSatoy--

