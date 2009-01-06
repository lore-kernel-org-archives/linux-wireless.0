Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a80-127-65-128.adsl.xs4all.nl ([80.127.65.128]:18092 "EHLO
	linux.wilsoft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760693AbZAFWma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 17:42:30 -0500
Received: from notebook.wilsoft.nl ([192.168.4.4])
	by linux.wilsoft.nl with esmtp (Exim 4.69)
	(envelope-from <listsrv@wilsoft.nl>)
	id 1LKKcx-0001vG-4N
	for linux-wireless@vger.kernel.org; Tue, 06 Jan 2009 23:42:23 +0100
From: "W. van den Akker" <listsrv@wilsoft.nl>
To: linux-wireless@vger.kernel.org
Subject: Re: Still problems to get ath9k in accessmode. Kernel hangs
Date: Tue, 6 Jan 2009 23:42:22 +0100
References: <200901011444.20333.listsrv@wilsoft.nl> <200901062132.04403.listsrv@wilsoft.nl> <4963C43D.1080209@erley.org>
In-Reply-To: <4963C43D.1080209@erley.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901062342.22935.listsrv@wilsoft.nl> (sfid-20090106_234247_582060_D83AA8EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 06 January 2009 21:51:09 you wrote:
> W. van den Akker wrote:
> --- Snip ---
>
> >> However, after starting a internet session and Kmail session the server
> >> hangs again without any output. Does the NMI-handler not process per
> >> CPU? So if one CPU hangs, the other would still proceed?
> >>
> >> I have no 802.11n enabled, nor X.
> >>
> >> This means I think the system halted hard 'hlt-instruction'
> >>
> >> Any further suggestion? I am little bit hopeless now. I have placed the
> >> PCI card into another slot, no result.
> >
> > Some additional information:
> > I have booted the server at approx 16:00. Hostapd was started at
> > boot-time. After 5 hours without any connection from any computers the
> > server hangs.
>
> Just as a data point, I'm running master mode with ath9k on 64bit with
> multiple clients and have no problems.  Perhaps it's hardware version
> related?  Here's the info for my system:
>
> kernel: 2.6.28-gentoo
> compat-wireless-2.6: cedd75beb269e2b559a5174ee628ebd01f63a4040
> wireless-testing: fd1dae5fbc7a260b0ddfab7d4939a766a82ef3f3
> hostapd: 2c04820d80b5c489576cb735c3be8f026a035a5b
>
> I have 80211n enabled for my device with this config:
>
> ht_capab=[HT40-][SHORT-GI-40][DSSS_CCK-40]
>
> my device:
>
> Network controller: Atheros Communications, Inc. AR5416 802.11a/b/g/n
> Wireless PCI Adapter (rev 01)
>
> phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81:
> mem=0xffffc20000060000, irq=17
>
> Currently I'm using my ps3, axim, laptop, and a netbook at the same
> time, and have no disconnects.  Any additional testing I could do that
> might help you out, or more information I could provide you?

My system:
kernel: 2.6.28-rc9-wl (wireless testing): 2.6.28-rc9-1-686-wl #1 SMP Fri Jan 2 
19:38:20 CET 2009 i686 GNU/Linux
hostapd: 0.6.6
Have no 80211n enabled
Processor  Intel(R) Pentium(R) 4 CPU 3.00GHz 1024 KB

my device:
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

System hangsup depending on the number of devices or cennections are opened:
- only hostapd (no devices connected). system hangs after approx 5 hours. 
(ifconfig shows wlan0 up)
- only a laptop with a browsing session, system did nog hang after a few 
hours.
- only a laptop with a browsing session and kmail, system hangs directly.
No logging to console. Nmi watchdog enabled...



-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

