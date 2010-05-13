Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49510 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0EMPnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 11:43:16 -0400
Received: by vws16 with SMTP id 16so46755vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 08:43:14 -0700 (PDT)
From: Joshua Smith <jesmith@kaon.com>
Content-Type: text/plain; charset=us-ascii
Subject: compat-wireless 2010-05-12 is crashing
Date: Thu, 13 May 2010 11:43:12 -0400
Message-Id: <3A25FB02-BE72-4FF6-BC66-AA04E459A9C9@kaon.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1078)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I connect any rt2x00 device, I'm getting this crash:

usb 1-1.6: new high speed USB device using ehci_hcd and address 5
usb 1-1.6: configuration #1 chosen from 1 choice
Generic kernel compatibility enabled based on linux-next next-20100113
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
phy0: Selected rate control algorithm 'minstrel'
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<00000000>]
*pde = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in: arc4 ecb rt2800usb(+) rt2800lib rt2x00usb rt2x00lib led_class compat_firmware_class mac80211 cfg80211 rfkill_backport compat crc_ccitt snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss pcmcia pcmcia_core agpgart ppdev lp parport_pc parport pcspkr psmouse sg snd_hda_intel snd_pcm snd_timer snd_page_alloc snd_hwdep snd soundcore e1000e evdev fuse aufs squashfs sqlzma unlzma [last unloaded: pcmcia_core]

Pid: 5340, comm: modprobe Not tainted (2.6.27.8 #1)
EIP: 0060:[<00000000>] EFLAGS: 00010286 CPU: 2
EIP is at 0x0
EAX: f5012000 EBX: f7146890 ECX: 00000000 EDX: 00000000
ESI: f7146800 EDI: f5084300 EBP: f5012000 ESP: f519bc54
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 5340, ti=f519a000 task=f6abb100 task.ti=f519a000)
Stack: c067340f f5012160 00000282 00000292 f794ff60 00000000 00000000 00000000 
       00000000 00000000 00000000 00000000 000005dc f5012000 f5084300 ffffffff 
       00000010 c06738c9 00000000 00000000 ffffffff 00000000 c08eaa5c ffffffff 
Call Trace:
 [<c067340f>] rtnl_fill_ifinfo+0x2af/0x4a0
 [<c06738c9>] rtmsg_ifinfo+0x69/0x100
 [<c06739a4>] rtnetlink_event+0x44/0x60
 [<c013ba50>] notifier_call_chain+0x30/0x60
 [<c013baf7>] raw_notifier_call_chain+0x17/0x20
 [<c066ad60>] register_netdevice+0x200/0x340
 [<fa1a0030>] ieee80211_rx_mgmt_probe_resp+0xe0/0x170 [mac80211]
 [<fa1a3aec>] ieee80211_setup_sdata+0x2c/0xf0 [mac80211]
 [<fa1a424e>] ieee80211_if_add+0x47e/0x860 [mac80211]
 [<c03ab109>] crypto_spawn_tfm+0x59/0xb0
 [<fa1161aa>] crypto_ecb_init_tfm+0x1a/0x30 [ecb]
 [<c01263db>] printk+0x1b/0x20
 [<fa1a5a24>] ieee80211_init_rate_ctrl_alg+0xd4/0x1e0 [mac80211]
 [<fa197b32>] ieee80211_register_hw+0x322/0x3b0 [mac80211]
 [<fa11dc19>] rt2x00lib_probe_dev+0x2d9/0x390 [rt2x00lib]
 [<fa067c83>] rt2x00usb_probe+0xb3/0x150 [rt2x00usb]
 [<c05e8e67>] usb_match_one_id+0x27/0xb0
 [<c05e9e1a>] usb_probe_interface+0x8a/0x130
 [<c01b984f>] sysfs_create_link+0xf/0x20
 [<c0435592>] driver_probe_device+0x82/0x180
 [<c04356fc>] __driver_attach+0x6c/0x70
 [<c0434d3b>] bus_for_each_dev+0x3b/0x60
 [<c0435416>] driver_attach+0x16/0x20
 [<c0435690>] __driver_attach+0x0/0x70
 [<c0435271>] bus_add_driver+0x1a1/0x220
 [<c04358fd>] driver_register+0x4d/0x120
 [<c05e9451>] usb_register_driver+0x81/0x100
 [<fa1283a0>] rt2800_config_erp+0x0/0x160 [rt2800lib]
 [<f8d1c000>] rt2800usb_init+0x0/0x14 [rt2800usb]
 [<c0101123>] _stext+0x33/0x160
 [<c0146bb7>] sys_init_module+0x87/0x1b0
 [<c01764d1>] sys_read+0x41/0x70
 [<c0103262>] syscall_call+0x7/0xb
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:f519bc54
---[ end trace fbe1874eb5bb9481 ]---

Is this a known problem?

What other info would you like to help diagnose this?

-Joshua

