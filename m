Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:34408 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYDUVZH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 17:25:07 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Jo3VW-0006Bx-Rg
	for linux-wireless@vger.kernel.org; Mon, 21 Apr 2008 21:25:02 +0000
Received: from 77-85-144-87.btc-net.bg ([77.85.144.87])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 21:25:02 +0000
Received: from a.godumov by 77-85-144-87.btc-net.bg with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 21:25:02 +0000
To: linux-wireless@vger.kernel.org
From: =?utf-8?b?0JDQu9C10LrRgdCw0L3QtNGK0YA=?=
	 =?utf-8?b?0JPQvtC00YPQvNC+0LI=?= <a.godumov@gmail.com>
Subject: Problems with bcm4318 on debian unstable (kernel 2.6.24-1-686-6)
Date: Mon, 21 Apr 2008 21:13:48 +0000 (UTC)
Message-ID: <loom.20080421T203748-692@post.gmane.org> (sfid-20080421_232600_217334_E7CF3509)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an acer travelmate 2492 notebook
with a broadcom bcm4318 wireless lan
card. My wireless lan card never worked
fine with bcm43xx so i used ndiswrapper.
With the new 2.6.24 kernel however my wlan
card is broken and i cannot get it to
work. The reason is the new b43 driver.
Judging by what is written on
linuxwireless my wlan card should be supported.
However it does not work. Here
is some information about my current setup:

06:02.0 Network controller:
Broadcom Corporation BCM4318 [AirForce One 54g]
802.11g Wireless LAN Controller (rev 02)
Subsystem: AMBIT Microsystem Corp. TravelMate 2410
Flags: bus master, fast devsel, latency 64, IRQ 21
Memory at d0002000 (32-bit, non-prefetchable) [size=8K]
Kernel driver in use: b43-pci-bridge
Kernel modules: ssb

debian:/home/hellfire# uname -r
2.6.24-1-686

debian:/home/hellfire# cat /etc/network/interfaces
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug eth0
iface eth0 inet static
pre-up iptables-restore < /etc/iptables/iptables
hwaddress ether 00:16:36:A4:64:85
netmask 255.255.255.252
gateway 192.168.0.1
address 192.168.0.2
auto eth0

allow-hotplug wlan0
iface wlan0 inet static
address 172.16.0.1
netmask 255.255.0.0
wireless-mode Ad-Hoc
wireless-key s:xxxxxxxxxxxxx
wireless-essid Debian
auto wlan0

(this interfaces file works fine with ndiswrapper)


When i installed b43-fwcutter via apt it
automatically downloaded the correct
firmware (which is 4.80.53.0 - i use kernel 2.6.24-1)
so i doubt the problem is
related the the firmware. The problem
itself is that my wlan cannot create an
ad-hoc wireless network - since i only use
my wlan card in ad-hoc mode I haven`t
had the chance to test it in managed or any
other mode. Here is the error i get:

debian:/home/hellfire# /etc/init.d/networking restart
Reconfiguring network
interfaces...RTNETLINK answers: No such process
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Invalid argument.
Error for wireless request "Set ESSID" (8B1A) :
    SET failed on device wlan0 ; Invalid argument.
if-up.d/mountnfs[eth0]:
waiting for interface wlan0 before doing NFS mounts
done.

I get this error at startup when
the network initializes or when i restart the
network. This is the output
iwconfig and iwlist scan give:

debian:/home/hellfire# iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11g  ESSID:"Debian"  
          Mode:Ad-Hoc  Frequency:2.412 GHz  Cell: 1A:B2:3F:BA:96:EC   
          Tx-Power=27 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B   
          Encryption key:6465-7473-6B69-7370-6F6D-656E-6A
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

debian:/home/hellfire# iwlist scan
lo        Interface doesn't support scanning.

eth0      Interface doesn't support scanning.

wmaster0  Interface doesn't support scanning.

wlan0     No scan results (naturally
it cannot find any network - when i use
ndiswrapper it lists the network i have ceated among the others)

Ifconfig says that my wlan0 card is
configured according to the interfaces files:

debian:/home/hellfire# ifconfig
wlan0     Link encap:Ethernet  HWaddr 00:16:cf:9c:5e:d1  
          inet addr:172.16.0.1  Bcast:172.16.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:44 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:6416 (6.2 KiB)

Here is what dmesg | grep b43 and dmesg | grep wlan0 give:
debian:/home/hellfire# dmesg | grep b43
b43-phy0: Broadcom 4318 WLAN found
input: b43-phy0 as /class/input/input9
Registered led device: b43-phy0:tx
Registered led device: b43-phy0:rx
Registered led device: b43-phy0:radio


debian:/home/hellfire# dmesg | grep wlan0
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
DST=224.0.0.251 LEN=140 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=120 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
DST=224.0.0.251 LEN=140 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=120 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
DST=224.0.0.251 LEN=140 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=120 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 
DST=224.0.0.251 LEN=128 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=108 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 
DST=224.0.0.251 LEN=136 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=116 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
DST=224.0.0.251 LEN=136 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=116 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=136 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=116 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=197 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=177 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=112 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=92 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=197 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=177 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=128 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=108 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=197 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=177 
wlan0: Creating new IBSS network, BSSID 66:61:4d:bf:4c:a1
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 
DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 
DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
phy0: Adding new IBSS station 00:18:de:bf:58:94 (dev=wlan0)
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 
DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 


Apparently the b43 driver just cannot
set the wireless mode (Ad-Hoc) and the
essid (Debian). It does manage to set
the wireles key though (at least it does
not give any errors about it). I also
 tried to configure manually my wlan card
debian:/home/hellfire# iwconfig wlan0 
essid Debian mode Ad-Hoc key s:xxxxxxxxxxxxx
debian:/home/hellfire# ifconfig wlan0 down
&& ifconfig wlan0 up
debian:/home/hellfire# iwlist scan
lo        Interface doesn't support scanning.

eth0      Interface doesn't support scanning.

wmaster0  Interface doesn't support scanning.

wlan0     No scan results

debian:/home/hellfire# iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11g  ESSID:"Debian"  
Mode:Ad-Hoc  Frequency:2.412 GHz  Cell: 66:61:4D:BF:4C:A1   
Tx-Power=27 dBm   
Retry min limit:7   RTS thr:off   Fragment thr=2346 B   
Encryption key:6465-7473-6B69-7370-6F6D-656E-6A
Link Quality:0  Signal level:0  Noise level:0
Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
Tx excessive retries:0  Invalid misc:0   Missed beacon:0


As you can see nothing really happens

At this point dmesg | grep b43
does not tell anything new and dmesg | grep wlan0
has this to say:

wlan0: Trigger new scan to find an IBSS to join
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
DST=224.0.0.251 LEN=141 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=121 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
DST=224.0.0.251 LEN=224 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=204 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=224 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=204 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=224 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=204 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=206 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=186 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=141 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=121 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=206 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=186 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=197 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=177 
wlan0: Trigger new scan to find an IBSS to join
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=206 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=186 
wlan0: Trigger new scan to find an IBSS to join
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
wlan0: Trigger new scan to find an IBSS to join
wlan0: Trigger new scan to find an IBSS to join
wlan0: Trigger new scan to find an IBSS to join
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 
DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
wlan0: Trigger new scan to find an IBSS to join
wlan0: Trigger new scan to find an IBSS to join
wlan0: Creating new IBSS network, BSSID 1a:b2:3f:ba:96:ec
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 
DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
wlan0: No active IBSS STAs - trying to scan
for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1
 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1
 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying 
to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec 
based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan
 for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1
based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:18:de:bf:58:94 (dev=wlan0)
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: expiring inactive STA 00:18:de:bf:58:94
wlan0: No active IBSS STAs - trying to scan 
for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec
 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:18:de:bf:58:94 (dev=wlan0)
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: expiring inactive STA 00:18:de:bf:58:94
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:18:de:bf:58:94 (dev=wlan0)
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: expiring inactive STA 00:18:de:bf:58:94
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:18:de:bf:58:94 (dev=wlan0)
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: expiring inactive STA 00:18:de:bf:58:94
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
phy0: Adding new IBSS station 00:18:de:bf:58:94 (dev=wlan0)
wlan0: expiring inactive STA 00:18:de:bf:58:94
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
phy0: Adding new IBSS station 00:18:de:bf:58:94 (dev=wlan0)
wlan0: expiring inactive STA 00:18:de:bf:58:94
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:18:de:bf:58:94 (dev=wlan0)
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: expiring inactive STA 00:18:de:bf:58:94
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
phy0: Adding new IBSS station 00:0c:30:75:61:e3 (dev=wlan0)
phy0: Adding new IBSS station 00:18:de:bf:58:94 (dev=wlan0)
wlan0: expiring inactive STA 00:18:de:bf:58:94
wlan0: expiring inactive STA 00:0c:30:75:61:e3
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
wlan0: Selected IBSS BSSID 1a:b2:3f:ba:96:ec based on configured SSID
wlan0: Failed to configure IBSS beacon template
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=224 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=204 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=141 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=121 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=224 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=204 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=224 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=204 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=206 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=186 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=141 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=121 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=206 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=186 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
wlan0: Selected IBSS BSSID 66:61:4d:bf:4c:a1 based on configured SSID
wlan0: Failed to configure IBSS beacon template
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=197 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=177 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=206 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=186 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
Unknown InputIN=wlan0 OUT= MAC= SRC=172.16.0.1 DST=224.0.0.251 LEN=68 TOS=0x00
PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=48 
phy0: Adding new IBSS station 00:18:de:bf:58:94 (dev=wlan0)

I really don`t know what do to - i searched through the mailing lists but it
could not find anything like this. I also cannot use ndiswrapper since it
conflicts with the ssb module which is required by the b44 module which i need
because i also have a broadcom ethernet card. So for the time beeing i`m stuck
with b43. Any ideas how to make it work?

