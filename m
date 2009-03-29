Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out10.libero.it ([212.52.84.110]:36466 "EHLO
	cp-out10.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbZC2US0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 16:18:26 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: Nick Kossifidis <mick@madwifi-project.org>
Subject: Re: [PATCH 3/3] ath5k: Add tx power calibration support
Date: Sun, 29 Mar 2009 21:09:51 +0200
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
References: <20090315202035.GC5246@makis>
In-Reply-To: <20090315202035.GC5246@makis>
MIME-Version: 1.0
Message-Id: <200903292109.55033.rossi.f@inwind.it> (sfid-20090329_221829_561804_892ACC23)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 15 March 2009, Nick Kossifidis wrote:

>  * Add tx power calibration support
>  * Add a few tx power limits
>  * Hardcode default power to 12.5dB
>  * Disable TPC for now
>
>  v2: Address Jiri's comments
>
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

After bisecting I have found that this patch causes a regression with my 
wireless PCI board:

0:0b.0 Ethernet controller: 3Com Corporation AR5212 802.11abg NIC (3CRDAG675) 
(rev 01)
        Subsystem: 3Com Corporation 3CRDAG675 11a/b/g Wireless PCI Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at d6800000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-
        Kernel driver in use: ath5k
        Kernel modules: ath5k

Before applying the patch I can associate with my access point without 
problems. After giving the "iwconfig essid" command I can see the frequency 
sweep in the .11G and .11A bands until the authentication-association 
process ends successfully. I get the following diagnostic from dmesg:

Mar 29 11:29:50 kernel: ath5k 0000:00:0b.0: enabling device (0014 -> 0016)
Mar 29 11:29:50 kernel: ath5k 0000:00:0b.0: PCI INT A -> Link[LNKB] -> GSI 10 
(level, low) -> IRQ 10
Mar 29 11:29:50 kernel: ath5k 0000:00:0b.0: registered as 'phy0'
Mar 29 11:29:50 kernel: phy0: Selected rate control algorithm 'minstrel'
Mar 29 11:29:50 kernel: ath5k phy0: Atheros AR5212 chip found (MAC: 0x56, PHY: 
0x41)
Mar 29 11:29:50 kernel: ath5k phy0: RF5112B multiband radio found (0x36)
Mar 29 11:29:50 kernel: udev: renamed network interface wlan0 to ath0
Mar 29 11:31:29 kernel: ath0: authenticate with AP 00:0c:f6:xx:xx:xx
Mar 29 11:31:29 kernel: ath0: authenticated
Mar 29 11:31:29 kernel: ath0: associate with AP 00:0c:f6:xx:xx:xx
Mar 29 11:31:29 kernel: ath0: RX AssocResp from 00:0c:f6:xx:xx:xx (capab=0x411 
status=0 aid=2)
Mar 29 11:31:29 kernel: ath0: associated
Mar 29 11:31:29 kernel: phy0: Allocated STA 00:0c:f6:xx:xx:xx
Mar 29 11:31:29 kernel: phy0: Inserted STA 00:0c:f6:xx:xx:xx
Mar 29 11:31:29 kernel: ath0: switched to short slot time 
(BSSID=00:0c:f6:xx:xx:xx)

and with "modprobe -r ath5k"

Mar 29 11:32:23 kernel: ath0: deauthenticating by local choice (reason=3)
Mar 29 11:32:23 kernel: phy0: Removed STA 00:0c:f6:xx:xx:xx
Mar 29 11:32:23 kernel: phy0: Destroyed STA 00:0c:f6:xx:xx:xx
Mar 29 11:32:23 kernel: ath5k 0000:00:0b.0: PCI INT A disabled

With the problematic patch there is no frequency sweep after the "iwconfig 
essid" command and I can't associate anymore (the frequency remains stuck to 
5.18GHz but I work with 802.11G)

Mar 29 11:08:45 kernel: cfg80211: Calling CRDA to update world regulatory 
domain
Mar 29 11:08:45 kernel: ath5k 0000:00:0b.0: PCI INT A -> Link[LNKB] -> GSI 10 
(level, low) -> IRQ 10
Mar 29 11:08:45 kernel: ath5k 0000:00:0b.0: registered as 'phy0'
Mar 29 11:08:45 kernel: phy0: Selected rate control algorithm 'minstrel'
Mar 29 11:08:45 kernel: ath5k phy0: Atheros AR5212 chip found (MAC: 0x56, PHY: 
0x41)
Mar 29 11:08:45 kernel: ath5k phy0: RF5112B multiband radio found (0x36)
Mar 29 11:08:45 kernel: udev: renamed network interface wlan0 to ath0
Mar 29 11:09:03 kernel: ath5k phy0: noise floor calibration timeout (5180MHz)
Mar 29 11:09:36 last message repeated 3 times
Mar 29 11:10:43 last message repeated 6 times
Mar 29 11:11:48 last message repeated 6 times
Mar 29 11:12:54 last message repeated 6 times
Mar 29 11:14:00 last message repeated 6 times
Mar 29 11:15:06 last message repeated 6 times
Mar 29 11:16:12 last message repeated 6 times

and with "modprobe -r ath5k"

Mar 29 11:23:59 kernel: ath0: deauthenticating by local choice (reason=3)
Mar 29 11:24:05 kernel: ath5k phy0: noise floor calibration timeout (5180MHz)
Mar 29 11:24:38 last message repeated 3 times
Mar 29 11:24:49 kernel: ath5k phy0: noise floor calibration timeout (5180MHz)

(I can't understand the deauthenticating line when before I don't see an 
authenticate line). At this point it's impossible to remove the module and 
the execution of a top session identifies a "phy0" program which runs forever 
with high CPU usage (I need to reboot the system)

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
21548 root      15  -5     0    0    0 R 68.5  0.0   2:25.68 phy0


Fabio
