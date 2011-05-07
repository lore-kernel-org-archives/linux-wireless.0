Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:3595 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753726Ab1EGJYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 05:24:45 -0400
Message-ID: <4DC50FDA.3020700@gmail.com> (sfid-20110507_112448_039077_6DA659EB)
Date: Sat, 07 May 2011 11:24:42 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@01019freenet.de>
CC: users@rt2x00.serialmonkey.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rmmod rt2800pci broken since compat-wireless-2011-04-21 - CPU
 load is 1
References: <4DC44F80.8040605@01019freenet.de>
In-Reply-To: <4DC44F80.8040605@01019freenet.de>
Content-Type: multipart/mixed;
 boundary="------------030207090003000303040901"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030207090003000303040901
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Andreas,

On 05/06/11 21:44, Andreas Hartmann wrote:
> Hello,
> 
> since compat-wireless-2011-04-21 (running with kernel 2.6.34.9),
> removing of rt2800pci is broken: rmmod hangs and system load goes up to
> 1 on one CPU.
> 
> Loading:
> 
> [ 5951.248390] Compat-wireless backport release:
> compat-wireless-2011-04-14-3-g77081fd
> [ 5951.248402] Backport based on linux-next.git next-20110421
> [ 5951.293158] cfg80211: Calling CRDA to update world regulatory domain
> [ 5951.316293] cfg80211: World regulatory domain updated:
> [ 5951.316300] cfg80211:     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [ 5951.316307] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> [ 5951.316313] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
> (300 mBi, 2000 mBm)
> [ 5951.316319] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
> (300 mBi, 2000 mBm)
> [ 5951.316324] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> [ 5951.316330] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> [ 5951.387120] rt2800pci 0000:03:07.0: PCI INT A -> GSI 21 (level, low)
> -> IRQ 21
> [ 5951.396951] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [ 5951.399528] Registered led device: rt2800pci-phy0::radio
> [ 5951.399685] Registered led device: rt2800pci-phy0::assoc
> [ 5951.399831] Registered led device: rt2800pci-phy0::quality
> [ 5951.408153] wlan0 renamed to wlan1 by udevd [26800]
> [ 5951.411780] udev: renamed network interface wlan0 to wlan1
> ifup:     wlan1     device: RaLink RT2800 802.11n PCI
> ifup:               No configuration found for wlan1
> 
> 
> "Unloading" doesn't produce any logentries in /var/log/messages.
> 
> compat-wireless-2011-04-19 doesn't show this problem
> (compat-wireless-2011-04-20 doesn't exist).
> 
> 
> My hardware: Linksys WMP600N
> 
> 03:07.0 Network controller: RaLink RT2800 802.11n PCI
>         Subsystem: Linksys Device 0067
>         Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Interrupt: pin A routed to IRQ 21
>         Region 0: Memory at fdce0000 (32-bit, non-prefetchable) [size=64K]
>         Capabilities: [40] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> 
> 
> Could you please fix this problem?
> 

This is just a hunch and untested, but could you check if the attached patch
solves the problem?

---
Gertjan

--------------030207090003000303040901
Content-Type: text/plain;
 name="rmmod_hang_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rmmod_hang_fix.patch"

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 7776d9f..ae61d24 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1071,9 +1071,9 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Stop all work.
 	 */
-	del_timer_sync(&rt2x00dev->txstatus_timer);
 	cancel_work_sync(&rt2x00dev->intf_work);
 	if (rt2x00_is_usb(rt2x00dev)) {
+		del_timer_sync(&rt2x00dev->txstatus_timer);
 		cancel_work_sync(&rt2x00dev->rxdone_work);
 		cancel_work_sync(&rt2x00dev->txdone_work);
 	}

--------------030207090003000303040901--
