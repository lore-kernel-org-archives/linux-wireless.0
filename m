Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:36579 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbbLTC32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2015 21:29:28 -0500
Received: by mail-ig0-f193.google.com with SMTP id rx7so2158085igc.3
        for <linux-wireless@vger.kernel.org>; Sat, 19 Dec 2015 18:29:28 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 19 Dec 2015 21:29:27 -0500
Message-ID: <CAOeNLurbw9SG6Zr1tWNfYiqg-_H0NO=7ypR26+jWJmb4Yi=jaA@mail.gmail.com> (sfid-20151220_032932_620378_60593839)
Subject: Panic in rtl8192ee on 4.2 kernel (Ubuntu 15.10)
From: Rich <rercola@acm.jhu.edu>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
(Apologies if this is the wrong place, but [1] said I should send my
report here.)

I've got a Lenovo ThinkPad T440 running Ubuntu 15.10 here, and under
load, the rtl8192ee wireless driver will panic after a few minutes.

The kernel is the Ubuntu 4.2.0-22-generic amd64 kernel.

I went looking for the current equivalent of what was formerly
compat-drivers/linux-backports-modules/compat-wireless, and will try
the new location for wireless-testing next, but wanted to forward on
the panic while doing so.

The lspci -v entry for the card:
03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8192EE
PCIe Wireless Network Adapter
Subsystem: Realtek Semiconductor Co., Ltd. Device 001b
Flags: bus master, fast devsel, latency 0, IRQ 48
I/O ports at 3000 [size=256]
Memory at f0400000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [40] Power Management version 3
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
Capabilities: [70] Express Endpoint, MSI 00
Capabilities: [100] Advanced Error Reporting
Capabilities: [140] Device Serial Number 01-91-81-fe-ff-4c-e0-00
Capabilities: [150] Latency Tolerance Reporting
Capabilities: [158] L1 PM Substates
Kernel driver in use: rtl8192ee

The panic:
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffffc058a0cf>] rtl92ee_set_desc+0x2f/0x1d0 [rtl8192ee]
PGD 0
Oops: 0000 [#1] SMP
Modules linked in: rfcomm drbg ansi_cprng ctr ccm bnep nls_iso8859_1
intel_rapl iosf_mbi x86_pkg_temp_thermal arc4 intel_powerclamp
rtl8192ee btcoexist coretemp rtl_pci rtlwifi kvm_intel kvm mac80211
btusb cfg80211 uvcvideo snd_hda_codec_hdmi btrtl btbcm btintel
crct10dif_pclmul crc32_pclmul videobuf2_vmalloc videobuf2_memops
videobuf2_core v4l2_common snd_hda_codec_realtek snd_hda_codec_generic
bluetooth snd_hda_intel videodev snd_hda_codec rtsx_pci_ms media
aesni_intel snd_hda_core thinkpad_acpi memstick aes_x86_64 lrw
gf128mul glue_helper nvram snd_seq_midi snd_hwdep snd_seq_midi_event
snd_rawmidi snd_pcm snd_seq ablk_helper snd_seq_device cryptd
snd_timer snd input_leds soundcore joydev shpchp mei_me mei serio_raw
lpc_ich mac_hid intel_smartconnect efi_pstore parport_pc ppdev lp
parport
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W
4.2.0-21-generic #25-Ubuntu
Hardware name: LENOVO 20B6CTO1WW/20B6CTO1WW, BIOS GJET64WW (2.14 ) 11/12/2013
task: ffff880119c9b700 ti: ffff880119cb0000 task.ti: ffff880119cb0000
RIP: 0010:[<ffffffffc058a0cf>]  [<ffffffffc058a0cf>]
rtl92ee_set_desc+0x2f/0x1d0 [rtl8192ee]
RSP: 0018:ffff88011f283508  EFLAGS: 00010046
RAX: ffffffffc058cf60 RBX: 0000000000000000 RCX: 0000000000000007
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800d56306a0
RBP: ffff88011f283560 R08: ffff88011f283524 R09: 0000160000000000
R10: ffffea0001993380 R11: 0000000000000000 R12: ffff8800d56306a0
R13: 0000000000000195 R14: ffff880086713100 R15: ffff8800d5631440
FS:  0000000000000000(0000) GS:ffff88011f280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000002c0c000 CR4: 00000000001406e0
Stack:
 ffffffffc054afbf ffff8800664cee00 0000000000000000 d32dc04001283560
 fdf6cd13473e1849 ffff8800b770cf00 0000000000000000 ffff880086713100
 ffff8800d56306a0 ffff880086713100 ffff8800d5631440 ffff88011f283760
Call Trace:
 <IRQ>
 [<ffffffffc054afbf>] ? _rtl_pci_init_one_rxdesc+0x1df/0x240 [rtl_pci]
 [<ffffffffc054d3a3>] _rtl_pci_rx_interrupt+0x4f3/0x790 [rtl_pci]
 [<ffffffffc054d819>] _rtl_pci_interrupt+0x1d9/0x3b1 [rtl_pci]
 [<ffffffff810d4204>] handle_irq_event_percpu+0x74/0x180
 [<ffffffff810d4359>] handle_irq_event+0x49/0x70
 [<ffffffff810d76d1>] handle_edge_irq+0x81/0x150
 [<ffffffff810172b5>] handle_irq+0x25/0x40
 [<ffffffff817f2e2f>] do_IRQ+0x4f/0xe0
 [<ffffffff817f0dab>] common_interrupt+0x6b/0x6b
 [<ffffffff81731dc1>] ? tcp_parse_md5sig_option+0x11/0x70
 [<ffffffff8174606c>] tcp_v4_rcv+0x76c/0xa70
 [<ffffffff810d42ac>] ? handle_irq_event_percpu+0x11c/0x180
 [<ffffffff8171fe14>] ip_local_deliver_finish+0xa4/0x1f0
 [<ffffffff817200e5>] ip_local_deliver+0x55/0xc0
 [<ffffffff81745899>] ? tcp_v4_early_demux+0x109/0x170
 [<ffffffff8171fab1>] ip_rcv_finish+0x81/0x340
 [<ffffffff817f0dab>] ? common_interrupt+0x6b/0x6b
 [<ffffffff817203f2>] ip_rcv+0x2a2/0x3d0
 [<ffffffff817ce6d3>] ? packet_rcv+0x43/0x400
 [<ffffffff816e4145>] __netif_receive_skb_core+0x725/0xa00
 [<ffffffff8107fadb>] ? irq_exit+0x6b/0xb0
 [<ffffffff816e4438>] __netif_receive_skb+0x18/0x60
 [<ffffffff816e44b2>] netif_receive_skb_internal+0x32/0xa0
 [<ffffffff816e453c>] netif_receive_skb_sk+0x1c/0x60
 [<ffffffffc0665f4f>] ieee80211_deliver_skb+0x11f/0x1b0 [mac80211]
 [<ffffffffc066817b>] ieee80211_rx_handlers+0xd3b/0x2460 [mac80211]
 [<ffffffff810d4364>] ? handle_irq_event+0x54/0x70
 [<ffffffff810d76d1>] ? handle_edge_irq+0x81/0x150
 [<ffffffffc0669a54>] ieee80211_prepare_and_rx_handle+0x1b4/0xa90 [mac80211]
 [<ffffffff8107fadb>] ? irq_exit+0x6b/0xb0
 [<ffffffff817f0dab>] ? common_interrupt+0x6b/0x6b
 [<ffffffffc066a618>] ieee80211_rx+0x2e8/0x8b0 [mac80211]
 [<ffffffffc0642153>] ieee80211_tasklet_handler+0xc3/0xd0 [mac80211]
 [<ffffffff8107f1af>] tasklet_action+0xdf/0x100
 [<ffffffff8107f846>] __do_softirq+0xf6/0x250
 [<ffffffff8107fb13>] irq_exit+0xa3/0xb0
 [<ffffffff817f2e38>] do_IRQ+0x58/0xe0
 [<ffffffff817f0dab>] common_interrupt+0x6b/0x6b
 <EOI>
 [<ffffffff810bd473>] ? call_cpuidle+0x33/0x60
 [<ffffffff810bd708>] ? cpu_startup_entry+0x268/0x320
 [<ffffffff8104d3d3>] start_secondary+0x183/0x1c0
Code: 00 84 d2 74 14 84 c9 74 37 80 f9 02 0f 85 79 01 00 00 41 8b 00
89 46 30 c3 80 f9 06 0f 84 6b 01 00 00 80 f9 07 0f 85 60 01 00 00 <8b>
06 25 00 40 00 80 0d 18 20 00 00 89 06 41 8b 00 89 46 04 c3
RIP  [<ffffffffc058a0cf>] rtl92ee_set_desc+0x2f/0x1d0 [rtl8192ee]
 RSP <ffff88011f283508>
CR2: 0000000000000000

I've got a vmcore from kdump weighing in at about 100 MB if that would
be useful to someone.

Please let me know if there's anything else of use I can contribute;
I'm going to go try poking around in the source after I confirm that
wireless-testing doesn't help with this, but thought I'd report it,
since I could only find one other report of someone encountering a
similar panic [2].

Thanks,
- Rich Ercolani

PS: Please CC me on any replies, as I'm not on linux-wireless.

[1] - https://wireless.wiki.kernel.org/en/users/Documentation/Reporting_bugs
[2] - https://bugs.launchpad.net/ubuntu/+source/ubuntu-release-upgrader/+bug/1527603
