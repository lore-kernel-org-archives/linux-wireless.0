Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbZEXRZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 13:25:18 -0400
Subject: Re: [RFT 3/4] cfg80211: add rfkill support
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1243171957.24236.13.camel@localhost.localdomain>
References: <20090521215940.344214804@sipsolutions.net>
	 <20090521220105.198751775@sipsolutions.net>
	 <1243171957.24236.13.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-X12ADzBRbaorzvuPfdSy"
Date: Sun, 24 May 2009 19:24:11 +0200
Message-Id: <1243185851.29222.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X12ADzBRbaorzvuPfdSy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-05-24 at 09:32 -0400, Dan Williams wrote:
> On Thu, 2009-05-21 at 23:59 +0200, Johannes Berg wrote:
> > plain text document attachment (015-cfg80211-rfkill.patch)
> > To be easier on drivers and users, have cfg80211 register an
> > rfkill structure that drivers can access. When soft-killed,
> > simply take down all interfaces; when hard-killed the driver
> > needs to notify us and we will take down the interfaces
> > after the fact. While rfkilled, interfaces cannot be set UP.
>=20
> Any chance we could get something other than EINVAL returned from the
> PRE_UP notifier when the device is rfkilled?  It's useful to get some
> indication of *why* the device can't be brought up.  For example, if the
> device requires firmware but that firmware isn't present, the driver
> will usually return ENOENT because that's what request_firmware()
> returns when it can't find what it needs.  Thus userspace can do
> something intelligent with the error.
>=20
> So maybe EL2HLT could be (ab)used here?  I guess technically it's an L1
> halt since the PHY is powered down, but whatever.  The only other stuff
> that seems to use this are the USB 'gadget' drivers.  Either that, or
> lets make an EL1OFF or ERFKILL maybe.

Sure, we can do whatever we want, I just quickly put EINVAL in.

johannes

--=-X12ADzBRbaorzvuPfdSy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKGYK0AAoJEODzc/N7+QmaFacQAI4j7F6hW2y7lI1JbFA2D+NE
iFUM5xH8a2f0Vfg59BrRkW+78RYZloiBZUPuQmjBq1gN3dPTpEhnmd32/9FiYbWR
duHF5vOD5aH1LkLeBWQjiqGO3UrI9TfojBQlS3PP58n+Ne7dM4rjPr+q4IK44Ye0
iwKDIeRkRY5cIBE1b/jtDipYNGn9xTijWfgRXxkVe/iSSm+4jUPvNtRc65YvmhpR
cY7TAV4AX/rptB9XkWiHUAp6qfDZDo7/+mc5TPHgL5wMgveCXiWlY7aB+EzpbJba
m0ECo9FREbpyawlq3RGDW373yBaoKUoLAOx0tOAGPZ15oU/YtiXFsENeVr6TKjqP
dfLjNgRmuc0NE83j1lJrDSBoWG58EJ/9Y9LiClftX9oS4jIf7C65TsCNpHZ/TZrR
NoktAf0VkWgjr2yMGQWlOmOYcbn1lTei/MuwL2lST76w7fkNwNnZyVWYhSz2aO8B
GM0cUEEnx5PZJLSNdCH4hXzCHGNSBCHsGtL4qTGq+/WthR5gSxWkKwsPZr8MqVSY
LsJzLXVnypOp6RC0R2JD6o4EVMDEHn64AWbn/mc+CZ0z3wwEMyDKkq7pVBVdVeoB
Rs80ILKSj9pGDLd7zkiiPhFORESccHY8Fb6o8PtiX8MDhtMlFFB6v19fPOOAHyat
4ryjIKQfqW7D7vopp17z
=63sB
-----END PGP SIGNATURE-----

--=-X12ADzBRbaorzvuPfdSy--

