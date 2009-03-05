Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:47284 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbZCEKn0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 05:43:26 -0500
Message-ID: <49AFACC4.4060500@openwrt.org> (sfid-20090305_114339_171588_EF0DBC06)
Date: Thu, 05 Mar 2009 11:43:16 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: use correct init values for ar9100
 devices
References: <1236103846-1672-1-git-send-email-juhosg@openwrt.org>	<18862.1025.217829.656599@gargle.gargle.HOWL>	<18862.4870.138381.234256@gargle.gargle.HOWL>	<49AE8466.3040906@openwrt.org>	<18862.36430.959276.440720@gargle.gargle.HOWL>	<49AEAA34.8080806@openwrt.org> <18863.12192.871072.649460@gargle.gargle.HOWL>
In-Reply-To: <18863.12192.871072.649460@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith =EDrta:
> Gabor Juhos wrote:
>> Well, I was curious, so I did it. :)
>>
>> After some cut&paste job, here is the diff between the original and =
the new
>> initvals from your patch:
>>
>> diff --git a/drivers/net/wireless/ath9k/initvals.h
>> b/drivers/net/wireless/ath9k/initvals.h
>> index d492363..d5a8aec 100644
>> --- a/drivers/net/wireless/ath9k/initvals.h
>> +++ b/drivers/net/wireless/ath9k/initvals.h
>> @@ -658,7 +657,7 @@ static const u32 ar5416Addac_9100[][2] =3D {
>>      {0x0000989c,  0x00000000 },
>>      {0x0000989c,  0x00000000 },
>>      {0x0000989c,  0x00000000 },
>> -    {0x000098cc,  0x00000000 },
>> +    {0x000098c4,  0x00000000 },
>>  };
>>
>>  static const u32 ar5416Modes[][6] =3D {
>> @@ -862,7 +861,7 @@ static const u32 ar5416Common[][2] =3D {
>>      { 0x00008134, 0x00000000 },
>>      { 0x00008138, 0x00000000 },
>>      { 0x0000813c, 0x00000000 },
>> -    { 0x00008144, 0x00000000 },
>> +    { 0x00008144, 0xffffffff },
>>      { 0x00008168, 0x00000000 },
>>      { 0x0000816c, 0x00000000 },
>>      { 0x00008170, 0x32143320 },
>>
>=20
> Heh. :-)
> Dunno if those 2 values make any difference.

Indeed, these 2 values does not make too much difference.

The first one reverts this commit:
http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-testing.g=
it;a=3Dcommitdiff;h=3D6753ddb4bebecab1039a2a2c8d51d6656d0d0513

With the second one we will use the same initial value (which is in the
ar5416Common_9100, ar5416Common_9160  ar5416Common_9280_2 and
ar5416Common_9285_1_2 arrays currently) for the AR_PHY_ERR_EIFS_MASK re=
gister.

Hm, the ar5416Common_9280 and ar5416Common_9285 arrays are using 0x0000=
0000 for
the same register. By any chance, these values would be wrong in them a=
lso?

>=20
>>>>> +#define AR_SREV_VERSION_9100		0x014
>>>> 0x14?
>>> Yep, this can be fixed.
>> I have to send a new patch, or you will take care of it?
>=20
> Feel free to send a patch fixing this, and the macro cleanup.
> I'll just update the initvals, fix the check for AR9100 in HW attach=20

Well, the _AR9100_OR_LATER would be the right one, simply the macro its=
elf is
wrong. According to Luis' request, I would send a new patchset, then we=
 can
discuss it further based on that.

> and the typo for AR9285 chipsets.

This one can go with a separated patch?

Regards,
Gabor
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
