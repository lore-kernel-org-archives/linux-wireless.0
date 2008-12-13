Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:57779 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbYLMMzH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Dec 2008 07:55:07 -0500
Subject: Re: Fuijtsu Lifebook RFKILL support
From: Tony Vroon <tony@linx.net>
Reply-To: tony@linx.net
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-acpi@vger.kernel.org, jwoithe@physics.adelaide.edu.au,
	Peter Gruber <nokos@gmx.net>, linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0812121532580.4064@localhost.localdomain>
References: <1228957506.4045.11.camel@localhost>
	 <20081211165247.GA4844@khazad-dum.debian.net>
	 <1229016827.6446.6.camel@localhost>
	 <20081211194734.GA18132@khazad-dum.debian.net>
	 <1229046602.4030.13.camel@localhost>
	 <20081212195331.GA12679@khazad-dum.debian.net>
	 <alpine.LFD.2.00.0812121532580.4064@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QP5DL0/RTZJmOAFGoOVJ"
Date: Sat, 13 Dec 2008 12:47:45 +0000
Message-Id: <1229172465.4010.11.camel@localhost> (sfid-20081213_135515_733271_335C0B0D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QP5DL0/RTZJmOAFGoOVJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> What is the WLAN driver involved? Is it rfkill-aware?

The driver is iwlagn, which does indeed notice that it is killed. This
information does not reach NetworkManager. Relevant log entries:
Dec 12 00:59:01 amalthea iwlagn: Radio Frequency Kill Switch is On:
Dec 12 00:59:01 amalthea Kill switch must be turned off for wireless
networking to work.

[cutting relevant pieces of text together]
> > 1. rfkill actualy is/looks like a hotplug/hotunplug operation
> >   1b. You cannot do it at will
> >       Attaching it to the rfkill core simply is not supported

Okay, both Bluetooth & WWAN are USB devices following this terminology.
So the rfkill framework is not an appropriate tool for this job,
understood.

Len, I would still like to export the 3 values learned about in this
event to userspace. Is it alright for me to create 3 read-only files on
the platform device? (docked, lid, radios)
It would if anything simplify the code.

> However do NOT do it for WLAN.  Almost every WLAN device knows quite
> well if it is being rfkilled or not by a hardware rfkill line, and it
> is their business to report it.  And the wireless network drivers are
> being ported to connect to the rfkill core.

Okay.

Thanks,
Tony V.

--=-QP5DL0/RTZJmOAFGoOVJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAklDrvEACgkQp5vW4rUFj5p8xwCdHQZCyjgsEVtVxtjqxkb7s0tv
75MAn38TyHe011m03PbGXPEhuG4geJAK
=lc94
-----END PGP SIGNATURE-----

--=-QP5DL0/RTZJmOAFGoOVJ--

