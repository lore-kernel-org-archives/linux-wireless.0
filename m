Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbXGZPjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 11:39:47 -0400
Subject: Re: driver bugs with changed mac address
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <46A80535.7060301@gentoo.org>
References: <1182333938.3714.53.camel@johannes.berg>
	 <46A80535.7060301@gentoo.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UtIo39Mc8ITIzUDix/Bb"
Date: Thu, 26 Jul 2007 17:39:41 +0200
Message-Id: <1185464381.4006.26.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UtIo39Mc8ITIzUDix/Bb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-25 at 22:21 -0400, Daniel Drake wrote:

> Looking at this now, the behaviour you describe is not what happens.=20
> When I bring up an interface set to monitor mode, zd_mac_add_interface()=20
> gets called with a non-NULL mac address, the actual MAC of the device.=20
> So, when zd_mac_open gets called soon after, it calls zd_write_mac_addr=20
> with a non-NULL address, so it succeeds as normal.
>=20
> Should I ignore the above and just set an all-zero MAC in the hardware=20
> when a monitor interface is brought up? (setting all-zero will disable ac=
ks)

Oh, hm, it looks like there's a behavioural difference in mac80211 when
you have IEEE80211_HW_MONITOR_DURING_OPER vs. when you don't.

johannes

--=-UtIo39Mc8ITIzUDix/Bb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGqMA9/ETPhpq3jKURAlNSAKCYC5faM4oLS+9hxOBTOqlzue4MPwCfcQ9E
B0AHRCHfinunAJhygsrwD1w=
=P2NL
-----END PGP SIGNATURE-----

--=-UtIo39Mc8ITIzUDix/Bb--

