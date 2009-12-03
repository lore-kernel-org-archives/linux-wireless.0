Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60947 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbZLCSNW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 13:13:22 -0500
Subject: Re: [PATCH v2 3/5] mac80211: correctly place aMPDU RX reorder code
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20091125164821.184669673@sipsolutions.net>
References: <20091125164614.427835023@sipsolutions.net>
	 <20091125164821.184669673@sipsolutions.net>
Content-Type: text/plain
Date: Thu, 03 Dec 2009 10:13:27 -0800
Message-Id: <1259864007.4653.298.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Wed, 2009-11-25 at 08:46 -0800, Johannes Berg wrote:
> As indicated by the comment, the aMPDU RX reorder code
> should logically be after ieee80211_rx_h_check(). The
> previous patch moved the code there, and this patch now
> hooks it up in that place by introducing a list of skbs
> that are then processed by the remaining handlers. The
> list may be empty if the function is buffering the skb
> to release it later.
> 
> The only change needed to the RX data is that the crypto
> handler needs to clear the key that may be set from a
> previous loop iteration, and that not everything can be
> in the rx flags now.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I bisected a hang problem to this patch. When associating to an 11n AP
(tested on 5GHz), ping works fine, but trying to copy a large file
causes the system to freeze (keyboard lights start blinking and system
unresponsive. Reverting this patch I can copy large files successfully.

This is also described in
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2126.

Here is the panic:

[  729.671546] BUG: unable to handle kernel NULL pointer dereference at (null)
[  729.671656] IP: [<ffffffff81074b89>] __bfs+0xc9/0x270
[  729.671729] PGD 0 
[  729.671796] Oops: 0000 [#1] SMP 
[  729.671900] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:00/power_supply/BAT0/energy_full
[  729.671939] CPU 0 
[  729.672008] Modules linked in: iwlagn iwlcore mac80211 cfg80211 i915 drm_kms_helper drm i2c_algo_bit i2c_core ipv6 acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative cpufreq_stats freq_table container sbs sbshc pcmcia joydev arc4 ecb af_packet yenta_socket psmouse rsrc_nonstatic evdev pcspkr serio_raw pcmcia_core iTCO_wdt iTCO_vendor_support intel_agp button battery sony_laptop rfkill tpm_infineon tpm tpm_bios video output ac processor ext3 jbd mbcache sg sr_mod cdrom sd_mod ahci libata scsi_mod ehci_hcd uhci_hcd usbcore thermal fan thermal_sys [last unloaded: cfg80211]
[  729.672010] Pid: 14639, comm: ssh Not tainted 2.6.32-rc8-wl-60817-gc1f4e0e #96 VGN-Z540N
[  729.672010] RIP: 0010:[<ffffffff81074b89>]  [<ffffffff81074b89>] __bfs+0xc9/0x270
[  729.672010] RSP: 0018:ffff8800020036e0  EFLAGS: 00010002
[  729.672010] RAX: ffffffff81af3f30 RBX: ffffffff81af3f20 RCX: ffff880002003760
[  729.672010] RDX: ffff880002003708 RSI: 0000000000000006 RDI: ffff880002003760
[  729.672010] RBP: ffff880002003740 R08: 0000000000000001 R09: 0000000000000000
[  729.672010] R10: ffff8800955f86b0 R11: 0000000000000000 R12: 0000000000000006
[  729.672010] R13: ffffffff81073810 R14: ffff8800020037a8 R15: 0000000000000000
[  729.672010] FS:  00007fdf4f7d3710(0000) GS:ffff880002000000(0000) knlGS:0000000000000000
[  729.672010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  729.672010] CR2: 0000000000000000 CR3: 0000000079ff7000 CR4: 00000000000006f0
[  729.672010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  729.672010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  729.672010] Process ssh (pid: 14639, threadinfo ffff88005a630000, task ffff8800955f8000)
[  729.672010] Stack:
[  729.672010]  000000000000b520 ffffffff813624c0 ffff88005a631d50 ffffffff00000001
[  729.672010] <0> ffff880002003790 ffff880002003760 ffff88000200375c ffff880002003760
[  729.672010] <0> ffff8800955f86b0 ffffffff814811cd ffff8800955f8000 ffffffff8107a6c0
[  729.672010] Call Trace:
[  729.672010]  <IRQ> 
[  729.672010]  [<ffffffff8107a6c0>] ? check_usage_forwards+0x0/0x110
[  729.672010]  [<ffffffff8107a741>] check_usage_forwards+0x81/0x110
[  729.672010]  [<ffffffff81076210>] mark_lock+0x200/0x640
[  729.672010]  [<ffffffff8107824f>] __lock_acquire+0xabf/0x1d30
[  729.672010]  [<ffffffff8107955b>] lock_acquire+0x9b/0x120
[  729.672010]  [<ffffffff812aff1b>] ? skb_queue_tail+0x2b/0x60
[  729.672010]  [<ffffffff813593a1>] _spin_lock_irqsave+0x41/0x60
[  729.672010]  [<ffffffff812aff1b>] ? skb_queue_tail+0x2b/0x60
[  729.672010]  [<ffffffff81359130>] ? _spin_unlock_irqrestore+0x40/0x60
[  729.672010]  [<ffffffff812aff1b>] skb_queue_tail+0x2b/0x60
[  729.672010]  [<ffffffffa04b11f5>] ieee80211_release_reorder_frame+0x35/0x50 [mac80211]
[  729.672010]  [<ffffffffa04b2f0c>] ieee80211_invoke_rx_handlers+0xb8c/0x1990 [mac80211]
[  729.672010]  [<ffffffff810766bc>] ? mark_held_locks+0x6c/0xa0
[  729.672010]  [<ffffffff81358f30>] ? _write_unlock_irqrestore+0x40/0x60
[  729.672010]  [<ffffffff810768bb>] ? trace_hardirqs_on_caller+0x6b/0x190
[  729.672010]  [<ffffffff810769ed>] ? trace_hardirqs_on+0xd/0x10
[  729.672010]  [<ffffffffa04b3db6>] ? ieee80211_rx+0xa6/0x8f0 [mac80211]
[  729.672010]  [<ffffffffa04b3fef>] ieee80211_rx+0x2df/0x8f0 [mac80211]
[  729.672010]  [<ffffffffa04b3db6>] ? ieee80211_rx+0xa6/0x8f0 [mac80211]
[  729.672010]  [<ffffffff812af1c7>] ? skb_copy_bits+0x167/0x2b0
[  729.672010]  [<ffffffffa04fd2f1>] iwl_rx_reply_rx+0x571/0xee0 [iwlcore]
[  729.672010]  [<ffffffff8100efb5>] ? dump_trace+0x105/0x2c0
[  729.672010]  [<ffffffff811dceb9>] ? debug_dma_unmap_page+0x59/0x60
[  729.672010]  [<ffffffffa0557e89>] iwl_rx_handle+0x149/0x670 [iwlagn]
[  729.672010]  [<ffffffff810766bc>] ? mark_held_locks+0x6c/0xa0
[  729.672010]  [<ffffffffa0559afc>] iwl_irq_tasklet+0x2ec/0x1320 [iwlagn]
[  729.672010]  [<ffffffff810766bc>] ? mark_held_locks+0x6c/0xa0
[  729.672010]  [<ffffffff8104b1d9>] ? tasklet_action+0x49/0xe0
[  729.672010]  [<ffffffff8104b260>] tasklet_action+0xd0/0xe0
[  729.672010]  [<ffffffff8104c78b>] __do_softirq+0xcb/0x200
[  729.672010]  [<ffffffff8100d09c>] call_softirq+0x1c/0x50
[  729.672010]  [<ffffffff8100e80d>] do_softirq+0x7d/0xb0
[  729.672010]  [<ffffffff8104c2c5>] irq_exit+0x95/0xa0
[  729.672010]  [<ffffffff8135e485>] do_IRQ+0x75/0xf0
[  729.672010]  [<ffffffff8100c893>] ret_from_intr+0x0/0xf
[  729.672010]  <EOI> 
[  729.672010]  [<ffffffff8102eccd>] ? flush_tlb_page+0x7d/0x90
[  729.672010]  [<ffffffff8102ec98>] ? flush_tlb_page+0x48/0x90
[  729.672010]  [<ffffffff810f508d>] ? move_page_tables+0x2cd/0x4c0
[  729.672010]  [<ffffffff810f5133>] ? move_page_tables+0x373/0x4c0
[  729.672010]  [<ffffffff810f5879>] ? do_mremap+0x5f9/0x7a0
[  729.672010]  [<ffffffff810f5a7f>] ? sys_mremap+0x5f/0x90
[  729.672010]  [<ffffffff8100bedb>] ? system_call_fastpath+0x16/0x1b
[  729.672010] Code: 0a 89 05 bb f5 da 00 48 8b 41 10 48 85 c0 0f 84 2e 01 00 00 48 8d 98 70 01 00 00 48 05 80 01 00 00 45 85 c0 48 0f 44 d8 4c 8b 3b <49> 8b 07 49 39 df 0f 18 08 74 a4 4c 89 f8 48 2d c0 c2 76 81 48 
[  729.672010] RIP  [<ffffffff81074b89>] __bfs+0xc9/0x270
[  729.672010]  RSP <ffff8800020036e0>
[  729.672010] CR2: 0000000000000000
[  729.672010] ---[ end trace 73a47421077c9586 ]---
[  729.672010] Kernel panic - not syncing: Fatal exception in interrupt
[  729.672010] Pid: 14639, comm: ssh Tainted: G      D    2.6.32-rc8-wl-60817-gc1f4e0e #96
[  729.672010] Call Trace:
[  729.672010]  <IRQ>  [<ffffffff81355ad6>] panic+0x78/0x136
[  729.672010]  [<ffffffff8135a752>] oops_end+0xe2/0xf0
[  729.672010]  [<ffffffff8102aab2>] no_context+0xf2/0x260
[  729.672010]  [<ffffffff8129f7a5>] ? led_trigger_event+0x85/0x90
[  729.672010]  [<ffffffff8102ad45>] __bad_area_nosemaphore+0x125/0x1e0
[  729.672010]  [<ffffffffa04b4f47>] ? __ieee80211_tx+0x147/0x1a0 [mac80211]
[  729.672010]  [<ffffffff8102ae13>] bad_area_nosemaphore+0x13/0x20
[  729.672010]  [<ffffffff8135c174>] do_page_fault+0x2d4/0x380
[  729.672010]  [<ffffffff81073810>] ? usage_match+0x0/0x20
[  729.672010]  [<ffffffff8135994f>] page_fault+0x1f/0x30
[  729.672010]  [<ffffffff81073810>] ? usage_match+0x0/0x20
[  729.672010]  [<ffffffff81074b89>] ? __bfs+0xc9/0x270
[  729.672010]  [<ffffffff8107a6c0>] ? check_usage_forwards+0x0/0x110
[  729.672010]  [<ffffffff8107a741>] check_usage_forwards+0x81/0x110
[  729.672010]  [<ffffffff81076210>] mark_lock+0x200/0x640
[  729.672010]  [<ffffffff8107824f>] __lock_acquire+0xabf/0x1d30
[  729.672010]  [<ffffffff8107955b>] lock_acquire+0x9b/0x120
[  729.672010]  [<ffffffff812aff1b>] ? skb_queue_tail+0x2b/0x60
[  729.672010]  [<ffffffff813593a1>] _spin_lock_irqsave+0x41/0x60
[  729.672010]  [<ffffffff812aff1b>] ? skb_queue_tail+0x2b/0x60
[  729.672010]  [<ffffffff81359130>] ? _spin_unlock_irqrestore+0x40/0x60
[  729.672010]  [<ffffffff812aff1b>] skb_queue_tail+0x2b/0x60
[  729.672010]  [<ffffffffa04b11f5>] ieee80211_release_reorder_frame+0x35/0x50 [mac80211]
[  729.672010]  [<ffffffffa04b2f0c>] ieee80211_invoke_rx_handlers+0xb8c/0x1990 [mac80211]
[  729.672010]  [<ffffffff810766bc>] ? mark_held_locks+0x6c/0xa0
[  729.672010]  [<ffffffff81358f30>] ? _write_unlock_irqrestore+0x40/0x60
[  729.672010]  [<ffffffff810768bb>] ? trace_hardirqs_on_caller+0x6b/0x190
[  729.672010]  [<ffffffff810769ed>] ? trace_hardirqs_on+0xd/0x10
[  729.672010]  [<ffffffffa04b3db6>] ? ieee80211_rx+0xa6/0x8f0 [mac80211]
[  729.672010]  [<ffffffffa04b3fef>] ieee80211_rx+0x2df/0x8f0 [mac80211]
[  729.672010]  [<ffffffffa04b3db6>] ? ieee80211_rx+0xa6/0x8f0 [mac80211]
[  729.672010]  [<ffffffff812af1c7>] ? skb_copy_bits+0x167/0x2b0
[  729.672010]  [<ffffffffa04fd2f1>] iwl_rx_reply_rx+0x571/0xee0 [iwlcore]
[  729.672010]  [<ffffffff8100efb5>] ? dump_trace+0x105/0x2c0
[  729.672010]  [<ffffffff811dceb9>] ? debug_dma_unmap_page+0x59/0x60
[  729.672010]  [<ffffffffa0557e89>] iwl_rx_handle+0x149/0x670 [iwlagn]
[  729.672010]  [<ffffffff810766bc>] ? mark_held_locks+0x6c/0xa0
[  729.672010]  [<ffffffffa0559afc>] iwl_irq_tasklet+0x2ec/0x1320 [iwlagn]
[  729.672010]  [<ffffffff810766bc>] ? mark_held_locks+0x6c/0xa0
[  729.672010]  [<ffffffff8104b1d9>] ? tasklet_action+0x49/0xe0
[  729.672010]  [<ffffffff8104b260>] tasklet_action+0xd0/0xe0
[  729.672010]  [<ffffffff8104c78b>] __do_softirq+0xcb/0x200
[  729.672010]  [<ffffffff8100d09c>] call_softirq+0x1c/0x50
[  729.672010]  [<ffffffff8100e80d>] do_softirq+0x7d/0xb0
[  729.672010]  [<ffffffff8104c2c5>] irq_exit+0x95/0xa0
[  729.672010]  [<ffffffff8135e485>] do_IRQ+0x75/0xf0
[  729.672010]  [<ffffffff8100c893>] ret_from_intr+0x0/0xf
[  729.672010]  <EOI>  [<ffffffff8102eccd>] ? flush_tlb_page+0x7d/0x90
[  729.672010]  [<ffffffff8102ec98>] ? flush_tlb_page+0x48/0x90
[  729.672010]  [<ffffffff810f508d>] ? move_page_tables+0x2cd/0x4c0
[  729.672010]  [<ffffffff810f5133>] ? move_page_tables+0x373/0x4c0
[  729.672010]  [<ffffffff810f5879>] ? do_mremap+0x5f9/0x7a0
[  729.672010]  [<ffffffff810f5a7f>] ? sys_mremap+0x5f/0x90
[  729.672010]  [<ffffffff8100bedb>] ? system_call_fastpath+0x16/0x1b
[  729.682892] ------------[ cut here ]------------
[  729.682936] WARNING: at /home/rchatre/iwlwifi-2.6/arch/x86/kernel/smp.c:117 native_smp_send_reschedule+0x54/0x60()
[  729.682976] Hardware name: VGN-Z540N
[  729.683014] Modules linked in: iwlagn iwlcore mac80211 cfg80211 i915 drm_kms_helper drm i2c_algo_bit i2c_core ipv6 acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative cpufreq_stats freq_table container sbs sbshc pcmcia joydev arc4 ecb af_packet yenta_socket psmouse rsrc_nonstatic evdev pcspkr serio_raw pcmcia_core iTCO_wdt iTCO_vendor_support intel_agp button battery sony_laptop rfkill tpm_infineon tpm tpm_bios video output ac processor ext3 jbd mbcache sg sr_mod cdrom sd_mod ahci libata scsi_mod ehci_hcd uhci_hcd usbcore thermal fan thermal_sys [last unloaded: cfg80211]
[  729.685583] Pid: 14639, comm: ssh Tainted: G      D    2.6.32-rc8-wl-60817-gc1f4e0e #96
[  729.685623] Call Trace:
[  729.685663]  <IRQ>  [<ffffffff81044deb>] warn_slowpath_common+0x7b/0xc0
[  729.685750]  [<ffffffff81044e44>] warn_slowpath_null+0x14/0x20
[  729.685793]  [<ffffffff810213d4>] native_smp_send_reschedule+0x54/0x60
[  729.685838]  [<ffffffff81030048>] resched_task+0x68/0x70
[  729.685882]  [<ffffffff81036ae9>] check_preempt_wakeup+0x1c9/0x240
[  729.685926]  [<ffffffff810402ff>] try_to_wake_up+0x1af/0x250
[  729.685970]  [<ffffffff810403b2>] default_wake_function+0x12/0x20
[  729.686014]  [<ffffffff810637d6>] autoremove_wake_function+0x16/0x40
[  729.686057]  [<ffffffff8102f8f9>] __wake_up_common+0x59/0x90
[  729.686100]  [<ffffffff81036088>] __wake_up+0x48/0x70
[  729.686151]  [<ffffffffa040aa91>] i915_driver_irq_handler+0x3c1/0x5b0 [i915]
[  729.686196]  [<ffffffff810a42d0>] handle_IRQ_event+0x50/0x160
[  729.686240]  [<ffffffff810a63bd>] handle_edge_irq+0xcd/0x170
[  729.686283]  [<ffffffff8100e862>] handle_irq+0x22/0x30
[  729.686327]  [<ffffffff8135e47c>] do_IRQ+0x6c/0xf0
[  729.686372]  [<ffffffff8100c893>] ret_from_intr+0x0/0xf
[  729.686417]  [<ffffffff81355b70>] ? panic+0x112/0x136
[  729.686459]  [<ffffffff81355b73>] ? panic+0x115/0x136
[  729.686502]  [<ffffffff81355b70>] ? panic+0x112/0x136
[  729.686545]  [<ffffffff8135a752>] ? oops_end+0xe2/0xf0
[  729.686589]  [<ffffffff8102aab2>] ? no_context+0xf2/0x260
[  729.686632]  [<ffffffff8129f7a5>] ? led_trigger_event+0x85/0x90
[  729.686676]  [<ffffffff8102ad45>] ? __bad_area_nosemaphore+0x125/0x1e0
[  729.686724]  [<ffffffffa04b4f47>] ? __ieee80211_tx+0x147/0x1a0 [mac80211]
[  729.686769]  [<ffffffff8102ae13>] ? bad_area_nosemaphore+0x13/0x20
[  729.686813]  [<ffffffff8135c174>] ? do_page_fault+0x2d4/0x380
[  729.686858]  [<ffffffff81073810>] ? usage_match+0x0/0x20
[  729.686884]  [<ffffffff8135994f>] ? page_fault+0x1f/0x30
[  729.686884]  [<ffffffff81073810>] ? usage_match+0x0/0x20
[  729.686884]  [<ffffffff81074b89>] ? __bfs+0xc9/0x270
[  729.686884]  [<ffffffff8107a6c0>] ? check_usage_forwards+0x0/0x110
[  729.686884]  [<ffffffff8107a741>] ? check_usage_forwards+0x81/0x110
[  729.686884]  [<ffffffff81076210>] ? mark_lock+0x200/0x640
[  729.686884]  [<ffffffff8107824f>] ? __lock_acquire+0xabf/0x1d30
[  729.686884]  [<ffffffff8107955b>] ? lock_acquire+0x9b/0x120
[  729.686884]  [<ffffffff812aff1b>] ? skb_queue_tail+0x2b/0x60
[  729.686884]  [<ffffffff813593a1>] ? _spin_lock_irqsave+0x41/0x60
[  729.686884]  [<ffffffff812aff1b>] ? skb_queue_tail+0x2b/0x60
[  729.686884]  [<ffffffff81359130>] ? _spin_unlock_irqrestore+0x40/0x60
[  729.686884]  [<ffffffff812aff1b>] ? skb_queue_tail+0x2b/0x60
[  729.686884]  [<ffffffffa04b11f5>] ? ieee80211_release_reorder_frame+0x35/0x50 [mac80211]
[  729.686884]  [<ffffffffa04b2f0c>] ? ieee80211_invoke_rx_handlers+0xb8c/0x1990 [mac80211]
[  729.686884]  [<ffffffff810766bc>] ? mark_held_locks+0x6c/0xa0
[  729.686884]  [<ffffffff81358f30>] ? _write_unlock_irqrestore+0x40/0x60
[  729.686884]  [<ffffffff810768bb>] ? trace_hardirqs_on_caller+0x6b/0x190
[  729.686884]  [<ffffffff810769ed>] ? trace_hardirqs_on+0xd/0x10
[  729.686884]  [<ffffffffa04b3db6>] ? ieee80211_rx+0xa6/0x8f0 [mac80211]
[  729.686884]  [<ffffffffa04b3fef>] ? ieee80211_rx+0x2df/0x8f0 [mac80211]
[  729.686884]  [<ffffffffa04b3db6>] ? ieee80211_rx+0xa6/0x8f0 [mac80211]
[  729.686884]  [<ffffffff812af1c7>] ? skb_copy_bits+0x167/0x2b0
[  729.686884]  [<ffffffffa04fd2f1>] ? iwl_rx_reply_rx+0x571/0xee0 [iwlcore]
[  729.686884]  [<ffffffff8100efb5>] ? dump_trace+0x105/0x2c0
[  729.686884]  [<ffffffff811dceb9>] ? debug_dma_unmap_page+0x59/0x60
[  729.686884]  [<ffffffffa0557e89>] ? iwl_rx_handle+0x149/0x670 [iwlagn]
[  729.686884]  [<ffffffff810766bc>] ? mark_held_locks+0x6c/0xa0
[  729.686884]  [<ffffffffa0559afc>] ? iwl_irq_tasklet+0x2ec/0x1320 [iwlagn]
[  729.686884]  [<ffffffff810766bc>] ? mark_held_locks+0x6c/0xa0
[  729.686884]  [<ffffffff8104b1d9>] ? tasklet_action+0x49/0xe0
[  729.686884]  [<ffffffff8104b260>] ? tasklet_action+0xd0/0xe0
[  729.686884]  [<ffffffff8104c78b>] ? __do_softirq+0xcb/0x200
[  729.686884]  [<ffffffff8100d09c>] ? call_softirq+0x1c/0x50
[  729.686884]  [<ffffffff8100e80d>] ? do_softirq+0x7d/0xb0
[  729.686884]  [<ffffffff8104c2c5>] ? irq_exit+0x95/0xa0
[  729.686884]  [<ffffffff8135e485>] ? do_IRQ+0x75/0xf0
[  729.686884]  [<ffffffff8100c893>] ? ret_from_intr+0x0/0xf
[  729.686884]  <EOI>  [<ffffffff8102eccd>] ? flush_tlb_page+0x7d/0x90
[  729.686884]  [<ffffffff8102ec98>] ? flush_tlb_page+0x48/0x90
[  729.686884]  [<ffffffff810f508d>] ? move_page_tables+0x2cd/0x4c0
[  729.686884]  [<ffffffff810f5133>] ? move_page_tables+0x373/0x4c0
[  729.686884]  [<ffffffff810f5879>] ? do_mremap+0x5f9/0x7a0
[  729.686884]  [<ffffffff810f5a7f>] ? sys_mremap+0x5f/0x90
[  729.686884]  [<ffffffff8100bedb>] ? system_call_fastpath+0x16/0x1b
[  729.686884] ---[ end trace 73a47421077c9587 ]---

Reinette



