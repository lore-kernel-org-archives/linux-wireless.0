Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:42929 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933003AbeGIUvT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 16:51:19 -0400
Received: by mail-pl0-f65.google.com with SMTP id f4-v6so2369975plb.9
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2018 13:51:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0000000000000cc1f0057096efe6@google.com>
References: <0000000000000cc1f0057096efe6@google.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 9 Jul 2018 22:50:57 +0200
Message-ID: <CACT4Y+Zc+UKpGwEEMfKOsZ1s+AAFYFrVmjO0-u7NNjODRiJ7tg@mail.gmail.com> (sfid-20180709_225139_580541_5371A92A)
Subject: Re: INFO: rcu detected stall in llcp_sock_sendmsg
To: syzbot <syzbot+e9f364d3b15ce41d8451@syzkaller.appspotmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 9, 2018 at 10:34 PM, syzbot
<syzbot+e9f364d3b15ce41d8451@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    1e4b044d2251 Linux 4.18-rc4
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1414c2c2400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=25856fac4e580aa7
> dashboard link: https://syzkaller.appspot.com/bug?extid=e9f364d3b15ce41d8451
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+e9f364d3b15ce41d8451@syzkaller.appspotmail.com

Looks like the problem is actually in nfc, so +nfc maintainers.


> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> INFO: rcu_sched self-detected stall on CPU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>         1-...!: (1 GPs behind) idle=9aa/1/4611686018427387906
> softirq=167235/167236 fqs=107
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>
>  (t=105001 jiffies g=87150 c=87149 q=684)
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> rcu_sched kthread starved for 104291 jiffies! g87150 c87149 f0x0
> RCU_GP_WAIT_FQS(3) ->state=0x0 ->cpu=0
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> RCU grace-period kthread stack dump:
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> rcu_sched       R
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>   running task
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 23392    10      2 0x80000000
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  context_switch kernel/sched/core.c:2853 [inline]
>  __schedule+0x87c/0x1ed0 kernel/sched/core.c:3501
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  schedule+0xfb/0x450 kernel/sched/core.c:3545
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  schedule_timeout+0x140/0x260 kernel/time/timer.c:1801
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  rcu_gp_kthread+0x717/0x1c90 kernel/rcu/tree.c:2179
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  kthread+0x345/0x410 kernel/kthread.c:246
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> CPU: 1 PID: 32171 Comm: syz-executor7 Not tainted 4.18.0-rc4+ #138
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  nmi_cpu_backtrace.cold.4+0x19/0xce lib/nmi_backtrace.c:103
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  nmi_trigger_cpumask_backtrace+0x151/0x192 lib/nmi_backtrace.c:62
>  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  trigger_single_cpu_backtrace include/linux/nmi.h:156 [inline]
>  rcu_dump_cpu_stacks+0x175/0x1c2 kernel/rcu/tree.c:1336
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  tick_sched_handle+0x9f/0x180 kernel/time/tick-sched.c:164
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  hrtimer_interrupt+0x2f3/0x750 kernel/time/hrtimer.c:1518
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1025 [inline]
>  smp_apic_timer_interrupt+0x165/0x730 arch/x86/kernel/apic/apic.c:1050
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:863
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  </IRQ>
> RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:783
> [inline]
> RIP: 0010:console_trylock_spinning kernel/printk/printk.c:1678 [inline]
> RIP: 0010:vprintk_emit+0xbe9/0xdf0 kernel/printk/printk.c:1906
> Code:
> fc
> ff
> df
> 41
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 80
> 3c
> 00
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 0f
> 85
> d4
> 01
> 00 48 83 3d b3 c1
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 8e
> 07
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 0f
> fe
> 00
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 00
> 00
> e8
> e0
> 19
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 00
> 8b
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> a8
> fe
> ff
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> ff
> 57
> 9d
> <0f>
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 1f
> 00
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 00
> e9
> 18
> fe
> ff
> 41
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 80
> 0f
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 84
> eb
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> ff
> e9
> ef
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> RSP: 0018:ffff880199fbf4d0 EFLAGS: 00000246
>  ORIG_RAX: ffffffffffffff13
> RAX: 0000000000040000 RBX: 0000000000000200 RCX: ffffc90002628000
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> RDX: 0000000000040000 RSI: ffffffff8162eec0 RDI: 0000000000000246
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> RBP: ffff880199fbf660 R08: ffff8801c9b64400 R09: 0000000000000000
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> R10: 0000000000000000 R11: 0000000000000000 R12: 1ffffffff11e360d
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> R13: 0000000000000034 R14: ffffed00333f7eb7 R15: ffffffff8aa0c4a0
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  llcp_sock_sendmsg+0x278/0x350 net/nfc/llcp_sock.c:789
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  sock_sendmsg_nosec net/socket.c:641 [inline]
>  sock_sendmsg+0xd5/0x120 net/socket.c:651
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  ___sys_sendmsg+0x51d/0x930 net/socket.c:2125
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  __sys_sendmmsg+0x240/0x6f0 net/socket.c:2220
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  __do_sys_sendmmsg net/socket.c:2249 [inline]
>  __se_sys_sendmmsg net/socket.c:2246 [inline]
>  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2246
>  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> Code:
> 1d
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> fb
> ff
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 66
> 2e
> 0f
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 1f
> 84
> 00
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 00
> 00
> 00
> 66
> 48
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 89
> f8
> 48
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 89
> f7
> 89
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 48
> 89
> ca
> 4d
> 89
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> c2
> 4d
> c8
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 4c
> 8b
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 24
> 0f
> 05
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> <48>
> 01
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> f0
> ff
> ff
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 83
> eb
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> fb
> c3
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 2e
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 1f
> 84
> 00
> 00
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> 00
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> RSP: 002b:00007f012a991c68 EFLAGS: 00000246
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
>  ORIG_RAX: 0000000000000133
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> RAX: ffffffffffffffda RBX: 00007f012a9926d4 RCX: 0000000000455e29
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> RBP: 000000000072bea0 R08: 0000000000000000 R09: 0000000000000000
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> R10: 0000000000008040 R11: 0000000000000246 R12: 00000000ffffffff
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> R13: 00000000004c1145 R14: 00000000004d15a0 R15: 0000000000000000
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> llcp: nfc_llcp_send_ui_frame: Could not allocate PD
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit
> https://groups.google.com/d/msgid/syzkaller-bugs/0000000000000cc1f0057096efe6%40google.com.
> For more options, visit https://groups.google.com/d/optout.
