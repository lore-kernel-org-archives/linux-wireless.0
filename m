Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:46756 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0LQFMB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 00:12:01 -0500
Message-ID: <E680F3C4CE6F415E95DCBDA48F0158FC@MINX0125717>
From: "panduranga" <x0125717@ti.com>
To: "Elvis Dowson" <elvis.dowson@mac.com>,
	"Ohad Ben-Cohen" <ohad@wizery.com>
Cc: "Linux Wireless Mailing List" <linux-wireless@vger.kernel.org>,
	"Jara, Pedro" <pedrojara@ti.com>
References: <57CB308D-7237-46D7-9AF8-7093F52682E8@mac.com> <AANLkTikESPwcaxUSDd3B=Oh7kBD-QpndKRHmu9-roDqs@mail.gmail.com> <C77CCCD3-2467-4363-A513-05B68B9F57F6@mac.com>
Subject: Re: Problem bringing up wlan0 interface up with mainline wl1271 drivers
Date: Fri, 17 Dec 2010 10:41:46 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Elvis,

This because you havent set the mac address for wlan0

wlan0     Link encap:Ethernet  HWaddr 00:00:00:00:00:00

You can do by using the following command:
ifconfig wlan0 hw ether 11:22:33:44:55:66

OR

add the following patch 
(http://www.spinics.net/lists/linux-wireless/msg59391.html) by Arik Nemtsov.

diff --git a/drivers/net/wireless/wl12xx/main.c 
b/drivers/net/wireless/wl12xx/main.c
index 708b699..e5fbbb6 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2987,6 +2987,18 @@ int wl1271_register_hw(struct wl1271 *wl)
 	if (wl->mac80211_registered)
 		return 0;

+	ret = wl1271_fetch_nvs(wl);
+	if (ret == 0) {
+		u8 *nvs_ptr = (u8 *)wl->nvs->nvs;
+
+		wl->mac_addr[0] = nvs_ptr[11];
+		wl->mac_addr[1] = nvs_ptr[10];
+		wl->mac_addr[2] = nvs_ptr[6];
+		wl->mac_addr[3] = nvs_ptr[5];
+		wl->mac_addr[4] = nvs_ptr[4];
+		wl->mac_addr[5] = nvs_ptr[3];
+	}
+
 	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);

 	ret = ieee80211_register_hw(wl->hw);
-- 

Regards,
Pandu.

----- Original Message ----- 
From: "Elvis Dowson" <elvis.dowson@mac.com>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Cc: "Linux Wireless Mailing List" <linux-wireless@vger.kernel.org>; 
"Mallireddy, Panduranga" <x0125717@ti.com>; "Jara, Pedro" <pedrojara@ti.com>
Sent: Friday, December 17, 2010 5:53 AM
Subject: Problem bringing up wlan0 interface up with mainline wl1271 drivers


Hi,

On Dec 12, 2010, at 1:24 AM, Ohad Ben-Cohen wrote:

>> When I build the TI WiLink drivers from the ti rowboat hardware/ti/wlan 
>> project
>
> The linux-omap community can help you with mainline drivers, but no so
> much with proprietary ones. Why don't you use the upstream wl12xx
> driver ?

I've built linux kernel 2.6.37-rc6, and patched board-omap3beagle.c to 
interface with MMC2 SDIO controller,
but I'm unable to bring the wlan0 interface up.

Here are the messages during kernel boot:

[    0.000000] wlan_mux_init: Configuring mux settings for wl1271 wlan 
module
[    0.077117] regulator: vwl1271: 1850 mV normal standby
[    2.171813] mmc1: mmc_rescan: trying to init card at 400000 Hz
[    2.323120] mmc1: card claims to support voltages below the defined 
range. These will be ignored.
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

