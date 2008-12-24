Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a80-127-65-128.adsl.xs4all.nl ([80.127.65.128]:43393 "EHLO
	linux.wilsoft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYLXJks (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 04:40:48 -0500
Received: from hp4000.wilsoft.nl ([192.168.4.5])
	by linux.wilsoft.nl with esmtp (Exim 4.69)
	(envelope-from <listsrv@wilsoft.nl>)
	id 1LFQEJ-0001S6-QT
	for linux-wireless@vger.kernel.org; Wed, 24 Dec 2008 10:40:39 +0100
From: "W. van den Akker" <listsrv@wilsoft.nl>
To: linux-wireless@vger.kernel.org
Subject: Still problems to get ath9k in accessmode. Kernel hangs
Date: Wed, 24 Dec 2008 10:40:38 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812241040.39056.listsrv@wilsoft.nl> (sfid-20081224_104109_378213_F5888A0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have tested with the latest kernel 2.6.27.10 and compat-wireless 22-12-2008.
I have a dual core system (Intel(R) Pentium(R) 4 CPU 3.00GHz) and use hostapd 
0.6.6.

I have build the kernel, compiled the compat-wireless and did a make install.
Make unload didnt work because some drivers were in use (mac80211).
First problem arises, a rmmod ath9k hangs the kernel. No message of what so 
ever in the log or to stdout.

Rebooted the system (hostapd still disabled). Iwconfig shows:
wlan0     IEEE 802.11bgn  ESSID:""
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
          Tx-Power=27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

If I start hostapd (by hand or from init.d) the kernel hangs with no trace of 
such thing. Hostapd shows in stdout (with -dd):
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
Opening raw packet socket for ifindex 1688
BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
Allowed channel: mode=1 chan=1 freq=2412 MHz
Allowed channel: mode=1 chan=2 freq=2417 MHz
Allowed channel: mode=1 chan=3 freq=2422 MHz
Allowed channel: mode=1 chan=4 freq=2427 MHz
Allowed channel: mode=1 chan=5 freq=2432 MHz
Allowed channel: mode=1 chan=6 freq=2437 MHz
Allowed channel: mode=1 chan=7 freq=2442 MHz
Allowed channel: mode=1 chan=8 freq=2447 MHz
Allowed channel: mode=1 chan=9 freq=2452 MHz
Allowed channel: mode=1 chan=10 freq=2457 MHz
Allowed channel: mode=1 chan=11 freq=2462 MHz
Failed to update rate sets in kernel module
RATE[0] rate=10 flags=0x2
RATE[1] rate=20 flags=0x2
RATE[2] rate=55 flags=0x2
RATE[3] rate=110 flags=0x2
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
Passive scanning not supported
Flushing old station entries

I have tried in the past several kernelversions and compat-wireless versions 
and all give the same problem.
So I think it is hardware (system) related and ap-mode.
How can I trace the problem? Default I get no entries in any log.

lspci -vv shows 
04:08.0 Network controller: Atheros Communications Inc. AR5416 802.11abgn 
Wireless PCI Adapter (rev 01)
        Subsystem: Linksys Device 0061
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at d0310000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [40] #80 [0000]
        Kernel driver in use: ath9k
        Kernel modules: ath9k


Can somebody provide some help. I am struggeling to get the card into ap mode.

TIA,
Willem

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

