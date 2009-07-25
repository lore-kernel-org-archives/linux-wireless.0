Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([204.127.217.101]:40773 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbZGYDf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 23:35:26 -0400
Message-ID: <4A6A7D95.1080103@lwfinger.net>
Date: Fri, 24 Jul 2009 22:35:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: BUG in latest wireless-testing pull - 2.6.31-rc4
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I pulled from the wireless-testing (git describe yields
v2.6.31-rc4-29133-g1addf37) and get the following BUG:

BUG: unable to handle kernel NULL pointer dereference at 000000000000000c
IP: [<ffffffffa0267fc1>] ieee80211_scan_work+0x18a/0x426 [mac80211]
PGD 0
Oops: 0000 [#1] SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:0d.0/0000:04:00.0/ssb0:0/uevent
CPU 0
Modules linked in: af_packet snd_pcm_oss snd_mixer_oss snd_seq
snd_seq_device nfs lockd nfs_acl auth_rpcgss sunrpc vboxnetadp
vboxnetflt vboxdrv cpufreq_conservative cpufreq_userspace
cpufreq_powersave powernow_k8 fuse ext4 jbd2 crc16 loop dm_mod arc4
ecb ide_cd_mod cdrom b43 rng_core snd_hda_codec_conexant
ide_pci_generic mac80211 cfg80211 rfkill snd_hda_intel snd_hda_codec
snd_pcm led_class snd_timer snd battery ssb i2c_nforce2 amd74xx ac
k8temp serio_raw button sg soundcore hwmon ide_core i2c_core joydev
forcedeth snd_page_alloc sd_mod ohci_hcd ehci_hcd usbcore edd ahci
libata scsi_mod ext3 mbcache jbd fan thermal processor
Pid: 2059, comm: phy0 Not tainted 2.6.31-rc4-wl #184 HP Pavilion
dv2700 Notebook PC
RIP: 0010:[<ffffffffa0267fc1>]  [<ffffffffa0267fc1>]
ieee80211_scan_work+0x18a/0x426 [mac80211]
RSP: 0018:ffff8800b852fdb0  EFLAGS: 00010293
RAX: ffff880037b26969 RBX: 0000000000000000 RCX: ffff8800b88e46c0
RDX: 000000000000000e RSI: 0000000000000001 RDI: ffffffff8127bc96
RBP: ffff8800b852fdf0 R08: 0000000000000002 R09: 0000000000000000
R10: ffff880002193fd0 R11: ffff8800b852fb70 R12: ffff880037b411d0
R13: ffff880037b404c0 R14: ffff880037b412e8 R15: ffff8800b859acd0
FS:  00007f987563e6f0(0000) GS:ffff880002187000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000000000c CR3: 0000000001001000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process phy0 (pid: 2059, threadinfo ffff8800b852e000, task
ffff8800b859acd0)
Stack:
 ffff8800021a0840 ffff880037b41118 ffff880037b41128 ffff8800b852fed8
<0> ffff8800021a0840 ffff880037b412f0 ffff880037b412e8 ffff8800b859acd0
<0> ffff8800b852fec0 ffffffff81050704 ffffffff810506ad 0000000000000046
Call Trace:
 [<ffffffff81050704>] worker_thread+0x1fa/0x30a
 [<ffffffff810506ad>] ? worker_thread+0x1a3/0x30a
 [<ffffffffa0267e37>] ? ieee80211_scan_work+0x0/0x426 [mac80211]
 [<ffffffff81054f7c>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff81063973>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8105050a>] ? worker_thread+0x0/0x30a
 [<ffffffff81054c1a>] kthread+0x88/0x90
 [<ffffffff8100cb7a>] child_rip+0xa/0x20
 [<ffffffff8100c53c>] ? restore_args+0x0/0x30
 [<ffffffff81054b92>] ? kthread+0x0/0x90
 [<ffffffff8100cb70>] ? child_rip+0x0/0x20
Code: 85 24 0e 00 00 03 00 00 00 e9 43 ff ff ff 49 8b 85 00 0e 00 00
49 63 95 1c 0e 00 00 49 8b 8d c8 0e 00 00 48 8b 40 10 48 8b 1c d0 <8b>
43 0c a8 01 75 27 83 b9 90 08 00 00 01 75 04 a8 04 75 1a 49
RIP  [<ffffffffa0267fc1>] ieee80211_scan_work+0x18a/0x426 [mac80211]
 RSP <ffff8800b852fdb0>
CR2: 000000000000000c
---[ end trace 07b5d563305d3f01 ]---

The trace translates back to the statement

chan = local->scan_req->channels[local->scan_channel_idx];

in ieee80211_scan_state_set_channel().

Larry


