Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.wut.de ([194.77.229.25]:51611 "EHLO mail.wut.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab2ALOVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 09:21:04 -0500
Message-ID: <4F0EEA1B.3040501@wut.de> (sfid-20120112_152109_885301_61827E02)
Date: Thu, 12 Jan 2012 15:11:39 +0100
From: =?ISO-8859-15?Q?Markus_K=F6nigshaus?= <m.koenigshaus@wut.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Larry.Finger@lwfinger.net, georgia@realtek.com
Subject: Problem with the rtl8192cu - kernelmodule after ifdown, ifup
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am using a USB WLAN - Stick with Realtek 8192 kernel driver. After 
plugging it works fine, connecting to a WPA - network works. After 
ifdown wlan0, ifup wlan0 the stick no longer works , it stucks on 
scanning. Only a modprobe -r rtl8192cu; modprobe rtl8192cu fixes the 
problem. The problem only appear if more than one wireless - network is 
in range.The problem appear only in connection with the rtl8192cu 
driver, other USB - sticks (with different Chipset) and other PCIE - 
boards operate properly.
In order to reproduce the behavior repeat the sequenceifdown wlan0, ifup 
wlan0 a few times.

wpa_cli status->
Selected interface 'wlan0'
wpa_state=SCANNING
< no change after 10 minutes>

dmesg ->
rtl8192cu: MAC auto ON okay!
rtl8192cu: Tx queue select: 0x05
rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
wlan0: authenticate with 00:08:54:9a:b2:5f (try 1)
wlan0: authenticated
wlan0: associate with 00:08:54:9a:b2:5f (try 1)
wlan0: RX AssocResp from 00:08:54:9a:b2:5f (capab=0x411 status=0 aid=1)
wlan0: associated
< ifdown wlan0 >
wlan0: disassociated from 00:08:54:9a:b2:5f (Reason: 14)
wlan0: deauthenticating from 00:08:54:9a:b2:5f by local choice (reason=3)
cfg80211: Calling CRDA for country: US
rtl8192cu: MAC auto ON okay!
rtl8192cu: Tx queue select: 0x05
rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
< ifup wlan0 >
rtl8192cu: MAC auto ON okay!
rtl8192cu: Tx queue select: 0x05
rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin


cat /sys/class/net/wlan0/carrier -> 0
cat /sys/class/net/wlan0/operstate -> down

Kernelversion: 3.1.8

modinfo rtl8192cu->
filename:       kernel/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko
description:    Realtek 8192C/8188C 802.11n USB wireless
author:         Larry Finger <Larry.Finger@lwfinger.net>
author:         Georgia <georgia@realtek.com>
license:        GPL
vermagic:       3.1.8-WuT preempt mod_unload ARMv5
firmware:       rtlwifi/rtl8192cufw.bin
depends:        rtlwifi,rtl8192c-common

lsusb ->
Bus 001 Device 001: ID 1d6b:0002
Bus 001 Device 003: ID 0bda:8176

lsmod ->
Module                  Size  Used by    Not tainted
rtl8192cu              89196  0
rtl8192c_common        53560  1 rtl8192cu
rtlwifi                88269  1 rtl8192cu
orion_wdt               3043  1

iwlist wlan0 scan ->
wlan0     No scan results


After modprobe -r rtl8192cu; modprobe rtl8192cu

cat /sys/class/net/wlan0/carrier ->1
cat /sys/class/net/wlan0/operstate ->up

< First scan only finds Cell 01 >

iwlist wlan0 scan->
wlan0     Scan completed :
           Cell 01 - Address: 00:08:54:9A:B2:5F
                     Channel:1
                     Frequency:2.412 GHz (Channel 1)
                     Quality=70/70  Signal level=-36 dBm
                     Encryption key:on
                     ESSID:"AP-KK"
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                               9 Mb/s; 12 Mb/s; 18 Mb/s
                     Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s
                     Mode:Master
                     Extra:tsf=000000044859a0d7
                     Extra: Last beacon: 20ms ago
                     (Unknown Wireless Token 0x8C05)

< Retry >

iwlist wlan0 scan
wlan0     Scan completed :
           Cell 01 - Address: 00:08:54:9A:B2:5F
                     Channel:1
                     Frequency:2.412 GHz (Channel 1)
                     Quality=69/70  Signal level=-41 dBm
                     Encryption key:on
                     ESSID:"AP-KK"
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                               9 Mb/s; 12 Mb/s; 18 Mb/s
                     Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s
                     Mode:Master
                     Extra:tsf=000000044880b0d7
                     Extra: Last beacon: 20ms ago
                     (Unknown Wireless Token 0x8C05)
           Cell 02 - Address: C8:3A:35:18:1B:D8
                     Channel:6
                     Frequency:2.437 GHz (Channel 6)
                     Quality=69/70  Signal level=-41 dBm
                     Encryption key:on
                     ESSID:"Logilink"
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 9 Mb/s
                               18 Mb/s; 36 Mb/s; 54 Mb/s
                     Bit Rates:6 Mb/s; 12 Mb/s; 24 Mb/s; 48 Mb/s
                     Mode:Master
                     Extra:tsf=00000000dd4b9158
                     Extra: Last beacon: 300ms ago
                     (Unknown Wireless Token 0x8C05)

Regards, Markus

-- Unsere Aussagen koennen Irrtuemer und Missverstaendnisse enthalten.
Bitte pruefen Sie die Aussagen fuer Ihren Fall, bevor Sie Entscheidungen 
auf Grundlage dieser Aussagen treffen.
Wiesemann & Theis GmbH, Porschestr. 12, D-42279 Wuppertal
Geschaeftsfuehrer: Dipl.-Ing. Ruediger Theis
Registergericht: Amtsgericht Wuppertal, HRB 6377 
Tel. +49-202/2680-0, Fax +49-202/2680-265, http://www.wut.de
