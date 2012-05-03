Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40841 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430Ab2ECTFH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 15:05:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SQ1Kp-00024r-LB
	for linux-wireless@vger.kernel.org; Thu, 03 May 2012 21:05:03 +0200
Received: from host-84-13-216-172.opaltelecom.net ([84.13.216.172])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 21:05:03 +0200
Received: from mprowe by host-84-13-216-172.opaltelecom.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 21:05:03 +0200
To: linux-wireless@vger.kernel.org
From: Martin Rowe <mprowe@gzunder.homeip.net>
Subject: Poor Signal Strength on Broadcom BCM94313....? 
Date: Thu, 3 May 2012 18:44:38 +0000 (UTC)
Message-ID: <loom.20120503T203736-143@post.gmane.org> (sfid-20120503_210511_787697_AD0B5244)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a new notebook (HP DM1-4125) onto which I have installed openSUSE 12.1.
Generally, all is well. But (isn't there always!) I am having problems with the
wireless (wlan and bt).
The radio module is a Broadcom BCM94313HMGB. Which, I think is a BCM4313 plus a
BCM20702AW bluetooth component?

My problem is that the rx signal is VERY poor.
For example with BCM94313 (wlan0) installed in a testbed alongside a (very old
but) known working unit (wlan1). At only 30cm from the AP, I see these figures:

#iwlist scan

wlan0     Scan completed :
          Cell 01 - Address: 00:21:63:30:0B:E8
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
          **********Quality=37/70  Signal level=-73 dBm*************
                    Encryption key:on
                    ESSID:"myAP0"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              9 Mb/s; 12 Mb/s; 18 Mb/s
                    Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=00000000127b4180
                    Extra: Last beacon: 166ms ago
*****Truncated*******

wlan1      Scan completed :
          Cell 01 - Address: 00:21:63:30:0B:E8
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
          **********Quality=70/70  Signal level=-33 dBm***********
                    Encryption key:on
                    ESSID:"myAP0"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              9 Mb/s; 12 Mb/s; 18 Mb/s
                    Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=00000000127f062e
                    Extra: Last beacon: 169ms ago
******TRUNCATED*****

When, I move more that 5 meters away from the AP, all connection is lost via the
Broadcom. I have to increase the distance to over 20m before the other wlan
connection starts complaining. Any suggestions on how to increase the range for
the broadcom will be appreciated.

One possible cause that comes to mind is the Antenna Diversity?
Is the antenna switch introducing this massive loss? Can this antenna switch be
bypassed via software or is it purely a hardware function?

Incidentally, the bluetooth function is nowhere to be seen!! But I guess that
this is a whole different (driver) issue?

I hope that any details that may be useful are listed here:

#hwinfo --wlan
25: PCI 300.0: 0282 WLAN controller
  [Created at pci.319]
  Unique ID: y9sn.N0h4zxfwtV0
  Parent ID: H0_h.4N97gW8nvQ8
  SysFS ID: /devices/pci0000:00/0000:00:06.0/0000:03:00.0
  SysFS BusID: 0000:03:00.0
  Hardware Class: network
  Model: "Broadcom WLAN controller"
  Vendor: pci 0x14e4 "Broadcom"
  Device: pci 0x4727 
  SubVendor: pci 0x103c "Hewlett-Packard Company"
  SubDevice: pci 0x1795 
  Revision: 0x01
  Driver: "brcmsmac"
  Driver Modules: "brcmsmac"
  Device File: wlan0
  Features: WLAN
  Memory Range: 0xfe3fc000-0xfe3fffff (rw,non-prefetchable)
  IRQ: 18 (no events)
  HW Address: 60:d8:19:99:39:12
  Link detected: no
  WLAN channels: 1 2 3 4 5 6 7 8 9 10 11 12 13 14
  WLAN frequencies: 2.412 2.417 2.422 2.427 2.432 2.437 2.442 2.447 2.452 2.457
2.462 2.467 2.472 2.484
  WLAN encryption modes: WEP40 WEP104 TKIP CCMP
  WLAN authentication modes: open sharedkey wpa-psk wpa-eap
  Module Alias: "pci:v000014E4d00004727sv0000103Csd00001795bc02sc80i00"
  Driver Info #0:
    Driver Status: brcmsmac is active
    Driver Activation Cmd: "modprobe brcmsmac"
  Driver Info #1:
    Driver Status: bcma is active
    Driver Activation Cmd: "modprobe bcma"
  Driver Info #2:
    Driver Status: wl is active
    Driver Activation Cmd: "modprobe wl"
  Config Status: cfg=no, avail=yes, need=no, active=unknown
  Attached to: #4 (PCI bridge)

27: PCMCIA 00.0: 0282 WLAN controller
  [Created at pcmcia.84]
  Unique ID: pz0h.lG4e6KMEdl8
  Parent ID: +QnG.J5lSzbB0WR8
  SysFS ID: /devices/pci0000:00/0000:00:14.4/0000:04:06.0/0.0
  SysFS BusID: 0.0
  Hardware Class: network
  Model: "TOSHIBA Wireless LAN Card"
  Hotplug: CardBus
  Socket: 0
  Vendor: pcmcia 0x0156 "TOSHIBA"
  Device: pcmcia 0x0002 "Wireless LAN Card"
  Driver: "orinoco_cs"
  Driver Modules: "orinoco_cs"
  Device File: eth1
  Features: WLAN
  HW Address: 00:02:2d:13:2d:ea
  Link detected: no
  WLAN channels: 1 2 3 4 5 6 7 8 9 10 11
  WLAN frequencies: 2.412 2.417 2.422 2.427 2.432 2.437 2.442 2.447 2.452 2.457
2.462
  WLAN encryption modes: WEP40 WEP104 TKIP
  WLAN authentication modes: open sharedkey wpa-psk wpa-eap
  Module Alias:
"pcmcia:m0156c0002f06fn00pfn00paB4585A1Apb0B537C13pcD27DEB1Apd00000000"
  Driver Info #0:
    Driver Status: hostap_cs is not active
    Driver Activation Cmd: "modprobe hostap_cs"
  Driver Info #1:
    Driver Status: orinoco_cs is active
    Driver Activation Cmd: "modprobe orinoco_cs"
  Extra Info: TOSHIBA, Wireless LAN Card, Version 01.01
  Config Status: cfg=no, avail=yes, need=no, active=unknown
  Attached to: #26 (CardBus bridge)

Regards, Martin

