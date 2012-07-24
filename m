Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43662 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2GXUDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 16:03:02 -0400
Received: by weyx8 with SMTP id x8so5379859wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 13:03:00 -0700 (PDT)
References: <781BD600E733884C96CCDD5DF04A71C1023B3B@xmb-rcd-x14.cisco.com> <500EFC27.40409@lwfinger.net>
In-Reply-To: <500EFC27.40409@lwfinger.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <175A8680-40E0-42A5-AE01-DA531C829C8C@gmail.com> (sfid-20120724_220307_577051_3EBFAC40)
Cc: "Balaji Ravindran (balravin)" <balravin@cisco.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: Help requested troubleshooting compilation of rt3573 driver for cisco ae3000
Date: Tue, 24 Jul 2012 22:02:59 +0200
To: Larry Finger <Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Balaji, Larry,

On 24 jul. 2012, at 21:48, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 07/24/2012 01:52 PM, Balaji Ravindran (balravin) wrote:
>> Hi,
>> 
>> I request help to make my cisco AE3000 wireless usb work with my Ubuntu 12.04 64 bit server OS. I tried the following, and everything was in vain. So please pass me on some pointers.
>> 
>>  1.      Started off with ndiswrapper.
>> 
>>    a.      Looked for Windows XP driver from CD packaging and tried load it with ndiswrapper 1.57, but it is not working because, cisco does not provide a 64 bit windows xp driver, so ndiswrapper complains saying 64 bit kernel detected.
>> 
>>    b.      I did give a shot with using 64bit windows vista and windows 7 drivers included in the CD package even though I knew ndiswrapper will not support vista or win 7 drivers.
>> 
>> 2.      RT drivers are opensource (yay!) so identified the hardware Id for the product it was (13b1:003b) comes with rt3573 chipset (I confirm that). So I downloaded the latest RT3573 chipset driver from their RALINK website, and still no use.
>> I successfully built and installed the rt3573sta.ko under /lib/modules/(shell $(uname -r))..... and was successfully able to modprobe the module. But still I did not see the device's model was recognized as a WiFi device.
>> Output of 'lsusb' still showed up 'Linksys'
>> 
>>  3.      Step further, under /common/rtusb_dev_id.c I waslooking for the USB device id, and I could'nt find a match for 13b1:003b., so created a new device id, and rebuilt the driver
>> 
>>    a.      Make clean, make uninstall, make install.
>>    b.      Driver built successfully, still did not detect the device
>> 
>> 4.      In vain tried the default included rt2800usb module., and did
>>    a.      sudo depmod -a
>>    b.      sudo modprobe -v rt2800usb
>>    c.      Module loaded successfully, and still in vain, driver not detected.
>> 
>> Any help here would be much appreciated? Anything I missed out or I could try., please help.
> 
> A device with an RT3573 chip should be handled by rt2800usb; however, your particular ID is not in the device table.
> 
> What happens when you do the following:
> 
> su -
> modprobe -v rt2800usb
> echo "13b1 003b" > /sys/bus/usb/drivers/rt2800usb/new_id
> exit

Unfortunately rt2800usb is not able to handle the RT3573 chip. It is quite a different beast then the other chips that are supported ( for one it is the first 3T3R chip that we see from Ralink, and the EEPROM layout is quite different).

So, you have to stick with the driver of the Ralink website, until we are able to add support for the chip in rt2800usb.
Although I do own a device with that chip, my time is unfortunately very limited right now, so my progress is very slow.

---
Gertjan