Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a80-127-65-128.adsl.xs4all.nl ([80.127.65.128]:32398 "EHLO
	linux.wilsoft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbZAJL0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 06:26:24 -0500
Received: from hp4000.wilsoft.nl ([192.168.4.5])
	by linux.wilsoft.nl with esmtp (Exim 4.69)
	(envelope-from <listsrv@wilsoft.nl>)
	id 1LLbyr-0001b7-NT
	for linux-wireless@vger.kernel.org; Sat, 10 Jan 2009 12:26:17 +0100
From: "W. van den Akker" <listsrv@wilsoft.nl>
To: linux-wireless@vger.kernel.org
Subject: Re: Still problems to get ath9k in accessmode. Kernel hangs
Date: Sat, 10 Jan 2009 12:26:15 +0100
References: <200901011444.20333.listsrv@wilsoft.nl> <200901062342.22935.listsrv@wilsoft.nl> <200901071642.04310.listsrv@wilsoft.nl>
In-Reply-To: <200901071642.04310.listsrv@wilsoft.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901101226.16007.listsrv@wilsoft.nl> (sfid-20090110_122628_713492_65BCD99E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 07 January 2009, you wrote:
> On Tuesday 06 January 2009, you wrote:
> > On Tuesday 06 January 2009 21:51:09 you wrote:
> > > W. van den Akker wrote:
> > > --- Snip ---
> > >
> > > >> However, after starting a internet session and Kmail session the
> > > >> server hangs again without any output. Does the NMI-handler not
> > > >> process per CPU? So if one CPU hangs, the other would still proceed?
> > > >>
> > > >> I have no 802.11n enabled, nor X.
> > > >>
> > > >> This means I think the system halted hard 'hlt-instruction'
> > > >>
> > > >> Any further suggestion? I am little bit hopeless now. I have placed
> > > >> the PCI card into another slot, no result.
> > > >
> > > > Some additional information:
> > > > I have booted the server at approx 16:00. Hostapd was started at
> > > > boot-time. After 5 hours without any connection from any computers
> > > > the server hangs.
> > >
> > > Just as a data point, I'm running master mode with ath9k on 64bit with
> > > multiple clients and have no problems.  Perhaps it's hardware version
> > > related?  Here's the info for my system:
> > >
> > > kernel: 2.6.28-gentoo
> > > compat-wireless-2.6: cedd75beb269e2b559a5174ee628ebd01f63a4040
> > > wireless-testing: fd1dae5fbc7a260b0ddfab7d4939a766a82ef3f3
> > > hostapd: 2c04820d80b5c489576cb735c3be8f026a035a5b
> > >
> > > I have 80211n enabled for my device with this config:
> > >
> > > ht_capab=[HT40-][SHORT-GI-40][DSSS_CCK-40]
> > >
> > > my device:
> > >
> > > Network controller: Atheros Communications, Inc. AR5416 802.11a/b/g/n
> > > Wireless PCI Adapter (rev 01)
> > >
> > > phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81:
> > > mem=0xffffc20000060000, irq=17
> > >
> > > Currently I'm using my ps3, axim, laptop, and a netbook at the same
> > > time, and have no disconnects.  Any additional testing I could do that
> > > might help you out, or more information I could provide you?
> >
> > My system:
> > kernel: 2.6.28-rc9-wl (wireless testing): 2.6.28-rc9-1-686-wl #1 SMP Fri
> > Jan 2 19:38:20 CET 2009 i686 GNU/Linux
> > hostapd: 0.6.6
> > Have no 80211n enabled
> > Processor  Intel(R) Pentium(R) 4 CPU 3.00GHz 1024 KB
> >
> > my device:
> > 04:08.0 Network controller: Atheros Communications Inc. AR5416 802.11abgn
> > Wireless PCI Adapter (rev 01)
> >         Subsystem: Linksys Device 0061
> >         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> > ParErr+ Stepping- SERR+ FastB2B- DisINTx-
> >         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> >         Latency: 168, Cache Line Size: 32 bytes
> >         Interrupt: pin A routed to IRQ 21
> >         Region 0: Memory at d0310000 (32-bit, non-prefetchable)
> > [size=64K] Capabilities: [40] #80 [0000]
> >         Kernel driver in use: ath9k
> >         Kernel modules: ath9k
> >
> > System hangsup depending on the number of devices or cennections are
> > opened: - only hostapd (no devices connected). system hangs after approx
> > 5 hours. (ifconfig shows wlan0 up)
> > - only a laptop with a browsing session, system did nog hang after a few
> > hours.
> > - only a laptop with a browsing session and kmail, system hangs directly.
> > No logging to console. Nmi watchdog enabled...
>
> I have tested today with the latest wireless testing 2.6.28-wl and tested
> with WPA and without WPA. It didnt make any difference.
>
> I am getting pretty hopeless now. Because nothing seems to work or give any
> progress.
>
>

Did some futher testing to exclude problems....
The wlan0 and eth1 are both part of a bridge. I have removed the eth1 
interface so the the eth1-driver cannot interfer with the ath9k driver.
Also no result. The server still locks.

What is the right way to combine the eth1 and wlan0 into a bridge. Do I even 
need  a bridge? The hostapd.config says I must define a bridge when I use the 
nl80211driver interface.
The bridge has an IP adress, wlan0 and eth1 are in the same subnet.

When hostapd is started I have some error-messages. Dont know if they can 
hurt...
Failed to set CTS protect in kernel driver
Failed to set Short Slot Time option in kernel driver
Could not set preamble for kernel driver


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

