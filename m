Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbXIGV70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 17:59:26 -0400
Subject: Re: Kernel panic with rt2500pci built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: Rob Hussey <robjhussey@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <6b8cef970709071438o6870cecej355119fee4396dcb@mail.gmail.com>
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
	 <1189125944.28781.125.camel@johannes.berg>
	 <6b8cef970709071231s5693b835vaf8493254c8292da@mail.gmail.com>
	 <1189193840.28781.197.camel@johannes.berg>
	 <6b8cef970709071438o6870cecej355119fee4396dcb@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JhkPlXbGYxO9Ml4K3aUE"
Date: Sat, 08 Sep 2007 00:00:41 +0200
Message-Id: <1189202441.28781.208.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JhkPlXbGYxO9Ml4K3aUE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-07 at 17:38 -0400, Rob Hussey wrote:

> I took some pictures of the screen with DEBUG_KOBJECT enabled. It's
> tough to get it all though, since the messages don't really fit on one
> screen. I played around with the vga=3D line, and was able to get the
> scrolling to stop at different points (the stack trace and all appears
> about 1 msec after booting, so this was my only choice). The pictures
> can be found here:
> http://www.healthcarelinen.com/misc/
>=20
> These two are probably the best:
> http://www.healthcarelinen.com/misc/101_1988.jpg
> http://www.healthcarelinen.com/misc/101_1992.jpg
>=20
> Hopefully the pictures have what you need.

The line
kobject phy0: registering. parent: <NULL>, set: devices
points out what I thought was the problem. However, I don't understand
why it happens.

In rt2500pci we see:
rt2500pci_probe_hw_mode:
	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_pci(rt2x00dev)->dev);
which expands to
	set_wiphy_dev(hw->wiphy, dev);
which expands to
	wiphy->dev.parent =3D dev;

it is called from rt2500pci_probe_hw which in turn is called from
rt2x00lib_probe_dev, which later calls rt2x00lib_probe_hw which is what
calls ieee80211_register_hw which is the path leading to the bug.

But there's no way &rt2x00dev_pci(rt2x00dev)->dev can be NULL! Sorry, I
don't see right now how this can happen. Anybody have a better idea?

johannes

--=-JhkPlXbGYxO9Ml4K3aUE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4coJ/ETPhpq3jKURAlZJAJwOrBdXzw9BP+pwbuFTPwwEGhq95wCdGL24
TDFEF/oLSOfWvOkYgWTtnDM=
=anJu
-----END PGP SIGNATURE-----

--=-JhkPlXbGYxO9Ml4K3aUE--

