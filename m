Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9863 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933986AbaFRIf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2014 04:35:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <drwho@infidigm.net>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>
Subject: Re: QCA ar9375 in Ubuntu 14.04 beta 2 not working
References: <63ed0fb1a4c098dd260f249546408de5.squirrel@www.infidigm.net>
Date: Wed, 18 Jun 2014 11:35:22 +0300
In-Reply-To: <63ed0fb1a4c098dd260f249546408de5.squirrel@www.infidigm.net>
	(drwho@infidigm.net's message of "Tue, 17 Jun 2014 17:19:30 -0400")
Message-ID: <87k38eehth.fsf@kamboji.qca.qualcomm.com> (sfid-20140618_103535_175841_7B79E935)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<drwho@infidigm.net> writes:

>> I just sent patches to add ar6004 hw3.0 support. If you can, please
>> test those and give feedback.
>
> Ok, I rebuilt the Ubuntu kernel with your 6 patches,
>
> sudo modprobe ath6kl_usb
> insert ar9375
>
> At first I was getting an error about not being able find the firmware
> file, so I renamed your fw-5.bin to fw.ram.bin.

You should not rename the firmware file, it will break everything if you
do that. This is what you should see:

[  364.432845] usb 2-1.4: new high-speed USB device number 4 using ehci-pci
[  364.510168] usb 2-1.4: New USB device found, idVendor=0cf3, idProduct=9375
[  364.510232] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  364.510289] usb 2-1.4: Product: USBWLAN
[  364.510346] usb 2-1.4: Manufacturer: Qualcomm Atheros.
[  364.510430] usb 2-1.4: SerialNumber: 12345678
[  364.835598] ath6kl: ar6004 hw 3.0 usb fw 3.5.0.349-1 api 5
[  364.835710] ath6kl: firmware supports: 64bit-rates,map-lp-endpoint,ratetable-mcs15,no-ip-checksum

My first guess is that something went wrong in the kernel compilation
and the new patches are not actually applied. Double check that you
really have the new hw3.0 support in place, for example by adding few
printks and making sure that you see them in dmesg.

-- 
Kalle Valo
