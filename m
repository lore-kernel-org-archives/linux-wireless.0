Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:58761 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756437AbcH3H6D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 03:58:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: [PATCH 5/5] ath9k: Make EEPROM endianness swapping configurable via devicetree
Date: Tue, 30 Aug 2016 09:57:24 +0200
Cc: nbd@nbd.name, kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        chunkeey@googlemail.com, robh+dt@kernel.org
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com> <201608292325.38091.arnd@arndb.de> <CAFBinCCXqX1F3XpU-DFLLB5ZNjU1XVNiTLR-ZB34QgrL8uyv8Q@mail.gmail.com>
In-Reply-To: <CAFBinCCXqX1F3XpU-DFLLB5ZNjU1XVNiTLR-ZB34QgrL8uyv8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201608300957.24770.arnd@arndb.de> (sfid-20160830_095807_594637_2C5E7684)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 30 August 2016, Martin Blumenstingl wrote:
> new logic (assuming that we went for __le16/__le32 fields):
> - reading data: use le16_to_cpu and le32_to_cpu for all fields
> 
> LE system:
> - LE EEPROM -> no swap will be applied
> - BE EEPROM -> be16_to_cpu / be32_to_cpu (or swab16 / swab32 as before)
> BE system:
> - LE EEPROM -> le16_to_cpu / le32_to_cpu (or swab16 / swab32 as before)
> - BE EEPROM -> no swap will be applied

I think this should be:

LE and BE systems:
 - LE EEPROM -> no swap will be applied
 - BE EEPROM -> or swab16 / swab32

The upside of this is that we no longer care about what the CPU is,
and in my opinion that makes the code easier to understand.

> There is one downside of the "new approach" I can think of: you need
> to swap the data twice in some cases (BE EEPROM on a BE machine).
> - first swap while writing the data to __le16/__le32 fields
> - second swap while reading the data from the __le16/__le32 fields
> If you forget to swap a field in either place then things will be broken.

Correct. Fortunately, "make C=1" with sparse helps you find those bugs
at compile time.

> Maybe someone else wants to state his/her opinion on this - I guess
> some fresh thoughts could help us a lot!

Yes, that would be helpful. It's possible I'm missing something here,
or that changing this will just add confusion with other people.

	Arnd
