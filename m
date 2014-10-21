Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55771 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932551AbaJUN4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 09:56:48 -0400
Message-ID: <5446660B.4040602@rempel-privat.de> (sfid-20141021_155652_583859_24C230F7)
Date: Tue, 21 Oct 2014 15:56:27 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Li, Hongchun" <lihongchun@cn.fujitsu.com>,
	"(ath9k-devel@lists.ath9k.org)" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] IBSS network crashes after one device leaves network
References: <C7367401563A9D46BC5A92B9456C061D48D210@G08CNEXMBPEKD03.g08.fujitsu.local>	 <54455DDF.50305@rempel-privat.de> (sfid-20141020_211003_234775_62CEB57E) <1413833356.32358.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1413833356.32358.4.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9H47QJhWi0j5V3OHkO6MeJTFIlWqnEau9"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9H47QJhWi0j5V3OHkO6MeJTFIlWqnEau9
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 20.10.2014 um 21:29 schrieb Johannes Berg:
> On Mon, 2014-10-20 at 21:09 +0200, Oleksij Rempel wrote:
>> Hi Johannes,
>>
>> since this function was added by you, may be you can help here (commit=

>> f09603a259). ath9k_htc support max 8 STAs in AP or ADHOC mode.  If mor=
e
>> then 8 stations connected, driver will return error, but
>> sta_info_insert_drv_state() setting it to zero.
>> What was initial purpose of this?
>=20
> The reason for this is that it's pointless to do anything else - the
> station will try to communicate with us since there's no protocol that
> allows rejecting the link. We therefore don't fail here, and try to
> communicate with the station anyway - that might end up with not having=

> proper rate scaling etc. but is still better.
>=20
> johannes

hmm.. suddenly rate scaling is not singe limitation of ath9k-htc.
Firmware keeps some information for each STA and trying to reduce usb
bandwidth. If i understand it correctly, ath10k works in the same way.
It means, early or soon we need to work with some hard limits.
--=20
Regards,
Oleksij



--9H47QJhWi0j5V3OHkO6MeJTFIlWqnEau9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlRGZgsACgkQHwImuRkmbWnlYgD+JTM93nOVQgsITOrEeUGNZqxC
D1ehijei3Ufhs3YJgJEBAIOVfVBjJ6RsNOzYwE/9TzL1FZTkHMJQV+9mj94RgnnU
=YIyF
-----END PGP SIGNATURE-----

--9H47QJhWi0j5V3OHkO6MeJTFIlWqnEau9--
