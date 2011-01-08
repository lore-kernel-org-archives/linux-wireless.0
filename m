Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:40980 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751697Ab1AHMif (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jan 2011 07:38:35 -0500
Message-ID: <4D2850B8.7080107@gmx.net>
Date: Sat, 08 Jan 2011 12:55:36 +0100
From: Andre Kuehne <andre.kuehne@gmx.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: hwcrypt issue with rt73usb
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I use a USB WLAN Stick (model: TP-LINK TL-WN321G) with hostapd.
With kernel26-2.6.36 this setup is not working anymore.
The interface is up and if I try to connect with another client
WPA handshake also seems to work, but the IP configuration via DHCP fails.

After downgrading to kernel26-2.6.35 the connection works fine again.

On #linux-wireless it was suggested to test with nohwcrypt and indeed after

     modprobe rt73usb nohwcrypt=1

the connection worked fine again under kernel26-2.6.36.

 > lsusb
...
Bus 001 Device 003: ID 148f:2573 Ralink Technology, Corp. RT2501/RT2573 Wireless Adapter
...

 > lsmod
...
rt73usb 21779 0
rt2500usb 17334 0
rt2x00usb 7597 2 rt73usb,rt2500usb
rt2x00lib 25013 3 rt73usb,rt2500usb,rt2x00usb
mac80211 189270 2 rt2x00usb,rt2x00lib
cfg80211 144231 2 rt2x00lib,mac80211
...

 > cat /etc/hostapd/hostapd.conf
...
interface=wlan0
bridge=br0
driver=nl80211
country_code=DE
ieee80211d=1
hw_mode=g
beacon_int=100
dtim_period=2
max_num_sta=255
rts_threshold=2347
fragm_threshold=2346
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
...

 > grep hostap /var/log/messages.log
... authenticated
... associated (aid 1)
... RADIUS: starting accounting session 4CFD0763-000001A0
... WPA: pairwise key handshake completed (RSN)
...

Please let me know if you are interested in more details or if I could otherwise help in testing etc.

Best regards
Andre
