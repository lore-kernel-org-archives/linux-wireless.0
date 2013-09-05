Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1072 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab3IEMc2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 08:32:28 -0400
Message-ID: <522879D0.2030107@broadcom.com> (sfid-20130905_143232_868594_2BDCDC33)
Date: Thu, 5 Sep 2013 14:32:16 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: bcma problem on x86_64
Content-Type: multipart/mixed;
 boundary=------------040500090407030103000402
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--------------040500090407030103000402
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 8bit

Hi Rafał,

Since 3.11-rc4 I am seeing a problem with bcma on x64 (see attached 
log). I thought I misconfigured my setup, but just upgraded to 3.11 and 
I am still seeing the same issue. Did you have any reports like this?

I will double check my setup.

Regards,
Arend

--------------040500090407030103000402
Content-Type: text/plain;
 name=bcma-rcu-stall.log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=bcma-rcu-stall.log

Sep  4 20:19:13 lb-bun-21 kernel: [17177.377932] bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and package 0x0A
Sep  4 20:20:13 lb-bun-21 kernel: [17237.438967] INFO: rcu_sched self-detected stall on CPU { 0}  (t=15000 jiffies g=7908 c=7907 q=37423)
Sep  4 20:20:13 lb-bun-21 kernel: [17237.438979] sending NMI to all CPUs:
Sep  4 20:20:13 lb-bun-21 kernel: [17237.438986] NMI backtrace for cpu 0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.438994] CPU: 0 PID: 6340 Comm: insmod Tainted: G           O 3.11.0-rc5-wl-testing-x64-00002-g079f98c-dirty #1
Sep  4 20:20:13 lb-bun-21 kernel: [17237.438997] Hardware name: Dell Inc. Latitude E6410/07XJP9, BIOS A07 02/15/2011
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439002] task: ffff880123b18000 ti: ffff880125006000 task.ti: ffff880125006000
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439006] RIP: 0010:[<ffffffff812f4152>]  [<ffffffff812f4152>] __const_udelay+0x22/0x30
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439019] RSP: 0018:ffff88012bc03d88  EFLAGS: 00000807
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439023] RAX: 0000000041ca2400 RBX: 0000000000002710 RCX: 000000000154f0a0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439027] RDX: 00000000002a46e1 RSI: 0000000000000007 RDI: 0000000000418958
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439031] RBP: ffff88012bc03d88 R08: 000000000000000a R09: 0000000000000000
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439034] R10: 0000000000000329 R11: 0000000000000328 R12: ffffffff81a389c0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439038] R13: ffffffff81a389c0 R14: 0000000000000000 R15: ffffffff81aab808
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439042] FS:  00007fd6a460c700(0000) GS:ffff88012bc00000(0000) knlGS:0000000000000000
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439046] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439050] CR2: 00007fd6a41383d0 CR3: 00000001262aa000 CR4: 00000000000007f0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439053] Stack:
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439056]  ffff88012bc03da8 ffffffff8102f85a 000000000000922f ffff88012bc0db80
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439063]  ffff88012bc03e18 ffffffff810dc99a ffff88012bc03dc8 ffffffff810e044c
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439068]  0000000000000092 0000000000000000 0000000000000000 ffff880125006000
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439074] Call Trace:
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439077]  <IRQ> 
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439081]  [<ffffffff8102f85a>] arch_trigger_all_cpu_backtrace+0x6a/0x90
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439098]  [<ffffffff810dc99a>] rcu_check_callbacks+0x21a/0x660
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439106]  [<ffffffff810e044c>] ? acct_account_cputime+0x1c/0x20
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439113]  [<ffffffff81053ee8>] update_process_times+0x48/0x80
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439122]  [<ffffffff8109f2f6>] tick_sched_handle.isra.10+0x36/0x50
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439128]  [<ffffffff8109f3fc>] tick_sched_timer+0x4c/0x80
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439136]  [<ffffffff8106b01d>] __run_hrtimer+0x7d/0x220
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439142]  [<ffffffff8109f3b0>] ? tick_nohz_handler+0xa0/0xa0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439148]  [<ffffffff8106b90f>] hrtimer_interrupt+0xff/0x240
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439155]  [<ffffffff8102dd0b>] local_apic_timer_interrupt+0x3b/0x60
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439166]  [<ffffffff815973e5>] smp_apic_timer_interrupt+0x45/0x60
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439172]  [<ffffffff815961ca>] apic_timer_interrupt+0x6a/0x70
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439175]  <EOI> 
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439179]  [<ffffffffa008ab0f>] ? bcma_erom_get_addr_desc.isra.7+0xf/0x90 [bcma]
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439200]  [<ffffffffa008ae3c>] bcma_get_next_core+0x2ac/0x370 [bcma]
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439210]  [<ffffffffa008b05b>] bcma_bus_scan+0xbb/0x310 [bcma]
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439221]  [<ffffffffa008a40c>] bcma_bus_register+0x4c/0x4b0 [bcma]
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439232]  [<ffffffffa008e8d4>] bcma_host_pci_probe+0x134/0x1d0 [bcma]
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439240]  [<ffffffff813153f9>] pci_device_probe+0x99/0xe0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439249]  [<ffffffff813bfb2b>] driver_probe_device+0x7b/0x240
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439255]  [<ffffffff813bfd9b>] __driver_attach+0xab/0xb0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439262]  [<ffffffff813bfcf0>] ? driver_probe_device+0x240/0x240
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439268]  [<ffffffff813bde5e>] bus_for_each_dev+0x5e/0x90
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439274]  [<ffffffff813bf62e>] driver_attach+0x1e/0x20
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439280]  [<ffffffff813bf124>] bus_add_driver+0x104/0x270
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439286]  [<ffffffff813c02dd>] driver_register+0x7d/0x160
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439293]  [<ffffffff8131441b>] __pci_register_driver+0x4b/0x50
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439302]  [<ffffffffa00a83e6>] bcma_host_pci_init+0x1e/0x20 [bcma]
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439311]  [<ffffffffa00a8185>] bcma_modinit+0x1d/0x35 [bcma]
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439320]  [<ffffffffa00a8168>] ? bcma_bus_early_register+0x168/0x168 [bcma]
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439328]  [<ffffffff8100024e>] do_one_initcall+0x4e/0x170
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439336]  [<ffffffff8106d393>] ? __blocking_notifier_call_chain+0x63/0x80
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439344]  [<ffffffff810aaae8>] load_module+0x1308/0x1a50
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439350]  [<ffffffff810a7d40>] ? show_initstate+0x50/0x50
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439357]  [<ffffffff811464af>] ? alloc_vmap_area.isra.19+0x25f/0x310
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439365]  [<ffffffff810ab2dc>] SyS_init_module+0xac/0xd0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439372]  [<ffffffff81595602>] system_call_fastpath+0x16/0x1b
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439375] Code: 2e 0f 1f 84 00 00 00 00 00 55 48 8d 04 bd 00 00 00 00 65 48 8b 14 25 a0 25 01 00 48 8d 0c 12 48 c1 e2 06 48 89 e5 48 29 ca f7 e2 <48> 8d 7a 01 ff 15 7c 60 77 00 5d c3 66 90 66 66 66 66 90 55 65 
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439434] NMI backtrace for cpu 2
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439442] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G           O 3.11.0-rc5-wl-testing-x64-00002-g079f98c-dirty #1
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439446] Hardware name: Dell Inc. Latitude E6410/07XJP9, BIOS A07 02/15/2011
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439449] task: ffff880127138000 ti: ffff880127132000 task.ti: ffff880127132000
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439453] RIP: 0010:[<ffffffff81342e27>]  [<ffffffff81342e27>] intel_idle+0xa7/0x100
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439463] RSP: 0018:ffff880127133db8  EFLAGS: 00000046
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439466] RAX: 0000000000000020 RBX: 0000000000000008 RCX: 0000000000000001
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439470] RDX: 0000000000000000 RSI: ffff880127133fd8 RDI: 0000000000000002
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439473] RBP: ffff880127133de8 R08: 0000000000000009 R09: 0000000000000019
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439476] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000004
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439480] R13: 0000000000000020 R14: 0000000000000003 R15: 0000000000000004
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439484] FS:  0000000000000000(0000) GS:ffff88012bc80000(0000) knlGS:0000000000000000
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439488] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439491] CR2: 0000000000be46f0 CR3: 0000000001a0b000 CR4: 00000000000007e0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439494] Stack:
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439496]  ffff880127133de8 00000002810967e4 ffff88012bc99800 00000fa97738ebfe
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439502]  ffffffff81a6cbb8 ffffffff81a6ca40 ffff880127133e48 ffffffff8147749f
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439508]  0000000000000000 0000000000f2b044 0000000000000000 0000000000f2b044
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439513] Call Trace:
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439523]  [<ffffffff8147749f>] cpuidle_enter_state+0x4f/0xe0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439529]  [<ffffffff814775fe>] cpuidle_idle_call+0xce/0x230
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439538]  [<ffffffff8100b1de>] arch_cpu_idle+0xe/0x30
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439545]  [<ffffffff81094ede>] cpu_startup_entry+0xce/0x290
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439552]  [<ffffffff8102c57d>] start_secondary+0x1cd/0x230
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439555] Code: 28 e0 ff ff 83 e2 08 75 22 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d ab 9f 72 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 93 a4 d5 
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439612] NMI backtrace for cpu 1
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439621] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G           O 3.11.0-rc5-wl-testing-x64-00002-g079f98c-dirty #1
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439625] Hardware name: Dell Inc. Latitude E6410/07XJP9, BIOS A07 02/15/2011
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439638] task: ffff880127105b40 ti: ffff880127130000 task.ti: ffff880127130000
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439649] RIP: 0010:[<ffffffff81342e27>]  [<ffffffff81342e27>] intel_idle+0xa7/0x100
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439674] RSP: 0018:ffff880127131db8  EFLAGS: 00000046
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439687] RAX: 0000000000000020 RBX: 0000000000000008 RCX: 0000000000000001
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439697] RDX: 0000000000000000 RSI: ffff880127131fd8 RDI: 0000000000000001
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439710] RBP: ffff880127131de8 R08: 0000000000000019 R09: 00000000000000c4
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439721] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000004
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439733] R13: 0000000000000020 R14: 0000000000000003 R15: 0000000000000004
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439746] FS:  0000000000000000(0000) GS:ffff88012bc40000(0000) knlGS:0000000000000000
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439759] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439771] CR2: 00007f5ec7d9b000 CR3: 0000000001a0b000 CR4: 00000000000007e0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439780] Stack:
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439787]  ffff880127131de8 00000001810967e4 ffff88012bc59800 00000fa97738f6ca
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439793]  ffffffff81a6cbb8 ffffffff81a6ca40 ffff880127131e48 ffffffff8147749f
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439799]  0000000000000000 0000000000f29705 0000000000000000 0000000000f29705
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439805] Call Trace:
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439814]  [<ffffffff8147749f>] cpuidle_enter_state+0x4f/0xe0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439822]  [<ffffffff814775fe>] cpuidle_idle_call+0xce/0x230
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439829]  [<ffffffff8100b1de>] arch_cpu_idle+0xe/0x30
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439836]  [<ffffffff81094ede>] cpu_startup_entry+0xce/0x290
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439843]  [<ffffffff8102c57d>] start_secondary+0x1cd/0x230
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439847] Code: 28 e0 ff ff 83 e2 08 75 22 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d ab 9f 72 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 93 a4 d5 
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439905] NMI backtrace for cpu 3
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439913] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G           O 3.11.0-rc5-wl-testing-x64-00002-g079f98c-dirty #1
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439915] Hardware name: Dell Inc. Latitude E6410/07XJP9, BIOS A07 02/15/2011
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439918] task: ffff8801271396d0 ti: ffff880127134000 task.ti: ffff880127134000
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439921] RIP: 0010:[<ffffffff81342e27>]  [<ffffffff81342e27>] intel_idle+0xa7/0x100
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439927] RSP: 0018:ffff880127135db8  EFLAGS: 00000046
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439930] RAX: 0000000000000020 RBX: 0000000000000008 RCX: 0000000000000001
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439932] RDX: 0000000000000000 RSI: ffff880127135fd8 RDI: 0000000000000003
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439935] RBP: ffff880127135de8 R08: 0000000000000e79 R09: 00000000001a62c9
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439937] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000004
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439939] R13: 0000000000000020 R14: 0000000000000003 R15: 0000000000000004
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439942] FS:  0000000000000000(0000) GS:ffff88012bcc0000(0000) knlGS:0000000000000000
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439945] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439948] CR2: 0000000000bff54e CR3: 0000000001a0b000 CR4: 00000000000007e0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439950] Stack:
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439952]  ffff880127135de8 00000003810967e4 ffff88012bcd9800 00000fa97738df12
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439956]  ffffffff81a6cbb8 ffffffff81a6ca40 ffff880127135e48 ffffffff8147749f
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439960]  0000000000000000 00000000003b7c0c 0000000000000000 00000000003b7c0c
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439964] Call Trace:
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439970]  [<ffffffff8147749f>] cpuidle_enter_state+0x4f/0xe0
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439975]  [<ffffffff814775fe>] cpuidle_idle_call+0xce/0x230
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439980]  [<ffffffff8100b1de>] arch_cpu_idle+0xe/0x30
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439984]  [<ffffffff81094ede>] cpu_startup_entry+0xce/0x290
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439989]  [<ffffffff8102c57d>] start_secondary+0x1cd/0x230
Sep  4 20:20:13 lb-bun-21 kernel: [17237.439992] Code: 28 e0 ff ff 83 e2 08 75 22 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d ab 9f 72 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 93 a4 d5 


--------------040500090407030103000402--

