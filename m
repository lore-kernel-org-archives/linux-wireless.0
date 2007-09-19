Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:47744 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbXISTnP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 15:43:15 -0400
Received: from storm (pool-71-169-154-64.burl.east.verizon.net [71.169.154.64])
	(authenticated bits=0)
	by mail3.webfaction.com (8.13.1/8.13.3) with ESMTP id l8JJbmLR004495
	for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2007 14:37:48 -0500
Date: Wed, 19 Sep 2007 15:37:43 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: linux-wireless@vger.kernel.org
Subject: VT6656 driver source available from VIA
Message-ID: <20070919193743.GA14127@storm.local.network>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--jho1yZJdad60DJr+
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

A few months ago, VIA quietly released the source for their VT6656 USB WiFi
chip.  The original VIA archive can be downloaded here:

http://www.viaarena.com/Driver/vt6656-linux-x86-src-v113.rar

As I work with VIA hardware regularly as part of my job and some of our
customers would find this driver useful, I spent a little bit of time looki=
ng at
it.  With a slight tweak, it compiled against my 2.6.20 kernel, and seemed =
to be
working fine.  The attached patch illustrates the changes I made to make the
driver compile, however, I'm not much of a kernel hacker, so I can't guaran=
tee
its correctness.

Now, I expect that the kernel developers will want this driver to be worked=
 over
before it could be accepted into the kernel tree, however, the most critical
remaining issue is that of license.  Most of the source files contain the
following notice:

 * Copyright (c) 2003 VIA Networking, Inc. All rights reserved.
 *
 * This software is copyrighted by and is the sole property of
 * VIA Networking, Inc. This software may only be used in accordance
 * with the corresponding license agreement. Any unauthorized use,
 * duplication, transmission, distribution, or disclosure of this
 * software is expressly forbidden.
 *
 * This software is provided by VIA Networking, Inc. "as is" and any
 * express or implied warranties, including, but not limited to, the
 * implied warranties of merchantability and fitness for a particular
 * purpose are disclaimed. In no event shall VIA Networking, Inc. be
 * liable for any direct, indirect, incidental, special, exemplary, or
 * consequential damages.

This doesn't sound very GPL to me, however, the twist is in main_usb.c:

MODULE_LICENSE("GPL");

I am not sure how legally binding this declaration could be.  My guess is t=
hat
it's not.

I have sent some messages to VIA asking for clarification, however, I've not
gotten much of a response.  I can possibly push this harder, but I thought =
I'd
send it this way first to see if it is worth pursuing in the minds of the p=
eople
that would know these things.

What do you think?

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net

--OgqxwSJOaUobr8KG
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="vt6656-compile-with-2.6.20.patch"
Content-Transfer-Encoding: quoted-printable

diff -Naur vt6656.old/driver/main_usb.c vt6656/driver/main_usb.c
--- vt6656.old/driver/main_usb.c	2007-01-18 15:26:04.000000000 -0500
+++ vt6656/driver/main_usb.c	2007-08-21 14:31:11.000000000 -0400
@@ -798,7 +798,9 @@
     netdev->set_multicast_list =3D device_set_multi;
     netdev->do_ioctl           =3D device_ioctl;
 #ifdef WIRELESS_EXT
+#if WIRELESS_EXT < 13
 	netdev->get_wireless_stats =3D iwctl_get_wireless_stats;
+#endif
 #if WIRELESS_EXT > 12
 	netdev->wireless_handlers =3D (struct iw_handler_def *)&iwctl_handler_def;
 //	netdev->wireless_handlers =3D NULL;=09

--OgqxwSJOaUobr8KG--

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG8XqHRO4fQQdv5AwRAgxAAKCVktpSPl1C+BKeX5C0B0N8WlkZkgCdFqxU
3qH6VIu4hTEQycAvLL7fZyU=
=lBDf
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
