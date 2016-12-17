Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35109 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756832AbcLQOka (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Dec 2016 09:40:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=3zox7QkFUA-3yxtvSTzPT4GiFkoOUU3cPTXSN4xV8vQ@mail.gmail.com>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
 <20161002222913.12223-1-martin.blumenstingl@googlemail.com>
 <87insxg0yc.fsf@kamboji.qca.qualcomm.com> <871sxza9al.fsf@kamboji.qca.qualcomm.com>
 <CAFBinCC6JWBhZwma=66fBi3_to2SaHOMNDQS23jHNhcc+RUcYQ@mail.gmail.com> <CAJ-Vmo=3zox7QkFUA-3yxtvSTzPT4GiFkoOUU3cPTXSN4xV8vQ@mail.gmail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sat, 17 Dec 2016 15:40:07 +0100
Message-ID: <CAFBinCCmTSAQwZ1Gff=NVuGc5s4_i7k9oqBfB6XnQae_zeJ9gg@mail.gmail.com> (sfid-20161217_154053_672991_08D4963F)
Subject: Re: [PATCH v2 0/7] ath9k: EEPROM swapping improvements
To: Adrian Chadd <adrian@freebsd.org>
Cc: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>,
        "nbd@nbd.name" <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

On Wed, Dec 14, 2016 at 7:45 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> hi,
>
> On 12 December 2016 at 12:05, Martin Blumenstingl
> <martin.blumenstingl@googlemail.com> wrote:
>
>>
>> It seems that there are a few devices out there where the whole EEPROM
>> is swab16'ed which switches the position of the 1-byte fields
>> opCapFlags and eepMisc.
>> those still work fine with the new code, however I had a second patch
>> in LEDE [0] which results in ath9k_platform_data.endian_check NOT
>> being set anymore.
>> that endian_check flag was used before to swab16 the whole EEPROM, to
>> correct the position of the 1-byte fields again.
>> Currently we are fixing this in the firmware hotplug script: [1]
>> This is definitely not a blocker for this series though (if we want to
>> have a devicetree replacement for "ath9k_platform_data.endian_check"
>> then I'd work on that within a separate series, but I somewhat
>> consider these EEPROMs as "broken" so fixing them in
>> userspace/firmware hotplug script is fine for me)
>
> As a reference - the reference driver has been doign this for a while.
> It attempts to detect the endianness by looking at the 0xa55a
> signature endian and figuring out which endian the actual contents are
> in.
>
> So just FYI yeah, this is a "thing" for reasons I don't quite know.
on all devices I have seen so far (all customer devices, no
development boards) these two magic bytes *can* be used to detect the
endianness of the data that is written to the PCI memory (and thus
whether swapping of that data is required or not).
however, there are many devices (roughly 50% of the ones I've seen)
where the magic bytes cannot be used to swap the actual EEPROM (=
calibration) data because they are "inverted". reading the eepMisc
byte works fine on all devices I've seen so far *if* the manufacturer
did not swab16 all data (PCI memory and EEPROM data).

on the other hand you are right: all four devices which were broken
had the correct magic bytes at the start, but as long as this is not
the case for all devices we cannot use it without some feature-flag.

as an (unrelated) side-note: I've also some EEPROMs where the length
matches neither the "magic bytes endianness" nor the "eepMisc
endianness". I consider these broken as well, but fortunately ath9k
has a fallback for this issue.


Regards,
Martin
