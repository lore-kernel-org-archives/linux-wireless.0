Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36391 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZGAPJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 11:09:19 -0400
Subject: Re: [PATCH] iwlwifi: fix aggregation limit
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1246460817.12994.153.camel@localhost.localdomain>
References: <1246453079.4131.19.camel@johannes.local>
	 <1246460817.12994.153.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xZ4M1PGQQM+iBE8X/z+4"
Date: Wed, 01 Jul 2009 17:09:04 +0200
Message-Id: <1246460944.8154.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xZ4M1PGQQM+iBE8X/z+4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-01 at 08:06 -0700, Marcel Holtmann wrote:
> Hi Johannes,
>=20
> > According to the documentation, the limit is 0x3f =3D=3D 63, not 64.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > It seems bug 2018 is related to the link quality command, because it
> > seems I can trivially trigger it or similar bugs that way, but this
> > doesn't fix it.
> >=20
> > --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-commands.h	2=
009-07-01 14:53:33.804427206 +0200
> > +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-commands.h	2009-0=
7-01 14:53:38.924427592 +0200
> > @@ -1922,7 +1922,7 @@ struct iwl_link_qual_general_params {
> >  #define LINK_QUAL_AGG_DISABLE_START_MIN	(0)
> > =20
> >  #define LINK_QUAL_AGG_FRAME_LIMIT_DEF	(31)
> > -#define LINK_QUAL_AGG_FRAME_LIMIT_MAX	(64)
> > +#define LINK_QUAL_AGG_FRAME_LIMIT_MAX	0x3f
> >  #define LINK_QUAL_AGG_FRAME_LIMIT_MIN	(0)
>=20
> why are you switching of hex now? Just putting (63) in there is not
> enough?

It would be, obviously, but the doc says 0x3f.

johannes

--=-xZ4M1PGQQM+iBE8X/z+4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKS3wNAAoJEODzc/N7+QmaLeoP/1oWgUBx8BR/w/NxgRV1geez
DAFK8BXQOEM+7YvRQJdmbzAJ4Unjehx1RwnDZ7nxtHM8+dGC1L9NcV+r5mvLh35H
9fdOWLa4WhQVVaz4ZjhaxoPIfSaEjWzxTjPQmP8qMcUlwZJuYNNj+EHr19eoq+dB
GQ5uwW2Q/2l7E9Z7PpXgbQP9nNPTU4xmyGJlkPospHddypZBj6DVdDjH3X0d7rXm
EkNRpY5tig+G/I5GXYtFaFdHw/cJTb9vGl+BQBcuccGcOjWB+HZV0IunYMDl7n/U
IlhZzZfuXasf4kxNs55qhSZV1DEPmX2xGQcXxpIyLpDH30SbijiFTeRqVfYTOWRn
xEdYR6Cs+fYtuUwfd3NiKAsAbeYE8A469MDIE564qyKi4B0sKnAMPrLYaK/2ui51
LwgjESWSJmCew+bb/K9gCm/FIHMddVQoKwb3cEbBUj1CCSsNGW1nPa6rCM2X06VH
B4W7unLTg+TsniaGMv7OZiyRsX++9R4Y6XMie8GB/ZSQFPYdaR6RKt1TTPQbxUcH
YoIDu+0eZmn4lihE3y4HJGZsIWbvMZ9ol8RJDbHZ4fRdeUmf/ozghhev4FyZvbak
Ah2wwpHbftjlzg71ByDMq3azxhnM6OeuTBr17gggNi8ibMblK7BLwrY8fUQB5Nyn
pJZ1wCsrnbpfay9FpEq/
=4qoH
-----END PGP SIGNATURE-----

--=-xZ4M1PGQQM+iBE8X/z+4--

