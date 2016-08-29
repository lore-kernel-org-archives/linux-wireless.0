Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36455 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755857AbcH2WH7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 18:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <201608292325.38091.arnd@arndb.de>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
 <201608291410.44338.arnd@arndb.de> <CAFBinCCSBE8KsLgP3t=FzB-2jgjfQBtuF+EjqQEk-7mmmps_Pg@mail.gmail.com>
 <201608292325.38091.arnd@arndb.de>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Tue, 30 Aug 2016 00:07:35 +0200
Message-ID: <CAFBinCCXqX1F3XpU-DFLLB5ZNjU1XVNiTLR-ZB34QgrL8uyv8Q@mail.gmail.com> (sfid-20160830_000803_266090_F470FB71)
Subject: Re: [PATCH 5/5] ath9k: Make EEPROM endianness swapping configurable
 via devicetree
To: Arnd Bergmann <arnd@arndb.de>
Cc: nbd@nbd.name, kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        chunkeey@googlemail.com, robh+dt@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2016 at 11:25 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 29 August 2016, Martin Blumenstingl wrote:
>> > and then do a swab32() on them. I suspect these should just be __le32
>> > (and __le16, respectively where needed), using appropriate accessors
>> > everywhere that those fields are being read instead of having one function
>> > that tries to turn them into cpu-native ordering.
>> I'm not sure if we want those fields to be __le32:
>> BIT(0) in the eepMisc field indicates whether to interpret the data as
>> big or little endian.
>> When this bit is set we would want these fields to be __be32 instead -
>> so I guess the current implementation is "OK" for this specific
>> use-case.
>
> Ok, I see. It's still confusing because it's different from how other
> drivers handle this (case in point: I was very confused by this).
lesson learned: specification should state that data is _either_ big
or little endian, no mix between these two

> Do you see any downsides in changing the code to consistently annotate
> the eeprom as either __le or __be (whichever is more common), using
> the respective endianess accessors, and then doing the swap if the
> data we read is the opposite way?
I am assuming you mean leNN_to_cpu() and beNN_to_cpu() here?

old logic:
- reading data: simply access the struct fields

LE system:
- LE EEPROM -> no swap will be applied
- BE EEPROM -> swab16 / swab32 the fields
BE system:
- LE EEPROM -> swab16 / swab32 the fields
- BE EEPROM -> no swap will be applied

new logic (assuming that we went for __le16/__le32 fields):
- reading data: use le16_to_cpu and le32_to_cpu for all fields

LE system:
- LE EEPROM -> no swap will be applied
- BE EEPROM -> be16_to_cpu / be32_to_cpu (or swab16 / swab32 as before)
BE system:
- LE EEPROM -> le16_to_cpu / le32_to_cpu (or swab16 / swab32 as before)
- BE EEPROM -> no swap will be applied

There is one downside of the "new approach" I can think of: you need
to swap the data twice in some cases (BE EEPROM on a BE machine).
- first swap while writing the data to __le16/__le32 fields
- second swap while reading the data from the __le16/__le32 fields
If you forget to swap a field in either place then things will be broken.

Maybe someone else wants to state his/her opinion on this - I guess
some fresh thoughts could help us a lot!


Regards,
Martin
