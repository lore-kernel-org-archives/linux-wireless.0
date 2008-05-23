Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbYEWJML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 05:12:11 -0400
Subject: Re: BUG: scheduling while atomic (2.6.26-rc3...)
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Price <andy@andrewprice.me.uk>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <g158ou$ts7$1@ger.gmane.org> (sfid-20080523_040537_383935_93B9797D)
References: <g158ou$ts7$1@ger.gmane.org>
	 (sfid-20080523_040537_383935_93B9797D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ra3CwS0K7L5pLp09bOWq"
Date: Fri, 23 May 2008 11:11:13 +0200
Message-Id: <1211533873.18247.0.camel@johannes.berg> (sfid-20080523_111216_124642_1A058359)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ra3CwS0K7L5pLp09bOWq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-23 at 03:05 +0100, Andrew Price wrote:
> Hi,
>=20
> I'm seeing this bug when I boot but unfortunately the messages don't
> seem to get logged and the system locks so I took a photo of as much as
> could fit on my laptop's screen:
> http://sucs.org/~welshbyte/wirelesstraces.jpg (sorry about the bad qualit=
y).
>=20
> Anyway, I've bisected it down to commit
> 2f561feb386d6adefbad63c59a1fcd298ac6a79c "mac80211: Add RTNL version of
> ieee80211_iterate_active_interfaces"
>=20
> lspci says I'm using a:
>=20
> 02:00.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 0=
1)

Looks like rt2x00 actually needs both versions of the function.

johannes

--=-Ra3CwS0K7L5pLp09bOWq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDaKMKVg1VMiehFYAQKGbQ/+KyGTavpRFNeD1SIm1lWvOj9rdxTNyVTm
orRmdh/bGUGt1J0EJur9a2irqe8f7wMT5omBeqQ++oQo/KNrESZjVT5tOygyI38c
Wkm9MjexSltnnDJ3kuo+H4kR3I3YGXSQFzT5ddlJEXjXgYv87k6NSywnIivdHatc
WHByxt4nAZ4MpTAgINlVH4GxTWGsVFLnwR2vTcMCq8yiKuRz+4vQKJnOkeN9wRC6
FcXPguI1DiI4IH41wnZwtn3Q17fogDbieNMXpSTcvPKhKqsSYawbgwN2IkU29LYw
bCA5LepMhJQMtIlFgVQPTu+HCZC7+sLVKdND3k/ZiAcLTSdV2QgoINglAgruUTLz
4a3FTnUElededzVwpTMzHsTRwiiJqKAzPgPCWNP4+cD+MSXnNKxyG/Mm+leinJXQ
zBGvk8UDC9xZlTmCfg1bw1ogwMkjolvLvQ0vx87P9wGyn3JETOujy6l2rzJTjav4
gWuEX2p7Ka+EEA0YJXDzMfqcTeSyUveGBL5kd2c2jHLewT196YZoqctv8ucnUeXU
2C/SU6ON4oy+dn9dl6Px2aEKAh2mRon75XzEuPnKNiP3Y3FjB/lVzHguHaaZNsyl
xdn+PCOiKMz71GPL6QBdO3eQbo9A4NuJJr4CZudJApJGWSshcPkDX0cDSPINty3N
H/E/APR4Ik0=
=I3YK
-----END PGP SIGNATURE-----

--=-Ra3CwS0K7L5pLp09bOWq--

