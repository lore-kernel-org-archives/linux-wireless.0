Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:33323 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZESQkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 12:40:23 -0400
Received: from localhost (filter1.syneticon.net [192.168.113.83])
	by mx03.syneticon.net (Postfix) with ESMTP id AE97F35E22
	for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 18:40:22 +0200 (CEST)
Received: from mx03.syneticon.net ([192.168.113.84])
	by localhost (mx03.syneticon.net [192.168.113.83]) (amavisd-new, port 10025)
	with ESMTP id FBfiOlOTnCy9 for <linux-wireless@vger.kernel.org>;
	Tue, 19 May 2009 18:40:20 +0200 (CEST)
Received: from [192.168.10.145] (koln-4db489cf.pool.einsundeins.de [77.180.137.207])
	by mx03.syneticon.net (Postfix) with ESMTPSA
	for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 18:40:20 +0200 (CEST)
Message-ID: <4A12E0F3.2040209@wpkg.org>
Date: Tue, 19 May 2009 18:40:19 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ipw2100: Oops, Data bus error
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure if it's interesting or not.

On ASUS WL-500gP (MIPS platform, with OpenWRT patches), running 2.6.29.3 kernel, I'm getting 
an Oops (see below) when I remove the ipw2100 module and modprobe it again.
Let me know if I should decode the Oops etc., or if has perhaps something to do with the board
not fully supported by the upstream kernel, and just leave it.


Output from lspci:

00:02.0 Network controller: Intel Corporation PRO/Wireless LAN 2100 3B Mini PCI Adapter (rev 04)
        Subsystem: Intel Corporation Samsung X10/P30 integrated WLAN
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 6
        Region 0: Memory at 40001000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Kernel modules: ipw2100



# modprobe ipw2100
[42949450.360000] lib80211: common routines for IEEE802.11 drivers
[42949450.440000] ieee80211: 802.11 data/management/control stack, git-1.1.13
[42949450.440000] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[42949450.550000] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[42949450.560000] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[42949450.580000] PCI: Enabling device 0000:00:02.0 (0000 -> 0002)
[42949450.590000] PCI: Fixing up device 0000:00:02.0
[42949450.590000] ipw2100Device not found via register read.

mangoo:~# rmmod ipw2100

mangoo:~# modprobe ipw2100
[42949611.580000] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[42949611.590000] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[42949611.610000] PCI: Fixing up device 0000:00:02.0
[42949611.610000] Data bus error, epc == c02b8d54, ra == c02b8d48
[42949611.610000] Oops[#1]:
[42949611.610000] Cpu 0
[42949611.610000] $ 0   : 00000000 1000d800 c02c8000 00000000
[42949611.610000] $ 4   : c02c0000 00000000 00000001 000000dc
[42949611.610000] $ 8   : 00000000 00000000 00000002 80340000
[42949611.610000] $12   : 80330000 00000030 00000008 00000000
[42949611.610000] $16   : 800372e8 81d4db28 00000000 c02bc374
[42949611.610000] $20   : 81d4d000 81ccb400 c02c8000 004fe008
[42949611.610000] $24   : 028f5beb 80180eb4
[42949611.610000] $28   : 80c36000 80c37cd8 7fa2db88 c02b8d48
[42949611.610000] Hi    : 00000083
[42949611.610000] Lo    : e42b2000
[42949611.610000] epc   : c02b8d54 0xc02b8d54
[42949611.610000]     Not tainted
[42949611.610000] ra    : c02b8d48 0xc02b8d48
[42949611.610000] Status: 1000d803    KERNEL EXL IE
[42949611.610000] Cause : 0080001c
[42949611.610000] PrId  : 00029006 (Broadcom BCM3302)
[42949611.610000] Modules linked in: ipw2100(+) sch_sfq cls_fw sch_htb xt_MARK ipt_ULOG xt_recent xt_state xt_tcpudp iptable_filter iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables fuse ohci_hcd libipw lib80211 uhci_hcd [last unloaded: ipw2100]
[42949611.610000] Process modprobe (pid: 1153, threadinfo=80c36000, task=81330088, tls=2aad96f0)
[42949611.610000] Stack : 00000001 00000000 00000400 81ea1fb0 00000000 00000000 00000000 00000000
[42949611.610000]         00000000 00000000 00000000 00000000 00000000 00000080 4a12df14 2f222ee2
[42949611.610000]         c02c09e0 81ccb400 00000000 c02c0a10 c02c4000 00000000 00000000 80166874
[42949611.610000]         81ccb458 c02c0a10 c02c4000 801850d8 c02c09e0 81ccb400 c02c0d5c 00000000
[42949611.610000]         81ccb458 81ccb458 c02c0a10 80185304 81c34a08 8014d614 000031f1 1000d800
[42949611.610000]         ...
[42949611.610000] Call Trace:[<c02c4000>] 0xc02c4000
[42949611.610000] [<80166874>] 0x80166874
[42949611.610000] [<c02c4000>] 0xc02c4000
[42949611.610000] [<801850d8>] 0x801850d8
[42949611.610000] [<80185304>] 0x80185304
[42949611.610000] [<8014d614>] 0x8014d614
[42949611.610000] [<8018549c>] 0x8018549c
[42949611.610000] [<8018213c>] 0x8018213c
[42949611.610000] [<8014d398>] 0x8014d398
[42949611.610000] [<8018542c>] 0x8018542c
[42949611.610000] [<80184540>] 0x80184540
[42949611.610000] [<c02c4000>] 0xc02c4000
[42949611.610000] [<8014dba4>] 0x8014dba4
[42949611.610000] [<80184bd0>] 0x80184bd0
[42949611.610000] [<80184ba8>] 0x80184ba8
[42949611.610000] [<c02c4000>] 0xc02c4000
[42949611.610000] [<80185730>] 0x80185730
[42949611.610000] [<c02c4000>] 0xc02c4000
[42949611.610000] [<80166b30>] 0x80166b30
[42949611.610000] [<80081c38>] 0x80081c38
[42949611.610000] [<c02c4068>] 0xc02c4068
[42949611.610000] [<8017e7f4>] 0x8017e7f4
[42949611.610000] [<8000c664>] 0x8000c664
[42949611.610000] [<8007d528>] 0x8007d528
[42949611.610000] [<8007d4ec>] 0x8007d4ec
[42949611.610000] [<8004a1a4>] 0x8004a1a4
[42949611.610000] [<80059288>] 0x80059288
[42949611.610000] [<80059238>] 0x80059238
[42949611.610000] [<800031d0>] 0x800031d0
[42949611.610000] [<800031d0>] 0x800031d0
[42949611.610000]
[42949611.610000]
[42949611.610000] Code: 8e820024  10400300  3c04c02c <8c430090> 3c02d555  344255d5  146202fc  3c028003  26a20058
Segmentation fault


-- 
Tomasz Chmielewski
http://wpkg.org

