Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53787 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZENV0C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 17:26:02 -0400
Subject: Re: [RFC] Simulate medium behavior
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Wagner <wagi@monom.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090514205020.GC3225@newton.monom.org>
References: <20090422092159.GA24586@toronto053.server4you.de>
	 <1240393088.21756.3.camel@johannes.local>
	 <20090422113556.GB24586@toronto053.server4you.de>
	 <20090507184007.GA6684@newton.monom.org>
	 <1241722972.7590.34.camel@johannes.local>
	 <20090514184547.GA3225@newton.monom.org>
	 <1242328369.5799.9.camel@johannes.local>
	 <20090514205020.GC3225@newton.monom.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BXJwuPpsxUIOJJ1QatOu"
Date: Thu, 14 May 2009 23:25:31 +0200
Message-Id: <1242336331.5799.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BXJwuPpsxUIOJJ1QatOu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-14 at 22:50 +0200, Daniel Wagner wrote:

> > >  		data->debugfs_ps =3D debugfs_create_file("ps", 0666,
> > >  						       data->debugfs, data,
> > >  						       &hwsim_fops_ps);
> > > +		data->debugfs_group =3D debugfs_create_file("group", 0666,
> > > +							data->debugfs, data,
> > > +							&hwsim_fops_group);
> >=20
> > Good thing this is a test module only... debugfs files with user access
> > permissions are a security risk. (a user can open the file and leave th=
e
> > fd open, if root then rmmods future reads/writes to the fd by the user
> > crash the kernel)
>=20
> There isn't much we can do about that, right?=20

I generally just use 0600 to not allow regular users to open the files.
Maybe at some point, with the revoke() discussion, we'll actually get a
solution.

johannes

--=-BXJwuPpsxUIOJJ1QatOu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDIxIAAoJEODzc/N7+QmammoP/3bi6ykHlF9nVnAqB2cxrMSx
orkaorE2cPdd9iCZ9VJDUclsdyTZr/uC2IO4n0vvpQGK09ygxgBnG7eOBFj/R9fd
btE2Ty7TbSDdOCmfQ86gFpSvm4pC4F3Xo+GnObW7nQh/nkDHEurWqd30jWsH9zA7
QFUEWvV4LMG7jbYbjJLwXggGS2DfiSsElBwspTlKnxsHAyv4tqb5dWeubMiYqgY7
ngb2h6rz7jcsKuaWuumDfsGspC6uthNErSR6vFiGncMQjAZXg2gxohlyg6kNW+9D
tednDDGxBiT6ro0oaI+dm0wuXrD+ZobPqy2gl/lfQKvrYv/9aY5i+XcRdfizRvru
wqIhWab+qcREQq6KirtOjm4IeBczWUq46x2vFZRzMOWsQa/BXb4JQMIsPtIlqhcl
UxGl3XE/rd1i91MpWcBW1qGV9SzYZhA87HITgCNYOLswHQUbUzUxd65SEjm52tHV
8HyTV6sKA5ez7fju4Y1ZNfDCgrlt52t1Xn0IdvD+7PAKvJ4ryhQlbYWlrnUKoknE
cwwpJkDSniSn6cHI8az8Y/5iK4JLVGuyvNCvt4ytWjNlqsODCXjHKPzFd97h/pEf
dXiav00VErazeY0RoMcLve4Em9Hevlbl734EL0TU7beDS0aM6mjs402W/kaVD2qa
7uohJgIWxyaNWtsvM5o+
=V4eU
-----END PGP SIGNATURE-----

--=-BXJwuPpsxUIOJJ1QatOu--

