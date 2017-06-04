Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34327 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdFDNMe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Jun 2017 09:12:34 -0400
Received: by mail-lf0-f68.google.com with SMTP id f14so7730695lfe.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jun 2017 06:12:33 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: johannes@sipsolutions.net, johannes.berg@intel.com,
        kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 0/1] mac80211: removal of warning in RX path
Date: Sun,  4 Jun 2017 15:11:54 +0200
Message-Id: <1496581915-4412-1-git-send-email-erik.stromdahl@gmail.com> (sfid-20170604_151239_571820_930DA442)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is related to ath10k (usb and sdio patches) so I CC Kalle
and the ath10k mailing list as well.

The *WARN_ON_ONCE(softirq_count() == 0);* call in ieee80211_rx_napi is
causing a warning every time ath10k passes its first frame to mac80211
when running usb and sdio based devices.

It seems as if the softirq_count is simply not updated when the underlying
driver is usb or sdio based.

What is the purpose of this warning?

An odd thing is that the WARN_ macro behaves differently in Linux 4.12
when compared to previous versions (4.11 and older).

Below is an extract of the disassembly of ieee80211_rx_napi from Linux 4.12-rc2
The instructions prefixed with arrows (->) are extra important.

Dump of assembler code for function ieee80211_rx_napi:
   0xffffffffa002af00 <+0>:	nopl   0x0(%rax,%rax,1)
   0xffffffffa002af05 <+5>:	push   %rbp
   0xffffffffa002af06 <+6>:	mov    %rsp,%rbp
   0xffffffffa002af09 <+9>:	push   %r15
   0xffffffffa002af0b <+11>:	push   %r14
   0xffffffffa002af0d <+13>:	push   %r13
   0xffffffffa002af0f <+15>:	push   %r12
   0xffffffffa002af11 <+17>:	push   %rbx
   0xffffffffa002af12 <+18>:	mov    %rdx,%rbx
   0xffffffffa002af15 <+21>:	sub    $0xa8,%rsp
   0xffffffffa002af1c <+28>:	mov    %rsi,-0xb8(%rbp)
   0xffffffffa002af23 <+35>:	mov    %rcx,-0xa0(%rbp)
   0xffffffffa002af2a <+42>:	mov    %gs:0x28,%rax
   0xffffffffa002af33 <+51>:	mov    %rax,-0x30(%rbp)
   0xffffffffa002af37 <+55>:	xor    %eax,%eax
   0xffffffffa002af39 <+57>:	movzbl 0x4b(%rdx),%eax
   0xffffffffa002af3d <+61>:	cmp    $0x2,%al
   0xffffffffa002af3f <+63>:	ja     0xffffffffa002b485 <ieee80211_rx_napi+1413>
   0xffffffffa002af45 <+69>:	mov    0x38(%rdi),%rdx
   0xffffffffa002af49 <+73>:	mov    %rdi,%r15
   0xffffffffa002af4c <+76>:	mov    0xf8(%rdx,%rax,8),%rdx
   0xffffffffa002af54 <+84>:	test   %rdx,%rdx
-> 0xffffffffa002af57 <+87>:	je     0xffffffffa002b48c <ieee80211_rx_napi+1420>   <-- We take the jump here
   0xffffffffa002af5d <+93>:	mov    0x490(%rdi),%eax
   0xffffffffa002af63 <+99>:	and    $0xff00ff00,%eax
   0xffffffffa002af68 <+104>:	mov    %eax,-0xac(%rbp)
   0xffffffffa002af6e <+110>:	jne    0xffffffffa002afca <ieee80211_rx_napi+202>
   ...
   0xffffffffa002b478 <+1400>:	jmpq   0xffffffffa002b105 <ieee80211_rx_napi+517>
   0xffffffffa002b47d <+1405>:	mov    %r13,%r12
   0xffffffffa002b480 <+1408>:	jmpq   0xffffffffa002b246 <ieee80211_rx_napi+838>
   0xffffffffa002b485 <+1413>:	(bad)  
   0xffffffffa002b487 <+1415>:	jmpq   0xffffffffa002afca <ieee80211_rx_napi+202>
-> 0xffffffffa002b48c <+1420>:	(bad)  
   0xffffffffa002b48e <+1422>:	jmpq   0xffffffffa002afca <ieee80211_rx_napi+202>
   0xffffffffa002b493 <+1427>:	mov    -0xb8(%rbp),%rsi
   0xffffffffa002b49a <+1434>:	test   %rsi,%rsi
   0xffffffffa002b49d <+1437>:	mov    %rsi,%rax
   0xffffffffa002b4a0 <+1440>:	je     0xffffffffa002b825 <ieee80211_rx_napi+2341>


The jump at address 2af57 is taken and we end up executing an invalid op
at address 2b48c. I think this is the way the BUG_ macros are implemented
in the kernel, so I got very surprised when I realized that the WARN_ was
behaving in the same way.

In the previous (4.11) releases of the kernel, the WARN_ON macro does not
generate trap instructions as in the 4.12 case.

Below is the disassembly of ieee80211_rx_napi from Linux 4.11:

Dump of assembler code for function ieee80211_rx_napi:
   0xffffffffa002bfc0 <+0>:	nopl   0x0(%rax,%rax,1)
   0xffffffffa002bfc5 <+5>:	push   %rbp
   0xffffffffa002bfc6 <+6>:	mov    %rsp,%rbp
   0xffffffffa002bfc9 <+9>:	push   %r15
   0xffffffffa002bfcb <+11>:	push   %r14
   0xffffffffa002bfcd <+13>:	push   %r13
   0xffffffffa002bfcf <+15>:	push   %r12
   0xffffffffa002bfd1 <+17>:	mov    %rdi,%r15
   0xffffffffa002bfd4 <+20>:	push   %rbx
   0xffffffffa002bfd5 <+21>:	mov    %rdx,%rbx
   0xffffffffa002bfd8 <+24>:	sub    $0xa8,%rsp
   0xffffffffa002bfdf <+31>:	mov    %rsi,-0xb8(%rbp)
   0xffffffffa002bfe6 <+38>:	mov    %rcx,-0xa0(%rbp)
   0xffffffffa002bfed <+45>:	mov    %gs:0x28,%rax
   0xffffffffa002bff6 <+54>:	mov    %rax,-0x30(%rbp)
   0xffffffffa002bffa <+58>:	xor    %eax,%eax
   0xffffffffa002bffc <+60>:	mov    %gs:0x5ffe128d(%rip),%eax        # 0xd290 <__preempt_count>
   0xffffffffa002c003 <+67>:	test   $0xff,%ah
-> 0xffffffffa002c006 <+70>:	je     0xffffffffa002c588 <ieee80211_rx_napi+1480>    <- We take the jump here
   0xffffffffa002c00c <+76>:	movzbl 0x4b(%rbx),%eax
   0xffffffffa002c010 <+80>:	cmp    $0x2,%al
   0xffffffffa002c012 <+82>:	ja     0xffffffffa002c5b2 <ieee80211_rx_napi+1522>
   ...
   0xffffffffa002c57b <+1467>:	jmpq   0xffffffffa002c1fa <ieee80211_rx_napi+570>
   0xffffffffa002c580 <+1472>:	mov    %r13,%r15
   0xffffffffa002c583 <+1475>:	jmpq   0xffffffffa002c33d <ieee80211_rx_napi+893>
-> 0xffffffffa002c588 <+1480>:	cmpb   $0x0,0x66740(%rip)        # 0xffffffffa0092ccf
   0xffffffffa002c58f <+1487>:	jne    0xffffffffa002c00c <ieee80211_rx_napi+76>
   0xffffffffa002c595 <+1493>:	mov    $0x109d,%esi
   0xffffffffa002c59a <+1498>:	mov    $0xffffffffa0081a66,%rdi
   0xffffffffa002c5a1 <+1505>:	movb   $0x1,0x66727(%rip)        # 0xffffffffa0092ccf
-> 0xffffffffa002c5a8 <+1512>:	callq  0xffffffff810a0220 <warn_slowpath_null>
   0xffffffffa002c5ad <+1517>:	jmpq   0xffffffffa002c00c <ieee80211_rx_napi+76>

In this case there is just a jump to a function call (warn_slowpath_null)
that handles the warning (just as I would suspect).

No comes the real problem:
When building mac80211 as a module, the system does not seem to handle
the trap properly and I get the below error message (instead of the
expected warning that this patch addresses):

[   58.423370] BUG: unable to handle kernel paging request at ffffffffa00818ee   
[   58.426085] IP: report_bug+0x94/0x120                                         
[   58.427343] PGD 1c0c067                                                       
[   58.427345] P4D 1c0c067                                                       
[   58.428256] PUD 1c0d063                                                       
[   58.428727] PMD 3dd3f067                                                      
[   58.429019] PTE 800000003dd18161                                              
[   58.429288]                                                                   
[   58.429765] Oops: 0003 [#1] PREEMPT SMP                                       
[   58.430158] Modules linked in: ehci_pci ehci_hcd i8042 serio ath10k_usb ath10k_core ath mac80211                                                               
[   58.431093] CPU: 0 PID: 16 Comm: kworker/0:1 Not tainted 4.12.0-rc2-wt-ath-ARCH-QEMU+ #4                                                                       
[   58.431921] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-20170228_101828-anatol 04/01/2014                                               
[   58.432957] Workqueue: events ath10k_usb_io_comp_work [ath10k_usb]            
[   58.433582] task: ffff880039b2ce00 task.stack: ffffc90000210000               
[   58.434135] RIP: 0010:report_bug+0x94/0x120                                   
[   58.434510] RSP: 0018:ffffc90000213a68 EFLAGS: 00010202                       
[   58.434979] RAX: 0000000000000907 RBX: ffffc90000213bb8 RCX: ffffffffa00818e4 
[   58.435614] RDX: 0000000000000001 RSI: 000000000000109e RDI: 0000000000000001 
[   58.436255] RBP: ffffc90000213a88 R08: ffffc90000214000 R09: 0000000000000030
[   58.436913] R10: ffffffff81c06a80 R11: 0000000000000080 R12: ffffffffa002b498
[   58.437544] R13: ffffffffa007eab6 R14: 0000000000000006 R15: 0000000000000004
[   58.438176] FS:  0000000000000000(0000) GS:ffff88003b400000(0000) knlGS:000000000000000
[   58.438910] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   58.439431] CR2: ffffffffa00818ee CR3: 000000003e272000 CR4: 00000000000006f0
[   58.440239] Call Trace:
[   58.440524]  do_trap+0x16c/0x190
[   58.440884]  do_error_trap+0x89/0x110
[   58.441301]  ? ieee80211_rx_napi+0x598/0xa30 [mac80211]
[   58.441872]  ? __update_load_avg_se.isra.5+0x15b/0x180
[   58.442448]  ? __enqueue_entity+0x6c/0x70
[   58.442902]  ? enqueue_entity+0x401/0xb40
[   58.443347]  do_invalid_op+0x20/0x30
[   58.443755]  invalid_op+0x1e/0x30
[   58.444139] RIP: 0010:ieee80211_rx_napi+0x598/0xa30 [mac80211]
[   58.444794] RSP: 0018:ffffc90000213c68 EFLAGS: 00010346
[   58.445383] RAX: 0000000080000000 RBX: ffff88003ddd3300 RCX: 0000000000000000
[   58.446172] RDX: ffff88003ddd3300 RSI: 0000000000000000 RDI: ffff8800393c0780
[   58.446993] RBP: ffffc90000213d38 R08: 0000000000000000 R09: 00000000fffffff0
[   58.447777] R10: ffffea0000f76e00 R11: 0000000000000080 R12: 0000000000000000
[   58.448566] R13: ffff8800393c1560 R14: 0000000000000080 R15: ffff8800393c0780
[   58.449361]  ? __slab_free+0x2a5/0x410
[   58.449782]  ? ieee80211_rx_napi+0xf/0xa30 [mac80211]
[   58.450345]  ath10k_wmi_event_mgmt_rx+0x233/0x430 [ath10k_core]
[   58.450994]  ath10k_wmi_tlv_op_rx+0x2fb/0x7b0 [ath10k_core]
[   58.451608]  ath10k_wmi_process_rx+0x1a/0x40 [ath10k_core]
[   58.452208]  ath10k_usb_io_comp_work+0x13e/0x1a0 [ath10k_usb]
[   58.452839]  ? __schedule+0x2e3/0x840
[   58.453241]  process_one_work+0x1e0/0x420
[   58.453708]  worker_thread+0x48/0x3f0
[   58.454142]  kthread+0x109/0x140
[   58.454393]  ? process_one_work+0x420/0x420
[   58.454882]  ? kthread_create_on_node+0x70/0x70
[   58.455388]  ret_from_fork+0x2c/0x40
[   58.455792] Code: 74 59 0f b7 41 0a 4c 63 69 04 0f b7 71 08 89 c7 49 01 cd 83
e7 01 a8 02 74 15 66 85 ff 74 10 a8 04 ba 01 00 00 00 75 26 83 c8 04 <66> 89 41 0
a 66 85 ff 74 49 0f b6 49 0b 4c 89 e2 45 31 c9 49 89
[   58.457842] RIP: report_bug+0x94/0x120 RSP: ffffc90000213a68
[   58.458458] CR2: ffffffffa00818ee
[   58.458826] ---[ end trace 1d0941df07be82c5 ]---

When mac80211 is built into the kernel everything is working as expected!

I understand that this is really not an issue with mac80211, but perhaps
you have experienced similar issues before.

Perhaps it is a kernel config issue?
I have used the default ARCH config (as I have always done), and it has
never before caused any problems.

Any ideas are welcome...

Erik Stromdahl (1):
  mac80211: ieee80211_rx_napi: remove warning

 net/mac80211/rx.c | 2 --
 1 file changed, 2 deletions(-)

-- 
2.13.0
