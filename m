Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32741 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932455AbcLMMDs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 07:03:48 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC: ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>,
        "nbd@nbd.name" <nbd@nbd.name>
Subject: Re: [PATCH v2 0/7] ath9k: EEPROM swapping improvements
Date: Tue, 13 Dec 2016 12:03:18 +0000
Message-ID: <87twa8yr22.fsf@kamboji.qca.qualcomm.com> (sfid-20161213_130353_309370_EC594742)
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
        <20161002222913.12223-1-martin.blumenstingl@googlemail.com>
        <87insxg0yc.fsf@kamboji.qca.qualcomm.com>
        <871sxza9al.fsf@kamboji.qca.qualcomm.com>
        <CAFBinCC6JWBhZwma=66fBi3_to2SaHOMNDQS23jHNhcc+RUcYQ@mail.gmail.com>
In-Reply-To: <CAFBinCC6JWBhZwma=66fBi3_to2SaHOMNDQS23jHNhcc+RUcYQ@mail.gmail.com>       (Martin
 Blumenstingl's message of "Mon, 12 Dec 2016 21:05:53 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> Hello Kalle,
>
> On Fri, Nov 25, 2016 at 4:06 PM, Valo, Kalle <kvalo@qca.qualcomm.com> wro=
te:
>> Kalle Valo <kvalo@codeaurora.org> writes:
>>
>>> Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:
>>>
>>>> There are two types of swapping the EEPROM data in the ath9k driver.
>>>> Before this series one type of swapping could not be used without the
>>>> other.
>>>>
>>>> The first type of swapping looks at the "magic bytes" at the start of
>>>> the EEPROM data and performs swab16 on the EEPROM contents if needed.
>>>> The second type of swapping is EEPROM format specific and swaps
>>>> specific fields within the EEPROM itself (swab16, swab32 - depends on
>>>> the EEPROM format).
>>>>
>>>> With this series the second part now looks at the EEPMISC register
>>>> inside the EEPROM, which uses a bit to indicate if the EEPROM data
>>>> is Big Endian (this is also done by the FreeBSD kernel).
>>>> This has a nice advantage: currently there are some out-of-tree hacks
>>>> (in OpenWrt and LEDE) where the EEPROM has a Big Endian header on a
>>>> Big Endian system (=3D no swab16 is performed) but the EEPROM itself
>>>> indicates that it's data is Little Endian. Until now the out-of-tree
>>>> code simply did a swab16 before passing the data to ath9k, so ath9k
>>>> first did the swab16 - this also enabled the format specific swapping.
>>>> These out-of-tree hacks are still working with the new logic, but it
>>>> is recommended to remove them. This implementation is based on a
>>>> discussion with Arnd Bergmann who raised concerns about the
>>>> robustness and portability of the swapping logic in the original OF
>>>> support patch review, see [0].
>>>>
>>>> After a second round of patches (=3D v1 of this series) neither Arnd
>>>> Bergmann nor I were really happy with the complexity of the EEPROM
>>>> swapping logic. Based on a discussion (see [1] and [2]) we decided
>>>> that ath9k should use a defined format (specifying the endianness
>>>> of the data - I went with __le16 and __le32) when accessing the
>>>> EEPROM fields. A benefit of this is that we enable the EEPMISC based
>>>> swapping logic by default, just like the FreeBSD driver, see [3]. On
>>>> the devices which I have tested (see below) ath9k now works without
>>>> having to specify the "endian_check" field in ath9k_platform_data (or
>>>> a similar logic which could provide this via devicetree) as ath9k now
>>>> detects the endianness automatically. Only EEPROMs which are mangled
>>>> by some out-of-tree code still need the endian_check flag (or one can
>>>> simply remove that mangling from the out-of-tree code).
>>>>
>>>> Testing:
>>>> - tested by myself on AR9287 with Big Endian EEPROM
>>>> - tested by myself on AR9227 with Little Endian EEPROM
>>>> - tested by myself on AR9381 (using the ar9003_eeprom implementation,
>>>>   which did not suffer from this whole problem)
>>>> - how do we proceed with testing? maybe we could keep this in a
>>>>   feature-branch and add these patches to LEDE once we have an ACK to
>>>>   get more people to test this
>>>>
>>>> This series depends on my other series (v7):
>>>> "add devicetree support to ath9k" - see [4]
>>>
>>> I think this looks pretty good. If there's a bug somewhere it should be
>>> quite easy to fix so I'm not that worried and would be willing to take
>>> these as soon as I have applied the dependency series. IIRC your
>>> devicetree patches will have at least one more review round so that wil=
l
>>> take some time still. In the meantime it would be great if LEDE folks
>>> could take a look at these and comment (or test).
>>
>> So are everyone happy with this? I haven't seen any comments. If I don't
>> here anything I'm planning to take these, most likely for 4.11.
>
> the patches have been in LEDE for almost two weeks now and I did not
> see any reports of ath9k breakage (footnote below).
>
> It seems that there are a few devices out there where the whole EEPROM
> is swab16'ed which switches the position of the 1-byte fields
> opCapFlags and eepMisc.
> those still work fine with the new code, however I had a second patch
> in LEDE [0] which results in ath9k_platform_data.endian_check NOT
> being set anymore.
> that endian_check flag was used before to swab16 the whole EEPROM, to
> correct the position of the 1-byte fields again.
> Currently we are fixing this in the firmware hotplug script: [1]
> This is definitely not a blocker for this series though (if we want to
> have a devicetree replacement for "ath9k_platform_data.endian_check"
> then I'd work on that within a separate series, but I somewhat
> consider these EEPROMs as "broken" so fixing them in
> userspace/firmware hotplug script is fine for me)

Sounds good to me, thanks for the thorough followup. I'm planning to
apply these any day.

--=20
Kalle Valo=
