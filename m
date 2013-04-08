Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.piware.de ([213.9.93.70]:37922 "EHLO www.piware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934520Ab3DHJIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 05:08:48 -0400
Date: Mon, 8 Apr 2013 11:01:52 +0200
From: Martin Pitt <martin.pitt@ubuntu.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, dcbw@redhat.com
Subject: Re: mac80211_hwsim driver attribute
Message-ID: <20130408090152.GA2818@piware.de> (sfid-20130408_110852_108215_14A434BF)
References: <20130403133802.GK2960@piware.de>
 <1364996685.8351.46.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
In-Reply-To: <1364996685.8351.46.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Johannes,

Johannes Berg [2013-04-03 15:44 +0200]:
> Martin,
>=20
> >  /sys/class/net/wlan0/device/driver -> ../../../../bus/pci/drivers/iwlw=
ifi
> >=20
> > But /sys/class/net/wlan1/device/ only has the default "uevent" and
> > subsystem link.
>=20
> I suspect this is because there's no real "device", and therefore no
> real driver.

There are real devices (wlan0, wlan1, etc.); there is also a real
driver (mac80211_hwsim), the only thing that's a bit tricky is that
there is no real bus. My impression is that such devices might belong
to /sys/bus/platform/ ?

> We do play with device_create() in hwsim, which was likely intended to
> address something like this, but I have no idea how this should really
> work.

I figured it out, it works well now. I'll send the patch to the
lists/maintainers, and CC: Dan and you.

Thanks,

Martin
--=20
Martin Pitt                        | http://www.piware.de
Ubuntu Developer (www.ubuntu.com)  | Debian Developer  (www.debian.org)

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRYod9AAoJEPmIJawmtHufPxkP/1xavo0yvXICaGjcEav4pADD
BqnI0bAKQQ+ISG81Fa94h8vRSDyY8yfvC7N3OpB2gZMaCA44as/wKBrFlAmwRV3E
rwsIoH/MXuPkQA3MrzxuCXt2/ejw8JSpQqMqFBjqxbqtXKQqJ/foaVDdONsb1ssd
dWr0yok/7xAaE0wTaI15hH7chJzWLlkXheKwBjoloGXqvrfjGZYyEKTY6gcql41X
/VswZNxesfS+KkLxZEy0Nmn3tqnCk+H8CM7boVeTS04IfzeBoD2NOOH80zrsqVdy
h2cgliM8IgU3o9qQAem4SBezhhpTLcUQfPyMdoa4BrquYHUqIpjJ8/FcEu1cUV1B
qbJl/RZ7SKRUkH1nD+yJeNbLr7FA+a5WePjzWHb0X1SQUddJTDCR52nd2jdlCRE2
RakF4nE+ssJDDYDBD0ngzgnzotFzYi/n1AOzvVWYC5V6Dh6T+WjGRZYvn0J2ccyE
CvibQ+uz1ScoU1U7Ml4PSt4Msiqlsr9h7FZqVWOYQcxnIrjnet1tvua/OoLCSqLj
9i7whUdz0Hz4BX9hKUGU7x16p+IV5LBi6+bZsw2EIWceJllt4oTQuWNvUqnb6Usg
03MlQUvgyVnkYVdX3vaBA/52I+ZVvtGg85MWWE5xKfZp1z9Yf51X1h2l5ecP+S1z
IN6XR3LuoyxfrR/usL+F
=elU/
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
