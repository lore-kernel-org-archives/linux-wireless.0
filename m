Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.syneticon.net ([213.239.212.131]:33480 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYBHWBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 17:01:37 -0500
Received: from postfix1.syneticon.net (postfix1.syneticon.net [192.168.112.6])
	by mail2.syneticon.net (Postfix) with ESMTP id F1462628A3
	for <linux-wireless@vger.kernel.org>; Fri,  8 Feb 2008 23:01:35 +0100 (CET)
Received: from localhost (filter1.syneticon.net [192.168.113.3])
	by postfix1.syneticon.net (Postfix) with ESMTP id 2C862946A
	for <linux-wireless@vger.kernel.org>; Fri,  8 Feb 2008 23:01:34 +0100 (CET)
Received: from postfix1.syneticon.net ([192.168.113.4])
	by localhost (mx03.syneticon.net [192.168.113.3]) (amavisd-new, port 10025)
	with ESMTP id Lk4On6vHCHk9 for <linux-wireless@vger.kernel.org>;
	Fri,  8 Feb 2008 23:01:27 +0100 (CET)
Received: from [192.168.10.145] (koln-4d0b075c.pool.mediaWays.net [77.11.7.92])
	by postfix1.syneticon.net (Postfix) with ESMTP
	for <linux-wireless@vger.kernel.org>; Fri,  8 Feb 2008 23:01:27 +0100 (CET)
Message-ID: <47ACD136.4030705@wpkg.org> (sfid-20080208_220148_358484_714FFEE6)
Date: Fri, 08 Feb 2008 23:01:26 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: prism54: Out of memory, cannot handle oid, card/socket may be faulty,
 or IRQ line too busy
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just wanted to use a mini-PCI card using a prism54 module - however, 
it fails to bring the interface up with "Out of memory, cannot handle 
oid" and "Your card/socket may be faulty, or IRQ line too busy" messages.

I used the card in an ASUS WL-500gP router (mipsel).


Any ideas what it might be?

I used 2.6.23.1 kernel, below full data.


# lspci -vv -nn
00:02.0 Network controller [0280]: Intersil Corporation ISL3890 [Prism 
GT/Prism Duette]/ISL3886 [Prism Javelin/Prism Xbow] [1260:3890] (rev 01)
         Subsystem: Intersil Corporation Unknown device [1260:0000]
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 80 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 6
         Region 0: Memory at 40004000 (32-bit, non-prefetchable) [size=8K]
         Capabilities: [dc] Power Management version 1
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

# ifconfig eth2
eth2      Link encap:Ethernet  HWaddr 00:30:B4:00:00:00
           BROADCAST MULTICAST  MTU:1500  Metric:1
           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
           Interrupt:6 Base address:0x4000

# iwconfig
(...)
Warning: Driver for device eth2 has been compiled with version 22
of Wireless Extension, while this program supports up to version 20.
Some things may be broken...

eth2      NOT READY!  ESSID:off/any
           Mode:Managed  Channel:0  Access Point: Not-Associated
           Tx-Power=31 dBm   Sensitivity=0/200
           Retry limit:0   RTS thr=0 B   Fragment thr=0 B
           Encryption key:off
           Link Quality:0  Signal level:0  Noise level:0
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0


# ifconfig eth2 up
eth2: Out of memory, cannot handle oid 0x080002ff
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=19000001 err=-145
eth2: Out of memory, cannot handle oid 0x04000019
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=12000004 err=-145
eth2: Out of memory, cannot handle oid 0x06000012
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=ff02000c err=-145
eth2: interface reset failure
prism54: Your card/socket may be faulty, or IRQ line too busy :(
SIOCSIFFLAGS: Connection timed out


# dmesg -c
Loaded prism54 driver, version 1.2
PCI: Fixing up device 0000:00:02.0
eth2: resetting device...
eth2: uploading firmware...
eth2: firmware version: 1.0.4.3
eth2: firmware upload complete
eth2: Out of memory, cannot handle oid 0x080002ff
eth2: timeout waiting for mgmt response 250, triggering device
eth2: timeout waiting for mgmt response 225, triggering device
eth2: timeout waiting for mgmt response 200, triggering device
eth2: timeout waiting for mgmt response 175, triggering device
eth2: timeout waiting for mgmt response 150, triggering device
eth2: timeout waiting for mgmt response 125, triggering device
eth2: timeout waiting for mgmt response 100, triggering device
eth2: timeout waiting for mgmt response 75, triggering device
eth2: timeout waiting for mgmt response 50, triggering device
eth2: timeout waiting for mgmt response 25, triggering device
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=19000001 err=-145
eth2: Out of memory, cannot handle oid 0x04000019
eth2: timeout waiting for mgmt response 250, triggering device
eth2: timeout waiting for mgmt response 225, triggering device
eth2: timeout waiting for mgmt response 200, triggering device
eth2: timeout waiting for mgmt response 175, triggering device
eth2: timeout waiting for mgmt response 150, triggering device
eth2: timeout waiting for mgmt response 125, triggering device
eth2: timeout waiting for mgmt response 100, triggering device
eth2: timeout waiting for mgmt response 75, triggering device
eth2: timeout waiting for mgmt response 50, triggering device
eth2: timeout waiting for mgmt response 25, triggering device
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=12000004 err=-145
eth2: Out of memory, cannot handle oid 0x06000012
eth2: timeout waiting for mgmt response 250, triggering device
eth2: timeout waiting for mgmt response 225, triggering device
eth2: timeout waiting for mgmt response 200, triggering device
eth2: timeout waiting for mgmt response 175, triggering device
eth2: timeout waiting for mgmt response 150, triggering device
eth2: timeout waiting for mgmt response 125, triggering device
eth2: timeout waiting for mgmt response 100, triggering device
eth2: timeout waiting for mgmt response 75, triggering device
eth2: timeout waiting for mgmt response 50, triggering device
eth2: timeout waiting for mgmt response 25, triggering device
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=ff02000c err=-145
eth2: mgt_commit: failure
eth2: interface reset failure
prism54: Your card/socket may be faulty, or IRQ line too busy :(



-- 
Tomasz Chmielewski
http://wpkg.org

