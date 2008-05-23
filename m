Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:59260 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbYEWCFe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:05:34 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JzMew-0001ve-LL
	for linux-wireless@vger.kernel.org; Fri, 23 May 2008 02:05:30 +0000
Received: from cpc3-cwma2-0-0-cust15.swan.cable.ntl.com ([81.96.204.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2008 02:05:30 +0000
Received: from andy by cpc3-cwma2-0-0-cust15.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2008 02:05:30 +0000
To: linux-wireless@vger.kernel.org
From: Andrew Price <andy@andrewprice.me.uk>
Subject: BUG: scheduling while atomic (2.6.26-rc3...)
Date: Fri, 23 May 2008 03:05:17 +0100
Message-ID: <g158ou$ts7$1@ger.gmane.org> (sfid-20080523_040537_383935_93B9797D)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm seeing this bug when I boot but unfortunately the messages don't
seem to get logged and the system locks so I took a photo of as much as
could fit on my laptop's screen:
http://sucs.org/~welshbyte/wirelesstraces.jpg (sorry about the bad quality).

Anyway, I've bisected it down to commit
2f561feb386d6adefbad63c59a1fcd298ac6a79c "mac80211: Add RTNL version of
ieee80211_iterate_active_interfaces"

lspci says I'm using a:

02:00.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
	Subsystem: Belkin Device 701a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at 54000000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: rt2500pci

Let me know if you require any more information (or a clearer
photo/transcription).

--
Andy Price

