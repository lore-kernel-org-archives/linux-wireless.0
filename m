Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4037 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab3CRTro (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 15:47:44 -0400
Message-ID: <51476F35.9040909@broadcom.com> (sfid-20130318_204750_925774_0FD0CEBE)
Date: Mon, 18 Mar 2013 20:47:01 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org,
	"David Spinadel" <dvdspndl@gmail.com>
Subject: BUG: problem while tracing cfg80211
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

While testing David Spinadel's P2P device support functionality I got 
the following blurb, which is probably caused by cfg80211 tracing given 
the instruction pointer address.

brcmfmac returns ERR_PTR(-ENOENT) and I think the trace code/macros do 
not take this into account.

Gr. AvS

---8<------------------------------------------------------------------
[  224.558144] BUG: unable to handle kernel paging request at fffffffe
[  224.564732] IP: [<f8335e4c>] 
ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 [cfg80211]
[  224.572552] *pde = 0184a067 *pte = 00000000
[  224.577151] Oops: 0000 [#1] SMP
[  224.580700] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O) 
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi dell_laptop 
snd_seq_midi_event dell_wmi dcdbas psmouse sparse_keymap snd_seq 
coretemp serio_raw snd_timer snd_seq_device snd soundcore snd_page_alloc 
intel_ips microcode lpc_ich mfd_core nouveau ttm drm_kms_helper drm 
i2c_algo_bit mxm_wmi crc32c_intel intel_agp intel_gtt firewire_ohci 
sdhci_pci sdhci ahci mmc_core libahci firewire_core e1000e crc_itu_t ptp 
pps_core video agpgart [last unloaded: brcmfmac]
[  224.634833] Pid: 2614, comm: wpa_supplicant Tainted: G           O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1 Dell Inc. Latitude 
E6410/07XJP9
[  224.648198] EIP: 0060:[<f8335e4c>] EFLAGS: 00210282 CPU: 3
[  224.654033] EIP is at ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  224.661233] EAX: ffffffea EBX: f04819b8 ECX: ffffffea EDX: f7246fc8
[  224.667837] ESI: f04819bc EDI: f835ae40 EBP: f0535bf0 ESP: f0535bc8
[  224.674437]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  224.680173] CR0: 80050033 CR2: fffffffe CR3: 34454000 CR4: 000007d0
[  224.686773] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  224.693385] DR6: ffff0ff0 DR7: 00000400
[  224.697561] Process wpa_supplicant (pid: 2614, ti=f0534000 
task=f2b60000 task.ti=f0534000)
[  224.706174] Stack:
[  224.708530]  00200292 00000001 f04e02c0 00200292 00000001 ffffffea 
f4c5e380 f3cbc190
[  224.716745]  ffffffea f8335dd0 f0535c40 f8312505 00000000 f0535c24 
f8312f04 c12c6ccc
[  224.724964]  00000000 f20ef500 f04e02c0 f0535c6c f04e0000 0000000a 
00000000 00000000
[  224.733186] Call Trace:
[  224.736009]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  224.744651]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  224.751557]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  224.758190]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  224.763441]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  224.770249]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  224.775404]  [<c145cb84>] ? genl_lock+0x14/0x20
[  224.780305]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  224.785116]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  224.790363]  [<c145cbac>] genl_rcv+0x1c/0x30
[  224.794996]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  224.800409]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  224.805821]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  224.810886]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  224.815870]  [<c11183de>] ? might_fault+0x9e/0xb0
[  224.820920]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  224.826314]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  224.831557]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  224.836785]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  224.841664]  [<c1118394>] ? might_fault+0x54/0xb0
[  224.846710]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  224.851583]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  224.856888]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  224.862898]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  224.868207] Code: e8 8a bb d9 c8 89 c6 8b 45 e0 8b 90 f4 00 00 00 85 
d2 74 6b 8d 46 08 b9 20 00 00 00 e8 ce ed f7 c8 8b 45 ec 85 c0 74 4f 8b 
4d ec <8b> 41 14 89 46 28 8b 45 f0 89 f1 89 1c 24 89 fa e8 af f2 d9 c8
[  224.888716] EIP: [<f8335e4c>] 
ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 [cfg80211] SS:ESP 0068:f0535bc8
[  224.898528] CR2: 00000000fffffffe
[  224.902230] ---[ end trace 55dda37028829c2c ]---
[  224.907232] BUG: sleeping function called from invalid context at 
kernel/rwsem.c:20
[  224.915431] in_atomic(): 1, irqs_disabled(): 1, pid: 2614, name: 
wpa_supplicant
[  224.923117] INFO: lockdep is turned off.
[  224.927422] irq event stamp: 0
[  224.930850] hardirqs last  enabled at (0): [<  (null)>]   (null)
[  224.937247] hardirqs last disabled at (0): [<c1038066>] 
copy_process+0x486/0x1290
[  224.945124] softirqs last  enabled at (0): [<c1038066>] 
copy_process+0x486/0x1290
[  224.952997] softirqs last disabled at (0): [<  (null)>]   (null)
[  224.959398] Pid: 2614, comm: wpa_supplicant Tainted: G      D    O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  224.970032] Call Trace:
[  224.972849]  [<c1066d58>] __might_sleep+0xe8/0x120
[  224.978002]  [<c1524b7f>] down_read+0x1f/0x60
[  224.982712]  [<c104e4ae>] exit_signals+0x1e/0x110
[  224.987764]  [<c103f447>] do_exit+0x97/0x9b0
[  224.992387]  [<c103d4c8>] ? kmsg_dump+0xe8/0x110
[  224.997353]  [<c103d4dc>] ? kmsg_dump+0xfc/0x110
[  225.002322]  [<c15287aa>] oops_end+0x9a/0xe0
[  225.006937]  [<c151e0d1>] no_context+0x18c/0x194
[  225.011902]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  225.017310]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  225.023304]  [<c108954d>] ? ktime_get+0x5d/0x100
[  225.028260]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  225.033814]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  225.039454]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  225.044832]  [<c1008738>] ? sched_clock+0x8/0x10
[  225.049771]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  225.056013]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  225.061555]  [<c152b1ad>] do_page_fault+0xd/0x10
[  225.066496]  [<c1527f74>] error_code+0x6c/0x74
[  225.071256]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  225.076467]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  225.084199]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  225.092791]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  225.099653]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  225.106257]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  225.111473]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  225.118236]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  225.123356]  [<c145cb84>] ? genl_lock+0x14/0x20
[  225.128207]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  225.132987]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  225.138181]  [<c145cbac>] genl_rcv+0x1c/0x30
[  225.142772]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  225.148146]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  225.153536]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  225.158558]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  225.163495]  [<c11183de>] ? might_fault+0x9e/0xb0
[  225.168528]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  225.173916]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  225.179033]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  225.184233]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  225.189081]  [<c1118394>] ? might_fault+0x54/0xb0
[  225.194090]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  225.198900]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  225.204140]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  225.210078]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  225.215312] BUG: scheduling while atomic: wpa_supplicant/2614/0x10000003
[  225.222280] INFO: lockdep is turned off.
[  225.226468] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O) 
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi dell_laptop 
snd_seq_midi_event dell_wmi dcdbas psmouse sparse_keymap snd_seq 
coretemp serio_raw snd_timer snd_seq_device snd soundcore snd_page_alloc 
intel_ips microcode lpc_ich mfd_core nouveau ttm drm_kms_helper drm 
i2c_algo_bit mxm_wmi crc32c_intel intel_agp intel_gtt firewire_ohci 
sdhci_pci sdhci ahci mmc_core libahci firewire_core e1000e crc_itu_t ptp 
pps_core video agpgart [last unloaded: brcmfmac]
[  225.280460] irq event stamp: 0
[  225.283805] hardirqs last  enabled at (0): [<  (null)>]   (null)
[  225.290117] hardirqs last disabled at (0): [<c1038066>] 
copy_process+0x486/0x1290
[  225.297904] softirqs last  enabled at (0): [<c1038066>] 
copy_process+0x486/0x1290
[  225.305685] softirqs last disabled at (0): [<  (null)>]   (null)
[  225.311989] Pid: 2614, comm: wpa_supplicant Tainted: G      D    O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  225.322537] Call Trace:
[  225.325278]  [<c151eb8a>] __schedule_bug+0x68/0x7a
[  225.330364]  [<c152570c>] __schedule+0x79c/0x7e0
[  225.335270]  [<c10055ac>] ? show_trace_log_lvl+0x4c/0x60
[  225.340900]  [<c10055df>] ? show_trace+0x1f/0x30
[  225.345811]  [<c151d47f>] ? dump_stack+0x73/0x7a
[  225.350717]  [<c1066d58>] ? __might_sleep+0xe8/0x120
[  225.355973]  [<c10697bb>] __cond_resched+0x1b/0x30
[  225.361059]  [<c15257c9>] _cond_resched+0x29/0x30
[  225.366054]  [<c1524b84>] down_read+0x24/0x60
[  225.370698]  [<c104e4ae>] exit_signals+0x1e/0x110
[  225.375692]  [<c103f447>] do_exit+0x97/0x9b0
[  225.380254]  [<c103d4c8>] ? kmsg_dump+0xe8/0x110
[  225.385163]  [<c103d4dc>] ? kmsg_dump+0xfc/0x110
[  225.390075]  [<c15287aa>] oops_end+0x9a/0xe0
[  225.394637]  [<c151e0d1>] no_context+0x18c/0x194
[  225.399548]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  225.404895]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  225.410845]  [<c108954d>] ? ktime_get+0x5d/0x100
[  225.415755]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  225.421268]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  225.426867]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  225.432208]  [<c1008738>] ? sched_clock+0x8/0x10
[  225.437114]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  225.443328]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  225.448845]  [<c152b1ad>] do_page_fault+0xd/0x10
[  225.453748]  [<c1527f74>] error_code+0x6c/0x74
[  225.458494]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  225.463682]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  225.471382]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  225.479948]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  225.486778]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  225.493337]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  225.498513]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  225.505246]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  225.510330]  [<c145cb84>] ? genl_lock+0x14/0x20
[  225.515161]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  225.519898]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  225.525067]  [<c145cbac>] genl_rcv+0x1c/0x30
[  225.529624]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  225.534966]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  225.540311]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  225.545306]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  225.550218]  [<c11183de>] ? might_fault+0x9e/0xb0
[  225.555215]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  225.560559]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  225.565637]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  225.570805]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  225.575612]  [<c1118394>] ? might_fault+0x54/0xb0
[  225.580583]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  225.585378]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  225.590605]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  225.596536]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  225.601835] note: wpa_supplicant[2614] exited with preempt_count 2
[  225.608312] BUG: scheduling while atomic: wpa_supplicant/2614/0x10000003
[  225.615245] INFO: lockdep is turned off.
[  225.619358] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O) 
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi dell_laptop 
snd_seq_midi_event dell_wmi dcdbas psmouse sparse_keymap snd_seq 
coretemp serio_raw snd_timer snd_seq_device snd soundcore snd_page_alloc 
intel_ips microcode lpc_ich mfd_core nouveau ttm drm_kms_helper drm 
i2c_algo_bit mxm_wmi crc32c_intel intel_agp intel_gtt firewire_ohci 
sdhci_pci sdhci ahci mmc_core libahci firewire_core e1000e crc_itu_t ptp 
pps_core video agpgart [last unloaded: brcmfmac]
[  225.673159] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  225.683640] Call Trace:
[  225.686360]  [<c151eb8a>] __schedule_bug+0x68/0x7a
[  225.691354]  [<c152570c>] __schedule+0x79c/0x7e0
[  225.696201]  [<c10424f9>] ? irq_exit+0x69/0xb0
[  225.700872]  [<c105ea05>] ? lock_hrtimer_base.isra.21+0x25/0x50
[  225.707005]  [<c12bf8df>] ? do_raw_spin_lock+0x3f/0x100
[  225.712441]  [<c10697bb>] __cond_resched+0x1b/0x30
[  225.717489]  [<c15257c9>] _cond_resched+0x29/0x30
[  225.722472]  [<c1524b84>] down_read+0x24/0x60
[  225.727043]  [<c105ec9b>] ? hrtimer_try_to_cancel+0x3b/0xa0
[  225.732816]  [<c10a4574>] acct_collect+0x44/0x170
[  225.737722]  [<c103facf>] do_exit+0x71f/0x9b0
[  225.742352]  [<c15287aa>] oops_end+0x9a/0xe0
[  225.746823]  [<c151e0d1>] no_context+0x18c/0x194
[  225.751643]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  225.756950]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  225.762837]  [<c108954d>] ? ktime_get+0x5d/0x100
[  225.767710]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  225.773134]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  225.778639]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  225.783943]  [<c1008738>] ? sched_clock+0x8/0x10
[  225.788768]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  225.794940]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  225.800366]  [<c152b1ad>] do_page_fault+0xd/0x10
[  225.805191]  [<c1527f74>] error_code+0x6c/0x74
[  225.809855]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  225.815001]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  225.822626]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  225.831380]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  225.838138]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  225.844658]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  225.849771]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  225.856481]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  225.861520]  [<c145cb84>] ? genl_lock+0x14/0x20
[  225.866303]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  225.870976]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  225.876075]  [<c145cbac>] genl_rcv+0x1c/0x30
[  225.880596]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  225.885895]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  225.891201]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  225.896149]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  225.900991]  [<c11183de>] ? might_fault+0x9e/0xb0
[  225.905959]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  225.911215]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  225.916214]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  225.921362]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  225.926105]  [<c1118394>] ? might_fault+0x54/0xb0
[  225.931021]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  225.935749]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  225.940904]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  225.946853]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  225.952080] BUG: sleeping function called from invalid context at 
kernel/rwsem.c:20
[  225.959936] in_atomic(): 1, irqs_disabled(): 0, pid: 2614, name: 
wpa_supplicant
[  225.967442] INFO: lockdep is turned off.
[  225.971544] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  225.981982] Call Trace:
[  225.984608]  [<c1066d58>] __might_sleep+0xe8/0x120
[  225.989584]  [<c1524b7f>] down_read+0x1f/0x60
[  225.994125]  [<c103f50f>] do_exit+0x15f/0x9b0
[  225.998666]  [<c15287aa>] oops_end+0x9a/0xe0
[  226.003131]  [<c151e0d1>] no_context+0x18c/0x194
[  226.007957]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  226.013218]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  226.019086]  [<c108954d>] ? ktime_get+0x5d/0x100
[  226.023897]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  226.029339]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  226.034842]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  226.040115]  [<c1008738>] ? sched_clock+0x8/0x10
[  226.044948]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  226.051080]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  226.056513]  [<c152b1ad>] do_page_fault+0xd/0x10
[  226.061339]  [<c1527f74>] error_code+0x6c/0x74
[  226.065978]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  226.071076]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  226.078695]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  226.087179]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  226.093934]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  226.100423]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  226.105524]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  226.112162]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  226.117180]  [<c145cb84>] ? genl_lock+0x14/0x20
[  226.121925]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  226.126564]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  226.131641]  [<c145cbac>] genl_rcv+0x1c/0x30
[  226.136107]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  226.141412]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  226.146657]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  226.151576]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  226.156387]  [<c11183de>] ? might_fault+0x9e/0xb0
[  226.161297]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  226.166543]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  226.171527]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  226.176615]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  226.181339]  [<c1118394>] ? might_fault+0x54/0xb0
[  226.186247]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  226.190969]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  226.196125]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  226.201974]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  226.207127] BUG: scheduling while atomic: wpa_supplicant/2614/0x10000003
[  226.214018] INFO: lockdep is turned off.
[  226.218122] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O) 
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi dell_laptop 
snd_seq_midi_event dell_wmi dcdbas psmouse sparse_keymap snd_seq 
coretemp serio_raw snd_timer snd_seq_device snd soundcore snd_page_alloc 
intel_ips microcode lpc_ich mfd_core nouveau ttm drm_kms_helper drm 
i2c_algo_bit mxm_wmi crc32c_intel intel_agp intel_gtt firewire_ohci 
sdhci_pci sdhci ahci mmc_core libahci firewire_core e1000e crc_itu_t ptp 
pps_core video agpgart [last unloaded: brcmfmac]
[  226.271655] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  226.282121] Call Trace:
[  226.284781]  [<c151eb8a>] __schedule_bug+0x68/0x7a
[  226.289806]  [<c152570c>] __schedule+0x79c/0x7e0
[  226.294654]  [<c10055ac>] ? show_trace_log_lvl+0x4c/0x60
[  226.300209]  [<c10055df>] ? show_trace+0x1f/0x30
[  226.305054]  [<c151d47f>] ? dump_stack+0x73/0x7a
[  226.309891]  [<c1066d58>] ? __might_sleep+0xe8/0x120
[  226.315123]  [<c10697bb>] __cond_resched+0x1b/0x30
[  226.320129]  [<c15257c9>] _cond_resched+0x29/0x30
[  226.325042]  [<c1524b84>] down_read+0x24/0x60
[  226.329611]  [<c103f50f>] do_exit+0x15f/0x9b0
[  226.334176]  [<c15287aa>] oops_end+0x9a/0xe0
[  226.338656]  [<c151e0d1>] no_context+0x18c/0x194
[  226.343493]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  226.348762]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  226.354634]  [<c108954d>] ? ktime_get+0x5d/0x100
[  226.359461]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  226.364916]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  226.370455]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  226.375731]  [<c1008738>] ? sched_clock+0x8/0x10
[  226.380558]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  226.386688]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  226.392121]  [<c152b1ad>] do_page_fault+0xd/0x10
[  226.396958]  [<c1527f74>] error_code+0x6c/0x74
[  226.401619]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  226.406716]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  226.406728]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  226.406737]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  226.406745]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  226.406747]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  226.406756]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  226.406757]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  226.406759]  [<c145cb84>] ? genl_lock+0x14/0x20
[  226.406760]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  226.406761]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  226.406762]  [<c145cbac>] genl_rcv+0x1c/0x30
[  226.406764]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  226.406765]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  226.406766]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  226.406768]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  226.406769]  [<c11183de>] ? might_fault+0x9e/0xb0
[  226.406771]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  226.406772]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  226.406773]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  226.406776]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  226.406777]  [<c1118394>] ? might_fault+0x54/0xb0
[  226.406778]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  226.406779]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  226.406781]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  226.406782]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  226.406923] BUG: scheduling while atomic: wpa_supplicant/2614/0x10000003
[  226.406924] INFO: lockdep is turned off.
[  226.406941] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O) 
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi dell_laptop 
snd_seq_midi_event dell_wmi dcdbas psmouse sparse_keymap snd_seq 
coretemp serio_raw snd_timer snd_seq_device snd soundcore snd_page_alloc 
intel_ips microcode lpc_ich mfd_core nouveau ttm drm_kms_helper drm 
i2c_algo_bit mxm_wmi crc32c_intel intel_agp intel_gtt firewire_ohci 
sdhci_pci sdhci ahci mmc_core libahci firewire_core e1000e crc_itu_t ptp 
pps_core video agpgart [last unloaded: brcmfmac]
[  226.406942] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  226.406943] Call Trace:
[  226.406945]  [<c151eb8a>] __schedule_bug+0x68/0x7a
[  226.406946]  [<c152570c>] __schedule+0x79c/0x7e0
[  226.406948]  [<c106824c>] ? ttwu_stat+0xac/0x140
[  226.406951]  [<c10931bb>] ? trace_hardirqs_off+0xb/0x10
[  226.406952]  [<c1527255>] ? _raw_spin_unlock_irqrestore+0x65/0x70
[  226.406953]  [<c10697bb>] __cond_resched+0x1b/0x30
[  226.406954]  [<c15257c9>] _cond_resched+0x29/0x30
[  226.406956]  [<c1525f29>] wait_for_completion+0x29/0xd0
[  226.406957]  [<c10b02ef>] ? queue_stop_cpus_work+0x8f/0xb0
[  226.406958]  [<c10b0463>] __stop_cpus+0x53/0x80
[  226.406962]  [<c10c40a0>] ? __rcu_process_gp_end+0x120/0x120
[  226.406963]  [<c10c40a0>] ? __rcu_process_gp_end+0x120/0x120
[  226.406964]  [<c10b05ca>] try_stop_cpus+0x3a/0x60
[  226.406966]  [<c10c5547>] synchronize_sched_expedited+0xb7/0x180
[  226.406967]  [<c10c561d>] synchronize_rcu_expedited+0xd/0x10
[  226.406969]  [<c1434035>] synchronize_net+0x45/0x50
[  226.406971]  [<c14fec5c>] packet_release+0x1bc/0x290
[  226.406973]  [<c1153c6a>] ? mntput_no_expire+0x3a/0x120
[  226.406974]  [<c1422c70>] sock_release+0x20/0x80
[  226.406975]  [<c1422e17>] sock_close+0x17/0x30
[  226.406977]  [<c113952d>] __fput+0xad/0x210
[  226.406979]  [<c113969d>] ____fput+0xd/0x10
[  226.406980]  [<c1058371>] task_work_run+0xa1/0xd0
[  226.406981]  [<c103f655>] do_exit+0x2a5/0x9b0
[  226.406983]  [<c15287aa>] oops_end+0x9a/0xe0
[  226.406984]  [<c151e0d1>] no_context+0x18c/0x194
[  226.406985]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  226.406987]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  226.406988]  [<c108954d>] ? ktime_get+0x5d/0x100
[  226.406989]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  226.406990]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  226.406991]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  226.406993]  [<c1008738>] ? sched_clock+0x8/0x10
[  226.406995]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  226.406996]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  226.406997]  [<c152b1ad>] do_page_fault+0xd/0x10
[  226.406998]  [<c1527f74>] error_code+0x6c/0x74
[  226.407000]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  226.407010]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  226.407021]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  226.407029]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  226.407038]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  226.407039]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  226.407048]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  226.407049]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  226.407051]  [<c145cb84>] ? genl_lock+0x14/0x20
[  226.407052]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  226.407053]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  226.407054]  [<c145cbac>] genl_rcv+0x1c/0x30
[  226.407056]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  226.407057]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  226.407058]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  226.407060]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  226.407061]  [<c11183de>] ? might_fault+0x9e/0xb0
[  226.407063]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  226.407064]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  226.407065]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  226.407067]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  226.407069]  [<c1118394>] ? might_fault+0x54/0xb0
[  226.407070]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  226.407071]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  226.407073]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  226.407074]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  226.407078] BUG: scheduling while atomic: wpa_supplicant/2614/0x00000003
[  226.407078] INFO: lockdep is turned off.
[  226.407092] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O) 
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi dell_laptop 
snd_seq_midi_event dell_wmi dcdbas psmouse sparse_keymap snd_seq 
coretemp serio_raw snd_timer snd_seq_device snd soundcore snd_page_alloc 
intel_ips microcode lpc_ich mfd_core nouveau ttm drm_kms_helper drm 
i2c_algo_bit mxm_wmi crc32c_intel intel_agp intel_gtt firewire_ohci 
sdhci_pci sdhci ahci mmc_core libahci firewire_core e1000e crc_itu_t ptp 
pps_core video agpgart [last unloaded: brcmfmac]
[  226.407093] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  226.407093] Call Trace:
[  226.407095]  [<c151eb8a>] __schedule_bug+0x68/0x7a
[  226.407096]  [<c152570c>] __schedule+0x79c/0x7e0
[  226.407098]  [<c1097aeb>] ? trace_hardirqs_on+0xb/0x10
[  226.407099]  [<c15271d7>] ? _raw_spin_unlock_irq+0x27/0x40
[  226.407100]  [<c1065d5f>] ? finish_task_switch+0x7f/0xe0
[  226.407101]  [<c1065d1d>] ? finish_task_switch+0x3d/0xe0
[  226.407102]  [<c1525318>] ? __schedule+0x3a8/0x7e0
[  226.407103]  [<c1525ff3>] schedule+0x23/0x60
[  226.407105]  [<c152360d>] schedule_timeout+0x15d/0x210
[  226.407106]  [<c1525f30>] ? wait_for_completion+0x30/0xd0
[  226.407107]  [<c12bf8df>] ? do_raw_spin_lock+0x3f/0x100
[  226.407109]  [<c1525f8d>] wait_for_completion+0x8d/0xd0
[  226.407110]  [<c106bf90>] ? try_to_wake_up+0x260/0x260
[  226.407111]  [<c10b0463>] __stop_cpus+0x53/0x80
[  226.407113]  [<c10c40a0>] ? __rcu_process_gp_end+0x120/0x120
[  226.407114]  [<c10c40a0>] ? __rcu_process_gp_end+0x120/0x120
[  226.407115]  [<c10b05ca>] try_stop_cpus+0x3a/0x60
[  226.407116]  [<c10c5547>] synchronize_sched_expedited+0xb7/0x180
[  226.407118]  [<c10c561d>] synchronize_rcu_expedited+0xd/0x10
[  226.407119]  [<c1434035>] synchronize_net+0x45/0x50
[  226.407120]  [<c14fec5c>] packet_release+0x1bc/0x290
[  226.407122]  [<c1153c6a>] ? mntput_no_expire+0x3a/0x120
[  226.407123]  [<c1422c70>] sock_release+0x20/0x80
[  226.407124]  [<c1422e17>] sock_close+0x17/0x30
[  226.407125]  [<c113952d>] __fput+0xad/0x210
[  226.407126]  [<c113969d>] ____fput+0xd/0x10
[  226.407128]  [<c1058371>] task_work_run+0xa1/0xd0
[  226.407129]  [<c103f655>] do_exit+0x2a5/0x9b0
[  226.407130]  [<c15287aa>] oops_end+0x9a/0xe0
[  226.407131]  [<c151e0d1>] no_context+0x18c/0x194
[  226.407132]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  226.407134]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  226.407135]  [<c108954d>] ? ktime_get+0x5d/0x100
[  226.407136]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  226.407137]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  226.407138]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  226.407139]  [<c1008738>] ? sched_clock+0x8/0x10
[  226.407141]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  226.407142]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  226.407143]  [<c152b1ad>] do_page_fault+0xd/0x10
[  226.407145]  [<c1527f74>] error_code+0x6c/0x74
[  226.407146]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  226.407156]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  226.407166]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  226.407175]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  226.407183]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  226.407184]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  226.407193]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  226.407194]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  226.407196]  [<c145cb84>] ? genl_lock+0x14/0x20
[  226.407197]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  226.407198]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  226.407200]  [<c145cbac>] genl_rcv+0x1c/0x30
[  226.407201]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  226.407202]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  226.407203]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  226.407205]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  226.407206]  [<c11183de>] ? might_fault+0x9e/0xb0
[  226.407208]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  226.407209]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  226.407210]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  226.407212]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  226.407213]  [<c1118394>] ? might_fault+0x54/0xb0
[  226.407215]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  226.407216]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  226.407217]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  226.407219]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  227.385720] BUG: sleeping function called from invalid context at 
kernel/mutex.c:270
[  227.393713] in_atomic(): 1, irqs_disabled(): 0, pid: 2614, name: 
wpa_supplicant
[  227.401208] INFO: lockdep is turned off.
[  227.405315] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  227.415827] Call Trace:
[  227.418460]  [<c1066d58>] __might_sleep+0xe8/0x120
[  227.423442]  [<c1523a8a>] mutex_lock_nested+0x2a/0x2e0
[  227.428776]  [<c1097aeb>] ? trace_hardirqs_on+0xb/0x10
[  227.434160]  [<c10c40a0>] ? __rcu_process_gp_end+0x120/0x120
[  227.440044]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  227.444996]  [<c103d792>] put_online_cpus+0x22/0x70
[  227.450071]  [<c10c55b3>] synchronize_sched_expedited+0x123/0x180
[  227.456411]  [<c10c561d>] synchronize_rcu_expedited+0xd/0x10
[  227.462263]  [<c1434035>] synchronize_net+0x45/0x50
[  227.467334]  [<c14fec5c>] packet_release+0x1bc/0x290
[  227.472539]  [<c1153c6a>] ? mntput_no_expire+0x3a/0x120
[  227.477961]  [<c1422c70>] sock_release+0x20/0x80
[  227.482854]  [<c1422e17>] sock_close+0x17/0x30
[  227.487501]  [<c113952d>] __fput+0xad/0x210
[  227.491910]  [<c113969d>] ____fput+0xd/0x10
[  227.496289]  [<c1058371>] task_work_run+0xa1/0xd0
[  227.501199]  [<c103f655>] do_exit+0x2a5/0x9b0
[  227.505809]  [<c15287aa>] oops_end+0x9a/0xe0
[  227.510271]  [<c151e0d1>] no_context+0x18c/0x194
[  227.515092]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  227.520415]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  227.526268]  [<c108954d>] ? ktime_get+0x5d/0x100
[  227.531136]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  227.536576]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  227.542192]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  227.547422]  [<c1008738>] ? sched_clock+0x8/0x10
[  227.552280]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  227.558379]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  227.563783]  [<c152b1ad>] do_page_fault+0xd/0x10
[  227.568598]  [<c1527f74>] error_code+0x6c/0x74
[  227.573217]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  227.578359]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  227.585951]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  227.594468]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  227.601200]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  227.607702]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  227.612850]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  227.619467]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  227.624454]  [<c145cb84>] ? genl_lock+0x14/0x20
[  227.629161]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  227.633786]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  227.638861]  [<c145cbac>] genl_rcv+0x1c/0x30
[  227.643311]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  227.648603]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  227.653837]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  227.658737]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  227.663592]  [<c11183de>] ? might_fault+0x9e/0xb0
[  227.668500]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  227.673741]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  227.678714]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  227.683795]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  227.688513]  [<c1118394>] ? might_fault+0x54/0xb0
[  227.693403]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  227.698178]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  227.703319]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  227.709218]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  227.714368] BUG: scheduling while atomic: wpa_supplicant/2614/0x10000003
[  227.721248] INFO: lockdep is turned off.
[  227.725351] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O) 
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi dell_laptop 
snd_seq_midi_event dell_wmi dcdbas psmouse sparse_keymap snd_seq 
coretemp serio_raw snd_timer snd_seq_device snd soundcore snd_page_alloc 
intel_ips microcode lpc_ich mfd_core nouveau ttm drm_kms_helper drm 
i2c_algo_bit mxm_wmi crc32c_intel intel_agp intel_gtt firewire_ohci 
sdhci_pci sdhci ahci mmc_core libahci firewire_core e1000e crc_itu_t ptp 
pps_core video agpgart [last unloaded: brcmfmac]
[  227.779056] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  227.789501] Call Trace:
[  227.792149]  [<c151eb8a>] __schedule_bug+0x68/0x7a
[  227.797150]  [<c152570c>] __schedule+0x79c/0x7e0
[  227.801967]  [<c10055ac>] ? show_trace_log_lvl+0x4c/0x60
[  227.807485]  [<c10055df>] ? show_trace+0x1f/0x30
[  227.812311]  [<c151d47f>] ? dump_stack+0x73/0x7a
[  227.817135]  [<c1066d58>] ? __might_sleep+0xe8/0x120
[  227.822305]  [<c10697bb>] __cond_resched+0x1b/0x30
[  227.827462]  [<c15257c9>] _cond_resched+0x29/0x30
[  227.832378]  [<c1523a8f>] mutex_lock_nested+0x2f/0x2e0
[  227.837709]  [<c1097aeb>] ? trace_hardirqs_on+0xb/0x10
[  227.843056]  [<c10c40a0>] ? __rcu_process_gp_end+0x120/0x120
[  227.848930]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  227.853828]  [<c103d792>] put_online_cpus+0x22/0x70
[  227.858911]  [<c10c55b3>] synchronize_sched_expedited+0x123/0x180
[  227.865276]  [<c10c561d>] synchronize_rcu_expedited+0xd/0x10
[  227.871146]  [<c1434035>] synchronize_net+0x45/0x50
[  227.876238]  [<c14fec5c>] packet_release+0x1bc/0x290
[  227.881425]  [<c1153c6a>] ? mntput_no_expire+0x3a/0x120
[  227.886868]  [<c1422c70>] sock_release+0x20/0x80
[  227.891772]  [<c1422e17>] sock_close+0x17/0x30
[  227.896428]  [<c113952d>] __fput+0xad/0x210
[  227.900821]  [<c113969d>] ____fput+0xd/0x10
[  227.905200]  [<c1058371>] task_work_run+0xa1/0xd0
[  227.910108]  [<c103f655>] do_exit+0x2a5/0x9b0
[  227.914670]  [<c15287aa>] oops_end+0x9a/0xe0
[  227.919131]  [<c151e0d1>] no_context+0x18c/0x194
[  227.923952]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  227.929300]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  227.935162]  [<c108954d>] ? ktime_get+0x5d/0x100
[  227.939981]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  227.945405]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  227.950922]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  227.956173]  [<c1008738>] ? sched_clock+0x8/0x10
[  227.960994]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  227.967102]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  227.972523]  [<c152b1ad>] do_page_fault+0xd/0x10
[  227.977344]  [<c1527f74>] error_code+0x6c/0x74
[  227.981983]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  227.987144]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  227.994758]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  228.003235]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  228.010029]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  228.016504]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  228.021601]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  228.021605]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  228.021609]  [<c145cb84>] ? genl_lock+0x14/0x20
[  228.021612]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  228.021614]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  228.021615]  [<c145cbac>] genl_rcv+0x1c/0x30
[  228.021620]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  228.021625]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  228.021628]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  228.021630]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  228.021633]  [<c11183de>] ? might_fault+0x9e/0xb0
[  228.021635]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  228.021637]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  228.021639]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  228.021643]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  228.021645]  [<c1118394>] ? might_fault+0x54/0xb0
[  228.021647]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  228.021650]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  228.021652]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  228.021654]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  228.021674] BUG: scheduling while atomic: wpa_supplicant/2614/0x10000003
[  228.021675] INFO: lockdep is turned off.
[  228.021706] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O) 
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi dell_laptop 
snd_seq_midi_event dell_wmi dcdbas psmouse sparse_keymap snd_seq 
coretemp serio_raw snd_timer snd_seq_device snd soundcore snd_page_alloc 
intel_ips microcode lpc_ich mfd_core nouveau ttm drm_kms_helper drm 
i2c_algo_bit mxm_wmi crc32c_intel intel_agp intel_gtt firewire_ohci 
sdhci_pci sdhci ahci mmc_core libahci firewire_core e1000e crc_itu_t ptp 
pps_core video agpgart [last unloaded: brcmfmac]
[  228.021708] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  228.021709] Call Trace:
[  228.021713]  [<c151eb8a>] __schedule_bug+0x68/0x7a
[  228.021718]  [<c152570c>] __schedule+0x79c/0x7e0
[  228.021721]  [<c106824c>] ? ttwu_stat+0xac/0x140
[  228.021725]  [<c10931bb>] ? trace_hardirqs_off+0xb/0x10
[  228.021728]  [<c1527255>] ? _raw_spin_unlock_irqrestore+0x65/0x70
[  228.021730]  [<c10697bb>] __cond_resched+0x1b/0x30
[  228.021732]  [<c15257c9>] _cond_resched+0x29/0x30
[  228.021734]  [<c1525f29>] wait_for_completion+0x29/0xd0
[  228.021736]  [<c10b02ef>] ? queue_stop_cpus_work+0x8f/0xb0
[  228.021738]  [<c10b0463>] __stop_cpus+0x53/0x80
[  228.021740]  [<c10c40a0>] ? __rcu_process_gp_end+0x120/0x120
[  228.021743]  [<c10c40a0>] ? __rcu_process_gp_end+0x120/0x120
[  228.021744]  [<c10b05ca>] try_stop_cpus+0x3a/0x60
[  228.021747]  [<c10c5547>] synchronize_sched_expedited+0xb7/0x180
[  228.021749]  [<c10c561d>] synchronize_rcu_expedited+0xd/0x10
[  228.021751]  [<c1434035>] synchronize_net+0x45/0x50
[  228.021753]  [<c14fec5c>] packet_release+0x1bc/0x290
[  228.021755]  [<c1153c6a>] ? mntput_no_expire+0x3a/0x120
[  228.021758]  [<c1422c70>] sock_release+0x20/0x80
[  228.021759]  [<c1422e17>] sock_close+0x17/0x30
[  228.021761]  [<c113952d>] __fput+0xad/0x210
[  228.021763]  [<c113969d>] ____fput+0xd/0x10
[  228.021765]  [<c1058371>] task_work_run+0xa1/0xd0
[  228.021767]  [<c103f655>] do_exit+0x2a5/0x9b0
[  228.021769]  [<c15287aa>] oops_end+0x9a/0xe0
[  228.021771]  [<c151e0d1>] no_context+0x18c/0x194
[  228.021773]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  228.021775]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  228.021777]  [<c108954d>] ? ktime_get+0x5d/0x100
[  228.021779]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  228.021782]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  228.021785]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  228.021789]  [<c1008738>] ? sched_clock+0x8/0x10
[  228.021793]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  228.021796]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  228.021799]  [<c152b1ad>] do_page_fault+0xd/0x10
[  228.021803]  [<c1527f74>] error_code+0x6c/0x74
[  228.021807]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  228.021822]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  228.021836]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  228.021848]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  228.021861]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  228.021864]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  228.021877]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  228.021880]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  228.021884]  [<c145cb84>] ? genl_lock+0x14/0x20
[  228.021887]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  228.021890]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  228.021894]  [<c145cbac>] genl_rcv+0x1c/0x30
[  228.021897]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  228.021901]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  228.021904]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  228.021907]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  228.021911]  [<c11183de>] ? might_fault+0x9e/0xb0
[  228.021914]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  228.021917]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  228.021919]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  228.021922]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  228.021924]  [<c1118394>] ? might_fault+0x54/0xb0
[  228.021926]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  228.021928]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  228.021931]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  228.021933]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  228.021938] BUG: scheduling while atomic: wpa_supplicant/2614/0x00000003
[  228.021938] INFO: lockdep is turned off.
[  228.021961] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O) 
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi dell_laptop 
snd_seq_midi_event dell_wmi dcdbas psmouse sparse_keymap snd_seq 
coretemp serio_raw snd_timer snd_seq_device snd soundcore snd_page_alloc 
intel_ips microcode lpc_ich mfd_core nouveau ttm drm_kms_helper drm 
i2c_algo_bit mxm_wmi crc32c_intel intel_agp intel_gtt firewire_ohci 
sdhci_pci sdhci ahci mmc_core libahci firewire_core e1000e crc_itu_t ptp 
pps_core video agpgart [last unloaded: brcmfmac]
[  228.021963] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  228.021963] Call Trace:
[  228.021966]  [<c151eb8a>] __schedule_bug+0x68/0x7a
[  228.021968]  [<c152570c>] __schedule+0x79c/0x7e0
[  228.021970]  [<c1097aeb>] ? trace_hardirqs_on+0xb/0x10
[  228.021972]  [<c15271d7>] ? _raw_spin_unlock_irq+0x27/0x40
[  228.021974]  [<c1065d5f>] ? finish_task_switch+0x7f/0xe0
[  228.021976]  [<c1065d1d>] ? finish_task_switch+0x3d/0xe0
[  228.021978]  [<c1525318>] ? __schedule+0x3a8/0x7e0
[  228.021980]  [<c1525ff3>] schedule+0x23/0x60
[  228.021982]  [<c152360d>] schedule_timeout+0x15d/0x210
[  228.021984]  [<c1525f30>] ? wait_for_completion+0x30/0xd0
[  228.021986]  [<c12bf8df>] ? do_raw_spin_lock+0x3f/0x100
[  228.021988]  [<c1525f8d>] wait_for_completion+0x8d/0xd0
[  228.021990]  [<c106bf90>] ? try_to_wake_up+0x260/0x260
[  228.021992]  [<c10b0463>] __stop_cpus+0x53/0x80
[  228.021995]  [<c10c40a0>] ? __rcu_process_gp_end+0x120/0x120
[  228.021997]  [<c10c40a0>] ? __rcu_process_gp_end+0x120/0x120
[  228.021999]  [<c10b05ca>] try_stop_cpus+0x3a/0x60
[  228.022001]  [<c10c5547>] synchronize_sched_expedited+0xb7/0x180
[  228.022003]  [<c10c561d>] synchronize_rcu_expedited+0xd/0x10
[  228.022005]  [<c1434035>] synchronize_net+0x45/0x50
[  228.022007]  [<c14fec5c>] packet_release+0x1bc/0x290
[  228.022009]  [<c1153c6a>] ? mntput_no_expire+0x3a/0x120
[  228.022011]  [<c1422c70>] sock_release+0x20/0x80
[  228.022013]  [<c1422e17>] sock_close+0x17/0x30
[  228.022015]  [<c113952d>] __fput+0xad/0x210
[  228.022017]  [<c113969d>] ____fput+0xd/0x10
[  228.022019]  [<c1058371>] task_work_run+0xa1/0xd0
[  228.022021]  [<c103f655>] do_exit+0x2a5/0x9b0
[  228.022023]  [<c15287aa>] oops_end+0x9a/0xe0
[  228.022027]  [<c151e0d1>] no_context+0x18c/0x194
[  228.022030]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  228.022033]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  228.022036]  [<c108954d>] ? ktime_get+0x5d/0x100
[  228.022040]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  228.022043]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  228.022047]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  228.022050]  [<c1008738>] ? sched_clock+0x8/0x10
[  228.022054]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  228.022057]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  228.022060]  [<c152b1ad>] do_page_fault+0xd/0x10
[  228.022064]  [<c1527f74>] error_code+0x6c/0x74
[  228.022067]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  228.022082]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  228.022096]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  228.022109]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  228.022121]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  228.022124]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  228.022136]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  228.022140]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  228.022144]  [<c145cb84>] ? genl_lock+0x14/0x20
[  228.022147]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  228.022150]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  228.022154]  [<c145cbac>] genl_rcv+0x1c/0x30
[  228.022157]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  228.022160]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  228.022164]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  228.022167]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  228.022170]  [<c11183de>] ? might_fault+0x9e/0xb0
[  228.022173]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  228.022175]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  228.022177]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  228.022180]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  228.022182]  [<c1118394>] ? might_fault+0x54/0xb0
[  228.022184]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  228.022186]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  228.022188]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  228.022190]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  228.965789] BUG: sleeping function called from invalid context at 
kernel/mutex.c:270
[  228.973752] in_atomic(): 1, irqs_disabled(): 0, pid: 2614, name: 
wpa_supplicant
[  228.981243] INFO: lockdep is turned off.
[  228.985348] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  228.995791] Call Trace:
[  228.998435]  [<c1066d58>] __might_sleep+0xe8/0x120
[  229.003427]  [<c1523a8a>] mutex_lock_nested+0x2a/0x2e0
[  229.008770]  [<c1097aeb>] ? trace_hardirqs_on+0xb/0x10
[  229.014097]  [<c10c40a0>] ? __rcu_process_gp_end+0x120/0x120
[  229.019959]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  229.024848]  [<c103d792>] put_online_cpus+0x22/0x70
[  229.029902]  [<c10c55b3>] synchronize_sched_expedited+0x123/0x180
[  229.036193]  [<c10c561d>] synchronize_rcu_expedited+0xd/0x10
[  229.042043]  [<c1434035>] synchronize_net+0x45/0x50
[  229.047165]  [<c14fec5c>] packet_release+0x1bc/0x290
[  229.052306]  [<c1153c6a>] ? mntput_no_expire+0x3a/0x120
[  229.057731]  [<c1422c70>] sock_release+0x20/0x80
[  229.062539]  [<c1422e17>] sock_close+0x17/0x30
[  229.067164]  [<c113952d>] __fput+0xad/0x210
[  229.071548]  [<c113969d>] ____fput+0xd/0x10
[  229.075926]  [<c1058371>] task_work_run+0xa1/0xd0
[  229.080825]  [<c103f655>] do_exit+0x2a5/0x9b0
[  229.085356]  [<c15287aa>] oops_end+0x9a/0xe0
[  229.089806]  [<c151e0d1>] no_context+0x18c/0x194
[  229.094622]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  229.099860]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  229.105715]  [<c108954d>] ? ktime_get+0x5d/0x100
[  229.110517]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  229.115934]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  229.121426]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  229.126675]  [<c1008738>] ? sched_clock+0x8/0x10
[  229.131468]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  229.137565]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  229.142986]  [<c152b1ad>] do_page_fault+0xd/0x10
[  229.147778]  [<c1527f74>] error_code+0x6c/0x74
[  229.152412]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  229.157478]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  229.165076]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  229.173523]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  229.180257]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  229.186719]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  229.191790]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  229.198426]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  229.203400]  [<c145cb84>] ? genl_lock+0x14/0x20
[  229.208127]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  229.212771]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  229.217836]  [<c145cbac>] genl_rcv+0x1c/0x30
[  229.222292]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  229.227548]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  229.232841]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  229.237750]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  229.242574]  [<c11183de>] ? might_fault+0x9e/0xb0
[  229.247481]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  229.252730]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  229.257722]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  229.262797]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  229.267512]  [<c1118394>] ? might_fault+0x54/0xb0
[  229.272417]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  229.277124]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  229.282272]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  229.288122]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  229.293258] BUG: scheduling while atomic: wpa_supplicant/2614/0x10000003
[  229.300148] INFO: lockdep is turned off.
[  229.304247] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O) 
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi dell_laptop 
snd_seq_midi_event dell_wmi dcdbas psmouse sparse_keymap snd_seq 
coretemp serio_raw snd_timer snd_seq_device snd soundcore snd_page_alloc 
intel_ips microcode lpc_ich mfd_core nouveau ttm drm_kms_helper drm 
i2c_algo_bit mxm_wmi crc32c_intel intel_agp intel_gtt firewire_ohci 
sdhci_pci sdhci ahci mmc_core libahci firewire_core e1000e crc_itu_t ptp 
pps_core video agpgart [last unloaded: brcmfmac]
[  229.358078] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  229.368530] Call Trace:
[  229.371198]  [<c151eb8a>] __schedule_bug+0x68/0x7a
[  229.376189]  [<c152570c>] __schedule+0x79c/0x7e0
[  229.381005]  [<c10055ac>] ? show_trace_log_lvl+0x4c/0x60
[  229.386516]  [<c10055df>] ? show_trace+0x1f/0x30
[  229.391392]  [<c151d47f>] ? dump_stack+0x73/0x7a
[  229.396245]  [<c1066d58>] ? __might_sleep+0xe8/0x120
[  229.401418]  [<c10697bb>] __cond_resched+0x1b/0x30
[  229.406416]  [<c15257c9>] _cond_resched+0x29/0x30
[  229.411338]  [<c1523a8f>] mutex_lock_nested+0x2f/0x2e0
[  229.416675]  [<c1097aeb>] ? trace_hardirqs_on+0xb/0x10
[  229.422016]  [<c10c40a0>] ? __rcu_process_gp_end+0x120/0x120
[  229.427878]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  229.432783]  [<c103d792>] put_online_cpus+0x22/0x70
[  229.437881]  [<c10c55b3>] synchronize_sched_expedited+0x123/0x180
[  229.444182]  [<c10c561d>] synchronize_rcu_expedited+0xd/0x10
[  229.450078]  [<c1434035>] synchronize_net+0x45/0x50
[  229.455158]  [<c14fec5c>] packet_release+0x1bc/0x290
[  229.460322]  [<c1153c6a>] ? mntput_no_expire+0x3a/0x120
[  229.465750]  [<c1422c70>] sock_release+0x20/0x80
[  229.470584]  [<c1422e17>] sock_close+0x17/0x30
[  229.475243]  [<c113952d>] __fput+0xad/0x210
[  229.479622]  [<c113969d>] ____fput+0xd/0x10
[  229.484002]  [<c1058371>] task_work_run+0xa1/0xd0
[  229.488919]  [<c103f655>] do_exit+0x2a5/0x9b0
[  229.493472]  [<c15287aa>] oops_end+0x9a/0xe0
[  229.497939]  [<c151e0d1>] no_context+0x18c/0x194
[  229.502753]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  229.508058]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  229.513945]  [<c108954d>] ? ktime_get+0x5d/0x100
[  229.518756]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  229.524175]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  229.529679]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  229.534929]  [<c1008738>] ? sched_clock+0x8/0x10
[  229.539746]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  229.545926]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  229.551510]  [<c152b1ad>] do_page_fault+0xd/0x10
[  229.556327]  [<c1527f74>] error_code+0x6c/0x74
[  229.560968]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  229.566062]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  229.573733]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  229.582208]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  229.588945]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  229.595414]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  229.600496]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  229.607140]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  229.612127]  [<c145cb84>] ? genl_lock+0x14/0x20
[  229.616855]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  229.621507]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  229.626581]  [<c145cbac>] genl_rcv+0x1c/0x30
[  229.631056]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  229.636309]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  229.641583]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  229.646512]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  229.651343]  [<c11183de>] ? might_fault+0x9e/0xb0
[  229.656274]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  229.661523]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  229.666516]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  229.671583]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  229.676320]  [<c1118394>] ? might_fault+0x54/0xb0
[  229.681240]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  229.685976]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  229.691145]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  229.697008]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  229.702194] BUG: scheduling while atomic: wpa_supplicant/2614/0x10000003
[  229.709103] INFO: lockdep is turned off.
[  229.713228] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O) 
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi dell_laptop 
snd_seq_midi_event dell_wmi dcdbas psmouse sparse_keymap snd_seq 
coretemp serio_raw snd_timer snd_seq_device snd soundcore snd_page_alloc 
intel_ips microcode lpc_ich mfd_core nouveau ttm drm_kms_helper drm 
i2c_algo_bit mxm_wmi crc32c_intel intel_agp intel_gtt firewire_ohci 
sdhci_pci sdhci ahci mmc_core libahci firewire_core e1000e crc_itu_t ptp 
pps_core video agpgart [last unloaded: brcmfmac]
[  229.766946] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  229.777408] Call Trace:
[  229.780063]  [<c151eb8a>] __schedule_bug+0x68/0x7a
[  229.785071]  [<c152570c>] __schedule+0x79c/0x7e0
[  229.789899]  [<c11351db>] ? kmem_cache_free+0x1ab/0x1c0
[  229.795340]  [<c1041f68>] ? local_bh_enable+0x68/0xd0
[  229.800599]  [<c1425d73>] ? __sk_free+0xd3/0x130
[  229.805436]  [<c1425e4d>] ? sk_free+0x1d/0x30
[  229.810005]  [<c11342af>] ? kfree+0x18f/0x1a0
[  229.814569]  [<c10697bb>] __cond_resched+0x1b/0x30
[  229.819569]  [<c15257c9>] _cond_resched+0x29/0x30
[  229.824486]  [<c114ca4e>] dput+0x17e/0x210
[  229.828908]  [<c11395ec>] __fput+0x16c/0x210
[  229.833389]  [<c113969d>] ____fput+0xd/0x10
[  229.837781]  [<c1058371>] task_work_run+0xa1/0xd0
[  229.842692]  [<c103f655>] do_exit+0x2a5/0x9b0
[  229.847269]  [<c15287aa>] oops_end+0x9a/0xe0
[  229.851744]  [<c151e0d1>] no_context+0x18c/0x194
[  229.856568]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  229.861823]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  229.867693]  [<c108954d>] ? ktime_get+0x5d/0x100
[  229.872512]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  229.877943]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  229.883451]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  229.888709]  [<c1008738>] ? sched_clock+0x8/0x10
[  229.893532]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  229.899655]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  229.905104]  [<c152b1ad>] do_page_fault+0xd/0x10
[  229.909930]  [<c1527f74>] error_code+0x6c/0x74
[  229.914572]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  229.919668]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  229.927273]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  229.935747]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  229.942483]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  229.948955]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  229.954049]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  229.960690]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  229.965670]  [<c145cb84>] ? genl_lock+0x14/0x20
[  229.970402]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  229.975036]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  229.980117]  [<c145cbac>] genl_rcv+0x1c/0x30
[  229.984576]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  229.989827]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  229.995080]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  229.999976]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  230.004803]  [<c11183de>] ? might_fault+0x9e/0xb0
[  230.009697]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  230.014938]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  230.019936]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  230.025011]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  230.029747]  [<c1118394>] ? might_fault+0x54/0xb0
[  230.034659]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  230.039391]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  230.044551]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  230.050389]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  230.055597] BUG: sleeping function called from invalid context at 
fs/inode.c:504
[  230.063181] in_atomic(): 1, irqs_disabled(): 0, pid: 2614, name: 
wpa_supplicant
[  230.070668] INFO: lockdep is turned off.
[  230.074774] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  230.085218] Call Trace:
[  230.087861]  [<c1066d58>] __might_sleep+0xe8/0x120
[  230.092845]  [<c114ec1d>] clear_inode+0x1d/0x80
[  230.097573]  [<c114f951>] evict+0x111/0x180
[  230.101945]  [<c1150110>] iput+0xe0/0x170
[  230.106153]  [<c114adf7>] dentry_iput+0x87/0xd0
[  230.110879]  [<c114c9dc>] dput+0x10c/0x210
[  230.115168]  [<c11395ec>] __fput+0x16c/0x210
[  230.119621]  [<c113969d>] ____fput+0xd/0x10
[  230.123997]  [<c1058371>] task_work_run+0xa1/0xd0
[  230.128884]  [<c103f655>] do_exit+0x2a5/0x9b0
[  230.133435]  [<c15287aa>] oops_end+0x9a/0xe0
[  230.137895]  [<c151e0d1>] no_context+0x18c/0x194
[  230.142717]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  230.147965]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  230.153820]  [<c108954d>] ? ktime_get+0x5d/0x100
[  230.158632]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  230.164050]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  230.169565]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  230.174811]  [<c1008738>] ? sched_clock+0x8/0x10
[  230.179627]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  230.185744]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  230.191182]  [<c152b1ad>] do_page_fault+0xd/0x10
[  230.195995]  [<c1527f74>] error_code+0x6c/0x74
[  230.200647]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  230.205729]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  230.213325]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  230.221793]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  230.228519]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  230.234980]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  230.240068]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  230.246703]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  230.251690]  [<c145cb84>] ? genl_lock+0x14/0x20
[  230.256416]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  230.261041]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  230.266126]  [<c145cbac>] genl_rcv+0x1c/0x30
[  230.270588]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  230.275846]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  230.281095]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  230.285991]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  230.290827]  [<c11183de>] ? might_fault+0x9e/0xb0
[  230.295726]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  230.300971]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  230.305960]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  230.311040]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  230.315756]  [<c1118394>] ? might_fault+0x54/0xb0
[  230.320657]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  230.325372]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  230.330531]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  230.336383]  [<c152eb4d>] sysenter_do_call+0x12/0x38
[  230.341552] BUG: scheduling while atomic: wpa_supplicant/2614/0x10000003
[  230.348453] INFO: lockdep is turned off.
[  230.352571] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O) 
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi dell_laptop 
snd_seq_midi_event dell_wmi dcdbas psmouse sparse_keymap snd_seq 
coretemp serio_raw snd_timer snd_seq_device snd soundcore snd_page_alloc 
intel_ips microcode lpc_ich mfd_core nouveau ttm drm_kms_helper drm 
i2c_algo_bit mxm_wmi crc32c_intel intel_agp intel_gtt firewire_ohci 
sdhci_pci sdhci ahci mmc_core libahci firewire_core e1000e crc_itu_t ptp 
pps_core video agpgart [last unloaded: brcmfmac]
[  230.406310] Pid: 2614, comm: wpa_supplicant Tainted: G      D W  O 
3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd #1
[  230.416773] Call Trace:
[  230.419415]  [<c151eb8a>] __schedule_bug+0x68/0x7a
[  230.424422]  [<c152570c>] __schedule+0x79c/0x7e0
[  230.429240]  [<c10055ac>] ? show_trace_log_lvl+0x4c/0x60
[  230.434776]  [<c10055df>] ? show_trace+0x1f/0x30
[  230.439606]  [<c151d47f>] ? dump_stack+0x73/0x7a
[  230.444445]  [<c1066d58>] ? __might_sleep+0xe8/0x120
[  230.449625]  [<c10697bb>] __cond_resched+0x1b/0x30
[  230.454630]  [<c15257c9>] _cond_resched+0x29/0x30
[  230.459553]  [<c114ec28>] clear_inode+0x28/0x80
[  230.464300]  [<c114f951>] evict+0x111/0x180
[  230.468697]  [<c1150110>] iput+0xe0/0x170
[  230.472923]  [<c114adf7>] dentry_iput+0x87/0xd0
[  230.477685]  [<c114c9dc>] dput+0x10c/0x210
[  230.482011]  [<c11395ec>] __fput+0x16c/0x210
[  230.486492]  [<c113969d>] ____fput+0xd/0x10
[  230.490897]  [<c1058371>] task_work_run+0xa1/0xd0
[  230.495811]  [<c103f655>] do_exit+0x2a5/0x9b0
[  230.500384]  [<c15287aa>] oops_end+0x9a/0xe0
[  230.504873]  [<c151e0d1>] no_context+0x18c/0x194
[  230.509701]  [<c12b5dae>] ? number.isra.2+0x32e/0x370
[  230.514958]  [<c151e21d>] __bad_area_nosemaphore+0x144/0x14c
[  230.520831]  [<c108954d>] ? ktime_get+0x5d/0x100
[  230.525656]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  230.531092]  [<c151e23c>] bad_area_nosemaphore+0x17/0x19
[  230.536607]  [<c152afbd>] __do_page_fault+0x31d/0x500
[  230.541869]  [<c1008738>] ? sched_clock+0x8/0x10
[  230.546692]  [<c10d21b7>] ? ring_buffer_unlock_commit+0x77/0xa0
[  230.552832]  [<c152b1a0>] ? __do_page_fault+0x500/0x500
[  230.558262]  [<c152b1ad>] do_page_fault+0xd/0x10
[  230.563088]  [<c1527f74>] error_code+0x6c/0x74
[  230.567746]  [<c12b007b>] ? idr_mark_full+0x2b/0x50
[  230.572840]  [<f8335e4c>] ? ftrace_raw_event_wiphy_wdev_evt+0x7c/0xe0 
[cfg80211]
[  230.580450]  [<f8335dd0>] ? 
ftrace_raw_event_rdev_change_virtual_intf+0xe0/0xe0 [cfg80211]
[  230.588929]  [<f8312505>] nl80211_new_interface+0x415/0x430 [cfg80211]
[  230.595678]  [<f8312f04>] ? nl80211_pre_doit+0x1c4/0x370 [cfg80211]
[  230.602158]  [<c12c6ccc>] ? validate_nla+0xcc/0x1e0
[  230.607252]  [<f8312d40>] ? nl80211_get_wowlan+0x650/0x650 [cfg80211]
[  230.613908]  [<c145cdbc>] genl_rcv_msg+0x1fc/0x270
[  230.618914]  [<c145cb84>] ? genl_lock+0x14/0x20
[  230.623651]  [<c145cbc0>] ? genl_rcv+0x30/0x30
[  230.628306]  [<c145c5ee>] netlink_rcv_skb+0x8e/0xb0
[  230.633389]  [<c145cbac>] genl_rcv+0x1c/0x30
[  230.637871]  [<c145bfad>] netlink_unicast+0x17d/0x1f0
[  230.643131]  [<c145c248>] netlink_sendmsg+0x228/0x390
[  230.648400]  [<c152484d>] ? mutex_unlock+0xd/0x10
[  230.653315]  [<c1422201>] sock_sendmsg+0xd1/0xf0
[  230.658155]  [<c11183de>] ? might_fault+0x9e/0xb0
[  230.663056]  [<c12b94f2>] ? _copy_from_user+0x42/0x60
[  230.668318]  [<c142eaa4>] ? verify_iovec+0x44/0xb0
[  230.673320]  [<c1423252>] __sys_sendmsg+0x262/0x270
[  230.678404]  [<c117342c>] ? fsnotify+0x6c/0x2a0
[  230.683136]  [<c1118394>] ? might_fault+0x54/0xb0
[  230.688046]  [<c142452b>] sys_sendmsg+0x3b/0x60
[  230.692770]  [<c1424bd3>] sys_socketcall+0x283/0x2e0
[  230.697925]  [<c12b9108>] ? trace_hardirqs_on_thunk+0xc/0x10
[  230.703768]  [<c152eb4d>] sysenter_do_call+0x12/0x38


