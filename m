Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50619 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab0ADSJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 13:09:24 -0500
Received: by ewy19 with SMTP id 19so7563818ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jan 2010 10:09:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1262619639-21426-1-git-send-email-lrodriguez@atheros.com>
References: <1262619639-21426-1-git-send-email-lrodriguez@atheros.com>
Date: Mon, 4 Jan 2010 20:09:22 +0200
Message-ID: <40f31dec1001041009r87f677l9c777535c1a057f@mail.gmail.com>
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
>
> +
> +/* FLASH(EEPROM) Defines for AR531X chips */
> +#define AR5K_EEPROM_SIZE_LOWER         0x1b /* size info -- lower */
> +#define AR5K_EEPROM_SIZE_UPPER         0x1c /* size info -- upper */
> +#define AR5K_EEPROM_SIZE_UPPER_MASK    0xfff0
> +#define AR5K_EEPROM_SIZE_UPPER_SHIFT   4
> +#define AR5K_EEPROM_SIZE_ENDLOC_SHIFT  12
> +

AR531X chips are SoCs, are you sure this comment is correct ?

In the docs this marks the end of EAR section (and the end of
checksum) for EEPROMs larger than 16k
valid values for checksum end are 0x00000C0 to 0x0080000

Also to calculate EEPROM size (stored on the first 4 bits of 0x1c) you
do this according to the docs
2 ^ (EEPROM size + 9) and valid values are from 1 to 11 (11 = 1MB)

There is also an EEPROM size indicator on PCICFG but it seems it's
only for older chips.

A value of 0 on 0x1c means we have a 2k EEPROM and an end location 0x0000400.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
