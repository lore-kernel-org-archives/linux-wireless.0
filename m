Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:61083 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756124AbcHVPcB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 11:32:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, chunkeey@googlemail.com, nbd@nbd.name
Subject: Re: [PATCH 2/5] ath9k: Set the "big endian" bit of the AR9003 EEPROM templates
Date: Mon, 22 Aug 2016 17:31:23 +0200
Message-ID: <14216135.Y4g7Oly61q@wuerfel> (sfid-20160822_173316_848964_458BD48D)
In-Reply-To: <CAFBinCBdv9poKwjsDeGue30x0B9aUjxdkb5BHZcBgouOMAGWMQ@mail.gmail.com>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com> <3744898.ltfZjZgAjj@wuerfel> <CAFBinCBdv9poKwjsDeGue30x0B9aUjxdkb5BHZcBgouOMAGWMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, August 22, 2016 1:56:46 PM CEST Martin Blumenstingl wrote:
> On Mon, Aug 22, 2016 at 1:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Sunday, August 21, 2016 4:49:03 PM CEST Martin Blumenstingl wrote:
> >> We will default to the system's native endianness for the eepmisc value.
> >> This may be overwritten by the actual calibration data. If it is not
> >> overwritten we interpret the template data in it's native endianness,
> >> meaning that no swapping is required.
> >
> > I'm still skeptical about this one. What is the significance of "native
> > endianess" here? You are keying the endianess of the eeprom tables off the
> > way the CPU operates, but for a PCI device there is no correlation between
> > those two.
> (the ar9003 eeprom format and handling is different compared to 9287,
> def and 4k)
> ar9003_eeprom.c contains EEPROM templates -> these are compiled into
> the ath9k kernel module. Values from these templates can be
> overwritten by the EEPROM found on the actual hardware.
> This change tries to handle the case where the values in the hardware
> EEPROM do not override any of the template values (means final EEPROM
> data = template data). In this case the we can simply rely on the
> endianness which was used to compile ath9k.ko.

Ok, I see what you mean now. However, looking at the source now, I
also see

#define LE16(x) cpu_to_le16(x)
#define LE32(x) cpu_to_le32(x)
        .baseEepHeader = {
                .regDmn = { LE16(0), LE16(0x1f) },

suggesting that the fields are meant to be little-endian in object
code, and your patch does not change that. In fact, Felix's
ffdc4cbe5b17 ("ath9k_hw: clean up EEPROM endian handling on AR9003")
seems to have corrected this already.

	Arnd
