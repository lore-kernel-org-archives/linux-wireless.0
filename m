Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:56184 "EHLO
	spunkymail-a10.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757400AbZEVTU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 15:20:27 -0400
Message-ID: <4A16FAF6.7030403@hiramoto.org>
Date: Fri, 22 May 2009 21:20:22 +0200
From: Karl Hiramoto <karl@hiramoto.org>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k-devel] hostapd not sending beacons, and no traffic.
References: <4A168B8A.4070609@hiramoto.org> <4A16AD12.2020200@hiramoto.org> <4A16C6DC.7070502@hiramoto.org>
In-Reply-To: <4A16C6DC.7070502@hiramoto.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If anyone can help me with this, I'd appreciate it.  I thin the issue may be with the TX, but I'm not sure where 
to look next. I'm willing to test any patches. 

Using wireless-testing from today, but the same occurs on 2.6.30-rc6

I simplified my test case and what fails still is copying from one 
interface to another when routing.   I  now have no bridges.

# ip addr
1: lo: <LOOPBACK,UP,10000> mtu 16436 qdisc noqueue
   link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
   inet 127.0.0.1/8 scope host lo
2: eth1: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast qlen 1000
   link/ether 00:13:01:00:02:18 brd ff:ff:ff:ff:ff:ff
   inet 192.168.10.55/24 brd 192.168.10.255 scope global eth1
3: eth0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast qlen 100
   link/ether 9e:b6:45:72:d7:98 brd ff:ff:ff:ff:ff:ff
4: wmaster0: <UP,10000> mtu 0 qdisc pfifo_fast qlen 1000
   link/ieee802.11 00:0e:8e:15:6e:16 brd 00:00:00:00:00:00
5: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop qlen 1000
   link/ether 00:0e:8e:15:6e:16 brd ff:ff:ff:ff:ff:ff
6: wlan0_0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc cbq qlen 1000
   link/ether 00:0e:8e:15:6e:16 brd ff:ff:ff:ff:ff:ff
   inet 192.168.1.1/24 brd 192.168.1.255 scope global wlan0_0
8: mon.wlan0_0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast 
qlen 1000
   link/[803] 00:0e:8e:15:6e:16 brd ff:ff:ff:ff:ff:ff



# ip route
192.168.1.0/24 dev wlan0_0  proto kernel  scope link  src 192.168.1.1
192.168.10.0/24 dev eth1  proto kernel  scope link  src 192.168.10.55
127.0.0.0/8 dev lo  scope link
default via 192.168.10.254 dev eth1  proto static


Downloading a 40MB file from a http server on eth1 lan   to  wifi client 
on  access point  wlan0_0,     The connection at some point of the http 
file download fails.  Usually I can download at least 300KB of data before the error occurs. 


hostapd.conf:

interface=wlan0_0
driver=nl80211
logger_syslog=-1
logger_syslog_level=2
logger_stdout=0
logger_stdout_level=2
dump_file=/tmp/hostapd/hostapd.0.dump
ssid=karl
channel=1
hw_mode=g
auth_algs=1
macaddr_acl=0
accept_mac_file=/tmp/hostapd/hostapd.wlan0_0.accept
deny_mac_file=/tmp/hostapd/hostapd.wlan0_0.deny
ignore_broadcast_ssid=0
wpa=3
wpa_passphrase=hiramoto
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
ieee8021x=0
eap_server=0


600KB of kernel log messages with modprobe ath9k debug=0xFFFFFFFF
at: http://karl.hiramoto.org/ath9k.txt


Thanks.
--
Karl
