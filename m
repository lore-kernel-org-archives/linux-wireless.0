Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32800 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754196AbcHVL5J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 07:57:09 -0400
MIME-Version: 1.0
In-Reply-To: <3744898.ltfZjZgAjj@wuerfel>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
 <20160821144906.30984-3-martin.blumenstingl@googlemail.com> <3744898.ltfZjZgAjj@wuerfel>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Mon, 22 Aug 2016 13:56:46 +0200
Message-ID: <CAFBinCBdv9poKwjsDeGue30x0B9aUjxdkb5BHZcBgouOMAGWMQ@mail.gmail.com> (sfid-20160822_135713_098279_155D1DEE)
Subject: Re: [PATCH 2/5] ath9k: Set the "big endian" bit of the AR9003 EEPROM templates
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, chunkeey@googlemail.com, nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 22, 2016 at 1:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday, August 21, 2016 4:49:03 PM CEST Martin Blumenstingl wrote:
>> We will default to the system's native endianness for the eepmisc value.
>> This may be overwritten by the actual calibration data. If it is not
>> overwritten we interpret the template data in it's native endianness,
>> meaning that no swapping is required.
>
> I'm still skeptical about this one. What is the significance of "native
> endianess" here? You are keying the endianess of the eeprom tables off the
> way the CPU operates, but for a PCI device there is no correlation between
> those two.
(the ar9003 eeprom format and handling is different compared to 9287,
def and 4k)
ar9003_eeprom.c contains EEPROM templates -> these are compiled into
the ath9k kernel module. Values from these templates can be
overwritten by the EEPROM found on the actual hardware.
This change tries to handle the case where the values in the hardware
EEPROM do not override any of the template values (means final EEPROM
data = template data). In this case the we can simply rely on the
endianness which was used to compile ath9k.ko.

I also noted that this is missing a signed-off-by tag as well (sorry
for that, I will re-send it together with the other patch next
weekend)
