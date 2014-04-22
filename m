Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stator.leun.net ([85.214.203.199]:35470 "EHLO stator.leun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904AbaDVQAc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 12:00:32 -0400
Date: Tue, 22 Apr 2014 18:00:03 +0200
From: Michael Leun <lkml20140418@newton.leun.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	arik@wizery.com, linux@eikelenboom.it,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH 0/2] cfg80211: two reg fixes
Message-ID: <20140422180003.6438dbb7@xenia.leun.net> (sfid-20140422_180037_890444_67256923)
In-Reply-To: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 21 Apr 2014 20:39:33 -0700
"Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:



> that'd be appreciated as an alternative. I'm also very curious to hear
> no one else would have run into the same regression as you have.

I only see this on an Acer PTZ1825 with an ath9k wireless card, but
that machine was not sold with that wlan card, so other people with the
same model won't neccesarily see the same issue.


> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> This rebases Arik's patch to apply first and then piggy back
> the non modular fix on top of that. I think you all have
> more fancy things to test this series than I do now.
> 
> Michael Leun <lkml20140418@newton.leun.net> you reported a regression
> with commit 2a901468c221e778af52603e006a53 on v3.14, I however cannot
> see how that commit caused the issue you reported, can you test this
> patch ported onto v3.14? A port is here:
> 
> http://drvbp1.linux-foundation.org/~mcgrof/patches/2014/04/22/test-ariks-patch-for-314.patch

Applied this one ontop 3.14.1 and it does not seem to change anything:

When doing "rtcwake -m mem -s 30" I get 100% of tries the result below.

Did I get this correct, test-ariks-patch-for-314.patch is the same
thing as the two patches you posted and that got applied? If so, that
does not help for 3.14, I fear. I might try them on an current 3.15-rc.

[   97.914884] PM: Syncing filesystems ... done.
[   97.988935] PM: Preparing system for mem sleep
[   98.181751] Freezing user space processes ... (elapsed 0.001 seconds) done.
[   98.183136] Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
[   98.184111] PM: Entering mem sleep   
[   98.184765] wlan0: deauthenticating from 90:f6:52:4e:ba:b6 by local choice (reason=3)
[   98.200666] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   98.201020] sd 0:0:0:0: [sda] Stopping disk
[   98.201150] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
[   98.201233] IP: [<ffffffffa002b1f1>] reg_todo+0xc1/0x4d0 [cfg80211]
[   98.201320] PGD 0
[   98.201348] Oops: 0000 [#1] SMP
[   98.201395] Modules linked in: netconsole configfs ipt_REJECT xt_LOG xt_limit xt_recent iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 iptable_filter nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack xt_tcpudp ip6table_filter ip6_tables nf_nat_ftp
 nf_nat nf_conntrack_ftp nf_conntrack ip_tables x_tables ctr ccm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_pcm acer_wmi iTCO_wdt iTCO_vendor_support sparse_keymap snd_seq snd_seq_device snd_timer 
snd_mixer_oss hid_multitouch coretemp snd pcspkr joydev ath9k atl1c serio_raw i2c_i801 ac shpchp lpc_ich mfd_core acpi_cpufreq battery soundcore wmi sg sha256_ssse3 sha256_generic cbc linear md_mod af_packet usbhid uhci_hcd i915 i2c_algo_bit drm_kms_helper drm ehci_pci e
hci_hcd video usbcore button usb_common scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh dm_mirror dm_region_hash dm_log dm_crypt dm_snapshot dm_bufio dm_mod glue_helper lrw gf128mul ablk_helper cryptd aes_x86_64 arc4 ath9k_common ath9k_hw ath mac80211 cfg8021
1 rfkill fan processor thermal [last unloaded: ath9k]
[   98.202874] CPU: 1 PID: 22 Comm: kworker/1:0 Tainted: G          I  3.14.1-test+ #2
[   98.202936] Hardware name: Acer Aspire 1825PTZ/JM12-MS-CAP, BIOS V1.3127 04/23/2010
[   98.203017] Workqueue: events reg_todo [cfg80211]
[   98.203064] task: ffff8801b71c2610 ti: ffff8801b71c4000 task.ti: ffff8801b71c4000
[   98.203124] RIP: 0010:[<ffffffffa002b1f1>]  [<ffffffffa002b1f1>] reg_todo+0xc1/0x4d0 [cfg80211]
[   98.203219] RSP: 0018:ffff8801b71c5de8  EFLAGS: 00010297
[   98.203265] RAX: ffffffffa0074360 RBX: ffff8801b1dfb2f0 RCX: 0000000000000003
[   98.203322] RDX: 0000000000000000 RSI: ffff8801bfc92ed8 RDI: 0000000000000000
[   98.203378] RBP: ffff8801b71c5e20 R08: fffe801d0b000000 R09: 1600000000000000
[   98.203435] R10: 00017fe2950742c0 R11: 0000000000000000 R12: ffff8801b1dfb2c0
[   98.203491] R13: 0000000000000000 R14: ffff8801b1dfb2dc R15: 0000000000000040
[   98.203549] FS:  0000000000000000(0000) GS:ffff8801bfc80000(0000) knlGS:0000000000000000
[   98.203615] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   98.203663] CR2: 0000000000000038 CR3: 0000000001a0e000 CR4: 00000000000407e0
[   98.203719] Stack:
[   98.203741]  ffff8801b71c5e20 ffffffffa00499df ffff8801b70e8300 ffff8801bfc92ec0
[   98.203829]  ffffffffa00742c0 0000000000000000 0000000000000040 ffff8801b71c5e68
[   98.203913]  ffffffff81071b48 00000000bfc92ed8 ffff8801bfc96a00 ffff8801bfc92ed8
[   98.203999] Call Trace:
[   98.204053]  [<ffffffffa00499df>] ? disconnect_work+0xbf/0xd0 [cfg80211]
[   98.204120]  [<ffffffff81071b48>] process_one_work+0x178/0x420
[   98.204171]  [<ffffffff81072759>] worker_thread+0x119/0x3a0
[   98.204220]  [<ffffffff81072640>] ? rescuer_thread+0x360/0x360
[   98.204271]  [<ffffffff81078ced>] kthread+0xcd/0xf0
[   98.204314]  [<ffffffff81078c20>] ? kthread_create_on_node+0x180/0x180
[   98.204371]  [<ffffffff8159300c>] ret_from_fork+0x7c/0xb0
[   98.204417]  [<ffffffff81078c20>] ? kthread_create_on_node+0x180/0x180
[   98.204470] Code: 8e 02 00 00 83 f9 01 0f 84 d7 01 00 00 72 4a 83 f9 03 0f 85 ad 01 00 00 48 8b 05 6b 91 04 00 8b 50 14 83 fa 01 0f 84 79 03 00 00 <41> f6 45 38 10 0f 85 49 03 00 00 0f b6 4b ec f6 81 c0 5c 64 81
[   98.205094] RIP  [<ffffffffa002b1f1>] reg_todo+0xc1/0x4d0 [cfg80211]
[   98.205108]  RSP <ffff8801b71c5de8>
[   98.205108] CR2: 0000000000000038
[   98.205108] ---[ end trace 5ba75e439c2c7126 ]---
[   98.213229] BUG: unable to handle kernel paging request at ffffffffffffffd8
[   98.215861] IP: [<ffffffff8107928b>] kthread_data+0xb/0x20
[   98.217042] PGD 1a0f067 PUD 1a11067 PMD 0
[   98.217042] Oops: 0000 [#2] SMP
[   98.217042] Modules linked in: netconsole configfs ipt_REJECT xt_LOG xt_limit xt_recent iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 iptable_filter nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack xt_tcpudp ip6table_filter ip6_tables nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack ip_tables x_tables ctr ccm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_pcm acer_wmi iTCO_wdt iTCO_vendor_support sparse_keymap snd_seq snd_seq_device snd_timer snd_mixer_oss hid_multitouch coretemp snd pcspkr joydev ath9k atl1c serio_raw i2c_i801 ac shpchp lpc_ich mfd_core acpi_cpufreq battery soundcore wmi sg sha256_ssse3 sha256_generic cbc linear md_mod af_packet usbhid uhci_hcd i915 i2c_algo_bit drm_kms_helper drm ehci_pci ehci_hcd video usbcore button usb_common scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh dm_mirror dm_region_hash dm_log dm_crypt dm_snapshot dm_bufio dm_mod glue_he!
 lper lrw gf128mul ablk_helper cryptd aes_x86_64 arc4 ath9k_common ath9k_hw ath mac80211 cfg80211 rfkill fan processor thermal [last unloaded: ath9k]
[   98.217042] CPU: 1 PID: 22 Comm: kworker/1:0 Tainted: G      D   I  3.14.1-test+ #2
[   98.217042] Hardware name: Acer Aspire 1825PTZ/JM12-MS-CAP, BIOS V1.3127 04/23/2010
[   98.217042] task: ffff8801b71c2610 ti: ffff8801b71c4000 task.ti: ffff8801b71c4000
[   98.217042] RIP: 0010:[<ffffffff8107928b>]  [<ffffffff8107928b>] kthread_data+0xb/0x20
[   98.217042] RSP: 0018:ffff8801b71c5a40  EFLAGS: 00010002
[   98.217042] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000007
[   98.217042] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff8801b71c2610
[   98.217042] RBP: ffff8801b71c5a40 R08: 0000000000000000 R09: 0000000000000001
[   98.217042] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801b71c2b18
[   98.217042] R13: 0000000000000001 R14: ffff8801b71c2600 R15: ffff8801b71c2610
[   98.217042] FS:  0000000000000000(0000) GS:ffff8801bfc80000(0000) knlGS:0000000000000000
[   98.217042] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   98.217042] CR2: 0000000000000028 CR3: 0000000001a0e000 CR4: 00000000000407e0
[   98.217042] Stack:
[   98.217042]  ffff8801b71c5a58 ffffffff81072d5c ffff8801bfc93640 ffff8801b71c5ab8
[   98.217042]  ffffffff8158753b ffff8801b71c2610 ffff8801b71c5fd8 0000000000013640
[   98.217042]  0000000000013640 ffff8801b71c2610 ffff8801b71c2d38 ffff8801b71c2600
[   98.217042] Call Trace:
[   98.217042]  [<ffffffff81072d5c>] wq_worker_sleeping+0xc/0x80
[   98.217042]  [<ffffffff8158753b>] __schedule+0x51b/0x750
[   98.217042]  [<ffffffff81587794>] schedule+0x24/0x70
[   98.217042]  [<ffffffff8105974f>] do_exit+0x6cf/0xa40
[   98.217042]  [<ffffffff810ad8c8>] ? console_unlock+0x1e8/0x3f0
[   98.217042]  [<ffffffff8158bd07>] oops_end+0x97/0xe0
[   98.217042]  [<ffffffff8157f22e>] no_context+0x279/0x286
[   98.217042]  [<ffffffff8157f2a9>] __bad_area_nosemaphore+0x6e/0x1c7
[   98.217042]  [<ffffffff8157f410>] bad_area_nosemaphore+0xe/0x10
[   98.217042]  [<ffffffff8158e26c>] __do_page_fault+0x8c/0x520
[   98.217042]  [<ffffffff8100a825>] ? native_sched_clock+0x35/0x90
[   98.217042]  [<ffffffff8100a889>] ? sched_clock+0x9/0x10
[   98.217042]  [<ffffffff8108bd3d>] ? sched_clock_local+0x1d/0x80
[   98.217042]  [<ffffffff8108bf68>] ? sched_clock_cpu+0x98/0xc0
[   98.217042]  [<ffffffff8106fa10>] ? insert_work+0x50/0xa0
[   98.217042]  [<ffffffff8158e722>] do_page_fault+0x22/0x30
[   98.217042]  [<ffffffff8158b1b8>] page_fault+0x28/0x30
[   98.217042]  [<ffffffffa002b1f1>] ? reg_todo+0xc1/0x4d0 [cfg80211]
[   98.217042]  [<ffffffffa002b1bb>] ? reg_todo+0x8b/0x4d0 [cfg80211]
[   98.217042]  [<ffffffffa00499df>] ? disconnect_work+0xbf/0xd0 [cfg80211]
[   98.217042]  [<ffffffff81071b48>] process_one_work+0x178/0x420
[   98.217042]  [<ffffffff81072759>] worker_thread+0x119/0x3a0
[   98.217042]  [<ffffffff81072640>] ? rescuer_thread+0x360/0x360
[   98.217042]  [<ffffffff81078ced>] kthread+0xcd/0xf0
[   98.217042]  [<ffffffff81078c20>] ? kthread_create_on_node+0x180/0x180
[   98.217042]  [<ffffffff8159300c>] ret_from_fork+0x7c/0xb0
[   98.217042]  [<ffffffff81078c20>] ? kthread_create_on_node+0x180/0x180
[   98.217042] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 87 b0 04 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
[   98.217042] RIP  [<ffffffff8107928b>] kthread_data+0xb/0x20
[   98.217042]  RSP <ffff8801b71c5a40>
[   98.217042] CR2: ffffffffffffffd8  
[   98.217042] ---[ end trace 5ba75e439c2c7127 ]---
[   98.217042] Fixing recursive fault but reboot is needed!
[   99.169250] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
[   99.169250] Shutting down cpus with NMI
[   99.169250] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[   99.169250] drm_kms_helper: panic occurred, switching back to text console
[   99.169250] Rebooting in 15 seconds..


> 
> Arik Nemtsov (1):
>   cfg80211: avoid freeing last_request while in flight
> 
> Luis R. Rodriguez (1):
>   cfg80211: fix processing world regdomain when non modular
> 
>  net/wireless/reg.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> -- 
> 1.9.0
> 


-- 
MfG,

Michael Leun

