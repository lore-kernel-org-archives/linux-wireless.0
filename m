Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173001pub.verizon.net ([206.46.173.1]:51306 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbZAWBlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 20:41:37 -0500
Received: from depotrd.localnet ([96.237.24.228]) by vms173001.mailsrvcs.net
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 with ESMTPA id <0KDW0066XI1BVAN9@vms173001.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Thu, 22 Jan 2009 19:41:36 -0600 (CST)
Date: Wed, 21 Jan 2009 21:58:13 -0500
From: Glenn Burkhardt <gbburkhardt@verizon.net>
Subject: Re: poor performance with ath5k; reverting to ath_pci
In-reply-to: <b6c5339f0901160733u433b1154sfb8b5662c4fe991c@mail.gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
Message-id: <200901212158.13854.gbburkhardt@verizon.net> (sfid-20090123_024143_368230_5C2913BC)
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
References: <200901140003.31693.gbburkhardt@verizon.net>
 <200901151734.46144.gbburkhardt@verizon.net>
 <b6c5339f0901160733u433b1154sfb8b5662c4fe991c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 January 2009 10:33:13 Bob Copeland wrote:
> On Thu, Jan 15, 2009 at 5:34 PM, Glenn Burkhardt
>
> <gbburkhardt@verizon.net> wrote:
> > ath5k_pci 0000:00:07.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> > ath5k_pci 0000:00:07.0: registered as 'phy0'
> > phy0: Selected rate control algorithm 'pid'
>
> Can you change the rate control algorithm to minstrel and retry?

I'll have to say that performance is worse with minstrel than pid rate 
control.  I used Channel 2 on the router, and:

ath_pci:
DepotRd:/home/gbb-suse/wireless # ping 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=5.82 ms
64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=1.32 ms
64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=0.967 ms
64 bytes from 192.168.2.1: icmp_seq=4 ttl=64 time=0.954 ms
64 bytes from 192.168.2.1: icmp_seq=5 ttl=64 time=0.970 ms
64 bytes from 192.168.2.1: icmp_seq=6 ttl=64 time=1.14 ms
64 bytes from 192.168.2.1: icmp_seq=7 ttl=64 time=1.32 ms
64 bytes from 192.168.2.1: icmp_seq=8 ttl=64 time=0.981 ms
64 bytes from 192.168.2.1: icmp_seq=9 ttl=64 time=0.961 ms
64 bytes from 192.168.2.1: icmp_seq=10 ttl=64 time=3.88 ms
64 bytes from 192.168.2.1: icmp_seq=11 ttl=64 time=0.962 ms
64 bytes from 192.168.2.1: icmp_seq=12 ttl=64 time=0.894 ms
64 bytes from 192.168.2.1: icmp_seq=13 ttl=64 time=0.991 ms
64 bytes from 192.168.2.1: icmp_seq=14 ttl=64 time=0.968 ms
64 bytes from 192.168.2.1: icmp_seq=15 ttl=64 time=0.978 ms
64 bytes from 192.168.2.1: icmp_seq=16 ttl=64 time=1.10 ms
64 bytes from 192.168.2.1: icmp_seq=17 ttl=64 time=0.999 ms
64 bytes from 192.168.2.1: icmp_seq=18 ttl=64 time=0.998 ms
DepotRd:/home/gbb-suse/wireless # iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wifi0     no wireless extensions.

ath0      IEEE 802.11g  ESSID:"Belkin_N_Wireless_A99331"  
          Mode:Managed  Frequency:2.417 GHz  Access Point: 00:1C:DF:A9:93:31   
          Bit Rate:36 Mb/s   Tx-Power:15 dBm   Sensitivity=1/1  
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:FA2D-087E-61EF-D860-2E7D-46C9-AF65-CA4C   Security 
mode:restricted
          Power Management:off
          Link Quality=37/70  Signal level=-59 dBm  Noise level=-96 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


ath5k with pid:

DepotRd:/home/gbb-suse/linux-2.6.28.1 # ping 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=1729 ms
64 bytes from 192.168.2.1: icmp_seq=5 ttl=64 time=2320 ms
64 bytes from 192.168.2.1: icmp_seq=6 ttl=64 time=2050 ms
64 bytes from 192.168.2.1: icmp_seq=8 ttl=64 time=1402 ms
64 bytes from 192.168.2.1: icmp_seq=9 ttl=64 time=1323 ms
64 bytes from 192.168.2.1: icmp_seq=11 ttl=64 time=1151 ms
64 bytes from 192.168.2.1: icmp_seq=13 ttl=64 time=608 ms
64 bytes from 192.168.2.1: icmp_seq=14 ttl=64 time=1134 ms
64 bytes from 192.168.2.1: icmp_seq=15 ttl=64 time=1100 ms
64 bytes from 192.168.2.1: icmp_seq=16 ttl=64 time=356 ms
64 bytes from 192.168.2.1: icmp_seq=17 ttl=64 time=164 ms
64 bytes from 192.168.2.1: icmp_seq=18 ttl=64 time=423 ms
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=20 ttl=64 time=407 ms
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=23 ttl=64 time=1086 ms
64 bytes from 192.168.2.1: icmp_seq=24 ttl=64 time=1442 ms
DepotRd:~ # iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:"Belkin_N_Wireless_A99331"  
          Mode:Managed  Frequency:2.417 GHz  Access Point: 00:1C:DF:A9:93:31   
          Bit Rate=54 Mb/s   Tx-Power=27 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
          Encryption key:E854-5075-1208-1225-D46B-46E6-CB2C-B627-DA3D-788E-
F50E-7351-DDE0-C111-E9A5-1FB7 [2]   Security mode:open
          Power Management:off
          Link Quality=53/100  Signal level:-69 dBm  Noise level=-103 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0



ath5k with minstrel

dmesg | egrep 'ath|phy'
BIOS-provided physical RAM map:
  Setting physnode_map array to node 0 for pfns:
ath5k_pci 0000:00:07.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ath5k_pci 0000:00:07.0: registered as 'phy0'
phy0: Selected rate control algorithm 'minstrel'
ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy0: RF2112B 2GHz radio found (0x46)

DepotRd:# ping 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=13159 ms
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=8 ttl=64 time=40968 ms
64 bytes from 192.168.2.1: icmp_seq=10 ttl=64 time=42986 ms
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=15 ttl=64 time=41983 ms
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=16 ttl=64 time=42860 ms
DepotRd:~ # iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:"Belkin_N_Wireless_A99331"  
          Mode:Managed  Frequency:2.417 GHz  Access Point: 00:1C:DF:A9:93:31   
          Bit Rate=54 Mb/s   Tx-Power=27 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
          Encryption key:1193-9C46-9CB0-B2EE-99CA-EA37-7EB4-1B62-9475-B834-
AE70-AA4F-B4A5-B303-3D51-4244 [2]   Security mode:open
          Power Management:off
          Link Quality=56/100  Signal level:-67 dBm  Noise level=-103 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

