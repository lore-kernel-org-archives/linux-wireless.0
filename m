Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41691 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966224AbcIZI4m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 04:56:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: [PATCH 2/2] mwifiex: firmware name correction for usb8997 chipset
In-Reply-To: <3ca1064a85854ba9b7f5e6b5ef127726@SC-EXCH04.marvell.com>
        (Amitkumar Karwar's message of "Tue, 20 Sep 2016 13:48:17 +0000")
References: <1473686728-8101-1-git-send-email-akarwar@marvell.com>
        <1473686728-8101-3-git-send-email-akarwar@marvell.com>
        <87poo6ct94.fsf@kamboji.qca.qualcomm.com>
        <3ca1064a85854ba9b7f5e6b5ef127726@SC-EXCH04.marvell.com>
Date: Mon, 26 Sep 2016 11:56:37 +0300
Message-ID: <87wphzyr7e.fsf@kamboji.qca.qualcomm.com> (sfid-20160926_105705_621907_B8757A3C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

>> Like discussed earlier, the firmware names are supposed to be stable. I
>> consider them to be an interface between kernel and user space. Instead
>> of changing the driver you should actually rename the firmware file. I'm
>> planning to take this anyway but in the future please pay extra
>> attention to do this properly.
>
> Thanks for accepting the patch. We will stick to the same name for
> 8997 and ensure v3/v4 etc won't be used for future chipsets/firmwares.

Good, thanks.

>> My recommendation is to keep the firmware name simple as possible and
>> get rid of any extra cruft, for example in this case a good name would
>> be "mrvl/usb8997.bin". That extra "usb" and "combo_v4" don't bring any
>> benefit.
>> 
>
> 'combo' here indicates it's a combine firmware image for bluetooth and
> wifi. Firmware images with bluetooth only OR WiFi only functionality
> are also possible. Example use case: We support PCIe function level
> reset feature as a recovery mechanism. With this mechanism, WiFi
> recovery can happen by re-downloading WiFi only firmware without
> affecting bluetooth functionality for PCIe-USB8997 chipset.

Ok, makes sense.

> 'usbusb' here indicates this firmware is for a USB-USB8997 chipset
> where WiFi and bluetooth are over USB bus. There would be a different
> firmware if chipset is USB-UART8997 where bluetooth is via UART.

So the bluetooth via UART chip would be 'usbuart'? Sounds reasonable
then.

-- 
Kalle Valo
