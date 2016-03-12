Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34834 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbcCLU70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Mar 2016 15:59:26 -0500
Received: by mail-wm0-f50.google.com with SMTP id l68so60321009wml.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Mar 2016 12:59:25 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: alexander nekrasov <i.sinister@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: carl1970: stops working at random periods on Ubuntu 15.05
Date: Sat, 12 Mar 2016 21:59:22 +0100
Message-ID: <3054426.yRobc0R5Xb@debian64> (sfid-20160312_215930_414389_37FB215F)
In-Reply-To: <CAG4k0fDJ6KjK14Ja5fKpy8L4aGzWVwLTOGT6EvkVEDwS9qVdhw@mail.gmail.com>
References: <CAG4k0fCqB1KNLyHV5--pi1nSoDPnV3qM-yTB0T2jmgbnjmqvww@mail.gmail.com> <CAG4k0fCd7Q-0Nz+XH1U-A9jwFRdX_SbVJNO=m_qP_ZpVADQkVw@mail.gmail.com> <CAG4k0fDJ6KjK14Ja5fKpy8L4aGzWVwLTOGT6EvkVEDwS9qVdhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, March 11, 2016 09:12:40 AM alexander nekrasov wrote:
> Thanks for an answer, Christian! Adapter is getting hot sometimes
> indeed. Also my adapter is usb2.0 but it was on extender with another
> usb1.1 device. I plugged it into motherboards port directly but issue
> still continue to happens. I  also tried reload host controller but it
> did not help. 
In that case, this might be a problem with the host controller on your
motherboard. I say "might", because it could also be that the ar9170
device is damaged or that something else is going on. Can you test the
device on a different PC and test if it fails in the same way?

Other than that, there's not much you can do (easily). If you want
to investigate the issue further, you would need probe the FUSB200
in the device. The only place you can do that is within the firmware
as the USB subsystem is breaking down. The firmware can be downloaded
from [0]. The register to look at is 0x1E110C (AR9170_USB_REG_DMA_STATUS).

There are a few error bits that can be checked.

Bit 24: Error when the upstream DMA access the data bus.
Bit 25: Error when the upstream DMA access the command bus.
Bit 26: Error when the downstream DMA access the data bus.
Bit 27: Error when the downstream DMA access the command bus.
Bit 28: Error when the CPU access the data bus.
Bit 29: Error when the CPU access the command bus.

If any of those bits are set, it's probably time to issue a
firmware reboot (set fw.reboot to 1 or directly call "reboot();").

That said, I don't have high hopes. In your logs, the carl9170
driver is already trying to reset the device... and failing since
it is unable to communicate with the device.

> However I discovered strange behavior. Here is my
> scenario:
> 1. boot system
> 2. check device is displayed by 'lsusb' and 'lsusb -t'
> 3. unbind and bind root hub where device is plugged into
> 4. this time 'lsusb' does list device and 'lsusb -t' does not
> 
> Is it ok?
> 
> After unbind/bind device definitely is not working - there is led
> indicator and it is off. Should I 'enable' device after binding root
> hub with another command?

I would suggest you also contact the linux-usb mailing list [1].
They may be able to debug why the host controller is not responding
to the bind and unbind.

[0] <https://wireless.wiki.kernel.org/en/users/drivers/carl9170.fw>
[1] <http://www.linux-usb.org/mailing.html>
