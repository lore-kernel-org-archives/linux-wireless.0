Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:33478 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbYFDOTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 10:19:01 -0400
Received: by nf-out-0910.google.com with SMTP id d3so42046nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2008 07:19:00 -0700 (PDT)
Date: Wed, 4 Jun 2008 17:23:14 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless.h: improve userland include-ability
Message-ID: <20080604142307.GA22903@localhost.localdomain> (sfid-20080604_161905_828184_D61304F5)
References: <1212515497-21578-1-git-send-email-linville@tuxdriver.com> <20080603.120515.193703574.davem@davemloft.net> <1212587529.32207.82.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
In-Reply-To: <1212587529.32207.82.camel@pmac.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2008 at 02:52:09PM +0100, David Woodhouse wrote:
> On Tue, 2008-06-03 at 12:05 -0700, David Miller wrote:
> > Yeah, go check so me magic userspace tool header to see what magic is
> > needed just to include a core networking header file correctly.
> >=20
> > No, thanks.
>=20
> Just to clarify: this is only a problem for userspace, and you're
> objecting to that? Just including <linux/wireless.h> within the kernel
> will continue to work.
>=20
> We've traditionally got away with saying 'caveat emptor' when userspace
> includes kernel headers -- you _have_ to include the right
> prerequisites, because the kernel doesn't do it for you.
>=20
> I'm happy enough to change that, but it means seeing stuff like...
> 	#ifndef __KERNEL__
> 	#include <sys/foo.h>
> 	#endif=20
> ... in kernel headers. Is that what you're intending, or am I
> misunderstanding your objection?
>=20
> I believe that the main reason for this patch was that <linux/socket.h>
> and <linux/if.h> both have problems when you include them in the same C
> file as the 'proper' glibc equivalent? Is that something we can address,
> instead of just dropping those includes?

What do you think about hack linke this:

#include <linux/types.h>                /* for __u* and __s* typedefs */
#if defined(__KERNEL__) || !defined(_SYS_SOCKET_H)
#include <linux/socket.h>               /* for "struct sockaddr" et al  */
#endif
#if defined(__KERNEL__) || !defined(_NET_IF_H)
#include <linux/if.h>                   /* for IFNAMSIZ and co... */
#endif

It avoids conflict between glibc's and kernel's headers if glibc's headers=
=20
include first.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhGpU8ACgkQbWYnhzC5v6qRogCfaFWr06+YOq/P/gXaw+qenbDT
/rIAnjp5od1qyjYDlE1C/2uKbOMFM7VL
=ZdEc
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
