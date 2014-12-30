Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52351 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaL3KSe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 05:18:34 -0500
Message-ID: <54A27BEE.4020603@rempel-privat.de> (sfid-20141230_111838_207541_F5C70605)
Date: Tue, 30 Dec 2014 11:18:22 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>,
	adrian@freebsd.org
Subject: Re: [RFC 0/3] add TPC capability for AR9002 based chips
References: <1419689545-26965-1-git-send-email-lorenzo.bianconi83@gmail.com>	<549FFB8F.9010701@rempel-privat.de>	<CAA2SeNKxDk+sgpP9be=8MUgVOBHO26=oA4r4v+wRHfN1b6fH8w@mail.gmail.com>	<54A15896.2020008@rempel-privat.de> <CAA2SeNKM34-DWGFw5ahKVt2N=yr97OK6zCcf=FNRU5jrDJc6gQ@mail.gmail.com>
In-Reply-To: <CAA2SeNKM34-DWGFw5ahKVt2N=yr97OK6zCcf=FNRU5jrDJc6gQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="R13PgDtMkpKn4g0R3pS9Ju8lbe7hIhtTV"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R13PgDtMkpKn4g0R3pS9Ju8lbe7hIhtTV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 29.12.2014 um 15:18 schrieb Lorenzo Bianconi:
>> Am 28.12.2014 um 15:32 schrieb Lorenzo Bianconi:
>>>> Hi, can you please describe some testcases for you patches.
>>>>
>>>
>>> This patchset adds Transmission Power Control (TPC) for AR9002 based
>>> chips. IOW it enables the capability of correct TX power on per-packe=
t
>>> basis. It is preparatory for upcoming Thomas's joint rate and power
>>> control
>>>  algorithm.
>>
>> Do you mean, right now there is no way to test your patches?
>>
>=20
> I have just added TPC support to ath9k. In order to exploit that hw
> feature we have to wait Thomas's algorithm :).
> However in order to test patches you can set tx_power field of
> ath_frame_info data structure in setup_frame_info() to a different
> value (for the moment it is set to MAX_RATE_POWER) and measure the RX
> power on the other end of the link (this is what I did).

Ok, thank you.
We will talk with Adrian how to mesure it at home.

>=20
> Regards,
> Lorenzo
>=20
>>
>>> Regards,
>>> Lorenzo
>>>
>>>> Am 27.12.2014 um 15:12 schrieb Lorenzo Bianconi:
>>>>> This patchset adds TPC capability to ath9k for AR9002 based chips
>>>>>
>>>>> *[RFC 1/3]: add TX power per-rate tables to cap TX power in TX desc=
riptor path
>>>>> *[RFC 2/3]: cap per-packet TX power according to TX power per-rate =
tables
>>>>> *[RFC 3/3]: enable per-packet TPC on AR9002 based chips by default
>>>>>
>>>>> This pachset is based on Adrian Chadd's hints
>>>>> (https://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg10396.=
html)
>>>>>
>>>>> Lorenzo Bianconi (3):
>>>>>   ath9k: add power per-rate tables for AR9002 chips
>>>>>   ath9k: add TPC to TX path for AR9002 based chips
>>>>>   ath9k: enable per-packet TPC on AR9002 based chips
>>>>>
>>>>>  drivers/net/wireless/ath/ath9k/ar5008_phy.c  | 80 ++++++++++++++++=
++++++++++++
>>>>>  drivers/net/wireless/ath/ath9k/debug.c       |  5 --
>>>>>  drivers/net/wireless/ath/ath9k/eeprom_4k.c   | 14 +++++
>>>>>  drivers/net/wireless/ath/ath9k/eeprom_9287.c | 15 ++++++
>>>>>  drivers/net/wireless/ath/ath9k/eeprom_def.c  | 14 +++++
>>>>>  drivers/net/wireless/ath/ath9k/hw.c          |  3 +-
>>>>>  drivers/net/wireless/ath/ath9k/hw.h          |  2 +
>>>>>  drivers/net/wireless/ath/ath9k/xmit.c        | 66 ++++++++++++++++=
+++----
>>>>>  8 files changed, 181 insertions(+), 18 deletions(-)
>>>>>
>>>>
>>>>
>>>> --
>>>> Regards,
>>>> Oleksij
>>>>
>>>
>>>
>>>
>>
>>
>> --
>> Regards,
>> Oleksij
>>
>=20
>=20
>=20


--=20
Regards,
Oleksij


--R13PgDtMkpKn4g0R3pS9Ju8lbe7hIhtTV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlSie+4ACgkQHwImuRkmbWmMhQD/VUSzbk7pWnQsjArctdgN3qNO
a7+ZkXBmkmCU04olSwIA/i/Yy1wX/gqmJCvA5l6ZYSI7HwytKViBkAER+XRQALA0
=ymK/
-----END PGP SIGNATURE-----

--R13PgDtMkpKn4g0R3pS9Ju8lbe7hIhtTV--
