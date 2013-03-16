Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f53.google.com ([209.85.128.53]:36326 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3CPXWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 19:22:55 -0400
Received: by mail-qe0-f53.google.com with SMTP id cz11so2621435qeb.40
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2013 16:22:54 -0700 (PDT)
Message-ID: <5144FECC.6050504@lwfinger.net> (sfid-20130317_002308_820554_1B95E519)
Date: Sat, 16 Mar 2013 18:22:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Clauss <cclauss@bluewin.ch>
CC: ziv_huang@realtek.com, georgia@realtek.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192cu NOT working on Raspberry Pi
References: <041DFAF5-BEDE-4C1A-9863-A04F2DD3049A@bluewin.ch>
In-Reply-To: <041DFAF5-BEDE-4C1A-9863-A04F2DD3049A@bluewin.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/2013 05:03 PM, Christian Clauss wrote:
> Hi Larry, Ziv, and Georgia,
>
>     These rtl8192cu drivers seem to be very flakey / non-functional on Raspberry Pi.
>
>      https://github.com/hexameron/rtlwifi
>
>      http://www.raspberrypi.org/phpBB3/viewtopic.php?f=71&t=24951

Sorry, but I only support the drivers in the current Linux kernel, and as 
backported with compat-drivers.

>
> # ========
>
> $ uname -a
> Linux raspberrypi 3.6.11+ #371 PREEMPT Thu Feb 7 16:31:35 GMT 2013 armv6l GNU/Linux
>
> # ========
>
> $ modinfo rtl8192cu          # Only after following hexameron's instructions above.
> filename:       /lib/modules/3.6.11+/kernel/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko
> firmware:       rtlwifi/rtl8192cufw.bin
> description:    Realtek 8192C/8188C 802.11n USB wireless
> license:        GPL
> author:         Larry Finger	<Larry.Finger@lwfinger.net>
> author:         Ziv Huang	<ziv_huang@realtek.com>
> author:         Georgia		<georgia@realtek.com>
>
> # ========
>
> $ modinfo 8192cu
> filename:       /lib/modules/3.6.11+/kernel/drivers/net/wireless/rtl8192cu/8192cu.ko
> version:        v3.4.3_4369.20120622
> author:         Realtek Semiconductor Corp.
> description:    Realtek Wireless Lan Driver
> license:        GPL
>
> # ========
>
> $ ifup wlan0
> ioctl[SIOCSIWAP]: Operation not permitted
> ioctl[SIOCSIWENCODEEXT]: Invalid argument
> ioctl[SIOCSIWENCODEEXT]: Invalid argument

No mac80211 driver will support *ALL* of the ioctl commands. You should use iw; 
however, these should not be critical.

>
> # ========
>
> $ ip addr
> 4: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN qlen 1000
>      link/ether e0:91:53:62:9e:d9 brd ff:ff:ff:ff:ff:ff
>
> # ========
>
> $ ifconfig wlan0
> wlan0     Link encap:Ethernet  HWaddr e0:91:53:62:9e:d9
>            UP BROADCAST MULTICAST  MTU:1500  Metric:1
>            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>            collisions:0 txqueuelen:1000
>            RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

There is a major bug in rtl8192cu that was just fixed this past week. See 
http://marc.info/?l=linux-wireless&m=136319807619280&w=2 for the patch.

Larry


