Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4444 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab2CMMwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 08:52:30 -0400
Received: from mail-sj1-12.sj.broadcom.com (mail-sj1-12.sj.broadcom.com
 [10.17.16.106]) by mail-irva-13.broadcom.com (Postfix) with ESMTP id
 5D7C7BC394 for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2012
 05:52:18 -0700 (PDT)
Received: from [10.0.2.15] (unknown [10.176.68.152]) by
 mail-sj1-12.sj.broadcom.com (Postfix) with ESMTP id A84DD207C0 for
 <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2012 05:52:17 -0700 (PDT)
Message-ID: <4F5F4300.6090103@broadcom.com> (sfid-20120313_135234_397539_8DF6367C)
Date: Tue, 13 Mar 2012 13:52:16 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: oops upon driver unload
Content-Type: multipart/mixed;
 boundary=------------010702080601090908030402
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--------------010702080601090908030402
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit

During testing I got an OOPS with the brcmsmac (see attachment). I 
suspect mac80211 is using a driver callback after the module is removed 
(could be wrong here). The connection with the AP is dropped, and after 
1 sec. the driver is unloaded using rmmod, which causes the driver to 
unregister from mac80211.

Any clues?

Gr. AvS


--------------010702080601090908030402
Content-Type: text/plain;
 name=oops-upon-disconnect.log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=oops-upon-disconnect.log

Mar 12 02:51:17 lb-bun-09 kernel: [575810.085726] ieee80211 phy0: FIF_BCN_PRBRES
P_PROMISC
Mar 12 02:52:34 lb-bun-09 kernel: [575886.855388] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
Mar 12 02:52:34 lb-bun-09 kernel: [575886.855933] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
Mar 12 02:52:34 lb-bun-09 kernel: [575886.855943] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
Mar 12 02:52:34 lb-bun-09 kernel: [575886.855951] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
Mar 12 02:52:34 lb-bun-09 kernel: [575886.855957] wlan3: deauthenticating from 98:fc:11:8e:94:58 by local choice (reason=3)
Mar 12 02:52:34 lb-bun-09 kernel: [575886.880401] cfg80211: All devices are disconnected, going to restore regulatory settings
Mar 12 02:52:34 lb-bun-09 kernel: [575886.880408] cfg80211: Restoring regulatory settings
Mar 12 02:52:34 lb-bun-09 kernel: [575886.880414] cfg80211: Calling CRDA to update world regulatory domain
Mar 12 02:52:34 lb-bun-09 kernel: [575886.887653] cfg80211: World regulatory domain updated:
Mar 12 02:52:34 lb-bun-09 kernel: [575886.909709] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
Mar 12 02:52:35 lb-bun-09 kernel: [575888.181322] cfg80211: Found new beacon on frequency: 5240 MHz (Ch 48) on phy0
Mar 12 02:52:35 lb-bun-09 kernel: [575888.297978] cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on phy0
Mar 12 02:52:35 lb-bun-09 kernel: [575888.443474] cfg80211: Found new beacon on frequency: 5765 MHz (Ch 153) on phy0
Mar 12 02:52:36 lb-bun-09 kernel: [575888.905711] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
Mar 12 02:52:36 lb-bun-09 kernel: [575888.906010] wlan3: authenticate with 98:fc:11:8e:94:58
Mar 12 02:52:36 lb-bun-09 kernel: [575888.906057] wlan3: send auth to 98:fc:11:8e:94:58 (try 1/3)
Mar 12 02:52:36 lb-bun-09 kernel: [575888.906546] wlan3: authenticated
Mar 12 02:52:36 lb-bun-09 kernel: [575888.907688] wlan3: deauthenticating from 98:fc:11:8e:94:58 by local choice (reason=3)
Mar 12 02:52:36 lb-bun-09 kernel: [575888.909725] wlan3: associate with 98:fc:11:8e:94:58 (try 1/3)
Mar 12 02:52:36 lb-bun-09 kernel: [575889.108021] BUG: unable to handle kernel paging request at fb35e280
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] IP: [<fb35e280>] 0xfb35e27f
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] *pde = 2e77f067 *pte = 00000000 
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] Oops: 0000 [#1] SMP 
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] Modules linked in: aes_generic
 arc4 binfmt_misc psmouse snd_hda_codec_realtek snd_hda_intel snd_hda_codec serio_raw snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc usbhid hid i915 drm_kms_helper drm i2c_algo_bit floppy intel_agp r8169 intel_gtt mii video agpgart [last unloaded: bcma]
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] 
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] Pid: 0, comm: swapper/0 Tainted: G        W  O 3.3.0-rc3-wl-testing-00002-g0e65d9a #1                  /DG41TY
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] EIP: 0060:[<fb35e280>] EFLAGS: 00010246 CPU: 0
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] EIP is at 0xfb35e280
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] EAX: d7e61460 EBX: 000000bd ECX: 00000000 EDX: f540dfa0
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] ESI: c17b4000 EDI: d7e61784 EBP: f540dfb4 ESP: f540df64
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] Process swapper/0 (pid: 0, ti=f540c000 task=c16a1de0 task.ti=c169c000)
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] Stack:
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  c103f0ea c1066109 00000000 f540df88 f5806e60 00000000 00000000 f540dfa0
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  c17b4e10 c17b4c10 c17b4a10 d7e61460 fb35e280 c17b4810 00000100 f540dfa0
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  f540dfa0 c169df10 00000004 00000141 f540dff8 c1037b9e f0f0f0f4 f0f0f0f0
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] Call Trace:
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c103f0ea>] ? run_timer_softirq+0x11a/0x2d0
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c1066109>] ? rebalance_domains+0x89/0x150
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c1037b9e>] __do_softirq+0x9e/0x1b0
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c1037b00>] ? irq_enter+0x70/0x70
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  <IRQ> 
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c10379dd>] ? irq_exit+0x9d/0xc0
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c14b8869>] ? smp_apic_timer_interrupt+0x59/0x88
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c105da4e>] ? scheduler_ipi+0x4e/0xe0
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c14b1e05>] ? apic_timer_interrupt+0x31/0x38
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c10700d8>] ? count_free_highmem_pages+0x28/0x70
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c1009dc8>] ? mwait_idle+0x88/0x180
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c1001d8e>] ? cpu_idle+0xae/0xf0
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c149cabd>] ? rest_init+0x5d/0x70
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c16f5853>] ? start_kernel+0x38a/0x390
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c16f52f3>] ? kernel_init+0x145/0x145
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c16f5075>] ? i386_start_kernel+0x75/0x79
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] Code:  Bad EIP value.
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] EIP: [<fb35e280>] 0xfb35e280 SS:ESP 0068:f540df64
Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] CR2: 00000000fb35e280
Mar 12 02:55:00 lb-bun-09 kernel: [576032.619994] INFO: rcu_sched detected stall on CPU 0 (t=15000 jiffies)


--------------010702080601090908030402--

