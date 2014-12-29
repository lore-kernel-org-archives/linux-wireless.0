Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62590 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaL2TRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 14:17:04 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so22897900wib.4
        for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2014 11:17:02 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 29 Dec 2014 14:17:02 -0500
Message-ID: <CAM-0sLw-N1J535xWE=XG-Pn3yi7YBUFhbBKJE0pmEUy9tKDtsA@mail.gmail.com> (sfid-20141229_201711_003109_96AC10CA)
Subject: IBSS or Hostapd, but not both
From: Tuc at Beach House <tuctboh@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Raspberry Pi Model B+, Linux blue 3.12.28+ #709 PREEMPT Mon Sep 8 15:28:00
BST 2014 armv6l GNU/Linux, hostapd v2.3 (defconfig), Ralink using rt2800usb
driver on either a Wi-Pi or Panda Ultra Wireless N USB Adapter.

What I'm trying to accomplish is using a single interface to be an AP on
one SSID, and ad-hoc on another SSID. The problem is that I can either do
one, or the other, but not both...

root@blue:~# iwconfig wlan1
wlan1     IEEE 802.11bgn  ESSID:off/any
          Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on

So if I set up ad-hoc, works fine :

root@blue:~# iw dev wlan1 interface add wlan10 type ibss
root@blue:~# iwconfig wlan10
wlan10    IEEE 802.11bgn  ESSID:off/any
          Mode:Ad-Hoc  Cell: Not-Associated   Tx-Power=0 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on

root@blue:~# iwconfig wlan10 essid WEDDING
root@blue:~# ifconfig wlan10 10.4.4.8 netmask 255.255.255.0
root@blue:~# ping -c2 new
PING new.wedding.ramolaandscott,com (10.4.4.6) 56(84) bytes of data.
64 bytes from new.wedding.ramolaandscott,com (10.4.4.6): icmp_req=1 ttl=64
time=3.51 ms
64 bytes from new.wedding.ramolaandscott,com (10.4.4.6): icmp_req=2 ttl=64
time=1.02 ms

--- new.wedding.ramolaandscott,com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 1.024/2.268/3.512/1.244 ms


Now invoke hostapd with the following /etc/hostapd/hostapd.conf :

root@blue:~# cat /etc/hostapd/hostapd.conf
interface=wlan1
ssid=FREE
hw_mode=g
channel=1
root@blue:~# /usr/local/bin/hostapd -dd /etc/hostapd/hostapd.conf
(Please see http://pastebin.com/cjqukwyH)


But if I reboot and try backwards :

root@blue:~# hostapd -dd /etc/hostapd/hostapd.conf
(Please see http://pastebin.com/Tdc5dz81)


And its fine, but then :

root@blue:~# iw dev wlan1 interface add wlan10 type ibss
root@blue:~# iwconfig wlan10
wlan10    IEEE 802.11bgn  ESSID:off/any
          Mode:Ad-Hoc  Cell: Not-Associated   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on

root@blue:~# iwconfig wlan10 essid WEDDING
root@blue:~# ifconfig wlan10
wlan10    Link encap:Ethernet  HWaddr 00:c1:41:07:07:d1
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

root@blue:~# ifconfig wlan10 10.4.4.8 netmask 255.255.255.0
SIOCSIFFLAGS: Device or resource busy
root@blue:~# ifconfig wlan10
wlan10    Link encap:Ethernet  HWaddr 00:c1:41:07:07:d1
          inet addr:10.4.4.8  Bcast:10.4.4.255  Mask:255.255.255.0
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

root@blue:~# ping -c2 new
PING new.wedding.ramolaandscott,com (10.4.4.6) 56(84) bytes of data.

--- new.wedding.ramolaandscott,com ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 1001ms



Any idea where to look or what to do to get them to work and play together?

Thanks, Tuc
