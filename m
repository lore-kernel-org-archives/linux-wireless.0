Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.versatel.nl ([62.58.50.88]:49476 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758212AbYDYSPR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2008 14:15:17 -0400
Subject: rt61pci current wireless testing git gives kernel oops
From: Bas Hulsken <bhulsken@hotmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 25 Apr 2008 20:10:56 +0200
Message-Id: <1209147056.2955.7.camel@Bas> (sfid-20080425_201545_149101_F42E95D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivo,

I recently obtained an rt61pci NIC, and in an attempt to find out
whether my recent hostapd problems were rt2500pci specific (remember
that?) I plugged it into the server.

the interface goes up well, but I get an oops as soon as I run hostapd,
seems something with debugfs. This shows up in dmesg, let me know if you
need any more info.

best regards,
Bas

attached: dmesg, modinfo, lspci

dmesg -----------------------------------------------------------------
Unable to handle kernel NULL pointer dereference at 0000000000000218
RIP: 
 [<ffffffff8824bd9d>] :mac80211:ieee80211_debugfs_key_add_default
+0x24/0x55
PGD bad8c067 PUD b702d067 PMD 0 
Oops: 0000 [1] SMP 
CPU 2 
Modules linked in: nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 fuse
rfcomm l2cap sunrpc rt2500pci(U) ipt_REJECT xt_multiport iptable_filter
ipt_MASQUERADE ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 ipt_TOS
iptable_mangle ip_tables nf_conntrack_ipv6 xt_state nf_conntrack
xt_tcpudp ip6t_ipv6header ip6t_REJECT ip6table_filter ip6_tables
x_tables ipv6 cpufreq_ondemand acpi_cpufreq ext2 dm_mirror dm_multipath
dm_mod wm8775 cx25840 msp3400 arc4 ecb blkcipher snd_hda_intel saa7115
snd_seq_dummy snd_seq_oss snd_seq_midi_event tuner snd_seq rt61pci(U)
rt2x00pci(U) snd_seq_device tea5767 tda8290 tuner_simple rt2x00lib(U)
mt20xx snd_pcm_oss tea5761 snd_mixer_oss snd_pcm rfkill input_polldev
rtl8187(U) mac80211(U) ivtv snd_timer snd_page_alloc snd_hwdep
cfg80211(U) i2c_algo_bit snd i2c_i801 cx2341x tveeprom videodev
firewire_ohci firewire_core crc_itu_t r8169 eeprom_93cx6(U) v4l2_common
v4l1_compat iTCO_wdt hci_usb sr_mod lirc_atiusb button i2c_core pcspkr
soundcore lirc_dev iTCO_vendor_support bluetooth sky2 cdrom sg floppy
ahci pata_jmicron ata_generic ata_piix pata_acpi libata sd_mod scsi_mod
raid456 async_xor async_memcpy async_tx xor ext3 jbd mbcache uhci_hcd
ohci_hcd ehci_hcd
Pid: 17, comm: events/2 Not tainted 2.6.24.4-64.fc8 #1
RIP: 0010:[<ffffffff8824bd9d>]
[<ffffffff8824bd9d>] :mac80211:ieee80211_debugfs_key_add_default
+0x24/0x55
RSP: 0018:ffff81012fb2de10  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8100bac66400 RCX: 00000000000000b6
RDX: ffff81012a443ea0 RSI: ffffffff88258eb7 RDI: ffff81012fb2de10
RBP: ffff81012a811700 R08: ffff81012fc09c30 R09: 0000000000000036
R10: ffffffff810b09b9 R11: ffffffff810fb05d R12: ffff81012fa53d40
R13: ffffffffffffffff R14: 0000000000000036 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff81012fc01b00(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000218 CR3: 00000000cf9fc000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process events/2 (pid: 17, threadinfo ffff81012fb2c000, task
ffff81012fb248b0)
Stack:  0000000000000036 ffff81012a443ea0 ffff81012a443ea0
ffff81012a811700
 ffff81012dfda500 ffffffff810b479f ffff810100000000 ffff81012a811700
 ffffffff8824722f ffff8100bac66400 ffffffff8824722f ffffffff88247027
Call Trace:
 [<ffffffff810b479f>] mntput_no_expire+0x1c/0x87
 [<ffffffff8824722f>] :mac80211:key_todo+0x0/0x5
 [<ffffffff8824722f>] :mac80211:key_todo+0x0/0x5
 [<ffffffff88247027>] :mac80211:__ieee80211_key_todo+0x76/0x1ed
 [<ffffffff8824722f>] :mac80211:key_todo+0x0/0x5
 [<ffffffff88247228>] :mac80211:ieee80211_key_todo+0xe/0x15
 [<ffffffff81045625>] run_workqueue+0x7f/0x10b
 [<ffffffff81045f2d>] worker_thread+0x0/0xe4
 [<ffffffff81046007>] worker_thread+0xda/0xe4
 [<ffffffff81048f1d>] autoremove_wake_function+0x0/0x2e
 [<ffffffff81048dee>] kthread+0x47/0x75
 [<ffffffff8100cca8>] child_rip+0xa/0x12
 [<ffffffff81048da7>] kthread+0x0/0x75
 [<ffffffff8100cc9e>] child_rip+0x0/0x12


Code: 8b 90 18 02 00 00 31 c0 e8 43 c0 ed f8 48 8b b5 40 04 00 00 
RIP  [<ffffffff8824bd9d>] :mac80211:ieee80211_debugfs_key_add_default
+0x24/0x55
 RSP <ffff81012fb2de10>
CR2: 0000000000000218
---[ end trace 5bf48e6dc8139959 ]---

modinfo-----------------------------------------------------------------
filename:       /lib/modules/2.6.24.4-64.fc8/updates/rt2x00/rt61pci.ko
license:        GPL
firmware:       rt2661.bin
firmware:       rt2561s.bin
firmware:       rt2561.bin
description:    Ralink RT61 PCI & PCMCIA Wireless LAN driver.
version:        2.1.4
author:         http://rt2x00.serialmonkey.com
srcversion:     FCC52B48B3074E83A77D602
alias:          pci:v00001814d00000401sv*sd*bc*sc*i*
alias:          pci:v00001814d00000302sv*sd*bc*sc*i*
alias:          pci:v00001814d00000301sv*sd*bc*sc*i*
depends:        rt2x00lib,rt2x00pci,crc-itu-t,eeprom_93cx6
vermagic:       2.6.24.4-64.fc8 SMP mod_unload 

lspci-----------------------------------------------------------------
05:01.0 Network controller: RaLink RT2561/RT61 802.11g PCI
        Subsystem: Linksys WMP54G ver 4.1
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at febf8000 (32-bit, non-prefetchable)
[size=32K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: rt61pci
        Kernel modules: rt61pci


