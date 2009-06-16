Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:44335 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZFPRsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 13:48:07 -0400
Received: by qw-out-2122.google.com with SMTP id 5so2791751qwd.37
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 10:48:09 -0700 (PDT)
MIME-Version: 1.0
From: suvayu ali <fatkasuvayu+linux@gmail.com>
Date: Tue, 16 Jun 2009 10:47:48 -0700
Message-ID: <fe3123490906161047n11043d63y94166a03815cff47@mail.gmail.com>
Subject: Prism54 driver not working on 2.6.29 kernel
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am a user who is having trouble getting Prism54 to work. The
webpage[1]  for Linux wireless said to ask on this list so here I am.

Hardware:   D-Link DWL-G122 rev. A1
OS:              Fedora 11 x86_64
Kernel:         2.6.29.4-167.fc11.x86_64

I had this working under F10 flawlessly with kernel 2.6.27. But since
I have upgraded to F11 it has stopped working. I have used the
appropriate firmware as mentioned in [1]. After I put the firmware in
/lib/firmware, modprobe prism54 and reboot, I get this.

$ dmesg|grepp 54
phy0: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2392
p54usb: probe of 2-1:1.0 failed with error -16
usbcore: registered new interface driver p54usb

$ dmesg |grep prism
Loaded prism54 driver, version 1.2

$ lsmod |grep p54
p54usb                 14624  0
p54common              20820  1 p54usb
mac80211              199552  2 p54usb,p54common

$ dmesg |grep isl
usb 2-1: firmware: requesting isl3886usb

My kernel is configured like this,

prism54:
   Symbol: PRISM54 [=m]
   Prompt: Intersil Prism GT/Duette/Indigo PCI/Cardbus
     Defined at drivers/net/wireless/Kconfig:375
     Depends on: NETDEVICES && !S390 && PCI && EXPERIMENTAL && WLAN_80211
     Location:
       -> Device Drivers
         -> Network device support (NETDEVICES [=y])
           -> Wireless LAN
             -> Wireless LAN (IEEE 802.11) (WLAN_80211 [=y])
     Selects: WIRELESS_EXT && FW_LOADER

p54:
   Symbol: P54_USB [=m]
   Prompt: Prism54 USB support
     Defined at drivers/net/wireless/p54/Kconfig:14
     Depends on: NETDEVICES && !S390 && P54_COMMON && USB
     Location:
       -> Device Drivers
         -> Network device support (NETDEVICES [=y])
           -> Wireless LAN
             -> Wireless LAN (IEEE 802.11) (WLAN_80211 [=y])
               -> Softmac Prism54 support (P54_COMMON [=m])
     Selects: CRC32

   Symbol: P54_COMMON [=m]
   Prompt: Softmac Prism54 support
     Defined at drivers/net/wireless/p54/Kconfig:1
     Depends on: NETDEVICES && !S390 && MAC80211 && WLAN_80211 && FW_LOADE
     Location:
       -> Device Drivers
         -> Network device support (NETDEVICES [=y])
           -> Wireless LAN
             -> Wireless LAN (IEEE 802.11) (WLAN_80211 [=y])

   Symbol: P54_PCI [=m]
   Prompt: Prism54 PCI support
     Defined at drivers/net/wireless/p54/Kconfig:51
     Depends on: NETDEVICES && !S390 && P54_COMMON && PCI
     Location:
       -> Device Drivers
         -> Network device support (NETDEVICES [=y])
           -> Wireless LAN
             -> Wireless LAN (IEEE 802.11) (WLAN_80211 [=y])
               -> Softmac Prism54 support (P54_COMMON [=m])

Now when I use the _old_ _firmware_ (the firmware I used with F10 and
kernel 2.6.27) and rename it from isl3890usb to isl3886usb, I am able
to connect to but only for less than a minute. This Is what I get when
using the firmware for 2.6.27.

$ dmesg |grep p54
phy0: p54 detected a LM86 firmware
phy0: you are using an obsolete firmware. visit
http://wireless.kernel.org/en/users/Drivers/p54 and grab one for
"kernel >= 2.6.28"!
wmaster0 (p54usb): not using net_device_ops yet
wlan0 (p54usb): not using net_device_ops yet
usbcore: registered new interface driver p54usb

$ lsmod |grep prism
prism54                53352  0

The other messages are same as above.

Am I doing something wrong? Thanks for any help on this.

[1] http://wireless.kernel.org/en/users/Drivers/p54
-- 
Suvayu

Open source is the future. It sets us free.
