Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33975 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753566AbcH2TqA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 15:46:00 -0400
MIME-Version: 1.0
In-Reply-To: <201608291410.44338.arnd@arndb.de>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
 <2303906.Xe1WvCfP0V@wuerfel> <CAFBinCCK4zG7QXENpCgEr9wUgzinfr1ugEm3HepjE6c3RDqtVg@mail.gmail.com>
 <201608291410.44338.arnd@arndb.de>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Mon, 29 Aug 2016 21:45:38 +0200
Message-ID: <CAFBinCCSBE8KsLgP3t=FzB-2jgjfQBtuF+EjqQEk-7mmmps_Pg@mail.gmail.com> (sfid-20160829_214603_884440_0B32CE67)
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

On Mon, Aug 29, 2016 at 2:10 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> Without patch 4 from this series the EEPROM data is loaded like this:
>> 1. out of tree code extracts the EEPROM data from NOR/SPI/NAND flash
>> 2. board specific entry (usually device-tree) tells the code to apply
>> swab16 to the data
>> 3. board specific entry (usually device-tree again) sets the
>> "endian_check" property in the ath9k_platform_data to true
>> 4.a ath9k sees that the magic bytes are not matching and applies swab16
>> 4.b while doing that it notifies the EEPROM format specific swapping
>>
>> However, with patch 4 from this series steps 4.a and 4.b are replaced with:
>> 4. ath9k checks the eepMisc field of the EEPROM and applies the EEPROM
>> format specific swapping
>
> I think the intention of the patch is right, but it needs to go further:
> It seems wrong to have 'u32' members e.g. in
>
> struct modal_eep_ar9287_header {
>         u32 antCtrlChain[AR9287_MAX_CHAINS];
>         u32 antCtrlCommon;
>
> and then do a swab32() on them. I suspect these should just be __le32
> (and __le16, respectively where needed), using appropriate accessors
> everywhere that those fields are being read instead of having one function
> that tries to turn them into cpu-native ordering.
I'm not sure if we want those fields to be __le32:
BIT(0) in the eepMisc field indicates whether to interpret the data as
big or little endian.
When this bit is set we would want these fields to be __be32 instead -
so I guess the current implementation is "OK" for this specific
use-case.

> If we can manage to convert the code into doing this consistently,
> maybe only the 16-bit swaps of the data stream are left over.
 we don't need the 16bit swap anymore - at least on the lantiq devices
that I know (not sure about other platforms / devices though).


Martin
