Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f50.google.com ([209.85.208.50]:34089 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729620AbeHHVfy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 17:35:54 -0400
Received: by mail-ed1-f50.google.com with SMTP id h1-v6so1777569eds.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2018 12:14:49 -0700 (PDT)
Subject: Re: wireless dongle causing entire machine to hang
To: Randy Oostdyk <linux-kernel@oostdyk.com>,
        linux-wireless@vger.kernel.org
References: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B6B4127.1040308@broadcom.com> (sfid-20180808_211520_873355_A926AB8A)
Date: Wed, 8 Aug 2018 21:14:47 +0200
MIME-Version: 1.0
In-Reply-To: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/8/2018 7:58 PM, Randy Oostdyk wrote:
> Good day all,

Hi Randy

> I'm writing to report an issue with the linux kernel, and I'm hoping
> this is the right place to report it. (short aside: I tried to ask in
> the #linux-wireless IRC channel, but wasn't permitted to speak!)

uhm. why?

> I'm aware that this is a USB protocol issue, and so this may be the
> wrong place to report the bug, but the warning seems to be generated
> by the wireless driver, and that appears to be the key issue here.
>
> My USB wifi dongle is on the end of a very long USB cable, and was
> connected to a USB hub. On two different occasions (after hours or
> days of use), the machine it was attached to (Raspberry Pi 3) stopped
> responding. I was unable to SSH in, even over ethernet. After a hard
> reboot, I found that the following error was repeated **many thousands
> of times per second** in three different log files:

I assume that USB is powered, right? Now probably asking the obvious, 
but you did not write it down so here it is: did you try with a very 
short USB cable?

I guess you read this already [1]

> Rpi kernel: [857011.857581] ieee80211 phy1:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71

So this -EPROTO. The usb host controller of the RPi3 can be found here:

https://github.com/raspberrypi/linux/tree/rpi-4.18.y/drivers/usb/host/dwc_otg

Not sure it that tells us anything though.

Regards,
Arend

[1] 
https://www.raspberrypi.org/documentation/hardware/raspberrypi/usb/README.md
