Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59468 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbcDPGDH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 02:03:07 -0400
Subject: Re: [PATCH] ath9k: ar5008_hw_cmn_spur_mitigate: add missing mask_m &
 mask_p initialisation
To: Bob Copeland <me@bobcopeland.com>
References: <120e427452ad7e93f17828e8bba4b043@openmailbox.org>
 <1460482664-21086-1-git-send-email-linux@rempel-privat.de>
 <20160415205939.GA2894@localhost>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, lkml2017@openmailbox.org
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <5711D557.6000803@rempel-privat.de> (sfid-20160416_080313_596299_60C95EEF)
Date: Sat, 16 Apr 2016 08:01:59 +0200
MIME-Version: 1.0
In-Reply-To: <20160415205939.GA2894@localhost>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0oDRBPUGsroRk2kPi6Wkw6IqLDg4qDV3l"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0oDRBPUGsroRk2kPi6Wkw6IqLDg4qDV3l
Content-Type: multipart/mixed; boundary="8PIM03nQ4xtQt5ppB13vn3vpcfkpw4VR2"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
 kvalo@codeaurora.org, lkml2017@openmailbox.org
Message-ID: <5711D557.6000803@rempel-privat.de>
Subject: Re: [PATCH] ath9k: ar5008_hw_cmn_spur_mitigate: add missing mask_m &
 mask_p initialisation
References: <120e427452ad7e93f17828e8bba4b043@openmailbox.org>
 <1460482664-21086-1-git-send-email-linux@rempel-privat.de>
 <20160415205939.GA2894@localhost>
In-Reply-To: <20160415205939.GA2894@localhost>

--8PIM03nQ4xtQt5ppB13vn3vpcfkpw4VR2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 15.04.2016 um 22:59 schrieb Bob Copeland:
> On Tue, Apr 12, 2016 at 07:37:44PM +0200, Oleksij Rempel wrote:
>> by moving common code to ar5008_hw_cmn_spur_mitigate i forgot to move
>> mask_m & mask_p initialisation. This coused a performance regression
>> on ar9281.
>>
>> Fixes: f911085ffa88 ("ath9k: split ar5008_hw_spur_mitigate and reuse c=
ommon code in ar9002_hw_spur_mitigate.")
>> Reported-by: Gustav Frederiksen <lkml2017@openmailbox.org>
>> Tested-by: Gustav Frederiksen <lkml2017@openmailbox.org>
>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>> ---
>>  drivers/net/wireless/ath/ath9k/ar5008_phy.c | 8 +++-----
>>  drivers/net/wireless/ath/ath9k/ar9002_phy.c | 5 -----
>>  2 files changed, 3 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net=
/wireless/ath/ath9k/ar5008_phy.c
>> index 8f87930..1b271b9 100644
>> --- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
>> +++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
>> @@ -274,6 +274,9 @@ void ar5008_hw_cmn_spur_mitigate(struct ath_hw *ah=
,
>>  	};
>>  	static const int inc[4] =3D { 0, 100, 0, 0 };
>> =20
>> +	memset(&mask_m, 0, sizeof(int8_t) * 123);
>> +	memset(&mask_p, 0, sizeof(int8_t) * 123);
>> +
>=20
> For a future patch, "sizeof(mask_m)" or even just:
>=20
>     u8 mask_m[123] =3D {0};
>=20
> ... would be better here.  I looked at this bit and thought, no way is
> "123" actually correct.  Lo and behold, that is actually the number of
> array elements, whether that has a basis in something real or not :)

If you already on it can you please rework it on top of this patch?
This complete function can be probably reworked.

--=20
Regards,
Oleksij


--8PIM03nQ4xtQt5ppB13vn3vpcfkpw4VR2--

--0oDRBPUGsroRk2kPi6Wkw6IqLDg4qDV3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlcR1YMACgkQHwImuRkmbWkD1QD/chAQl4Nq1jpZnaTBTa0cyH7t
BKpbFLTj4Em8vPxHJ9UA/3slY1DfE2qoshwjuR/JiyaoV7KiAfmoWV9OoEmtPMwu
=IKTK
-----END PGP SIGNATURE-----

--0oDRBPUGsroRk2kPi6Wkw6IqLDg4qDV3l--
