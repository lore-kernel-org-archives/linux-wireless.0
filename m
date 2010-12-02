Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63496 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab0LBUug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 15:50:36 -0500
Received: by fxm20 with SMTP id 20so1550754fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 12:50:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimNkq6p2PmRM2Dx+Syk1-YOu4dkKp7rtFRzR0Bd@mail.gmail.com>
References: <AANLkTim4w0F4CS-yR_=EhSbPEDvWLN=7hu0VdQwegsgC@mail.gmail.com> <AANLkTimNkq6p2PmRM2Dx+Syk1-YOu4dkKp7rtFRzR0Bd@mail.gmail.com>
From: Joshua Boyd <boydjd@jbip.net>
Date: Thu, 2 Dec 2010 15:50:14 -0500
Message-ID: <AANLkTimM83-pTdG8GgyZ6_j3cGaCnGzX8Rhay34LUGYf@mail.gmail.com>
Subject: Re: Kernel oops on loading of iwlagn on 2.6.34.7-61.fc13.x86_64 #1 SMP
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whoops, the formatting of this is awful. Lets fix it:

I get the following kernel oops using an Intel 5300 AGN when trying
compat-wireless-2010-12-02:

Compat-wireless backport release: compat-wireless-2010-11-23-7-g813c0e6
Backport based on linux-next.git next-20101202
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
iwlagn: Copyright(c) 2003-2010 Intel Corporation
------------[ cut here ]------------
kernel BUG at /root/compat-wireless-2010-12-02/net/mac80211/main.c:540!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/module/rfkill/initstate
CPU 1
Modules linked in: iwlagn(+) iwlcore mac80211 cfg80211 compat fuse
deflate zlib_deflate ctr camellia cast5 rmd160 crypto_null ccm serpent
blowfish twofish_x86_64 twofish_common xcbc cbc sha256_generic
sha512_generic des_generic aes_x86_64 aes_generic ah6 ah4 esp6 esp4
xfrm4_mode_beet xfrm4_tunnel tunnel4 xfrm4_mode_tunnel
xfrm4_mode_transport xfrm6_mode_transport xfrm6_mode_ro
xfrm6_mode_beet xfrm6_mode_tunnel ipcomp ipcomp6 xfrm_ipcomp
xfrm6_tunnel tunnel6 af_key vboxnetadp vboxnetflt vboxdrv sunrpc
cpufreq_ondemand acpi_cpufreq freq_table ip6t_REJECT nf_conntrack_ipv6
ip6table_filter ip6_tables be2iscsi bnx2i cnic uio cxgb3i cxgb3 mdio
ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6
iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi uinput arc4 ecb
snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm snd_timer thinkpad_acpi microcode joydev snd
rfkill iTCO_wdt e1000e i2c_i801 iTCO_vendor_support soundcore wmi
snd_page_alloc firewire_ohci yenta_socket rsrc_nonstatic firewire_core
crc_itu_t ata_generic pata_acpi i915 drm_kms_helper drm i2c_algo_bit
i2c_core video output [last unloaded: bluetooth]
Pid: 15140, comm: modprobe Not tainted 2.6.34.7-61.fc13.x86_64 #1
2765T6U/2765T6U
RIP: 0010:[<ffffffffa07b824f>]  [<ffffffffa07b824f>]
ieee80211_alloc_hw+0xba/0x3b6 [mac80211]
RSP: 0018:ffff8802317edc78  EFLAGS: 00010246
RAX: ffff8801bb041ae0 RBX: ffff8801bb040460 RCX: 0000000000000000
RDX: ffff8801ea733188 RSI: ffffffffa07ae93c RDI: ffff8801bb0400c0
RBP: ffff8802317edc98 R08: ffff8801bb040000 R09: 0000ffffffffff0a
R10: 0000000000000000 R11: ffff8802317edbf8 R12: ffff8801bb040180
R13: ffffffffa084fca0 R14: 00000000ffffffff R15: ffffffffa08509a0
FS:  00007f3fae5ed700(0000) GS:ffff880002080000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f3fae3a500f CR3: 000000020b019000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 15140, threadinfo ffff8802317ec000, task
ffff880209665dc0)
Stack:
 ffff8802317edc98 ffff880232e41000 ffffffffa08509a0 ffff880232e41000
<0> ffff8802317edcb8 ffffffffa07fa71e ffff880232e41000 00000000fffffff4
<0> ffff8802317edd18 ffffffffa0838e34 ffff880232e52558 ffff880232e410a0
Call Trace:
 [<ffffffffa07fa71e>] iwl_alloc_all+0x19/0x44 [iwlcore]
 [<ffffffffa0838e34>] iwl_pci_probe+0x77/0xcb4 [iwlagn]
 [<ffffffff8120d6ad>] ? kobject_get+0x1a/0x22
 [<ffffffff8122412d>] local_pci_probe+0x17/0x1b
 [<ffffffff812250a0>] pci_device_probe+0xcd/0xfd
 [<ffffffff812c3aaf>] ? driver_sysfs_add+0x4c/0x71
 [<ffffffff812c3c7e>] driver_probe_device+0xea/0x217
 [<ffffffff812c3e08>] __driver_attach+0x5d/0x81
 [<ffffffff812c3dab>] ? __driver_attach+0x0/0x81
 [<ffffffff812c30a4>] bus_for_each_dev+0x53/0x88
 [<ffffffff812c3a0e>] driver_attach+0x1e/0x20
 [<ffffffff812c33a2>] bus_add_driver+0x11d/0x282
 [<ffffffff812c4109>] driver_register+0x9e/0x10f
 [<ffffffff812252cc>] __pci_register_driver+0x58/0xc8
 [<ffffffffa03a9000>] ? iwl_init+0x0/0x7b [iwlagn]
 [<ffffffffa03a905c>] iwl_init+0x5c/0x7b [iwlagn]
 [<ffffffffa03a9000>] ? iwl_init+0x0/0x7b [iwlagn]
 [<ffffffff81002069>] do_one_initcall+0x5e/0x159
 [<ffffffff8107cfff>] sys_init_module+0xd6/0x237
 [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
Code: 0b eb fe 49 83 7d 30 00 75 04 0f 0b eb fe 49 83 7d 18 00 75 04
0f 0b eb fe 49 83 7d 28 00 75 04 0f 0b eb fe 49 83 7d 48 00 75 04 <0f>
0b eb fe 4c 89 6b 60 66 c7 43 58 01 00 49 8d bc 24 88 0e 00
RIP  [<ffffffffa07b824f>] ieee80211_alloc_hw+0xba/0x3b6 [mac80211]
 RSP <ffff8802317edc78>
---[ end trace d39ed8c7a9907b0a ]---

[jdb@carbine ~]$ uname -ar
Linux carbine 2.6.34.7-61.fc13.x86_64 #1 SMP Tue Oct 19 04:06:30 UTC
2010 x86_64 x86_64 x86_64 GNU/Linux


Run after removing the offending new iwlagn:

[jdb@carbine ~]$ su -c 'lspci -vvv -s 03:00.0'
Password:
03:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300
Subsystem: Intel Corporation Device 1011
Physical Slot: 1
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 35
Region 0: Memory at f4300000 (64-bit, non-prefetchable) [size=8K]
Capabilities: [c8] Power Management version 3
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0300c  Data: 4122
Capabilities: [e0] Express (v1) Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<128ns, L1 <32us
ClockPM+ Surprise- LLActRep- BwNot-
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [140 v1] Device Serial Number 00-21-6a-ff-ff-0e-07-94
Kernel driver in use: iwlagn
Kernel modules: iwlagn

-- 
Joshua Boyd
JBipNet

E-mail: boydjd@jbip.net

http://www.jbip.net
