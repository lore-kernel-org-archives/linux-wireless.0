Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1124 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbaFWNlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 09:41:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <drwho@infidigm.net>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>
Subject: Re: QCA ar9375 in Ubuntu 14.04 beta 2 not working
References: <63ed0fb1a4c098dd260f249546408de5.squirrel@www.infidigm.net>
	<87k38eehth.fsf@kamboji.qca.qualcomm.com>
	<2f52376ba13cf8814471ea684d86ad3b.squirrel@www.infidigm.net>
Date: Mon, 23 Jun 2014 16:40:52 +0300
In-Reply-To: <2f52376ba13cf8814471ea684d86ad3b.squirrel@www.infidigm.net>
	(drwho@infidigm.net's message of "Wed, 18 Jun 2014 16:31:17 -0400")
Message-ID: <871tufagm3.fsf@kamboji.qca.qualcomm.com> (sfid-20140623_154111_145648_43294398)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<drwho@infidigm.net> writes:

>>> At first I was getting an error about not being able find the firmware
>>> file, so I renamed your fw-5.bin to fw.ram.bin.
>>
>> You should not rename the firmware file, it will break everything if you
>> do that. This is what you should see:
>>
>> [  364.432845] usb 2-1.4: new high-speed USB device number 4 using
>> ehci-pci
>> [  364.510168] usb 2-1.4: New USB device found, idVendor=0cf3,
>> idProduct=9375
>> [  364.510232] usb 2-1.4: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [  364.510289] usb 2-1.4: Product: USBWLAN
>> [  364.510346] usb 2-1.4: Manufacturer: Qualcomm Atheros.
>> [  364.510430] usb 2-1.4: SerialNumber: 12345678
>> [  364.835598] ath6kl: ar6004 hw 3.0 usb fw 3.5.0.349-1 api 5
>> [  364.835710] ath6kl: firmware supports:
>> 64bit-rates,map-lp-endpoint,ratetable-mcs15,no-ip-checksum
>>
>> My first guess is that something went wrong in the kernel compilation
>> and the new patches are not actually applied. Double check that you
>> really have the new hw3.0 support in place, for example by adding few
>> printks and making sure that you see them in dmesg.
>
> The firmware files were corrupt.  After copying the firmware directly from
> the git repo, I've got the 9375 working in Ubuntu 14.04 and on an arm SoC
> using backports-3.11.

Ok, that's good.

> After some testing (downloading a large file from a local server
> repeatedly), I've discovered that after 10-40min the 9375 device
> becomes "stuck". This happens on Ubuntu x86 and on the arm SoC using
> backports. I've tried it with a TP-WR1043ND router and a Ubiquity UAP.
> The issue happens when associated to either AP.

Thanks, I'll report this forward.

-- 
Kalle Valo
