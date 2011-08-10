Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:32942 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab1HJLpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 07:45:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Qr7Df-0005x1-IL
	for linux-wireless@vger.kernel.org; Wed, 10 Aug 2011 13:45:07 +0200
Received: from 203.200.200.74.ill-bgl.static.vsnl.net.in ([203.200.200.74.ill-bgl.static.vsnl.net.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 13:45:07 +0200
Received: from amit.gemini by 203.200.200.74.ill-bgl.static.vsnl.net.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 13:45:07 +0200
To: linux-wireless@vger.kernel.org
From: =?utf-8?b?YW1pdC5nZW1pbmlAc2Fza2VuLmNvbQ==?=
	<amit.gemini@sasken.com>
Subject: Problem bringing up wlan0 interface up with mainline wl1271 drivers on Panda Board with 2.6.39 Kernel
Date: Wed, 10 Aug 2011 11:38:20 +0000 (UTC)
Message-ID: <loom.20110810T133554-589@post.gmane.org> (sfid-20110810_134513_166734_B2CFD2CE)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am using Panda Board with 2.6.39 Kernel

when ever i insert the driver , error comes out "wl1271: ERROR could not get nvs
file: -2"

as you can see from the logs...

/ # insmod file-sys-2.6.39/lib/modules/2.6.39/kernel/net/wireless/cfg80211.ko 
[   18.853088] cfg80211: Calling CRDA to update world regulatory domain
/ # insmod file-sys-2.6.39/lib/modules/2.6.39/kernel/net/mac80211/mac80211.ko 
/ # insmod file-sys-2.6.39/lib/modules/2.6.39/kernel/drivers/net/wireless/wl12xx
/wl12xx.ko 
/ # insmod file-sys-2.6.39/lib/modules/2.6.39/kernel/drivers/net/wireless/wl12xx
/wl12xx_sdio.ko 
[  112.121643] wl1271: ERROR could not get nvs file: -2
[  112.137634] wl1271_sdio mmc1:0001:2: wlan0: Features changed: 0x00004800 ->
0x00004000
[  112.148712] wl1271: loaded
[  112.151550] wl1271: initialized
/ # ifconfig -a
lo        Link encap:Local Loopback  
          LOOPBACK  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

wlan0     Link encap:Ethernet  HWaddr 00:00:00:00:00:00  
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

/ #  ifconfig wlan0 hw ether 00:22:33:44:55:66
/ #  ifconfig wlan0 hw ether 00:22:33:44:55:D1
/ # ifconfig -a
lo        Link encap:Local Loopback  
          LOOPBACK  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

wlan0     Link encap:Ethernet  HWaddr 00:22:33:44:55:D1  
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

/ # ifconfig wlan0 down
/ # ifconfig wlan0 up
[  427.125793] wl1271: ERROR could not get firmware: -2
[  488.123046] wl1271: ERROR could not get firmware: -2


