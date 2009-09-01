Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2753 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbZIAMRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 08:17:38 -0400
Received: from hash ([72.83.200.195])
	(authenticated user bob@bobcopeland.com)
	by mail.deathmatch.net
	(using TLSv1/SSLv3 with cipher AES256-SHA (256 bits))
	for linux-wireless@vger.kernel.org;
	Tue, 1 Sep 2009 08:17:39 -0400
Received: from bob by hash with local (Exim 4.69)
	(envelope-from <me@bobcopeland.com>)
	id 1MiSIi-0005cp-U2
	for linux-wireless@vger.kernel.org; Tue, 01 Sep 2009 08:17:28 -0400
Date: Tue, 1 Sep 2009 08:17:28 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Subject: soft lockup in cfg80211 find_ie()
Message-ID: <20090901121728.GA15790@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

My laptop was on all night and at some point got stuck in a loop.
Unfortunately I don't know exactly what happened since dmesg buffer
filled up and there was nothing incriminating in /var/log, but
here's my interpretation:

EIP points to line 146:

   while (len > 2 && ies[0] != num) ...

ECX holds len, which is negative (unfortunately size_t is unsigned)
EDX holds ies, looks like a valid pointer
EBX holds num, which is 0.

This looks like this is a DoS-able bug if there are any malformed
packets, no?  I think we should change 'len' to int here.

[38442.105007] BUG: soft lockup - CPU#0 stuck for 61s! [phy0:2230]
[38442.105007] Modules linked in: aes_i586 aes_generic fuse af_packet ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state iptable_filter ip_tables x_tables acpi_cpufreq binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath dm_mod kvm_intel kvm uinput i915 arc4 ecb drm snd_hda_codec_idt ath5k snd_hda_intel hid_apple mac80211 usbhid appletouch snd_hda_codec snd_pcm ath cfg80211 snd_timer i2c_algo_bit ohci1394 video snd processor ieee1394 rfkill ehci_hcd sg sky2 backlight snd_page_alloc uhci_hcd joydev output ac thermal button battery sr_mod applesmc cdrom input_polldev evdev unix [last unloaded: scsi_wait_scan]
[38442.105007] irq event stamp: 2044208759
[38442.105007] hardirqs last  enabled at (2044208758): [<c1002ffc>] restore_all_notrace+0x0/0x18
[38442.105007] hardirqs last disabled at (2044208759): [<c10038f4>] apic_timer_interrupt+0x28/0x34
[38442.105007] softirqs last  enabled at (92950144): [<c103ab48>] __do_softirq+0x108/0x210
[38442.105007] softirqs last disabled at (92950274): [<c1348e74>] _spin_lock_bh+0x14/0x80
[38442.105007] 
[38442.105007] Pid: 2230, comm: phy0 Tainted: G        W  (2.6.31-rc7-wl #8) MacBook1,1
[38442.105007] EIP: 0060:[<f8ea2d50>] EFLAGS: 00010292 CPU: 0
[38442.105007] EIP is at cmp_ies+0x30/0x180 [cfg80211]
[38442.105007] EAX: 00000082 EBX: 00000000 ECX: ffffffc1 EDX: d8efd014
[38442.105007] ESI: ffffff7c EDI: 0000004d EBP: eee2dc50 ESP: eee2dc3c
[38442.105007]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[38442.105007] CR0: 8005003b CR2: d8efd014 CR3: 01694000 CR4: 000026d0
[38442.105007] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[38442.105007] DR6: ffff0ff0 DR7: 00000400
[38442.105007] Call Trace:
[38442.105007]  [<f8ea2f8d>] cmp_bss+0xed/0x100 [cfg80211]
[38442.105007]  [<f8ea33e4>] cfg80211_bss_update+0x84/0x410 [cfg80211]
[38442.105007]  [<f8ea3884>] cfg80211_inform_bss_frame+0x114/0x180 [cfg80211]
[38442.105007]  [<f97255ff>] ieee80211_bss_info_update+0x4f/0x180 [mac80211]
[38442.105007]  [<f972b118>] ieee80211_rx_bss_info+0x88/0xf0 [mac80211]
[38442.105007]  [<f9739297>] ? ieee802_11_parse_elems+0x27/0x30 [mac80211]
[38442.105007]  [<f972b224>] ieee80211_rx_mgmt_probe_resp+0xa4/0x1c0 [mac80211]
[38442.105007]  [<f972bc59>] ieee80211_sta_rx_queued_mgmt+0x919/0xc50 [mac80211]
[38442.105007]  [<c1009707>] ? sched_clock+0x27/0xa0
[38442.105007]  [<c1009707>] ? sched_clock+0x27/0xa0
[38442.105007]  [<c105ffd0>] ? mark_held_locks+0x60/0x80
[38442.105007]  [<c1348be5>] ? _spin_unlock_irqrestore+0x55/0x70
[38442.105007]  [<c134baa5>] ? sub_preempt_count+0x85/0xc0
[38442.105007]  [<c1348bce>] ? _spin_unlock_irqrestore+0x3e/0x70
[38442.105007]  [<c12c1c0f>] ? skb_dequeue+0x4f/0x70
[38442.105007]  [<f972c021>] ieee80211_sta_work+0x91/0xb80 [mac80211]
[38442.105007]  [<c1009707>] ? sched_clock+0x27/0xa0
[38442.105007]  [<c134baa5>] ? sub_preempt_count+0x85/0xc0
[38442.105007]  [<c10479af>] worker_thread+0x18f/0x320
[38442.105007]  [<c104794e>] ? worker_thread+0x12e/0x320
[38442.105007]  [<c1348be5>] ? _spin_unlock_irqrestore+0x55/0x70
[38442.105007]  [<f972bf90>] ? ieee80211_sta_work+0x0/0xb80 [mac80211]
[38442.105007]  [<c104cbb0>] ? autoremove_wake_function+0x0/0x50
[38442.105007]  [<c1047820>] ? worker_thread+0x0/0x320
[38442.105007]  [<c104c854>] kthread+0x84/0x90
[38442.105007]  [<c104c7d0>] ? kthread+0x0/0x90
[38442.105007]  [<c1003ab7>] kernel_thread_helper+0x7/0x10
[38507.604007] BUG: soft lockup - CPU#0 stuck for 61s! [phy0:2230]
[38507.604007] Modules linked in: aes_i586 aes_generic fuse af_packet ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state iptable_filter ip_tables x_tables acpi_cpufreq binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath dm_mod kvm_intel kvm uinput i915 arc4 ecb drm snd_hda_codec_idt ath5k snd_hda_intel hid_apple mac80211 usbhid appletouch snd_hda_codec snd_pcm ath cfg80211 snd_timer i2c_algo_bit ohci1394 video snd processor ieee1394 rfkill ehci_hcd sg sky2 backlight snd_page_alloc uhci_hcd joydev output ac thermal button battery sr_mod applesmc cdrom input_polldev evdev unix [last unloaded: scsi_wait_scan]
[38507.604007] irq event stamp: 2295973181
[38507.604007] hardirqs last  enabled at (2295973180): [<c1002ffc>] restore_all_notrace+0x0/0x18
[38507.604007] hardirqs last disabled at (2295973181): [<c10038f4>] apic_timer_interrupt+0x28/0x34
[38507.604007] softirqs last  enabled at (92950144): [<c103ab48>] __do_softirq+0x108/0x210
[38507.604007] softirqs last disabled at (92950274): [<c1348e74>] _spin_lock_bh+0x14/0x80
[38507.604007] 
[38507.604007] Pid: 2230, comm: phy0 Tainted: G        W  (2.6.31-rc7-wl #8) MacBook1,1
[38507.604007] EIP: 0060:[<f8ea2d50>] EFLAGS: 00010292 CPU: 0
[38507.604007] EIP is at cmp_ies+0x30/0x180 [cfg80211]
[38507.604007] EAX: 00000082 EBX: 00000000 ECX: ffffffc1 EDX: d8efd014
[38507.604007] ESI: ffffff7c EDI: 0000004d EBP: eee2dc50 ESP: eee2dc3c
[38507.604007]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[38507.604007] CR0: 8005003b CR2: d8efd014 CR3: 01694000 CR4: 000026d0
[38507.604007] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[38507.604007] DR6: ffff0ff0 DR7: 00000400
[38507.604007] Call Trace:
[38507.604007]  [<f8ea2f8d>] cmp_bss+0xed/0x100 [cfg80211]
[38507.604007]  [<f8ea33e4>] cfg80211_bss_update+0x84/0x410 [cfg80211]
[38507.604007]  [<f8ea3884>] cfg80211_inform_bss_frame+0x114/0x180 [cfg80211]
[38507.604007]  [<f97255ff>] ieee80211_bss_info_update+0x4f/0x180 [mac80211]
[38507.604007]  [<f972b118>] ieee80211_rx_bss_info+0x88/0xf0 [mac80211]
[38507.604007]  [<f9739297>] ? ieee802_11_parse_elems+0x27/0x30 [mac80211]
[38507.604007]  [<f972b224>] ieee80211_rx_mgmt_probe_resp+0xa4/0x1c0 [mac80211]
[38507.604007]  [<f972bc59>] ieee80211_sta_rx_queued_mgmt+0x919/0xc50 [mac80211]
[38507.604007]  [<c1009707>] ? sched_clock+0x27/0xa0
[38507.604007]  [<c1009707>] ? sched_clock+0x27/0xa0
[38507.604007]  [<c105ffd0>] ? mark_held_locks+0x60/0x80
[38507.604007]  [<c1348be5>] ? _spin_unlock_irqrestore+0x55/0x70
[38507.604007]  [<c134baa5>] ? sub_preempt_count+0x85/0xc0
[38507.604007]  [<c1348bce>] ? _spin_unlock_irqrestore+0x3e/0x70
[38507.604007]  [<c12c1c0f>] ? skb_dequeue+0x4f/0x70
[38507.604007]  [<f972c021>] ieee80211_sta_work+0x91/0xb80 [mac80211]
[38507.604007]  [<c1009707>] ? sched_clock+0x27/0xa0
[38507.604007]  [<c134baa5>] ? sub_preempt_count+0x85/0xc0
[38507.604007]  [<c10479af>] worker_thread+0x18f/0x320
[38507.604007]  [<c104794e>] ? worker_thread+0x12e/0x320
[38507.604007]  [<c1348be5>] ? _spin_unlock_irqrestore+0x55/0x70
[38507.604007]  [<f972bf90>] ? ieee80211_sta_work+0x0/0xb80 [mac80211]
[38507.604007]  [<c104cbb0>] ? autoremove_wake_function+0x0/0x50
[38507.604007]  [<c1047820>] ? worker_thread+0x0/0x320
[38507.604007]  [<c104c854>] kthread+0x84/0x90
[38507.604007]  [<c104c7d0>] ? kthread+0x0/0x90
[38507.604007]  [<c1003ab7>] kernel_thread_helper+0x7/0x10

-- 
Bob Copeland %% www.bobcopeland.com

