Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:41843 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab1EORus (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 13:50:48 -0400
Received: from [195.4.92.23] (helo=13.mx.freenet.de)
	by mout6.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QLfSo-0001qf-4U
	for linux-wireless@vger.kernel.org; Sun, 15 May 2011 19:50:46 +0200
Received: from p54a187d2.dip0.t-ipconnect.de ([84.161.135.210]:40278 helo=mail.maya.org)
	by 13.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QLfSn-0001vV-NJ
	for linux-wireless@vger.kernel.org; Sun, 15 May 2011 19:50:46 +0200
Message-ID: <4DD01270.7080305@dualc.maya.org> (sfid-20110515_195052_787405_3D33F633)
Date: Sun, 15 May 2011 19:50:40 +0200
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: rt2800pci doesn't come up again after rt2800pci_txdone: Warning -
 Got TX status for an empty queue 0, dropping
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

after the "rt2800pci_txdone: Warning - Got TX status for an empty queue 
0, dropping" storm, I removed all modules for compat-wireless:

rmmod rt2800pci rt2800lib rt2x00pci rt2x00lib mac80211 cfg80211 rfkill 
compat arc4 crc_ccitt eeprom_93cx6

If I want to reload the modules, thy can be reloaded, but the device 
can't be set up with ifconfig up, because of WPDMA TX/RX busy:


May 15 19:41:56 dualc kernel: [ 3646.350332] Compat-wireless backport 
release: compat-wireless-2011-04-26-3-g6542f4c
May 15 19:41:56 dualc kernel: [ 3646.350339] Backport based on 
linux-next.git next-20110505
May 15 19:41:56 dualc kernel: [ 3646.393687] cfg80211: Calling CRDA to 
update world regulatory domain
May 15 19:41:56 dualc kernel: [ 3646.444317] cfg80211: World regulatory 
domain updated:
May 15 19:41:56 dualc kernel: [ 3646.444321] cfg80211:     (start_freq - 
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 15 19:41:56 dualc kernel: [ 3646.444323] cfg80211:     (2402000 KHz 
- 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 15 19:41:56 dualc kernel: [ 3646.444326] cfg80211:     (2457000 KHz 
- 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 15 19:41:56 dualc kernel: [ 3646.444328] cfg80211:     (2474000 KHz 
- 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 15 19:41:56 dualc kernel: [ 3646.444330] cfg80211:     (5170000 KHz 
- 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 15 19:41:56 dualc kernel: [ 3646.444333] cfg80211:     (5735000 KHz 
- 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 15 19:41:56 dualc kernel: [ 3646.448237] cfg80211: Calling CRDA for 
country: DE
May 15 19:41:56 dualc kernel: [ 3646.456646] cfg80211: Regulatory domain 
changed to country: DE
May 15 19:41:56 dualc kernel: [ 3646.456649] cfg80211:     (start_freq - 
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 15 19:41:56 dualc kernel: [ 3646.456652] cfg80211:     (2400000 KHz 
- 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
May 15 19:41:56 dualc kernel: [ 3646.456654] cfg80211:     (5150000 KHz 
- 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
May 15 19:41:56 dualc kernel: [ 3646.456656] cfg80211:     (5470000 KHz 
- 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
May 15 19:41:56 dualc kernel: [ 3646.475664] rt2800pci 0000:03:07.0: PCI 
INT A -> GSI 21 (level, low) -> IRQ 21
May 15 19:41:56 dualc kernel: [ 3646.485215] phy0 -> rt2x00_set_chip: 
Info - Chipset detected - rt: 2860, rf: 0002, rev: 0103.
May 15 19:41:56 dualc kernel: [ 3646.492435] ieee80211 phy0: Selected 
rate control algorithm 'minstrel_ht'
May 15 19:41:56 dualc kernel: [ 3646.494191] Registered led device: 
rt2800pci-phy0::radio
May 15 19:41:56 dualc kernel: [ 3646.494208] Registered led device: 
rt2800pci-phy0::assoc
May 15 19:41:56 dualc kernel: [ 3646.494222] Registered led device: 
rt2800pci-phy0::quality
May 15 19:41:56 dualc kernel: [ 3646.503712] wlan0 renamed to wlan1 by 
udevd [15819]
May 15 19:41:56 dualc kernel: [ 3646.506646] udev: renamed network 
interface wlan0 to wlan1
May 15 19:41:57 dualc ifup:     wlan1     device: RaLink RT2800 802.11n PCI
May 15 19:41:57 dualc ifup:               No configuration found for wlan1
May 15 19:42:25 dualc kernel: [ 3675.463794] phy0 -> 
rt2x00lib_request_firmware: Info - Loading firmware file 'rt2860.bin'.
May 15 19:42:25 dualc kernel: [ 3675.463806] rt2800pci 0000:03:07.0: 
firmware: requesting rt2860.bin
May 15 19:42:25 dualc kernel: [ 3675.467959] phy0 -> 
rt2x00lib_request_firmware: Info - Firmware detected - version: 0.34.
May 15 19:42:25 dualc kernel: [ 3675.493637] phy0 -> 
rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
May 15 19:42:26 dualc kernel: [ 3676.595030] phy0 -> 
rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting.
May 15 19:42:26 dualc kernel: [ 3676.595042] phy0 -> 
rt2800pci_set_device_state: Error - Device failed to enter state 4 (-5).


The hardware is a linksys WMP600N:

03:07.0 0280: 1814:0601
         Subsystem: 1737:0067
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




Kind regards,
Andreas
