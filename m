Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38726 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1BAUbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 15:31:34 -0500
Received: by qyj19 with SMTP id 19so5185796qyj.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 12:31:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110201114757.GA11930@sig21.net>
References: <AANLkTik=oRjh9UHAsOOTpuOJR7OBw2HCsXd8vhHN_YJY@mail.gmail.com>
	<20110201114757.GA11930@sig21.net>
Date: Tue, 1 Feb 2011 20:31:33 +0000
Message-ID: <AANLkTi=VGu6Ysn5WkYjdmVx1+gvzywmqA1-jG5DEL3Eh@mail.gmail.com>
Subject: Re: Ralink RT2501/RT2573 USB Wireless Adapter crashes kernel 2.6.37
From: Eric Fernandez <zeb@zebulon.org.uk>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/2/1 Johannes Stezenbach <js@sig21.net>:


>
> If it still crashes, can you check dmesg for the crash messages?
>
>
> Thanks,
> Johannes
>

Hi,

this is what I get in /var/log/messages after I plug in the adapter:

Feb  1 20:22:39 localhost kernel: usb 2-2: new high speed USB device
using ehci_hcd and address 3
Feb  1 20:22:39 localhost kernel: cfg80211: Calling CRDA to update
world regulatory domain
Feb  1 20:22:39 localhost kernel: usbcore: registered new interface
driver rt2500usb
Feb  1 20:22:39 localhost kernel: PGD 154c063 PUD 1fffc067 PMD 80000000c94001e3
Feb  1 20:22:39 localhost kernel: CPU 1
Feb  1 20:22:39 localhost kernel: Modules linked in: rt73usb(+)
rt2500usb rt2x00usb rt2x00lib mac80211 cfg80211 rfkill ipv6 it87
adt7475 hwmon_vid ext3 jbd nls_cp437 vfat fat joydev usbhid hid
nvidia(P) uvcvideo videodev v4l1_compat v4l2_compat_ioctl32
snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device r8169 mii firewire_ohci
firewire_core crc_itu_t uhci_hcd ehci_hcd usbcore
snd_hda_codec_realtek shpchp pci_hotplug snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm pcspkr snd_timer snd soundcore snd_page_alloc sg
evdev processor button i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support
serio_raw ext4 mbcache jbd2 crc16 sr_mod cdrom pata_jmicron pata_acpi
sd_mod ahci libahci libata scsi_mod
Feb  1 20:22:39 localhost kernel:
Feb  1 20:22:39 localhost kernel: Pid: 7507, comm: modprobe Tainted: P
           2.6.37-ARCH #1 P55M-UD2/P55M-UD2
Feb  1 20:22:39 localhost kernel: RIP: 0010:[<ffff8800c94bcc28>]
[<ffff8800c94bcc28>] 0xffff8800c94bcc28
Feb  1 20:22:39 localhost kernel: RSP: 0018:ffff8800b6a19b20  EFLAGS: 00010286
Feb  1 20:22:39 localhost kernel: RAX: ffff8800c94bcc28 RBX:
ffff8800c1bd81a8 RCX: 0000000000000000
Feb  1 20:22:39 localhost kernel: RDX: 0000000000000000 RSI:
ffff8800c1bd81a8 RDI: ffff8800c1bd81a8
Feb  1 20:22:39 localhost kernel: RBP: ffff8800b6a19b38 R08:
0000000000000001 R09: 0000000000000000
Feb  1 20:22:39 localhost kernel: R10: 0000000000000000 R11:
0000000000000000 R12: ffff8800c94b9c30
Feb  1 20:22:39 localhost kernel: R13: ffff8800bbaf0240 R14:
ffff8800c979e2c8 R15: 0000000000000000
Feb  1 20:22:39 localhost kernel: FS:  00007f2e5b3c7700(0000)
GS:ffff8800df440000(0000) knlGS:0000000000000000
Feb  1 20:22:39 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Feb  1 20:22:39 localhost kernel: CR2: ffff8800c94bcc28 CR3:
00000000b6be9000 CR4: 00000000000006e0
Feb  1 20:22:39 localhost kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb  1 20:22:39 localhost kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb  1 20:22:39 localhost kernel: Process modprobe (pid: 7507,
threadinfo ffff8800b6a18000, task ffff880117cc29a0)
Feb  1 20:22:39 localhost kernel: ffffffff8138de74 ffff8800c94b9c30
ffff8800c1bd81a8 ffff8800b6a19b58
Feb  1 20:22:39 localhost kernel: ffffffff8138dfa2 ffff8800c979e080
ffff8800c979e090 ffff8800b6a19bd8
Feb  1 20:22:39 localhost kernel: ffffffff812ae58a ffff880000000007
0000000000000000 ffffffffa0085ea0
Feb  1 20:22:39 localhost kernel: [<ffffffff8138de74>] ?
klist_node_init+0x44/0x70
Feb  1 20:22:39 localhost kernel: [<ffffffff8138dfa2>] klist_add_tail+0x22/0x60
Feb  1 20:22:39 localhost kernel: [<ffffffff812ae58a>] device_add+0x4fa/0x5c0
Feb  1 20:22:39 localhost kernel: [<ffffffffa00846af>]
rfkill_register+0x9f/0x270 [rfkill]
Feb  1 20:22:39 localhost kernel: [<ffffffffa0cdf096>]
wiphy_register+0x246/0x340 [cfg80211]
Feb  1 20:22:39 localhost kernel: [<ffffffff81127e2b>] ? __kmalloc+0x19b/0x280
Feb  1 20:22:39 localhost kernel: [<ffffffffa0d032e7>]
ieee80211_register_hw+0x167/0x520 [mac80211]
Feb  1 20:22:39 localhost kernel: [<ffffffffa0d43e40>]
rt2x00lib_probe_dev+0x2e0/0x4c0 [rt2x00lib]
Feb  1 20:22:39 localhost kernel: [<ffffffffa01502ad>]
rt2x00usb_probe+0x14d/0x310 [rt2x00usb]
Feb  1 20:22:39 localhost kernel: [<ffffffffa02ce359>]
usb_probe_interface+0x109/0x200 [usbcore]
Feb  1 20:22:39 localhost kernel: [<ffffffff812b11e6>]
driver_probe_device+0x96/0x1c0
Feb  1 20:22:39 localhost kernel: [<ffffffff812b13ab>] __driver_attach+0x9b/0xa0
Feb  1 20:22:39 localhost kernel: [<ffffffff812b1310>] ?
__driver_attach+0x0/0xa0
Feb  1 20:22:39 localhost kernel: [<ffffffff812b012e>]
bus_for_each_dev+0x5e/0x90
Feb  1 20:22:39 localhost kernel: [<ffffffff812b0e89>] driver_attach+0x19/0x20
Feb  1 20:22:39 localhost kernel: [<ffffffff812b0a18>]
bus_add_driver+0x158/0x300
Feb  1 20:22:39 localhost kernel: [<ffffffff812b1621>]
driver_register+0x71/0x140
Feb  1 20:22:39 localhost kernel: [<ffffffff8107d50d>] ?
notifier_call_chain+0x4d/0x70
Feb  1 20:22:39 localhost kernel: [<ffffffffa02cd078>]
usb_register_driver+0xb8/0x170 [usbcore]
Feb  1 20:22:39 localhost kernel: [<ffffffffa01c8000>] ?
rt73usb_init+0x0/0x20 [rt73usb]
Feb  1 20:22:39 localhost kernel: [<ffffffffa01c801e>]
rt73usb_init+0x1e/0x20 [rt73usb]
Feb  1 20:22:39 localhost kernel: [<ffffffff8100212f>]
do_one_initcall+0x3f/0x180
Feb  1 20:22:39 localhost kernel: [<ffffffff81093ebb>]
sys_init_module+0xbb/0x200
Feb  1 20:22:39 localhost kernel: [<ffffffff8100bf12>]
system_call_fastpath+0x16/0x1b
Feb  1 20:22:39 localhost kernel: RSP <ffff8800b6a19b20>
Feb  1 20:22:39 localhost kernel: ---[ end trace 0d76df522e93fe83 ]---
Feb  1 20:23:10 localhost kernel: usb 2-2: USB disconnect, address 3
Feb  1 20:23:22 localhost kernel: CE: hpet6 increased min_delta_ns to 7500 nsec
Feb  1 20:23:22 localhost kernel: CE: hpet6 increased min_delta_ns to 11250 nsec

Hope this helps.
Eric
