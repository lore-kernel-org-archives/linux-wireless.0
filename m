Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60111 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0DLQ3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 12:29:51 -0400
Received: by pva18 with SMTP id 18so3209312pva.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 09:29:51 -0700 (PDT)
From: tom.leiming@gmail.com
To: Sujith.Manoharan@atheros.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ming Lei <tom.leiming@gmail.com>
Subject: [PATCHv2 4/4] ath9k-htc: fix lockdep warning and kernel warning after unplugging ar9271 usb device
Date: Tue, 13 Apr 2010 00:29:27 +0800
Message-Id: <1271089767-7999-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

This patch fixes two warnings below after unplugging ar9271 usb device:
	-one is a kernel warning[1]
	-another is a lockdep warning[2]

The root reason is that __skb_queue_purge can't be executed in hardirq
context, so the patch forks ath9k_skb_queue_purge(ath9k version of _skb_queue_purge),
which frees skb with dev_kfree_skb_any which can be run in hardirq
context safely, then prevent the lockdep warning and kernel warning after
unplugging ar9271 usb device.

[1] kernel warning
[  602.894005] ------------[ cut here ]------------
[  602.894005] WARNING: at net/core/skbuff.c:398 skb_release_head_state+0x71/0x87()
[  602.894005] Hardware name: 6475EK2
[  602.894005] Modules linked in: ath9k_htc ath9k ath9k_common ath9k_hw ath bridge stp llc sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table kvm_intel kvm arc4 ecb mac80211 snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep thinkpad_acpi snd_pcm snd_timer hwmon iTCO_wdt snd e1000e pcspkr i2c_i801 usbhid iTCO_vendor_support wmi cfg80211 yenta_socket rsrc_nonstatic pata_acpi snd_page_alloc soundcore uhci_hcd ohci_hcd ehci_hcd usbcore i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: ath]
[  602.894005] Pid: 2506, comm: ping Tainted: G        W  2.6.34-rc3-wl #20
[  602.894005] Call Trace:
[  602.894005]  <IRQ>  [<ffffffff8104a41c>] warn_slowpath_common+0x7c/0x94
[  602.894005]  [<ffffffffa022f398>] ? __skb_queue_purge+0x43/0x4a [ath9k_htc]
[  602.894005]  [<ffffffff8104a448>] warn_slowpath_null+0x14/0x16
[  602.894005]  [<ffffffff813269c1>] skb_release_head_state+0x71/0x87
[  602.894005]  [<ffffffff8132829a>] __kfree_skb+0x16/0x81
[  602.894005]  [<ffffffff813283b2>] kfree_skb+0x7e/0x86
[  602.894005]  [<ffffffffa022f398>] __skb_queue_purge+0x43/0x4a [ath9k_htc]
[  602.894005]  [<ffffffffa022f560>] __hif_usb_tx+0x1c1/0x21b [ath9k_htc]
[  602.894005]  [<ffffffffa022f73c>] hif_usb_tx_cb+0x12f/0x154 [ath9k_htc]
[  602.894005]  [<ffffffffa00d2fbe>] usb_hcd_giveback_urb+0x91/0xc5 [usbcore]
[  602.894005]  [<ffffffffa00f6c34>] ehci_urb_done+0x7a/0x8b [ehci_hcd]
[  602.894005]  [<ffffffffa00f6f33>] qh_completions+0x2ee/0x376 [ehci_hcd]
[  602.894005]  [<ffffffffa00f8ba5>] ehci_work+0x95/0x76e [ehci_hcd]
[  602.894005]  [<ffffffffa00fa5ae>] ? ehci_irq+0x2f/0x1d4 [ehci_hcd]
[  602.894005]  [<ffffffffa00fa725>] ehci_irq+0x1a6/0x1d4 [ehci_hcd]
[  602.894005]  [<ffffffff810a6d18>] ? __rcu_process_callbacks+0x7a/0x2df
[  602.894005]  [<ffffffff810a47a4>] ? handle_fasteoi_irq+0x22/0xd2
[  602.894005]  [<ffffffffa00d268d>] usb_hcd_irq+0x4a/0xa7 [usbcore]
[  602.894005]  [<ffffffff810a2853>] handle_IRQ_event+0x77/0x14f
[  602.894005]  [<ffffffff813285ce>] ? skb_release_data+0xc9/0xce
[  602.894005]  [<ffffffff810a4814>] handle_fasteoi_irq+0x92/0xd2
[  602.894005]  [<ffffffff8100c4fb>] handle_irq+0x88/0x91
[  602.894005]  [<ffffffff8100baed>] do_IRQ+0x63/0xc9
[  602.894005]  [<ffffffff81354245>] ? ip_flush_pending_frames+0x4d/0x5c
[  602.894005]  [<ffffffff813ba993>] ret_from_intr+0x0/0x16
[  602.894005]  <EOI>  [<ffffffff811095fe>] ? __delete_object+0x5a/0xb1
[  602.894005]  [<ffffffff813ba5f5>] ? _raw_write_unlock_irqrestore+0x47/0x7e
[  602.894005]  [<ffffffff813ba5fa>] ? _raw_write_unlock_irqrestore+0x4c/0x7e
[  602.894005]  [<ffffffff811095fe>] __delete_object+0x5a/0xb1
[  602.894005]  [<ffffffff81109814>] delete_object_full+0x25/0x31
[  602.894005]  [<ffffffff813a60c0>] kmemleak_free+0x26/0x45
[  602.894005]  [<ffffffff810ff517>] kfree+0xaa/0x149
[  602.894005]  [<ffffffff81323fb7>] ? sock_def_write_space+0x84/0x89
[  602.894005]  [<ffffffff81354245>] ? ip_flush_pending_frames+0x4d/0x5c
[  602.894005]  [<ffffffff813285ce>] skb_release_data+0xc9/0xce
[  602.894005]  [<ffffffff813282a2>] __kfree_skb+0x1e/0x81
[  602.894005]  [<ffffffff813283b2>] kfree_skb+0x7e/0x86
[  602.894005]  [<ffffffff81354245>] ip_flush_pending_frames+0x4d/0x5c
[  602.894005]  [<ffffffff81370c1f>] raw_sendmsg+0x653/0x709
[  602.894005]  [<ffffffff81379e31>] inet_sendmsg+0x54/0x5d
[  602.894005]  [<ffffffff813207a2>] ? sock_recvmsg+0xc6/0xdf
[  602.894005]  [<ffffffff813208c1>] sock_sendmsg+0xc0/0xd9
[  602.894005]  [<ffffffff810e13b4>] ? might_fault+0x68/0xb8
[  602.894005]  [<ffffffff810e13fd>] ? might_fault+0xb1/0xb8
[  602.894005]  [<ffffffff8132a1c3>] ? copy_from_user+0x2f/0x31
[  602.894005]  [<ffffffff8132a5b3>] ? verify_iovec+0x54/0x91
[  602.894005]  [<ffffffff81320d41>] sys_sendmsg+0x1da/0x241
[  602.894005]  [<ffffffff8103d327>] ? finish_task_switch+0x0/0xc9
[  602.894005]  [<ffffffff8103d327>] ? finish_task_switch+0x0/0xc9
[  602.894005]  [<ffffffff8107642e>] ? trace_hardirqs_on_caller+0x16/0x150
[  602.894005]  [<ffffffff813ba27d>] ? _raw_spin_unlock_irq+0x56/0x63
[  602.894005]  [<ffffffff8103d3cb>] ? finish_task_switch+0xa4/0xc9
[  602.894005]  [<ffffffff8103d327>] ? finish_task_switch+0x0/0xc9
[  602.894005]  [<ffffffff810357fe>] ? need_resched+0x23/0x2d
[  602.894005]  [<ffffffff8107642e>] ? trace_hardirqs_on_caller+0x16/0x150
[  602.894005]  [<ffffffff813b9750>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  602.894005]  [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  602.894005] ---[ end trace 91ba2d8dc7826839 ]---

[2] lockdep warning
[  169.363215] ======================================================
[  169.365390] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[  169.366334] 2.6.34-rc3-wl #20
[  169.366872] ------------------------------------------------------
[  169.366872] khubd/78 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[  169.366872]  (clock-AF_INET){++.?..}, at: [<ffffffff81323f51>] sock_def_write_space+0x1e/0x89
[  169.366872]
[  169.366872] and this task is already holding:
[  169.366872]  (&(&hif_dev->tx.tx_lock)->rlock){-.-...}, at: [<ffffffffa03715b0>] hif_usb_stop+0x24/0x53 [ath9k_htc]
[  169.366872] which would create a new lock dependency:
[  169.366872]  (&(&hif_dev->tx.tx_lock)->rlock){-.-...} -> (clock-AF_INET){++.?..}
[  169.366872]
[  169.366872] but this new dependency connects a HARDIRQ-irq-safe lock:
[  169.366872]  (&(&hif_dev->tx.tx_lock)->rlock){-.-...}
[  169.366872] ... which became HARDIRQ-irq-safe at:
[  169.366872]   [<ffffffff810772d5>] __lock_acquire+0x2c6/0xd2b
[  169.366872]   [<ffffffff8107866d>] lock_acquire+0xec/0x119
[  169.366872]   [<ffffffff813b99bb>] _raw_spin_lock+0x40/0x73
[  169.366872]   [<ffffffffa037163d>] hif_usb_tx_cb+0x5e/0x154 [ath9k_htc]
[  169.366872]   [<ffffffffa00d2fbe>] usb_hcd_giveback_urb+0x91/0xc5 [usbcore]
[  169.366872]   [<ffffffffa00f6c34>] ehci_urb_done+0x7a/0x8b [ehci_hcd]
[  169.366872]   [<ffffffffa00f6f33>] qh_completions+0x2ee/0x376 [ehci_hcd]
[  169.366872]   [<ffffffffa00f8ba5>] ehci_work+0x95/0x76e [ehci_hcd]
[  169.366872]   [<ffffffffa00fa725>] ehci_irq+0x1a6/0x1d4 [ehci_hcd]
[  169.366872]   [<ffffffffa00d268d>] usb_hcd_irq+0x4a/0xa7 [usbcore]
[  169.366872]   [<ffffffff810a2853>] handle_IRQ_event+0x77/0x14f
[  169.366872]   [<ffffffff810a4814>] handle_fasteoi_irq+0x92/0xd2
[  169.366872]   [<ffffffff8100c4fb>] handle_irq+0x88/0x91
[  169.366872]   [<ffffffff8100baed>] do_IRQ+0x63/0xc9
[  169.366872]   [<ffffffff813ba993>] ret_from_intr+0x0/0x16
[  169.366872]   [<ffffffff8130f6ee>] cpuidle_idle_call+0xa7/0x115
[  169.366872]   [<ffffffff81008c4f>] cpu_idle+0x68/0xc4
[  169.366872]   [<ffffffff813a41e0>] rest_init+0x104/0x10b
[  169.366872]   [<ffffffff81899db3>] start_kernel+0x3f1/0x3fc
[  169.366872]   [<ffffffff818992c8>] x86_64_start_reservations+0xb3/0xb7
[  169.366872]   [<ffffffff818993c4>] x86_64_start_kernel+0xf8/0x107
[  169.366872]
[  169.366872] to a HARDIRQ-irq-unsafe lock:
[  169.366872]  (clock-AF_INET){++.?..}
[  169.366872] ... which became HARDIRQ-irq-unsafe at:
[  169.366872] ...  [<ffffffff81077349>] __lock_acquire+0x33a/0xd2b
[  169.366872]   [<ffffffff8107866d>] lock_acquire+0xec/0x119
[  169.366872]   [<ffffffff813b9d07>] _raw_write_lock_bh+0x45/0x7a
[  169.366872]   [<ffffffff8135cf14>] tcp_close+0x165/0x34d
[  169.366872]   [<ffffffff8137aced>] inet_release+0x55/0x5c
[  169.366872]   [<ffffffff81321350>] sock_release+0x1f/0x6e
[  169.366872]   [<ffffffff813213c6>] sock_close+0x27/0x2b
[  169.366872]   [<ffffffff8110dd45>] __fput+0x125/0x1ca
[  169.366872]   [<ffffffff8110de04>] fput+0x1a/0x1c
[  169.366872]   [<ffffffff8110adc9>] filp_close+0x68/0x72
[  169.366872]   [<ffffffff8110ae80>] sys_close+0xad/0xe7
[  169.366872]   [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  169.366872]
[  169.366872] other info that might help us debug this:
[  169.366872]
[  169.366872] 5 locks held by khubd/78:
[  169.366872]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff8133bc8b>] rtnl_lock+0x17/0x19
[  169.366872]  #1:  (&wdev->mtx){+.+.+.}, at: [<ffffffffa01373f2>] cfg80211_netdev_notifier_call+0x28d/0x46d [cfg80211]
[  169.366872]  #2:  (&ifmgd->mtx){+.+.+.}, at: [<ffffffffa028b085>] ieee80211_mgd_deauth+0x3f/0x18f [mac80211]
[  169.366872]  #3:  (&priv->mutex){+.+.+.}, at: [<ffffffffa0374296>] ath9k_htc_config+0x41/0x496 [ath9k_htc]
[  169.366872]  #4:  (&(&hif_dev->tx.tx_lock)->rlock){-.-...}, at: [<ffffffffa03715b0>] hif_usb_stop+0x24/0x53 [ath9k_htc]
[  169.366872]
[  169.366872] the dependencies between HARDIRQ-irq-safe lock and the holding lock:
[  169.366872] -> (&(&hif_dev->tx.tx_lock)->rlock){-.-...} ops: 239529 {
[  169.366872]    IN-HARDIRQ-W at:
[  169.366872]                                        [<ffffffff810772d5>] __lock_acquire+0x2c6/0xd2b
[  169.366872]                                        [<ffffffff8107866d>] lock_acquire+0xec/0x119
[  169.366872]                                        [<ffffffff813b99bb>] _raw_spin_lock+0x40/0x73
[  169.366872]                                        [<ffffffffa037163d>] hif_usb_tx_cb+0x5e/0x154 [ath9k_htc]
[  169.366872]                                        [<ffffffffa00d2fbe>] usb_hcd_giveback_urb+0x91/0xc5 [usbcore]
[  169.366872]                                        [<ffffffffa00f6c34>] ehci_urb_done+0x7a/0x8b [ehci_hcd]
[  169.366872]                                        [<ffffffffa00f6f33>] qh_completions+0x2ee/0x376 [ehci_hcd]
[  169.366872]                                        [<ffffffffa00f8ba5>] ehci_work+0x95/0x76e [ehci_hcd]
[  169.366872]                                        [<ffffffffa00fa725>] ehci_irq+0x1a6/0x1d4 [ehci_hcd]
[  169.366872]                                        [<ffffffffa00d268d>] usb_hcd_irq+0x4a/0xa7 [usbcore]
[  169.366872]                                        [<ffffffff810a2853>] handle_IRQ_event+0x77/0x14f
[  169.366872]                                        [<ffffffff810a4814>] handle_fasteoi_irq+0x92/0xd2
[  169.366872]                                        [<ffffffff8100c4fb>] handle_irq+0x88/0x91
[  169.366872]                                        [<ffffffff8100baed>] do_IRQ+0x63/0xc9
[  169.366872]                                        [<ffffffff813ba993>] ret_from_intr+0x0/0x16
[  169.366872]                                        [<ffffffff8130f6ee>] cpuidle_idle_call+0xa7/0x115
[  169.366872]                                        [<ffffffff81008c4f>] cpu_idle+0x68/0xc4
[  169.366872]                                        [<ffffffff813a41e0>] rest_init+0x104/0x10b
[  169.366872]                                        [<ffffffff81899db3>] start_kernel+0x3f1/0x3fc
[  169.366872]                                        [<ffffffff818992c8>] x86_64_start_reservations+0xb3/0xb7
[  169.366872]                                        [<ffffffff818993c4>] x86_64_start_kernel+0xf8/0x107
[  169.366872]    IN-SOFTIRQ-W at:
[  169.366872]                                        [<ffffffff810772f6>] __lock_acquire+0x2e7/0xd2b
[  169.366872]                                        [<ffffffff8107866d>] lock_acquire+0xec/0x119
[  169.366872]                                        [<ffffffff813b9b5b>] _raw_spin_lock_irqsave+0x58/0x92
[  169.366872]                                        [<ffffffffa03719a1>] hif_usb_send+0x46/0x208 [ath9k_htc]
[  169.366872]                                        [<ffffffffa0370496>] htc_issue_send.clone.0+0x6c/0x7b [ath9k_htc]
[  169.366872]                                        [<ffffffffa0370864>] htc_send+0x18/0x1a [ath9k_htc]
[  169.366872]                                        [<ffffffffa03731dc>] ath9k_htc_tx_start+0x1d9/0x1e4 [ath9k_htc]
[  169.366872]                                        [<ffffffffa0374e59>] ath9k_htc_tx+0x85/0x105 [ath9k_htc]
[  169.366872]                                        [<ffffffffa029805a>] __ieee80211_tx+0xfa/0x16e [mac80211]
[  169.366872]                                        [<ffffffffa0299070>] ieee80211_tx+0xe5/0x206 [mac80211]
[  169.366872]                                        [<ffffffffa0299307>] ieee80211_xmit+0x176/0x18a [mac80211]
[  169.366872]                                        [<ffffffffa029a3e2>] ieee80211_subif_start_xmit+0x70d/0x72b [mac80211]
[  169.366872]                                        [<ffffffff81331590>] dev_hard_start_xmit+0x228/0x2f9
[  169.366872]                                        [<ffffffff813452ef>] sch_direct_xmit+0x6d/0x17e
[  169.366872]                                        [<ffffffff81331a49>] dev_queue_xmit+0x2d0/0x45d
[  169.366872]                                        [<ffffffff8133a524>] neigh_resolve_output+0x216/0x267
[  169.366872]                                        [<ffffffffa03f813e>] ip6_output2+0x358/0x39f [ipv6]
[  169.366872]                                        [<ffffffffa03f8d39>] ip6_output+0xbb4/0xbc6 [ipv6]
[  169.366872]                                        [<ffffffffa0411af3>] mld_sendpack+0x248/0x363 [ipv6]
[  169.366872]                                        [<ffffffffa041231b>] mld_ifc_timer_expire+0x246/0x27f [ipv6]
[  169.366872]                                        [<ffffffff81056ed6>] run_timer_softirq+0x246/0x31b
[  169.366872]                                        [<ffffffff81050a64>] __do_softirq+0x11c/0x1fd
[  169.366872]                                        [<ffffffff8100ab9c>] call_softirq+0x1c/0x30
[  169.366872]                                        [<ffffffff8100c41b>] do_softirq+0x4b/0xa3
[  169.366872]                                        [<ffffffff81050543>] irq_exit+0x4a/0x99
[  169.366872]                                        [<ffffffff81021091>] smp_apic_timer_interrupt+0x84/0x92
[  169.366872]                                        [<ffffffff8100a653>] apic_timer_interrupt+0x13/0x20
[  169.366872]                                        [<ffffffff8100d87c>] print_context_stack+0xa8/0xc4
[  169.366872]                                        [<ffffffff8100cbb5>] dump_trace+0x2fa/0x32d
[  169.366872]                                        [<ffffffff8101554c>] save_stack_trace+0x2f/0x4c
[  169.366872]                                        [<ffffffff8110a9f0>] create_object+0x1a4/0x2a8
[  169.366872]                                        [<ffffffff813a61dc>] kmemleak_alloc+0x26/0x43
[  169.366872]                                        [<ffffffff810ff401>] kmem_cache_alloc+0xff/0x16b
[  169.366872]                                        [<ffffffff8132826a>] skb_clone+0x47/0x61
[  169.366872]                                        [<ffffffff81349f86>] netlink_broadcast+0xfc/0x279
[  169.366872]                                        [<ffffffff8134a51d>] nlmsg_notify+0x48/0x8e
[  169.366872]                                        [<ffffffff8133b92b>] rtnl_notify+0x30/0x32
[  169.366872]                                        [<ffffffff8139f588>] wireless_nlevent_process+0x35/0x70
[  169.366872]                                        [<ffffffff81060f84>] worker_thread+0x28b/0x38a
[  169.366872]                                        [<ffffffff8106525d>] kthread+0x7f/0x87
[  169.366872]                                        [<ffffffff8100aaa4>] kernel_thread_helper+0x4/0x10
[  169.366872]    INITIAL USE at:
[  169.366872]                                       [<ffffffff810773c0>] __lock_acquire+0x3b1/0xd2b
[  169.366872]                                       [<ffffffff8107866d>] lock_acquire+0xec/0x119
[  169.366872]                                       [<ffffffff813b9b5b>] _raw_spin_lock_irqsave+0x58/0x92
[  169.366872]                                       [<ffffffffa0370b81>] hif_usb_start+0x25/0x3b [ath9k_htc]
[  169.366872]                                       [<ffffffffa03700a6>] htc_start+0x49/0x5d [ath9k_htc]
[  169.366872]                                       [<ffffffffa0374d9a>] ath9k_htc_start+0x1c2/0x1fc [ath9k_htc]
[  169.366872]                                       [<ffffffffa029082d>] ieee80211_open+0x287/0x68e [mac80211]
[  169.366872]                                       [<ffffffff813321a8>] __dev_open+0x8e/0xbc
[  169.366872]                                       [<ffffffff8132ff65>] __dev_change_flags+0xad/0x130
[  169.366872]                                       [<ffffffff813320e5>] dev_change_flags+0x21/0x56
[  169.366872]                                       [<ffffffff81378db0>] devinet_ioctl+0x270/0x504
[  169.366872]                                       [<ffffffff8137a750>] inet_ioctl+0x8f/0xa7
[  169.366872]                                       [<ffffffff8131f6fd>] sock_do_ioctl+0x29/0x48
[  169.366872]                                       [<ffffffff8131fb23>] sock_ioctl+0x213/0x222
[  169.366872]                                       [<ffffffff81119614>] vfs_ioctl+0x32/0xa6
[  169.366872]                                       [<ffffffff81119b94>] do_vfs_ioctl+0x490/0x4d6
[  169.366872]                                       [<ffffffff81119c21>] sys_ioctl+0x47/0x6a
[  169.366872]                                       [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  169.366872]  }
[  169.366872]  ... key      at: [<ffffffffa0379328>] __key.44613+0x0/0xffffffffffffdca3 [ath9k_htc]
[  169.366872]  ... acquired at:
[  169.366872]    [<ffffffff81076fae>] check_irq_usage+0x5d/0xbe
[  169.366872]    [<ffffffff81077a4f>] __lock_acquire+0xa40/0xd2b
[  169.366872]    [<ffffffff8107866d>] lock_acquire+0xec/0x119
[  169.366872]    [<ffffffff813ba0da>] _raw_read_lock+0x43/0x78
[  169.366872]    [<ffffffff81323f51>] sock_def_write_space+0x1e/0x89
[  169.366872]    [<ffffffff81324879>] sock_wfree+0x42/0x60
[  169.366872]    [<ffffffff813269ca>] skb_release_head_state+0x7a/0x87
[  169.366872]    [<ffffffff8132829a>] __kfree_skb+0x16/0x81
[  169.366872]    [<ffffffff813283b2>] kfree_skb+0x7e/0x86
[  169.366872]    [<ffffffffa037136b>] __skb_queue_purge+0x43/0x49 [ath9k_htc]
[  169.366872]    [<ffffffffa03715bd>] hif_usb_stop+0x31/0x53 [ath9k_htc]
[  169.366872]    [<ffffffffa0370049>] htc_stop+0x49/0x5d [ath9k_htc]
[  169.366872]    [<ffffffffa0374376>] ath9k_htc_config+0x121/0x496 [ath9k_htc]
[  169.366872]    [<ffffffffa0282a52>] ieee80211_hw_config+0xf3/0x148 [mac80211]
[  169.366872]    [<ffffffffa028adbc>] ieee80211_set_disassoc+0x15f/0x18a [mac80211]
[  169.366872]    [<ffffffffa028b0a3>] ieee80211_mgd_deauth+0x5d/0x18f [mac80211]
[  169.366872]    [<ffffffffa0292b88>] ieee80211_deauth+0x1e/0x20 [mac80211]
[  169.366872]    [<ffffffffa0146de6>] __cfg80211_mlme_deauth+0x140/0x14f [cfg80211]
[  169.366872]    [<ffffffffa014a5af>] __cfg80211_disconnect+0x11b/0x193 [cfg80211]
[  169.366872]    [<ffffffffa0137433>] cfg80211_netdev_notifier_call+0x2ce/0x46d [cfg80211]
[  169.366872]    [<ffffffff813bd892>] notifier_call_chain+0x37/0x63
[  169.366872]    [<ffffffff8106a134>] raw_notifier_call_chain+0x14/0x16
[  169.366872]    [<ffffffff81331dbe>] call_netdevice_notifiers+0x1b/0x1d
[  169.366872]    [<ffffffff81332232>] __dev_close+0x5c/0x8b
[  169.366872]    [<ffffffff8133256d>] dev_close+0x1f/0x45
[  169.366872]    [<ffffffff81332623>] rollback_registered_many+0x90/0x1a6
[  169.366872]    [<ffffffff81332752>] unregister_netdevice_many+0x19/0x56
[  169.366872]    [<ffffffffa028f6af>] ieee80211_remove_interfaces+0xa6/0xb5 [mac80211]
[  169.366872]    [<ffffffffa02820a2>] ieee80211_unregister_hw+0x47/0xe8 [mac80211]
[  169.366872]    [<ffffffffa037658e>] ath9k_htc_disconnect_device+0x3b/0x73 [ath9k_htc]
[  169.366872]    [<ffffffffa03700d1>] ath9k_htc_hw_deinit+0x17/0x19 [ath9k_htc]
[  169.366872]    [<ffffffffa03712b9>] ath9k_hif_usb_disconnect+0x3b/0xaa [ath9k_htc]
[  169.366872]    [<ffffffffa00d819c>] usb_unbind_interface+0x71/0x13a [usbcore]
[  169.366872]    [<ffffffff812a86c4>] __device_release_driver+0x7b/0xd1
[  169.366872]    [<ffffffff812a87f5>] device_release_driver+0x1e/0x2a
[  169.366872]    [<ffffffff812a7a7c>] bus_remove_device+0xc9/0xde
[  169.366872]    [<ffffffff812a5f04>] device_del+0x137/0x185
[  169.366872]    [<ffffffffa00d52a4>] usb_disable_device+0x85/0xfc [usbcore]
[  169.366872]    [<ffffffffa00d0590>] usb_disconnect+0x9b/0x129 [usbcore]
[  169.366872]    [<ffffffffa00d0d3b>] hub_thread+0x50a/0xf63 [usbcore]
[  169.366872]    [<ffffffff8106525d>] kthread+0x7f/0x87
[  169.366872]    [<ffffffff8100aaa4>] kernel_thread_helper+0x4/0x10
[  169.366872]
[  169.366872]
[  169.366872] the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
[  169.366872] -> (clock-AF_INET){++.?..} ops: 1525890 {
[  169.366872]    HARDIRQ-ON-W at:
[  169.366872]                                        [<ffffffff81077349>] __lock_acquire+0x33a/0xd2b
[  169.366872]                                        [<ffffffff8107866d>] lock_acquire+0xec/0x119
[  169.366872]                                        [<ffffffff813b9d07>] _raw_write_lock_bh+0x45/0x7a
[  169.366872]                                        [<ffffffff8135cf14>] tcp_close+0x165/0x34d
[  169.366872]                                        [<ffffffff8137aced>] inet_release+0x55/0x5c
[  169.366872]                                        [<ffffffff81321350>] sock_release+0x1f/0x6e
[  169.366872]                                        [<ffffffff813213c6>] sock_close+0x27/0x2b
[  169.366872]                                        [<ffffffff8110dd45>] __fput+0x125/0x1ca
[  169.366872]                                        [<ffffffff8110de04>] fput+0x1a/0x1c
[  169.366872]                                        [<ffffffff8110adc9>] filp_close+0x68/0x72
[  169.366872]                                        [<ffffffff8110ae80>] sys_close+0xad/0xe7
[  169.366872]                                        [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  169.366872]    HARDIRQ-ON-R at:
[  169.366872]                                        [<ffffffff81077321>] __lock_acquire+0x312/0xd2b
[  169.366872]                                        [<ffffffff8107866d>] lock_acquire+0xec/0x119
[  169.366872]                                        [<ffffffff813ba0da>] _raw_read_lock+0x43/0x78
[  169.366872]                                        [<ffffffff81323f51>] sock_def_write_space+0x1e/0x89
[  169.366872]                                        [<ffffffff81324879>] sock_wfree+0x42/0x60
[  169.366872]                                        [<ffffffff812e83d2>] loopback_xmit+0x26/0x8c
[  169.366872]                                        [<ffffffff81331590>] dev_hard_start_xmit+0x228/0x2f9
[  169.366872]                                        [<ffffffff81331b00>] dev_queue_xmit+0x387/0x45d
[  169.366872]                                        [<ffffffff8133a524>] neigh_resolve_output+0x216/0x267
[  169.366872]                                        [<ffffffff813566ac>] ip_finish_output2+0x25c/0x291
[  169.366872]                                        [<ffffffff81356742>] ip_finish_output+0x61/0x63
[  169.366872]                                        [<ffffffff813567e3>] ip_output+0x9f/0xa8
[  169.366872]                                        [<ffffffff81354068>] dst_output+0x10/0x12
[  169.366872]                                        [<ffffffff8135484b>] ip_local_out+0x61/0x63
[  169.366872]                                        [<ffffffff81354aff>] ip_push_pending_frames+0x2b2/0x313
[  169.366872]                                        [<ffffffff8137276f>] udp_push_pending_frames+0x2de/0x35e
[  169.366872]                                        [<ffffffff81373861>] udp_sendmsg+0x4fb/0x5f2
[  169.366872]                                        [<ffffffff81379e31>] inet_sendmsg+0x54/0x5d
[  169.366872]                                        [<ffffffff813208c1>] sock_sendmsg+0xc0/0xd9
[  169.366872]                                        [<ffffffff81322332>] sys_sendto+0xe0/0x105
[  169.366872]                                        [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  169.366872]    IN-SOFTIRQ-R at:
[  169.366872]                                        [<ffffffff810772f6>] __lock_acquire+0x2e7/0xd2b
[  169.366872]                                        [<ffffffff8107866d>] lock_acquire+0xec/0x119
[  169.366872]                                        [<ffffffff813ba0da>] _raw_read_lock+0x43/0x78
[  169.366872]                                        [<ffffffff81323fda>] sock_def_readable+0x1e/0x67
[  169.366872]                                        [<ffffffff81325e4a>] sock_queue_rcv_skb+0x141/0x163
[  169.366872]                                        [<ffffffff813719ca>] __udp_queue_rcv_skb+0x17/0x85
[  169.366872]                                        [<ffffffff81374135>] udp_queue_rcv_skb+0x14c/0x204
[  169.366872]                                        [<ffffffff8137476f>] __udp4_lib_rcv+0x2c1/0x481
[  169.366872]                                        [<ffffffff81374949>] udp_rcv+0x1a/0x1c
[  169.366872]                                        [<ffffffff8135203a>] ip_local_deliver+0x106/0x17c
[  169.366872]                                        [<ffffffff81351d84>] ip_rcv+0x4e5/0x525
[  169.366872]                                        [<ffffffff813304c0>] netif_receive_skb+0x341/0x36e
[  169.366872]                                        [<ffffffff8133058e>] process_backlog+0xa1/0xe1
[  169.366872]                                        [<ffffffff813307ff>] net_rx_action+0xc8/0x21c
[  169.366872]                                        [<ffffffff81050a64>] __do_softirq+0x11c/0x1fd
[  169.366872]                                        [<ffffffff8100ab9c>] call_softirq+0x1c/0x30
[  169.366872]                                        [<ffffffff8105049d>] _local_bh_enable_ip+0xb8/0xf0
[  169.366872]                                        [<ffffffff810504f7>] local_bh_enable+0x12/0x14
[  169.366872]                                        [<ffffffff813310e3>] rcu_read_unlock_bh+0x26/0x28
[  169.366872]                                        [<ffffffff81331ba2>] dev_queue_xmit+0x429/0x45d
[  169.366872]                                        [<ffffffff8133a524>] neigh_resolve_output+0x216/0x267
[  169.366872]                                        [<ffffffff813566ac>] ip_finish_output2+0x25c/0x291
[  169.366872]                                        [<ffffffff81356742>] ip_finish_output+0x61/0x63
[  169.366872]                                        [<ffffffff813567e3>] ip_output+0x9f/0xa8
[  169.366872]                                        [<ffffffff81354068>] dst_output+0x10/0x12
[  169.366872]                                        [<ffffffff8135484b>] ip_local_out+0x61/0x63
[  169.366872]                                        [<ffffffff81354aff>] ip_push_pending_frames+0x2b2/0x313
[  169.366872]                                        [<ffffffff8137276f>] udp_push_pending_frames+0x2de/0x35e
[  169.366872]                                        [<ffffffff81373861>] udp_sendmsg+0x4fb/0x5f2
[  169.366872]                                        [<ffffffff81379e31>] inet_sendmsg+0x54/0x5d
[  169.366872]                                        [<ffffffff813208c1>] sock_sendmsg+0xc0/0xd9
[  169.366872]                                        [<ffffffff81322332>] sys_sendto+0xe0/0x105
[  169.366872]                                        [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  169.366872]    SOFTIRQ-ON-R at:
[  169.366872]                                        [<ffffffff8107736a>] __lock_acquire+0x35b/0xd2b
[  169.366872]                                        [<ffffffff8107866d>] lock_acquire+0xec/0x119
[  169.366872]                                        [<ffffffff813ba0da>] _raw_read_lock+0x43/0x78
[  169.366872]                                        [<ffffffff81323f51>] sock_def_write_space+0x1e/0x89
[  169.366872]                                        [<ffffffff8132584e>] sock_setsockopt+0x26d/0x5e7
[  169.366872]                                        [<ffffffff81320ace>] sys_setsockopt+0x66/0x96
[  169.366872]                                        [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  169.366872]    INITIAL USE at:
[  169.366872]                                       [<ffffffff810773c0>] __lock_acquire+0x3b1/0xd2b
[  169.366872]                                       [<ffffffff8107866d>] lock_acquire+0xec/0x119
[  169.366872]                                       [<ffffffff813b9d07>] _raw_write_lock_bh+0x45/0x7a
[  169.366872]                                       [<ffffffff8135cf14>] tcp_close+0x165/0x34d
[  169.366872]                                       [<ffffffff8137aced>] inet_release+0x55/0x5c
[  169.366872]                                       [<ffffffff81321350>] sock_release+0x1f/0x6e
[  169.366872]                                       [<ffffffff813213c6>] sock_close+0x27/0x2b
[  169.366872]                                       [<ffffffff8110dd45>] __fput+0x125/0x1ca
[  169.366872]                                       [<ffffffff8110de04>] fput+0x1a/0x1c
[  169.366872]                                       [<ffffffff8110adc9>] filp_close+0x68/0x72
[  169.366872]                                       [<ffffffff8110ae80>] sys_close+0xad/0xe7
[  169.366872]                                       [<ffffffff81009c02>] system_call_fastpath+0x16/0x1b
[  169.366872]  }
[  169.366872]  ... key      at: [<ffffffff824b1440>] af_callback_keys+0x10/0x128
[  169.366872]  ... acquired at:
[  169.366872]    [<ffffffff81076fae>] check_irq_usage+0x5d/0xbe
[  169.366872]    [<ffffffff81077a4f>] __lock_acquire+0xa40/0xd2b
[  169.366872]    [<ffffffff8107866d>] lock_acquire+0xec/0x119
[  169.366872]    [<ffffffff813ba0da>] _raw_read_lock+0x43/0x78
[  169.366872]    [<ffffffff81323f51>] sock_def_write_space+0x1e/0x89
[  169.366872]    [<ffffffff81324879>] sock_wfree+0x42/0x60
[  169.366872]    [<ffffffff813269ca>] skb_release_head_state+0x7a/0x87
[  169.366872]    [<ffffffff8132829a>] __kfree_skb+0x16/0x81
[  169.366872]    [<ffffffff813283b2>] kfree_skb+0x7e/0x86
[  169.366872]    [<ffffffffa037136b>] __skb_queue_purge+0x43/0x49 [ath9k_htc]
[  169.366872]    [<ffffffffa03715bd>] hif_usb_stop+0x31/0x53 [ath9k_htc]
[  169.366872]    [<ffffffffa0370049>] htc_stop+0x49/0x5d [ath9k_htc]
[  169.366872]    [<ffffffffa0374376>] ath9k_htc_config+0x121/0x496 [ath9k_htc]
[  169.366872]    [<ffffffffa0282a52>] ieee80211_hw_config+0xf3/0x148 [mac80211]
[  169.366872]    [<ffffffffa028adbc>] ieee80211_set_disassoc+0x15f/0x18a [mac80211]
[  169.366872]    [<ffffffffa028b0a3>] ieee80211_mgd_deauth+0x5d/0x18f [mac80211]
[  169.366872]    [<ffffffffa0292b88>] ieee80211_deauth+0x1e/0x20 [mac80211]
[  169.366872]    [<ffffffffa0146de6>] __cfg80211_mlme_deauth+0x140/0x14f [cfg80211]
[  169.366872]    [<ffffffffa014a5af>] __cfg80211_disconnect+0x11b/0x193 [cfg80211]
[  169.366872]    [<ffffffffa0137433>] cfg80211_netdev_notifier_call+0x2ce/0x46d [cfg80211]
[  169.366872]    [<ffffffff813bd892>] notifier_call_chain+0x37/0x63
[  169.366872]    [<ffffffff8106a134>] raw_notifier_call_chain+0x14/0x16
[  169.366872]    [<ffffffff81331dbe>] call_netdevice_notifiers+0x1b/0x1d
[  169.366872]    [<ffffffff81332232>] __dev_close+0x5c/0x8b
[  169.366872]    [<ffffffff8133256d>] dev_close+0x1f/0x45
[  169.366872]    [<ffffffff81332623>] rollback_registered_many+0x90/0x1a6
[  169.366872]    [<ffffffff81332752>] unregister_netdevice_many+0x19/0x56
[  169.366872]    [<ffffffffa028f6af>] ieee80211_remove_interfaces+0xa6/0xb5 [mac80211]
[  169.366872]    [<ffffffffa02820a2>] ieee80211_unregister_hw+0x47/0xe8 [mac80211]
[  169.366872]    [<ffffffffa037658e>] ath9k_htc_disconnect_device+0x3b/0x73 [ath9k_htc]
[  169.366872]    [<ffffffffa03700d1>] ath9k_htc_hw_deinit+0x17/0x19 [ath9k_htc]
[  169.366872]    [<ffffffffa03712b9>] ath9k_hif_usb_disconnect+0x3b/0xaa [ath9k_htc]
[  169.366872]    [<ffffffffa00d819c>] usb_unbind_interface+0x71/0x13a [usbcore]
[  169.366872]    [<ffffffff812a86c4>] __device_release_driver+0x7b/0xd1
[  169.366872]    [<ffffffff812a87f5>] device_release_driver+0x1e/0x2a
[  169.366872]    [<ffffffff812a7a7c>] bus_remove_device+0xc9/0xde
[  169.366872]    [<ffffffff812a5f04>] device_del+0x137/0x185
[  169.366872]    [<ffffffffa00d52a4>] usb_disable_device+0x85/0xfc [usbcore]
[  169.366872]    [<ffffffffa00d0590>] usb_disconnect+0x9b/0x129 [usbcore]
[  169.366872]    [<ffffffffa00d0d3b>] hub_thread+0x50a/0xf63 [usbcore]
[  169.366872]    [<ffffffff8106525d>] kthread+0x7f/0x87
[  169.366872]    [<ffffffff8100aaa4>] kernel_thread_helper+0x4/0x10
[  169.366872]
[  169.366872]
[  169.366872] stack backtrace:
[  169.366872] Pid: 78, comm: khubd Not tainted 2.6.34-rc3-wl #20
[  169.366872] Call Trace:
[  169.366872]  [<ffffffff81076f3d>] check_usage+0x350/0x364
[  169.366872]  [<ffffffff81010471>] ? sched_clock+0x9/0xd
[  169.366872]  [<ffffffff81076fae>] check_irq_usage+0x5d/0xbe
[  169.366872]  [<ffffffff81077a4f>] __lock_acquire+0xa40/0xd2b
[  169.366872]  [<ffffffff81074d0b>] ? __bfs+0x141/0x1d4
[  169.366872]  [<ffffffff81076ffe>] ? check_irq_usage+0xad/0xbe
[  169.366872]  [<ffffffff81323f51>] ? sock_def_write_space+0x1e/0x89
[  169.366872]  [<ffffffff8107866d>] lock_acquire+0xec/0x119
[  169.366872]  [<ffffffff81323f51>] ? sock_def_write_space+0x1e/0x89
[  169.366872]  [<ffffffffa037136b>] ? __skb_queue_purge+0x43/0x49 [ath9k_htc]
[  169.366872]  [<ffffffff813ba0da>] _raw_read_lock+0x43/0x78
[  169.366872]  [<ffffffff81323f51>] ? sock_def_write_space+0x1e/0x89
[  169.366872]  [<ffffffff81323f51>] sock_def_write_space+0x1e/0x89
[  169.366872]  [<ffffffff81324879>] sock_wfree+0x42/0x60
[  169.366872]  [<ffffffff813269ca>] skb_release_head_state+0x7a/0x87
[  169.366872]  [<ffffffff8132829a>] __kfree_skb+0x16/0x81
[  169.366872]  [<ffffffff813283b2>] kfree_skb+0x7e/0x86
[  169.366872]  [<ffffffffa037136b>] __skb_queue_purge+0x43/0x49 [ath9k_htc]
[  169.366872]  [<ffffffffa03715bd>] hif_usb_stop+0x31/0x53 [ath9k_htc]
[  169.366872]  [<ffffffffa0370049>] htc_stop+0x49/0x5d [ath9k_htc]
[  169.366872]  [<ffffffffa0374376>] ath9k_htc_config+0x121/0x496 [ath9k_htc]
[  169.366872]  [<ffffffff81061892>] ? __cancel_work_timer+0xe4/0x17e
[  169.366872]  [<ffffffff8106184c>] ? __cancel_work_timer+0x9e/0x17e
[  169.366872]  [<ffffffffa0282a52>] ieee80211_hw_config+0xf3/0x148 [mac80211]
[  169.366872]  [<ffffffffa028adbc>] ieee80211_set_disassoc+0x15f/0x18a [mac80211]
[  169.366872]  [<ffffffffa028b0a3>] ieee80211_mgd_deauth+0x5d/0x18f [mac80211]
[  169.366872]  [<ffffffff8107627a>] ? mark_held_locks+0x52/0x70
[  169.366872]  [<ffffffffa0292b88>] ieee80211_deauth+0x1e/0x20 [mac80211]
[  169.366872]  [<ffffffffa0146de6>] __cfg80211_mlme_deauth+0x140/0x14f [cfg80211]
[  169.366872]  [<ffffffff813b88a8>] ? __mutex_lock_common+0x447/0x49d
[  169.366872]  [<ffffffffa01373f2>] ? cfg80211_netdev_notifier_call+0x28d/0x46d [cfg80211]
[  169.366872]  [<ffffffffa014a5af>] __cfg80211_disconnect+0x11b/0x193 [cfg80211]
[  169.366872]  [<ffffffffa0137433>] cfg80211_netdev_notifier_call+0x2ce/0x46d [cfg80211]
[  169.366872]  [<ffffffff813bd892>] notifier_call_chain+0x37/0x63
[  169.366872]  [<ffffffff8106a134>] raw_notifier_call_chain+0x14/0x16
[  169.366872]  [<ffffffff81331dbe>] call_netdevice_notifiers+0x1b/0x1d
[  169.366872]  [<ffffffff81332232>] __dev_close+0x5c/0x8b
[  169.366872]  [<ffffffff8133256d>] dev_close+0x1f/0x45
[  169.366872]  [<ffffffff81332623>] rollback_registered_many+0x90/0x1a6
[  169.366872]  [<ffffffff81332752>] unregister_netdevice_many+0x19/0x56
[  169.366872]  [<ffffffffa028f6af>] ieee80211_remove_interfaces+0xa6/0xb5 [mac80211]
[  169.366872]  [<ffffffffa02820a2>] ieee80211_unregister_hw+0x47/0xe8 [mac80211]
[  169.366872]  [<ffffffffa037658e>] ath9k_htc_disconnect_device+0x3b/0x73 [ath9k_htc]
[  169.366872]  [<ffffffffa03700d1>] ath9k_htc_hw_deinit+0x17/0x19 [ath9k_htc]
[  169.366872]  [<ffffffffa03712b9>] ath9k_hif_usb_disconnect+0x3b/0xaa [ath9k_htc]
[  169.366872]  [<ffffffffa00d819c>] usb_unbind_interface+0x71/0x13a [usbcore]
[  169.366872]  [<ffffffff812a86c4>] __device_release_driver+0x7b/0xd1
[  169.366872]  [<ffffffff812a87f5>] device_release_driver+0x1e/0x2a
[  169.366872]  [<ffffffff812a7a7c>] bus_remove_device+0xc9/0xde
[  169.366872]  [<ffffffff812a5f04>] device_del+0x137/0x185
[  169.366872]  [<ffffffffa00d52a4>] usb_disable_device+0x85/0xfc [usbcore]
[  169.366872]  [<ffffffffa00d0590>] usb_disconnect+0x9b/0x129 [usbcore]
[  169.366872]  [<ffffffffa00d0d3b>] hub_thread+0x50a/0xf63 [usbcore]
[  169.366872]  [<ffffffff810757d9>] ? trace_hardirqs_off+0xd/0xf
[  169.366872]  [<ffffffff813b7c1b>] ? schedule+0x5ee/0x649
[  169.366872]  [<ffffffff8107653d>] ? trace_hardirqs_on_caller+0x125/0x150
[  169.366872]  [<ffffffff8106570a>] ? autoremove_wake_function+0x0/0x39
[  169.366872]  [<ffffffffa00d0831>] ? hub_thread+0x0/0xf63 [usbcore]
[  169.366872]  [<ffffffff8106525d>] kthread+0x7f/0x87
[  169.366872]  [<ffffffff8100aaa4>] kernel_thread_helper+0x4/0x10
[  169.366872]  [<ffffffff813baa54>] ? restore_args+0x0/0x30
[  169.366872]  [<ffffffff810651de>] ? kthread+0x0/0x87
[  169.366872]  [<ffffffff8100aaa0>] ? kernel_thread_helper+0x0/0x10

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Sujith <Sujith.Manoharan@atheros.com>
---
This version does not any change but rebase against the previous fix.
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 3d8f0f4..fe994e2 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -149,6 +149,13 @@ static void hif_usb_tx_cb(struct urb *urb)
 	}
 }
 
+static inline void ath9k_skb_queue_purge(struct sk_buff_head *list)
+{
+	struct sk_buff *skb;
+	while ((skb = __skb_dequeue(list)) != NULL)
+		dev_kfree_skb_any(skb);
+}
+
 /* TX lock has to be taken */
 static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 {
@@ -207,7 +214,7 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 	ret = usb_submit_urb(tx_buf->urb, GFP_ATOMIC);
 	if (ret) {
 		tx_buf->len = tx_buf->offset = 0;
-		__skb_queue_purge(&tx_buf->skb_queue);
+		ath9k_skb_queue_purge(&tx_buf->skb_queue);
 		__skb_queue_head_init(&tx_buf->skb_queue);
 		list_move_tail(&tx_buf->list, &hif_dev->tx.tx_buf);
 		hif_dev->tx.tx_buf_cnt++;
@@ -274,7 +281,7 @@ static void hif_usb_stop(void *hif_handle, u8 pipe_id)
 	unsigned long flags;
 
 	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
-	__skb_queue_purge(&hif_dev->tx.tx_skb_queue);
+	ath9k_skb_queue_purge(&hif_dev->tx.tx_skb_queue);
 	hif_dev->tx.tx_skb_cnt = 0;
 	hif_dev->tx.flags |= HIF_USB_TX_STOP;
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
-- 
1.6.2.5

