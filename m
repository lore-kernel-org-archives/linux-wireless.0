Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35651 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab0GVPlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 11:41:25 -0400
Received: by fxm14 with SMTP id 14so4388057fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 08:41:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279780848.2322.31.camel@powerslave>
References: <4C37BCA0.5090607@deltatee.com>
	<AC090B9732AB2B4DB7FF476E907FE660010685F34E@dnce02.ent.ti.com>
	<AANLkTilHNKeRZX5CMplyriTo2hTPBrz_z1_Zpwoy3SZx@mail.gmail.com>
	<AC090B9732AB2B4DB7FF476E907FE66001069662F2@dnce02.ent.ti.com>
	<AC090B9732AB2B4DB7FF476E907FE6600106966BA5@dnce02.ent.ti.com>
	<4C45ED36.2090604@deltatee.com>
	<AANLkTinjvF9UeV7d2aBUy6HfexuAeL_cdsVPGVxSRVMp@mail.gmail.com>
	<AANLkTinnYeJPV-xxg7DdPXnWW_kD7X1TVcd9HrhupJWS@mail.gmail.com>
	<1279780848.2322.31.camel@powerslave>
Date: Thu, 22 Jul 2010 17:41:24 +0200
Message-ID: <AANLkTilZhvGg2SUk5btpQQA3qj2k4rob4rTychDu7gXM@mail.gmail.com>
Subject: Re: wl1271 firmware
From: Pazzo Da Legare <pazzodalegare@gmail.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Levi, Shahar" <shahar_levi@ti.com>,
	Logan Gunthorpe <logang@deltatee.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Luciano,
Dear All,

I enabled the DEBUG_LEVEL as you advice me but I have no additional
information....

[  186.230000] wl1271_sdio mmc0:0001:2: firmware: requesting
wl1271-fw.bin
[  186.420000] wl1271_sdio mmc0:0001:2: firmware: requesting
wl1271-nvs.bin
[  186.860000] wl1271: firmware booted (Rev 6.1.0.0.310)
[  186.880000] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  187.380000] wl1271: ERROR ELP wakeup timeout!
[  187.880000] wl1271: ERROR ELP wakeup timeout!

Pazzo

2010/7/22 Luciano Coelho <luciano.coelho@nokia.com>:
> Hi Pazzo,
>
>
> On Wed, 2010-07-21 at 19:27 +0200, ext Pazzo Da Legare wrote:
>> Dear All again,
>>
>> I've just test with compact-wireless-2010-07-20 but I've the same problem:
>>
>> root@hawkboard:~# ifconfig wlan0 192.168.0.1 up
>> [   68.920000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-fw.bin
>> [   69.100000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-nvs.bin
>> [   69.510000] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> root@hawkboard:~# [   70.020000] wl1271: ERROR ELP wakeup timeout!
>> [   70.520000] wl1271: ERROR ELP wakeup timeout!
>>
>>
>> looking at dmesg:
>>
>> [  68.920000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-fw.bin
>> [   69.100000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-nvs.bin
>> [   69.500000] wl1271: firmware booted (Rev 6.1.0.0.310)
>> [   69.510000] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [   70.020000] wl1271: ERROR ELP wakeup timeout!
>> [   70.520000] wl1271: ERROR ELP wakeup timeout!
>>
>> [   68.920000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-fw.bin
>> [   69.100000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-nvs.bin
>> [   69.500000] wl1271: firmware booted (Rev 6.1.0.0.310)
>> [   70.020000] wl1271: ERROR ELP wakeup timeout!
>> [   70.520000] wl1271: ERROR ELP wakeup timeout!
>>
>> Do you have any clue?
>
> I'm not sure what this is, but usually an ERROR ELP wakeup timeout means
> that the firmware has crashed.
>
> Could you enable the following DEBUG flags in wl1271.h and send the logs
> again? Maybe they provide more clues...
>
> #define DEBUG_LEVEL (DEBUG_BOOT | DEBUG_ACX | DEBUG_CMD | DEBUG_PSM | \
>                     DEBUG_IRQ | DEBUG_EVENT)
>
>
> --
> Cheers,
> Luca.
>
>
