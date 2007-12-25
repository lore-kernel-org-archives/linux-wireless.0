Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbXLYKkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 05:40:40 -0500
Subject: Re: [PATCH] mac80211: Restore rx.fc before every invocation of
	ieee80211_invoke_rx_handlers
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Helmut Schaa <hschaa@suse.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1198553497.3065.237.camel@debian.sh.intel.com>
References: <200712211516.35731.hschaa@suse.de>
	 (sfid-20071221_141215_108356_0F4BE6F7) <1198401880.4116.6.camel@johannes.berg>
	 <20071223123517.17ds9zttxc4goo00@imap.suse.de>
	 <1198417706.4000.1.camel@johannes.berg>
	 <1198467294.3065.180.camel@debian.sh.intel.com>
	 <1198491831.4103.17.camel@johannes.berg>
	 <1198553497.3065.237.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JKf/tn63SlL+3Egfqxvj"
Date: Tue, 25 Dec 2007 11:40:30 +0100
Message-Id: <1198579231.4103.53.camel@johannes.berg> (sfid-20071225_104043_989751_E9DD2C4E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JKf/tn63SlL+3Egfqxvj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-12-25 at 11:31 +0800, Zhu Yi wrote:
> On Mon, 2007-12-24 at 11:23 +0100, Johannes Berg wrote:
> > I don't think it does, does it? In prepare_for_handlers frames aren't
> > sent to the master device while not scanning.
>=20
> Should we also discard frames to mdev if ((rx->fc &
> IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA)?

I guess we should, yeah. In fact, I'd like to make the scan code
short-cut and not go through the master device so we can completely
remove RX on the master.

johannes

--=-JKf/tn63SlL+3Egfqxvj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3DeHaVg1VMiehFYAQLdbQ/+PqcNCOrcACIup32ej1UftOD9HybFiLvP
qvayw2bFa3yvbQr3X/aJloNYX2zY3vvcq+E67VaogX1y6dkZxsxCE3A4mNfZbx5L
FHo0qYcT5rO7XazrTu4hA5OQy12ZwphMFtE4ORyaCsir2840HV04IQr6OAoMAli/
VaBmR/guAtsw86YJFz5azqRdpIqUP8HJjtWw1XgoryUp21o/fPn3QdewGiDXFOm6
TPs8w3Wsd3uOGmWbZ4ty/NoRi+NuJ+tNnx101niJtxtj63YKKyY+3L1cPC9wgX0g
cMBsJs+inHkj02EA9KBNbCi6Q2sWZMn1I4CwfCnqNMch8WeEMMNZwkJf2vumQaCE
ZY92QlPmgEJrtMnRUSNramF48S5BCnRHL2SrYI7cIqZkl+vSryRDpU7gByTuWi98
eIYuyrzW7hRXDJlVO97ZwgDK1E2WDebXvla8WXMH4rB+xsZBXb/nQxmSNVJUZh12
pUfWTGk3fQT3/i91iRvQdigr/y80UxG3fO2W9kCr2aUoU6HDOA1WSOYXUwCP+Dd/
EwUPvRV+nRavdfN7NLz2U5Ahnl+1tonUCokho73qcxG3aacLfzwzddJe4dEJeyyD
Vl2OJfTpaG9K2hrg3PF6iisJhuNDW8ZqT+pTNgj4Ts3VFXGqrLTNb43oK7+v3aj0
dJ45109Si+g=
=AG9F
-----END PGP SIGNATURE-----

--=-JKf/tn63SlL+3Egfqxvj--

