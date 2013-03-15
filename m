Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49749 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410Ab3CON3t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 09:29:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UGUi0-0001su-T4
	for linux-wireless@vger.kernel.org; Fri, 15 Mar 2013 14:30:08 +0100
Received: from 213.48.13.39 ([213.48.13.39])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2013 14:30:08 +0100
Received: from vishnu.kopparapu by 213.48.13.39 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2013 14:30:08 +0100
To: linux-wireless@vger.kernel.org
From: vishnu <vishnu.kopparapu@gmail.com>
Subject: problem connecting to AP on new kernel (disassociating continuously after associating ) . Can some one please comment on the issue I am facing 
Date: Fri, 15 Mar 2013 13:29:32 +0000 (UTC)
Message-ID: <loom.20130315T140953-940@post.gmane.org> (sfid-20130315_142955_822110_63E16693)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

driver used : rtl8192cu

When I tested with my linux kernel 3.0 , I didn't have any problems connecting 
to AP. But with kernel 3.6.8 , I had a problem . When I tested with 3.7.8 also I 
am facing the same problem. This is the latest kernel used by latest release of 
buildroot , so I didn't test any kernels after that version.

The authentication and association are fine but from some reason it is 
disassociating after that and it keeps repeating it and it never connects to the 
AP.


Mar 15 11:23:04  kernel: [ 1943.421615] cfg80211: Calling CRDA to update world 
regulatory domain
Mar 15 11:23:04  kernel: [ 1943.512963] cfg80211: World regulatory domain 
updated:
Mar 15 11:23:04  kernel: [ 1943.513013] cfg80211:   (start_freq - end_freq @ 
bandwidth), (max_antenna_gain, max_eirp)
Mar 15 11:23:04  kernel: [ 1943.513058] cfg80211:   (2402000 KHz - 2472000 KHz @ 
40000 KHz), (300 mBi, 2000 mBm)
Mar 15 11:23:04  kernel: [ 1943.513102] cfg80211:   (2457000 KHz - 2482000 KHz @ 
20000 KHz), (300 mBi, 2000 mBm)
Mar 15 11:23:04  kernel: [ 1943.513143] cfg80211:   (2474000 KHz - 2494000 KHz @ 
20000 KHz), (300 mBi, 2000 mBm)
Mar 15 11:23:04  kernel: [ 1943.513183] cfg80211:   (5170000 KHz - 5250000 KHz @ 
40000 KHz), (300 mBi, 2000 mBm)
Mar 15 11:23:04  kernel: [ 1943.513221] cfg80211:   (5735000 KHz - 5835000 KHz @ 
40000 KHz), (300 mBi, 2000 mBm)
Mar 15 11:23:05  kernel: [ 1943.557338] rtl8192cu: Chip version 0x11
Mar 15 11:23:07  kernel: [ 1946.035267] rtl8192cu: MAC address: 
00:34:f1:81:00:29
Mar 15 11:23:07  kernel: [ 1946.035283] rtl8192cu: Board Type 0
Mar 15 11:23:07  kernel: [ 1946.042320] rtlwifi: rx_max_size 15360, rx_urb_num 
8, in_ep 1
Mar 15 11:23:07  kernel: [ 1946.042569] rtl8192cu: Loading firmware 
rtlwifi/rtl8192cufw.bin
Mar 15 11:23:07  kernel: [ 1946.043055] ieee80211 phy0: Selected rate control 
algorithm 'rtl_rc'
Mar 15 11:23:07  kernel: [ 1946.052242] usbcore: registered new interface driver 
rtl8192cu 
Mar 15 11:23:07  kernel: [ 1946.056275] rtlwifi: wireless switch is on
Mar 15 11:23:07  kernel: [ 1946.140211] rtl8192cu: MAC auto ON okay!
Mar 15 11:23:08  kernel: [ 1947.229454] rtl8192cu: Tx queue select: 0x05
Mar 15 11:23:10  kernel: [ 1949.153683] IPv6: ADDRCONF(NETDEV_UP): wlan0: link 
is not ready
Mar 15 11:25:32  kernel: [ 2091.089686] wlan0: authenticate with 
00:17:3f:15:8f:55
Mar 15 11:25:32  kernel: [ 2091.292720] wlan0: send auth to 00:17:3f:15:8f:55 
(try 1/3)
Mar 15 11:25:32  kernel: [ 2091.317107] wlan0: authenticated
Mar 15 11:25:32  kernel: [ 2091.317845] rtl8192cu 1-2:1.0 wlan0: disabling HT as 
WMM/QoS is not supported by the AP
Mar 15 11:25:32  kernel: [ 2091.317848] rtl8192cu 1-2:1.0 wlan0: disabling VHT 
as WMM/QoS is not supported by the AP
Mar 15 11:25:32  kernel: [ 2091.321307] wlan0: associate with 00:17:3f:15:8f:55 
(try 1/3)
Mar 15 11:25:32  kernel: [ 2091.342314] wlan0: RX AssocResp from 
00:17:3f:15:8f:55 (capab=0x411 status=0 aid=2)
Mar 15 11:25:32  kernel: [ 2091.345594] wlan0: associated
Mar 15 11:25:32  kernel: [ 2091.346092] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: 
link becomes ready
Mar 15 11:25:42  kernel: [ 2101.346864] wlan0: disassociating from 
00:17:3f:15:8f:55 by local choice (reason=3)
Mar 15 11:25:42  kernel: [ 2101.397208] cfg80211: Calling CRDA to update world 
regulatory domain
Mar 15 11:25:42  kernel: [ 2101.399994] wlan0: deauthenticating from 
00:17:3f:15:8f:55 by local choice (reason=3)
Mar 15 11:25:42  kernel: [ 2101.475451] cfg80211: World regulatory domain 
updated:
Mar 15 11:25:42  kernel: [ 2101.475457] cfg80211:   (start_freq - end_freq @ 
bandwidth), (max_antenna_gain, max_eirp)
Mar 15 11:25:42  kernel: [ 2101.475460] cfg80211:   (2402000 KHz - 2472000 KHz @ 
40000 KHz), (300 mBi, 2000 mBm)
Mar 15 11:25:42  kernel: [ 2101.475462] cfg80211:   (2457000 KHz - 2482000 KHz @ 
20000 KHz), (300 mBi, 2000 mBm)
Mar 15 11:25:42  kernel: [ 2101.475464] cfg80211:   (2474000 KHz - 2494000 KHz @ 
20000 KHz), (300 mBi, 2000 mBm)
Mar 15 11:25:42  kernel: [ 2101.475467] cfg80211:   (5170000 KHz - 5250000 KHz @ 
40000 KHz), (300 mBi, 2000 mBm)
Mar 15 11:25:42  kernel: [ 2101.475469] cfg80211:   (5735000 KHz - 5835000 KHz @ 
40000 KHz), (300 mBi, 2000 mBm)
Mar 15 11:25:44  kernel: [ 2102.720500] wlan0: authenticate with 
00:17:3f:15:8f:55
Mar 15 11:25:44  kernel: [ 2102.862351] wlan0: send auth to 00:17:3f:15:8f:55 
(try 1/3)
Mar 15 11:25:44  kernel: [ 2102.869904] wlan0: authenticated
Mar 15 11:25:44  kernel: [ 2102.870255] rtl8192cu 1-2:1.0 wlan0: disabling HT as 
WMM/QoS is not supported by the AP
Mar 15 11:25:44  kernel: [ 2102.870260] rtl8192cu 1-2:1.0 wlan0: disabling VHT 
as WMM/QoS is not supported by the AP
Mar 15 11:25:44  kernel: [ 2102.872049] wlan0: associate with 00:17:3f:15:8f:55 
(try 1/3)
Mar 15 11:25:44  kernel: [ 2102.875984] wlan0: RX AssocResp from 
00:17:3f:15:8f:55 (capab=0x411 status=0 aid=2)
Mar 15 11:25:44  kernel: [ 2102.879009] wlan0: associated
Mar 15 11:25:54  kernel: [ 2112.881414] wlan0: disassociating from 
00:17:3f:15:8f:55 by local choice (reason=3)






Configuration of wifi client:

modprobe rtl8192cu
wpa_supplicant -g/var/run/wpa_supplicant-global -B
wpa_cli -g/var/run/wpa_supplicant-global interface_add wlan0 "" nl80211 
/var/run/wpa_supplicant
wpa_cli -iwlan0 -a/usr/bin/wifi-action -B

sleep 1
wpa_cli -iwlan0 add_network
wpa_cli -iwlan0 set_network 0 ssid '"belkin54g"'
wpa_cli -iwlan0 set_network 0 key_mgmt WPA-PSK
wpa_cli -iwlan0 set_network 0 proto WPA
wpa_cli -iwlan0 set_network 0 pairwise TKIP
wpa_cli -iwlan0 set_network 0 group TKIP
wpa_cli -iwlan0 set_network 0 psk '"Test123456"'

sleep 1
wpa_cli -iwlan0 enable_network 0


If you need more information , I will be happy to provide. thanks. 


Regards,
Vishnu.



