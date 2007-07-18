Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:52934 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754267AbXGRHtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 03:49:43 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: p54usb: Don't run DMA off code segment
Date: Wed, 18 Jul 2007 00:48:31 -0700
Cc: cebbert@redhat.com, linville@redhat.com,
	linux-wireless@vger.kernel.org
References: <20070716231051.0971d9c0.zaitcev@redhat.com>
In-Reply-To: <20070716231051.0971d9c0.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1429006.jJXL2GUeQU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707180048.35762.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1429006.jJXL2GUeQU
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 16 July 2007 23:10, Pete Zaitcev wrote:
> +=A0=A0=A0=A0=A0=A0=A0if ((err =3D p54u_bulk_msg(priv, P54U_PIPE_DATA, bu=
f, 4)) !=3D 0) {
Please follow the style used elsewhere in this function and do it like:

  err =3D p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, 4);
  if (err) {

The rest of the patch looks fine. Thanks for fixing this.

=2DMichael Wu

--nextPart1429006.jJXL2GUeQU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGncXTT3Oqt9AH4aERAiW2AJ9sfIGsR0QhGyP4Bos0MC3HVCKf1gCfVBvW
J+4R9xhUBsRJq3W9oGIZxY0=
=l4wG
-----END PGP SIGNATURE-----

--nextPart1429006.jJXL2GUeQU--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
