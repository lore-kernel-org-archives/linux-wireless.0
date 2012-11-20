Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49181 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab2KTNCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 08:02:47 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2379530eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 05:02:46 -0800 (PST)
From: "Walter Robert Ditzler" <ditwal001@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: ap
Date: Tue, 20 Nov 2012 14:02:41 +0100
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAOJK0u4CH31Kl5v1RPAzyrZCgQAAEAAAAK0684NI5KVMj9apXTFW10wBAAAAAA==@gmail.com> (sfid-20121120_140251_363384_E197E2DD)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi there,

after adrian chadd helped me to get 5ghz running (radio turn on) on debian
6-0-6,

***
aptitude install wireless-regdb crda :)
***

i run into a other problem. i try to install a dual band ap with hostapd but
it doesnt start on runtime. below my config's. when i start it manually it
works (console). does anyone have a brief hint on that?

is there maybe another way to get a multi band ap working without using
hostapd?

thanks a lot,

walter.




i use:
***
alix2d2 board, cf 4gb, debian 6-0-6, kernel 3-6-5, ubiquiti ub-5 wifi card
(ath5k), compex WLM200NX (ath9k) 
***


*** my network startup script
rm -f /etc/udev/rules.d/*.rules

ifconfig        eth0    down
ifconfig        wlan0   down
ifconfig        wlan1   down
ifconfig        mesh0   down
ifconfig        bat0    down
ifconfig        br0     down

brctl           delbr   br0
batctl          if del  mesh0

iw dev wlan0            del
iw dev wlan1            del
iw dev mesh0            del
iw dev mon.wlan0        del
iw dev mon.wlan1        del

iw phy phy0 interface add mesh0 type adhoc
ifconfig mesh0 mtu 1528
iwconfig mesh0 mode ad-hoc essid abbeoo_mesh ap xx:xx:xx:xx:xx:xx channel
165
batctl if add mesh0
ifconfig mesh0 0.0.0.0 up

iw phy phy1 interface add wlan1 type adhoc

brctl addbr br0
brctl addif br0 eth0
brctl addif br0 bat0

ifconfig bat0 0.0.0.0 up
ifconfig eth0 0.0.0.0 up
ifconfig br0 0.0.0.0 up

dhclient br0

/etc/init.d/hostapd restart

brctl addif br0 wlan1

exit 0;
***


*** /etc/default/hostapd
RUN_DAEMON="yes"
DAEMON_CONF="/etc/abbeoo/abo_cfghostapd24 /etc/abbeoo/abo_cfghostapd50"
DAEMON_OPTS="-dd"
***

*** /etc/abbeoo/abo_cfghostapd24
interface=wlan1
bridge=br0
driver=nl80211
ssid=abbeoo_c
hw_mode=g
channel=10
country_code=CH
***

*** /etc/abbeoo/abo_cfghostapd50
interface=wlan1
bridge=br0
driver=nl80211
country_code=CH
ssid=abbeoo_cc
hw_mode=a
channel=48
***

*** ifconfig
root@srv-ldeb-mesh01:/etc/abbeoo# ifconfig
bat0      Link encap:Ethernet  HWaddr xx:xx:xx:xx:xx:xx
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:13656 errors:0 dropped:6709 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:1285777 (1.2 MiB)

br0       Link encap:Ethernet  HWaddr xx:xx:xx:xx:xx:xx
          inet addr:10.41.20.151  Bcast:10.41.21.255  Mask:255.255.254.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:21127 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1248 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:1799124 (1.7 MiB)  TX bytes:305156 (298.0 KiB)

eth0      Link encap:Ethernet  HWaddr xx:xx:xx:xx:xx:xx
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:27294 errors:0 dropped:223 overruns:0 frame:0
          TX packets:1481 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:2967463 (2.8 MiB)  TX bytes:406176 (396.6 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:8 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:560 (560.0 B)  TX bytes:560 (560.0 B)

mesh0     Link encap:Ethernet  HWaddr xx:xx:xx:xx:xx:xx
          UP BROADCAST RUNNING MULTICAST  MTU:1528  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:54364 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:6510597 (6.2 MiB)

root@srv-ldeb-mesh01:/etc/abbeoo#
***

*** iwconfig
root@srv-ldeb-mesh01:/etc/abbeoo# iwconfig
ip_vti0   no wireless extensions.

gre0      no wireless extensions.

br0       no wireless extensions.

bat0      no wireless extensions.

lo        no wireless extensions.

eth0      no wireless extensions.

eth1      no wireless extensions.

wlan1     IEEE 802.11abgn  ESSID:off/any
          Mode:Ad-Hoc  Cell: Not-Associated   Tx-Power=0 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on

mesh0     IEEE 802.11a  ESSID:"abbeoo_mesh"
          Mode:Ad-Hoc  Frequency:5.825 GHz  Cell: xx:xx:xx:xx:xx:xx
          Tx-Power=30 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on

tunl0     no wireless extensions.

root@srv-ldeb-mesh01:/etc/abbeoo#
***




