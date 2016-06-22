Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:13340 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbcFVQVy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 12:21:54 -0400
Date: Wed, 22 Jun 2016 19:21:51 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Miaoqing Pan <miaoqing@codeaurora.org>
Subject: WARNING: CPU: 1 PID: 103 at drivers/net/wireless/ath/ath9k/hw.c:2778
Message-ID: <20160622162151.GD1718@lahna.fi.intel.com> (sfid-20160622_182205_552677_AA9CD767)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

After upgrading from v4.6 to v4.7-rc3 I'm starting to see following
warnings constantly being printed by ath driver:

[    6.761789] ath: phy0: ASPM enabled: 0x43
[    6.761794] ath: EEPROM regdomain: 0x6a
[    6.761796] ath: EEPROM indicates we should expect a direct regpair map
[    6.761799] ath: Country alpha2 being used: 00
[    6.761800] ath: Regpair used: 0x6a
[    6.773482] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    6.774048] ieee80211 phy0: Atheros AR9462 Rev:3 mem=0xffffc90000b00000, irq=19
[    6.774054] ------------[ cut here ]------------
[    6.774070] WARNING: CPU: 1 PID: 103 at drivers/net/wireless/ath/ath9k/hw.c:2778 ath9k_hw_gpio_get+0x161/0x1b0 [ath9k_hw]
[    6.774115] Modules linked in: arc4 rt2x00lib ath9k(+) crc_itu_t ath9k_common ath9k_hw mac80211 snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel snd_hda_codec x86_pkg_temp_thermal coretemp snd_hwdep kvm_intel snd_hda_core ath kvm iTCO_wdt cfg80211 vfat snd_seq fat iTCO_vendor_support acer_wmi hid_multitouch irqbypass sparse_keymap snd_seq_device crct10dif_pclmul crc32_pclmul crc32c_intel snd_pcm ghash_clmulni_intel snd_timer rfkill mei_me i2c_i801 snd mei shpchp soundcore lpc_ich i2c_designware_platform dw_dmac wmi dw_dmac_core gpio_lynxpoint i2c_designware_core rtsx_usb_sdmmc rtsx_usb mfd_core i915 i2c_algo_bit drm_kms_helper drm sdhci_acpi sdhci serio_raw r8169 mmc_core mii video i2c_hid
[    6.774118] CPU: 1 PID: 103 Comm: kworker/1:1 Not tainted 4.7.0-rc3+ #40
[    6.774120] Hardware name: Acer Aspire V3-371/Aspire V3-371, BIOS V1.12 09/05/2014
[    6.774126] Workqueue: events_power_efficient rfkill_poll [rfkill]
[    6.774130]  0000000000000286 0000000025917c2d ffff880156dabd30 ffffffff813c4c93
[    6.774133]  0000000000000000 0000000000000000 ffff880156dabd70 ffffffff810a1c0b
[    6.774137]  00000ada25917c2d ffff88009ba94028 000000000000000b ffff88003fb18720
[    6.774138] Call Trace:
[    6.774145]  [<ffffffff813c4c93>] dump_stack+0x65/0x92
[    6.774149]  [<ffffffff810a1c0b>] __warn+0xcb/0xf0
[    6.774153]  [<ffffffff810a1d3d>] warn_slowpath_null+0x1d/0x20
[    6.774160]  [<ffffffffa06b8521>] ath9k_hw_gpio_get+0x161/0x1b0 [ath9k_hw]
[    6.774169]  [<ffffffffa0531333>] ath9k_rfkill_poll_state+0x33/0x60 [ath9k]
[    6.774190]  [<ffffffffa061ff4a>] ieee80211_rfkill_poll+0x2a/0x30 [mac80211]
[    6.774205]  [<ffffffffa034899a>] cfg80211_rfkill_poll+0x2a/0xf0 [cfg80211]
[    6.774208]  [<ffffffffa02ba2c4>] rfkill_poll+0x24/0x50 [rfkill]
[    6.774211]  [<ffffffff810bb70b>] process_one_work+0x15b/0x440
[    6.774213]  [<ffffffff810bba3e>] worker_thread+0x4e/0x480
[    6.774215]  [<ffffffff810bb9f0>] ? process_one_work+0x440/0x440
[    6.774217]  [<ffffffff810bb9f0>] ? process_one_work+0x440/0x440
[    6.774220]  [<ffffffff810c1668>] kthread+0xd8/0xf0
[    6.774222]  [<ffffffff8179783f>] ret_from_fork+0x1f/0x40
[    6.774225]  [<ffffffff810c1590>] ? kthread_worker_fn+0x160/0x160
[    6.774227] ---[ end trace 06d3bff20c580235 ]---
[    6.774228] ------------[ cut here ]------------
[    6.774234] WARNING: CPU: 1 PID: 103 at drivers/net/wireless/ath/ath9k/hw.c:2798 ath9k_hw_gpio_get+0xc0/0x1b0 [ath9k_hw]
[    6.774255] Modules linked in: arc4 rt2x00lib ath9k(+) crc_itu_t ath9k_common ath9k_hw mac80211 snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel snd_hda_codec x86_pkg_temp_thermal coretemp snd_hwdep kvm_intel snd_hda_core ath kvm iTCO_wdt cfg80211 vfat snd_seq fat iTCO_vendor_support acer_wmi hid_multitouch irqbypass sparse_keymap snd_seq_device crct10dif_pclmul crc32_pclmul crc32c_intel snd_pcm ghash_clmulni_intel snd_timer rfkill mei_me i2c_i801 snd mei shpchp soundcore lpc_ich i2c_designware_platform dw_dmac wmi dw_dmac_core gpio_lynxpoint i2c_designware_core rtsx_usb_sdmmc rtsx_usb mfd_core i915 i2c_algo_bit drm_kms_helper drm sdhci_acpi sdhci serio_raw r8169 mmc_core mii video i2c_hid
[    6.774257] CPU: 1 PID: 103 Comm: kworker/1:1 Tainted: G        W       4.7.0-rc3+ #40
[    6.774258] Hardware name: Acer Aspire V3-371/Aspire V3-371, BIOS V1.12 09/05/2014
[    6.774261] Workqueue: events_power_efficient rfkill_poll [rfkill]
[    6.774263]  0000000000000286 0000000025917c2d ffff880156dabd30 ffffffff813c4c93
[    6.774264]  0000000000000000 0000000000000000 ffff880156dabd70 ffffffff810a1c0b
[    6.774266]  00000aee25917c2d ffff88009ba94028 000000000000000b ffff88003fb18720
[    6.774266] Call Trace:
[    6.774269]  [<ffffffff813c4c93>] dump_stack+0x65/0x92
[    6.774271]  [<ffffffff810a1c0b>] __warn+0xcb/0xf0
[    6.774273]  [<ffffffff810a1d3d>] warn_slowpath_null+0x1d/0x20
[    6.774279]  [<ffffffffa06b8480>] ath9k_hw_gpio_get+0xc0/0x1b0 [ath9k_hw]
[    6.774285]  [<ffffffffa0531333>] ath9k_rfkill_poll_state+0x33/0x60 [ath9k]
[    6.774304]  [<ffffffffa061ff4a>] ieee80211_rfkill_poll+0x2a/0x30 [mac80211]
[    6.774322]  [<ffffffffa034899a>] cfg80211_rfkill_poll+0x2a/0xf0 [cfg80211]
[    6.774326]  [<ffffffffa02ba2c4>] rfkill_poll+0x24/0x50 [rfkill]
[    6.774332]  [<ffffffff810bb70b>] process_one_work+0x15b/0x440
[    6.774335]  [<ffffffff810bba3e>] worker_thread+0x4e/0x480
[    6.774339]  [<ffffffff810bb9f0>] ? process_one_work+0x440/0x440
[    6.774343]  [<ffffffff810bb9f0>] ? process_one_work+0x440/0x440
[    6.774347]  [<ffffffff810c1668>] kthread+0xd8/0xf0
[    6.774351]  [<ffffffff8179783f>] ret_from_fork+0x1f/0x40
[    6.774355]  [<ffffffff810c1590>] ? kthread_worker_fn+0x160/0x160
[    6.774376] ---[ end trace 06d3bff20c580236 ]---

This is Acer Aspire V13 laptop and the device in question looks like
below. Any ideas?

I did not yet bisect this but I can do that if needed. Probably has
something to do with commit a01ab81b09c55025365c1de1345b941a18e05529
("ath9k: define correct GPIO numbers and bits mask") and related.

Thanks.

02:00.0 Network controller: Qualcomm Atheros AR9462 Wireless Network Adapter (rev 01)
	Subsystem: Lite-On Communications Inc Device 0802
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at b0500000 (64-bit, non-prefetchable) [size=512K]
	Expansion ROM at b0580000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP+ Rollover- Timeout+ NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: ath9k
	Kernel modules: ath9k
