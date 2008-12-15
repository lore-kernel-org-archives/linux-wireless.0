Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:51685 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751AbYLOUUd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 15:20:33 -0500
Received: by ey-out-2122.google.com with SMTP id 6so403645eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 12:20:31 -0800 (PST)
Message-ID: <4946BC0C.3040701@gmail.com> (sfid-20081215_212043_711476_6BD37700)
Date: Mon, 15 Dec 2008 21:20:28 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <4946A4C9.7040304@lwfinger.net> <200812152043.21971.chunkeey@web.de>
In-Reply-To: <200812152043.21971.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Monday 15 December 2008 19:41:13 Larry Finger wrote:
>> Artur Skawina wrote:
>>> I have a sinus 154 data usb adapter, which used to work w/ p54 in 2.6.27:
>> Can you bisect this problem?
> Naa I guess its "p54: fix memory management".
> 872037115977dc07ae05e4b6b769bf8726da4e87
> 
> so tell us if this patch works.

Nope, the attached patch did not improve things, as the log below shows.
I'll try bisecting.

Thanks,

artur

> Dec 15 21:11:08 kernel: usb 1-7: new high speed USB device using ehci_hcd and address 12
> Dec 15 21:11:09 kernel: usb 1-7: configuration #1 chosen from 1 choice
> Dec 15 21:11:09 kernel: cfg80211: Using static regulatory domain info
> Dec 15 21:11:09 kernel: cfg80211: Regulatory domain: US
> Dec 15 21:11:09 kernel: ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> Dec 15 21:11:09 kernel: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
> Dec 15 21:11:09 kernel: ^I(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> Dec 15 21:11:09 kernel: ^I(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> Dec 15 21:11:09 kernel: ^I(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> Dec 15 21:11:09 kernel: ^I(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> Dec 15 21:11:09 kernel: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> Dec 15 21:11:09 kernel: cfg80211: Calling CRDA for country: US
> Dec 15 21:11:09 kernel: usb 1-7: New USB device found, idVendor=0846, idProduct=4200
> Dec 15 21:11:09 kernel: usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> Dec 15 21:11:09 kernel: usb 1-7: firmware: requesting isl3886usb
> Dec 15 21:11:09 kernel: phy0: p54 detected a LM86 firmware
> Dec 15 21:11:09 kernel: phy0: FW rev 2.5.6.0 - Softmac protocol 3.0
> Dec 15 21:11:09 kernel: phy0: you are using an obsolete firmware. visit http://wireless.kernel.org/en/users/Drivers/p54 and grab one for "kernel >= 2.6.28"!
> Dec 15 21:11:09 kernel: phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:no
> Dec 15 21:11:12 kernel: phy0: device does not respond!
> Dec 15 21:11:12 kernel: p54usb: probe of 1-7:1.0 failed with error -16
> Dec 15 21:11:12 kernel: usbcore: registered new interface driver p54usb
