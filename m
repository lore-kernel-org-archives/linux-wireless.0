Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout027.mac.com ([17.148.16.102]:47346 "EHLO
	asmtpout027.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0LQAXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 19:23:48 -0500
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII
Received: from [192.168.1.30] (unknown [87.201.169.175])
 by asmtp027.mac.com (Oracle Communications Messaging Exchange Server 7u4-18.01
 64bit (built Jul 15 2010)) with ESMTPSA id <0LDJ00FMEQFHDC20@asmtp027.mac.com>
 for linux-wireless@vger.kernel.org; Thu, 16 Dec 2010 16:23:47 -0800 (PST)
Subject: Problem bringing up wlan0 interface up with mainline wl1271 drivers
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <AANLkTikESPwcaxUSDd3B=Oh7kBD-QpndKRHmu9-roDqs@mail.gmail.com>
Date: Fri, 17 Dec 2010 04:23:32 +0400
Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>,
	panduranga <x0125717@ti.com>, Pedro Jara <pedrojara@ti.com>
Message-id: <C77CCCD3-2467-4363-A513-05B68B9F57F6@mac.com>
References: <57CB308D-7237-46D7-9AF8-7093F52682E8@mac.com>
 <AANLkTikESPwcaxUSDd3B=Oh7kBD-QpndKRHmu9-roDqs@mail.gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Dec 12, 2010, at 1:24 AM, Ohad Ben-Cohen wrote:

>> When I build the TI WiLink drivers from the ti rowboat hardware/ti/wlan project
> 
> The linux-omap community can help you with mainline drivers, but no so
> much with proprietary ones. Why don't you use the upstream wl12xx
> driver ?

I've built linux kernel 2.6.37-rc6, and patched board-omap3beagle.c to interface with MMC2 SDIO controller, 
but I'm unable to bring the wlan0 interface up.

Here are the messages during kernel boot:

[    0.000000] wlan_mux_init: Configuring mux settings for wl1271 wlan module
[    0.077117] regulator: vwl1271: 1850 mV normal standby
[    2.171813] mmc1: mmc_rescan: trying to init card at 400000 Hz
[    2.323120] mmc1: card claims to support voltages below the defined range. These will be ignored.
[    2.368865] mmc1: queuing unknown CIS tuple 0x91 (3 bytes)
[    2.392150] mmc1: new SDIO card at address 0001
[    2.787597] wl1271: loaded
[    2.790802] wl1271: initialized

# ifconfig -a
lo        Link encap:Local Loopback  
          LOOPBACK  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

wlan0     Link encap:Ethernet  HWaddr 00:00:00:00:00:00  
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

# ifconfig wlan0 up
SIOCSIFFLAGS: Cannot assign requested address

What could the reason be?

Elvis Dowson
