Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63105 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab3IVUFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 16:05:45 -0400
Received: from 3capp-gmx-bs34.server.lan ([172.19.170.86]) by
 mrigmx.server.lan (mrigmx002) with ESMTP (Nemesis) id
 0La1J5-1Vkojd0FIL-00liiK for <linux-wireless@vger.kernel.org>; Sun, 22 Sep
 2013 22:05:44 +0200
MIME-Version: 1.0
Message-ID: <trinity-4366d417-bdc3-4e3b-a613-25b1af7a51a7-1379880343916@3capp-gmx-bs34> (sfid-20130922_220554_875221_5F1EA440)
From: the_force@gmx.de
To: linux-wireless@vger.kernel.org
Subject: p54usb raspberry pi no wlan0 device
Content-Type: text/plain; charset=UTF-8
Date: Sun, 22 Sep 2013 22:05:44 +0200 (CEST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Folks,
 
i want to use an Corega WLUSB2GTST USB adapter on my Raspberry Pi linux device. I used fwextract utility with the driver file (Windows 2000 driver, nobyteswap option). So i got these 2 files:
 
cgwlusb200.arm
cgwlusb201.arm
 
I have copied these files (i tried cgwlusb200.arm also cgwlusb201.arm) to the following location on my Raspberry Pi:
 
/lib/firmware/isl3887usb
/lib/modules/3.6.11+/kernel/drivers/net/wireless/isl3887usb
 
After doing a modprobe p54usb, the module seems to load fine:

root@pinulldrei:/lib/firmware# lsmod
ModuleSize Used by
p54usb 11627 0
p54common 30229 1 p54usb
crc_ccitt 1530 1 p54common
mac80211 273979 2 p54common,p54usb
cfg80211 184390 2 mac80211,p54common
rfkill 18298 1 cfg80211
tun 14995 2
snd_bcm2835 16432 0
snd_pcm 77728 1 snd_bcm2835
snd_seq 53482 0
snd_timer 20110 2 snd_pcm,snd_seq
snd_seq_device 6462 1 snd_seq
snd 58744 5 snd_bcm2835,snd_timer,snd_pcm,snd_seq,snd_seq_device
snd_page_alloc 5169 1 snd_pcm
leds_gpio 2243   0
led_class 3570  2 leds_gpio,p54common
root@pinulldrei:/lib/firmware#

dmesg says:
[1031466.099404] usb 1-1.2.1: new high-speed USB device number 10 using dwc_otg
[1031466.202908] usb 1-1.2.1: New USB device found, idVendor=07aa, idProduct=0020
[1031466.202939] usb 1-1.2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[1031554.700433] cfg80211: Calling CRDA to update world regulatory domain
[1031554.755865] usbcore: registered new interface driver p54usb

/var/log/messages says:
Sep 22 21:33:08 pinulldrei kernel: [1031466.099404] usb 1-1.2.1: new high-speed USB device number 10 using dwc_otg
Sep 22 21:33:09 pinulldrei kernel: [1031466.202908] usb 1-1.2.1: New USB device found, idVendor=07aa, idProduct=0020
Sep 22 21:33:09 pinulldrei kernel: [1031466.202939] usb 1-1.2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Sep 22 21:34:37 pinulldrei kernel: [1031554.700433] cfg80211: Calling CRDA to update world regulatory domain
Sep 22 21:34:37 pinulldrei kernel: [1031554.755865] usbcore: registered new interface driver p54usb

Everything looks fine - but no wlan0 device will be created :-( The led on the stick will not turn on, so i think i have a driver problem.

How can i debug / solve this problem?!?

Greetings from Germany,
Jörg
