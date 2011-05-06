Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:37790 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765Ab1EFTmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 15:42:21 -0400
Received: from [195.4.92.27] (helo=17.mx.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QIQun-0001nN-7D
	for linux-wireless@vger.kernel.org; Fri, 06 May 2011 21:42:17 +0200
Received: from p54a19735.dip0.t-ipconnect.de ([84.161.151.53]:36902 helo=mail.maya.org)
	by 17.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QIQum-0005Tu-Tm
	for linux-wireless@vger.kernel.org; Fri, 06 May 2011 21:42:17 +0200
Message-ID: <4DC44F80.8040605@01019freenet.de> (sfid-20110506_214224_995962_C9AC38C7)
Date: Fri, 06 May 2011 21:44:00 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: users@rt2x00.serialmonkey.com
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: rmmod rt2800pci broken since compat-wireless-2011-04-21 - CPU load
 is 1
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

since compat-wireless-2011-04-21 (running with kernel 2.6.34.9),
removing of rt2800pci is broken: rmmod hangs and system load goes up to
1 on one CPU.

Loading:

[ 5951.248390] Compat-wireless backport release:
compat-wireless-2011-04-14-3-g77081fd
[ 5951.248402] Backport based on linux-next.git next-20110421
[ 5951.293158] cfg80211: Calling CRDA to update world regulatory domain
[ 5951.316293] cfg80211: World regulatory domain updated:
[ 5951.316300] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 5951.316307] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 5951.316313] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[ 5951.316319] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[ 5951.316324] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 5951.316330] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 5951.387120] rt2800pci 0000:03:07.0: PCI INT A -> GSI 21 (level, low)
-> IRQ 21
[ 5951.396951] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[ 5951.399528] Registered led device: rt2800pci-phy0::radio
[ 5951.399685] Registered led device: rt2800pci-phy0::assoc
[ 5951.399831] Registered led device: rt2800pci-phy0::quality
[ 5951.408153] wlan0 renamed to wlan1 by udevd [26800]
[ 5951.411780] udev: renamed network interface wlan0 to wlan1
ifup:     wlan1     device: RaLink RT2800 802.11n PCI
ifup:               No configuration found for wlan1


"Unloading" doesn't produce any logentries in /var/log/messages.

compat-wireless-2011-04-19 doesn't show this problem
(compat-wireless-2011-04-20 doesn't exist).


My hardware: Linksys WMP600N

03:07.0 Network controller: RaLink RT2800 802.11n PCI
        Subsystem: Linksys Device 0067
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at fdce0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-


Could you please fix this problem?


Thank you,
kind regards,
Andreas
