Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42671 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab0AEXGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 18:06:14 -0500
Received: by ewy19 with SMTP id 19so9025629ewy.21
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 15:06:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e891001041015h6026607bp34d6cb3440f7aae5@mail.gmail.com>
References: <1262619639-21426-1-git-send-email-lrodriguez@atheros.com>
	 <40f31dec1001041009r87f677l9c777535c1a057f@mail.gmail.com>
	 <43e72e891001041015h6026607bp34d6cb3440f7aae5@mail.gmail.com>
Date: Wed, 6 Jan 2010 01:06:11 +0200
Message-ID: <40f31dec1001051506j2648a4ccp4871b6855e1c417@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Fix eeprom checksum check for custom sized eeproms
From: Nick Kossifidis <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	joshuacov@googlemail.com, stephenbeahm@comcast.net,
	stable@kernel.org, David Quan <david.quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/4 Luis R. Rodriguez <lrodriguez@atheros.com>:
> On Mon, Jan 4, 2010 at 10:09 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>> 2010/1/4 Luis R. Rodriguez <lrodriguez@atheros.com>:
>>>
>>> +
>>> +/* FLASH(EEPROM) Defines for AR531X chips */
>>> +#define AR5K_EEPROM_SIZE_LOWER         0x1b /* size info -- lower */
>>> +#define AR5K_EEPROM_SIZE_UPPER         0x1c /* size info -- upper */
>>> +#define AR5K_EEPROM_SIZE_UPPER_MASK    0xfff0
>>> +#define AR5K_EEPROM_SIZE_UPPER_SHIFT   4
>>> +#define AR5K_EEPROM_SIZE_ENDLOC_SHIFT  12
>>> +
>>
>> AR531X chips are SoCs, are you sure this comment is correct ?
>
> I got that from the legacy HAL, so just using that as a source of
> documentation for this.
>
>> In the docs this marks the end of EAR section (and the end of
>> checksum) for EEPROMs larger than 16k
>> valid values for checksum end are 0x00000C0 to 0x0080000
>
> I didn't see this used, just replicating what I saw in the legacy HAL
> to match the code on Linux with what we have on other operating
> systems. Not sure about the valid values for the checksum as per
> documentation Vs what is implemented, I am just following what I see
> implemented to ensure consistency.
>
>> Also to calculate EEPROM size (stored on the first 4 bits of 0x1c) you
>> do this according to the docs
>> 2 ^ (EEPROM size + 9) and valid values are from 1 to 11 (11 = 1MB)
>
> OK thanks so the eep_max should not be > 11 ?
>

I guess

eep_max > (3 * AR5K_EEPROM_INFO_MAX)

should be

eep_max > 1024



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
