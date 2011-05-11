Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:59292 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab1EKPgI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 11:36:08 -0400
Received: from [195.4.92.19] (helo=9.mx.freenet.de)
	by mout1.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QK9fs-0001rj-Uv
	for linux-wireless@vger.kernel.org; Wed, 11 May 2011 15:42:00 +0200
Received: from p54a18766.dip0.t-ipconnect.de ([84.161.135.102]:39440 helo=mail.maya.org)
	by 9.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QK9fs-0004X5-NK
	for linux-wireless@vger.kernel.org; Wed, 11 May 2011 15:42:00 +0200
Message-ID: <4DCA921A.8090500@01019freenet.de> (sfid-20110511_173624_806165_68E09231)
Date: Wed, 11 May 2011 15:41:46 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: users@rt2x00.serialmonkey.com
CC: linux-wireless@vger.kernel.org
Subject: rekeying of GTK and PTK completely broken under network load
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Could you please take a look at this bugreport:

http://w1.fi/bugz/show_bug.cgi?id=402


I'm not really sure, if this really is a hostapd bug or a bug somewhere
else!


The tests I did where done with the following hardware:

hostapd:

03:07.0 Network controller: RaLink RT2800 802.11n PCI
        Subsystem: Linksys Device 0067
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (500ns min, 1000ns max), Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at fdce0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: rt2800pci


-> this is a Linksys WMP600N with a ralink RT2860 / RT2850 chip (see
http://www.wikidevi.com/wiki/Linksys_WMP600N)




The supplicants in use where:

wext-driver with rt3572sta (Linksys WUSB600Nv2 rt3572
http://www.wikidevi.com/wiki/Linksys_WUSB600N_v2)

nl80211-driver with AR9285 (PCIE-device of a laptop)


Thank you,
Andreas

