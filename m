Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:16117 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZH1DRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 23:17:04 -0400
Received: by ey-out-2122.google.com with SMTP id 25so365349eya.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 20:17:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com>
References: <20090827023000.21926.90867.stgit@mj.roinet.com>
	 <40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com>
Date: Fri, 28 Aug 2009 06:17:05 +0300
Message-ID: <40f31dec0908272017y41251832ha34a809ec01a4e00@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix uninitialized value use in
	ath5k_eeprom_read_turbo_modes()
From: Nick Kossifidis <mickflemm@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/27 Nick Kossifidis <mickflemm@gmail.com>:
> 2009/8/27 Pavel Roskin <proski@gnu.org>:
>> The `val' variable in ath5k_eeprom_read_turbo_modes() is used
>> uninitialized.  gcc 4.4.1 with -fno-inline-functions-called-once reports
>> it:
>>
>> eeprom.c: In function 'ath5k_eeprom_read_turbo_modes':
>> eeprom.c:441: warning: 'val' may be used uninitialized in this function
>>
>> Comparing the code to the Atheros HAL, it's clear that the split between
>> ath5k_eeprom_read_modes() and ath5k_eeprom_read_turbo_modes() was
>> incorrect.
>>
>> The Atheros HAL reads both turbo and non-turbo data from EEPROM in one
>> function.  Some turbo mode parameters are derived from the same EEPROM
>> values as non-turbo parameters, just from different bits.
>>
>> Merge ath5k_eeprom_read_turbo_modes() into ath5k_eeprom_read_modes() to
>> fix the warning.  The actual values and offsets have been cross-checked
>> against Atheros HAL.
>>
>> Signed-off-by: Pavel Roskin <proski@gnu.org>
>
> Current code works fine (i 've checked it against various cards),
> there is nothing wrong
> with having another function for reading turbo modes, i find it's
> cleaner that way.
>
> Just change
>
> u16 val;
>
> to
>
> u16 val = 0;
>
> and it should be fine.
>

Ouch seems my local tree and current wireless-testing are out of sync
or something, yup compiler is right
you' ll need to put a

AR5K_EEPROM_READ(o, val);

before the switch.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
