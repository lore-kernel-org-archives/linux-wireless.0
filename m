Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38177 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1DJRfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 13:35:53 -0400
Received: by qwk3 with SMTP id 3so2878130qwk.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 10:35:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DA1E90A.5070902@gmail.com>
References: <4DA1E90A.5070902@gmail.com>
Date: Sun, 10 Apr 2011 19:35:52 +0200
Message-ID: <BANLkTimp6h9x0JC0HzSpKzdbKLOw=ioUvw@mail.gmail.com>
Subject: Re: Firmware files for Ralink RT28x0
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

>> I notice that rt2800{pci,usb} each specify only one firmware image,
>> regardless of the controller version.
>>
>> This is inconsistent with rt28{6,7}0sta and with the firmware images in
>> linux-firmware.
>>
>> If you think that a single image per bus type can cover all controllers,
>> please identify those firmware images, test them on each hardware
>> generation, and get them into linux-firmware.
>
> querida:/datos/kernel/linux-2.6/drivers/net/wireless/rt2x00 $ grep "\.bin" *
> rt2800pci.h:#define FIRMWARE_RT2860                     "rt2860.bin"
> rt2800usb.h:#define FIRMWARE_RT2870                     "rt2870.bin"
> rt61pci.h:#define FIRMWARE_RT2561                       "rt2561.bin"
> rt61pci.h:#define FIRMWARE_RT2561s                      "rt2561s.bin"
> rt61pci.h:#define FIRMWARE_RT2661                       "rt2661.bin"
> rt73usb.h:#define FIRMWARE_RT2571                       "rt73.bin"
>
> rt3070.bin rt3071.bin rt3090.bin should be deleted from linux-firmware.
> They were only need by staging drivers.

True, but the rt2860 and rt2870 firmware file are outdated in the
linux-firmware,
and probably don't support the rt3090 or other more recent chipsets. So before
they can be removed, those files must be updated.

Ivo
