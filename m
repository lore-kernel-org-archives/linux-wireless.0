Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726135AbeHOK7D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 06:59:03 -0400
Date: Wed, 15 Aug 2018 10:07:48 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Randy Oostdyk <linux-kernel@oostdyk.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless dongle causing entire machine to hang
Message-ID: <20180815080747.GA26839@redhat.com> (sfid-20180815_100803_364844_E8D9DD89)
References: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
 <20180809111049.GC1955@redhat.com>
 <CAAemcoOkA4y7zDMCKzD+nKJAQFoWCGPVHdbEV0j9ZOeaCe144g@mail.gmail.com>
 <20180810111425.GA16269@redhat.com>
 <CAAemcoOK6pxENmX8By=WJR3PVE7u2HwbE50LD3v0+Cif6bS5Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAemcoOK6pxENmX8By=WJR3PVE7u2HwbE50LD3v0+Cif6bS5Lg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please attach logs as txt file. Your mail client break lines
what makes logs unreadable for me.

Thanks
Stanislaw

On Tue, Aug 14, 2018 at 11:19:09PM -0600, Randy Oostdyk wrote:
> Finally got an opportunity to implement the patch and test it out.
> Looks like it suppressed the log spam (excellent!), but the machine
> unfortunately remains unresponsive. Attached is a relevant section of
> the log: I'm not able to interpret the CPU stall backtrace info, but
> perhaps someone here can determine whether it's USB or the wireless
> driver hanging the machine? In the log, it repeats with further
> warnings and CPU stall backtraces. I can supply more, if needed.
> 
> As mentioned earlier, it seems clear I have some kind of USB hardware
> issue going on, and I'll sort that out myself, I just wanted to report
> the hang, in case it might help contribute toward improving the
> reliability of the kernel.
> 
> Cheers!
> 
> 
> Aug 10 14:44:09 RCBLpi kernel: [  284.697778] wlan1: AP
> fc:2d:5e:dd:54:32 changed bandwidth, new config is 2437 MHz, width 1
> (2437/0 MHz)
> Aug 10 14:45:00 RCBLpi kernel: [  335.680872]
> rt2800usb_tx_sta_fifo_read_completed: 1389 callbacks suppressed
> Aug 10 14:45:00 RCBLpi kernel: [  335.680887] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:00 RCBLpi kernel: [  335.680986] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:00 RCBLpi kernel: [  335.681059] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:00 RCBLpi kernel: [  335.681126] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:00 RCBLpi kernel: [  335.681193] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:00 RCBLpi kernel: [  335.681282] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:00 RCBLpi kernel: [  335.681348] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:00 RCBLpi kernel: [  335.681415] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:00 RCBLpi kernel: [  335.681548] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:00 RCBLpi kernel: [  335.681623] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:00 RCBLpi kernel: [  336.171569] ieee80211 phy4:
> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for
> offset 0x1700 with error -71
> Aug 10 14:45:05 RCBLpi kernel: [  340.681558]
> rt2800usb_tx_sta_fifo_read_completed: 73528 callbacks suppressed
> Aug 10 14:45:05 RCBLpi kernel: [  340.681573] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:05 RCBLpi kernel: [  340.681659] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:05 RCBLpi kernel: [  340.681754] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:05 RCBLpi kernel: [  340.681829] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:05 RCBLpi kernel: [  340.681903] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:05 RCBLpi kernel: [  340.681984] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:05 RCBLpi kernel: [  340.682079] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:05 RCBLpi kernel: [  340.682149] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:05 RCBLpi kernel: [  340.682236] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:05 RCBLpi kernel: [  340.682302] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:10 RCBLpi kernel: [  345.691516]
> rt2800usb_tx_sta_fifo_read_completed: 76991 callbacks suppressed
> Aug 10 14:45:10 RCBLpi kernel: [  345.691530] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:10 RCBLpi kernel: [  345.691603] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:10 RCBLpi kernel: [  345.691704] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:10 RCBLpi kernel: [  345.691810] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:10 RCBLpi kernel: [  345.691877] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:10 RCBLpi kernel: [  345.691958] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:10 RCBLpi kernel: [  345.692024] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:10 RCBLpi kernel: [  345.692091] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:10 RCBLpi kernel: [  345.692173] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:10 RCBLpi kernel: [  345.692241] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:15 RCBLpi kernel: [  350.701580]
> rt2800usb_tx_sta_fifo_read_completed: 77030 callbacks suppressed
> Aug 10 14:45:15 RCBLpi kernel: [  350.701596] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:15 RCBLpi kernel: [  350.701722] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:15 RCBLpi kernel: [  350.701789] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:15 RCBLpi kernel: [  350.701870] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:15 RCBLpi kernel: [  350.701935] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:15 RCBLpi kernel: [  350.702001] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:15 RCBLpi kernel: [  350.702084] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:15 RCBLpi kernel: [  350.702150] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:15 RCBLpi kernel: [  350.702241] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:15 RCBLpi kernel: [  350.702307] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:20 RCBLpi kernel: [  355.711589]
> rt2800usb_tx_sta_fifo_read_completed: 77771 callbacks suppressed
> Aug 10 14:45:20 RCBLpi kernel: [  355.711603] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:20 RCBLpi kernel: [  355.711674] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:20 RCBLpi kernel: [  355.711763] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:20 RCBLpi kernel: [  355.711829] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:20 RCBLpi kernel: [  355.711917] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:20 RCBLpi kernel: [  355.711983] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:20 RCBLpi kernel: [  355.712048] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:20 RCBLpi kernel: [  355.712135] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:20 RCBLpi kernel: [  355.712199] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:20 RCBLpi kernel: [  355.712265] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:20 RCBLpi kernel: [  356.171492] INFO: rcu_sched
> self-detected stall on CPU
> Aug 10 14:45:20 RCBLpi kernel: [  356.171522]   0-...: (2099 ticks
> this GP) idle=72a/140000000000002/0 softirq=11632/11632 fqs=1002
> Aug 10 14:45:20 RCBLpi kernel: [  356.171525]    (t=2100 jiffies
> g=5626 c=5625 q=17568)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171541] NMI backtrace for cpu 0
> Aug 10 14:45:20 RCBLpi kernel: [  356.171553] CPU: 0 PID: 1007 Comm:
> kworker/u8:17 Tainted: G         C      4.14.61-v7+ #1
> Aug 10 14:45:20 RCBLpi kernel: [  356.171558] Hardware name: BCM2835
> Aug 10 14:45:20 RCBLpi kernel: [  356.171588] Workqueue: phy4
> rt2x00usb_work_rxdone [rt2x00usb]
> Aug 10 14:45:20 RCBLpi kernel: [  356.171622] [<8010ffc0>]
> (unwind_backtrace) from [<8010c1fc>] (show_stack+0x20/0x24)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171640] [<8010c1fc>]
> (show_stack) from [<807894fc>] (dump_stack+0xc8/0x10c)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171659] [<807894fc>]
> (dump_stack) from [<8078f43c>] (nmi_cpu_backtrace+0x11c/0x120)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171676] [<8078f43c>]
> (nmi_cpu_backtrace) from [<8078f520>]
> (nmi_trigger_cpumask_backtrace+0xe0/0x12c)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171692] [<8078f520>]
> (nmi_trigger_cpumask_backtrace) from [<8010e648>]
> (arch_trigger_cpumask_backtrace+0x20/0x24)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171710] [<8010e648>]
> (arch_trigger_cpumask_backtrace) from [<80185710>]
> (rcu_dump_cpu_stacks+0xb0/0xdc)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171728] [<80185710>]
> (rcu_dump_cpu_stacks) from [<801850b0>]
> (rcu_check_callbacks+0x7e8/0x960)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171745] [<801850b0>]
> (rcu_check_callbacks) from [<8018b314>]
> (update_process_times+0x44/0x70)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171762] [<8018b314>]
> (update_process_times) from [<8019d32c>] (tick_sched_handle+0x64/0x70)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171779] [<8019d32c>]
> (tick_sched_handle) from [<8019d590>] (tick_sched_timer+0x50/0xac)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171795] [<8019d590>]
> (tick_sched_timer) from [<8018c2cc>]
> (__hrtimer_run_queues+0x158/0x2ec)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171810] [<8018c2cc>]
> (__hrtimer_run_queues) from [<8018c704>]
> (hrtimer_interrupt+0xb8/0x20c)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171827] [<8018c704>]
> (hrtimer_interrupt) from [<8063de74>]
> (arch_timer_handler_phys+0x40/0x48)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171846] [<8063de74>]
> (arch_timer_handler_phys) from [<8017a150>]
> (handle_percpu_devid_irq+0x88/0x23c)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171863] [<8017a150>]
> (handle_percpu_devid_irq) from [<801749fc>]
> (generic_handle_irq+0x34/0x44)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171879] [<801749fc>]
> (generic_handle_irq) from [<80175050>] (__handle_domain_irq+0x6c/0xc4)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171894] [<80175050>]
> (__handle_domain_irq) from [<80101520>]
> (bcm2836_arm_irqchip_handle_irq+0xac/0xb0)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171911] [<80101520>]
> (bcm2836_arm_irqchip_handle_irq) from [<807a4ffc>]
> (__irq_svc+0x5c/0x7c)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171918] Exception
> stack(0xadbffab0 to 0xadbffaf8)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171927] faa0:
>                  00000000 00000000 a980bd00 00000000
> Aug 10 14:45:20 RCBLpi kernel: [  356.171939] fac0: b7716e80 60000113
> b9fbe400 adae99d0 00000001 adbfe000 00000001 adbffb1c
> Aug 10 14:45:20 RCBLpi kernel: [  356.171949] fae0: adbffb00 adbffb00
> 805b3388 805b339c 60000113 ffffffff
> Aug 10 14:45:20 RCBLpi kernel: [  356.171969] [<807a4ffc>] (__irq_svc)
> from [<805b339c>] (__usb_hcd_giveback_urb+0x118/0x15c)
> Aug 10 14:45:20 RCBLpi kernel: [  356.171988] [<805b339c>]
> (__usb_hcd_giveback_urb) from [<805b3530>]
> (usb_hcd_giveback_urb+0x4c/0xfc)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172006] [<805b3530>]
> (usb_hcd_giveback_urb) from [<805dde40>]
> (completion_tasklet_func+0x80/0xac)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172024] [<805dde40>]
> (completion_tasklet_func) from [<805ecc60>]
> (tasklet_callback+0x20/0x24)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172040] [<805ecc60>]
> (tasklet_callback) from [<80123ac4>] (tasklet_hi_action+0x70/0x104)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172055] [<80123ac4>]
> (tasklet_hi_action) from [<8010169c>] (__do_softirq+0x174/0x3d8)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172069] [<8010169c>]
> (__do_softirq) from [<801236a8>] (irq_exit+0xe4/0x140)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172083] [<801236a8>] (irq_exit)
> from [<80175054>] (__handle_domain_irq+0x70/0xc4)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172097] [<80175054>]
> (__handle_domain_irq) from [<80101520>]
> (bcm2836_arm_irqchip_handle_irq+0xac/0xb0)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172111] [<80101520>]
> (bcm2836_arm_irqchip_handle_irq) from [<807a4ffc>]
> (__irq_svc+0x5c/0x7c)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172117] Exception
> stack(0xadbffc58 to 0xadbffca0)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172125] fc40:
>                                    b9d83a40 00000000
> Aug 10 14:45:20 RCBLpi kernel: [  356.172136] fc60: 00000001 00000000
> 60000013 00000000 aa2d4b00 a9949600 b9db0400 b9fbe400
> Aug 10 14:45:20 RCBLpi kernel: [  356.172148] fc80: 00000000 adbffcbc
> adbffca8 adbffca8 807a4d2c 807a4d40 60000013 ffffffff
> Aug 10 14:45:20 RCBLpi kernel: [  356.172164] [<807a4ffc>] (__irq_svc)
> from [<807a4d40>] (_raw_spin_unlock_irqrestore+0x50/0x70)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172180] [<807a4d40>]
> (_raw_spin_unlock_irqrestore) from [<805ecbf8>]
> (DWC_SPINUNLOCK_IRQRESTORE+0x18/0x1c)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172196] [<805ecbf8>]
> (DWC_SPINUNLOCK_IRQRESTORE) from [<805e27f4>]
> (dwc_otg_urb_enqueue+0x1dc/0x31c)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172212] [<805e27f4>]
> (dwc_otg_urb_enqueue) from [<805b4f34>]
> (usb_hcd_submit_urb+0xc8/0x934)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172226] [<805b4f34>]
> (usb_hcd_submit_urb) from [<805b687c>] (usb_submit_urb+0x284/0x510)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172250] [<805b687c>]
> (usb_submit_urb) from [<7f4a76e0>] (rt2x00usb_kick_rx_entry+0xb4/0xfc
> [rt2x00usb])
> Aug 10 14:45:20 RCBLpi kernel: [  356.172296] [<7f4a76e0>]
> (rt2x00usb_kick_rx_entry [rt2x00usb]) from [<7f4a7758>]
> (rt2x00usb_clear_entry+0x30/0x34 [rt2x00usb])
> Aug 10 14:45:20 RCBLpi kernel: [  356.172354] [<7f4a7758>]
> (rt2x00usb_clear_entry [rt2x00usb]) from [<7f492a44>]
> (rt2x00lib_rxdone+0x148/0x5b8 [rt2x00lib])
> Aug 10 14:45:20 RCBLpi kernel: [  356.172412] [<7f492a44>]
> (rt2x00lib_rxdone [rt2x00lib]) from [<7f4a8088>]
> (rt2x00usb_work_rxdone+0x58/0x8c [rt2x00usb])
> Aug 10 14:45:20 RCBLpi kernel: [  356.172440] [<7f4a8088>]
> (rt2x00usb_work_rxdone [rt2x00usb]) from [<80137384>]
> (process_one_work+0x224/0x518)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172459] [<80137384>]
> (process_one_work) from [<8013835c>] (worker_thread+0x60/0x5f0)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172476] [<8013835c>]
> (worker_thread) from [<8013db68>] (kthread+0x144/0x174)
> Aug 10 14:45:20 RCBLpi kernel: [  356.172492] [<8013db68>] (kthread)
> from [<801080ac>] (ret_from_fork+0x14/0x28)
> Aug 10 14:45:22 RCBLpi kernel: [  357.591518] INFO: rcu_sched detected
> expedited stalls on CPUs/tasks: { 0-... } 2109 jiffies s: 221 root:
> 0x1/.
> Aug 10 14:45:22 RCBLpi kernel: [  357.591545] blocking rcu_node structures:
> Aug 10 14:45:22 RCBLpi kernel: [  357.591554] Task dump for CPU 0:
> Aug 10 14:45:22 RCBLpi kernel: [  357.591560] kworker/u8:17   R
> running task        0  1007      2 0x00000002
> Aug 10 14:45:22 RCBLpi kernel: [  357.591603] Workqueue: phy4
> rt2x00usb_work_rxdone [rt2x00usb]
> Aug 10 14:45:25 RCBLpi kernel: [  360.721537]
> rt2800usb_tx_sta_fifo_read_completed: 77886 callbacks suppressed
> Aug 10 14:45:25 RCBLpi kernel: [  360.721552] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:25 RCBLpi kernel: [  360.721651] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> Aug 10 14:45:25 RCBLpi kernel: [  360.721720] ieee80211 phy4:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> 
> On Fri, Aug 10, 2018 at 5:14 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Thu, Aug 09, 2018 at 12:49:58PM -0600, Randy Oostdyk wrote:
> >> On Thu, Aug 9, 2018 at 5:10 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >> > I'm reluctant to replace _warn by _dbg messages as if somethings
> >> > will go wrong we will not notice that. We can use printk_ratelimited()
> >> > variant instead to do not spam log in speed that it will hung
> >> > the machine. But the correct fix should be in USB host drivers,
> >> > which seems to be not in perfect shape on those embedded platforms.
> >>
> >> Agreed about the "correct" fix likely being on the USB side, but at
> >> least using printk_ratelimited() will avoid the log spamming, and
> >> avoid locking the machine, as you said.
> >>
> >> Will someone else take that approach and come up with a patch, or is
> >> this something I should try to take on myself? I could certainly test
> >> such a patch, if desired.
> >>
> >> Meanwhile, I'll look into reporting the USB bug, if it hasn't already been.
> >
> > I'm attaching the ratelimit patch for test.
> >
> > However after reading email from Larry I withdraw blaming USB host
> > driver. The issue could be faulty HW and USB host driver can not do
> > much much about this.
> >
> > Another question is if machine hung due to log spam or because there
> > was some crash. Those error conditions trigger code paths that are
> > not usually used, so there could be some oops that hung the system.
> >
> > Anyway you can test the patch and report back.
> >
> > Cheers
> > Stanislaw
