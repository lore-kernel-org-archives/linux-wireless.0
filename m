Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35853 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0JOWUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 18:20:22 -0400
Received: by ewy20 with SMTP id 20so1707225ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 15:20:20 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 Oct 2010 15:20:19 -0700
Message-ID: <AANLkTimqNvJ=93NA_s_p3Ype9pYey2+YS0zO0r9TZKd=@mail.gmail.com>
Subject: General protection fault in ieee80211_stop_tx_ba_sessions
From: Blaise Gassend <blaise@willowgarage.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have been getting a general protection fault in
ieee80211_stop_tx_ba_sessions. This mostly seems to happen within a
few tens of seconds of bringing the interface up.

I am pasting a backtrace and system information below below. What
other information would be useful to help track this down?

Thanks,
Blaise

Kernel:
Linux version 2.6.32-24-generic (buildd@crested) (gcc version 4.4.3
(Ubuntu 4.4.3-4ubuntu5) ) #42-Ubuntu SMP Fri Aug 20 14:21:58 UTC 2010

Wireless:
compat-wireless-2010-10-04

Backtrace (Keeps spewing for a really long time, I can provide more if
necessary):
[159217.170503] iwlagn 0000:01:00.0: Stopping AGG while state not ON or starting
[159217.209587] cfg80211: All devices are disconnected, going to
restore regulatory settings
[159217.209595] cfg80211: Restoring regulatory settings
[159217.209598] cfg80211: Calling CRDA to update world regulatory domain
[159217.211012] cfg80211: World regulatory domain updated:
[159217.211017]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[159217.211020]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[159217.211022]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[159217.211025]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[159217.211027]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[159217.211029]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[159217.633255] wlan0: authenticate with 00:24:6c:82:2f:38 (try 1)
[159217.827023] wlan0: authenticate with 00:24:6c:82:2f:38 (try 2)
[159217.828058] wlan0: authenticated
[159217.875128] wlan0: associate with 00:24:6c:82:2f:38 (try 1)
[159218.066890] wlan0: associate with 00:24:6c:82:2f:38 (try 2)
[159218.068422] wlan0: RX ReassocResp from 00:24:6c:82:2f:38
(capab=0x1501 status=0 aid=3)
[159218.068430] wlan0: associated
[159218.070203] ieee80211 phy3: U iwl_scan_cancel_timeout Scan cancel timeout
[159218.070212] ieee80211 phy3: U iwl_do_scan_abort Not performing scan to abort
[159218.070219] ieee80211 phy3: U iwl_scan_cancel_timeout Scan cancel timeout
[159218.070223] ieee80211 phy3: U iwl_do_scan_abort Not performing scan to abort
[159218.073268] cfg80211: Calling CRDA for country: US
[159218.168723] general protection fault: 0000 [#1] SMP
[159218.168740] last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/local_cpus
[159218.168746] CPU 3
[159218.168752] Modules linked in: iwlagn netconsole configfs autofs4
binfmt_misc ppdev nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs
snd_hda_codec_realtek fbcon tileblit font bitblit softcursor vga16fb
vgastate arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device i915
drm_kms_helper iwlcore snd drm mac80211 compat pcmcia_core
compat_firmware_class i2c_algo_bit psmouse video soundcore
snd_page_alloc output cfg80211 serio_raw intel_agp lp parport usbhid
hid ahci e1000e [last unloaded: iwlagn]
[159218.168846] Pid: 0, comm: swapper Not tainted 2.6.32-24-generic
#42-Ubuntu To Be Filled By O.E.M.
[159218.168848] RIP: 0010:[<ffffffffa01209a5>]  [<ffffffffa01209a5>]
ieee80211_stop_tx_ba_session+0x35/0xd0 [mac80211]
[159218.168860] RSP: 0018:ffff8800282c3de0  EFLAGS: 00010282
[159218.168863] RAX: 00040008000000c8 RBX: ffff880110a3d348 RCX:
0000000000000000
[159218.168865] RDX: dead000000200200 RSI: 0000000000000000 RDI:
ffff880110a3d348
[159218.168867] RBP: ffff8800282c3e20 R08: ffff8800282ce440 R09:
000090e302f96638
[159218.168869] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff88010637bd90
[159218.168871] R13: ffff8800282c3e90 R14: 0000000000000000 R15:
ffff880110a3d000
[159218.168873] FS:  0000000000000000(0000) GS:ffff8800282c0000(0000)
knlGS:0000000000000000
[159218.168875] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[159218.168876] CR2: 000000000214dac0 CR3: 00000000ae6e1000 CR4:
00000000000006e0
[159218.168879] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[159218.168882] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[159218.168886] Process swapper (pid: 0, threadinfo ffff88013392e000,
task ffff8801339316f0)
[159218.168887] Stack:
[159218.168889]  ffffffff81019e69 ffff8800282d5bc0 0000000000000092
ffff880133928000
[159218.168894] <0> ffff88010637bd90 ffff8800282c3e90 ffff880110a3d2c0
ffffffffa0120a40
[159218.168899] <0> ffff8800282c3e30 ffffffffa0120a87 ffff8800282c3ed0
ffffffff8107776b
[159218.168905] Call Trace:
[159218.168907]  <IRQ>
[159218.168917]  [<ffffffff81019e69>] ? sched_clock+0x9/0x10
[159218.168924]  [<ffffffffa0120a40>] ?
sta_addba_resp_timer_expired+0x0/0x50 [mac80211]
[159218.168931]  [<ffffffffa0120a87>]
sta_addba_resp_timer_expired+0x47/0x50 [mac80211]
[159218.168937]  [<ffffffff8107776b>] run_timer_softirq+0x19b/0x340
[159218.168943]  [<ffffffff812b92bd>] ? rb_insert_color+0x9d/0x160
[159218.168947]  [<ffffffff8108f723>] ? ktime_get+0x63/0xe0
[159218.168951]  [<ffffffff8106e467>] __do_softirq+0xb7/0x1e0
[159218.168954]  [<ffffffff810946aa>] ? tick_program_event+0x2a/0x30
[159218.168956]  [<ffffffff810142ec>] call_softirq+0x1c/0x30
[159218.168959]  [<ffffffff81015cb5>] do_softirq+0x65/0xa0
[159218.168961]  [<ffffffff8106e305>] irq_exit+0x85/0x90
[159218.168964]  [<ffffffff815496c1>] smp_apic_timer_interrupt+0x71/0x9c
[159218.168967]  [<ffffffff81013cb3>] apic_timer_interrupt+0x13/0x20
[159218.168968]  <EOI>
[159218.168972]  [<ffffffff8101b5a1>] ? mwait_idle+0x71/0xd0
[159218.168975]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.168980]  [<ffffffff81011e73>] ? cpu_idle+0xb3/0x110
[159218.168984]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
[159218.168987] Code: 5d d8 4c 89 65 e0 4c 89 6d e8 4c 89 75 f0 4c 89
7d f8 0f 1f 44 00 00 48 8b 87 d8 fc ff ff 48 89 fb 41 89 f6 4c 8d bf
b8 fc ff ff <4c> 8b a0 48 02 00 00 49 8b 44 24 60 48 83 b8 d8 00 00 00
00 75
[159218.169037] RIP  [<ffffffffa01209a5>]
ieee80211_stop_tx_ba_session+0x35/0xd0 [mac80211]
[159218.169046]  RSP <ffff8800282c3de0>
[159218.169052] ---[ end trace 431577676c190a40 ]---
[159218.169054] Kernel panic - not syncing: Fatal exception in interrupt
[159218.169056] Pid: 0, comm: swapper Tainted: G      D
2.6.32-24-generic #42-Ubuntu
[159218.169058] Call Trace:
[159218.169059]  <IRQ>  [<ffffffff81541605>] panic+0x78/0x137
[159218.169064]  [<ffffffff8154552a>] oops_end+0xea/0xf0
[159218.169067]  [<ffffffff8101713b>] die+0x5b/0x90
[159218.169070]  [<ffffffff81545072>] do_general_protection+0x152/0x160
[159218.169074]  [<ffffffff810397a9>] ? default_spin_lock_flags+0x9/0x10
[159218.169077]  [<ffffffff81544835>] general_protection+0x25/0x30
[159218.169084]  [<ffffffffa01209a5>] ?
ieee80211_stop_tx_ba_session+0x35/0xd0 [mac80211]
[159218.169087]  [<ffffffff81019e69>] ? sched_clock+0x9/0x10
[159218.169093]  [<ffffffffa0120a40>] ?
sta_addba_resp_timer_expired+0x0/0x50 [mac80211]
[159218.169099]  [<ffffffffa0120a87>]
sta_addba_resp_timer_expired+0x47/0x50 [mac80211]
[159218.169101]  [<ffffffff8107776b>] run_timer_softirq+0x19b/0x340
[159218.169104]  [<ffffffff812b92bd>] ? rb_insert_color+0x9d/0x160
[159218.169106]  [<ffffffff8108f723>] ? ktime_get+0x63/0xe0
[159218.169109]  [<ffffffff8106e467>] __do_softirq+0xb7/0x1e0
[159218.169111]  [<ffffffff810946aa>] ? tick_program_event+0x2a/0x30
[159218.169113]  [<ffffffff810142ec>] call_softirq+0x1c/0x30
[159218.169115]  [<ffffffff81015cb5>] do_softirq+0x65/0xa0
[159218.169117]  [<ffffffff8106e305>] irq_exit+0x85/0x90
[159218.169120]  [<ffffffff815496c1>] smp_apic_timer_interrupt+0x71/0x9c
[159218.169122]  [<ffffffff81013cb3>] apic_timer_interrupt+0x13/0x20
[159218.169123]  <EOI>  [<ffffffff8101b5a1>] ? mwait_idle+0x71/0xd0
[159218.169129]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.169132]  [<ffffffff81011e73>] ? cpu_idle+0xb3/0x110
[159218.169135]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
[159218.169142] [drm:drm_fb_helper_panic] *ERROR* panic occurred,
switching back to text console
[159218.169145] BUG: scheduling while atomic: swapper/0/0x10000100
[159218.169147] Modules linked in: iwlagn netconsole configfs autofs4
binfmt_misc ppdev nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs
snd_hda_codec_realtek fbcon tileblit font bitblit softcursor vga16fb
vgastate arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device i915
drm_kms_helper iwlcore snd drm mac80211 compat pcmcia_core
compat_firmware_class i2c_algo_bit psmouse video soundcore
snd_page_alloc output cfg80211 serio_raw intel_agp lp parport usbhid
hid ahci e1000e [last unloaded: iwlagn]
[159218.169196] CPU 3:
[159218.169197] Modules linked in: iwlagn netconsole configfs autofs4
binfmt_misc ppdev nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs
snd_hda_codec_realtek fbcon tileblit font bitblit softcursor vga16fb
vgastate arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device i915
drm_kms_helper iwlcore snd drm mac80211 compat pcmcia_core
compat_firmware_class i2c_algo_bit psmouse video arc4 snd_rawmidi
snd_seq_device snd compat psmouse snd_page_alloc intel_agp usbhid
[last unloaded: iwlagn][159218.195722] RIP: 0010:[<ffffffff8101b5a1>]
[159218.195729] RDX: 0000000000000000 RSI: ffff88013392ffd8 RDI:
ffffffff81948fa8
[159218.195735] R13: ffff88013392fe68 R14: 0000000000000000 R15:
0000000100f29f31
[159218.195740] CR2: 000000000214dac0 CR3: 00000000a31c9000 CR4:
00000000000006e0
[159218.195754] bad: scheduling from the idle thread!
 [<ffffffff810536da>] dequeue_task_idle+0x3a/0x50
[159218.195768]  [<ffffffff81541e59>] thread_return+0x131/0x418
[159218.195777]  [<ffffffff810780b0>] msleep+0x20/0x30
[159218.195792]  [<ffffffffa0226641>]
drm_fb_helper_force_kernel_mode+0x71/0xa0 [drm_kms_helper]
[159218.195802]  [<ffffffff81541627>] panic+0x9a/0x137
[159218.195811]  [<ffffffff81545072>] do_general_protection+0x152/0x160
[159218.195841]  [<ffffffff812b92bd>] ? rb_insert_color+0x9d/0x160
[159218.195849]  [<ffffffff810946aa>] ? tick_program_event+0x2a/0x30
[159218.195857]  [<ffffffff815496c1>] smp_apic_timer_interrupt+0x71/0x9c
 [<ffffffff8101b5a1>] ? mwait_idle+0x71/0xd0
[159218.195869]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
 netconsole binfmt_misc lockd exportfs tileblit softcursor
snd_hda_intel snd_pcm_oss snd_seq_oss snd_seq_midi_event i915 snd
compat psmouse snd_page_alloc serio_raw parport ahci[159218.196011]
CPU 3: netconsole binfmt_misc lockd exportfs font vga16fb
snd_hda_intel snd_pcm_oss snd_seq_oss snd_seq_midi_event
snd_seq_device iwlcore mac80211 compat_firmware_class soundcore
cfg80211 parport ahci[159218.196060] Pid: 0, comm: swapper Tainted: G
    D    2.6.32-24-generic #42-Ubuntu To Be Filled By O.E.M.
[159218.196067] RAX: 0000000000000000 RBX: ffff88013392ff08 RCX:
0000000000000000
[159218.196077] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[159218.196084] Call Trace:
[159218.196091]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
[159218.196096] Call Trace:
[159218.196099]  <IRQ> [159218.196103]  [<ffffffff8104b345>]
dequeue_task+0xb5/0xf0
[159218.196110]  [<ffffffff81542675>] schedule_timeout+0x195/0x300
[159218.196142]  [<ffffffff81541627>] panic+0x9a/0x137
[159218.196152]  [<ffffffff810397a9>] ? default_spin_lock_flags+0x9/0x10
[159218.196163]  [<ffffffff81019e69>] ? sched_clock+0x9/0x10
[159218.196177]  [<ffffffff8107776b>] run_timer_softirq+0x19b/0x340
[159218.196182]  [<ffffffff8108f723>] ? ktime_get+0x63/0xe0
[159218.196191]  [<ffffffff81015cb5>] do_softirq+0x65/0xa0
[159218.196196]  [<ffffffff815496c1>] smp_apic_timer_interrupt+0x71/0x9c
[159218.196205]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.196212] BUG: scheduling while atomic: swapper/0/0x00000100
 netconsole binfmt_misc lockd sunrpc fbcon bitblit vgastate
snd_hda_codec snd_mixer_oss snd_seq_oss snd_rawmidi snd_seq_device
iwlcore mac80211 compat_firmware_class video output intel_agp usbhid
e1000e[159218.196262] CPU 3: iwlagn autofs4 nfsd auth_rpcgss
snd_hda_codec_realtek fbcon font vga16fb snd_hda_intel snd_pcm_oss
snd_seq_dummy snd_rawmidi snd_seq_midi_event snd_timer iwlcore
mac80211 compat_firmware_class video output intel_agp lp usbhid
e1000e[159218.196400] Pid: 0, comm: swapper Tainted: G      D
2.6.32-24-generic #42-Ubuntu To Be Filled By O.E.M.
[159218.196410] RBP: ffffffff81013cae R08: 0000000000000000 R09:
0000000000000002
[159218.196418] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[159218.196423] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[159218.196429]  [<ffffffff81011e73>] ? cpu_idle+0xb3/0x110
[159218.196435] Pid: 0, comm: swapper Tainted: G      D
2.6.32-24-generic #42-Ubuntu
 [<ffffffff810536da>] dequeue_task_idle+0x3a/0x50
[159218.196454]  [<ffffffff815427fe>] schedule_timeout_uninterruptible+0x1e/0x20
[159218.196468]  [<ffffffffa0228ee3>]
drm_crtc_helper_set_config+0x783/0x920 [drm_kms_helper]
[159218.196477]  [<ffffffff815471f6>] notifier_call_chain+0x56/0x80
[159218.196484]  [<ffffffff8154552a>] oops_end+0xea/0xf0
[159218.196492]  [<ffffffff810397a9>] ? default_spin_lock_flags+0x9/0x10
[159218.196503]  [<ffffffff81019e69>] ? sched_clock+0x9/0x10
[159218.196524]  [<ffffffff8106e467>] __do_softirq+0xb7/0x1e0
[159218.196531]  [<ffffffff81015cb5>] do_softirq+0x65/0xa0
[159218.196535]  [<ffffffff815496c1>] smp_apic_timer_interrupt+0x71/0x9c
[159218.196543]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.196552] Modules linked in: configfs binfmt_misc nfs_acl
exportfs tileblit softcursor arc4 snd_hwdep snd_pcm snd_seq_midi
snd_seq i915 snd compat i2c_algo_bit soundcore cfg80211 lp hid [last
unloaded: iwlagn]
 netconsole binfmt_misc lockd auth_rpcgss fbcon bitblit vgastate
snd_hda_codec snd_mixer_oss snd_seq_oss snd_seq_midi_event
snd_seq_device iwlcore mac80211 compat_firmware_class video output
intel_agp parport e1000e[159218.196651] Pid: 0, comm: swapper Tainted:
G      D    2.6.32-24-generic #42-Ubuntu To Be Filled By O.E.M.
[159218.196656] RSP: 0018:ffff88013392fef8  EFLAGS: 00000246
[159218.196667] FS:  0000000000000000(0000) GS:ffff8800282c0000(0000)
knlGS:0000000000000000
[159218.196673] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
 fbcon bitblit softcursor vgastate snd_hda_codec snd_mixer_oss
snd_seq_oss snd_seq_midi_event snd_seq_device iwlcore compat
i2c_algo_bit soundcore snd_page_alloc output lp hid [last unloaded:
iwlagn]
 netconsole configfs autofs4 ppdev nfs_acl exportfs fbcon tileblit
softcursor arc4 snd_pcm snd_seq_midi snd_timer drm_kms_helper drm
pcmcia_core compat_firmware_class psmouse snd_page_alloc serio_raw
parport ahci
 [<ffffffff8101b5a1>] mwait_idle+0x71/0xd0
[159218.196999] RDX: 0000000000000000 RSI: ffff88013392ffd8 RDI:
ffffffff81948fa8
[159218.197006] FS:  0000000000000000(0000) GS:ffff8800282c0000(0000)
knlGS:0000000000000000
[159218.197015] Call Trace:
[159218.197025] Pid: 0, comm: swapper Tainted: G      D
2.6.32-24-generic #42-Ubuntu
[159218.197034]  [<ffffffff8104b3ee>] deactivate_task+0x2e/0x40
[159218.197048]  [<ffffffff810780b0>] msleep+0x20/0x30
[159218.197063]  [<ffffffffa0226641>]
drm_fb_helper_force_kernel_mode+0x71/0xa0 [drm_kms_helper]
[159218.197073]  [<ffffffff81541627>] panic+0x9a/0x137
[159218.197080]  [<ffffffff81545072>] do_general_protection+0x152/0x160
[159218.197105]  [<ffffffffa0120a87>]
sta_addba_resp_timer_expired+0x47/0x50 [mac80211]
[159218.197113]  [<ffffffff8108f723>] ? ktime_get+0x63/0xe0
[159218.197120]  [<ffffffff810142ec>] call_softirq+0x1c/0x30
[159218.197124]  [<ffffffff8106e305>] irq_exit+0x85/0x90
 [<ffffffff8101b5a1>] ? mwait_idle+0x71/0xd0
[159218.197140]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
 iwlagn autofs4 nfsd auth_rpcgss snd_hda_codec_realtek font vga16fb
snd_hda_intel snd_pcm_oss snd_seq_dummy snd_rawmidi snd_seq_device
iwlcore mac80211 compat_firmware_class video snd_page_alloc intel_agp
parport e1000e[159218.197279] CPU 3: iwlagn configfs nfsd auth_rpcgss
snd_hda_codec_realtek tileblit font bitblit vgastate snd_hda_intel
snd_mixer_oss snd_seq_oss snd_rawmidi snd_seq_device iwlcore mac80211
compat_firmware_class video output intel_agp usbhid
e1000e[159218.197330] RIP: 0010:[<ffffffff8101b5a1>] [159218.197338]
RBP: ffffffff81013cae R08: 0000000000000000 R09: 0000000000000002
[159218.197344] FS:  0000000000000000(0000) GS:ffff8800282c0000(0000)
knlGS:0000000000000000
[159218.197350] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[159218.197355]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.197362] bad: scheduling from the idle thread!
[159218.197367]  <IRQ> [159218.197373]  [<ffffffff8104b3ee>]
deactivate_task+0x2e/0x40
[159218.197392]  [<ffffffffa02b65a8>] intel_pipe_set_base+0x2e8/0x4b0 [i915]
[159218.197404]  [<ffffffffa02266d3>] drm_fb_helper_panic+0x23/0x30
[drm_kms_helper]
[159218.197410]  [<ffffffff81541627>] panic+0x9a/0x137
[159218.197417]  [<ffffffff81545072>] do_general_protection+0x152/0x160
[159218.197430]  [<ffffffffa01209a5>] ?
ieee80211_stop_tx_ba_session+0x35/0xd0 [mac80211]
[159218.197445]  [<ffffffffa0120a87>]
sta_addba_resp_timer_expired+0x47/0x50 [mac80211]
[159218.197461]  [<ffffffff81015cb5>] do_softirq+0x65/0xa0
[159218.197467]  [<ffffffff81013cb3>] apic_timer_interrupt+0x13/0x20
[159218.197473]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.197480] BUG: scheduling while atomic: swapper/0/0x00000100
 netconsole autofs4 nfsd sunrpc fbcon bitblit vgastate
e1000e[159218.198013] CPU 3: iwlagn autofs4 nfsd auth_rpcgss
snd_hda_codec_realtek font vga16fb snd_hda_intel snd_pcm_oss snd_pcm
snd_rawmidi snd_timer drm_kms_helper drm pcmcia_core psmouse
snd_page_alloc serio_raw parport ahci
 [<ffffffff8101b5a1>] mwait_idle+0x71/0xd0
[159218.198137] RBP: ffffffff81013cae R08: 0000000000000000 R09:
0000000000000002
[159218.198147] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[159218.198152]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.198157]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
[159218.198165]  <IRQ> [159218.198171]  [<ffffffff8104b3ee>]
deactivate_task+0x2e/0x40
[159218.198178]  [<ffffffff81077000>] ? process_timeout+0x0/0x10
[159218.198190]  [<ffffffffa02b65a8>] intel_pipe_set_base+0x2e8/0x4b0 [i915]
[159218.198201]  [<ffffffffa02266d3>] drm_fb_helper_panic+0x23/0x30
[drm_kms_helper]
[159218.198208]  [<ffffffff81541627>] panic+0x9a/0x137
[159218.198215]  [<ffffffff81545072>] do_general_protection+0x152/0x160
[159218.198226]  [<ffffffffa01209a5>] ?
ieee80211_stop_tx_ba_session+0x35/0xd0 [mac80211]
[159218.198240]  [<ffffffffa0120a87>]
sta_addba_resp_timer_expired+0x47/0x50 [mac80211]
[159218.198248]  [<ffffffff8108f723>] ? ktime_get+0x63/0xe0
[159218.198256]  [<ffffffff810142ec>] call_softirq+0x1c/0x30
[159218.198263]  [<ffffffff815496c1>] smp_apic_timer_interrupt+0x71/0x9c
 [<ffffffff8101b5a1>] ? mwait_idle+0x71/0xd0
[159218.198273]  [<ffffffff81011e73>] ? cpu_idle+0xb3/0x110
 iwlagn autofs4 nfsd auth_rpcgss snd_hda_codec_realtek font softcursor
snd_hda_intel snd_pcm_oss snd_seq_dummy snd_seq_midi snd_seq
drm_kms_helper drm pcmcia_core psmouse snd_page_alloc cfg80211 parport
ahci [last unloaded: iwlagn]
 configfs ppdev lockd exportfs tileblit softcursor arc4 snd_hwdep
snd_pcm snd_seq_midi snd_seq_midi_event snd_seq_device iwlcore
mac80211 compat_firmware_class lp hid
 [<ffffffff8101b5a1>] mwait_idle+0x71/0xd0
[159218.198474] RDX: 0000000000000000 RSI: ffff88013392ffd8 RDI:
ffffffff81948fa8
[159218.198478] R10: 0000000000000000 R11: 0000000100f29f34 R12:
ffffffff8101a113
[159218.198485] CR2: 000000000214dac0 CR3: 00000000a31c9000 CR4:
00000000000006e0
[159218.198490] Call Trace:
[159218.198497]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
[159218.198500] Pid: 0, comm: swapper Tainted: G      D
2.6.32-24-generic #42-Ubuntu
 [<ffffffff810536da>] dequeue_task_idle+0x3a/0x50
[159218.198514]  [<ffffffff81542675>] schedule_timeout+0x195/0x300
[159218.198521]  [<ffffffff810780b0>] msleep+0x20/0x30
[159218.198532]  [<ffffffffa0228ee3>]
drm_crtc_helper_set_config+0x783/0x920 [drm_kms_helper]
[159218.198543]  [<ffffffff815471f6>] notifier_call_chain+0x56/0x80
[159218.198553]  [<ffffffff8101713b>] die+0x5b/0x90
[159218.198575]  [<ffffffffa0120a40>] ?
sta_addba_resp_timer_expired+0x0/0x50 [mac80211]
[159218.198585]  [<ffffffff812b92bd>] ? rb_insert_color+0x9d/0x160
[159218.198595]  [<ffffffff810142ec>] call_softirq+0x1c/0x30
[159218.198601]  [<ffffffff815496c1>] smp_apic_timer_interrupt+0x71/0x9c
[159218.198605]  <EOI>  [<ffffffff8101b5a1>] ? mwait_idle+0x71/0xd0
[159218.198618] Modules linked in: iwlagn autofs4 nfsd auth_rpcgss
snd_hda_codec_realtek font vga16fb snd_hda_intel snd_pcm_oss
snd_seq_oss snd_rawmidi snd_seq_device iwlcore mac80211
compat_firmware_class video output intel_agp usbhid
e1000e[159218.198755] CPU 3: iwlagn autofs4 nfsd auth_rpcgss
snd_hda_codec_realtek font vga16fb snd_hda_intel snd_pcm_oss
snd_seq_dummy snd_rawmidi snd_timer drm_kms_helper drm pcmcia_core
i2c_algo_bit snd_page_alloc serio_raw parport ahci
 [<ffffffff8101b5a1>] mwait_idle+0x71/0xd0
[159218.198813] RDX: 0000000000000000 RSI: ffff88013392ffd8 RDI:
ffffffff81948fa8
[159218.198818] R13: ffff88013392fe68 R14: 0000000000000000 R15:
0000000100f29f31
[159218.198823] CR2: 000000000214dac0 CR3: 00000000a31c9000 CR4:
00000000000006e0
[159218.198828] Call Trace:
[159218.198835]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
[159218.198842] Call Trace:
[159218.198847]  [<ffffffff8104b345>] dequeue_task+0xb5/0xf0
[159218.198852]  [<ffffffff81541e59>] thread_return+0x131/0x418
[159218.198861]  [<ffffffff810780b0>] msleep+0x20/0x30
[159218.198876]  [<ffffffffa0226641>]
drm_fb_helper_force_kernel_mode+0x71/0xa0 [drm_kms_helper]
[159218.198884]  [<ffffffff8154725a>] atomic_notifier_call_chain+0x1a/0x20
[159218.198891]  [<ffffffff8101713b>] die+0x5b/0x90
[159218.198899]  [<ffffffff81544835>] general_protection+0x25/0x30
[159218.198907]  [<ffffffff81019e69>] ? sched_clock+0x9/0x10
[159218.198924]  [<ffffffff812b92bd>] ? rb_insert_color+0x9d/0x160
[159218.198929]  [<ffffffff8106e467>] __do_softirq+0xb7/0x1e0
[159218.198937]  [<ffffffff81015cb5>] do_softirq+0x65/0xa0
[159218.198944]  [<ffffffff81013cb3>] apic_timer_interrupt+0x13/0x20
[159218.198952]  [<ffffffff81011e73>] ? cpu_idle+0xb3/0x110
[159218.198958] Modules linked in: netconsole binfmt_misc ppdev
nfs_acl auth_rpcgss exportfs snd_hda_codec_realtek font softcursor
snd_hda_intel snd_pcm_oss snd_seq_dummy snd_rawmidi snd_timer
drm_kms_helper drm pcmcia_core psmouse snd_page_alloc serio_raw
parport ahci
[159218.199008] Modules linked in:[159218.199219]
[<ffffffffa02266d3>] drm_fb_helper_panic+0x23/0x30 [drm_kms_helper]
[159218.199226]  [<ffffffff81541627>] panic+0x9a/0x137
[159218.199236]  [<ffffffff810397a9>] ? default_spin_lock_flags+0x9/0x10
[159218.199247]  [<ffffffff81019e69>] ? sched_clock+0x9/0x10
[159218.199261]  [<ffffffff8107776b>] run_timer_softirq+0x19b/0x340
[159218.199268]  [<ffffffff8106e467>] __do_softirq+0xb7/0x1e0
[159218.199281]  [<ffffffff81013cb3>] apic_timer_interrupt+0x13/0x20
[159218.199287]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.199294] BUG: scheduling while atomic: swapper/0/0x00000100
 netconsole binfmt_misc nfs_acl snd_hda_codec_realtek tileblit
softcursor vga16fb arc4 snd_hwdep snd_pcm snd_rawmidi snd_timer
drm_kms_helper drm pcmcia_core psmouse snd_page_alloc serio_raw
parport ahci
[159218.199347] Modules linked in: configfs ppdev nfs_acl exportfs
tileblit vga16fb snd_hda_intel snd_pcm_oss snd_seq_dummy
snd_seq_midi_event snd_timer iwlcore mac80211 compat_firmware_class
video output intel_agp parport e1000e[159218.199396] Pid: 0, comm:
swapper Tainted: G      D    2.6.32-24-generic #42-Ubuntu To Be Filled
By O.E.M.
[159218.199407] RBP: ffffffff81013cae R08: 0000000000000000 R09:
0000000000000002
[159218.199411] R13: ffff88013392fe68 R14: 0000000000000000 R15:
0000000100f29f31
[159218.199418] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[159218.199423]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.199428]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
[159218.199433] Call Trace:
[159218.199439]  [<ffffffff8104b345>] dequeue_task+0xb5/0xf0
[159218.199541]  [<ffffffff810780b0>] msleep+0x20/0x30
[159218.199553]  [<ffffffffa0228ee3>]
drm_crtc_helper_set_config+0x783/0x920 [drm_kms_helper]
[159218.199565]  [<ffffffff8154725a>] atomic_notifier_call_chain+0x1a/0x20
[159218.199570]  [<ffffffff8154552a>] oops_end+0xea/0xf0
[159218.199579]  [<ffffffff81544835>] general_protection+0x25/0x30
[159218.199594]  [<ffffffffa0120a40>] ?
sta_addba_resp_timer_expired+0x0/0x50 [mac80211]
[159218.199604]  [<ffffffff812b92bd>] ? rb_insert_color+0x9d/0x160
[159218.199609]  [<ffffffff8106e467>] __do_softirq+0xb7/0x1e0
[159218.199618]  [<ffffffff8106e305>] irq_exit+0x85/0x90
[159218.199624]  <EOI>  [<ffffffff8101b5a1>] ? mwait_idle+0x71/0xd0
[159218.199631]  [<ffffffff81011e73>] ? cpu_idle+0xb3/0x110
[159218.199637] Modules linked in: configfs nfs_acl exportfs tileblit
softcursor arc4 snd_hwdep snd_pcm snd_seq_midi snd_seq i915 iwlcore
compat i2c_algo_bit soundcore cfg80211 intel_agp hid [last unloaded:
iwlagn]
 iwlagn binfmt_misc lockd auth_rpcgss fbcon bitblit vgastate snd_hwdep
snd_pcm snd_seq_midi snd_seq i915 snd compat i2c_algo_bit soundcore
cfg80211 intel_agp hid e1000e[159218.199738] RIP:
0010:[<ffffffff8101b5a1>] [159218.199743] RAX: 0000000000000000 RBX:
ffff88013392ff08 RCX: 0000000000000000
[159218.199748] R10: 0000000000000000 R11: 0000000100f29f34 R12:
ffffffff8101a113
[159218.199752] FS:  0000000000000000(0000) GS:ffff8800282c0000(0000)
knlGS:0000000000000000
[159218.199760] Call Trace:
[159218.199771] Pid: 0, comm: swapper Tainted: G      D
2.6.32-24-generic #42-Ubuntu
 [<ffffffff810536da>] dequeue_task_idle+0x3a/0x50
[159218.199784]  [<ffffffff81541e59>] thread_return+0x131/0x418
[159218.199791]  [<ffffffff815427fe>] schedule_timeout_uninterruptible+0x1e/0x20
[159218.199805]  [<ffffffffa0228ee3>]
drm_crtc_helper_set_config+0x783/0x920 [drm_kms_helper]
[159218.199814]  [<ffffffff815471f6>] notifier_call_chain+0x56/0x80
[159218.199821]  [<ffffffff8154552a>] oops_end+0xea/0xf0
[159218.199829]  [<ffffffff810397a9>] ? default_spin_lock_flags+0x9/0x10
[159218.199840]  [<ffffffff81019e69>] ? sched_clock+0x9/0x10
[159218.199854]  [<ffffffff8107776b>] run_timer_softirq+0x19b/0x340
[159218.199861]  [<ffffffff8106e467>] __do_softirq+0xb7/0x1e0
[159218.199867]  [<ffffffff81015cb5>] do_softirq+0x65/0xa0
[159218.199875]  [<ffffffff81013cb3>] apic_timer_interrupt+0x13/0x20
[159218.199881]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.199889] BUG: scheduling while atomic: swapper/0/0x00000100
 iwlagn netconsole autofs4 lockd sunrpc fbcon bitblit vgastate
snd_hda_codec snd_pcm_oss snd_seq_dummy snd_rawmidi snd_timer
drm_kms_helper drm pcmcia_core psmouse snd_page_alloc serio_raw
parport hid
[159218.200027] Modules linked in: configfs ppdev nfs_acl exportfs
tileblit bitblit arc4 snd_hda_intel snd_hda_codec snd_mixer_oss
snd_seq_oss snd_seq_midi_event snd_seq_device iwlcore mac80211
compat_firmware_class i2c_algo_bit video snd_page_alloc intel_agp
parport e1000e[159218.200074] Pid: 0, comm: swapper Tainted: G      D
  2.6.32-24-generic #42-Ubuntu To Be Filled By O.E.M.
[159218.200079] RSP: 0018:ffff88013392fef8  EFLAGS: 00000246
[159218.200083] RDX: 0000000000000000 RSI: ffff88013392ffd8 RDI:
ffffffff81948fa8
[159218.200091] FS:  0000000000000000(0000) GS:ffff8800282c0000(0000)
knlGS:0000000000000000
[159218.200096] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[159218.200102]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.200108] bad: scheduling from the idle thread!
[159218.200113]  <IRQ> [159218.200119]  [<ffffffff8104b3ee>]
deactivate_task+0x2e/0x40
[159218.200126]  [<ffffffff81077000>] ? process_timeout+0x0/0x10
[159218.200138]  [<ffffffffa02b65a8>] intel_pipe_set_base+0x2e8/0x4b0 [i915]
[159218.200150]  [<ffffffffa02266d3>] drm_fb_helper_panic+0x23/0x30
[drm_kms_helper]
[159218.200156]  [<ffffffff81541627>] panic+0x9a/0x137
[159218.200176]  [<ffffffffa01209a5>] ?
ieee80211_stop_tx_ba_session+0x35/0xd0 [mac80211]
[159218.200185]  [<ffffffffa0120a40>] ?
sta_addba_resp_timer_expired+0x0/0x50 [mac80211]
[159218.200196]  [<ffffffff812b92bd>] ? rb_insert_color+0x9d/0x160
[159218.200205]  [<ffffffff810142ec>] call_softirq+0x1c/0x30
[159218.200211]  [<ffffffff815496c1>] smp_apic_timer_interrupt+0x71/0x9c
 [<ffffffff8101b5a1>] ? mwait_idle+0x71/0xd0
[159218.200224]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
 iwlagn autofs4 ppdev nfs_acl exportfs tileblit softcursor arc4
snd_hwdep snd_pcm snd_seq_oss snd_seq snd_seq_device snd compat
i2c_algo_bit video cfg80211 lp hid [last unloaded: iwlagn]
 netconsole binfmt_misc lockd auth_rpcgss sunrpc exportfs fbcon
bitblit vgastate snd_hda_codec snd_seq_oss snd_seq_midi_event
snd_seq_device iwlcore mac80211 compat pcmcia_core psmouse output
intel_agp usbhid e1000e[159218.200413] Pid: 0, comm: swapper Tainted:
G      D    2.6.32-24-generic #42-Ubuntu To Be Filled By O.E.M.
[159218.200419] RSP: 0018:ffff88013392fef8  EFLAGS: 00000246
[159218.200424] RBP: ffffffff81013cae R08: 0000000000000000 R09:
0000000000000002
[159218.200429] FS:  0000000000000000(0000) GS:ffff8800282c0000(0000)
knlGS:0000000000000000
[159218.200434] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[159218.200437] Call Trace:
[159218.200444]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
[159218.200450] Call Trace:
[159218.200456]  [<ffffffff8104b345>] dequeue_task+0xb5/0xf0
[159218.200470]  [<ffffffff810780b0>] msleep+0x20/0x30
[159218.200489]  [<ffffffffa02266d3>] drm_fb_helper_panic+0x23/0x30
[drm_kms_helper]
[159218.200496]  [<ffffffff81541627>] panic+0x9a/0x137
[159218.200503]  [<ffffffff81545072>] do_general_protection+0x152/0x160
[159218.200514]  [<ffffffffa01209a5>] ?
ieee80211_stop_tx_ba_session+0x35/0xd0 [mac80211]
[159218.200528]  [<ffffffffa0120a87>]
sta_addba_resp_timer_expired+0x47/0x50 [mac80211]
[159218.200542]  [<ffffffff810142ec>] call_softirq+0x1c/0x30
[159218.200550]  [<ffffffff815496c1>] smp_apic_timer_interrupt+0x71/0x9c
[159218.200558]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.200566] BUG: scheduling while atomic: swapper/0/0x00000100
 netconsole binfmt_misc lockd sunrpc output intel_agp usbhid
e1000e[159218.201149] CPU 3: iwlagn autofs4 ppdev auth_rpcgss
snd_hda_codec_realtek font vga16fb snd_hda_intel snd_pcm_oss
snd_seq_dummy snd_seq_midi snd_timer i915 drm compat psmouse soundcore
cfg80211 lp hid [last unloaded: iwlagn][159218.201197] RIP:
0010:[<ffffffff8101b5a1>] [159218.201200] RSP: 0018:ffff88013392fef8
EFLAGS: 00000246
[159218.201281] R10: 0000000000000000 R11: 0000000100f29f34 R12:
ffffffff8101a113
[159218.201286] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[159218.201290] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[159218.201298]  [<ffffffff81011e73>] ? cpu_idle+0xb3/0x110
[159218.201304] Pid: 0, comm: swapper Tainted: G      D
2.6.32-24-generic #42-Ubuntu
 [<ffffffff810536da>] dequeue_task_idle+0x3a/0x50
[159218.201316]  [<ffffffff81541e59>] thread_return+0x131/0x418
[159218.201325]  [<ffffffff810780b0>] msleep+0x20/0x30
[159218.201340]  [<ffffffffa0226641>]
drm_fb_helper_force_kernel_mode+0x71/0xa0 [drm_kms_helper]
[159218.201348]  [<ffffffff8154725a>] atomic_notifier_call_chain+0x1a/0x20
[159218.201355]  [<ffffffff8101713b>] die+0x5b/0x90
[159218.201363]  [<ffffffff81544835>] general_protection+0x25/0x30
[159218.201377]  [<ffffffffa0120a40>] ?
sta_addba_resp_timer_expired+0x0/0x50 [mac80211]
[159218.201391]  [<ffffffff8108f723>] ? ktime_get+0x63/0xe0
[159218.201398]  [<ffffffff810142ec>] call_softirq+0x1c/0x30
[159218.201404]  [<ffffffff815496c1>] smp_apic_timer_interrupt+0x71/0x9c
 [<ffffffff8101b5a1>] ? mwait_idle+0x71/0xd0
[159218.201417]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
 iwlagn autofs4 nfsd auth_rpcgss snd_hda_codec_realtek font vga16fb
snd_hda_intel snd_hwdep snd_seq_dummy snd_rawmidi snd_timer
drm_kms_helper drm pcmcia_core psmouse snd_page_alloc intel_agp usbhid
e1000e[159218.201468] CPU 3: iwlagn autofs4 nfsd auth_rpcgss sunrpc
snd_hda_codec_realtek font vga16fb snd_hda_intel snd_pcm_oss
snd_seq_dummy snd_rawmidi snd_timer drm_kms_helper drm compat
i2c_algo_bit soundcore cfg80211 lp hid
 [<ffffffff8101b5a1>] mwait_idle+0x71/0xd0
[159218.201615] RDX: 0000000000000000 RSI: ffff88013392ffd8 RDI:
ffffffff81948fa8
[159218.201619] R10: 0000000000000000 R11: 0000000100f29f34 R12:
ffffffff8101a113
[159218.201626] CR2: 000000000214dac0 CR3: 00000000a31c9000 CR4:
00000000000006e0
[159218.201631] Call Trace:
[159218.201638]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
[159218.201643] Call Trace:
[159218.201649]  [<ffffffff8104b345>] dequeue_task+0xb5/0xf0
[159218.201663]  [<ffffffff810780b0>] msleep+0x20/0x30
[159218.201678]  [<ffffffffa0226641>]
drm_fb_helper_force_kernel_mode+0x71/0xa0 [drm_kms_helper]
[159218.201686]  [<ffffffff8154725a>] atomic_notifier_call_chain+0x1a/0x20
[159218.201693]  [<ffffffff8101713b>] die+0x5b/0x90
[159218.201701]  [<ffffffff81544835>] general_protection+0x25/0x30
[159218.201715]  [<ffffffffa0120a40>] ?
sta_addba_resp_timer_expired+0x0/0x50 [mac80211]
[159218.201735]  [<ffffffff810946aa>] ? tick_program_event+0x2a/0x30
[159218.201741]  [<ffffffff8106e305>] irq_exit+0x85/0x90
[159218.201747]  <EOI> [159218.201754]  [<ffffffff81011e73>] ?
cpu_idle+0xb3/0x110
[159218.201759] BUG: scheduling while atomic: swapper/0/0x00000100
 configfs ppdev nfs_acl exportfs tileblit vga16fb arc4 snd_hwdep
snd_pcm snd_seq drm_kms_helper drm mac80211 pcmcia_core psmouse
snd_page_alloc serio_raw parport ahci e1000e [last unloaded: iwlagn]
 iwlagn binfmt_misc lockd sunrpc exportfs fbcon bitblit vgastate
snd_hda_codec snd_pcm_oss snd_seq_oss snd_rawmidi snd_timer iwlcore
mac80211 compat_firmware_class psmouse output intel_agp usbhid ahci
[159218.201865] RSP: 0018:ffff88013392fef8  EFLAGS: 00000246
[159218.201870] RBP: ffffffff81013cae R08: 0000000000000000 R09:
0000000000000002
[159218.201969] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[159218.201975]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.201982] bad: scheduling from the idle thread!
[159218.201986]  <IRQ> [159218.201991]  [<ffffffff8104b345>]
dequeue_task+0xb5/0xf0
[159218.202000]  [<ffffffff81077000>] ? process_timeout+0x0/0x10
[159218.202012]  [<ffffffffa02b65a8>] intel_pipe_set_base+0x2e8/0x4b0 [i915]
[159218.202030]  [<ffffffff81541627>] panic+0x9a/0x137
[159218.202037]  [<ffffffff81545072>] do_general_protection+0x152/0x160
[159218.202049]  [<ffffffffa01209a5>] ?
ieee80211_stop_tx_ba_session+0x35/0xd0 [mac80211]
[159218.202063]  [<ffffffffa0120a87>]
sta_addba_resp_timer_expired+0x47/0x50 [mac80211]
[159218.202070]  [<ffffffff8108f723>] ? ktime_get+0x63/0xe0
[159218.202084]  [<ffffffff815496c1>] smp_apic_timer_interrupt+0x71/0x9c
 [<ffffffff8101b5a1>] ? mwait_idle+0x71/0xd0
[159218.202096]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
[159218.202100] Modules linked in: autofs4 nfsd auth_rpcgss
snd_hda_codec_realtek font vga16fb snd_hda_intel snd_pcm_oss snd_pcm
snd_seq_midi snd_rawmidi snd_seq i915 snd compat i2c_algo_bit
soundcore cfg80211 serio_raw lp hid e1000e
 iwlagn binfmt_misc ppdev lockd sunrpc fbcon bitblit vgastate
snd_hda_intel snd_mixer_oss snd_seq_oss snd_seq_midi_event
snd_seq_device iwlcore mac80211 compat_firmware_class video output
intel_agp usbhid ahci[159218.202199] Pid: 0, comm: swapper Tainted: G
    D    2.6.32-24-generic #42-Ubuntu To Be Filled By O.E.M.
 [<ffffffff8101b5a1>] mwait_idle+0x71/0xd0
 autofs4 nfsd auth_rpcgss snd_hda_codec_realtek font vga16fb
snd_hda_intel snd_pcm_oss snd_seq_dummy snd_rawmidi snd_timer
drm_kms_helper drm pcmcia_core psmouse snd_page_alloc serio_raw
parport ahci

 configfs ppdev nfs_acl exportfs tileblit softcursor arc4
snd_hda_codec snd_mixer_oss snd_seq_midi snd_seq snd_timer i915
iwlcore compat i2c_algo_bit soundcore output cfg80211 usbhid
e1000e[159218.202538] Pid: 0, comm: swapper Tainted: G      D
2.6.32-24-generic #42-Ubuntu To Be Filled By O.E.M.
[159218.202543] RSP: 0018:ffff88013392fef8  EFLAGS: 00000246
[159218.202548] RBP: ffffffff81013cae R08: 0000000000000000 R09:
0000000000000002
[159218.202554] FS:  0000000000000000(0000) GS:ffff8800282c0000(0000)
knlGS:0000000000000000
[159218.202559] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[159218.202564]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.202571] bad: scheduling from the idle thread!
[159218.202577]  <IRQ> [159218.202583]  [<ffffffff8104b3ee>]
deactivate_task+0x2e/0x40
[159218.202590]  [<ffffffff81077000>] ? process_timeout+0x0/0x10
[159218.202602]  [<ffffffffa02b65a8>] intel_pipe_set_base+0x2e8/0x4b0 [i915]
[159218.202620]  [<ffffffff81541627>] panic+0x9a/0x137
[159218.202627]  [<ffffffff81545072>] do_general_protection+0x152/0x160
[159218.202633]  [<ffffffff81544835>] general_protection+0x25/0x30
[159218.202653]  [<ffffffffa0120a87>]
sta_addba_resp_timer_expired+0x47/0x50 [mac80211]
[159218.202660]  [<ffffffff8108f723>] ? ktime_get+0x63/0xe0
[159218.202675]  [<ffffffff815496c1>] smp_apic_timer_interrupt+0x71/0x9c
 [<ffffffff8101b5a1>] ? mwait_idle+0x71/0xd0
[159218.202688]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
 iwlagn autofs4 nfsd auth_rpcgss snd_hda_codec_realtek font vga16fb
snd_hda_intel snd_pcm_oss snd_seq_dummy snd_rawmidi snd_timer
drm_kms_helper drm pcmcia_core psmouse soundcore serio_raw lp ahci
[159218.202829] Modules linked in: configfs ppdev nfs_acl exportfs
tileblit softcursor arc4 snd_hwdep snd_pcm snd_seq_midi snd_seq i915
drm_kms_helper iwlcore compat compat_firmware_class soundcore cfg80211
lp hid ahci e1000e[159218.202877] Pid: 0, comm: swapper Tainted: G
 D    2.6.32-24-generic #42-Ubuntu To Be Filled By O.E.M.
[159218.202883] RSP: 0018:ffff88013392fef8  EFLAGS: 00000246
[159218.202888] RBP: ffffffff81013cae R08: 0000000000000000 R09:
0000000000000002
[159218.202895] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[159218.202900] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[159218.202906]  [<ffffffff81011e73>] ? cpu_idle+0xb3/0x110
[159218.202912] Pid: 0, comm: swapper Tainted: G      D
2.6.32-24-generic #42-Ubuntu
 [<ffffffff810536da>] dequeue_task_idle+0x3a/0x50
[159218.202924]  [<ffffffff81541e59>] thread_return+0x131/0x418
[159218.202931]  [<ffffffff815427fe>] schedule_timeout_uninterruptible+0x1e/0x20
[159218.202945]  [<ffffffffa0228ee3>]
drm_crtc_helper_set_config+0x783/0x920 [drm_kms_helper]
[159218.202963]  [<ffffffff8154552a>] oops_end+0xea/0xf0
[159218.202970]  [<ffffffff810397a9>] ? default_spin_lock_flags+0x9/0x10
[159218.202981]  [<ffffffff81019e69>] ? sched_clock+0x9/0x10
[159218.202995]  [<ffffffff8107776b>] run_timer_softirq+0x19b/0x340
[159218.203002]  [<ffffffff8106e467>] __do_softirq+0xb7/0x1e0
[159218.203016]  [<ffffffff81013cb3>] apic_timer_interrupt+0x13/0x20
[159218.203021]  [<ffffffff8154725a>] ? atomic_notifier_call_chain+0x1a/0x20
[159218.203028] BUG: scheduling while atomic: swapper/0/0x00000100
 netconsole binfmt_misc nfsd auth_rpcgss fbcon bitblit vgastate
snd_hda_intel snd_mixer_oss snd_seq_oss snd_rawmidi snd_timer
drm_kms_helper drm compat psmouse snd_page_alloc cfg80211 parport hid
[159218.203080] Modules linked in: iwlagn configfs ppdev nfs_acl
exportfs tileblit softcursor vga16fb arc4 snd_hwdep snd_pcm
snd_seq_midi snd_seq i915 snd drm mac80211 compat_firmware_class
output serio_raw usbhid e1000e[159218.203216] Pid: 0, comm: swapper
Tainted: G      D    2.6.32-24-generic #42-Ubuntu To Be Filled By
O.E.M.
[159218.203222] RSP: 0018:ffff88013392fef8  EFLAGS: 00000246
[159218.203230] R13: ffff88013392fe68 R14: 0000000000000000 R15:
0000000100f29f31
[159218.203238] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[159218.203241] Call Trace:
[159218.203249] bad: scheduling from the idle thread!
[159218.203253] Call Trace:
[159218.203258]  [<ffffffff8104b345>] dequeue_task+0xb5/0xf0
[159218.203268]  [<ffffffff81077000>] ? process_timeout+0x0/0x10
[159218.203273]  [<ffffffff810780b0>] msleep+0x20/0x30
[159218.203298]  [<ffffffff81541627>] panic+0x9a/0x137
[159218.203305]  [<ffffffff81545072>] do_general_protection+0x152/0x160
[159218.203310]  [<ffffffff81544835>] general_protection+0x25/0x30
[159218.203330]  [<ffffffffa0120a87>]
sta_addba_resp_timer_expired+0x47/0x50 [mac80211]
[159218.203338]  [<ffffffff8108f723>] ? ktime_get+0x63/0xe0
[159218.203353]  [<ffffffff815496c1>] smp_apic_timer_interrupt+0x71/0x9c
 [<ffffffff8101b5a1>] ? mwait_idle+0x71/0xd0
[159218.203363]  [<ffffffff81011e73>] ? cpu_idle+0xb3/0x110
 iwlagn autofs4 nfsd lockd nfs_acl auth_rpcgss sunrpc
snd_hda_codec_realtek font softcursor arc4 snd_hwdep snd_seq_dummy
snd_seq_midi_event snd_seq_device iwlcore mac80211
compat_firmware_class psmouse output intel_agp parport usbhid
e1000e[159218.203418] CPU 3: iwlagn autofs4 nfsd nfs_acl
snd_hda_codec_realtek fbcon tileblit softcursor arc4 snd_pcm_oss
snd_seq_dummy snd_rawmidi snd_timer drm_kms_helper iwlcore snd compat
compat_firmware_class soundcore output lp hid [last unloaded:
iwlagn][159218.203471] RIP: 0010:[<ffffffff8101b5a1>] [159218.203476]
RAX: 0000000000000000 RBX: ffff88013392ff08 RCX: 0000000000000000
[159218.203485] FS:  0000000000000000(0000) GS:ffff8800282c0000(0000)
knlGS:0000000000000000
[159218.203579] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
 snd_seq_oss snd_seq_midi_event snd_seq_device iwlcore mac80211
pcmcia_core psmouse snd_page_alloc serio_raw parport ahci
 iwlagn autofs4 nfsd auth_rpcgss exportfs font vga16fb snd_hda_intel
snd_hwdep snd_seq_dummy snd_rawmidi snd_timer drm_kms_helper drm
compat psmouse soundcore serio_raw lp hid
 [<ffffffff8101b5a1>] mwait_idle+0x71/0xd0
[159218.204294] RDX: 0000000000000000 RSI: ffff88013392ffd8 RDI:
ffffffff81948fa8
[159218.204297] R10: 0000000000000000 R11: 0000000100f29f34 R12:
ffffffff8101a113
[159218.204304] CR2: 000000000214dac0 CR3: 00000000a31c9000 CR4:
00000000000006e0
[159218.204309] Call Trace:
[159218.204316]  [<ffffffff8153e33e>] ? start_secondary+0xa8/0xaa
[159218.204320] Pid: 0, comm: swapper Tainted: G      D
2.6.32-24-generic #42-Ubuntu
[159218.204322] Call Trace:
 [<ffffffff810536da>] dequeue_task_idle+0x3a/0x50
[159218.204333]  [<ffffffff81541e59>] thread_return+0x131/0x418
[159218.204340]  [<ffffffff815427fe>] schedule_timeout_uninterruptible+0x1e/0x20
[159218.204353]  [<ffffffffa0228ee3>]
drm_crtc_helper_set_config+0x783/0x920 [drm_kms_helper]
[159218.204365]  [<ffffffff8154725a>] atomic_notifier_call_chain+0x1a/0x20
[159218.204372]  [<ffffffff8101713b>] die+0x5b/0x90
[159218.204377]  [<ffffffff810397a9>] ? default_spin_lock_flags+0x9/0x10
[159218.204394]  [<ffffffffa0120a40>] ?
sta_addba_resp_timer_expired+0x0/0x50 [mac80211]
[159218.204404]  [<ffffffff812b92bd>] ? rb_insert_color+0x9d/0x160
[159218.204411]  [<ffffffff810946aa>] ? tick_program_event+0x2a/0x30
[159218.204425]  <EOI>  [<ffffffff8101b5a1>] ? mwait_idle+0x71/0xd0
