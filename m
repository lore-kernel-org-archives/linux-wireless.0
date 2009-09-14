Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:47241 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbZINOFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 10:05:33 -0400
Received: by fxm17 with SMTP id 17so855868fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 07:05:36 -0700 (PDT)
Message-ID: <4AAE4DAA.1010505@lwfinger.net>
Date: Mon, 14 Sep 2009 09:05:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Kernel oops with 2.6.31-wl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using the kernel v2.6.31-38241-g2d3a51e, I get the following kernel
oops when unloading b43:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: [<ffffffffa02a3a3e>] b43_op_config+0x10c/0x36f [b43]
PGD 79901067 PUD 2e6f0067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/class/rfkill/rfkill0/state
CPU 0
Modules linked in: udf crc_itu_t aes_x86_64 aes_generic af_packet
snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device vboxnetadp nfs
vboxnetflt lockd nfs_acl auth_rpcgss sunrpc vboxdrv
cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8
fuse ext4 jbd2 crc16 loop dm_mod ide_cd_mod cdrom
snd_hda_codec_conexant arc4 ecb ide_pci_generic b43(-) rng_core
snd_hda_intel mac80211 snd_hda_codec snd_pcm cfg80211 rfkill snd_timer
ac battery snd led_class amd74xx soundcore i2c_nforce2 button
serio_raw joydev k8temp forcedeth snd_page_alloc ssb ide_core hwmon
i2c_core sg sd_mod ohci_hcd ehci_hcd usbcore edd ahci libata scsi_mod
ext3 mbcache jbd fan thermal processor
Pid: 10483, comm: modprobe Not tainted 2.6.31-rc9-wl #209 HP Pavilion
dv2700 Notebook PC
RIP: 0010:[<ffffffffa02a3a3e>]  [<ffffffffa02a3a3e>]
b43_op_config+0x10c/0x36f [b43]
RSP: 0018:ffff88002e7f3a48  EFLAGS: 00010296
RAX: 000000000000001a RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff880002189000 RSI: 0000000000000001 RDI: 0000000000000004
RBP: ffff88002e7f3a98 R08: 0000000000000086 R09: ffffffff81058b2b
R10: 0000000000000086 R11: ffffffff8171e670 R12: ffff8800b9ebb800
R13: ffff8800b9c61720 R14: ffff8800378b8e40 R15: ffff8800b9c60500
FS:  00007fb8fdceb6f0(0000) GS:ffff880002189000(0000)
knlGS:00000000b725c970
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000010 CR3: 000000002e78a000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 10483, threadinfo ffff88002e7f2000, task
ffff8800aa0d3bc0)
Stack:
 ffff88002e7f3a68 00000100810639d0 ffff8800b9c61730 ffffffffa02c4de0
<0> 01ff88002e7f3a78 ffff8800b9c60500 0000000000000100 0000000000000100
<0> ffff8800378b8e40 ffff8800378b86d0 ffff88002e7f3ab8 ffffffffa025d197
Call Trace:
 [<ffffffffa025d197>] ieee80211_hw_config+0xa2/0xab [mac80211]
 [<ffffffffa0266819>] ieee80211_recalc_idle+0x44/0x4c [mac80211]
 [<ffffffffa026310a>] ieee80211_set_disassoc+0x158/0x287 [mac80211]
 [<ffffffffa0263077>] ? ieee80211_set_disassoc+0xc5/0x287 [mac80211]
 [<ffffffffa026374d>] ieee80211_mgd_deauth+0x67/0xfb [mac80211]
 [<ffffffffa0269144>] ieee80211_deauth+0x19/0x1b [mac80211]
 [<ffffffffa02172bb>] __cfg80211_mlme_deauth+0x10c/0x11b [cfg80211]
 [<ffffffffa021a7f9>] __cfg80211_disconnect+0x10c/0x184 [cfg80211]
 [<ffffffffa020936a>] ? cfg80211_netdev_notifier_call+0x262/0x436
[cfg80211]
 [<ffffffffa02093a3>] cfg80211_netdev_notifier_call+0x29b/0x436 [cfg80211]
 [<ffffffff8121a31a>] ? fib_rules_event+0x3b/0x13e
 [<ffffffff81058ca7>] notifier_call_chain+0x33/0x5b
 [<ffffffff81058d3f>] raw_notifier_call_chain+0xf/0x11
 [<ffffffff8120cfd9>] dev_close+0x6a/0xac
 [<ffffffff8120d09e>] rollback_registered+0x83/0x26e
 [<ffffffff8120d2c3>] unregister_netdevice+0x3a/0x68
 [<ffffffffa02668af>] ieee80211_remove_interfaces+0x8e/0xa0 [mac80211]
 [<ffffffffa025c093>] ieee80211_unregister_hw+0x42/0xe5 [mac80211]
 [<ffffffffa029f561>] b43_remove+0x69/0xbd [b43]
 [<ffffffffa0168201>] ssb_device_remove+0x2b/0x3f [ssb]
 [<ffffffff811d8ece>] __device_release_driver+0x80/0xc9
 [<ffffffff811d8f9e>] driver_detach+0x87/0xad
 [<ffffffff811d8193>] bus_remove_driver+0x89/0xb9
 [<ffffffff811d94a7>] driver_unregister+0x66/0x6e
 [<ffffffffa0169300>] ssb_driver_unregister+0xd/0xf [ssb]
 [<ffffffffa02b8ba0>] b43_exit+0x10/0x17 [b43]
 [<ffffffff8106e1ad>] sys_delete_module+0x1d3/0x249
 [<ffffffff810639d0>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffff8127da70>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
Code: 8a 45 d7 41 38 44 24 4a 0f 84 55 01 00 00 e8 6a a8 ff ff 48 c7
c6 18 ca 2b a0 48 89 c2 4c 89 ef 31 c0 e8 86 c0 ff ff 49 8b 5d 00 <44>
8b 73 10 41 83 fe 01 7e 0b 48 89 df e8 25 d7 ff ff 48 89 c3
RIP  [<ffffffffa02a3a3e>] b43_op_config+0x10c/0x36f [b43]
 RSP <ffff88002e7f3a48>
CR2: 0000000000000010
---[ end trace 024f1ac214ffdbb7 ]---


This is clearly a regression. The fault is not present in
2.6.31-rc8-wl, but was in 2.6.31-rc9-wl. I will start a bisection, but
I hope this dump triggers a response. I'm hoping that it does not end
up in mainline during the current merge period.

Larry

