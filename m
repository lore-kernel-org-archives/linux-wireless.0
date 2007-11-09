Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4458 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbXKITJN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 14:09:13 -0500
Date: Fri, 9 Nov 2007 14:08:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Dallet <ddmdllt@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: unrecognized usb card D-LINK DWA-110
Message-ID: <20071109190855.GA32472@tuxdriver.com> (sfid-20071109_190916_940610_725F95E3)
References: <2b74932e0711091035v323364e6n1e458e82a590dd3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2b74932e0711091035v323364e6n1e458e82a590dd3e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 09, 2007 at 07:35:40PM +0100, David Dallet wrote:

> Bus 004 Device 008: ID 07d1:3c07 D-Link System
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x07d1 D-Link System
>   idProduct          0x3c07
>   bcdDevice            0.01
>   iManufacturer           1 Ralink
>   iProduct                2 802.11 bg WLAN
>   iSerial                 0
>   bNumConfigurations      1
>   (I don't paste all the lines here, but they are in http://pastebin.ca/767375)

Looks like a USB Ralink device... :-)

Perhaps you could try this:

	sudo modprobe rt73usb
	sudo echo "07d1 3c07" > /sys/bus/usb/drivers/rt73usb/new_id

Any chance that brings your device to life?  If not, try the above with
"rt2500usb" instead of rt73usb?

This is really just a longshot....

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
