Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48678 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab3JPQkF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 12:40:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1VWU8h-0000yb-6v
	for linux-wireless@vger.kernel.org; Wed, 16 Oct 2013 18:40:03 +0200
Received: from 46.165.200.49 ([46.165.200.49])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Oct 2013 18:40:03 +0200
Received: from rezobezandron by 46.165.200.49 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Oct 2013 18:40:03 +0200
To: linux-wireless@vger.kernel.org
From: Andrey <rezobezandron@gmail.com>
Subject: Re: p54usb raspberry pi no wlan0 device
Date: Wed, 16 Oct 2013 16:35:26 +0000 (UTC)
Message-ID: <loom.20131016T182908-234@post.gmane.org> (sfid-20131016_184010_546945_B6B590F4)
References: <trinity-4366d417-bdc3-4e3b-a613-25b1af7a51a7-1379880343916@3capp-gmx-bs34>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 

<the_force@...> writes:

> 
> 
> Hi Folks,
>  
> i want to use an Corega WLUSB2GTST USB adapter on my Raspberry Pi linux 
device. I used fwextract utility with
> the driver file (Windows 2000 driver, nobyteswap option). So i got these 
2 files:
>  
> cgwlusb200.arm
> cgwlusb201.arm
>  
> I have copied these files (i tried cgwlusb200.arm also cgwlusb201.arm) to 
the following location on my
> Raspberry Pi:
>  
> /lib/firmware/isl3887usb
> /lib/modules/3.6.11+/kernel/drivers/net/wireless/isl3887usb
>  
> After doing a modprobe p54usb, the module seems to load fine:
> 
> root <at> pinulldrei:/lib/firmware# lsmod
> ModuleSize Used by
> p54usb 11627 0
> p54common 30229 1 p54usb
> crc_ccitt 1530 1 p54common
> mac80211 273979 2 p54common,p54usb
> cfg80211 184390 2 mac80211,p54common
> rfkill 18298 1 cfg80211
> tun 14995 2
> snd_bcm2835 16432 0
> snd_pcm 77728 1 snd_bcm2835
> snd_seq 53482 0
> snd_timer 20110 2 snd_pcm,snd_seq
> snd_seq_device 6462 1 snd_seq
> snd 58744 5 snd_bcm2835,snd_timer,snd_pcm,snd_seq,snd_seq_device
> snd_page_alloc 5169 1 snd_pcm
> leds_gpio 2243   0
> led_class 3570  2 leds_gpio,p54common
> root <at> pinulldrei:/lib/firmware#
> 
> dmesg says:
> [1031466.099404] usb 1-1.2.1: new high-speed USB device number 10 using 
dwc_otg
> [1031466.202908] usb 1-1.2.1: New USB device found, idVendor=07aa, 
idProduct=0020
> [1031466.202939] usb 1-1.2.1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
> [1031554.700433] cfg80211: Calling CRDA to update world regulatory domain
> [1031554.755865] usbcore: registered new interface driver p54usb
> 
> /var/log/messages says:
> Sep 22 21:33:08 pinulldrei kernel: [1031466.099404] usb 1-1.2.1: new high-
speed USB device number 10
> using dwc_otg
> Sep 22 21:33:09 pinulldrei kernel: [1031466.202908] usb 1-1.2.1: New USB 
device found, idVendor=07aa, idProduct=0020
> Sep 22 21:33:09 pinulldrei kernel: [1031466.202939] usb 1-1.2.1: New USB 
device strings: Mfr=1,
> Product=2, SerialNumber=3
> Sep 22 21:34:37 pinulldrei kernel: [1031554.700433] cfg80211: Calling 
CRDA to update world regulatory domain
> Sep 22 21:34:37 pinulldrei kernel: [1031554.755865] usbcore: registered 
new interface driver p54usb
> 
> Everything looks fine - but no wlan0 device will be created  The led on 
the stick will not turn on, so i think
> i have a driver problem.
> 
> How can i debug / solve this problem?!?
> 
> Greetings from Germany,
> Jörg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" 
in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


The same shit, it seems like p54usb doesn't provide support for this Corega 
wi-fi stick. If you'd have done modinfo p54usb you could see that there's 
no corega's vendor and device code among available aliases, the only one 
Corega device listed is 07aa:001C (your Corega WLUSB2GTST has device id 
07aa:0020), but it uses different ISL chip. 



