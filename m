Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42638 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933187Ab0BYSGg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 13:06:36 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2010 10:06:36 -0800
Date: Thu, 25 Feb 2010 10:06:34 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Schilling, Paul" <Paul.Schilling@ecolab.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: Ath9k Call trace from 2.6.33-RC8 - Rate marked as an HT rate
 but passed status->rate_idx is not an MCS index [0-76]: 127 (0x7f)
Message-ID: <20100225180634.GB5265@tux>
References: <599F2DD3D277A34381AA3DA3337F13A102F54E2F@USEAGAN1509P.GLOBAL.ECOLAB.CORP>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <599F2DD3D277A34381AA3DA3337F13A102F54E2F@USEAGAN1509P.GLOBAL.ECOLAB.CORP>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc'ing linux-wireless

On Thu, Feb 25, 2010 at 09:26:39AM -0800, Schilling, Paul wrote:
> 1. Call trace found in dmesg accociated with the Ath9k driver on a Vortex86DX processor with an AR9223 wireless LAN mini PCI card.
> 
> 2. No known issues exept the call trace in dmesg.  Hostapd is patched however to allow ath5k with powersaving devices not to endlessly try to re-associate when it believes the device is in powersaving mode and the device thinks it is disconnected.
> 
> The following patch was added to hostapd to make it work.  My understanding from mailing lists is that this should be handled in the kernel driver.  I needed this patch to get ubuntu linux kernel 2.6.31 working correctly with a power saving device.  I don't know if this patch is still required for this kernel version.  I left it in for backwords compatibility with the older kernel and the Ath9k device.

2.6.31 is no longer supported upstream, there are no more extra version kernels
going to be made with that.

> Linux version 2.6.33-rc8-vortex86dx (schilpa@schilpa-laptop) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #2 PREEMPT Fri Feb 19 09:03:09 CST 2010
> 
> 5.
> [125970.918677] ------------[ cut here ]------------
> [125970.918874] WARNING: at net/mac80211/rx.c:2509 ieee80211_rx+0x82f/0x8a0 [mac80211]()
> [125970.918901] Rate marked as an HT rate but passed status->rate_idx is not an MCS index [0-76]: 127 (0x7f)

I've heard a few people report this now. It seems under certain conditions
we do get a frame with a busted reported harware rate. How often does this
happen for you?

I should note that we drop these frames, the driver is somehow passing
these frames up, it either should detect for these frames early or better
yet we should figure out exactly when and how we get these type of frames.

Maybe you can help and try to reproduce until you can get it to happen
on demand. It would also help if you can test against a recent kernel.

> [125970.918925] Modules linked in: aes_i586 aes_generic arc4 snd_usb_audio snd_pcm snd_timer snd_page_alloc ath9k snd_hwdep ath9k_common snd_usb_lib mac80211 iptable_filter snd_rawmidi ath9k_hw ip_tables snd_seq_device ath x_tables snd lp cfg80211 r6040 serio_raw soundcore parport mii led_class usbhid pata_rdc
> 
> [125970.919133] Pid: 0, comm: swapper Not tainted 2.6.33-rc8-vortex86dx #2
> [125970.919153] Call Trace:
> [125970.919200]  [<c013856c>] warn_slowpath_common+0x6c/0xa0
> [125970.919286]  [<e0b2465f>] ? ieee80211_rx+0x82f/0x8a0 [mac80211]
> [125970.919364]  [<e0b2465f>] ? ieee80211_rx+0x82f/0x8a0 [mac80211]
> [125970.919399]  [<c01385eb>] warn_slowpath_fmt+0x2b/0x30
> [125970.919481]  [<e0b2465f>] ieee80211_rx+0x82f/0x8a0 [mac80211]
> [125970.919526]  [<e09f702e>] ? ath_rxbuf_alloc+0x2e/0xa0 [ath]
> [125970.919560]  [<e09f702e>] ? ath_rxbuf_alloc+0x2e/0xa0 [ath]
> [125970.919685]  [<e0973c34>] ? ieee80211_get_hdrlen_from_skb+0x24/0x30 [cfg80211]
> [125970.919725]  [<e0b6e080>] ? ath9k_cmn_rx_skb_postprocess+0x30/0x160 [ath9k_common]
> [125970.919798]  [<e0ba8c68>] ath_rx_send_to_mac80211+0x78/0x80 [ath9k]
> [125970.919842]  [<e0ba95fc>] ath_rx_tasklet+0x3cc/0x690 [ath9k]
> [125970.919877]  [<c015ca85>] ? sched_clock_cpu+0xa5/0x120
> [125970.919925]  [<e0ba7798>] ath9k_tasklet+0x108/0x140 [ath9k]
> [125970.919966]  [<c013de87>] tasklet_action+0x67/0x70
> [125970.920048]  [<c013ece9>] __do_softirq+0x79/0x1a0
> [125970.920083]  [<c0189715>] ? handle_IRQ_event+0x55/0x170
> [125970.920124]  [<c0571bb8>] ? sub_preempt_count+0x8/0x90
> [125970.920155]  [<c0571bb8>] ? sub_preempt_count+0x8/0x90
> [125970.920189]  [<c013ee45>] do_softirq+0x35/0x40
> [125970.920217]  [<c013f125>] irq_exit+0x85/0x90
> [125970.920245]  [<c05742d2>] do_IRQ+0x42/0xb0
> [125970.920279]  [<c0103590>] common_interrupt+0x30/0x40
> [125970.920321]  [<c0109f72>] ? default_idle+0x62/0xa0
> [125970.920351]  [<c0101dcc>] cpu_idle+0x9c/0xd0
> [125970.920390]  [<c0564e1a>] rest_init+0x7a/0x80
> [125970.920432]  [<c076a7b5>] start_kernel+0x314/0x31a
> [125970.920462]  [<c076a2d0>] ? unknown_bootoption+0x0/0x19b
> [125970.920498]  [<c076a09e>] i386_start_kernel+0x9e/0xa5
> [125970.920522] ---[ end trace 24dfc97b47d6eb21 ]---
> [145853.218975] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020
> 
> 
> 00:02.0 Network controller: Atheros Communications Inc. AR922X Wireless Network Adapter (rev 01)
>         Subsystem: Atheros Communications Inc. Device 3201
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 168, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 6
>         Region 0: Memory at fef90000 (32-bit, non-prefetchable) [size=64K]
>         Capabilities: [44] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=100mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: ath9k
>         Kernel modules: ath9k

A kernel log of loading ath9k would be nice too.

  Luis
