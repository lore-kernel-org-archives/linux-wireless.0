Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.brikks.com ([82.209.166.4]:13095 "EHLO smtp.bredband2.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754367AbYLGSic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 13:38:32 -0500
Date: Sun, 7 Dec 2008 19:38:26 +0100
From: Mats Johannesson <spamcan1@abrasax.se>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>
Subject: Re: [RFT] mac80211: fix HT channel selection
Message-ID: <20081207193826.3f2e1772@loke.fish.not> (sfid-20081207_193838_499670_3E4B7014)
In-Reply-To: <1228667447.22164.46.camel@johannes.berg>
References: <1228667447.22164.46.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 07 Dec 2008 17:30:46 +0100 Johannes Berg wrote:
> HT management is done differently for AP and STA modes, unify
> to just the ->config() callback since HT is fundamentally a
> PHY property and cannot be per-BSS.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Please test. Mats, this might fix your problem (if it applies on top
> of the patch that fixes the panic)

Crazy results. Made two 2.6.28-rc7-wl kernels with different outcomes:

A) Network won't come up properly (no inet address received etc).
Sujith ath9k panic fix:
http://marc.info/?l=linux-wireless&m=122857527427734&w=2
Johannes fix HT channel selection:
http://marc.info/?l=linux-wireless&m=122866746021496&w=2
Sujith changes Johannes patch:
http://marc.info/?l=linux-wireless&m=122866853122939&w=2

B) New kernel panic through the ath9k driver.
Sujith ath9k panic fix:
http://marc.info/?l=linux-wireless&m=122857527427734&w=2
Sujith 'stabelize connection':
http://marc.info/?l=linux-wireless&m=122858606608610&w=2
Johannes fix HT channel selection:
http://marc.info/?l=linux-wireless&m=122866746021496&w=2
Sujith changes Johannes patch:
http://marc.info/?l=linux-wireless&m=122866853122939&w=2

I'll send Sujith a private letter with a picture of the new panic.

Below is a piece of /var/log/kern.log from kernel A). A couple of
minutes where it just keeps adding entries in the log while I don't do
anything:

18:40:48 : cfg80211: Using static regulatory domain info
18:40:48 : cfg80211: Regulatory domain: US
18:40:48 : ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
18:40:48 : ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
18:40:48 : ^I(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
18:40:48 : ^I(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
18:40:48 : ^I(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
18:40:48 : ^I(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
18:40:48 : ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
18:40:48 : cfg80211: Calling CRDA for country: US
18:40:48 : ath9k: 0.1
18:40:48 : ath9k 0000:02:00.0: enabling device (0000 -> 0002)
18:40:48 : ath9k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
18:40:48 : uhci_hcd 0000:00:10.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
18:40:48 : uhci_hcd 0000:00:10.2: UHCI Host Controller
18:40:48 : uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
18:40:48 : uhci_hcd 0000:00:10.2: irq 21, io base 0x00001c40
18:40:48 : usb usb4: configuration #1 chosen from 1 choice
18:40:48 : hub 4-0:1.0: USB hub found
18:40:48 : hub 4-0:1.0: 2 ports detected
18:40:48 : ath9k: 2MHz channel: 2412, channelFlags: 0x300e0
18:40:48 : ath9k: 2MHz channel: 2417, channelFlags: 0x300e0
18:40:48 : ath9k: 2MHz channel: 2422, channelFlags: 0x300e0
18:40:48 : ath9k: 2MHz channel: 2427, channelFlags: 0x300e0
18:40:48 : ath9k: 2MHz channel: 2432, channelFlags: 0x700e0
18:40:48 : ath9k: 2MHz channel: 2437, channelFlags: 0x700e0
18:40:48 : ath9k: 2MHz channel: 2442, channelFlags: 0x700e0
18:40:48 : ath9k: 2MHz channel: 2447, channelFlags: 0x500e0
18:40:48 : ath9k: 2MHz channel: 2452, channelFlags: 0x500e0
18:40:48 : ath9k: 2MHz channel: 2457, channelFlags: 0x500e0
18:40:48 : ath9k: 2MHz channel: 2462, channelFlags: 0x500e0
18:40:48 : ath9k: Rate:  1Mbps, ratecode: 27
18:40:48 : ath9k: Rate:  2Mbps, ratecode: 26
18:40:48 : ath9k: Rate:  5Mbps, ratecode: 25
18:40:48 : ath9k: Rate: 11Mbps, ratecode: 24
18:40:48 : ath9k: Rate:  6Mbps, ratecode: 11
18:40:48 : ath9k: Rate:  9Mbps, ratecode: 15
18:40:48 : ath9k: Rate: 12Mbps, ratecode: 10
18:40:48 : ath9k: Rate: 18Mbps, ratecode: 14
18:40:48 : ath9k: Rate: 24Mbps, ratecode:  9
18:40:48 : ath9k: Rate: 36Mbps, ratecode: 13
18:40:48 : ath9k: Rate: 48Mbps, ratecode:  8
18:40:48 : ath9k: Rate: 54Mbps, ratecode: 12
18:40:48 : ath9k: Rate:  6Mbps, ratecode: 11
18:40:48 : ath9k: Rate:  9Mbps, ratecode: 15
18:40:48 : ath9k: Rate: 12Mbps, ratecode: 10
18:40:48 : ath9k: Rate: 18Mbps, ratecode: 14
18:40:48 : ath9k: Rate: 24Mbps, ratecode:  9
18:40:48 : ath9k: Rate: 36Mbps, ratecode: 13
18:40:48 : ath9k: Rate: 48Mbps, ratecode:  8
18:40:48 : ath9k: Rate: 54Mbps, ratecode: 12
18:40:48 : ath9k: tx DMA: 512 buffers 1 desc/buf
18:40:48 : ath9k: tx DMA map: ffff88007ba00000 (77824) -> 0 (77824)
18:40:48 : ath9k: beacon DMA: 4 buffers 1 desc/buf
18:40:48 : ath9k: beacon DMA map: ffff88007c319000 (608) -> 0 (608)
18:40:48 : ath9k: cachelsz 64 rxbufsize 3904
18:40:48 : ath9k: rx DMA: 512 buffers 1 desc/buf
18:40:48 : ath9k: rx DMA map: ffff88007ba20000 (77824) -> 0 (77824)
18:40:48 : phy0: Selected rate control algorithm 'ath9k_rate_control'
18:40:48 : Registered led device: ath9k-phy0:radio
18:40:48 : Registered led device: ath9k-phy0:assoc
18:40:48 : Registered led device: ath9k-phy0:tx
18:40:48 : Registered led device: ath9k-phy0:rx
18:40:48 : phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81: mem=0xffffc20000120000, irq=17
18:40:48 : ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000ae40510101a78]
18:40:48 : lp0: using parport0 (interrupt-driven).
18:40:48 : SCSI subsystem initialized
18:40:48 : Adding 2144636k swap on /dev/hda9.  Priority:-1 extents:1 across:2144636k
18:40:48 : EXT3 FS on hda2, internal journal
18:40:48 : kjournald starting.  Commit interval 5 seconds
18:40:48 : EXT3 FS on hda6, internal journal
18:40:48 : EXT3-fs: mounted filesystem with ordered data mode.
18:40:48 : kjournald starting.  Commit interval 5 seconds
18:40:48 : EXT3 FS on hda8, internal journal
18:40:48 : EXT3-fs: mounted filesystem with ordered data mode.
18:40:48 : kjournald starting.  Commit interval 5 seconds
18:40:48 : EXT3 FS on hda5, internal journal
18:40:48 : EXT3-fs: mounted filesystem with ordered data mode.
18:40:48 : kjournald starting.  Commit interval 5 seconds
18:40:48 : EXT3 FS on hda7, internal journal
18:40:48 : EXT3-fs: mounted filesystem with ordered data mode.
18:40:53 : ath9k: Starting driver with initial channel: 2412 MHz
18:40:53 : ath9k: Attach a VAP of type: 2
18:40:53 : ath9k: BSS Changed PREAMBLE 0
18:40:53 : ath9k: BSS Changed CTS PROT 0
18:40:53 : ath9k: Set HW RX filter: 0x0
18:40:53 : ath9k: Set channel: 2412 MHz
18:40:53 : ath9k: tx chmask: 1, rx chmask: 1
18:40:53 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:40:53 : ath9k: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
18:40:53 : ath9k: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
18:40:53 : ath9k: Configure tx [queue/halq] [2/1],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
18:40:53 : ath9k: Configure tx [queue/halq] [3/0],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
18:40:53 : ath9k: Set HW RX filter: 0x0
18:40:53 : ath9k: Set HW RX filter: 0x0
18:40:53 : ADDRCONF(NETDEV_UP): ath0: link is not ready
18:40:53 : ath9k: Set HW RX filter: 0x0
18:40:53 : ath9k: Set HW RX filter: 0x10
18:40:53 : ath9k: Set channel: 2412 MHz
18:40:53 : ath9k: tx chmask: 1, rx chmask: 1
18:40:53 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:40:53 : ath9k: Set channel: 2417 MHz
18:40:53 : ath9k: tx chmask: 1, rx chmask: 1
18:40:53 : ath9k: (2412 MHz) -> (2417 MHz), cflags:300e0, chanwidth: 0
18:40:53 : ath9k: Set channel: 2422 MHz
18:40:53 : ath9k: tx chmask: 1, rx chmask: 1
18:40:53 : ath9k: (2417 MHz) -> (2422 MHz), cflags:300e0, chanwidth: 0
18:40:53 : ath9k: Set channel: 2427 MHz
18:40:53 : ath9k: tx chmask: 1, rx chmask: 1
18:40:53 : ath9k: (2422 MHz) -> (2427 MHz), cflags:300e0, chanwidth: 0
18:40:53 : ath9k: Set channel: 2432 MHz
18:40:53 : ath9k: tx chmask: 1, rx chmask: 1
18:40:53 : ath9k: (2427 MHz) -> (2432 MHz), cflags:700e0, chanwidth: 0
18:40:54 : ath9k: Set channel: 2437 MHz
18:40:54 : ath9k: tx chmask: 1, rx chmask: 1
18:40:54 : ath9k: (2432 MHz) -> (2437 MHz), cflags:700e0, chanwidth: 0
18:40:54 : ath9k: Set channel: 2442 MHz
18:40:54 : ath9k: tx chmask: 1, rx chmask: 1
18:40:54 : ath9k: (2437 MHz) -> (2442 MHz), cflags:700e0, chanwidth: 0
18:40:54 : ath9k: Set channel: 2447 MHz
18:40:54 : ath9k: tx chmask: 1, rx chmask: 1
18:40:54 : ath9k: (2442 MHz) -> (2447 MHz), cflags:500e0, chanwidth: 0
18:40:54 : ath9k: Set channel: 2452 MHz
18:40:54 : ath9k: tx chmask: 1, rx chmask: 1
18:40:54 : ath9k: (2447 MHz) -> (2452 MHz), cflags:500e0, chanwidth: 0
18:40:54 : powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3400+ processors (1 cpu cores) (version 2.20.00)
18:40:54 : powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x2
18:40:54 : powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x6
18:40:54 : powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xa
18:40:54 : powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x12
18:40:54 : powernow-k8: ph2 null fid transition 0xe
18:40:54 : Marking TSC unstable due to cpufreq changes
18:40:54 : ath9k: Set channel: 2457 MHz
18:40:54 : ath9k: tx chmask: 1, rx chmask: 1
18:40:54 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
18:40:54 : ath9k: Set channel: 2462 MHz
18:40:54 : ath9k: tx chmask: 1, rx chmask: 1
18:40:54 : ath9k: (2457 MHz) -> (2462 MHz), cflags:500e0, chanwidth: 0
18:40:54 : ath9k: Set channel: 2412 MHz
18:40:54 : ath9k: tx chmask: 1, rx chmask: 1
18:40:54 : ath9k: (2462 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:40:54 : ath9k: Set HW RX filter: 0x0
18:40:54 essage repeated 2 times
18:40:54 : ath9k: Detach Interface
18:40:54 : ath9k: Cleaning up
18:40:54 : ath9k: Driver halt
18:40:54 : r8169: eth0: link down
18:40:54 : ADDRCONF(NETDEV_UP): eth0: link is not ready
18:40:54 : ath9k: Starting driver with initial channel: 2412 MHz
18:40:54 : ath9k: Attach a VAP of type: 2
18:40:54 : ath9k: BSS Changed PREAMBLE 0
18:40:54 : ath9k: BSS Changed CTS PROT 0
18:40:54 : ath9k: Set HW RX filter: 0x0
18:40:54 : ath9k: Set channel: 2412 MHz
18:40:54 : ath9k: tx chmask: 1, rx chmask: 1
18:40:54 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e2, chanwidth: 0
18:40:54 : ath9k: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
18:40:54 : ath9k: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
18:40:54 : ath9k: Configure tx [queue/halq] [2/1],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
18:40:54 : ath9k: Configure tx [queue/halq] [3/0],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
18:40:54 : ath9k: Set HW RX filter: 0x0
18:40:54 : ath9k: Set HW RX filter: 0x0
18:40:54 : ADDRCONF(NETDEV_UP): ath0: link is not ready
18:40:54 : ath9k: Set HW RX filter: 0x0
18:40:54 essage repeated 2 times
18:40:54 : ath9k: Set channel: 2412 MHz
18:40:54 : ath9k: tx chmask: 1, rx chmask: 1
18:40:54 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:40:54 : ath9k: Set HW RX filter: 0x10
18:40:54 : ath9k: Set channel: 2412 MHz
18:40:54 : ath9k: tx chmask: 1, rx chmask: 1
18:40:54 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:40:55 : ath9k: Set channel: 2417 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : ath9k: (2412 MHz) -> (2417 MHz), cflags:300e0, chanwidth: 0
18:40:55 : ath9k: Set channel: 2422 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : ath9k: (2417 MHz) -> (2422 MHz), cflags:300e0, chanwidth: 0
18:40:55 : ath9k: Set channel: 2427 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : warning: `dhclient' uses 32-bit capabilities (legacy support in use)
18:40:55 : ath9k: (2422 MHz) -> (2427 MHz), cflags:300e0, chanwidth: 0
18:40:55 : ath9k: Set HW RX filter: 0x0
18:40:55 : ath9k: Set HW RX filter: 0x0
18:40:55 : ath9k: Set channel: 2432 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : ath9k: (2427 MHz) -> (2432 MHz), cflags:700e0, chanwidth: 0
18:40:55 : ath9k: Set channel: 2437 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : ath9k: (2432 MHz) -> (2437 MHz), cflags:700e0, chanwidth: 0
18:40:55 : ath9k: Set channel: 2442 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : ath9k: (2437 MHz) -> (2442 MHz), cflags:700e0, chanwidth: 0
18:40:55 : ath9k: Set channel: 2447 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : ath9k: (2442 MHz) -> (2447 MHz), cflags:500e0, chanwidth: 0
18:40:55 : ath9k: Set channel: 2452 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : ath9k: (2447 MHz) -> (2452 MHz), cflags:500e0, chanwidth: 0
18:40:55 : ath9k: Set channel: 2457 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
18:40:55 : ath9k: Set channel: 2462 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : ath9k: (2457 MHz) -> (2462 MHz), cflags:500e0, chanwidth: 0
18:40:55 : ath9k: Set channel: 2412 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : ath9k: Set channel: 2412 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : ath9k: (2462 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:40:55 : ath9k: RX filter 0x0 bssid 00:1b:11:60:7a:3d aid 0x0
18:40:55 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:40:55 : ath9k: Set HW RX filter: 0x0
18:40:55 : ath9k: Set channel: 2412 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:40:55 : ath9k: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min: 15, cw_max: 1023, txop: 0
18:40:55 : ath9k: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min: 15, cw_max: 1023, txop: 0
18:40:55 : ath9k: Configure tx [queue/halq] [2/1],  aifs: 2, cw_min: 15, cw_max: 1023, txop: 0
18:40:55 : ath9k: Configure tx [queue/halq] [3/0],  aifs: 2, cw_min: 15, cw_max: 1023, txop: 0
18:40:55 : ath0: authenticate with AP 00:1b:11:60:7a:3d
18:40:55 : ath0: authenticated
18:40:55 : ath0: associate with AP 00:1b:11:60:7a:3d
18:40:55 : ath0: RX AssocResp from 00:1b:11:60:7a:3d (capab=0x431 status=0 aid=4)
18:40:55 : ath0: associated
18:40:55 : ath9k: Choosing rate table for mode: 10
18:40:55 : ath9k: Configure tx [queue/halq] [2/1],  aifs: 3, cw_min: 15, cw_max: 1023, txop: 0
18:40:55 : ath9k: Configure tx [queue/halq] [3/0],  aifs: 7, cw_min: 15, cw_max: 1023, txop: 0
18:40:55 : ath9k: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min: 7, cw_max: 15, txop: 94
18:40:55 : ath9k: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min: 3, cw_max: 7, txop: 47
18:40:55 : ath9k: Set channel: 2412 MHz
18:40:55 : ath9k: tx chmask: 1, rx chmask: 1
18:40:55 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:40:55 : ath9k: BSS Changed PREAMBLE 1
18:40:55 : ath9k: BSS Changed ASSOC 1
18:40:55 : ath9k: Bss Info ASSOC 4
18:40:55 : ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
18:40:55 : ath9k: Set HW RX filter: 0x0
18:40:55 : ath9k: Set HW RX filter: 0x0
18:40:55 : Clocksource tsc unstable (delta = -90870712 ns)
18:41:06 : ath0: no IPv6 routers present
18:41:07 : ath0: deauthenticated (Reason: 0)
18:41:07 : ath9k: Set channel: 2412 MHz
18:41:07 : ath9k: tx chmask: 1, rx chmask: 1
18:41:07 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:07 : ath9k: BSS Changed PREAMBLE 0
18:41:07 : ath9k: BSS Changed CTS PROT 0
18:41:07 : ath9k: BSS Changed ASSOC 0
18:41:07 : ath9k: Bss Info DISSOC
18:41:08 : ath0: direct probe to AP 00:1b:11:60:7a:3d try 1
18:41:08 : ath0 direct probe responded
18:41:08 : ath0: authenticate with AP 00:1b:11:60:7a:3d
18:41:08 : ath0: authenticated
18:41:08 : ath0: associate with AP 00:1b:11:60:7a:3d
18:41:08 : ath0: RX ReassocResp from 00:1b:11:60:7a:3d (capab=0x431 status=0 aid=4)
18:41:08 : ath0: associated
18:41:08 : ath9k: Choosing rate table for mode: 10
18:41:08 : ath9k: Set channel: 2412 MHz
18:41:08 : ath9k: tx chmask: 1, rx chmask: 1
18:41:08 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:08 : ath9k: BSS Changed PREAMBLE 1
18:41:08 : ath9k: BSS Changed ASSOC 1
18:41:08 : ath9k: Bss Info ASSOC 4
18:41:08 : ath9k: Set HW RX filter: 0x10
18:41:08 : ath9k: Set channel: 2412 MHz
18:41:08 : ath9k: tx chmask: 1, rx chmask: 1
18:41:08 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:08 : ath9k: Set channel: 2417 MHz
18:41:08 : ath9k: tx chmask: 1, rx chmask: 1
18:41:08 : ath9k: (2412 MHz) -> (2417 MHz), cflags:300e0, chanwidth: 0
18:41:09 : ath9k: Set channel: 2422 MHz
18:41:09 : ath9k: tx chmask: 1, rx chmask: 1
18:41:09 : ath9k: (2417 MHz) -> (2422 MHz), cflags:300e0, chanwidth: 0
18:41:09 : ath9k: Set channel: 2427 MHz
18:41:09 : ath9k: tx chmask: 1, rx chmask: 1
18:41:09 : ath9k: (2422 MHz) -> (2427 MHz), cflags:300e0, chanwidth: 0
18:41:09 : ath9k: Set channel: 2432 MHz
18:41:09 : ath9k: tx chmask: 1, rx chmask: 1
18:41:09 : ath9k: (2427 MHz) -> (2432 MHz), cflags:700e0, chanwidth: 0
18:41:09 : ath9k: Set channel: 2437 MHz
18:41:09 : ath9k: tx chmask: 1, rx chmask: 1
18:41:09 : ath9k: (2432 MHz) -> (2437 MHz), cflags:700e0, chanwidth: 0
18:41:09 : ath9k: Set channel: 2442 MHz
18:41:09 : ath9k: tx chmask: 1, rx chmask: 1
18:41:09 : ath9k: (2437 MHz) -> (2442 MHz), cflags:700e0, chanwidth: 0
18:41:09 : ath9k: Set channel: 2447 MHz
18:41:09 : ath9k: tx chmask: 1, rx chmask: 1
18:41:09 : ath9k: (2442 MHz) -> (2447 MHz), cflags:500e0, chanwidth: 0
18:41:09 : ath9k: Set channel: 2452 MHz
18:41:09 : ath9k: tx chmask: 1, rx chmask: 1
18:41:09 : ath9k: (2447 MHz) -> (2452 MHz), cflags:500e0, chanwidth: 0
18:41:09 : ath9k: Set channel: 2457 MHz
18:41:09 : ath9k: tx chmask: 1, rx chmask: 1
18:41:09 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
18:41:09 : ath9k: Set channel: 2462 MHz
18:41:09 : ath9k: tx chmask: 1, rx chmask: 1
18:41:09 : ath9k: (2457 MHz) -> (2462 MHz), cflags:500e0, chanwidth: 0
18:41:09 : ath9k: Set channel: 2412 MHz
18:41:09 : ath9k: tx chmask: 1, rx chmask: 1
18:41:09 : ath9k: (2462 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:09 : ath9k: Set HW RX filter: 0x0
18:41:20 : ath0: deauthenticated (Reason: 0)
18:41:20 : ath9k: Set channel: 2412 MHz
18:41:20 : ath9k: tx chmask: 1, rx chmask: 1
18:41:20 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:20 : ath9k: BSS Changed PREAMBLE 0
18:41:20 : ath9k: BSS Changed CTS PROT 0
18:41:20 : ath9k: BSS Changed ASSOC 0
18:41:20 : ath9k: Bss Info DISSOC
18:41:21 : ath0: direct probe to AP 00:1b:11:60:7a:3d try 1
18:41:21 : ath0 direct probe responded
18:41:21 : ath0: authenticate with AP 00:1b:11:60:7a:3d
18:41:21 : ath0: authenticated
18:41:21 : ath0: associate with AP 00:1b:11:60:7a:3d
18:41:21 : ath0: RX ReassocResp from 00:1b:11:60:7a:3d (capab=0x431 status=0 aid=4)
18:41:21 : ath0: associated
18:41:21 : ath9k: Choosing rate table for mode: 10
18:41:21 : ath9k: Set channel: 2412 MHz
18:41:21 : ath9k: tx chmask: 1, rx chmask: 1
18:41:21 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:21 : ath9k: BSS Changed PREAMBLE 1
18:41:21 : ath9k: BSS Changed ASSOC 1
18:41:21 : ath9k: Bss Info ASSOC 4
18:41:21 : ath9k: Set HW RX filter: 0x10
18:41:21 : ath9k: Set channel: 2412 MHz
18:41:21 : ath9k: tx chmask: 1, rx chmask: 1
18:41:21 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:21 : ath9k: Set channel: 2417 MHz
18:41:21 : ath9k: tx chmask: 1, rx chmask: 1
18:41:21 : ath9k: (2412 MHz) -> (2417 MHz), cflags:300e0, chanwidth: 0
18:41:22 : ath9k: Set channel: 2422 MHz
18:41:22 : ath9k: tx chmask: 1, rx chmask: 1
18:41:22 : ath9k: (2417 MHz) -> (2422 MHz), cflags:300e0, chanwidth: 0
18:41:22 : ath9k: Set channel: 2427 MHz
18:41:22 : ath9k: tx chmask: 1, rx chmask: 1
18:41:22 : ath9k: (2422 MHz) -> (2427 MHz), cflags:300e0, chanwidth: 0
18:41:22 : ath9k: Set channel: 2432 MHz
18:41:22 : ath9k: tx chmask: 1, rx chmask: 1
18:41:22 : ath9k: (2427 MHz) -> (2432 MHz), cflags:700e0, chanwidth: 0
18:41:22 : ath9k: Set channel: 2437 MHz
18:41:22 : ath9k: tx chmask: 1, rx chmask: 1
18:41:22 : ath9k: (2432 MHz) -> (2437 MHz), cflags:700e0, chanwidth: 0
18:41:22 : ath9k: Set channel: 2442 MHz
18:41:22 : ath9k: tx chmask: 1, rx chmask: 1
18:41:22 : ath9k: (2437 MHz) -> (2442 MHz), cflags:700e0, chanwidth: 0
18:41:22 : ath9k: Set channel: 2447 MHz
18:41:22 : ath9k: tx chmask: 1, rx chmask: 1
18:41:22 : ath9k: (2442 MHz) -> (2447 MHz), cflags:500e0, chanwidth: 0
18:41:22 : ath9k: Set channel: 2452 MHz
18:41:22 : ath9k: tx chmask: 1, rx chmask: 1
18:41:22 : ath9k: (2447 MHz) -> (2452 MHz), cflags:500e0, chanwidth: 0
18:41:22 : ath9k: Set channel: 2457 MHz
18:41:22 : ath9k: tx chmask: 1, rx chmask: 1
18:41:22 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
18:41:22 : ath9k: Set channel: 2462 MHz
18:41:22 : ath9k: tx chmask: 1, rx chmask: 1
18:41:22 : ath9k: (2457 MHz) -> (2462 MHz), cflags:500e0, chanwidth: 0
18:41:22 : ath9k: Set channel: 2412 MHz
18:41:22 : ath9k: tx chmask: 1, rx chmask: 1
18:41:22 : ath9k: (2462 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:22 : ath9k: Set HW RX filter: 0x0
18:41:33 : ath0: deauthenticated (Reason: 0)
18:41:33 : ath9k: Set channel: 2412 MHz
18:41:33 : ath9k: tx chmask: 1, rx chmask: 1
18:41:33 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:33 : ath9k: BSS Changed PREAMBLE 0
18:41:33 : ath9k: BSS Changed CTS PROT 0
18:41:33 : ath9k: BSS Changed ASSOC 0
18:41:33 : ath9k: Bss Info DISSOC
18:41:34 : ath0: direct probe to AP 00:1b:11:60:7a:3d try 1
18:41:34 : ath0: direct probe to AP 00:1b:11:60:7a:3d try 2
18:41:34 : ath0 direct probe responded
18:41:34 : ath0: authenticate with AP 00:1b:11:60:7a:3d
18:41:34 : ath0: authenticated
18:41:34 : ath0: associate with AP 00:1b:11:60:7a:3d
18:41:34 : ath0: RX ReassocResp from 00:1b:11:60:7a:3d (capab=0x431 status=0 aid=4)
18:41:34 : ath0: associated
18:41:34 : ath9k: Choosing rate table for mode: 10
18:41:34 : ath9k: Set channel: 2412 MHz
18:41:34 : ath9k: tx chmask: 1, rx chmask: 1
18:41:34 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:34 : ath9k: BSS Changed PREAMBLE 1
18:41:34 : ath9k: BSS Changed ASSOC 1
18:41:34 : ath9k: Bss Info ASSOC 4
18:41:35 : ath9k: Set HW RX filter: 0x10
18:41:35 : ath9k: Set channel: 2412 MHz
18:41:35 : ath9k: tx chmask: 1, rx chmask: 1
18:41:35 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:35 : ath9k: Set channel: 2417 MHz
18:41:35 : ath9k: tx chmask: 1, rx chmask: 1
18:41:35 : ath9k: (2412 MHz) -> (2417 MHz), cflags:300e0, chanwidth: 0
18:41:35 : ath9k: Set channel: 2422 MHz
18:41:35 : ath9k: tx chmask: 1, rx chmask: 1
18:41:35 : ath9k: (2417 MHz) -> (2422 MHz), cflags:300e0, chanwidth: 0
18:41:35 : ath9k: Set channel: 2427 MHz
18:41:35 : ath9k: tx chmask: 1, rx chmask: 1
18:41:35 : ath9k: (2422 MHz) -> (2427 MHz), cflags:300e0, chanwidth: 0
18:41:35 : ath9k: Set channel: 2432 MHz
18:41:35 : ath9k: tx chmask: 1, rx chmask: 1
18:41:35 : ath9k: (2427 MHz) -> (2432 MHz), cflags:700e0, chanwidth: 0
18:41:35 : ath9k: Set channel: 2437 MHz
18:41:35 : ath9k: tx chmask: 1, rx chmask: 1
18:41:35 : ath9k: (2432 MHz) -> (2437 MHz), cflags:700e0, chanwidth: 0
18:41:35 : ath9k: Set channel: 2442 MHz
18:41:35 : ath9k: tx chmask: 1, rx chmask: 1
18:41:35 : ath9k: (2437 MHz) -> (2442 MHz), cflags:700e0, chanwidth: 0
18:41:35 : ath9k: Set channel: 2447 MHz
18:41:35 : ath9k: tx chmask: 1, rx chmask: 1
18:41:35 : ath9k: (2442 MHz) -> (2447 MHz), cflags:500e0, chanwidth: 0
18:41:35 : ath9k: Set channel: 2452 MHz
18:41:35 : ath9k: tx chmask: 1, rx chmask: 1
18:41:35 : ath9k: (2447 MHz) -> (2452 MHz), cflags:500e0, chanwidth: 0
18:41:35 : ath9k: Set channel: 2457 MHz
18:41:35 : ath9k: tx chmask: 1, rx chmask: 1
18:41:35 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
18:41:35 : ath9k: Set channel: 2462 MHz
18:41:35 : ath9k: tx chmask: 1, rx chmask: 1
18:41:35 : ath9k: (2457 MHz) -> (2462 MHz), cflags:500e0, chanwidth: 0
18:41:35 : ath9k: Set channel: 2412 MHz
18:41:35 : ath9k: tx chmask: 1, rx chmask: 1
18:41:35 : ath9k: (2462 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:35 : ath9k: Set HW RX filter: 0x0
18:41:46 : ath0: deauthenticated (Reason: 0)
18:41:46 : ath9k: Set channel: 2412 MHz
18:41:46 : ath9k: tx chmask: 1, rx chmask: 1
18:41:46 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:46 : ath9k: BSS Changed PREAMBLE 0
18:41:46 : ath9k: BSS Changed CTS PROT 0
18:41:46 : ath9k: BSS Changed ASSOC 0
18:41:46 : ath9k: Bss Info DISSOC
18:41:47 : ath9k: Set HW RX filter: 0x0
18:41:47 : ath9k: Set HW RX filter: 0x0
18:41:47 : ath0: direct probe to AP 00:1b:11:60:7a:3d try 1
18:41:48 : ath0: direct probe to AP 00:1b:11:60:7a:3d try 2
18:41:48 : ath0 direct probe responded
18:41:48 : ath0: authenticate with AP 00:1b:11:60:7a:3d
18:41:48 : ath0: authenticated
18:41:48 : ath0: associate with AP 00:1b:11:60:7a:3d
18:41:48 : ath0: RX ReassocResp from 00:1b:11:60:7a:3d (capab=0x431 status=0 aid=4)
18:41:48 : ath0: associated
18:41:48 : ath9k: Choosing rate table for mode: 10
18:41:48 : ath9k: Set channel: 2412 MHz
18:41:48 : ath9k: tx chmask: 1, rx chmask: 1
18:41:48 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:48 : ath9k: BSS Changed PREAMBLE 1
18:41:48 : ath9k: BSS Changed ASSOC 1
18:41:48 : ath9k: Bss Info ASSOC 4
18:41:48 : ath9k: Set HW RX filter: 0x10
18:41:48 : ath9k: Set channel: 2412 MHz
18:41:48 : ath9k: tx chmask: 1, rx chmask: 1
18:41:48 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:48 : ath9k: Set channel: 2417 MHz
18:41:48 : ath9k: tx chmask: 1, rx chmask: 1
18:41:48 : ath9k: (2412 MHz) -> (2417 MHz), cflags:300e0, chanwidth: 0
18:41:48 : ath9k: Set channel: 2422 MHz
18:41:48 : ath9k: tx chmask: 1, rx chmask: 1
18:41:48 : ath9k: (2417 MHz) -> (2422 MHz), cflags:300e0, chanwidth: 0
18:41:48 : ath9k: Set channel: 2427 MHz
18:41:48 : ath9k: tx chmask: 1, rx chmask: 1
18:41:48 : ath9k: (2422 MHz) -> (2427 MHz), cflags:300e0, chanwidth: 0
18:41:48 : ath9k: Set channel: 2432 MHz
18:41:48 : ath9k: tx chmask: 1, rx chmask: 1
18:41:48 : ath9k: (2427 MHz) -> (2432 MHz), cflags:700e0, chanwidth: 0
18:41:48 : ath9k: Set channel: 2437 MHz
18:41:48 : ath9k: tx chmask: 1, rx chmask: 1
18:41:48 : ath9k: (2432 MHz) -> (2437 MHz), cflags:700e0, chanwidth: 0
18:41:48 : ath9k: Set channel: 2442 MHz
18:41:48 : ath9k: tx chmask: 1, rx chmask: 1
18:41:48 : ath9k: (2437 MHz) -> (2442 MHz), cflags:700e0, chanwidth: 0
18:41:48 : ath9k: Set channel: 2447 MHz
18:41:48 : ath9k: tx chmask: 1, rx chmask: 1
18:41:48 : ath9k: (2442 MHz) -> (2447 MHz), cflags:500e0, chanwidth: 0
18:41:48 : ath9k: Set channel: 2452 MHz
18:41:48 : ath9k: tx chmask: 1, rx chmask: 1
18:41:48 : ath9k: (2447 MHz) -> (2452 MHz), cflags:500e0, chanwidth: 0
18:41:48 : ath9k: Set channel: 2457 MHz
18:41:48 : ath9k: tx chmask: 1, rx chmask: 1
18:41:48 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
18:41:48 : ath9k: Set channel: 2462 MHz
18:41:48 : ath9k: tx chmask: 1, rx chmask: 1
18:41:48 : ath9k: (2457 MHz) -> (2462 MHz), cflags:500e0, chanwidth: 0
18:41:49 : ath9k: Set channel: 2412 MHz
18:41:49 : ath9k: tx chmask: 1, rx chmask: 1
18:41:49 : ath9k: (2462 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:41:49 : ath9k: Set HW RX filter: 0x0
18:41:50 : ath9k: Set HW RX filter: 0x0
18:42:00 : ath0: deauthenticated (Reason: 0)
18:42:00 : ath9k: Set channel: 2412 MHz
18:42:00 : ath9k: tx chmask: 1, rx chmask: 1
18:42:00 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:42:00 : ath9k: BSS Changed PREAMBLE 0
18:42:00 : ath9k: BSS Changed CTS PROT 0
18:42:00 : ath9k: BSS Changed ASSOC 0
18:42:00 : ath9k: Bss Info DISSOC
18:42:01 : ath0: direct probe to AP 00:1b:11:60:7a:3d try 1
18:42:01 : ath0 direct probe responded
18:42:01 : ath0: authenticate with AP 00:1b:11:60:7a:3d
18:42:01 : ath0: authenticated
18:42:01 : ath0: associate with AP 00:1b:11:60:7a:3d
18:42:01 : ath0: RX ReassocResp from 00:1b:11:60:7a:3d (capab=0x431 status=0 aid=4)
18:42:01 : ath0: associated
18:42:01 : ath9k: Choosing rate table for mode: 10
18:42:01 : ath9k: Set channel: 2412 MHz
18:42:01 : ath9k: tx chmask: 1, rx chmask: 1
18:42:01 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:42:01 : ath9k: BSS Changed PREAMBLE 1
18:42:01 : ath9k: BSS Changed ASSOC 1
18:42:01 : ath9k: Bss Info ASSOC 4
18:42:01 : ath9k: Set HW RX filter: 0x10
18:42:01 : ath9k: Set channel: 2412 MHz
18:42:01 : ath9k: tx chmask: 1, rx chmask: 1
18:42:01 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:42:01 : ath9k: Set channel: 2417 MHz
18:42:01 : ath9k: tx chmask: 1, rx chmask: 1
18:42:01 : ath9k: (2412 MHz) -> (2417 MHz), cflags:300e0, chanwidth: 0
18:42:01 : ath9k: Set channel: 2422 MHz
18:42:01 : ath9k: tx chmask: 1, rx chmask: 1
18:42:01 : ath9k: (2417 MHz) -> (2422 MHz), cflags:300e0, chanwidth: 0
18:42:01 : ath9k: Set channel: 2427 MHz
18:42:01 : ath9k: tx chmask: 1, rx chmask: 1
18:42:01 : ath9k: (2422 MHz) -> (2427 MHz), cflags:300e0, chanwidth: 0
18:42:01 : ath9k: Set channel: 2432 MHz
18:42:01 : ath9k: tx chmask: 1, rx chmask: 1
18:42:01 : ath9k: (2427 MHz) -> (2432 MHz), cflags:700e0, chanwidth: 0
18:42:01 : ath9k: Set channel: 2437 MHz
18:42:01 : ath9k: tx chmask: 1, rx chmask: 1
18:42:01 : ath9k: (2432 MHz) -> (2437 MHz), cflags:700e0, chanwidth: 0
18:42:01 : ath9k: Set channel: 2442 MHz
18:42:01 : ath9k: tx chmask: 1, rx chmask: 1
18:42:01 : ath9k: (2437 MHz) -> (2442 MHz), cflags:700e0, chanwidth: 0
18:42:01 : ath9k: Set channel: 2447 MHz
18:42:01 : ath9k: tx chmask: 1, rx chmask: 1
18:42:01 : ath9k: (2442 MHz) -> (2447 MHz), cflags:500e0, chanwidth: 0
18:42:01 : ath9k: Set channel: 2452 MHz
18:42:01 : ath9k: tx chmask: 1, rx chmask: 1
18:42:01 : ath9k: (2447 MHz) -> (2452 MHz), cflags:500e0, chanwidth: 0
18:42:01 : ath9k: Set channel: 2457 MHz
18:42:01 : ath9k: tx chmask: 1, rx chmask: 1
18:42:01 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
18:42:01 : ath9k: Set channel: 2462 MHz
18:42:01 : ath9k: tx chmask: 1, rx chmask: 1
18:42:01 : ath9k: (2457 MHz) -> (2462 MHz), cflags:500e0, chanwidth: 0
18:42:02 : ath9k: Set channel: 2412 MHz
18:42:02 : ath9k: tx chmask: 1, rx chmask: 1
18:42:02 : ath9k: (2462 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:42:02 : ath9k: Set HW RX filter: 0x0
18:42:13 : ath0: deauthenticated (Reason: 0)
18:42:13 : ath9k: Set channel: 2412 MHz
18:42:13 : ath9k: tx chmask: 1, rx chmask: 1
18:42:13 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:42:13 : ath9k: BSS Changed PREAMBLE 0
18:42:13 : ath9k: BSS Changed CTS PROT 0
18:42:13 : ath9k: BSS Changed ASSOC 0
18:42:13 : ath9k: Bss Info DISSOC
18:42:14 : ath0: direct probe to AP 00:1b:11:60:7a:3d try 1
18:42:14 : ath0 direct probe responded
18:42:14 : ath0: authenticate with AP 00:1b:11:60:7a:3d
18:42:14 : ath0: authenticated
18:42:14 : ath0: associate with AP 00:1b:11:60:7a:3d
18:42:14 : ath0: RX ReassocResp from 00:1b:11:60:7a:3d (capab=0x431 status=0 aid=4)
18:42:14 : ath0: associated
18:42:14 : ath9k: Choosing rate table for mode: 10
18:42:14 : ath9k: Set channel: 2412 MHz
18:42:14 : ath9k: tx chmask: 1, rx chmask: 1
18:42:14 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:42:14 : ath9k: BSS Changed PREAMBLE 1
18:42:14 : ath9k: BSS Changed ASSOC 1
18:42:14 : ath9k: Bss Info ASSOC 4
18:42:14 : ath9k: Set HW RX filter: 0x10
18:42:14 : ath9k: Set channel: 2412 MHz
18:42:14 : ath9k: tx chmask: 1, rx chmask: 1
18:42:14 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:42:14 : ath9k: Set channel: 2417 MHz
18:42:14 : ath9k: tx chmask: 1, rx chmask: 1
18:42:14 : ath9k: (2412 MHz) -> (2417 MHz), cflags:300e0, chanwidth: 0
18:42:14 : ath9k: Set channel: 2422 MHz
18:42:14 : ath9k: tx chmask: 1, rx chmask: 1
18:42:14 : ath9k: (2417 MHz) -> (2422 MHz), cflags:300e0, chanwidth: 0
18:42:14 : ath9k: Set channel: 2427 MHz
18:42:14 : ath9k: tx chmask: 1, rx chmask: 1
18:42:14 : ath9k: (2422 MHz) -> (2427 MHz), cflags:300e0, chanwidth: 0
18:42:14 : ath9k: Set channel: 2432 MHz
18:42:14 : ath9k: tx chmask: 1, rx chmask: 1
18:42:14 : ath9k: (2427 MHz) -> (2432 MHz), cflags:700e0, chanwidth: 0
18:42:14 : ath9k: Set channel: 2437 MHz
18:42:14 : ath9k: tx chmask: 1, rx chmask: 1
18:42:14 : ath9k: (2432 MHz) -> (2437 MHz), cflags:700e0, chanwidth: 0
18:42:14 : ath9k: Set channel: 2442 MHz
18:42:14 : ath9k: tx chmask: 1, rx chmask: 1
18:42:14 : ath9k: (2437 MHz) -> (2442 MHz), cflags:700e0, chanwidth: 0
18:42:14 : ath9k: Set channel: 2447 MHz
18:42:14 : ath9k: tx chmask: 1, rx chmask: 1
18:42:14 : ath9k: (2442 MHz) -> (2447 MHz), cflags:500e0, chanwidth: 0
18:42:14 : ath9k: Set channel: 2452 MHz
18:42:14 : ath9k: tx chmask: 1, rx chmask: 1
18:42:14 : ath9k: (2447 MHz) -> (2452 MHz), cflags:500e0, chanwidth: 0
18:42:14 : ath9k: Set channel: 2457 MHz
18:42:14 : ath9k: tx chmask: 1, rx chmask: 1
18:42:14 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
18:42:14 : ath9k: Set channel: 2462 MHz
18:42:14 : ath9k: tx chmask: 1, rx chmask: 1
18:42:14 : ath9k: (2457 MHz) -> (2462 MHz), cflags:500e0, chanwidth: 0
18:42:15 : ath9k: Set channel: 2412 MHz
18:42:15 : ath9k: tx chmask: 1, rx chmask: 1
18:42:15 : ath9k: (2462 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:42:15 : ath9k: Set HW RX filter: 0x0
18:42:26 : ath0: deauthenticated (Reason: 0)
18:42:26 : ath9k: Set channel: 2412 MHz
18:42:26 : ath9k: tx chmask: 1, rx chmask: 1
18:42:26 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:42:26 : ath9k: BSS Changed PREAMBLE 0
18:42:26 : ath9k: BSS Changed CTS PROT 0
18:42:26 : ath9k: BSS Changed ASSOC 0
18:42:26 : ath9k: Bss Info DISSOC
18:42:27 : ath0: direct probe to AP 00:1b:11:60:7a:3d try 1
18:42:27 : ath0 direct probe responded
18:42:27 : ath0: authenticate with AP 00:1b:11:60:7a:3d
18:42:27 : ath0: authenticated
18:42:27 : ath0: associate with AP 00:1b:11:60:7a:3d
18:42:27 : ath0: RX ReassocResp from 00:1b:11:60:7a:3d (capab=0x431 status=0 aid=4)
18:42:27 : ath0: associated
18:42:27 : ath9k: Choosing rate table for mode: 10
18:42:27 : ath9k: Set channel: 2412 MHz
18:42:27 : ath9k: tx chmask: 1, rx chmask: 1
18:42:27 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:42:27 : ath9k: BSS Changed PREAMBLE 1
18:42:27 : ath9k: BSS Changed ASSOC 1
18:42:27 : ath9k: Bss Info ASSOC 4
18:42:27 : ath9k: Set HW RX filter: 0x10
18:42:27 : ath9k: Set channel: 2412 MHz
18:42:27 : ath9k: tx chmask: 1, rx chmask: 1
18:42:27 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:42:27 : ath9k: Set channel: 2417 MHz
18:42:27 : ath9k: tx chmask: 1, rx chmask: 1
18:42:27 : ath9k: (2412 MHz) -> (2417 MHz), cflags:300e0, chanwidth: 0
18:42:27 : ath9k: Set channel: 2422 MHz
18:42:27 : ath9k: tx chmask: 1, rx chmask: 1
18:42:27 : ath9k: (2417 MHz) -> (2422 MHz), cflags:300e0, chanwidth: 0
18:42:27 : ath9k: Set channel: 2427 MHz
18:42:27 : ath9k: tx chmask: 1, rx chmask: 1
18:42:27 : ath9k: (2422 MHz) -> (2427 MHz), cflags:300e0, chanwidth: 0
18:42:27 : ath9k: Set channel: 2432 MHz
18:42:27 : ath9k: tx chmask: 1, rx chmask: 1
18:42:27 : ath9k: (2427 MHz) -> (2432 MHz), cflags:700e0, chanwidth: 0
18:42:27 : ath9k: Set channel: 2437 MHz
18:42:27 : ath9k: tx chmask: 1, rx chmask: 1
18:42:27 : ath9k: (2432 MHz) -> (2437 MHz), cflags:700e0, chanwidth: 0
18:42:27 : ath9k: Set channel: 2442 MHz
18:42:27 : ath9k: tx chmask: 1, rx chmask: 1
18:42:27 : ath9k: (2437 MHz) -> (2442 MHz), cflags:700e0, chanwidth: 0
18:42:27 : ath9k: Set channel: 2447 MHz
18:42:27 : ath9k: tx chmask: 1, rx chmask: 1
18:42:27 : ath9k: (2442 MHz) -> (2447 MHz), cflags:500e0, chanwidth: 0
18:42:27 : ath9k: Set channel: 2452 MHz
18:42:27 : ath9k: tx chmask: 1, rx chmask: 1
18:42:27 : ath9k: (2447 MHz) -> (2452 MHz), cflags:500e0, chanwidth: 0
18:42:27 : ath9k: Set channel: 2457 MHz
18:42:27 : ath9k: tx chmask: 1, rx chmask: 1
18:42:27 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
18:42:28 : ath9k: Set channel: 2462 MHz
18:42:28 : ath9k: tx chmask: 1, rx chmask: 1
18:42:28 : ath9k: (2457 MHz) -> (2462 MHz), cflags:500e0, chanwidth: 0
18:42:28 : ath9k: Set channel: 2412 MHz
18:42:28 : ath9k: tx chmask: 1, rx chmask: 1
18:42:28 : ath9k: (2462 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
18:42:28 : ath9k: Set HW RX filter: 0x0

/Mats
