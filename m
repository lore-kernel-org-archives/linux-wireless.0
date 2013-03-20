Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47931 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933124Ab3CTM4a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 08:56:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UIIZT-0000Ng-EY
	for linux-wireless@vger.kernel.org; Wed, 20 Mar 2013 13:56:47 +0100
Received: from 213.48.13.39 ([213.48.13.39])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 13:56:47 +0100
Received: from vishnu.kopparapu by 213.48.13.39 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 13:56:47 +0100
To: linux-wireless@vger.kernel.org
From: vishnu <vishnu.kopparapu@gmail.com>
Subject: Re: problem connecting to AP on new kernel (disassociating continuously after associating ) . Can some one please comment on the issue I am facing
Date: Wed, 20 Mar 2013 12:56:09 +0000 (UTC)
Message-ID: <loom.20130320T134142-168@post.gmane.org> (sfid-20130320_135633_767003_336EB2C4)
References: <loom.20130315T140953-940@post.gmane.org> <5144A184.1060900@iki.fi> <loom.20130318T191350-236@post.gmane.org> <51475D23.70108@lwfinger.net> <loom.20130319T163402-330@post.gmane.org> <5148AB04.2070003@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> That does not match my system. From the time I plug in my rtl8192cu device 
which 
> is shown by lsusb to be "Bus 001 Device 003: ID 7392:7811 Edimax Technology 
Co., 
> Ltd EW-7811Un 802.11n Wireless Adapter [Realtek RTL8188CUS]", the dmesg output 
> is as follows:
> 
> [47975.929602] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
> [47975.930889] usbcore: registered new interface driver rtl8192cu
> [47975.977981] cfg80211: Ignoring regulatory request Set by core since the 
> driver uses its own custom regulatory domain
> [47975.979893] ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
> [47975.986236] rtlwifi: wireless switch is on
> [47976.821468] rtl8192cu: MAC auto ON okay!
> [47976.899584] rtl8192cu: Tx queue select: 0x05
> [47977.359377] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [47991.649505] wlan1: authenticate with 20:e5:2a:01:f7:ea
> [47991.678097] wlan1: send auth to 20:e5:2a:01:f7:ea (try 1/3)
> [47991.698862] wlan1: authenticated
> [47991.700496] wlan1: associate with 20:e5:2a:01:f7:ea (try 1/3)
> [47991.722112] wlan1: RX AssocResp from 20:e5:2a:01:f7:ea (capab=0x411 
status=0 
> aid=2)
> [47991.724125] wlan1: associated
> [47991.724270] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
> [47991.732272] wlan1: dropped frame to 20:e5:2a:01:f7:ea (unauthorized port)
> 
> As I write this, the system is at 48246.72, and no drops. My AP is a Netgear 
> WNDR3400 running 802.11n with WPA2. What are the details for your AP?
> 
> Larry
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Hello Larry,

I am using Belkin BELKIN F5D7633-4 as AP. It is configured as below
  Security Mode - WPA/WPA2-Personal(PSK)
  Authentication - WPA-PSK + WPA2-PSK
  Encryption   -  TKIP

Configuration to start wifi client :

modprobe rtl8192cu
wpa_supplicant -g/var/run/wpa_supplicant-global -B
wpa_cli -g/var/run/wpa_supplicant-global interface_add wlan0 "" nl80211 
/var/run/wpa_supplicant
wpa_cli -iwlan0 -a/usr/bin/wifi-action -B

wpa_cli -iwlan0 add_network
wpa_cli -iwlan0 set_network 0 ssid '"belkin54g"'
wpa_cli -iwlan0 set_network 0 key_mgmt WPA-PSK
wpa_cli -iwlan0 set_network 0 proto WPA
wpa_cli -iwlan0 set_network 0 pairwise TKIP
wpa_cli -iwlan0 set_network 0 group TKIP
wpa_cli -iwlan0 set_network 0 psk '"Test123456"'
wpa_cli -iwlan0 enable_network 0


Do you see any reason, why it is behaving differently on my system.

Regards,
Vishnu.


