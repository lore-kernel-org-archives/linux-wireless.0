Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:32780 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751262AbcL1KPD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 05:15:03 -0500
MIME-Version: 1.0
In-Reply-To: <87vax9r26s.fsf@kamboji.qca.qualcomm.com>
References: <20160905095128.80560-1-nbd@nbd.name> <201609301636.43363.arnd@arndb.de>
 <557be2b8-5ff1-83ea-f6d1-6421c2465969@nbd.name> <201609301658.35039.arnd@arndb.de>
 <87vax9r26s.fsf@kamboji.qca.qualcomm.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 28 Dec 2016 11:08:11 +0100
Message-ID: <CACna6ryikdd0Yt2FWB_JT27N5uuh9XU+JUWNRjs4H5YcD5PVpw@mail.gmail.com> (sfid-20161228_111510_794775_53258400)
Subject: Re: [PATCH v3 1/3] Documentation: dt: net: add mt76 wireless device binding
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Felix Fietkau <nbd@nbd.name>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 October 2016 at 15:29, Kalle Valo <kvalo@codeaurora.org> wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
>
>> On Friday 30 September 2016, Felix Fietkau wrote:
>>> >> >> >> +                 device_type =3D "pci";
>>> >> >> >> +                 mediatek,mtd-eeprom =3D <&factory 0x8000>;
>>> >> >> >> +                 mediatek,2ghz =3D <0>;
>>> >> >
>>> >> > It's not clear what the possible values for the 2ghz property are,
>>> >> > can you be more verbose in the description? How is <0> different
>>> >> > from no property?
>>> >> 0 means disabled, no property means unchanged (compared to EEPROM).
>>> >
>>> > Maybe have a boolean property instead then to say "mediatek,2ghz-disa=
bled" ?
>>> >
>>> > If zero is the only possible value, there is no need to put a number =
in there.
>>> 1 is also possible, which will force-enable the capability.
>>
>> Ok, then both those values should be documented in the binding.
>
> Related to this, Martin sent patches which add generic bindings for
> enabling 2 Ghz and 5 Ghz bands.
>
> [RFC,1/3] Documentation: dt-bindings: add IEEE 802.11 binding documentati=
on
> https://patchwork.kernel.org/patch/9359833/
>
> [RFC,2/3] of: add IEEE 802.11 device configuration support code
> https://patchwork.kernel.org/patch/9359837/

I would prefer something more generic. Many tri-band routers split 5
GHz band into 2 sets of channels and they have separated radios for
them.

E.g. Netgear R8000 has phy0 which should be used for higher part of 5
GHz band (channels 149+) and phy2 which should be used for lower part
of 5 GHz band (channels from 36 to 48 or 64).

What do you think about some more flexible properties like:
ieee80211-min-center-freq
ieee80211-max-center-freq

--=20
Rafa=C5=82
