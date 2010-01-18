Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:39301 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab0ARQPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2010 11:15:32 -0500
Received: by fxm25 with SMTP id 25so614128fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2010 08:15:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <933379711001180712v7e6c0a3fx923123af900d90c7@mail.gmail.com>
References: <933379711001180712v7e6c0a3fx923123af900d90c7@mail.gmail.com>
From: Giuseppe Fontana <gfontana13@gmail.com>
Date: Mon, 18 Jan 2010 17:15:06 +0100
Message-ID: <933379711001180815r284ff41au733cadb40a7606fe@mail.gmail.com>
Subject: Broadcom BCM4318 AirForceOne issue - Ubuntu 9.10 on Acer Aspire
	5024wlmi
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi! I installed Ubuntu 9.10 on my Acer 5024wlmi and followed Linux
wireless instructions to enable my Broadcom AirForceOne BCM4318 wifi
card. Now the wireless adapter is on (laptop front led also is on), I
can see wifi networks but connection fails (even with a simple ad-hoc
open wifi network!). I tried with Network Manager/WICD/Wifi Radar and
also using terminal lfconfig/lwconfig commands without success. It
seems that my wifi card cannot ping access points: for example see
this log from WICD connection session:

-2010/01/16 22:51:15 :: Connecting to wireless network Winx
-2010/01/16 22:51:15 :: ping -q -w 3 -c 1 192.168.0.1
-2010/01/16 22:51:17 :: iwconfig wlan0
-2010/01/16 22:51:18 :: Connection Failed: Failed to ping the access point!

Here there are some useful data about my laptop/Ubuntu configuration.
Hope you can help!

------------------------------------------------------------------------------------------------------------------------------------------
Laptop model >> Acer Aspire 5024wlmi laptop
giuseppe@giuseppe-laptop:~$ lsb_release -d >> Description:    Ubuntu 9.10
giuseppe@giuseppe-laptop:~$ uname -mr >> 2.6.31-17-generic i686
------------------------------------------------------------------------------------------------------------------------------------------
giuseppe@giuseppe-laptop:~$ sudo lspci | grep 'Broadcom'
06:05.0 Network controller: Broadcom Corporation BCM4318 [AirForce One
54g] 802.11g Wireless LAN Controller (rev 02)
------------------------------------------------------------------------------------------------------------------------------------------
giuseppe@giuseppe-laptop:~$ sudo iwconfig wlan0
wlan0     IEEE 802.11bg  ESSID:""
          Mode:Managed  Frequency:2.462 GHz  Access Point: Not-Associated
          Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

------------------------------------------------------------------------------------------------------------------------------------------
giuseppe@giuseppe-laptop:~$ sudo lsmod | grep "b43"
b43                   122168  0
mac80211              181140  1 b43
cfg80211               93052  2 b43,mac80211
led_class               4096  3 acer_wmi,b43,sdhci
ssb                    35364  1 b43
------------------------------------------------------------------------------------------------------------------------------------------
giuseppe@giuseppe-laptop:~$ dmesg | grep b43
[    2.717660] b43-pci-bridge 0000:06:05.0: PCI INT A -> GSI 21
(level, low) -> IRQ 21
[   14.884317] b43-phy0: Broadcom 4318 WLAN found (core revision 9)
[   16.516094] b43 ssb0:0: firmware: requesting b43/ucode5.fw
[   16.739725] b43 ssb0:0: firmware: requesting b43/pcm5.fw
[   16.745578] b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
[   16.751202] b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
[...]
[ 4300.736074] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[ 4300.776488] Registered led device: b43-phy0::tx
[ 4300.776531] Registered led device: b43-phy0::rx
[ 4300.776575] Registered led device: b43-phy0::radio
------------------------------------------------------------------------------------------------------------------------------------------
giuseppe@giuseppe-laptop:~$ sudo lshw -C network
  *-network:0
       description: Network controller
       product: BCM4318 [AirForce One 54g] 802.11g Wireless LAN Controller
       vendor: Broadcom Corporation
       physical id: 5
       bus info: pci@0000:06:05.0
       version: 02
       width: 32 bits
       clock: 33MHz
       capabilities: bus_master
       configuration: driver=b43-pci-bridge latency=64
       resources: irq:21 memory:c0204000-c0205fff
  *-network:1
       description: Ethernet interface
       product: RTL-8169 Gigabit Ethernet
       vendor: Realtek Semiconductor Co., Ltd.
       physical id: 7
       bus info: pci@0000:06:07.0
       logical name: eth0
       version: 10
       serial: 00:0a:e4:e8:a2:87
       size: 1GB/s
       capacity: 1GB/s
       width: 32 bits
       clock: 66MHz
       capabilities: pm bus_master cap_list rom ethernet physical tp
mii 10bt 10bt-fd 100bt 100bt-fd 1000bt 1000bt-fd autonegotiation
       configuration: autonegotiation=on broadcast=yes driver=r8169
driverversion=2.3LK-NAPI duplex=full ip=192.168.0.242 latency=64
link=yes maxlatency=64 mingnt=32 multicast=yes port=MII speed=1GB/s
       resources: irq:23 ioport:a000(size=256)
memory:c0209400-c02094ff memory:44000000-4401ffff(prefetchable)
  *-network
       description: Wireless interface
       physical id: 1
       logical name: wlan0
       serial: 00:14:a4:49:c7:fc
       capabilities: ethernet physical wireless
       configuration: broadcast=yes multicast=yes wireless=IEEE 802.11bg
------------------------------------------------------------------------------------------------------------------------------------------
giuseppe@giuseppe-laptop:~$ sudo iwlist scan
(...)
wlan0     Scan completed :
          Cell 01 - Address: 02:1D:E0:00:08:5A
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=62/70  Signal level=-48 dBm
                    Encryption key:off
                    ESSID:"Winx"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
                              36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Ad-Hoc
                    Extra:tsf=00000001035383eb
                    Extra: Last beacon: 272ms ago
                    IE: Unknown: 000457696E78
                    IE: Unknown: 010482840B16
                    IE: Unknown: 03010B
                    IE: Unknown: 06020000
                    IE: Unknown: 2A0100
                    IE: Unknown: 32080C1218243048606C
                    IE: Unknown: DD070giuseppe@giuseppe-laptop:~$ sudo
iwlist scan050F202000100
------------------------------------------------------------------------------------------------------------------------------------------
giuseppe@giuseppe-laptop:~$ sudo /etc/init.d/networking restart
 * Reconfiguring network interfaces...
