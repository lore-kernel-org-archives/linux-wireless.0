Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:37981 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZCDO5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 09:57:38 -0500
Message-ID: <49AE96DA.9010208@openwrt.org> (sfid-20090304_155740_236376_95E8F873)
Date: Wed, 04 Mar 2009 15:57:30 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: use correct init values for ar9100
 devices
References: <1236103846-1672-1-git-send-email-juhosg@openwrt.org>	<18862.1025.217829.656599@gargle.gargle.HOWL>	<49AE851B.2070709@openwrt.org> <18862.36931.112561.497768@gargle.gargle.HOWL>
In-Reply-To: <18862.36931.112561.497768@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith =EDrta:
> Gabor Juhos wrote:
>>>> +#define AR_SREV_5416(_ah) \
>>>> +       (((_ah)->hw_version.macVersion =3D=3D AR_SREV_VERSION_5416=
_PCIE) || \
>>>> +       ((_ah)->hw_version.macVersion =3D=3D AR_SREV_VERSION_5416_=
PCI))
>>>> +#define AR_SREV_5416_V20_OR_LATER(_ah) \
>>>> +       (((_ah)->hw_version.macVersion > AR_SREV_VERSION_5416_PCIE=
) || \
>>>> +       ((AR_SREV_5416(_ah)) && \
>>>> +       ((_ah)->hw_version.macRev >=3D AR_SREV_REVISION_5416_20)))
>>>> +#define AR_SREV_5416_V22_OR_LATER(_ah) \
>>>> +       (((_ah)->hw_version.macVersion > AR_SREV_VERSION_5416_PCIE=
) || \
>>>> +       ((AR_SREV_5416(_ah)) && \
>>>> +       ((_ah)->hw_version.macRev >=3D AR_SREV_REVISION_5416_22)))
>>>> +
>>> Hm, the 5416_V1, 5416_V2 macros have to check 3 different HW (5416,=
 9100, 9160).
>> I don't see any 5416_V1 macro here. The AR_SREV_5416 should check th=
e silicon
>> revision of the AR5416 cards only. But if we would be consistent, we=
 should have
>> a _V10_OR_LATER although i don't see where it would be useful. The _=
V20_OR_LATER
>> and the _V22_OR_LATER macro I proposed above will cover the 9100 and=
 9160 chips.
>>
>=20
> I meant the AR_SREV_5416_V20_OR_LATER and AR_SREV_5416_V22_OR_LATER m=
acros.
> Yes, the naming implies that they are meant for AR5416 chipsets only,=
 but they
> do handle AR9100 and AR9160 chipsets.
>=20
> The proposed macros don't have the AR9100 and AR9160 macVersion check=
s, no ?

You are right, they don't have such version checks explicitly, but

AR_SREV_VERSION_9100 > AR_SREV_VERSION_5416_PCIE and
AR_SREV_VERSION_9160 > AR_SREV_VERSION_5416_PCIE

Maybe this looks cleaner:

#define AR_SREV_5416_V20_OR_LATER(_ah) \
	(((_ah)->hw_version.macVersion >=3D AR_SREV_VERSION_9100) || \
	 ((AR_SREV_5416(_ah)) && \
	 ((_ah)->hw_version.macRev >=3D AR_SREV_REVISION_5416_20)))

#define AR_SREV_5416_V22_OR_LATER(_ah) \
	(((_ah)->hw_version.macVersion >=3D AR_SREV_VERSION_9100) || \
	 ((AR_SREV_5416(_ah)) && \
	 ((_ah)->hw_version.macRev >=3D AR_SREV_REVISION_5416_22)))

or in this form:

#define AR_SREV_5416_V20_OR_LATER(_ah) \
	(((AR_SREV_5416(_ah)) && \
	 ((_ah)->hw_version.macRev >=3D AR_SREV_REVISION_5416_20)) || \
	 ((_ah)->hw_version.macVersion >=3D AR_SREV_VERSION_9100))

#define AR_SREV_5416_V22_OR_LATER(_ah) \
	(((AR_SREV_5416(_ah)) && \
	 ((_ah)->hw_version.macRev >=3D AR_SREV_REVISION_5416_22)) || \
	 ((_ah)->hw_version.macVersion >=3D AR_SREV_VERSION_9100))


Regards,
Gabor

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
