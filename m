Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634AbYETJOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 05:14:52 -0400
Subject: Re: iwlwifi injection bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
In-Reply-To: <1211249729.2532.59.camel@debian.sh.intel.com>
References: <1210945631.6381.11.camel@johannes.berg>
	 <1211249729.2532.59.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Yku3omZVQK80g7MGbB5H"
Date: Tue, 20 May 2008 11:13:40 +0200
Message-Id: <1211274820.6252.75.camel@johannes.berg> (sfid-20080520_111458_762799_399EFE6B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Yku3omZVQK80g7MGbB5H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >         if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
> >                 IWL_DEBUG_MAC80211("leave - monitor\n");
> >                 return -1;
> >         }
> >=20
> > You see, this will cause mac80211 to resubmit the frame and most
> > likely will totally mess up queue handling and various other things.
>=20
> The monitor mode the driver is using currently is purely a "sniffer". We
> will look into other promiscuous mode supported by the firmware to see
> if we can enable that.

Until then, however, you should return 0 and free the skb there to avoid
messing up the whole networking layer's queuing.

johannes

--=-Yku3omZVQK80g7MGbB5H
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDKWQ6Vg1VMiehFYAQIo3Q/+PnrVhyRteRm+sahHvTZDU2CNaVSCMTP6
gpNWPRUT5RPBZ2ASYC16bjyjpezhjdk0BuTGM/WhlM/Rwuw3sgqz3ZSNNqwXlZw+
QcHq1qvUFVH+Qtx/tbEF53SCXkUgqNoRWTcToM8CtcmETmttG51bMwZqEo4p92eU
/ZYtCzqFpvRH8hG/Aty35So6x28ViFsiPYelWarY/G1pWpOV8Rv0w8m1v6BlZaBM
eAIMUd6LmDNNhhTEDOjkBtvKEVjq4HkLsGVJULJS3qRhgeWUGAaxNY/ajX8SI5KI
vH5+VHWjVwCffqdi6o8dOmXoKtGt38+5AyF/CIW9Y/hfJ7BzsX5nxdnwxQVhZ8D4
Ks+C2Qg0B8SPZkMJzfgzygSoBaCwD1PV0rTrgMrKnsd/HTutrd5ut5sMilQQfvRt
XuqiAYLOptyM9rhmXQC3suNgQnhQhWDNuyTvG0TBlwu31HZXZErZw8HPGHXXFQI+
xRWSz9rGdPuDysK68+EreXTHYWWfELD/Jwj1VFijmpPnwFE/CesTFa64/VVWcYVw
SvvWFCRF5F/LEQlvyJpNk27XoS55DN1uB05JEA7Wy1vro/5GUk62sc6vH9e65pmY
f9MBg8Oat5Z3WhjklWwVpAK+lL7BLgq0GTbS8xOkibM8ZiGuDy9BBwqwWE4zSzci
W664+g+HSoU=
=UOVM
-----END PGP SIGNATURE-----

--=-Yku3omZVQK80g7MGbB5H--

