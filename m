Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:36645 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1C1G7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 02:59:48 -0400
Message-ID: <4D903114.2090905@pardus.org.tr>
Date: Mon, 28 Mar 2011 09:56:20 +0300
From: =?ISO-8859-9?Q?Ozan_=C7a=F0layan?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Linksys WUSB600N v2 with rt2x00 driver doesn't work
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The mentioned dongle's vendor&product id is added to the rt2800usb 
driver with the following commit:

commit 5e31258945f60dff65952575625cac214a75893e
Author: Gertjan van Wingerde <gwingerde@gmail.com>
Date:   Wed Dec 23 00:03:21 2009 +0100

     rt2x00: Add USB ID for Linksys WUSB 600N rev 2.

     This is a rt2870 based device.

     Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
     Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
     Signed-off-by: John W. Linville <linville@tuxdriver.com>

On 2.6.37.5 with compat-wireless 2.6.38.3, the driver gets loaded, the 
interface wlan0 is created but no scan results is returned. These are 
what logged in dmesg after plugging the device:

[336770.008134] usb 2-3: new high speed USB device using ehci_hcd and 
address 6
[336770.154067] usb 2-3: New USB device found, idVendor=1737, idProduct=0079
[336770.154071] usb 2-3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[336770.154075] usb 2-3: Product: Linksys WUSB600N Wireless-N USB 
Network Adapter with Dual-Band ver. 2
[336770.154078] usb 2-3: Manufacturer: Linksys
[336770.156447] usbip 2-3:1.0: this device 2-3 is not in match_busid 
table. skip!
[336770.171767] ieee80211 phy2: Selected rate control algorithm 
'minstrel_ht'
[336770.172614] Registered led device: rt2800usb-phy2::radio
[336770.172653] Registered led device: rt2800usb-phy2::assoc
[336770.172734] Registered led device: rt2800usb-phy2::quality
[336770.900090] ADDRCONF(NETDEV_UP): wlan0: link is not ready

ozanDesktopI7x86_64 rt2x00 # ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 68:7F:74:F5:E8:1A
           UP BROADCAST MULTICAST  MTU:1500  Metric:1
           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

ozanDesktopI7x86_64 rt2x00 # rfkill list
2: phy2: Wireless LAN
         Soft blocked: no
         Hard blocked: no

