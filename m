Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:43539 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755796AbdKGLB0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Nov 2017 06:01:26 -0500
Message-ID: <1510052483.24015.1.camel@gmail.com> (sfid-20171107_120451_397756_C87D90F4)
Subject: Re: Soft lockup in rt2x00usb_work_rxdone()
From: Richard Genoud <richard.genoud@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Date: Tue, 07 Nov 2017 12:01:23 +0100
In-Reply-To: <20171107101320.GA12140@redhat.com>
References: <1509983829.10974.2.camel@gmail.com>
         <20171107085327.GA11380@redhat.com>
         <CACQ1gAi6XtjCHPji3BP71jDG7srg+BshesviasXiSqnw2zs9_Q@mail.gmail.com>
         <20171107101320.GA12140@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le mardi 07 novembre 2017 à 11:13 +0100, Stanislaw Gruszka a écrit :
> On Tue, Nov 07, 2017 at 11:06:39AM +0100, Richard Genoud wrote:
> > > 3 short articles how to configure and use ftrace are here:
> > > https://lwn.net/Articles/365835/
> > > https://lwn.net/Articles/366796/
> > > https://lwn.net/Articles/370423/
> > > 
> > 
> > I tried with ftrace, but I don't think there's a way to dump the
> > trace
> > when there's a soft lock-up
> > (I can't do anything after the unbind, even the heartbeat led
> > stopped blinking).
> > I saw the /proc/sys/kernel/ftrace_dump_on_oops file, but there's no
> > /proc/sys/kernel/ftrace_dump_on_soft_lock-up file :)
> 
> You should configure function trace with rt2x* functions. After that
> start tracing, unbind the device, then stop tracing and provide trace
> output.
Ok, I found a way to display the trace (after the unbind, the board is
frozen and I can't type anything).
Adding
CONFIG_SOFTLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
along with echo 1 > /proc/sys/kernel/ftrace_dump_on_oops does the trick

(trace is after the stack dump)

# cd /sys/kernel/debug/tracing/
# echo 1 > /proc/sys/kernel/ftrace_dump_on_oops
# 
# echo rt2x00usb* > set_ftrace_filter
# echo 0 > tracing_on
# echo function > current_tracer
# echo 1 > tracing_on
# echo 1-2.2 > /sys/bus/usb/drivers/usb/unbind
[board frozen]
watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u2:3:188]
CPU: 0 PID: 188 Comm: kworker/u2:3 Not tainted 4.14.0-rc8-00040-g53fb1fe423ba #13
Hardware name: Atmel AT91SAM9
Workqueue: phy0 rt2x00usb_work_rxdone
task: c7b34400 task.stack: c7b4e000
PC is at rb_commit+0x1a8/0x2e4
LR is at ring_buffer_unlock_commit+0x20/0xa4
pc : [<c006c694>]    lr : [<c006d724>]    psr: 80000013
sp : c7b4fda8  ip : 00000000  fp : c7b4fdc4
r10: c664ee34  r9 : c7b2ed18  r8 : 60000013
r7 : 001c4851  r6 : c780a0e0  r5 : c7319340  r4 : 00008a48
r3 : c7319340  r2 : c664e000  r1 : 00000e38  r0 : 00000e24
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 0005317f  Table: 27270000  DAC: 00000053
CPU: 0 PID: 188 Comm: kworker/u2:3 Not tainted 4.14.0-rc8-00040-g53fb1fe423ba #13
Hardware name: Atmel AT91SAM9
Workqueue: phy0 rt2x00usb_work_rxdone
[<c000fe00>] (unwind_backtrace) from [<c000dd94>] (show_stack+0x20/0x24)
[<c000dd94>] (show_stack) from [<c05a55e0>] (dump_stack+0x20/0x28)
[<c05a55e0>] (dump_stack) from [<c000b03c>] (show_regs+0x1c/0x20)
[<c000b03c>] (show_regs) from [<c0064c90>] (watchdog_timer_fn+0x148/0x1ac)
[<c0064c90>] (watchdog_timer_fn) from [<c0051dec>] (hrtimer_run_queues+0x128/0x250)
[<c0051dec>] (hrtimer_run_queues) from [<c00512e8>] (run_local_timers+0x18/0x68)
[<c00512e8>] (run_local_timers) from [<c0051370>] (update_process_times+0x38/0x6c)
[<c0051370>] (update_process_times) from [<c005e1c0>] (tick_nohz_handler+0xc0/0x10c)
[<c005e1c0>] (tick_nohz_handler) from [<c03a756c>] (ch2_irq+0x30/0x38)
[<c03a756c>] (ch2_irq) from [<c0046b00>] (__handle_irq_event_percpu+0x74/0x1dc)
[<c0046b00>] (__handle_irq_event_percpu) from [<c0046c94>] (handle_irq_event_percpu+0x2c/0x68)
[<c0046c94>] (handle_irq_event_percpu) from [<c0046d08>] (handle_irq_event+0x38/0x4c)
[<c0046d08>] (handle_irq_event) from [<c0049f54>] (handle_fasteoi_irq+0xa0/0x114)
[<c0049f54>] (handle_fasteoi_irq) from [<c0046320>] (generic_handle_irq+0x28/0x38)
[<c0046320>] (generic_handle_irq) from [<c00463c0>] (__handle_domain_irq+0x90/0xb8)
[<c00463c0>] (__handle_domain_irq) from [<c00094a4>] (aic_handle+0xb0/0xb8)
[<c00094a4>] (aic_handle) from [<c000ea68>] (__irq_svc+0x68/0x84)
Exception stack(0xc7b4fd58 to 0xc7b4fda0)
fd40:                                                       00000e24 00000e38
fd60: c664e000 c7319340 00008a48 c7319340 c780a0e0 001c4851 60000013 c7b2ed18
fd80: c664ee34 c7b4fdc4 00000000 c7b4fda8 c006d724 c006c694 80000013 ffffffff
[<c000ea68>] (__irq_svc) from [<c006c694>] (rb_commit+0x1a8/0x2e4)
[<c006c694>] (rb_commit) from [<c006d724>] (ring_buffer_unlock_commit+0x20/0xa4)
[<c006d724>] (ring_buffer_unlock_commit) from [<c00756f4>] (trace_function+0xe0/0xf0)
[<c00756f4>] (trace_function) from [<c007c794>] (function_trace_call+0xbc/0x11c)
[<c007c794>] (function_trace_call) from [<c000f12c>] (ftrace_graph_call+0x0/0xc)
[<c000f12c>] (ftrace_graph_call) from [<c0337780>] (rt2x00usb_kick_rx_entry+0x14/0x118)
[<c0337780>] (rt2x00usb_kick_rx_entry) from [<c033834c>] (rt2x00usb_clear_entry+0x30/0x34)
[<c033834c>] (rt2x00usb_clear_entry) from [<c0332b10>] (rt2x00lib_rxdone+0x58c/0x5b8)
[<c0332b10>] (rt2x00lib_rxdone) from [<c03376ec>] (rt2x00usb_work_rxdone+0x60/0x7c)
[<c03376ec>] (rt2x00usb_work_rxdone) from [<c002ca64>] (process_one_work+0x1e4/0x3a0)
[<c002ca64>] (process_one_work) from [<c002cf28>] (worker_thread+0x2c8/0x45c)
[<c002cf28>] (worker_thread) from [<c0031f68>] (kthread+0x114/0x130)
[<c0031f68>] (kthread) from [<c000a4c8>] (ret_from_fork+0x14/0x2c)
Kernel panic - not syncing: softlockup: hung tasks
CPU: 0 PID: 188 Comm: kworker/u2:3 Tainted: G             L  4.14.0-rc8-00040-g53fb1fe423ba #13
Hardware name: Atmel AT91SAM9
Workqueue: phy0 rt2x00usb_work_rxdone
[<c000fe00>] (unwind_backtrace) from [<c000dd94>] (show_stack+0x20/0x24)
[<c000dd94>] (show_stack) from [<c05a55e0>] (dump_stack+0x20/0x28)
[<c05a55e0>] (dump_stack) from [<c00187d0>] (panic+0xc8/0x260)
[<c00187d0>] (panic) from [<c0064cc8>] (watchdog_timer_fn+0x180/0x1ac)
[<c0064cc8>] (watchdog_timer_fn) from [<c0051dec>] (hrtimer_run_queues+0x128/0x250)
[<c0051dec>] (hrtimer_run_queues) from [<c00512e8>] (run_local_timers+0x18/0x68)
[<c00512e8>] (run_local_timers) from [<c0051370>] (update_process_times+0x38/0x6c)
[<c0051370>] (update_process_times) from [<c005e1c0>] (tick_nohz_handler+0xc0/0x10c)
[<c005e1c0>] (tick_nohz_handler) from [<c03a756c>] (ch2_irq+0x30/0x38)
[<c03a756c>] (ch2_irq) from [<c0046b00>] (__handle_irq_event_percpu+0x74/0x1dc)
[<c0046b00>] (__handle_irq_event_percpu) from [<c0046c94>] (handle_irq_event_percpu+0x2c/0x68)
[<c0046c94>] (handle_irq_event_percpu) from [<c0046d08>] (handle_irq_event+0x38/0x4c)
[<c0046d08>] (handle_irq_event) from [<c0049f54>] (handle_fasteoi_irq+0xa0/0x114)
[<c0049f54>] (handle_fasteoi_irq) from [<c0046320>] (generic_handle_irq+0x28/0x38)
[<c0046320>] (generic_handle_irq) from [<c00463c0>] (__handle_domain_irq+0x90/0xb8)
[<c00463c0>] (__handle_domain_irq) from [<c00094a4>] (aic_handle+0xb0/0xb8)
[<c00094a4>] (aic_handle) from [<c000ea68>] (__irq_svc+0x68/0x84)
Exception stack(0xc7b4fd58 to 0xc7b4fda0)
fd40:                                                       00000e24 00000e38
fd60: c664e000 c7319340 00008a48 c7319340 c780a0e0 001c4851 60000013 c7b2ed18
fd80: c664ee34 c7b4fdc4 00000000 c7b4fda8 c006d724 c006c694 80000013 ffffffff
[<c000ea68>] (__irq_svc) from [<c006c694>] (rb_commit+0x1a8/0x2e4)
[<c006c694>] (rb_commit) from [<c006d724>] (ring_buffer_unlock_commit+0x20/0xa4)
[<c006d724>] (ring_buffer_unlock_commit) from [<c00756f4>] (trace_function+0xe0/0xf0)
[<c00756f4>] (trace_function) from [<c007c794>] (function_trace_call+0xbc/0x11c)
[<c007c794>] (function_trace_call) from [<c000f12c>] (ftrace_graph_call+0x0/0xc)
[<c000f12c>] (ftrace_graph_call) from [<c0337780>] (rt2x00usb_kick_rx_entry+0x14/0x118)
[<c0337780>] (rt2x00usb_kick_rx_entry) from [<c033834c>] (rt2x00usb_clear_entry+0x30/0x34)
[<c033834c>] (rt2x00usb_clear_entry) from [<c0332b10>] (rt2x00lib_rxdone+0x58c/0x5b8)
[<c0332b10>] (rt2x00lib_rxdone) from [<c03376ec>] (rt2x00usb_work_rxdone+0x60/0x7c)
[<c03376ec>] (rt2x00usb_work_rxdone) from [<c002ca64>] (process_one_work+0x1e4/0x3a0)
[<c002ca64>] (process_one_work) from [<c002cf28>] (worker_thread+0x2c8/0x45c)
[<c002cf28>] (worker_thread) from [<c0031f68>] (kthread+0x114/0x130)
[<c0031f68>] (kthread) from [<c000a4c8>] (ret_from_fork+0x14/0x2c)
Dumping ftrace buffer:
---------------------------------
CPU:0 [LOST 1781327 EVENTS]
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
kworker/-188     0.n.. 24110000us : rt2x00usb_kick_rx_entry <-rt2x00usb_clear_entry
kworker/-188     0.n.. 24110000us : rt2x00usb_clear_entry <-rt2x00lib_rxdone
[forever]

> Thanks
> Stanislaw

Thanks,
Richard
