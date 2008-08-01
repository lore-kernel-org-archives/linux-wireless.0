Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.phnxsoft.com ([195.227.45.4]:1150 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYHAIpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 04:45:30 -0400
Message-ID: <4892CD0C.7040403@imap.cc> (sfid-20080801_104535_154341_682114B6)
Date: Fri, 01 Aug 2008 10:45:00 +0200
From: Tilman Schmidt <tilman@imap.cc>
MIME-Version: 1.0
To: me@felipebalbi.com
CC: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
References: <4891D1B9.70703@imap.cc> <20080731163843.GB9606@kroah.com> <48922FE2.70705@imap.cc> <20080731215055.GB4817@kroah.com> <489242CF.2000100@imap.cc> <20080731232640.GB10436@frodo>
In-Reply-To: <20080731232640.GB10436@frodo>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBABEBC0EE5E97387E5EAB33A"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBABEBC0EE5E97387E5EAB33A
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Felipe, Greg,

Please accept that I am not interested in discussing the merits of
commit 782e70c6fc2290a0395850e8e02583b8b62264d8. You seem to have
a great urge to explain these, and you are of course free to do so
whenever you want, but it is completely irrelevant to my question.
My only concern is to evaluate my options for using this device
with recent Linux releases, and I'll therefore limit my reply to
those of your statements which appear pertinent to that.

On Fri, 1 Aug 2008 02:26:41 +0300, Felipe Balbi wrote:
> And after all, that driver isn't even closed source. I can see in the
> files' header the driver is lgpl (that's actually the first lgpl driver=

> i see :-p)

I think you are mistaken. Only the glue code to recompile for the
target kernel is LGPLed, the binary file which gets linked to it
obviously isn't. Consequently, line 49 of fritz/src/main.c says,
in no unclear words:

MODULE_LICENSE ("Proprietary");

But even if you were right it wouldn't help, because LGPL drivers
aren't permitted to use the USB API either.

> With a few changes to the source file, I could make it build. Don't hav=
e
> the device to test, but I assure you it's pretty simple changes.

Sure thing. In fact, that's what I did before posting my question.
For reference, here's the complete minimal patch needed to make
AVM's fwlanusb-1.00.00.tar.gz driver work on an openSUSE 11.0
system with kernel 2.6.25.11:

diff -rup fritz/src/defs.h fritz.patched/src/defs.h
--- fritz/src/defs.h	2007-07-05 15:00:00.000000000 +0200
+++ fritz.patched/src/defs.h	2008-07-11 17:47:08.000000000 +0200
@@ -60,7 +60,7 @@

  #define	UNUSED_ARG(x)	(x)=3D(x)

-typedef unsigned long uintptr_t;
+//typedef unsigned long uintptr_t;

  /*---------------------------------------------------------------------=
------*\
  \*---------------------------------------------------------------------=
------*/
diff -rup fritz/src/main.c fritz.patched/src/main.c
--- fritz/src/main.c	2007-07-05 15:00:00.000000000 +0200
+++ fritz.patched/src/main.c	2008-07-11 17:48:45.000000000 +0200
@@ -46,7 +46,7 @@

  /*---------------------------------------------------------------------=
------*\
  \*---------------------------------------------------------------------=
------*/
-MODULE_LICENSE ("Proprietary");
+MODULE_LICENSE ("GPL");
  MODULE_DESCRIPTION ("Driver for " PRODUCT_LOGO);

  /*---------------------------------------------------------------------=
------*\
diff -rup fritz/src/wext.c fritz.patched/src/wext.c
--- fritz/src/wext.c	2007-07-05 15:00:00.000000000 +0200
+++ fritz.patched/src/wext.c	2008-07-28 02:37:10.000000000 +0200
@@ -68,7 +68,7 @@ static int fwlanusb_get_name (
  		struct net_device *dev, struct iw_request_info *info,
  		union iwreq_data *wrqu, char *extra) {
  =09
-	strcpy(wrqu->name, "IEEE 802.11b/g");
+	snprintf(wrqu->name, IFNAMSIZ, "IEEE 802.11b/g");
  	return 0;
  }


I guess you can spot the problematic part.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigBABEBC0EE5E97387E5EAB33A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIks0WQ3+did9BuFsRAimrAJ9KBC7OgDcnAH2lXyA6VOsF3tHEqQCdHhTG
4H9jis4Mfn9YWza0ldG2nds=
=+8L4
-----END PGP SIGNATURE-----

--------------enigBABEBC0EE5E97387E5EAB33A--
