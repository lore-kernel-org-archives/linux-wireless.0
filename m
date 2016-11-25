Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5810 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755083AbcKYPGr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 10:06:47 -0500
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
Date: Fri, 25 Nov 2016 15:06:27 +0000
Message-ID: <871sxza9al.fsf@kamboji.qca.qualcomm.com> (sfid-20161125_160653_419502_416750E8)
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
        <20161002222913.12223-1-martin.blumenstingl@googlemail.com>
        <87insxg0yc.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87insxg0yc.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Wed, 12 Oct 2016 16:18:35 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:
>
>> There are two types of swapping the EEPROM data in the ath9k driver.
>> Before this series one type of swapping could not be used without the
>> other.
>>
>> The first type of swapping looks at the "magic bytes" at the start of
>> the EEPROM data and performs swab16 on the EEPROM contents if needed.
>> The second type of swapping is EEPROM format specific and swaps
>> specific fields within the EEPROM itself (swab16, swab32 - depends on
>> the EEPROM format).
>>
>> With this series the second part now looks at the EEPMISC register
>> inside the EEPROM, which uses a bit to indicate if the EEPROM data
>> is Big Endian (this is also done by the FreeBSD kernel).
>> This has a nice advantage: currently there are some out-of-tree hacks
>> (in OpenWrt and LEDE) where the EEPROM has a Big Endian header on a
>> Big Endian system (=3D no swab16 is performed) but the EEPROM itself
>> indicates that it's data is Little Endian. Until now the out-of-tree
>> code simply did a swab16 before passing the data to ath9k, so ath9k
>> first did the swab16 - this also enabled the format specific swapping.
>> These out-of-tree hacks are still working with the new logic, but it
>> is recommended to remove them. This implementation is based on a
>> discussion with Arnd Bergmann who raised concerns about the
>> robustness and portability of the swapping logic in the original OF
>> support patch review, see [0].
>>
>> After a second round of patches (=3D v1 of this series) neither Arnd
>> Bergmann nor I were really happy with the complexity of the EEPROM
>> swapping logic. Based on a discussion (see [1] and [2]) we decided
>> that ath9k should use a defined format (specifying the endianness
>> of the data - I went with __le16 and __le32) when accessing the
>> EEPROM fields. A benefit of this is that we enable the EEPMISC based
>> swapping logic by default, just like the FreeBSD driver, see [3]. On
>> the devices which I have tested (see below) ath9k now works without
>> having to specify the "endian_check" field in ath9k_platform_data (or
>> a similar logic which could provide this via devicetree) as ath9k now
>> detects the endianness automatically. Only EEPROMs which are mangled
>> by some out-of-tree code still need the endian_check flag (or one can
>> simply remove that mangling from the out-of-tree code).
>>
>> Testing:
>> - tested by myself on AR9287 with Big Endian EEPROM
>> - tested by myself on AR9227 with Little Endian EEPROM
>> - tested by myself on AR9381 (using the ar9003_eeprom implementation,
>>   which did not suffer from this whole problem)
>> - how do we proceed with testing? maybe we could keep this in a
>>   feature-branch and add these patches to LEDE once we have an ACK to
>>   get more people to test this
>>
>> This series depends on my other series (v7):
>> "add devicetree support to ath9k" - see [4]
>
> I think this looks pretty good. If there's a bug somewhere it should be
> quite easy to fix so I'm not that worried and would be willing to take
> these as soon as I have applied the dependency series. IIRC your
> devicetree patches will have at least one more review round so that will
> take some time still. In the meantime it would be great if LEDE folks
> could take a look at these and comment (or test).

So are everyone happy with this? I haven't seen any comments. If I don't
here anything I'm planning to take these, most likely for 4.11.

--=20
Kalle Valo=
