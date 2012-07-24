Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56679 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab2GXTtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 15:49:01 -0400
Received: by yenl2 with SMTP id l2so7093233yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 12:49:01 -0700 (PDT)
Message-ID: <500EFC27.40409@lwfinger.net> (sfid-20120724_214907_155361_CA8B9815)
Date: Tue, 24 Jul 2012 14:48:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Balaji Ravindran (balravin)" <balravin@cisco.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Help requested troubleshooting compilation of rt3573 driver for
 cisco ae3000
References: <781BD600E733884C96CCDD5DF04A71C1023B3B@xmb-rcd-x14.cisco.com>
In-Reply-To: <781BD600E733884C96CCDD5DF04A71C1023B3B@xmb-rcd-x14.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/24/2012 01:52 PM, Balaji Ravindran (balravin) wrote:
> Hi,
>
> I request help to make my cisco AE3000 wireless usb work with my Ubuntu 12.04 64 bit server OS. I tried the following, and everything was in vain. So please pass me on some pointers.
>
>   1.      Started off with ndiswrapper.
>
> 	a.      Looked for Windows XP driver from CD packaging and tried load it with ndiswrapper 1.57, but it is not working because, cisco does not provide a 64 bit windows xp driver, so ndiswrapper complains saying 64 bit kernel detected.
>
> 	b.      I did give a shot with using 64bit windows vista and windows 7 drivers included in the CD package even though I knew ndiswrapper will not support vista or win 7 drivers.
>
> 2.      RT drivers are opensource (yay!) so identified the hardware Id for the product it was (13b1:003b) comes with rt3573 chipset (I confirm that). So I downloaded the latest RT3573 chipset driver from their RALINK website, and still no use.
> I successfully built and installed the rt3573sta.ko under /lib/modules/(shell $(uname -r))..... and was successfully able to modprobe the module. But still I did not see the device's model was recognized as a WiFi device.
> Output of 'lsusb' still showed up 'Linksys'
>
>   3.      Step further, under /common/rtusb_dev_id.c I waslooking for the USB device id, and I could'nt find a match for 13b1:003b., so created a new device id, and rebuilt the driver
>
> 	a.      Make clean, make uninstall, make install.
> 	b.      Driver built successfully, still did not detect the device
>
> 4.      In vain tried the default included rt2800usb module., and did
> 	a.      sudo depmod -a
> 	b.      sudo modprobe -v rt2800usb
> 	c.      Module loaded successfully, and still in vain, driver not detected.
>
> Any help here would be much appreciated? Anything I missed out or I could try., please help.

A device with an RT3573 chip should be handled by rt2800usb; however, your 
particular ID is not in the device table.

What happens when you do the following:

su -
modprobe -v rt2800usb
echo "13b1 003b" > /sys/bus/usb/drivers/rt2800usb/new_id
exit

Larry


