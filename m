Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:36101 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbbEAIT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2015 04:19:56 -0400
Message-ID: <55433729.5010802@broadcom.com> (sfid-20150501_102009_961634_2931A948)
Date: Fri, 1 May 2015 10:19:53 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: <mhornung.linux@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac: kernel oops on Macbook Pro 12,1 (Early 2015)
References: <20150430193259.GA5630@googlemail.com>
In-Reply-To: <20150430193259.GA5630@googlemail.com>
Content-Type: multipart/mixed;
	boundary="------------080804040107000509010807"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------080804040107000509010807
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 04/30/15 21:33, mhornung.linux@gmail.com wrote:
> Hello,
>
> I am running Arch Linux on a Macbook Pro 12,1 Retina (Early 2015) and
> get kernel oopses related to the brcmfmac module. The oopses occur
> when I am downloading multiple files from the internet, e.g. when
> running "git clone git://git.kernel.org/..." or"pacman -Syu". The problem
> occured on vanilla kernels 3.19.3 and 4.0.1 and on distro kernels
> 3.19.3-3 and 4.0.1-1.
>
> The access point the notebook is connected to is a FRITZ!Box 6340 Cable,
> running on channel 6 in the 2.4 GHz band. I am running wpa_supplicant
> and NetworkManager (nm-applet).
>
> Please find following the output of "lspci -vvnn | grep -A 60 Network" and
> the oops message while running the following command on kernel vanilla kernel 4.0.1:
>
> "git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
>
> -------------------------------------------------------------------------
> lspci -vvnn | grep -A 60 Network
> -------------------------------------------------------------------------
>
> 03:00.0 Network controller [0280]: Broadcom Corporation BCM43602 802.11ac Wireless LAN SoC [14e4:43ba] (rev 01)
> 	Subsystem: Apple Inc. Device [106b:0133]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
> 	Latency: 0, Cache Line Size: 256 bytes
> 	Interrupt: pin A routed to IRQ 62
> 	Region 0: Memory at c1400000 (64-bit, non-prefetchable) [size=32K]
> 	Region 2: Memory at c1000000 (64-bit, non-prefetchable) [size=4M]
> 	Capabilities: [48] Power Management version 3
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
> 	Capabilities: [58] MSI: Enable+ Count=1/16 Maskable- 64bit+
> 		Address: 00000000fee00598  Data: 0000
> 	Capabilities: [68] Vendor Specific Information: Len=44<?>
> 	Capabilities: [ac] Express (v2) Endpoint, MSI 00
> 		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s<4us, L1 unlimited
> 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
> 			MaxPayload 128 bytes, MaxReadReq 1024 bytes
> 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s<2us, L1<32us
> 			ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
> 		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
> 			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
> 		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR+, OBFF Via WAKE#
> 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabled
> 		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
> 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> 			 Compliance De-emphasis: -6dB
> 		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
> 			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> 	Capabilities: [100 v1] Advanced Error Reporting
> 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> 		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
> 	Capabilities: [13c v1] Device Serial Number 89-cd-37-ff-ff-e9-d0-a6
> 	Capabilities: [150 v1] Power Budgeting<?>
> 	Capabilities: [160 v1] Virtual Channel
> 		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
> 		Arb:	Fixed- WRR32- WRR64- WRR128-
> 		Ctrl:	ArbSelect=Fixed
> 		Status:	InProgress-
> 		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> 			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> 			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
> 			Status:	NegoPending- InProgress-
> 	Capabilities: [1b0 v1] Latency Tolerance Reporting
> 		Max snoop latency: 3145728ns
> 		Max no snoop latency: 3145728ns
> 	Capabilities: [220 v1] #15
> 	Capabilities: [240 v1] L1 PM Substates
> 		L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
> 			  PortCommonModeRestoreTime=0us PortTPowerOnTime=50us
> 	Kernel driver in use: brcmfmac
>
> -------------------------------------------------------------------------
> Oops on "heavy" load (git clone linux-stable):
> -------------------------------------------------------------------------
> Apr 30 21:12:51 discordia kernel: brcmfmac: brcmf_msgbuf_get_pktid: Invalid packet id 273 (not in use)
> Apr 30 21:12:51 discordia kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
> Apr 30 21:12:51 discordia kernel: IP: [<ffffffff8145b225>] skb_pull+0x5/0x50
> Apr 30 21:12:51 discordia kernel: PGD 0
> Apr 30 21:12:51 discordia kernel: Oops: 0000 [#1] PREEMPT SMP
> Apr 30 21:12:51 discordia kernel: Modules linked in: pci_stub vboxpci(O) vboxnetflt(O) vboxnetadp(O) vboxdrv(O) snd_hda_codec_hdmi bnep mousedev hid_generic us
> Apr 30 21:12:51 discordia kernel:  hwmon msr ext4 crc16 mbcache jbd2 sd_mod uas usb_storage ahci libahci libata scsi_mod xhci_pci xhci_hcd usbcore usb_common [
> Apr 30 21:12:51 discordia kernel: CPU: 0 PID: 1661 Comm: irq/61-brcmf_pc Tainted: G           O    4.0.1-MacbookPro-ARCH #1
> Apr 30 21:12:51 discordia kernel: Hardware name: Apple Inc. MacBookPro12,1/Mac-E43C1C25D4880AD6, BIOS MBP121.88Z.0167.B02.1503241251 03/24/2015
> Apr 30 21:12:51 discordia kernel: task: ffff880264203cc0 ti: ffff88025ffe4000 task.ti: ffff88025ffe4000
> Apr 30 21:12:51 discordia kernel: RIP: 0010:[<ffffffff8145b225>]  [<ffffffff8145b225>] skb_pull+0x5/0x50
> Apr 30 21:12:51 discordia kernel: RSP: 0018:ffff88025ffe7d40  EFLAGS: 00010202
> Apr 30 21:12:51 discordia kernel: RAX: 0000000000000000 RBX: ffff88008a33c000 RCX: 0000000000000044
> Apr 30 21:12:51 discordia kernel: RDX: 0000000000000000 RSI: 000000000000004a RDI: 0000000000000000
> Apr 30 21:12:51 discordia kernel: RBP: ffff88025ffe7da8 R08: 0000000000000096 R09: 000000000000004a
> Apr 30 21:12:51 discordia kernel: R10: 0000000000000000 R11: 000000000000048e R12: ffff88025ff14f00
> Apr 30 21:12:51 discordia kernel: R13: 0000000000000000 R14: ffff880263b48200 R15: ffff88008a33c000
> Apr 30 21:12:51 discordia kernel: FS:  0000000000000000(0000) GS:ffff88026ec00000(0000) knlGS:0000000000000000
> Apr 30 21:12:51 discordia kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Apr 30 21:12:51 discordia kernel: CR2: 0000000000000080 CR3: 000000000180b000 CR4: 00000000003407f0
> Apr 30 21:12:51 discordia kernel: Stack:
> Apr 30 21:12:51 discordia kernel:  ffffffffa06aed74 ffff88025ffe7dc8 ffff880263b48270 ffff880263b48278
> Apr 30 21:12:51 discordia kernel:  05ea88020000004a 0002ffff81014635 000000001720b2f6 ffff88026ec116c0
> Apr 30 21:12:51 discordia kernel:  ffff880263b48200 0000000000010000 ffff880263b4ae00 ffff880264203cc0
> Apr 30 21:12:51 discordia kernel: Call Trace:
> Apr 30 21:12:51 discordia kernel:  [<ffffffffa06aed74>] ? brcmf_msgbuf_process_rx+0x404/0x480 [brcmfmac]
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810cea60>] ? irq_finalize_oneshot.part.30+0xf0/0xf0
> Apr 30 21:12:51 discordia kernel:  [<ffffffffa06afb55>] brcmf_proto_msgbuf_rx_trigger+0x35/0xf0 [brcmfmac]
> Apr 30 21:12:51 discordia kernel:  [<ffffffffa06baf2a>] brcmf_pcie_isr_thread_v2+0x8a/0x130 [brcmfmac]
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810cea80>] irq_thread_fn+0x20/0x50
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810ceddf>] irq_thread+0x13f/0x170
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810cebf0>] ? wake_threads_waitq+0x30/0x30
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810ceca0>] ? irq_thread_dtor+0xb0/0xb0
> Apr 30 21:12:51 discordia kernel:  [<ffffffff81092a08>] kthread+0xd8/0xf0
> Apr 30 21:12:51 discordia kernel:  [<ffffffff81092930>] ? kthread_create_on_node+0x1c0/0x1c0
> Apr 30 21:12:51 discordia kernel:  [<ffffffff8156d898>] ret_from_fork+0x58/0x90
> Apr 30 21:12:51 discordia kernel:  [<ffffffff81092930>] ? kthread_create_on_node+0x1c0/0x1c0
> Apr 30 21:12:51 discordia kernel: Code: 01 83 e2 f7 88 50 01 48 83 c4 08 5b 5d f3 c3 0f 1f 80 00 00 00 00 83 e2 f7 88 50 01 c3 66 0f 1f 84 00 00 00 00 00 0f 1f
> Apr 30 21:12:51 discordia kernel: RIP  [<ffffffff8145b225>] skb_pull+0x5/0x50
> Apr 30 21:12:51 discordia kernel:  RSP<ffff88025ffe7d40>
> Apr 30 21:12:51 discordia kernel: CR2: 0000000000000080
> Apr 30 21:12:51 discordia kernel: ---[ end trace b074c0f90e7c997d ]---
> Apr 30 21:12:51 discordia kernel: BUG: unable to handle kernel paging request at ffffffffffffffd8
> Apr 30 21:12:51 discordia kernel: IP: [<ffffffff81093090>] kthread_data+0x10/0x20
> Apr 30 21:12:51 discordia kernel: PGD 180e067 PUD 1810067 PMD 0
> Apr 30 21:12:51 discordia kernel: Oops: 0000 [#2] PREEMPT SMP
> Apr 30 21:12:51 discordia kernel: Modules linked in: pci_stub vboxpci(O) vboxnetflt(O) vboxnetadp(O) vboxdrv(O) snd_hda_codec_hdmi bnep mousedev hid_generic us
> Apr 30 21:12:51 discordia kernel:  hwmon msr ext4 crc16 mbcache jbd2 sd_mod uas usb_storage ahci libahci libata scsi_mod xhci_pci xhci_hcd usbcore usb_common [
> Apr 30 21:12:51 discordia kernel: CPU: 0 PID: 1661 Comm: irq/61-brcmf_pc Tainted: G      D    O    4.0.1-MacbookPro-ARCH #1
> Apr 30 21:12:51 discordia kernel: Hardware name: Apple Inc. MacBookPro12,1/Mac-E43C1C25D4880AD6, BIOS MBP121.88Z.0167.B02.1503241251 03/24/2015
> Apr 30 21:12:51 discordia kernel: task: ffff880264203cc0 ti: ffff88025ffe4000 task.ti: ffff88025ffe4000
> Apr 30 21:12:51 discordia kernel: RIP: 0010:[<ffffffff81093090>]  [<ffffffff81093090>] kthread_data+0x10/0x20
> Apr 30 21:12:51 discordia kernel: RSP: 0018:ffff88025ffe7a28  EFLAGS: 00010202
> Apr 30 21:12:51 discordia kernel: RAX: 0000000000000000 RBX: ffff880264203cc0 RCX: 000000000000c1c1
> Apr 30 21:12:51 discordia kernel: RDX: 0000000000000000 RSI: 00000000000000c1 RDI: ffff880264203cc0
> Apr 30 21:12:51 discordia kernel: RBP: ffff88025ffe7a28 R08: 0000000000000000 R09: 00000000000004b7
> Apr 30 21:12:51 discordia kernel: R10: 0000000000000000 R11: 00000000000004b7 R12: ffffffff81a4dce0
> Apr 30 21:12:51 discordia kernel: R13: ffff880264204428 R14: ffff880264203cc0 R15: 0000000000000046
> Apr 30 21:12:51 discordia kernel: FS:  0000000000000000(0000) GS:ffff88026ec00000(0000) knlGS:0000000000000000
> Apr 30 21:12:51 discordia kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Apr 30 21:12:51 discordia kernel: CR2: ffffffffffffffd8 CR3: 000000000180b000 CR4: 00000000003407f0
> Apr 30 21:12:51 discordia kernel: Stack:
> Apr 30 21:12:51 discordia kernel:  ffff88025ffe7a48 ffffffff810cec13 0000000000000000 ffffffff81a4dce0
> Apr 30 21:12:51 discordia kernel:  ffff88025ffe7a78 ffffffff81090f07 ffff880264203cc0 ffff88025ffe7ab0
> Apr 30 21:12:51 discordia kernel:  0000000000000000 0000000000000080 ffff88025ffe7af8 ffffffff81077389
> Apr 30 21:12:51 discordia kernel: Call Trace:
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810cec13>] irq_thread_dtor+0x23/0xb0
> Apr 30 21:12:51 discordia kernel:  [<ffffffff81090f07>] task_work_run+0xb7/0xf0
> Apr 30 21:12:51 discordia kernel:  [<ffffffff81077389>] do_exit+0x2f9/0xae0
> Apr 30 21:12:51 discordia kernel:  [<ffffffff8101979e>] oops_end+0x9e/0xe0
> Apr 30 21:12:51 discordia kernel:  [<ffffffff8106241b>] no_context+0x16b/0x3a0
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810ca59c>] ? print_time.part.8+0x6c/0x90
> Apr 30 21:12:51 discordia kernel:  [<ffffffff8106277d>] __bad_area_nosemaphore+0x12d/0x250
> Apr 30 21:12:51 discordia kernel:  [<ffffffff81147d13>] ? irq_work_queue+0x73/0xa0
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810628b3>] bad_area_nosemaphore+0x13/0x20
> Apr 30 21:12:51 discordia kernel:  [<ffffffff81062d7a>] __do_page_fault+0x26a/0x4c0
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810cc333>] ? vprintk_emit+0x303/0x520
> Apr 30 21:12:51 discordia kernel:  [<ffffffff81062ff2>] do_page_fault+0x22/0x30
> Apr 30 21:12:51 discordia kernel:  [<ffffffff8156f8e8>] page_fault+0x28/0x30
> Apr 30 21:12:51 discordia kernel:  [<ffffffff8145b225>] ? skb_pull+0x5/0x50
> Apr 30 21:12:51 discordia kernel:  [<ffffffffa06aed74>] ? brcmf_msgbuf_process_rx+0x404/0x480 [brcmfmac]
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810cea60>] ? irq_finalize_oneshot.part.30+0xf0/0xf0
> Apr 30 21:12:51 discordia kernel:  [<ffffffffa06afb55>] brcmf_proto_msgbuf_rx_trigger+0x35/0xf0 [brcmfmac]
> Apr 30 21:12:51 discordia kernel:  [<ffffffffa06baf2a>] brcmf_pcie_isr_thread_v2+0x8a/0x130 [brcmfmac]
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810cea80>] irq_thread_fn+0x20/0x50
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810ceddf>] irq_thread+0x13f/0x170
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810cebf0>] ? wake_threads_waitq+0x30/0x30
> Apr 30 21:12:51 discordia kernel:  [<ffffffff810ceca0>] ? irq_thread_dtor+0xb0/0xb0
> Apr 30 21:12:51 discordia kernel:  [<ffffffff81092a08>] kthread+0xd8/0xf0
> Apr 30 21:12:51 discordia kernel:  [<ffffffff81092930>] ? kthread_create_on_node+0x1c0/0x1c0
> Apr 30 21:12:51 discordia kernel:  [<ffffffff8156d898>] ret_from_fork+0x58/0x90
> Apr 30 21:12:51 discordia kernel:  [<ffffffff81092930>] ? kthread_create_on_node+0x1c0/0x1c0
> Apr 30 21:12:51 discordia kernel: Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 20 05 00 00 55
> Apr 30 21:12:51 discordia kernel: RIP  [<ffffffff81093090>] kthread_data+0x10/0x20
> Apr 30 21:12:51 discordia kernel:  RSP<ffff88025ffe7a28>
> Apr 30 21:12:51 discordia kernel: CR2: ffffffffffffffd8
> Apr 30 21:12:51 discordia kernel: ---[ end trace b074c0f90e7c997e ]---
> Apr 30 21:12:51 discordia kernel: Fixing recursive fault but reboot is needed!
> Apr 30 21:12:57 discordia kernel: brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
> Apr 30 21:12:57 discordia kernel: brcmfmac: brcmf_cfg80211_get_station: Could not get rate (-52)
> Apr 30 21:12:59 discordia kernel: brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
> Apr 30 21:12:59 discordia kernel: brcmfmac: brcmf_cfg80211_get_station: Could not get rate (-52)
> Apr 30 21:13:01 discordia kernel: brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
> Apr 30 21:13:01 discordia kernel: brcmfmac: brcmf_cfg80211_get_station: Could not get rate (-52)
> Apr 30 21:13:03 discordia kernel: brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
> Apr 30 21:13:03 discordia kernel: brcmfmac: brcmf_cfg80211_get_station: Could not get rate (-52)
> Apr 30 21:13:05 discordia kernel: brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
> Apr 30 21:13:05 discordia kernel: brcmfmac: brcmf_cfg80211_get_station: Could not get rate (-52)
> Apr 30 21:13:07 discordia kernel: brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
> Apr 30 21:13:07 discordia kernel: brcmfmac: brcmf_cfg80211_get_station: Could not get rate (-52)
> Apr 30 21:13:09 discordia kernel: brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
> Apr 30 21:13:09 discordia kernel: brcmfmac: brcmf_cfg80211_get_station: Could not get rate (-52)
> Apr 30 21:13:11 discordia kernel: brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
> Apr 30 21:13:11 discordia kernel: brcmfmac: brcmf_cfg80211_get_station: Could not get rate (-52)
> Apr 30 21:13:13 discordia kernel: brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
> Apr 30 21:13:13 discordia kernel: brcmfmac: brcmf_cfg80211_get_station: Could not get rate (-52)
> Apr 30 21:13:15 discordia kernel: brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
> Apr 30 21:13:15 discordia kernel: brcmfmac: brcmf_cfg80211_get_station: Could not get rate (-52)
> Apr 30 21:13:17 discordia kernel: brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
> Apr 30 21:13:17 discordia kernel: brcmfmac: brcmf_cfg80211_get_station: Could not get rate (-52)
>
> -------------------------------------------------------------------------
>
> I would really appreciate any help you can give. Thank you very much in advance.

Hi Michael,

Can you try the attached patch file. I based it on stable version v4.0.1 
kernel. Let me know if it works for you.

Regards,
Arend

> With best regards
>
> Michael Hornung


--------------080804040107000509010807
Content-Type: text/plain;
	name="0001-brcmfmac-avoid-null-pointer-access-when-brcmf_msgbuf.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-brcmfmac-avoid-null-pointer-access-when-brcmf_msgbuf.pa";
	filename*1="tch"

>From c2b3fb54bf2952b0a41d13cb1df592d9aa0ecf9e Mon Sep 17 00:00:00 2001
From: Arend van Spriel <arend@broadcom.com>
Date: Fri, 1 May 2015 09:59:35 +0200
Subject: [PATCH] brcmfmac: avoid null pointer access when
 brcmf_msgbuf_get_pktid() fails

The function brcmf_msgbuf_get_pktid() may return a NULL pointer so
the callers should check the return pointer before accessing it.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 6262612..7a3231d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -512,11 +512,9 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 				     msgbuf->rx_pktids,
 				     msgbuf->ioctl_resp_pktid);
 	if (msgbuf->ioctl_resp_ret_len != 0) {
-		if (!skb) {
-			brcmf_err("Invalid packet id idx recv'd %d\n",
-				  msgbuf->ioctl_resp_pktid);
+		if (!skb)
 			return -EBADF;
-		}
+
 		memcpy(buf, skb->data, (len < msgbuf->ioctl_resp_ret_len) ?
 				       len : msgbuf->ioctl_resp_ret_len);
 	}
@@ -875,10 +873,8 @@ brcmf_msgbuf_process_txstatus(struct brcmf_msgbuf *msgbuf, void *buf)
 	flowid -= BRCMF_NROF_H2D_COMMON_MSGRINGS;
 	skb = brcmf_msgbuf_get_pktid(msgbuf->drvr->bus_if->dev,
 				     msgbuf->tx_pktids, idx);
-	if (!skb) {
-		brcmf_err("Invalid packet id idx recv'd %d\n", idx);
+	if (!skb)
 		return;
-	}
 
 	set_bit(flowid, msgbuf->txstatus_done_map);
 	commonring = msgbuf->flowrings[flowid];
@@ -1157,6 +1153,8 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 
 	skb = brcmf_msgbuf_get_pktid(msgbuf->drvr->bus_if->dev,
 				     msgbuf->rx_pktids, idx);
+	if (!skb)
+		return;
 
 	if (data_offset)
 		skb_pull(skb, data_offset);
-- 
1.9.1


--------------080804040107000509010807--
