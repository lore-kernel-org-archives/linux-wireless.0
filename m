Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33747 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1IHPMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 11:12:46 -0400
Received: by yie30 with SMTP id 30so41069yie.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 08:12:46 -0700 (PDT)
Message-ID: <4E68DB6A.60006@lwfinger.net> (sfid-20110908_171250_649536_1A17F297)
Date: Thu, 08 Sep 2011 10:12:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Semigod King <semigodking@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211 driver for RT3070 wifi card does not work on big-endian
 platform
References: <CA+TXxM3EgGZmo1F9GS+-QNWfTTgWFD4XHvG31JH=kabrr=ES=A@mail.gmail.com>
In-Reply-To: <CA+TXxM3EgGZmo1F9GS+-QNWfTTgWFD4XHvG31JH=kabrr=ES=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/08/2011 12:34 AM, Semigod King wrote:
> Greetings,
>
> I would like to report a bug to you. The same problem was reported to
> OpenWRT developers. But, they suggest me report it to linux wireless.
>
> Problem:
> The wireless card can not be recognized. But, an iface with wrong MAC
> is created.
>
> wlan1 Link encap:Ethernet HWaddr 00:06:4E:E8:00:00<== Wrong MAC, the
> correct MAC is E8:4E:06:00:74:61. Looks like byte-swapped.
> UP BROADCAST MULTICAST MTU:1500 Metric:1<=== Not running
> RX packets:0 errors:0 dropped:0 overruns:0 frame:0
> TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
> collisions:0 txqueuelen:1000
> RX bytes:0 (0.0 B) TX bytes:0 (0.0 B)
>
> After making changes according to
> https://forum.openwrt.org/viewtopic.php?id=30132,
> the card can now be recognized with correct MAC and can be operated.
> But, it does not work yet.
> No RX in AP mode. No TX&  RX in STA mode. I guess the TX in AP mode is
> meaningless.
>
>
> Wifi Card: Unknown brand, RT3070 chipset, USB
> Platform: Openwrt (MIPS, BCM6358, big-endian)
> Kernel:
> root@OpenWrt:~# uname -a
> Linux OpenWrt 2.6.39.4 #1 Mon Aug 22 04:57:19 MST 2011 mips GNU/Linux
> driver: mac80211 compat-wireless driver.
> kmod-rt2800-lib - 2.6.39.4+2011-08-10-2
> kmod-rt2800-usb - 2.6.39.4+2011-08-10-2
> kmod-rt2x00-lib - 2.6.39.4+2011-08-10-2
> kmod-rt2x00-usb - 2.6.39.4+2011-08-10-2

Obviously, that driver fails to work on a big-endian platform. For tracking 
purposes, please open a bug report at bugzilla.kernel.org. That will also be a 
location for exchanging trial patches.

I have an RT3090 USB device and a MacBook G4 that uses the PPC processor, thus I 
have a test bed for investigating this problem.

Larry
