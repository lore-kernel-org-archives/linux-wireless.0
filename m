Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:35184 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754861Ab2FESjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 14:39:43 -0400
From: Oleksij Rempel <bug-track@fisher-privat.net>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Oleksij Rempel <bug-track@fisher-privat.net>
Subject: [PATCH 0/1 ] b43: do not call ieee80211_unregister_hw if we are not registred
Date: Tue,  5 Jun 2012 20:39:31 +0200
Message-Id: <1338921572-22315-1-git-send-email-bug-track@fisher-privat.net> (sfid-20120605_203947_147933_18933845)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fallwoing patch fixes Oops on rmmod b43. I didn't wonted to pass
cpmplete Oops to the patch description. For those who wont to see it,
here is complete extra oops trace:

P: [<ffffffff8104e988>] drain_workqueue+0x25/0x142
[  139.018775] PGD 153ac6067 PUD 153b82067 PMD 0
[  139.018814] Oops: 0000 [#1] SMP
[  139.018843] CPU 0
[  139.018858] Modules linked in: tun kvm_intel kvm bnep rfcomm binfmt_misc b43(-) mac80211 snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec i915 cfg80211 snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy btusb drm_kms_helper snd_seq_oss bluetooth snd_seq_midi usb_storage psmouse snd_rawmidi snd_seq_midi_event sr_mod firewire_ohci rfkill snd_seq firewire_core serio_raw coretemp ssb cdrom snd_timer snd_seq_device snd soundcore snd_page_alloc crc_itu_t cfbcopyarea cfbimgblt cfbfillrect batman_adv
[  139.019004]
[  139.019004] Pid: 3583, comm: rmmod Not tainted 3.4.0-rc7-00106-gb1dab2f-dirty #167                  /DG45ID
[  139.019004] RIP: 0010:[<ffffffff8104e988>]  [<ffffffff8104e988>] drain_workqueue+0x25/0x142
[  139.019004] RSP: 0018:ffff88014b90fd28  EFLAGS: 00010246
[  139.019004] RAX: 0000000000001f1f RBX: 0000000000000000 RCX: 0000000000000000
[  139.019004] RDX: 000000000000001f RSI: 0000000000000000 RDI: ffffffff819b2c80
[  139.019004] RBP: ffff88014b90fd68 R08: 0000000000000000 R09: ffffffff8189b4d8
[  139.019004] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801a0d97000
[  139.019004] R13: ffff8801a3146c00 R14: 0000000000000001 R15: 0000000000000008
[  139.019004] FS:  00007f2a2fb1c700(0000) GS:ffff8801abc00000(0000) knlGS:0000000000000000
[  139.019004] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  139.019004] CR2: 0000000000000088 CR3: 000000017642c000 CR4: 00000000000407f0
[  139.019004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  139.019004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  139.019004] Process rmmod (pid: 3583, threadinfo ffff88014b90e000, task ffff880153946630)
[  139.019004] Stack:
[  139.019004]  ffff88014b90fd58 ffffffff8138fef5 0000000000000048 0000000000000000
[  139.019004]  ffff8801a0d97000 ffff8801a3146c00 0000000000000001 0000000000000008
[  139.019004]  ffff88014b90fd98 ffffffff8104fb30 0000000000000000 ffff8801a23e0560
[  139.019004] Call Trace:
[  139.019004]  [<ffffffff8138fef5>] ? skb_dequeue+0x61/0x6d
[  139.019004]  [<ffffffff8104fb30>] destroy_workqueue+0x17/0xea
[  139.019004]  [<ffffffffa024619d>] ieee80211_unregister_hw+0xe5/0x116 [mac80211]
[  139.019004]  [<ffffffffa02a9c5d>] b43_ssb_remove+0x7f/0xbe [b43]
[  139.019004]  [<ffffffff812b1a61>] __device_release_driver+0x86/0xcf
[  139.019004]  [<ffffffff812b23a1>] driver_detach+0x84/0xab
[  139.019004]  [<ffffffff812b1883>] bus_remove_driver+0xb7/0xdc
[  139.019004]  [<ffffffff812b2990>] driver_unregister+0x69/0x71
[  139.019004]  [<ffffffffa02ce900>] ? b43_debugfs_exit+0x1a/0x1a [b43]
[  139.019004]  [<ffffffffa006c79e>] ssb_driver_unregister+0x12/0x14 [ssb]
[  139.019004]  [<ffffffffa02ce910>] b43_exit+0x10/0x28 [b43]
[  139.019004]  [<ffffffff8107efec>] sys_delete_module+0x20b/0x27d
[  139.019004]  [<ffffffff810dc506>] ? vm_munmap+0x50/0x60
[  139.019004]  [<ffffffff8146fcd2>] system_call_fastpath+0x16/0x1b
[  139.019004] Code: 41 5e 41 5f 5d c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 66 66 66 66 90 48 89 fb 48 c7 c7 80 2c 9b 81 e8 e0 07 42 00 <8b> 83 88 00 00 00 8d 50 01 85 c0 89 93 88 00 00 00 75 03 83 0b
[  139.019004] RIP  [<ffffffff8104e988>] drain_workqueue+0x25/0x142
[  139.019004]  RSP <ffff88014b90fd28>
[  139.019004] CR2: 0000000000000088
[  139.121477] ---[ end trace b82c4fe2c4e7d3f0 ]---
