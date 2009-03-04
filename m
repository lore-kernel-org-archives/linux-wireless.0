Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:42649 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZCDNl4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 08:41:56 -0500
Message-ID: <49AE851B.2070709@openwrt.org> (sfid-20090304_144159_674099_EC591F87)
Date: Wed, 04 Mar 2009 14:41:47 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Sujith <Sujith.Manoharan@atheros.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [RFC] ath9k: use correct init values for ar9100 devices
References: <1236103846-1672-1-git-send-email-juhosg@openwrt.org> <18862.1025.217829.656599@gargle.gargle.HOWL>
In-Reply-To: <18862.1025.217829.656599@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith =EDrta:
> Gabor Juhos wrote:
>> 1. In some cases the ethernet interface goes down for a short time
>> after'ifconfig wlan0 up'.
>> 2. Sometimes the device simply reboots itself after 'ifconfig wlan0 =
up'.
>>
>> After I have added some printk statements into the code, I noticed t=
hat the
>> ar5416 and ar9100 devices use the same initval arrays currently. I a=
ssume
>> that they requires different initialization, because we have differe=
nt
>> arrays for them.
>>
>=20
> Yep, this is a bug, and AR_SREV_9100_OR_LATER is probably wrong.

Ok.

>=20
>> Although I have no detailed knowledge about the evolution of the ath=
9k devices,
>> but the version checking macros for ther AR5416 cards seemed weird e=
nough, so I
>> have replaced them. Unfortunately, this leaded to very bad performan=
ce with the
>> ar5416 cards I have, but the driver was working on the ar913x boards=
=2E
>>
>> After some digging, I have found an interesting ifdef statement in S=
am's current
>> HAL. In his ar5416Common initval array, this ifdef conditionally sel=
ects the
>> right RTC register offsets for the ar5416/ar9100 devices. The strang=
e thing,
>> that in the ath9k driver the ar5416 specific RTC register offsets ar=
e used in
>> the ar5416Common_ar9100 array, while the ar9100 specific offsets are=
 used in the
>> ar5416Common.
>>
>=20
> I'll check the initval arrays and update.
>=20
>> +#define AR_SREV_5416(_ah) \
>> +       (((_ah)->hw_version.macVersion =3D=3D AR_SREV_VERSION_5416_P=
CIE) || \
>> +       ((_ah)->hw_version.macVersion =3D=3D AR_SREV_VERSION_5416_PC=
I))
>> +#define AR_SREV_5416_V20_OR_LATER(_ah) \
>> +       (((_ah)->hw_version.macVersion > AR_SREV_VERSION_5416_PCIE) =
|| \
>> +       ((AR_SREV_5416(_ah)) && \
>> +       ((_ah)->hw_version.macRev >=3D AR_SREV_REVISION_5416_20)))
>> +#define AR_SREV_5416_V22_OR_LATER(_ah) \
>> +       (((_ah)->hw_version.macVersion > AR_SREV_VERSION_5416_PCIE) =
|| \
>> +       ((AR_SREV_5416(_ah)) && \
>> +       ((_ah)->hw_version.macRev >=3D AR_SREV_REVISION_5416_22)))
>> +
>=20
> Hm, the 5416_V1, 5416_V2 macros have to check 3 different HW (5416, 9=
100, 9160).

I don't see any 5416_V1 macro here. The AR_SREV_5416 should check the s=
ilicon
revision of the AR5416 cards only. But if we would be consistent, we sh=
ould have
a _V10_OR_LATER although i don't see where it would be useful. The _V20=
_OR_LATER
and the _V22_OR_LATER macro I proposed above will cover the 9100 and 91=
60 chips.

>=20
>> +#define AR_SREV_9100(ah) \
>> +       ((ah->hw_version.macVersion) =3D=3D AR_SREV_VERSION_9100)
>>  #define AR_SREV_9100_OR_LATER(_ah) \
>> -       (((_ah)->hw_version.macVersion >=3D AR_SREV_VERSION_5416_PCI=
E))
>> -#define AR_SREV_5416_20_OR_LATER(_ah) \
>> -       (((_ah)->hw_version.macVersion >=3D AR_SREV_VERSION_9160) ||=
 \
>> -               ((_ah)->hw_version.macRev >=3D AR_SREV_REVISION_5416=
_20))
>> -#define AR_SREV_5416_22_OR_LATER(_ah) \
>> -       (((_ah)->hw_version.macVersion >=3D AR_SREV_VERSION_9160) ||=
 \
>> -               ((_ah)->hw_version.macRev >=3D AR_SREV_REVISION_5416=
_22))
>> +       ((_ah)->hw_version.macVersion >=3D AR_SREV_VERSION_9100)
>> +
>>  #define AR_SREV_9160(_ah) \
>>         (((_ah)->hw_version.macVersion =3D=3D AR_SREV_VERSION_9160))
>>  #define AR_SREV_9160_10_OR_LATER(_ah) \
>> --
>> 1.5.3.2
>>

Regards,
Gabor
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
