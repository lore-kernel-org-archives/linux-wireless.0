Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:45692 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0ADSQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 13:16:05 -0500
Received: by iwn32 with SMTP id 32so234400iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jan 2010 10:16:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <40f31dec1001041009r87f677l9c777535c1a057f@mail.gmail.com>
References: <1262619639-21426-1-git-send-email-lrodriguez@atheros.com>
	<40f31dec1001041009r87f677l9c777535c1a057f@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 4 Jan 2010 10:15:43 -0800
Message-ID: <43e72e891001041015h6026607bp34d6cb3440f7aae5@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Fix eeprom checksum check for custom sized eeproms
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	joshuacov@googlemail.com, stephenbeahm@comcast.net,
	stable@kernel.org, David Quan <david.quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 4, 2010 at 10:09 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2010/1/4 Luis R. Rodriguez <lrodriguez@atheros.com>:
>>
>> +
>> +/* FLASH(EEPROM) Defines for AR531X chips */
>> +#define AR5K_EEPROM_SIZE_LOWER         0x1b /* size info -- lower */
>> +#define AR5K_EEPROM_SIZE_UPPER         0x1c /* size info -- upper */
>> +#define AR5K_EEPROM_SIZE_UPPER_MASK    0xfff0
>> +#define AR5K_EEPROM_SIZE_UPPER_SHIFT   4
>> +#define AR5K_EEPROM_SIZE_ENDLOC_SHIFT  12
>> +
>
> AR531X chips are SoCs, are you sure this comment is correct ?

I got that from the legacy HAL, so just using that as a source of
documentation for this.

> In the docs this marks the end of EAR section (and the end of
> checksum) for EEPROMs larger than 16k
> valid values for checksum end are 0x00000C0 to 0x0080000

I didn't see this used, just replicating what I saw in the legacy HAL
to match the code on Linux with what we have on other operating
systems. Not sure about the valid values for the checksum as per
documentation Vs what is implemented, I am just following what I see
implemented to ensure consistency.

> Also to calculate EEPROM size (stored on the first 4 bits of 0x1c) you
> do this according to the docs
> 2 ^ (EEPROM size + 9) and valid values are from 1 to 11 (11 = 1MB)

OK thanks so the eep_max should not be > 11 ?

> There is also an EEPROM size indicator on PCICFG but it seems it's
> only for older chips.

Yeah not sure.

> A value of 0 on 0x1c means we have a 2k EEPROM and an end location 0x0000400.

I don't see this being implemented in the legacy HAL so although it
may be documented I'd avoid adding the code unless we run into issue
with the existing code + this patch.

  Luis
