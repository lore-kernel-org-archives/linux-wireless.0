Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53279 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbcFDU1l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 16:27:41 -0400
Subject: Re: ath9k_htc firmware
To: bruce m beach <brucembeach@gmail.com>
References: <CAArymCnfQaa29D2EXGzwOrp0yvXES+Qq1X-HbSUxC6gig8pH_A@mail.gmail.com>
 <57526D1D.9000305@gmx.net>
 <CAArymCm7SgKyK_cy+MucMb5-8nDZshiOCu-mPVyKR6WnNCm5Lg@mail.gmail.com>
Cc: ath9k-devel@lists.ath9k.org, ath9k_htc_fw@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <57533996.905@rempel-privat.de> (sfid-20160604_222743_701822_733CCCA0)
Date: Sat, 4 Jun 2016 22:27:02 +0200
MIME-Version: 1.0
In-Reply-To: <CAArymCm7SgKyK_cy+MucMb5-8nDZshiOCu-mPVyKR6WnNCm5Lg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FIEWbgEHagX61w69PGl3PgDHSPenSCkJi"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FIEWbgEHagX61w69PGl3PgDHSPenSCkJi
Content-Type: multipart/mixed; boundary="Tj59g2wt8XreoWesPEjfBRFdwndmRTts2"
From: Oleksij Rempel <linux@rempel-privat.de>
To: bruce m beach <brucembeach@gmail.com>
Cc: ath9k-devel@lists.ath9k.org, ath9k_htc_fw@lists.infradead.org,
 linux-wireless@vger.kernel.org
Message-ID: <57533996.905@rempel-privat.de>
Subject: Re: ath9k_htc firmware
References: <CAArymCnfQaa29D2EXGzwOrp0yvXES+Qq1X-HbSUxC6gig8pH_A@mail.gmail.com>
 <57526D1D.9000305@gmx.net>
 <CAArymCm7SgKyK_cy+MucMb5-8nDZshiOCu-mPVyKR6WnNCm5Lg@mail.gmail.com>
In-Reply-To: <CAArymCm7SgKyK_cy+MucMb5-8nDZshiOCu-mPVyKR6WnNCm5Lg@mail.gmail.com>

--Tj59g2wt8XreoWesPEjfBRFdwndmRTts2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 04.06.2016 um 21:44 schrieb bruce m beach:
>>> I'm looking for some kind of simple request in the ath9k_htc driver, =
through
>>> the usb ep0, like a memory read on the card, where a urb is sent with=

>>> the resulting chain of events. The simpler the better. The simplest.
>=20
>> For EP0 on drivers site:
>> static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
>> {
>> int transfer, err;
>> const void *data =3D hif_dev->fw_data;
>> size_t len =3D hif_dev->fw_size;
>> u32 addr =3D AR9271_FIRMWARE;
>> u8 *buf =3D kzalloc(4096, GFP_KERNEL);
>> u32 firm_offset;
>> ...
>=20
>   What about the code for setting and resetting leds ???
>=20
> Bruce

It is EP3/EP4 and it is not working without firmware.
Here is one example how you can add new command to firmware:
https://github.com/olerem/open-ath9k-htc-firmware/commit/c73c159303e30a28=
e2d3dc05ba0d2d15504e5fad


And for kernel driver:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?i=
d=3D8badb50cfab6d433622dbfd5a90b6adf27333107


PS: Grr... today i send message from wrong email. Sorry for the spam



--=20
Regards,
Oleksij


--Tj59g2wt8XreoWesPEjfBRFdwndmRTts2--

--FIEWbgEHagX61w69PGl3PgDHSPenSCkJi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAldTOZsACgkQHwImuRkmbWlf0AD+K8ZwC1Bd5BLdbCiCIL3Jnnha
sNLPpEI8fo2FgZ8117UA/AzdybWrisypNQ+tUAMqo5WaTMWwazB4wzby3RmCw7BT
=C45j
-----END PGP SIGNATURE-----

--FIEWbgEHagX61w69PGl3PgDHSPenSCkJi--
