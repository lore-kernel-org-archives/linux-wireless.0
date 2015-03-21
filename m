Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49570 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbbCUF0U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2015 01:26:20 -0400
Message-ID: <550D00E7.8020201@rempel-privat.de> (sfid-20150321_062623_906185_AAFBF189)
Date: Sat, 21 Mar 2015 06:25:59 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, kvalo@codeaurora.org,
	adrian@freebsd.org
Subject: Re: [PATCH 16/18] ath9k: use REG_RMW and rmw buffer in ath9k_hw_4k_set_gain
References: <1426855138-6121-1-git-send-email-linux@rempel-privat.de> <1426855138-6121-17-git-send-email-linux@rempel-privat.de> <550C19E1.1020305@openwrt.org>
In-Reply-To: <550C19E1.1020305@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pfb18JVLq1Rb3QXkIlfXldox6fvstJb1n"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pfb18JVLq1Rb3QXkIlfXldox6fvstJb1n
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 20.03.2015 um 14:00 schrieb Felix Fietkau:
> On 2015-03-20 13:38, Oleksij Rempel wrote:
>> it is possible to reduce time needed for this function
>> by rplacing REG_WRITE with REG_RMW (plus dummy 0) and putt all command=
s
>> in same buffer.
>>
>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>> ---
>>  drivers/net/wireless/ath/ath9k/eeprom_4k.c | 18 ++++++++++--------
>>  1 file changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/=
wireless/ath/ath9k/eeprom_4k.c
>> index 291c1d1..56621be 100644
>> --- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
>> +++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
>> @@ -772,15 +772,16 @@ static void ath9k_hw_4k_set_gain(struct ath_hw *=
ah,
>>  				 struct ar5416_eeprom_4k *eep,
>>  				 u8 txRxAttenLocal)
>>  {
>> -	REG_WRITE(ah, AR_PHY_SWITCH_CHAIN_0,
>> -		  pModal->antCtrlChain[0]);
>> +	ENABLE_REG_RMW_BUFFER(ah);
>> +	REG_RMW(ah, AR_PHY_SWITCH_CHAIN_0,
>> +		pModal->antCtrlChain[0], 0);
> How about combining the WRITE/RMW buffering in ath9k_htc (automatically=

> deciding whether to use RMW or WRITE for the whole transaction), instea=
d
> of quirky looking REG_WRITE to REG_RMW conversions?

Yea, i was thinking about this too, but decided to go readable way. Not
to produce unexpected behaviour of WRITE or READ cmd.

>> -	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0),
>> -		  (REG_READ(ah, AR_PHY_TIMING_CTRL4(0)) &
>> -		   ~(AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF |
>> -		     AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
>> -		  SM(pModal->iqCalICh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
>> -		  SM(pModal->iqCalQCh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF));
>> +	REG_RMW(ah, AR_PHY_TIMING_CTRL4(0),
>> +		(REG_READ(ah, AR_PHY_TIMING_CTRL4(0)) &
>> +		 ~(AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF |
>> +		   AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
>> +		SM(pModal->iqCalICh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
>> +		SM(pModal->iqCalQCh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF), 0);
> If you translate it to REG_RMW, you should get rid of the REG_READ part=
=2E

Ok, thank you. I'll take a look.


--=20
Regards,
Oleksij


--pfb18JVLq1Rb3QXkIlfXldox6fvstJb1n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlUNAOsACgkQHwImuRkmbWkzegEAlZoVPGsSrUGp8uzl8L0e4Ika
yq/TaBEKDySTsPvmH7sA/0lu2uFQq8BcS7HBOo7Woub6yUXmaV99jxDu30JyqcC8
=ayem
-----END PGP SIGNATURE-----

--pfb18JVLq1Rb3QXkIlfXldox6fvstJb1n--
