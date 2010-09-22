Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40004 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab0IVKjA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 06:39:00 -0400
Received: by iwn5 with SMTP id 5so438106iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 03:38:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com>
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com>
Date: Wed, 22 Sep 2010 14:38:58 +0400
Message-ID: <AANLkTi=M9zSKkckxqs6XwBg3290L9yijmCbRn9_E93xJ@mail.gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Alex Mihaylov <minimumlaw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Also i got firmware  2.13.0.0.a.13.14.arm from linux-wireles. After
> loading module with proper command line, I see message
>
> cx3110x spi1.0: firmware boot failed
>
> and no other error/warning message presents. SPI signals like good.
>
>
> phy0: p54 detected a LM20 firmware
> p54: rx_mtu reduced from 3240 to 2376
> phy0: FW rev 2.13.0.0.a.13.14 - Softmac protocol 5.6
> phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> cx3110x spi1.0: loading user eeprom...

Looks like you have custom eeprom image...

> phy0: hwaddr 00:02:ee:c0:ff:ee, MAC:isl3820 RF:Longbc
> x3110x spi1.0: firmware boot failed

...and this eeprom image has wrong format.

> What's trouble? Incorrect firmware? Unsupported (so slow) SPI rate?
>
> I try load another firmware from 2.13... series - result: firmware
> boot failed. I also try load firmware cutted from Sagrad source
> (version 2.19....) result is same: firmware boot failed.
>
> What is my next step for this idea?

I'd suggest removing file 3826.eeprom and trying to boot without it.

-- 
Max
