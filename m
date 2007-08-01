Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761708AbXHAKDy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 06:03:54 -0400
Subject: Re: Rate control over multiple devices
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20070801004543.GD4719@tuxdriver.com>
References: <46AFB779.4040003@warmcat.com>
	 <20070801004543.GD4719@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0Wt0wM7r823HpudrxVRp"
Date: Wed, 01 Aug 2007 11:32:44 +0200
Message-Id: <1185960764.14279.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0Wt0wM7r823HpudrxVRp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-07-31 at 20:45 -0400, John W. Linville wrote:

> > Just seemed a little strange, maybe it is perfectly fine.
> >=20
> > iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
> > PM: Adding info for No Bus:phy0
> > PM: Adding info for No Bus:wmaster0
> > wmaster0: Selected rate control algorithm 'iwl-3945-rs'
> >=20
> > ...but then we add an rt73usb...
> >=20
> > PM: Adding info for No Bus:phy1
> > PM: Adding info for No Bus:wmaster1
> > wmaster1: Selected rate control algorithm 'iwl-3945-rs' <----
> > PM: Adding info for No Bus:wlan1
> > usbcore: registered new interface driver rt73usb

Weird. But I guess that's because iwl-3945-rs is loaded and available so
it's chosen first or something.

> This looks like the reverse of a dust-up we had a couple of months ago:
>=20
> 	http://marc.info/?l=3Dlinux-wireless&m=3D117875332512693&w=3D2
>=20
> It is possible to change the rate control algorithm now via debugfs.
> In the past someone proposed letting drivers request their default
> rate scaling algorithm, and I think that makes a lot of sense.
> Any thoughts?

Apply the patch already? IIRC James made a pretty good one around that
time to let the driver choose a default name as part of the hw structure
it registers and it can be NULL for the default.

Of course, in a perfect world we'd have a 'default' rate control setting
somewhere and apply that for drivers that have rate_control=3D=3DNULL, whil=
e
default would default to 'simple' to avoid the issue above.

johannes

--=-0Wt0wM7r823HpudrxVRp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsFM8/ETPhpq3jKURAkp6AKC4s7o8s17cd7gElpRXLeMGKVHTwACgoVDH
42a8ARjcI5mKEf2EhzgMI78=
=c4Xl
-----END PGP SIGNATURE-----

--=-0Wt0wM7r823HpudrxVRp--

