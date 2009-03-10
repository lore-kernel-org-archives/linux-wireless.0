Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:37801 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbZCJQIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 12:08:39 -0400
Received: by bwz26 with SMTP id 26so1627146bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 09:08:36 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 10 Mar 2009 18:08:36 +0200
Message-ID: <548cdfc20903100908y6ce7809dw2da12ab8b5cd132b@mail.gmail.com> (sfid-20090310_170845_406652_AC62883F)
Subject: ath5k crashing in device probe
From: Pauli Nieminen <suokkos@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Original bug report to ubuntu bugs:
https://bugs.launchpad.net/bugs/339496 This is regression from 2 weeks
old driver that worked relatively stable. Driver only sometimes went
"mad" and required cold reboot because card couldn't be reseted. That
version was also compiled by me.

I have now tested the latest compat-wireless-2009-03-10
(v2.6.29-rc7-17107-g075d535) with same 2.6.28 kernel and I still gt
same null point reference.

uname -a
Linux haukka 2.6.28-8-generic #28-Ubuntu SMP Fri Mar 6 00:09:20 UTC
2009 x86_64 GNU/Linux

Wireless card info:
04:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR242x
802.11abg Wireless PCI Express Adapter [168c:001c] (rev 01)
	Subsystem: AMBIT Microsystem Corp. Device [1468:0428]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at c0200000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
		Vector table: BAR=0 offset=00000000
		PBA: BAR=0 offset=00000000
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Virtual Channel <?>
	Kernel driver in use: ath5k
	Kernel modules: ath5k

relevant part of dmesg the latest dmesg follows:
[   18.793135] cfg80211: Using static regulatory domain info
[   18.793140] cfg80211: Regulatory domain: EU
[   18.793142] 	(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   18.793145] 	(2402000 KHz - 2482000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[   18.793148] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   18.793151] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   18.793154] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   18.793156] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[   18.793159] 	(5490000 KHz - 5710000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[   18.839094] cfg80211: exports duplicate symbol
cfg80211_wext_giwrange (owned by lbm_cw_cfg80211)
[   18.874052] ath5k 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   18.874066] ath5k 0000:04:00.0: setting latency timer to 64
[   18.874160] ath5k 0000:04:00.0: registered as 'phy0'
[   18.942832] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000004
[   18.942836] IP: [<ffffffffa02c91d5>]
wiphy_update_regulatory+0x2c5/0x460 [lbm_cw_cfg80211]
[   18.942851] PGD 3f11e067 PUD 3d0ea067 PMD 0
[   18.942855] Oops: 0000 [#1] SMP
[   18.942859] last sysfs file: /sys/devices/platform/i8042/modalias
[   18.942863] Dumping ftrace buffer:
[   18.942865]    (ftrace buffer empty)
[   18.942867] CPU 1
[   18.942870] Modules linked in: ath5k(+) lbm_cw_mac80211
lbm_cw_cfg80211 parport_pc lp parport snd_hda_intel snd_pcm_oss
snd_mixer_oss snd_pcm pcmcia snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device
acer_wmi joydev uvcvideo led_class yenta_socket rsrc_nonstatic snd
psmouse pcspkr sdhci_pci compat_ioctl32 serio_raw sdhci pcmcia_core
videodev k8temp soundcore v4l1_compat snd_page_alloc i2c_piix4 usbhid
video output shpchp 8139cp 8139too mii ehci_hcd ohci_hcd fbcon
tileblit font bitblit softcursor
[   18.942913] Pid: 2532, comm: modprobe Not tainted 2.6.28-8-generic #28-Ubuntu
[   18.942916] RIP: 0010:[<ffffffffa02c91d5>]  [<ffffffffa02c91d5>]
wiphy_update_regulatory+0x2c5/0x460 [lbm_cw_cfg80211]
[   18.942926] RSP: 0018:ffff88003f041a68  EFLAGS: 00010246
[   18.942929] RAX: 0000000000000000 RBX: 00000000000000c6 RCX: 0000000000000090
[   18.942931] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88003d0d80a0
[   18.942934] RBP: ffff88003f041ab8 R08: 000000000000000c R09: 0000000000000002
[   18.942937] R10: 0000000000000000 R11: 000000003e170500 R12: ffff88003d0d80a0
[   18.942940] R13: ffff88003d0d8000 R14: ffff88003d0d8360 R15: ffff88003d0d80a0
[   18.942943] FS:  00007f5f8a6cf6f0(0000) GS:ffff88003f806a00(0000)
knlGS:0000000000000000
[   18.942946] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   18.942948] CR2: 0000000000000004 CR3: 000000003d513000 CR4: 00000000000006a0
[   18.942951] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   18.942954] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   18.942958] Process modprobe (pid: 2532, threadinfo
ffff88003f040000, task ffff88003cd45980)
[   18.942960] Stack:
[   18.942962]  ffff88003f041ba8 ffff88003d8f3000 ffff88003f041a88
ffffffff8041f2de
[   18.942967]  ffff88003f041ab8 00000000000000c6 ffff88003d0d80a0
ffff88003d0d8000
[   18.942973]  ffff88003d0d8360 ffff88003d0d9420 ffff88003f041ae8
ffffffffa02c750a
[   18.942978] Call Trace:
[   18.942981]  [<ffffffff8041f2de>] ? __const_udelay+0x4e/0x50
[   18.942989]  [<ffffffffa02c750a>] lbm_cw_wiphy_register+0x17a/0x210
[lbm_cw_cfg80211]
[   18.942998]  [<ffffffffa02f1276>]
lbm_cw_ieee80211_register_hw+0xb6/0x440 [lbm_cw_mac80211]
[   18.943019]  [<ffffffffa0342995>] ath5k_pci_probe+0x10b5/0x148a [ath5k]
[   18.943028]  [<ffffffff8041872a>] ? kobject_get+0x1a/0x30
[   18.943035]  [<ffffffff80430a1c>] pci_device_probe+0x7c/0xa0
[   18.943042]  [<ffffffff804b9a7d>] really_probe+0x6d/0x1a0
[   18.943048]  [<ffffffff804b9bfb>] driver_probe_device+0x4b/0x60
[   18.943052]  [<ffffffff804b9cab>] __driver_attach+0x9b/0xa0
[   18.943056]  [<ffffffff804b9c10>] ? __driver_attach+0x0/0xa0
[   18.943059]  [<ffffffff804b925b>] bus_for_each_dev+0x6b/0xa0
[   18.943063]  [<ffffffffa0079000>] ? init_ath5k_pci+0x0/0x42 [ath5k]
[   18.943071]  [<ffffffff804b98fc>] driver_attach+0x1c/0x20
[   18.943074]  [<ffffffff804b8af8>] bus_add_driver+0x1f8/0x270
[   18.943078]  [<ffffffffa0079000>] ? init_ath5k_pci+0x0/0x42 [ath5k]
[   18.943086]  [<ffffffff804b9e90>] driver_register+0x70/0x160
[   18.943090]  [<ffffffffa0079000>] ? init_ath5k_pci+0x0/0x42 [ath5k]
[   18.943099]  [<ffffffff80430cfd>] __pci_register_driver+0x6d/0xc0
[   18.943104]  [<ffffffffa0079000>] ? init_ath5k_pci+0x0/0x42 [ath5k]
[   18.943111]  [<ffffffffa0079023>] init_ath5k_pci+0x23/0x42 [ath5k]
[   18.943118]  [<ffffffff8020a03b>] do_one_initcall+0x3b/0x170
[   18.943123]  [<ffffffff802d028d>] ? __vunmap+0xcd/0x120
[   18.943129]  [<ffffffff802d0335>] ? vfree+0x25/0x30
[   18.943132]  [<ffffffff8027eec8>] ? load_module+0x11c8/0x11d0
[   18.943141]  [<ffffffff8027ef7d>] sys_init_module+0xad/0x1e0
[   18.943145]  [<ffffffff8021253a>] system_call_fastpath+0x16/0x1b
[   18.943149] Code: 30 75 06 80 78 05 30 74 37 49 8b 47 38 48 85 c0
66 0f 1f 44 00 00 74 0c 80 78 04 30 66 90 0f 84 57 01 00 00 48 8b 05
c3 0d 01 00 <83> 78 04 04 0f 84 d1 00 00 00 41 80 7f 08 00 0f 84 c6 00
00 00
[   18.943184] RIP  [<ffffffffa02c91d5>]
wiphy_update_regulatory+0x2c5/0x460 [lbm_cw_cfg80211]
[   18.943193]  RSP <ffff88003f041a68>
[   18.943195] CR2: 0000000000000004
[   18.943198] ---[ end trace 4540bc7bf8fd4a5f ]---

Pauli
