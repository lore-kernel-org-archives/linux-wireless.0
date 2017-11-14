Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34472 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752319AbdKNKjO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 05:39:14 -0500
Received: by mail-wm0-f42.google.com with SMTP id n74so17384662wmi.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Nov 2017 02:39:14 -0800 (PST)
Subject: Re: Slow connection with rtl8xxxu and 8192eu chipset
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-wireless@vger.kernel.org
References: <1195e649-c57f-1247-a0dc-2f0cc0732a00@gmail.com>
Cc: Jes.Sorensen@gmail.com
Message-ID: <ce042534-6ba9-9654-c99f-7cfdff45b88a@gmail.com> (sfid-20171114_113931_348206_7DCE7F8C)
Date: Tue, 14 Nov 2017 12:39:10 +0200
MIME-Version: 1.0
In-Reply-To: <1195e649-c57f-1247-a0dc-2f0cc0732a00@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 14.11.2017 11:26, Nikolay Borisov wrote:
> (Please CC as I'm not subscribed)
> 
> Hello,
> 
> I have the tp-link tl-wn822N usb wifi dongle. lsbusb reports it as
> 
> Bus 001 Device 003: ID 2357:0108
> 
> Unfortunately with the in-kernel rtl8xxxu driver I don't get very good
> results:
> 
> wifi1     IEEE 802.11  ESSID:"HOME"
>           Mode:Managed  Frequency:2.462 GHz  Access Point:
> 30:B5:C2:75:A4:CD
>           Bit Rate=1 Mb/s   Tx-Power=20 dBm
>           Retry short limit:7   RTS thr=2347 B   Fragment thr:off
>           Power Management:off
>           Link Quality=26/70  Signal level=-84 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:165   Missed beacon:0
> 
> 
> At the same time if I use an out of tree driver acquired from github:
> https://github.com/Mange/rtl8192eu-linux-driver I get the following:
> 
> wifi1     IEEE 802.11bgn  ESSID:"HOME"  Nickname:"<WIFI@REALTEK>"
>           Mode:Managed  Frequency:2.462 GHz  Access Point:
> 30:B5:C2:75:A4:CD
>           Bit Rate:144.4 Mb/s   Sensitivity:0/0
>           Retry:off   RTS thr:off   Fragment thr:off
>           Power Management:off
>           Link Quality=81/100  Signal level=100/100  Noise level=0/100
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> Clearly this is a software problem of the in-kernel driver. I'm using
> v4.10.17 with commit c14239f23adb ("rtl8xxxu: Add another 8192eu device
> to the USB list") so that my device is recognised. Latest commit for
> that driver in my kernel is: c59f13bbead4 ("rtl8xxxu: Work around issue
> with 8192eu and 8723bu devices not reconnecting").
> 
> Any ideas what I can do to further debug this, I'd really like to use
> the in-kernel driver ?

I just tested with verbatim 4.14 and even though the wireless works, 
iwconfig reports something strange: 

iwconfig wifi1
wifi1     no wireless extensions.

However, my device works as expected (albeit still slow): 

wifi1     Link encap:Ethernet  HWaddr 18:d6:c7:0d:47:3c  
          inet addr:10.20.1.175  Bcast:10.20.1.255  Mask:255.255.255.0
          inet6 addr: fe80::281d:5f27:eb1b:8ded/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:38903 errors:0 dropped:0 overruns:0 frame:0
          TX packets:24689 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:51524413 (51.5 MB)  TX bytes:5503039 (5.5 MB)


dmesg output:  

[вт ное 14 12:30:38 2017] usb 1-1.1: This Realtek USB WiFi dongle (0x2357:0x0108) is untested!
[вт ное 14 12:30:38 2017] usb 1-1.1: Please report results to Jes.Sorensen@gmail.com
[вт ное 14 12:30:39 2017] usb 1-1.1: Vendor: Realtek
[вт ное 14 12:30:39 2017] usb 1-1.1: Product: 802.11n NI
[вт ное 14 12:30:39 2017] usb 1-1.1: Serial: 
[вт ное 14 12:30:39 2017] usb 1-1.1: rtl8192eu_parse_efuse: dumping efuse (0x200 bytes):
[вт ное 14 12:30:39 2017] usb 1-1.1: 00: 29 81 00 7c 01 40 03 00
[вт ное 14 12:30:39 2017] usb 1-1.1: 08: 40 74 04 50 14 00 00 00
[вт ное 14 12:30:39 2017] usb 1-1.1: 10: 2b 2b 2c 2d 2d 2d 2c 2c
[вт ное 14 12:30:39 2017] usb 1-1.1: 18: 2d 2e 2e f2 ef ef ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 20: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 28: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 30: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 38: ff ff 29 29 29 29 29 29
[вт ное 14 12:30:39 2017] usb 1-1.1: 40: 2a 2a 29 29 29 f2 ef ef
[вт ное 14 12:30:39 2017] usb 1-1.1: 48: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 50: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 58: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 60: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 68: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 70: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 78: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 80: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 88: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 90: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 98: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: a0: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: a8: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: b0: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: b8: a1 3e 23 00 00 00 ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: c0: ff 01 00 10 00 00 00 ff
[вт ное 14 12:30:39 2017] usb 1-1.1: c8: 00 00 ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: d0: 57 23 08 01 e7 47 02 18
[вт ное 14 12:30:39 2017] usb 1-1.1: d8: d6 c7 0d 47 3c 0a 03 52
[вт ное 14 12:30:39 2017] usb 1-1.1: e0: 65 61 6c 74 65 6b 20 0e
[вт ное 14 12:30:39 2017] usb 1-1.1: e8: 03 38 30 32 2e 31 31 6e
[вт ное 14 12:30:39 2017] usb 1-1.1: f0: 20 4e 49 43 20 00 00 ff
[вт ное 14 12:30:39 2017] usb 1-1.1: f8: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 100: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 108: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 110: ff ff ff ff ff ff ff 0d
[вт ное 14 12:30:39 2017] usb 1-1.1: 118: 03 00 05 00 30 00 00 00
[вт ное 14 12:30:39 2017] usb 1-1.1: 120: 00 93 ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 128: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 130: f6 a8 98 2d 03 92 98 00
[вт ное 14 12:30:39 2017] usb 1-1.1: 138: fc 8c 00 11 9b 44 02 0a
[вт ное 14 12:30:39 2017] usb 1-1.1: 140: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 148: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 150: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 158: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 160: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 168: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 170: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 178: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 180: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 188: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 190: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 198: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 1a0: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 1a8: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 1b0: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 1b8: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 1c0: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 1c8: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 1d0: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 1d8: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 1e0: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 1e8: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 1f0: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: 1f8: ff ff ff ff ff ff ff ff
[вт ное 14 12:30:39 2017] usb 1-1.1: RTL8192EU rev B (SMIC) 2T2R, TX queues 3, WiFi=1, BT=0, GPS=0, HI PA=0
[вт ное 14 12:30:39 2017] usb 1-1.1: RTL8192EU MAC: 18:d6:c7:0d:47:3c
[вт ное 14 12:30:39 2017] usb 1-1.1: rtl8xxxu: Loading firmware rtlwifi/rtl8192eu_nic.bin
[вт ное 14 12:30:39 2017] usb 1-1.1: Firmware revision 19.0 (signature 0x92e1)
[вт ное 14 12:30:40 2017] usbcore: registered new interface driver rtl8xxxu
[вт ное 14 12:30:40 2017] rtl8xxxu 1-1.1:1.0 wifi1: renamed from wlan0
[вт ное 14 12:30:40 2017] IPv6: ADDRCONF(NETDEV_UP): wifi1: link is not ready
[вт ное 14 12:30:40 2017] IPv6: ADDRCONF(NETDEV_UP): wifi1: link is not ready
[вт ное 14 12:30:40 2017] IPv6: ADDRCONF(NETDEV_UP): wifi1: link is not ready
[вт ное 14 12:30:40 2017] Ebtables v2.0 registered
[вт ное 14 12:30:48 2017] random: crng init done
[вт ное 14 12:30:51 2017] wifi1: authenticate with 30:b5:c2:75:a4:cd
[вт ное 14 12:30:51 2017] wifi1: send auth to 30:b5:c2:75:a4:cd (try 1/3)
[вт ное 14 12:30:51 2017] wifi1: authenticated
[вт ное 14 12:30:51 2017] wifi1: associate with 30:b5:c2:75:a4:cd (try 1/3)
[вт ное 14 12:30:51 2017] wifi1: RX AssocResp from 30:b5:c2:75:a4:cd (capab=0x431 status=0 aid=1)
[вт ное 14 12:30:51 2017] usb 1-1.1: rtl8xxxu_bss_info_changed: HT supported
[вт ное 14 12:30:51 2017] wifi1: associated



> 
> 
