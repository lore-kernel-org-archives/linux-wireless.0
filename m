Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193AbXGLKCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 06:02:03 -0400
Subject: Re: d80211 deadlock with wpa_supplicant and rmmod
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: seventh guardian <seventhguardian@gmail.com>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20070711234153.GB5099@tuxdriver.com>
References: <1caff7430707111617o70a534a5x2cf6b611a91f301a@mail.gmail.com>
	 <20070711234153.GB5099@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rcDVXwOhzqZ/Mh9sZvkD"
Date: Thu, 12 Jul 2007 12:02:18 +0200
Message-Id: <1184234538.6669.30.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rcDVXwOhzqZ/Mh9sZvkD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-11 at 19:41 -0400, John W. Linville wrote:

> > >I believe we have a deadlock in d80211.
> >=20
> > I have it too. But I'm using iwl3945 driver, in-kernel mac80211, and a
> > gentoo kernel (basically a patched vanilla-2.6.22.1). My machine is a
> > x86_64 core 2 duo.
> >=20
> > >The following triggers it on my 2way SMT machine with preempt.
> > >
> > >modprobe bcm43xx-d80211
> > >add sta0
> > >ifconfig sta0 up
> > >start wpa_supplicant on the interface
> > >rmmod bcm43xx-d80211

Sounds like the bug with the scheduled work locking. See the
"mac80211/bcm43xx deadlock" thread, there's a patch, report back if you
can/can not reproduce with the patch.

johannes

--=-rcDVXwOhzqZ/Mh9sZvkD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlfwq/ETPhpq3jKURAv2uAJ9BJbZkR9derqS5t/a3nRXMi/IZyQCfTPJh
lwn5hjSgm5XkqvRU3pibfss=
=6yDj
-----END PGP SIGNATURE-----

--=-rcDVXwOhzqZ/Mh9sZvkD--

