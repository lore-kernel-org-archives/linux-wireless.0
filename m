Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbZFAHeD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 03:34:03 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: alan-jenkins@tuffmail.co.uk,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243796509.6570.35.camel@localhost.localdomain>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
	 <1243763887.19302.29.camel@johannes.local>
	 <1243796509.6570.35.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-REORrlMMciqQsjqvKmHC"
Date: Mon, 01 Jun 2009 09:33:59 +0200
Message-Id: <1243841639.5299.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-REORrlMMciqQsjqvKmHC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-05-31 at 21:01 +0200, Marcel Holtmann wrote:

> > You have a point there, but I'm not sure it even cares? When restarted
> > it will probably want to impose its current policy anyway? It would be
> > easy to add that we send the global default value for newly added ones
> > too but I'm not sure it's necessary -- Marcel?
>=20
> we can be smart and send an additional CHANGE_ALL when opening the
> control device if it is set. We can also just send these anyway. Doesn't
> really matter? Does it?

Well, I don't think we want/need this.

See, Henrique says that the use case is Thinkpads which store the
previous state in the BIOS. But that matters to you only if you use a
mixture of operation systems, which we don't have to support.

On the other hand, people on machines that don't store the rfkill state
in the BIOS might care about having their machine boot up with the same
rfkill state(s) as they shut down with, so the sane thing to do would be
to have rfkilld store the state persistently, and then recover it at
boot. At which point the BIOS state becomes irrelevant and a detail we
actually end up not even _wanting_ to support because it means we need
to be aware of machine differences in userspace.

johannes

--=-REORrlMMciqQsjqvKmHC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKI4RhAAoJEODzc/N7+QmadtcP/10y921wjpT/rCly+dkDPfT5
LXEdHoQUfJIPB2nhLPrYnNSdvC2VTxBFCs1R4IVF7Gy8ds/YMI4sTpHDfKm56XNZ
e3Iacu/e/5k0a7ljeMMUlPBvjLkHBu2sUFyyyG0JXJtm4EAD75zI5WiLVyuyQDD7
Ced6exauu4i/bs30CPySqG4B74ZZN02dn8YpKYWOnO30LejB6+addNJYLl3puluQ
Otj+gw4ghJh+2X9ZhDpyT7UKM7050vRPOxsUMSjbzF7GMnd4VmuGwpsiyqQ4BfVu
WQeyQuSa+JbwD3fwkkxFgyXXubqMB9xkhztep4nBXfH+L3J7lmPJ+3rdLeHp+DTd
FRMQE/gwe36DeewMFl6udhz084Wsashx/Clf/7IXexg+YL6oppeB0/c5Dr/GMfp2
28XizzT19ECf6n4kzAo/+9fZ+fip1fOHHbVxQNIEcGejp1pNq6pRfhWqM/FYrFBV
wPH4pIdcLKASWt3ktDlgp0XmwmQbCf0MveAlNKCvFVTp9yvWmR0sZrHNND/Axgey
OiUvWmnAaDav4v18Klr5PVUhDr6gNL33d3CZC28kQZNbA7Hb79PtQqUVCkbNi3rn
hg/BzkdEpiklXgzWM6qZ8zqT75QWmDBeaFVFBQAeGpLlQp8gRPqyvWM1FkHjreFU
h0JWxfJCoKp0LwBXdcEi
=Pu+N
-----END PGP SIGNATURE-----

--=-REORrlMMciqQsjqvKmHC--

