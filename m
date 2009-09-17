Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:33613 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZIQUx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 16:53:27 -0400
Received: by ewy2 with SMTP id 2so779632ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2009 13:53:30 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 17 Sep 2009 22:53:30 +0200
Message-ID: <49eab4770909171353n5f42359cu93e7262e391b58bf@mail.gmail.com>
Subject: problem: iw connect
From: =?ISO-8859-2?B?TWljaGGzIEJvv2Vr?= <mich.bozek@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm a student and I'm currently working on implementation of standard
802.21 which is the subject of my master's thesis. One of the project
modules is responsible for configuration of wireless interface and
basic operations like scanning, association... I decided to use
netlink library as a communication mechanism between kernel and
userspace. Firstly I wanted to try to establish connection using iw
tool, and here I encountered problem.

I installed:
+ iw 0.9.17
+ libnl 2.0
+ newest kernel (2.6.31-39-pae)

I typed:
+ ifconfig wlan0 up
+ iw wlan0 scan -> works properly, I discovered my wireless network
+ iw wlan0 connect xxxx -> error: command failed: Operation not supported (-95)

I received same error when I had older kernel (2.6.27.7-9) and I tried
scanning (iw wlan0 scan) so it looks like my kernel does not support
operation connect but I've got the newest one and as far as I know it
supports connecting/disconnecting.

It cannot be caused by some hardware malfunction because while using
w-ext I can connect to my AP without any problems.

Some info, perhaps something will be useful:

# uname -a
Linux linux-etd0 2.6.31-39-pae #1 SMP Thu Sep 17 20:29:31 CEST 2009
i686 i686 i386 GNU/Linux

# lspci -vnn | grep 14e4
02:0e.0 Ethernet controller [0200]: Broadcom Corporation BCM4401-B0
100Base-TX [14e4:170c] (rev 02)
10:00.0 Network controller [0280]: Broadcom Corporation BCM4311
802.11b/g WLAN [14e4:4311] (rev 01)

# lsmod | grep 80211
mac80211              208792  1 b43
cfg80211              105120  2 b43,mac80211
rfkill                 22548  2 cfg80211,bluetooth

# modinfo cfg80211
filename:       /lib/modules/2.6.31-39-pae/kernel/net/wireless/cfg80211.ko
description:    wireless configuration support
license:        GPL
author:         Johannes Berg
srcversion:     34A03B9852D93D21805D1BA
depends:        rfkill
vermagic:       2.6.31-39-pae SMP mod_unload modversions 686
parm:           ieee80211_regdom:IEEE 802.11 regulatory domain code (charp)

# modinfo mac80211
filename:       /lib/modules/2.6.31-39-pae/kernel/net/mac80211/mac80211.ko
license:        GPL
description:    IEEE 802.11 subsystem
srcversion:     1CA4235209A74C4FA4CCF94
depends:        cfg80211
vermagic:       2.6.31-39-pae SMP mod_unload modversions 686
parm:           ieee80211_default_rc_algo:Default rate control
algorithm for mac80211 to use (charp)

# iw wlan0 info
Interface wlan0
        ifindex 4
        type managed

# iw phy0 info
Wiphy phy0
        Band 1:
                Frequencies:
                        * 2412 MHz [1] (20.0 dBm)
                        * 2417 MHz [2] (20.0 dBm)
                        * 2422 MHz [3] (20.0 dBm)
                        * 2427 MHz [4] (20.0 dBm)
                        * 2432 MHz [5] (20.0 dBm)
                        * 2437 MHz [6] (20.0 dBm)
                        * 2442 MHz [7] (20.0 dBm)
                        * 2447 MHz [8] (20.0 dBm)
                        * 2452 MHz [9] (20.0 dBm)
                        * 2457 MHz [10] (20.0 dBm)
                        * 2462 MHz [11] (20.0 dBm)
                        * 2467 MHz [12] (20.0 dBm) (passive scanning, no IBSS)
                        * 2472 MHz [13] (20.0 dBm) (passive scanning, no IBSS)
                        * 2484 MHz [14] (20.0 dBm) (passive scanning, no IBSS)
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps (short preamble supported)
                        * 5.5 Mbps (short preamble supported)
                        * 11.0 Mbps (short preamble supported)
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 4
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * WDS
                 * monitor
                 * mesh point

# ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:14:A5:AF:AC:C6
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

# iwconfig wlan0
wlan0     IEEE 802.11bg  ESSID:""
          Mode:Managed  Frequency:2.462 GHz  Access Point: Not-Associated
          Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


I would greatly appreciate any tip how to solve the problem or what
can be the cause of it.

Thanks,

Michał Bożek
