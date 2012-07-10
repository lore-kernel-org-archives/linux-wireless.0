Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9830 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2GJKuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 06:50:09 -0400
Message-ID: <4FFC08C5.2050606@qca.qualcomm.com> (sfid-20120710_125014_507550_72546CC5)
Date: Tue, 10 Jul 2012 13:49:41 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <drwho@infidigm.net>
CC: Julian Calaby <julian.calaby@gmail.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: ar6004 / ar9374 firmware
References: <43a66e0f20b45e9cc461272e83f2c4e4.squirrel@www.infidigm.net>
In-Reply-To: <43a66e0f20b45e9cc461272e83f2c4e4.squirrel@www.infidigm.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ath6kl-devel

Hi Jon,

On 06/28/2012 12:28 AM, drwho@infidigm.net wrote:
> I've noticed in core.h in the ath6kl driver that it is defining the
> following firmware for the ar6004....
> 
> ath6k/AR6004/hw1.0/fw.ram.bin
> ath6k/AR6004/hw1.1/fw.ram.bin
> ath6k/AR6004/hw1.2/fw.ram.bin
> 
> In linux-firmware.git all that exists is...
> 
> ath6k/AR6004/hw1.2/fw-2.bin
> ath6k/AR6004/hw1.2/bdata.bin
> 
> fw-2.bin need a rename?

fw.ram.bin is for FW API 1 and fw-2.bin is FW API 2. So fw-2.bin is
correct, I'll send a patch for ath6kl to fix this.

> Also, my UB134 is coming up with a device ID of 0x31c8088a?
> 
> [  361.676440] ath6kl: Unsupported hardware version: 0x31c8088a
> [  361.680437] ath6kl: Failed to init ath6kl core: -22
> [  361.680491] ath6kl_usb: probe of 2-1:1.0 failed with error -22
> [  361.680520] usbcore: registered new interface driver ath6kl_usb

That's odd, I'm not familiar with 0x31c8088a. I wonder if it's corrupted
somehow or is it a valid device id? Does anyone from ath6kl-devel know?

Kalle
