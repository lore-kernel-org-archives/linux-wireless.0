Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53318 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab2GXUS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 16:18:58 -0400
Received: by pbbrp8 with SMTP id rp8so124322pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 13:18:57 -0700 (PDT)
From: "Balaji Ravindran" <opensrc@gameprotocol.com>
To: <Larry.Finger@lwfinger.net>
Cc: <gwingerde@gmail.com>, <linux-wireless@vger.kernel.org>
References: <500F00F1.70700@cisco.com>
In-Reply-To: <500F00F1.70700@cisco.com>
Subject: RE: Help requested troubleshooting compilation of rt3573 driver for cisco ae3000
Date: Tue, 24 Jul 2012 13:18:56 -0700
Message-ID: <00c201cd69d9$8da71710$a8f54530$@gameprotocol.com> (sfid-20120724_221901_708098_6DB878C4)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry, Gertjan,

Thank you so much for the reply. I tried it, Yeap, rt2800usb is unable to
handle this chipset.

However, on the other hand, i tried to compile the driver once again from
RT3573 source. Even their device table did not have an entry for this dev_id
(13b1:003b), so I manually added the entry to the USB_DEVICE and compiled
the driver. 

It now works in my other ubuntu 12.04 computer.

I will head home and try it on my 64 bit OS though. I thought i did it
correctly yesterday, maybe i skipped something while adding the dev_id while
compiling the driver.

root@balravin-lnx-server:~# modprobe -v rt2800usb insmod
/lib/modules/3.2.0-25-generic-pae/kernel/drivers/net/wireless/rt2x00/rt2x00l
ib.ko
insmod
/lib/modules/3.2.0-25-generic-pae/kernel/drivers/net/wireless/rt2x00/rt2x00u
sb.ko
insmod /lib/modules/3.2.0-25-generic-pae/kernel/lib/crc-ccitt.ko
insmod
/lib/modules/3.2.0-25-generic-pae/kernel/drivers/net/wireless/rt2x00/rt2800l
ib.ko
insmod
/lib/modules/3.2.0-25-generic-pae/kernel/drivers/net/wireless/rt2x00/rt2800u
sb.ko

root@balravin-lnx-server:~# echo "13b1 003b" >
/sys/bus/usb/drivers/rt2800usb/new_id
root@balravin-lnx-server:~# lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub Bus 002
Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub Bus 003 Device 001:
ID 1d6b:0002 Linux Foundation 2.0 root hub Bus 004 Device 001: ID 1d6b:0003
Linux Foundation 3.0 root hub Bus 001 Device 002: ID 8087:0024 Intel Corp.
Integrated Rate Matching Hub Bus 002 Device 002: ID 8087:0024 Intel Corp.
Integrated Rate Matching Hub Bus 003 Device 002: ID 05e3:0608 Genesys Logic,
Inc. USB-2.0 4-Port HUB Bus 001 Device 003: ID 05ca:18c0 Ricoh Co., Ltd Bus
002 Device 003: ID 13b1:003b Linksys Bus 003 Device 003: ID 10d5:5000 Uni
Class Technology Co., Ltd Bus 001 Device 005: ID 0489:e00f Foxconn / Hon Hai
Foxconn T77H114 BCM2070 [Single-Chip Bluetooth 2.1 + EDR Adapter]
root@balravin-lnx-server:~# exit logout balravin@balravin-lnx-server:~$
iwconfig

wlan0     IEEE 802.11bgn  ESSID:"hurricane"
          Bit Rate=144.4 Mb/s   Tx-Power=13 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=66/70  Signal level=-44 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:699  Invalid misc:272   Missed beacon:0

Thanks once again.

Regards

Balaji R


-----Original Message-----
From: Balaji Ravindran [mailto:balravin@cisco.com] 
Sent: Tuesday, July 24, 2012 1:16 PM
To: Larry Finger
Cc: linux-wireless@vger.kernel.org; Gertjan van Wingerde
Subject: Re: Help requested troubleshooting compilation of rt3573 driver for
cisco ae3000

Hi Larry, Gertjan,

Thank you so much for the reply. I tried it, Yeap, rt2800usb is unable to
handle this chipset.

However, on the other hand, i tried to compile the driver again from RT3573
source. Even their device table did not have an entry for this dev_id
(13b1:003b), so I manually added the entry to the USB_DEVICE and compiled
the driver. 

It now works in my other ubuntu 12.04 computer.

I will head home and try it on my 64 bit OS though. I thought i did it
correctly yesterday, maybe i skipped something while adding the dev_id while
compiling the driver.

root@balravin-lnx-server:~# modprobe -v rt2800usb insmod
/lib/modules/3.2.0-25-generic-pae/kernel/drivers/net/wireless/rt2x00/rt2x00l
ib.ko
insmod
/lib/modules/3.2.0-25-generic-pae/kernel/drivers/net/wireless/rt2x00/rt2x00u
sb.ko
insmod /lib/modules/3.2.0-25-generic-pae/kernel/lib/crc-ccitt.ko
insmod
/lib/modules/3.2.0-25-generic-pae/kernel/drivers/net/wireless/rt2x00/rt2800l
ib.ko
insmod
/lib/modules/3.2.0-25-generic-pae/kernel/drivers/net/wireless/rt2x00/rt2800u
sb.ko

root@balravin-lnx-server:~# echo "13b1 003b" >
/sys/bus/usb/drivers/rt2800usb/new_id
root@balravin-lnx-server:~# lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub Bus 002
Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub Bus 003 Device 001:
ID 1d6b:0002 Linux Foundation 2.0 root hub Bus 004 Device 001: ID 1d6b:0003
Linux Foundation 3.0 root hub Bus 001 Device 002: ID 8087:0024 Intel Corp.
Integrated Rate Matching Hub Bus 002 Device 002: ID 8087:0024 Intel Corp.
Integrated Rate Matching Hub Bus 003 Device 002: ID 05e3:0608 Genesys Logic,
Inc. USB-2.0 4-Port HUB Bus 001 Device 003: ID 05ca:18c0 Ricoh Co., Ltd Bus
002 Device 003: ID 13b1:003b Linksys Bus 003 Device 003: ID 10d5:5000 Uni
Class Technology Co., Ltd Bus 001 Device 005: ID 0489:e00f Foxconn / Hon Hai
Foxconn T77H114 BCM2070 [Single-Chip Bluetooth 2.1 + EDR Adapter]
root@balravin-lnx-server:~# exit logout balravin@balravin-lnx-server:~$
iwconfig

wlan0     IEEE 802.11bgn  ESSID:"hurricane"
          Bit Rate=144.4 Mb/s   Tx-Power=13 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=66/70  Signal level=-44 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:699  Invalid misc:272   Missed beacon:0

Thanks once again.

Regards

Balaji R

On 07/24/2012 01:02 PM, Gertjan van Wingerde wrote:
Balaji, Larry,

On 24 jul. 2012, at 21:48, Larry Finger <Larry.Finger@lwfinger.net> wrote:

On 07/24/2012 01:52 PM, Balaji Ravindran (balravin) wrote:
Hi,

I request help to make my cisco AE3000 wireless usb work with my Ubuntu
12.04 64 bit server OS. I tried the following, and everything was in vain.
So please pass me on some pointers.

 1.      Started off with ndiswrapper.

   a.      Looked for Windows XP driver from CD packaging and tried load it
with ndiswrapper 1.57, but it is not working because, cisco does not provide
a 64 bit windows xp driver, so ndiswrapper complains saying 64 bit kernel
detected.

   b.      I did give a shot with using 64bit windows vista and windows 7
drivers included in the CD package even though I knew ndiswrapper will not
support vista or win 7 drivers.

2.      RT drivers are opensource (yay!) so identified the hardware Id for
the product it was (13b1:003b) comes with rt3573 chipset (I confirm that).
So I downloaded the latest RT3573 chipset driver from their RALINK website,
and still no use.
I successfully built and installed the rt3573sta.ko under
/lib/modules/(shell $(uname -r))..... and was successfully able to modprobe
the module. But still I did not see the device's model was recognized as a
WiFi device.
Output of 'lsusb' still showed up 'Linksys'

 3.      Step further, under /common/rtusb_dev_id.c I waslooking for the USB
device id, and I could'nt find a match for 13b1:003b., so created a new
device id, and rebuilt the driver

   a.      Make clean, make uninstall, make install.
   b.      Driver built successfully, still did not detect the device

4.      In vain tried the default included rt2800usb module., and did
   a.      sudo depmod -a
   b.      sudo modprobe -v rt2800usb
   c.      Module loaded successfully, and still in vain, driver not
detected.

Any help here would be much appreciated? Anything I missed out or I could
try., please help.

A device with an RT3573 chip should be handled by rt2800usb; however, your
particular ID is not in the device table.

What happens when you do the following:

su -
modprobe -v rt2800usb
echo "13b1 003b" > /sys/bus/usb/drivers/rt2800usb/new_id
exit

Unfortunately rt2800usb is not able to handle the RT3573 chip. It is quite a
different beast then the other chips that are supported ( for one it is the
first 3T3R chip that we see from Ralink, and the EEPROM layout is quite
different).

So, you have to stick with the driver of the Ralink website, until we are
able to add support for the chip in rt2800usb.
Although I do own a device with that chip, my time is unfortunately very
limited right now, so my progress is very slow.

---
Gertjan


