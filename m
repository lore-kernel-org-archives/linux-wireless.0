Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42426 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3HPMBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 08:01:24 -0400
Received: by mail-pd0-f178.google.com with SMTP id w10so2148821pde.23
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 05:01:23 -0700 (PDT)
MIME-Version: 1.0
From: Vedant Lath <vedant@lath.in>
Date: Fri, 16 Aug 2013 17:31:03 +0530
Message-ID: <CAKajsGN5Wu88ckhPJnc8VwNe7LT+GxEU91_KQVNWaJvQ7iY7fw@mail.gmail.com> (sfid-20130816_140134_275126_D70997C8)
Subject: Kernel panic with skbuff and rtl8180 on Linux 3.10.5
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am getting kernel panics related to the rtl8180 driver. I have a
RTL8185 card in my desktop and am using debian testing with kernel
version 3.10.5.

[112535.772055] skbuff: skb_over_panic: text:ffffffffa0470850 len:2475
put:2475 head:ffff8802c72f2cc0 data:ffff8802c72f2d00 tail:0x9eb
end:0x980 dev:<NULL>
[112535.772123] ------------[ cut here ]------------
[112535.772239] kernel BUG at
/build/linux-4aFT2B/linux-3.10.5/net/core/skbuff.c:126!
[112535.772391] invalid opcode: 0000 [#1] SMP
[112535.772494] Modules linked in: snd_usb_audio snd_usbmidi_lib
usb_storage xt_TCPMSS xt_tcpmss iptable_mangle pppoe pppox parport_pc
parport nfnetlink_queue nfnetlink_log nfnetlink pci_stub vboxpci(O)
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc xt_nat xt_tcpudp
ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables ppp_generic slhc
netconsole configfs loop fuse snd_hda_codec_hdmi snd_hda_codec_realtek
arc4 snd_hda_intel acpi_cpufreq snd_hda_codec snd_hwdep mperf
processor rtl8180 kvm_amd kvm snd_seq_midi snd_pcm_oss
snd_seq_midi_event snd_mixer_oss snd_rawmidi snd_pcm sp5100_tco
mac80211 radeon cfg80211 snd_seq ttm drm_kms_helper drm asus_atk0110
edac_mce_amd thermal_sys eeprom_93cx6 snd_page_alloc snd_seq_device
edac_core rfkill i2c_algo_bit
[112535.774487]  i2c_piix4 evdev shpchp cdc_acm i2c_core k10temp
snd_timer snd wmi soundcore microcode button hid_generic usbhid hid
ext4 crc16 jbd2 mbcache sg sd_mod crc_t10dif dm_mod ahci libahci
firewire_ohci dmfe r8169 mii firewire_core crc_itu_t ehci_pci ohci_hcd
ehci_hcd libata scsi_mod usbcore usb_common [last unloaded: pcspkr]
[112535.775371] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G           O
3.10-2-amd64 #1 Debian 3.10.5-1
[112535.775545] Hardware name: System manufacturer System Product
Name/M4A89GTD-PRO, BIOS 2101    04/08/2011
[112535.775733] task: ffff88040f4fc7c0 ti: ffff88040f520000 task.ti:
ffff88040f520000
[112535.775882] RIP: 0010:[<ffffffff8138615d>]  [<ffffffff8138615d>]
skb_panic+0x5a/0x5c
[112535.776054] RSP: 0018:ffff88041fcc3e60  EFLAGS: 00010092
[112535.776163] RAX: 000000000000008b RBX: ffff88040eade660 RCX:
0000000000000000
[112535.776305] RDX: 00000000000400f6 RSI: ffff88041fccdfb8 RDI:
0000000000000046
[112535.776446] RBP: ffff88040eadf800 R08: 0000000000000004 R09:
00000000001c9674
[112535.776589] R10: ffff88040e3c5ac0 R11: 00000000c6526802 R12:
ffff88040a492cc0
[112535.776733] R13: ffff88040cdbe2c0 R14: ffff8800cf84a160 R15:
ffff88040eadf800
[112535.776878] FS:  00007fd1719db700(0000) GS:ffff88041fcc0000(0000)
knlGS:00000000f73beb40
[112535.777039] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[112535.777156] CR2: 00007f1cab7f0000 CR3: 000000040e405000 CR4:
00000000000007e0
[112535.777299] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[112535.777444] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[112535.777584] Stack:
[112535.777631]  ffff8802c72f2d00 00000000000009eb 0000000000000980
ffffffff8150b3d2
[112535.777818]  ffffffff812bb64a ffffffffa0470850 0000000000000000
ffff88041fcc3eb0
[112535.777998]  100509ab1fcc3f20 0088a9140000001f 0000000000000000
0000000000000000
[112535.778179] Call Trace:
[112535.778237]  <IRQ>
[112535.778286]
[112535.778335]  [<ffffffff812bb64a>] ? skb_put+0x3a/0x3b
[112535.778428]  [<ffffffffa0470850>] ? rtl8180_interrupt+0x14a/0x29d [rtl8180]
[112535.778581]  [<ffffffff810996fd>] ? handle_irq_event_percpu+0x49/0x1a4
[112535.778717]  [<ffffffff8109988a>] ? handle_irq_event+0x32/0x4b
[112535.778842]  [<ffffffff8109bd76>] ? handle_fasteoi_irq+0x80/0xb6
[112535.778969]  [<ffffffff8100e93e>] ? handle_irq+0x18/0x20
[112535.779082]  [<ffffffff8100e657>] ? do_IRQ+0x40/0x95
[112535.779188]  [<ffffffff813883ed>] ? common_interrupt+0x6d/0x6d
[112535.779304]  <EOI>
[112535.779354]
[112535.779403]  [<ffffffff8102e385>] ? native_safe_halt+0x2/0x3
[112535.779497]  [<ffffffff810133f6>] ? default_idle+0x17/0x3f
[112535.779612]  [<ffffffff810134cd>] ? amd_e400_idle+0xaf/0xd1
[112535.779731]  [<ffffffff81072571>] ? cpu_startup_entry+0x10d/0x187
[112535.779859]  [<ffffffff81378f4c>] ? start_secondary+0x1df/0x1e3
[112535.779979] Code: 00 00 48 89 44 24 10 8b 87 d8 00 00 00 48 89 44
24 08 48 8b 87 e8 00 00 00 48 c7 c7 e6 5d 53 81 48 89 04 24 31 c0 e8
c5 c5 ff ff <0f> 0b 0f 0b 41 55 41 54 55 53 48 89 fb 48 83 ec 28 48 8b
6f 20
[112535.780930] RIP  [<ffffffff8138615d>] skb_panic+0x5a/0x5c
[112535.781054]  RSP <ffff88041fcc3e60>

This seems weird because rtl8180 is associated with wlan0 on my system
yet the skbuff message says dev:<NULL>.

I've got kernel panics about 20 times in the last month but had not
been able to find the first oops message until now. Most of the time
the panic happened when the monitor was in sleep mode so I wasn't able
to see the oops. Other times, a useless
drm_fb_helper_restore_fbdev_mode oops hid the first oops. I then set
up kdump to get the oops. I suspect the rest of the panics have also
been due to this.

I don't have any steps to reproduce; it seems entirely random.
Sometimes it happens after weeks, sometimes within 10 minutes. There's
also zero traffic on the wlan0 interface as it is in managed mode and
not associated to any access point.

I have the full memory dump taken after the crash and an associated
vmlinux file in case we need it to troubleshoot this further.

Thanks and regards
Vedant Lath
