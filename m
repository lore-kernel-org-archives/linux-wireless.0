Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:54419 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbYJOTjB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 15:39:01 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KqCCt-0007m2-1L
	for linux-wireless@vger.kernel.org; Wed, 15 Oct 2008 19:38:55 +0000
Received: from 78-21-61-244.access.telenet.be ([78.21.61.244])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 19:38:55 +0000
Received: from fhimpe by 78-21-61-244.access.telenet.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 19:38:55 +0000
To: linux-wireless@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: iwlagn: associating with AP causes kernel hiccup
Date: Wed, 15 Oct 2008 19:38:44 +0000 (UTC)
Message-ID: <gd5gs4$abi$1@ger.gmane.org> (sfid-20081015_213906_931589_B5860EBB)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I associate with an AP, Linux 2.6.27 seems to "hang" for a few 
seconds. During that time, all sound stops playing and keyboard and mouse 
input is impossible. In the log I see this:

wlan0: authenticate with AP 00:15:f2:0a:ab:43
wlan0: authenticate with AP 00:15:f2:0a:ab:43
wlan0: authenticate with AP 00:15:f2:0a:ab:43
wlan0: authenticated
wlan0: associate with AP 00:15:f2:0a:ab:43
wlan0: RX AssocResp from 00:15:f2:0a:ab:43 (capab=0x431 status=0 aid=2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
iwlagn 0000:0c:00.0: PCI INT A disabled
iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:0c:00.0: restoring config space at offset 0x1 (was 0x100102, 
writing 0x100106)
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
iwlagn 0000:0c:00.0: PCI INT A disabled
iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:0c:00.0: restoring config space at offset 0x1 (was 0x100102, 
writing 0x100106)
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
wlan0: deauthenticating by local choice (reason=3)
psmouse.c: DualPoint TouchPad at isa0060/serio1/input0 lost 
synchronization, throwing 1 bytes away.
iwlagn 0000:0c:00.0: PCI INT A disabled
iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:0c:00.0: restoring config space at offset 0x1 (was 0x100102, 
writing 0x100106)
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
psmouse.c: resync failed, issuing reconnect request
input: PS/2 Generic Mouse as /class/input/input13
wlan0: authenticate with AP 00:15:f2:0a:ab:43
wlan0: authenticated
wlan0: associate with AP 00:15:f2:0a:ab:43
wlan0: RX AssocResp from 00:15:f2:0a:ab:43 (capab=0x431 status=0 aid=2)
wlan0: associated

This is a Dell Latitude E6400.

$ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Mobile 4 Series Chipset 
Memory Controller Hub [8086:2a40] (rev 07)
00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 4 
Series Chipset Integrated Graphics Controller [8086:2a42] (rev 07)
00:02.1 Display controller [0380]: Intel Corporation Mobile 4 Series 
Chipset Integrated Graphics Controller [8086:2a43] (rev 07)
00:19.0 Ethernet controller [0200]: Intel Corporation 82567LM Gigabit 
Network Connection [8086:10f5] (rev 03)
00:1a.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB 
UHCI Controller #4 [8086:2937] (rev 03)
00:1a.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB 
UHCI Controller #5 [8086:2938] (rev 03)
00:1a.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB 
UHCI Controller #6 [8086:2939] (rev 03)
00:1a.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) 
USB2 EHCI Controller #2 [8086:293c] (rev 03)
00:1b.0 Audio device [0403]: Intel Corporation 82801I (ICH9 Family) HD 
Audio Controller [8086:293e] (rev 03)
00:1c.0 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI 
Express Port 1 [8086:2940] (rev 03)
00:1c.1 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI 
Express Port 2 [8086:2942] (rev 03)
00:1c.2 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI 
Express Port 3 [8086:2944] (rev 03)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB 
UHCI Controller #1 [8086:2934] (rev 03)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB 
UHCI Controller #2 [8086:2935] (rev 03)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB 
UHCI Controller #3 [8086:2936] (rev 03)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) 
USB2 EHCI Controller #1 [8086:293a] (rev 03)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge 
[8086:2448] (rev 93)
00:1f.0 ISA bridge [0601]: Intel Corporation ICH9M-E LPC Interface 
Controller [8086:2917] (rev 03)
00:1f.2 SATA controller [0106]: Intel Corporation ICH9M/M-E SATA AHCI 
Controller [8086:2929] (rev 03)
00:1f.3 SMBus [0c05]: Intel Corporation 82801I (ICH9 Family) SMBus 
Controller [8086:2930] (rev 03)
03:01.0 CardBus bridge [0607]: Ricoh Co Ltd RL5c476 II [1180:0476] (rev 
ba)
03:01.1 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd R5C832 IEEE 1394 
Controller [1180:0832] (rev 04)
03:01.2 SD Host controller [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/
MSPro Host Adapter [1180:0822] (rev 21)
03:01.3 System peripheral [0880]: Ricoh Co Ltd R5C843 MMC Host Controller 
[1180:0843] (rev ff)
0c:00.0 Network controller [0280]: Intel Corporation Device [8086:4235]


