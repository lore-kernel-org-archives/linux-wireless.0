Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40797 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab1DJSGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 14:06:34 -0400
Received: by qyg14 with SMTP id 14so3480841qyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 11:06:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1302457754.5282.219.camel@localhost>
References: <1302450962.5282.129.camel@localhost>
	<BANLkTi=-bRn_6yie1b=wxgVowqZq6+03CQ@mail.gmail.com>
	<1302457754.5282.219.camel@localhost>
Date: Sun, 10 Apr 2011 20:06:33 +0200
Message-ID: <BANLkTi=o3P7PbcjW1n_dnhtwX08UE4t2+Q@mail.gmail.com>
Subject: Re: Firmware files for Ralink RT28x0
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> On Sun, Apr 10, 2011 at 5:56 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>> > I notice that rt2800{pci,usb} each specify only one firmware image,
>> > regardless of the controller version.
>> >
>> > This is inconsistent with rt28{6,7}0sta and with the firmware images in
>> > linux-firmware.
>>
>> Well the rt2800pci/usb firmware behavior is consistent with the original
>> Ralink drivers (Not sure about the staging drivers, I only look to the drivers
>> on the Ralink website).
>
> Are you referring to the #ifdef BIN_IN_FILE code?  This code is not
> enabled, so you should assume it is broken.  I suspect that it was
> intended to ease firmware development.

Not only BIN_IN_FILE, but the .bin files provided in the Ralink package
itself. At some point I grabbed all .bin files from all Ralink packages,
and compared them.

I also grabbed the firmware files, which Ralink provided separately,
Basically it was very clear that the firmware provided by rt3070, was
a simple later release of the rt2860 firmware (which is still used
for rt2860 devices).

So with new versions of the firmware, support for new chipsets was
being addded.

> Ralink provides multiple drivers per bus type for RT28xx and later
> chips.  For PCI devices they split between RT2860 and RT309x; for USB
> devices they split between RT2870 and RT307x (I think - the chip model
> numbers don't seem to be stated consistently).
>
> In addition, the USB drivers have two separate images packed together
> and they can select different images based on the controller version:
>
> #ifdef RTMP_MAC_USB
>                if ((Version != 0x2860) && (Version != 0x2872) && (Version != 0x3070))
>                {       // Use Firmware V2.
>                        //printk("KH:Use New Version,part2\n");
>                        pFirmwareImage = (PUCHAR)&FirmwareImage[FIRMWAREIMAGEV1_LENGTH];
>                        FileLength = FIRMWAREIMAGEV2_LENGTH;
>                }
>                else
>                {
>                        //printk("KH:Use New Version,part1\n");
>                        pFirmwareImage = FirmwareImage;
>                        FileLength = FIRMWAREIMAGEV1_LENGTH;
>                }
> #endif // RTMP_MAC_USB //
>
> The firmware blobs in RT2870 version 2009-08-20 and RT3070 version
> 2009-05-25 are all marked as version 17 (or 0.17), but *they all have
> different contents*.

How do you determine this version? I usually check the last couple
of bytes of the firmware file. (The last 2 bytes of the firmware is the CRC,
but the 2 bytes before that is the version).

> I attempted to maintain the same version selection logic when converting
> the staging drivers to use the firmware loader, since I assumed there
> was a good reason for it.
>
>> As for the linux-firmware that contains some firmware files for rt30** chipsets,
>> but that are not used by rt2800pci/usb for the simple reason that the latest
>> version of the rt2860.bin and rt2870.bin files contain support for
>> those chipsets
>> as well.
>
> So I have heard.  But do they still support the original chips
> correctly?

Yes, I am using the latest firmware for my rt2860/2870 devices
without problems.

>> > If you think that a single image per bus type can cover all controllers,
>> > please identify those firmware images, test them on each hardware
>> > generation, and get them into linux-firmware.
>>
>> Updating the firmware files in the linux-firmware tree seems to be
>> close to impossible. Multiple attempts have been made to update the
>> firmware files for rt73usb, rt61pci, rt2800pci and rt2800usb, and every
>> attempt has been ignored.
>> Even when Ralink sent the update directly, and it seemed that the patches
>> were accepted, they were still not applied.
>
> This roughly matches my experience, except that I have been persistent
> enough to get my changes applied eventually.
>
>> So honestly, I think it might be easier to simply remove the Ralink firmware
>> files from the linux-firmware tree, as then at least the users won't accidently
>> use the outdated firmware files from that tree.
>
> linux-firmware is supposed to have all firmware files referenced by any
> version of Linux; therefore these files must not be removed.

I agree that the firmware should be in linux-firmware, but only if they
are the latest version (and it is possible to keep them up-to-date). Having
outdated firmware in the linux-firmware tree only causes more problems.

> If just two files are sufficient then the other files could be replaced
> by symlinks to them.

Why? The patch to remove the staging drivers has been sent out a few
days ago. After that we only have rt2800pci and rt2800usb drivers,
so we can get rid of the rt30xx files completely. ;)

Ivo
