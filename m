Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33427 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752016AbcHVUbu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 16:31:50 -0400
MIME-Version: 1.0
In-Reply-To: <14216135.Y4g7Oly61q@wuerfel>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
 <3744898.ltfZjZgAjj@wuerfel> <CAFBinCBdv9poKwjsDeGue30x0B9aUjxdkb5BHZcBgouOMAGWMQ@mail.gmail.com>
 <14216135.Y4g7Oly61q@wuerfel>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Mon, 22 Aug 2016 22:31:28 +0200
Message-ID: <CAFBinCB0BVCi1cG=w_05MGj3ASyB9wXT37=yANaLdvmzB=AfYw@mail.gmail.com> (sfid-20160822_223154_129301_DF749375)
Subject: Re: [PATCH 2/5] ath9k: Set the "big endian" bit of the AR9003 EEPROM templates
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, chunkeey@googlemail.com, nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 22, 2016 at 5:31 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday, August 22, 2016 1:56:46 PM CEST Martin Blumenstingl wrote:
>> On Mon, Aug 22, 2016 at 1:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Sunday, August 21, 2016 4:49:03 PM CEST Martin Blumenstingl wrote:
>> >> We will default to the system's native endianness for the eepmisc value.
>> >> This may be overwritten by the actual calibration data. If it is not
>> >> overwritten we interpret the template data in it's native endianness,
>> >> meaning that no swapping is required.
>> >
>> > I'm still skeptical about this one. What is the significance of "native
>> > endianess" here? You are keying the endianess of the eeprom tables off the
>> > way the CPU operates, but for a PCI device there is no correlation between
>> > those two.
>> (the ar9003 eeprom format and handling is different compared to 9287,
>> def and 4k)
>> ar9003_eeprom.c contains EEPROM templates -> these are compiled into
>> the ath9k kernel module. Values from these templates can be
>> overwritten by the EEPROM found on the actual hardware.
>> This change tries to handle the case where the values in the hardware
>> EEPROM do not override any of the template values (means final EEPROM
>> data = template data). In this case the we can simply rely on the
>> endianness which was used to compile ath9k.ko.
>
> Ok, I see what you mean now. However, looking at the source now, I
> also see
>
> #define LE16(x) cpu_to_le16(x)
> #define LE32(x) cpu_to_le32(x)
>         .baseEepHeader = {
>                 .regDmn = { LE16(0), LE16(0x1f) },
>
> suggesting that the fields are meant to be little-endian in object
> code, and your patch does not change that. In fact, Felix's
> ffdc4cbe5b17 ("ath9k_hw: clean up EEPROM endian handling on AR9003")
> seems to have corrected this already.
oh, I totally missed that - thanks for the hint!
This means that eepMisc should be 0 (indicates little endian) in all
cases (it had this value, but the code was not explicit about it).

so please ignore this patch for now, it might cause more harm than good.
