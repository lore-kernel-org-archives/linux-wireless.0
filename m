Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nsp.dat.demokritos.gr ([143.233.247.10]:53569 "EHLO
	nsp.dat.demokritos.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYHHPFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 11:05:12 -0400
Received: from orion.ozo.com (orion.ozo.com [212.70.193.242])
	by nsp.dat.demokritos.gr (8.13.1/8.13.1) with SMTP id m78DnY2V000550
	for <linux-wireless@vger.kernel.org>; Fri, 8 Aug 2008 16:49:34 +0300
Message-ID: <489C5B6C.4030108@ozo.com> (sfid-20080808_170525_667461_87CB61DD)
Date: Fri, 08 Aug 2008 17:42:52 +0300
From: "Alexandros C. Couloumbis" <alex@ozo.com>
MIME-Version: 1.0
To: ath9k-devel@venema.h4ckr.net
CC: linux-wireless@vger.kernel.org
Subject: ath9k<-->ath9k ad-hoc does not associate
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings,

I am using an openwrt-x86 trunk 12244 image with linux-2.6.26.2,
compiled with gcc-4.2.2, compat-wireless-2008-08-06 from:
http://www.orbit-lab.org/kernel/compat-wireless-2.6/2008/08/compat-wireless-2008-08-06.tar.bz2
and ath9k commit c3785ea5f6f61095a3cffa8c688d9aae171abb83

The hardware used is: alix & wrap boards along with a pair of
 Unex DNMA-83 (Atheros 9160) wifi cards.

the mac80211 is compiled with all debug options enabled.
frame dumping is not enabled though. also timing info is
enabled on kernel debug.

the wifi cards are not able to ping one another.  here is some
output:

iwconfig, ifconfig & iwlist wlan0 scan from the wrap board:

wlan0     IEEE 802.11abgn  ESSID:"awmn"
          Mode:Ad-Hoc  Frequency:5.745 GHz  Cell: 0E:18:12:1E:75:73
          Tx-Power=23 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

wlan0     Link encap:Ethernet  HWaddr 00:0B:6B:B0:21:B8
          inet addr:192.168.100.1  Bcast:192.168.100.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

wmaster0  Link encap:UNSPEC  HWaddr 
00-0B-6B-B0-21-B8-00-00-00-00-00-00-00-00-00-00
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

wlan0     Scan completed :
          Cell 01 - Address: E6:FE:0E:A1:77:22
                    ESSID:"awmn"
                    Mode:Ad-Hoc
                    Channel:149
                    Frequency:5.745 GHz (Channel 149)
                    Quality=17/100  Signal level:-84 dBm  Noise 
level=-95 dBm
                    Encryption key:off
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
                              36 Mb/s; 48 Mb/s; 54 Mb/s
                    Extra:tsf=000005ffca03c65c
                    Extra: Last beacon: 370ms ago

iwconfig, ifconfig & iwlist wlan0 scan on the alix board:

wlan0     IEEE 802.11abgn  ESSID:"awmn"
          Mode:Ad-Hoc  Frequency:5.745 GHz  Cell: E6:FE:0E:A1:77:22
          Tx-Power=23 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

wlan0     Link encap:Ethernet  HWaddr 00:0B:6B:B0:21:FA
          inet addr:192.168.100.2  Bcast:192.168.100.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:180 (180.0 B)

wmaster0  Link encap:UNSPEC  HWaddr 
00-0B-6B-B0-21-FA-00-00-00-00-00-00-00-00-00-00
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

wlan0     Link encap:Ethernet  HWaddr 00:0B:6B:B0:21:FA
          inet addr:192.168.100.2  Bcast:192.168.100.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:180 (180.0 B)

wmaster0  Link encap:UNSPEC  HWaddr 
00-0B-6B-B0-21-FA-00-00-00-00-00-00-00-00-00-00
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)



dmesg on the wrap side is filled with:

[ 1504.350024] RX beacon SA=00:0b:6b:b0:21:fa BSSID=0e:18:12:1e:75:73 
TSF=0x11d4b13007e3e5 BCN=0x11d4b130076345 diff=32928 @120435
[ 1504.459005] RX beacon SA=00:0b:6b:b0:21:fa BSSID=0e:18:12:1e:75:73 
TSF=0x11d4b13008f3ea BCN=0x11d4b13008f34b diff=159 @120445
[ 1504.560161] RX beacon SA=00:0b:6b:b0:21:fa BSSID=0e:18:12:1e:75:73 
TSF=0x11d4b1300a83e6 BCN=0x11d4b1300a8346 diff=160 @120455
[ 1504.660023] RX beacon SA=00:0b:6b:b0:21:fa BSSID=0e:18:12:1e:75:73 
TSF=0x11d4b1300f93ed BCN=0x11d4b1300c134c diff=229537 @120466
[ 1504.766188] RX beacon SA=00:0b:6b:b0:21:fa BSSID=0e:18:12:1e:75:73 
TSF=0x11d4b1300da3e5 BCN=0x11d4b1300da345 diff=160 @120476
[ 1504.868558] RX beacon SA=00:0b:6b:b0:21:fa BSSID=0e:18:12:1e:75:73 
TSF=0x11d4b1300fb3eb BCN=0x11d4b1300f334b diff=32928 @120486

dmesg on the alix side:

[ 1614.667845] phy0: HW CONFIG: freq=5825
[ 1614.727853] phy0: HW CONFIG: freq=5745
[ 1614.735100] wlan0: sta_find_ibss (active_ibss=0)
[ 1614.735131]    bssid=e6:fe:0e:a1:77:22 found
[ 1614.735154]    bssid=0e:18:12:1e:75:73 found
[ 1614.735193]    sta_find_ibss: selected 0e:18:12:1e:75:73 current 
e6:fe:0e:a1:77:22
[ 1614.735226] wlan0: Selected IBSS BSSID 0e:18:12:1e:75:73 based on 
configured SSID
[ 1614.735297] phy0: HW CONFIG: freq=5745
[ 1644.738301] wlan0: No active IBSS STAs - trying to scan for other 
IBSS networks with same SSID (merge)
[ 1644.768298] phy0: HW CONFIG: freq=2412
[ 1644.828298] phy0: HW CONFIG: freq=2417
[ 1644.888299] phy0: HW CONFIG: freq=2422
[ 1644.948299] phy0: HW CONFIG: freq=2427
[ 1645.008303] phy0: HW CONFIG: freq=2432
[ 1645.068305] phy0: HW CONFIG: freq=2437
[ 1645.128303] phy0: HW CONFIG: freq=2442
[ 1645.188303] phy0: HW CONFIG: freq=2447
[ 1645.248306] phy0: HW CONFIG: freq=2452
[ 1645.308305] phy0: HW CONFIG: freq=2457
[ 1645.368304] phy0: HW CONFIG: freq=2462
[ 1645.428306] phy0: HW CONFIG: freq=5180
[ 1645.488308] phy0: HW CONFIG: freq=5200
[ 1645.548307] phy0: HW CONFIG: freq=5220
[ 1645.608313] phy0: HW CONFIG: freq=5240
[ 1645.668321] phy0: HW CONFIG: freq=5745
[ 1645.699752] phy0: Adding new IBSS station 00:0b:6b:b0:21:b8 (dev=wlan0)
[ 1645.699799] phy0: Allocated STA 00:0b:6b:b0:21:b8
[ 1645.699869] phy0: Inserted STA 00:0b:6b:b0:21:b8
[ 1645.728313] phy0: HW CONFIG: freq=5765
[ 1645.788314] phy0: HW CONFIG: freq=5785
[ 1645.848316] phy0: HW CONFIG: freq=5805
[ 1645.908316] phy0: HW CONFIG: freq=5825
[ 1645.968324] phy0: HW CONFIG: freq=5745
[ 1645.975576] wlan0: sta_find_ibss (active_ibss=0)
[ 1645.975606]    bssid=e6:fe:0e:a1:77:22 found
[ 1645.975645]    sta_find_ibss: selected e6:fe:0e:a1:77:22 current 
0e:18:12:1e:75:73
[ 1645.975678] wlan0: Selected IBSS BSSID e6:fe:0e:a1:77:22 based on 
configured SSID
[ 1645.975769] phy0: Removed STA 00:0b:6b:b0:21:b8
[ 1645.975864] phy0: HW CONFIG: freq=5745
[ 1645.984326] phy0: Destroyed STA 00:0b:6b:b0:21:b8

I would be happy to provide any further output if necessary.

best regards,

--
Alexandros C. Couloumbis
http://dev.ozo.com/
