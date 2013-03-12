Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60622 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab3CLNTr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:19:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UFP7c-0007Fo-TL
	for linux-wireless@vger.kernel.org; Tue, 12 Mar 2013 14:20:04 +0100
Received: from 213.48.13.39 ([213.48.13.39])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 14:20:04 +0100
Received: from vishnu.kopparapu by 213.48.13.39 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 14:20:04 +0100
To: linux-wireless@vger.kernel.org
From: vishnu <vishnu.kopparapu@gmail.com>
Subject: Problems connecting to AP 
Date: Tue, 12 Mar 2013 13:14:03 +0000 (UTC)
Message-ID: <loom.20130312T135822-902@post.gmane.org> (sfid-20130312_141951_612952_47A047F7)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP used : BELKIN F5D7633-4
AP Security configuration:
  Security Mode - WPA/WPA2-Personal(PSK)
  Authentication - WPA-PSK + WPA2-PSK
  Encryption   -  TKIP


Wifi client Host System details: 
Linux (kernel version 3.6.8)
ARM

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


log after executing above configuration:

# wpa_cli -iwlan0 enable_network 0
OK
# wlan0: authenticate with 00:17:3f:15:8f:55
wlan0: send auth to 00:17:3f:15:8f:55 (try 1/3)
wlan0: authenticated
rtl8192cu 1-1:1.0: wlan0: disabling HT due to WEP/TKIP use
rtl8192cu 1-1:1.0: wlan0: disabling HT as WMM/QoS is not supported
wlan0: associate with 00:17:3f:15:8f:55 (try 1/3)
wlan0: RX AssocResp from 00:17:3f:15:8f:55 (capab=0x411 status=0 aid=1)
wlan0: associated
IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: dropped frame to 00:17:3f:15:8f:55 (unauthorized port)
wlan0: dropped frame to 00:17:3f:15:8f:55 (unauthorized port)
wlan0: dropped frame to 00:17:3f:15:8f:55 (unauthorized port)
wlan0: dropped frame to 00:17:3f:15:8f:55 (unauthorized port)
wlan0: dropped frame to 00:17:3f:15:8f:55 (unauthorized port)
wlan0: dropped frame to 00:17:3f:15:8f:55 (unauthorized port)
wlan0: disassociating from 00:17:3f:15:8f:55 by local choice (reason=3)
cfg80211: Calling CRDA for country: US
wlan0: deauthenticating from 00:17:3f:15:8f:55 by local choice (reason=3)
wlan0: authenticate with 00:17:3f:15:8f:55
wlan0: send auth to 00:17:3f:15:8f:55 (try 1/3)
wlan0: authenticated
rtl8192cu 1-1:1.0: wlan0: disabling HT due to WEP/TKIP use
rtl8192cu 1-1:1.0: wlan0: disabling HT as WMM/QoS is not supported
wlan0: associate with 00:17:3f:15:8f:55 (try 1/3)
wlan0: RX AssocResp from 00:17:3f:15:8f:55 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociating from 00:17:3f:15:8f:55 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: deauthenticating from 00:17:3f:15:8f:55 by local choice (reason=3)
wlan0: authenticate with 00:17:3f:15:8f:55
wlan0: send auth to 00:17:3f:15:8f:55 (try 1/3)
wlan0: authenticated
rtl8192cu 1-1:1.0: wlan0: disabling HT due to WEP/TKIP use
rtl8192cu 1-1:1.0: wlan0: disabling HT as WMM/QoS is not supported
wlan0: associate with 00:17:3f:15:8f:55 (try 1/3)
wlan0: RX AssocResp from 00:17:3f:15:8f:55 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociating from 00:17:3f:15:8f:55 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: deauthenticating from 00:17:3f:15:8f:55 by local choice (reason=3)
wlan0: authenticate with 00:17:3f:15:8f:55
wlan0: send auth to 00:17:3f:15:8f:55 (try 1/3)
wlan0: authenticated
rtl8192cu 1-1:1.0: wlan0: disabling HT due to WEP/TKIP use
rtl8192cu 1-1:1.0: wlan0: disabling HT as WMM/QoS is not supported
wlan0: associate with 00:17:3f:15:8f:55 (try 1/3)
wlan0: RX AssocResp from 00:17:3f:15:8f:55 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociating from 00:17:3f:15:8f:55 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: deauthenticating from 00:17:3f:15:8f:55 by local choice (reason=3)
wlan0: authenticate with 00:17:3f:15:8f:55
wlan0: send auth to 00:17:3f:15:8f:55 (try 1/3)
wlan0: authenticated
rtl8192cu 1-1:1.0: wlan0: disabling HT due to WEP/TKIP use
rtl8192cu 1-1:1.0: wlan0: disabling HT as WMM/QoS is not supported
wlan0: associate with 00:17:3f:15:8f:55 (try 1/3)
wlan0: RX AssocResp from 00:17:3f:15:8f:55 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociating from 00:17:3f:15:8f:55 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: deauthenticating from 00:17:3f:15:8f:55 by local choice (reason=3)
wlan0: authenticate with 00:17:3f:15:8f:55
wlan0: send auth to 00:17:3f:15:8f:55 (try 1/3)
wlan0: authenticated



The same configuration on Linux ( kernel version 3.0.0 on X86 platform) is 
working fine and connection to the AP. 

Any information on why this is happening or how to fix will be useful. 

Thanks,
Vishnu.









