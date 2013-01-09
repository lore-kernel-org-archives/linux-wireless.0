Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:60930 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817Ab3AIFe0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 00:34:26 -0500
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: intermittent disconnect, BCM4321, kernel 3.7.1-5 debug, firmware 666.2
Message-Id: <4FB33A16-0A62-47ED-BE6B-E22FE32AE646@colorremedies.com> (sfid-20130109_063431_544323_3ABF88C5)
Date: Tue, 8 Jan 2013 22:34:23 -0700
To: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless g intermittantly disconnects periodically in linux, but not in OS X either in g or n mode. It's not reproducible on command, but I do get a consistent "possible circular locking dependency detected" message with the debug kernel that coincides with transition from multi-user.target to graphical.target that also involves a temporary drop out in the network connection. I have tried it with various 3.5 and 3.6 kernels with the same issue so this is not a regression.

Any suggestions? Or more information needed? If not, it's OK, it's mostly useable. Some details follow.



Router

Linksys WRT600N v1.1  using DD-WRT v24-sp2 (06/08/12) mini-usb-ftp - build 19342
G-Only mode
Auto channel
WPA2 Personal - AES




Firmware

Jan 09 04:48:48 f18s kernel: b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)




journalctl entry when transitioning from text to graphical boot

Jan 08 21:56:55 f18s NetworkManager[646]: <info> wpa_supplicant stopped
Jan 08 21:56:55 f18s NetworkManager[646]: <info> (wlan0): supplicant interface state: completed -> down
Jan 08 21:56:55 f18s NetworkManager[646]: <info> (wlan0): device state change: activated -> unavailable (reason 'supplicant-failed') [100 20 10]
Jan 08 21:56:55 f18s dbus[690]: [system] Activating via systemd: service name='fi.w1.wpa_supplicant1' unit='wpa_supplicant.service'
Jan 08 21:56:56 f18s kernel: cfg80211: Calling CRDA to update world regulatory domain
Jan 08 21:56:56 f18s dbus-daemon[690]: dbus[690]: [system] Activating via systemd: service name='fi.w1.wpa_supplicant1' unit='wpa_supplicant.servic
Jan 08 21:56:55 f18s systemd[1]: Stopped Bluetooth service.
Jan 08 21:56:56 f18s kernel: cfg80211: World regulatory domain updated:
Jan 08 21:56:56 f18s kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan 08 21:56:56 f18s kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 08 21:56:56 f18s alsactl[1279]: Found hardware: "HDA-Intel" "Realtek ALC889A" "HDA:10ec0885,106b3800,00100103" "0x106b" "0x00a3"
Jan 08 21:56:56 f18s alsactl[1279]: Hardware is initialized using a generic method
Jan 08 21:56:56 f18s kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan 08 21:56:56 f18s kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan 08 21:56:56 f18s kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 08 21:56:56 f18s kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 08 21:56:56 f18s kernel: 
Jan 08 21:56:56 f18s swapon[1288]: swapon: /dev/dm-1: swapon failed: Device or resource busy
Jan 08 21:56:56 f18s kernel: ======================================================
Jan 08 21:56:56 f18s kernel: [ INFO: possible circular locking dependency detected ]
Jan 08 21:56:56 f18s kernel: 3.7.1-5.fc18.x86_64.debug #1 Not tainted
Jan 08 21:56:56 f18s kernel: -------------------------------------------------------
Jan 08 21:56:56 f18s kernel: wpa_supplicant/810 is trying to acquire lock:
Jan 08 21:56:56 f18s kernel:  ((&wl->firmware_load)){+.+.+.}, at: [<ffffffff8108a525>] flush_work+0x5/0x2f0
Jan 08 21:56:56 f18s kernel: [34B blob data]
Jan 08 21:56:56 f18s kernel:  (rtnl_mutex){+.+.+.}, at: [<ffffffff815b8f87>] rtnl_lock+0x17/0x20
Jan 08 21:56:56 f18s kernel: [45B blob data]
Jan 08 21:56:56 f18s kernel: [53B blob data]
Jan 08 21:56:56 f18s kernel: [28B blob data]
Jan 08 21:56:56 f18s kernel:        [<ffffffff810d7701>] lock_acquire+0xa1/0x1f0
Jan 08 21:56:56 f18s kernel:        [<ffffffff816ebd46>] mutex_lock_nested+0x76/0x390
Jan 08 21:56:56 f18s kernel:        [<ffffffff815b8f87>] rtnl_lock+0x17/0x20
Jan 08 21:56:56 f18s kernel:        [<ffffffffa050f342>] wiphy_register+0x522/0x670 [cfg80211]
Jan 08 21:56:56 f18s kernel:        [<ffffffffa054f6c1>] ieee80211_register_hw+0x351/0x700 [mac80211]
Jan 08 21:56:56 f18s kernel:        [<ffffffffa05fc8c1>] b43_request_firmware+0x91/0x190 [b43]
Jan 08 21:56:56 f18s kernel:        [<ffffffff8108cfa7>] process_one_work+0x207/0x750
Jan 08 21:56:56 f18s kernel:        [<ffffffff8108d8ce>] worker_thread+0x15e/0x440
Jan 08 21:56:56 f18s kernel:        [<ffffffff81093c7d>] kthread+0xed/0x100
Jan 08 21:56:56 f18s kernel:        [<ffffffff816f932c>] ret_from_fork+0x7c/0xb0
Jan 08 21:56:56 f18s kernel: [38B blob data]
Jan 08 21:56:56 f18s kernel:        [<ffffffff810d6f7f>] __lock_acquire+0x1aef/0x1ba0
Jan 08 21:56:56 f18s kernel:        [<ffffffff810d7701>] lock_acquire+0xa1/0x1f0
Jan 08 21:56:56 f18s kernel:        [<ffffffff8108a56c>] flush_work+0x4c/0x2f0
Jan 08 21:56:56 f18s kernel:        [<ffffffff8108df42>] __cancel_work_timer+0x92/0x100
Jan 08 21:56:56 f18s kernel:        [<ffffffff8108dfe0>] cancel_work_sync+0x10/0x20
Jan 08 21:56:56 f18s kernel:        [<ffffffffa05fd40a>] b43_wireless_core_stop+0x7a/0x230 [b43]
Jan 08 21:56:56 f18s kernel:        [<ffffffffa05fd611>] b43_op_stop+0x51/0x90 [b43]
Jan 08 21:56:56 f18s kernel:        [<ffffffffa0585c41>] ieee80211_stop_device+0x61/0x2b0 [mac80211]
Jan 08 21:56:56 f18s kernel:        [<ffffffffa0569041>] ieee80211_do_stop+0x2a1/0x910 [mac80211]
Jan 08 21:56:56 f18s kernel:        [<ffffffffa05696ca>] ieee80211_stop+0x1a/0x20 [mac80211]
Jan 08 21:56:56 f18s kernel:        [<ffffffff815a2325>] __dev_close_many+0x95/0xe0
Jan 08 21:56:56 f18s kernel:        [<ffffffff815a3d08>] __dev_close+0x38/0x50
Jan 08 21:56:56 f18s kernel:        [<ffffffff815ac101>] __dev_change_flags+0xa1/0x180
Jan 08 21:56:56 f18s kernel:        [<ffffffff815ac298>] dev_change_flags+0x28/0x70
Jan 08 21:56:56 f18s kernel:        [<ffffffff816277d9>] devinet_ioctl+0x679/0x790
Jan 08 21:56:56 f18s kernel:        [<ffffffff81627a95>] inet_ioctl+0x75/0x90
Jan 08 21:56:56 f18s kernel:        [<ffffffff8158ad60>] sock_do_ioctl+0x30/0x70
Jan 08 21:56:56 f18s kernel:        [<ffffffff8158ae1d>] sock_ioctl+0x7d/0x2c0
Jan 08 21:56:56 f18s kernel:        [<ffffffff811e3949>] do_vfs_ioctl+0x99/0x5a0
Jan 08 21:56:56 f18s kernel:        [<ffffffff811e3ee1>] sys_ioctl+0x91/0xb0
Jan 08 21:56:56 f18s kernel:        [<ffffffff816f93d9>] system_call_fastpath+0x16/0x1b
Jan 08 21:56:56 f18s kernel: [43B blob data]
Jan 08 21:56:56 f18s kernel: [35B blob data]
Jan 08 21:56:56 f18s kernel:        CPU0                    CPU1
Jan 08 21:56:56 f18s kernel:        ----                    ----
Jan 08 21:56:56 f18s kernel:   lock(rtnl_mutex);
Jan 08 21:56:56 f18s kernel:                                lock((&wl->firmware_load));
Jan 08 21:56:56 f18s kernel:                                lock(rtnl_mutex);
Jan 08 21:56:56 f18s kernel:   lock((&wl->firmware_load));
Jan 08 21:56:56 f18s kernel: [19B blob data]
Jan 08 21:56:56 f18s kernel: 1 lock held by wpa_supplicant/810:
Jan 08 21:56:56 f18s kernel:  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff815b8f87>] rtnl_lock+0x17/0x20
Jan 08 21:56:56 f18s kernel: [17B blob data]
Jan 08 21:56:56 f18s kernel: Pid: 810, comm: wpa_supplicant Not tainted 3.7.1-5.fc18.x86_64.debug #1
Jan 08 21:56:56 f18s kernel: Call Trace:
Jan 08 21:56:56 f18s kernel:  [<ffffffff816e3c6d>] print_circular_bug+0x1fb/0x20c
Jan 08 21:56:56 f18s kernel:  [<ffffffff810d6f7f>] __lock_acquire+0x1aef/0x1ba0
Jan 08 21:56:56 f18s kernel:  [<ffffffff810d7701>] lock_acquire+0xa1/0x1f0
Jan 08 21:56:56 f18s kernel:  [<ffffffff8108a525>] ? flush_work+0x5/0x2f0
Jan 08 21:56:56 f18s kernel:  [<ffffffff8108a56c>] flush_work+0x4c/0x2f0
Jan 08 21:56:56 f18s kernel:  [<ffffffff8108a525>] ? flush_work+0x5/0x2f0
Jan 08 21:56:56 f18s kernel:  [<ffffffff810d276f>] ? lock_release_holdtime.part.26+0xf/0x180
Jan 08 21:56:56 f18s kernel:  [<ffffffff810d8102>] ? mark_held_locks+0xb2/0x130
Jan 08 21:56:56 f18s kernel:  [<ffffffff8107b3e8>] ? del_timer+0x68/0x80
Jan 08 21:56:56 f18s kernel:  [<ffffffff8108df2f>] ? __cancel_work_timer+0x7f/0x100
Jan 08 21:56:56 f18s kernel:  [<ffffffff8108df42>] __cancel_work_timer+0x92/0x100
Jan 08 21:56:56 f18s kernel:  [<ffffffff8108dfe0>] cancel_work_sync+0x10/0x20
Jan 08 21:56:56 f18s kernel:  [<ffffffffa05fd40a>] b43_wireless_core_stop+0x7a/0x230 [b43]
Jan 08 21:56:56 f18s kernel:  [<ffffffffa05fd611>] b43_op_stop+0x51/0x90 [b43]
Jan 08 21:56:56 f18s kernel:  [<ffffffffa0585c41>] ieee80211_stop_device+0x61/0x2b0 [mac80211]
Jan 08 21:56:56 f18s kernel:  [<ffffffffa0569041>] ieee80211_do_stop+0x2a1/0x910 [mac80211]
Jan 08 21:56:56 f18s kernel:  [<ffffffff815cc6c1>] ? dev_deactivate_many+0x221/0x2e0
Jan 08 21:56:56 f18s kernel:  [<ffffffffa05696ca>] ieee80211_stop+0x1a/0x20 [mac80211]
Jan 08 21:56:56 f18s kernel:  [<ffffffff815a2325>] __dev_close_many+0x95/0xe0
Jan 08 21:56:56 f18s kernel:  [<ffffffff815a3d08>] __dev_close+0x38/0x50
Jan 08 21:56:56 f18s kernel:  [<ffffffff815ac101>] __dev_change_flags+0xa1/0x180
Jan 08 21:56:56 f18s kernel:  [<ffffffff815ac298>] dev_change_flags+0x28/0x70
Jan 08 21:56:56 f18s kernel:  [<ffffffff816277d9>] devinet_ioctl+0x679/0x790
Jan 08 21:56:56 f18s kernel:  [<ffffffff81627a95>] inet_ioctl+0x75/0x90
Jan 08 21:56:56 f18s kernel:  [<ffffffff8158ad60>] sock_do_ioctl+0x30/0x70
Jan 08 21:56:56 f18s kernel:  [<ffffffff8158ae1d>] sock_ioctl+0x7d/0x2c0
Jan 08 21:56:56 f18s kernel:  [<ffffffff812e5852>] ? inode_has_perm.isra.48.constprop.61+0x62/0xa0
Jan 08 21:56:56 f18s kernel:  [<ffffffff811e3949>] do_vfs_ioctl+0x99/0x5a0
Jan 08 21:56:56 f18s kernel:  [<ffffffff812e5927>] ? file_has_perm+0x97/0xb0
Jan 08 21:56:56 f18s kernel:  [<ffffffff811e3ee1>] sys_ioctl+0x91/0xb0
Jan 08 21:56:56 f18s kernel:  [<ffffffff813580de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Jan 08 21:56:56 f18s kernel:  [<ffffffff816f93d9>] system_call_fastpath+0x16/0x1b
Jan 08 21:56:56 f18s kernel: irq/16-b43 (800) used greatest stack depth: 2704 bytes left



kernel

3.7.1-5.fc18.x86_64.debug #1 SMP Tue Jan 8 16:12:36 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux


lspci

0b:00.0 Network controller: Broadcom Corporation BCM4321 802.11a/b/g/n (rev 05)
	Subsystem: Apple Inc. Device 008c
	Physical Slot: 4
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d7300000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
	Capabilities: [58] Vendor Specific Information: Len=78 <?>
	Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 8b-73-c2-ff-ff-b9-00-1e
	Capabilities: [16c v1] Power Budgeting <?>
	Kernel driver in use: b43-pci-bridge




Chris Murphy

