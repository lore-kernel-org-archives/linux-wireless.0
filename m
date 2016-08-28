Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36568 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbcH1VKn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Aug 2016 17:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <2303906.Xe1WvCfP0V@wuerfel>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
 <20160821144906.30984-6-martin.blumenstingl@googlemail.com> <2303906.Xe1WvCfP0V@wuerfel>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sun, 28 Aug 2016 23:10:21 +0200
Message-ID: <CAFBinCCK4zG7QXENpCgEr9wUgzinfr1ugEm3HepjE6c3RDqtVg@mail.gmail.com> (sfid-20160828_231047_621576_F3331970)
Subject: Re: [PATCH 5/5] ath9k: Make EEPROM endianness swapping configurable
 via devicetree
To: Arnd Bergmann <arnd@arndb.de>, nbd@nbd.name
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        chunkeey@googlemail.com, robh+dt@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 22, 2016 at 1:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday, August 21, 2016 4:49:06 PM CEST Martin Blumenstingl wrote:
>> +- qca,check-eeprom-endianness: When enabled, the driver checks if the
>> +                               endianness of the EEPROM (using two checks,
>> +                               one is based on the two magic bytes at the
>> +                               start of the EEPROM and a second one which
>> +                               relies on a flag within the EEPROM data)
>> +                               matches the host system's native endianness.
>> +                               The data will be swapped accordingly if there
>> +                               is a mismatch.
>> +                               Leaving this disabled means that the EEPROM
>> +                               data will always be interpreted in the
>> +                               system's native endianness.
>> +                               Enable this option only when the EEPROMs
>> +                               endianness identifiers are known to be
>> +                               correct, because otherwise the EEPROM data
>> +                               may be swapped and thus interpreted
>> +                               incorrectly.
>
> The property should not describe the driver behavior, but instead
> describe what the hardware is like.
>
> A default of "system's native endianess" should not be specified
> in a binding, as the same DTB can be used with both big-endian or
> little-endian kernels on some architectures (ARM and PowerPC among
> others), so disabling the property means that it is guaranteed to
> be broken on one of the two.
OK, I went back to have a separate look at the whole issue again.
Let's recap, there are two types of swapping:
1. swab16 for the whole EEPROM data
2. EEPROM format specific swapping (for all u16 and u32 values)

Actually I am not 100% sure what #1 exists. In OpenWrt and LEDE it's
only used by the brcm63xx and lantiq targets (I personally have only
lantiq based devices, so that's what I can test with).
Without patch 4 from this series the EEPROM data is loaded like this:
1. out of tree code extracts the EEPROM data from NOR/SPI/NAND flash
2. board specific entry (usually device-tree) tells the code to apply
swab16 to the data
3. board specific entry (usually device-tree again) sets the
"endian_check" property in the ath9k_platform_data to true
4.a ath9k sees that the magic bytes are not matching and applies swab16
4.b while doing that it notifies the EEPROM format specific swapping

However, with patch 4 from this series steps 4.a and 4.b are replaced with:
4. ath9k checks the eepMisc field of the EEPROM and applies the EEPROM
format specific swapping

Currently this code is still guarded by a check whether swapping is
enabled or not.
However, FreeBSD uses the same check but has no guarding if-clause for it.

TL;DR: if we remove if (ah->ah_flags & AH_NO_EEP_SWAP) from patch 4 we
don't need an extra device-tree property.

The question is how we can test this properly:
I can test this on the boards I own (3 in total) - but I don't think
that this is enough.
Maybe we can test this together with some LEDE people - this should
get us test-coverage for embedded devices.
I'm open to more/better suggestions


Regards,
Martin
