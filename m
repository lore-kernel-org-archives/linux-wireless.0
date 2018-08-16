Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:33124 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387534AbeHPHV1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 03:21:27 -0400
Received: by mail-yb0-f194.google.com with SMTP id e84-v6so58059ybb.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2018 21:25:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180815080747.GA26839@redhat.com>
References: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
 <20180809111049.GC1955@redhat.com> <CAAemcoOkA4y7zDMCKzD+nKJAQFoWCGPVHdbEV0j9ZOeaCe144g@mail.gmail.com>
 <20180810111425.GA16269@redhat.com> <CAAemcoOK6pxENmX8By=WJR3PVE7u2HwbE50LD3v0+Cif6bS5Lg@mail.gmail.com>
 <20180815080747.GA26839@redhat.com>
From: Randy Oostdyk <linux-kernel@oostdyk.com>
Date: Wed, 15 Aug 2018 22:25:48 -0600
Message-ID: <CAAemcoMUm=O3yviObt3+u-Cf+ySrVD2HXOzUHHOU0L4wBm=e9w@mail.gmail.com> (sfid-20180816_062558_195598_A80A1A4A)
Subject: Re: wireless dongle causing entire machine to hang
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000783e39057385d646"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--000000000000783e39057385d646
Content-Type: text/plain; charset="UTF-8"

Sorry about the mangled log file! Here's the txt file as an
attachment, hope it's useful.

Cheers.

On Wed, Aug 15, 2018 at 2:07 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Please attach logs as txt file. Your mail client break lines
> what makes logs unreadable for me.
>
> Thanks
> Stanislaw
>
> On Tue, Aug 14, 2018 at 11:19:09PM -0600, Randy Oostdyk wrote:
>> Finally got an opportunity to implement the patch and test it out.
>> Looks like it suppressed the log spam (excellent!), but the machine
>> unfortunately remains unresponsive. Attached is a relevant section of
>> the log: I'm not able to interpret the CPU stall backtrace info, but
>> perhaps someone here can determine whether it's USB or the wireless
>> driver hanging the machine? In the log, it repeats with further
>> warnings and CPU stall backtraces. I can supply more, if needed.
>>
>> As mentioned earlier, it seems clear I have some kind of USB hardware
>> issue going on, and I'll sort that out myself, I just wanted to report
>> the hang, in case it might help contribute toward improving the
>> reliability of the kernel.
>>
>> Cheers!
>>
>>
>> Aug 10 14:44:09 RCBLpi kernel: [  284.697778] wlan1: AP
>> fc:2d:5e:dd:54:32 changed bandwidth, new config is 2437 MHz, width 1
>> (2437/0 MHz)
>> Aug 10 14:45:00 RCBLpi kernel: [  335.680872]
>> rt2800usb_tx_sta_fifo_read_completed: 1389 callbacks suppressed
>> Aug 10 14:45:00 RCBLpi kernel: [  335.680887] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:00 RCBLpi kernel: [  335.680986] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:00 RCBLpi kernel: [  335.681059] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:00 RCBLpi kernel: [  335.681126] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:00 RCBLpi kernel: [  335.681193] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:00 RCBLpi kernel: [  335.681282] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:00 RCBLpi kernel: [  335.681348] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:00 RCBLpi kernel: [  335.681415] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:00 RCBLpi kernel: [  335.681548] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:00 RCBLpi kernel: [  335.681623] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:00 RCBLpi kernel: [  336.171569] ieee80211 phy4:
>> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for
>> offset 0x1700 with error -71
>> Aug 10 14:45:05 RCBLpi kernel: [  340.681558]
>> rt2800usb_tx_sta_fifo_read_completed: 73528 callbacks suppressed
>> Aug 10 14:45:05 RCBLpi kernel: [  340.681573] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:05 RCBLpi kernel: [  340.681659] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:05 RCBLpi kernel: [  340.681754] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:05 RCBLpi kernel: [  340.681829] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:05 RCBLpi kernel: [  340.681903] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:05 RCBLpi kernel: [  340.681984] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:05 RCBLpi kernel: [  340.682079] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:05 RCBLpi kernel: [  340.682149] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:05 RCBLpi kernel: [  340.682236] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:05 RCBLpi kernel: [  340.682302] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:10 RCBLpi kernel: [  345.691516]
>> rt2800usb_tx_sta_fifo_read_completed: 76991 callbacks suppressed
>> Aug 10 14:45:10 RCBLpi kernel: [  345.691530] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:10 RCBLpi kernel: [  345.691603] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:10 RCBLpi kernel: [  345.691704] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:10 RCBLpi kernel: [  345.691810] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:10 RCBLpi kernel: [  345.691877] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:10 RCBLpi kernel: [  345.691958] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:10 RCBLpi kernel: [  345.692024] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:10 RCBLpi kernel: [  345.692091] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:10 RCBLpi kernel: [  345.692173] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:10 RCBLpi kernel: [  345.692241] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:15 RCBLpi kernel: [  350.701580]
>> rt2800usb_tx_sta_fifo_read_completed: 77030 callbacks suppressed
>> Aug 10 14:45:15 RCBLpi kernel: [  350.701596] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:15 RCBLpi kernel: [  350.701722] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:15 RCBLpi kernel: [  350.701789] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:15 RCBLpi kernel: [  350.701870] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:15 RCBLpi kernel: [  350.701935] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:15 RCBLpi kernel: [  350.702001] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:15 RCBLpi kernel: [  350.702084] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:15 RCBLpi kernel: [  350.702150] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:15 RCBLpi kernel: [  350.702241] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:15 RCBLpi kernel: [  350.702307] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:20 RCBLpi kernel: [  355.711589]
>> rt2800usb_tx_sta_fifo_read_completed: 77771 callbacks suppressed
>> Aug 10 14:45:20 RCBLpi kernel: [  355.711603] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:20 RCBLpi kernel: [  355.711674] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:20 RCBLpi kernel: [  355.711763] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:20 RCBLpi kernel: [  355.711829] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:20 RCBLpi kernel: [  355.711917] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:20 RCBLpi kernel: [  355.711983] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:20 RCBLpi kernel: [  355.712048] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:20 RCBLpi kernel: [  355.712135] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:20 RCBLpi kernel: [  355.712199] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:20 RCBLpi kernel: [  355.712265] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171492] INFO: rcu_sched
>> self-detected stall on CPU
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171522]   0-...: (2099 ticks
>> this GP) idle=72a/140000000000002/0 softirq=11632/11632 fqs=1002
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171525]    (t=2100 jiffies
>> g=5626 c=5625 q=17568)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171541] NMI backtrace for cpu 0
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171553] CPU: 0 PID: 1007 Comm:
>> kworker/u8:17 Tainted: G         C      4.14.61-v7+ #1
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171558] Hardware name: BCM2835
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171588] Workqueue: phy4
>> rt2x00usb_work_rxdone [rt2x00usb]
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171622] [<8010ffc0>]
>> (unwind_backtrace) from [<8010c1fc>] (show_stack+0x20/0x24)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171640] [<8010c1fc>]
>> (show_stack) from [<807894fc>] (dump_stack+0xc8/0x10c)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171659] [<807894fc>]
>> (dump_stack) from [<8078f43c>] (nmi_cpu_backtrace+0x11c/0x120)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171676] [<8078f43c>]
>> (nmi_cpu_backtrace) from [<8078f520>]
>> (nmi_trigger_cpumask_backtrace+0xe0/0x12c)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171692] [<8078f520>]
>> (nmi_trigger_cpumask_backtrace) from [<8010e648>]
>> (arch_trigger_cpumask_backtrace+0x20/0x24)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171710] [<8010e648>]
>> (arch_trigger_cpumask_backtrace) from [<80185710>]
>> (rcu_dump_cpu_stacks+0xb0/0xdc)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171728] [<80185710>]
>> (rcu_dump_cpu_stacks) from [<801850b0>]
>> (rcu_check_callbacks+0x7e8/0x960)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171745] [<801850b0>]
>> (rcu_check_callbacks) from [<8018b314>]
>> (update_process_times+0x44/0x70)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171762] [<8018b314>]
>> (update_process_times) from [<8019d32c>] (tick_sched_handle+0x64/0x70)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171779] [<8019d32c>]
>> (tick_sched_handle) from [<8019d590>] (tick_sched_timer+0x50/0xac)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171795] [<8019d590>]
>> (tick_sched_timer) from [<8018c2cc>]
>> (__hrtimer_run_queues+0x158/0x2ec)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171810] [<8018c2cc>]
>> (__hrtimer_run_queues) from [<8018c704>]
>> (hrtimer_interrupt+0xb8/0x20c)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171827] [<8018c704>]
>> (hrtimer_interrupt) from [<8063de74>]
>> (arch_timer_handler_phys+0x40/0x48)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171846] [<8063de74>]
>> (arch_timer_handler_phys) from [<8017a150>]
>> (handle_percpu_devid_irq+0x88/0x23c)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171863] [<8017a150>]
>> (handle_percpu_devid_irq) from [<801749fc>]
>> (generic_handle_irq+0x34/0x44)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171879] [<801749fc>]
>> (generic_handle_irq) from [<80175050>] (__handle_domain_irq+0x6c/0xc4)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171894] [<80175050>]
>> (__handle_domain_irq) from [<80101520>]
>> (bcm2836_arm_irqchip_handle_irq+0xac/0xb0)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171911] [<80101520>]
>> (bcm2836_arm_irqchip_handle_irq) from [<807a4ffc>]
>> (__irq_svc+0x5c/0x7c)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171918] Exception
>> stack(0xadbffab0 to 0xadbffaf8)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171927] faa0:
>>                  00000000 00000000 a980bd00 00000000
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171939] fac0: b7716e80 60000113
>> b9fbe400 adae99d0 00000001 adbfe000 00000001 adbffb1c
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171949] fae0: adbffb00 adbffb00
>> 805b3388 805b339c 60000113 ffffffff
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171969] [<807a4ffc>] (__irq_svc)
>> from [<805b339c>] (__usb_hcd_giveback_urb+0x118/0x15c)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.171988] [<805b339c>]
>> (__usb_hcd_giveback_urb) from [<805b3530>]
>> (usb_hcd_giveback_urb+0x4c/0xfc)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172006] [<805b3530>]
>> (usb_hcd_giveback_urb) from [<805dde40>]
>> (completion_tasklet_func+0x80/0xac)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172024] [<805dde40>]
>> (completion_tasklet_func) from [<805ecc60>]
>> (tasklet_callback+0x20/0x24)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172040] [<805ecc60>]
>> (tasklet_callback) from [<80123ac4>] (tasklet_hi_action+0x70/0x104)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172055] [<80123ac4>]
>> (tasklet_hi_action) from [<8010169c>] (__do_softirq+0x174/0x3d8)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172069] [<8010169c>]
>> (__do_softirq) from [<801236a8>] (irq_exit+0xe4/0x140)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172083] [<801236a8>] (irq_exit)
>> from [<80175054>] (__handle_domain_irq+0x70/0xc4)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172097] [<80175054>]
>> (__handle_domain_irq) from [<80101520>]
>> (bcm2836_arm_irqchip_handle_irq+0xac/0xb0)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172111] [<80101520>]
>> (bcm2836_arm_irqchip_handle_irq) from [<807a4ffc>]
>> (__irq_svc+0x5c/0x7c)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172117] Exception
>> stack(0xadbffc58 to 0xadbffca0)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172125] fc40:
>>                                    b9d83a40 00000000
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172136] fc60: 00000001 00000000
>> 60000013 00000000 aa2d4b00 a9949600 b9db0400 b9fbe400
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172148] fc80: 00000000 adbffcbc
>> adbffca8 adbffca8 807a4d2c 807a4d40 60000013 ffffffff
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172164] [<807a4ffc>] (__irq_svc)
>> from [<807a4d40>] (_raw_spin_unlock_irqrestore+0x50/0x70)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172180] [<807a4d40>]
>> (_raw_spin_unlock_irqrestore) from [<805ecbf8>]
>> (DWC_SPINUNLOCK_IRQRESTORE+0x18/0x1c)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172196] [<805ecbf8>]
>> (DWC_SPINUNLOCK_IRQRESTORE) from [<805e27f4>]
>> (dwc_otg_urb_enqueue+0x1dc/0x31c)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172212] [<805e27f4>]
>> (dwc_otg_urb_enqueue) from [<805b4f34>]
>> (usb_hcd_submit_urb+0xc8/0x934)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172226] [<805b4f34>]
>> (usb_hcd_submit_urb) from [<805b687c>] (usb_submit_urb+0x284/0x510)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172250] [<805b687c>]
>> (usb_submit_urb) from [<7f4a76e0>] (rt2x00usb_kick_rx_entry+0xb4/0xfc
>> [rt2x00usb])
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172296] [<7f4a76e0>]
>> (rt2x00usb_kick_rx_entry [rt2x00usb]) from [<7f4a7758>]
>> (rt2x00usb_clear_entry+0x30/0x34 [rt2x00usb])
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172354] [<7f4a7758>]
>> (rt2x00usb_clear_entry [rt2x00usb]) from [<7f492a44>]
>> (rt2x00lib_rxdone+0x148/0x5b8 [rt2x00lib])
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172412] [<7f492a44>]
>> (rt2x00lib_rxdone [rt2x00lib]) from [<7f4a8088>]
>> (rt2x00usb_work_rxdone+0x58/0x8c [rt2x00usb])
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172440] [<7f4a8088>]
>> (rt2x00usb_work_rxdone [rt2x00usb]) from [<80137384>]
>> (process_one_work+0x224/0x518)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172459] [<80137384>]
>> (process_one_work) from [<8013835c>] (worker_thread+0x60/0x5f0)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172476] [<8013835c>]
>> (worker_thread) from [<8013db68>] (kthread+0x144/0x174)
>> Aug 10 14:45:20 RCBLpi kernel: [  356.172492] [<8013db68>] (kthread)
>> from [<801080ac>] (ret_from_fork+0x14/0x28)
>> Aug 10 14:45:22 RCBLpi kernel: [  357.591518] INFO: rcu_sched detected
>> expedited stalls on CPUs/tasks: { 0-... } 2109 jiffies s: 221 root:
>> 0x1/.
>> Aug 10 14:45:22 RCBLpi kernel: [  357.591545] blocking rcu_node structures:
>> Aug 10 14:45:22 RCBLpi kernel: [  357.591554] Task dump for CPU 0:
>> Aug 10 14:45:22 RCBLpi kernel: [  357.591560] kworker/u8:17   R
>> running task        0  1007      2 0x00000002
>> Aug 10 14:45:22 RCBLpi kernel: [  357.591603] Workqueue: phy4
>> rt2x00usb_work_rxdone [rt2x00usb]
>> Aug 10 14:45:25 RCBLpi kernel: [  360.721537]
>> rt2800usb_tx_sta_fifo_read_completed: 77886 callbacks suppressed
>> Aug 10 14:45:25 RCBLpi kernel: [  360.721552] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:25 RCBLpi kernel: [  360.721651] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>> Aug 10 14:45:25 RCBLpi kernel: [  360.721720] ieee80211 phy4:
>> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
>> -71
>>
>> On Fri, Aug 10, 2018 at 5:14 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> > On Thu, Aug 09, 2018 at 12:49:58PM -0600, Randy Oostdyk wrote:
>> >> On Thu, Aug 9, 2018 at 5:10 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> >> > I'm reluctant to replace _warn by _dbg messages as if somethings
>> >> > will go wrong we will not notice that. We can use printk_ratelimited()
>> >> > variant instead to do not spam log in speed that it will hung
>> >> > the machine. But the correct fix should be in USB host drivers,
>> >> > which seems to be not in perfect shape on those embedded platforms.
>> >>
>> >> Agreed about the "correct" fix likely being on the USB side, but at
>> >> least using printk_ratelimited() will avoid the log spamming, and
>> >> avoid locking the machine, as you said.
>> >>
>> >> Will someone else take that approach and come up with a patch, or is
>> >> this something I should try to take on myself? I could certainly test
>> >> such a patch, if desired.
>> >>
>> >> Meanwhile, I'll look into reporting the USB bug, if it hasn't already been.
>> >
>> > I'm attaching the ratelimit patch for test.
>> >
>> > However after reading email from Larry I withdraw blaming USB host
>> > driver. The issue could be faulty HW and USB host driver can not do
>> > much much about this.
>> >
>> > Another question is if machine hung due to log spam or because there
>> > was some crash. Those error conditions trigger code paths that are
>> > not usually used, so there could be some oops that hung the system.
>> >
>> > Anyway you can test the patch and report back.
>> >
>> > Cheers
>> > Stanislaw

--000000000000783e39057385d646
Content-Type: text/plain; charset="US-ASCII"; name="rt2800usb_cpu_stall.txt"
Content-Disposition: attachment; filename="rt2800usb_cpu_stall.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jkw279x30

QXVnIDEwIDE0OjQ0OjA5IFJDQkxwaSBrZXJuZWw6IFsgIDI4NC42OTc3NzhdIHdsYW4xOiBBUCBm
YzoyZDo1ZTpkZDo1NDozMiBjaGFuZ2VkIGJhbmR3aWR0aCwgbmV3IGNvbmZpZyBpcyAyNDM3IE1I
eiwgd2lkdGggMSAoMjQzNy8wIE1IeikKQXVnIDEwIDE0OjQ1OjAwIFJDQkxwaSBrZXJuZWw6IFsg
IDMzNS42ODA4NzJdIHJ0MjgwMHVzYl90eF9zdGFfZmlmb19yZWFkX2NvbXBsZXRlZDogMTM4OSBj
YWxsYmFja3Mgc3VwcHJlc3NlZApBdWcgMTAgMTQ6NDU6MDAgUkNCTHBpIGtlcm5lbDogWyAgMzM1
LjY4MDg4N10gaWVlZTgwMjExIHBoeTQ6IHJ0MjgwMHVzYl90eF9zdGFfZmlmb19yZWFkX2NvbXBs
ZXRlZDogV2FybmluZyAtIFRYIHN0YXR1cyByZWFkIGZhaWxlZCAtNzEKQXVnIDEwIDE0OjQ1OjAw
IFJDQkxwaSBrZXJuZWw6IFsgIDMzNS42ODA5ODZdIGllZWU4MDIxMSBwaHk0OiBydDI4MDB1c2Jf
dHhfc3RhX2ZpZm9fcmVhZF9jb21wbGV0ZWQ6IFdhcm5pbmcgLSBUWCBzdGF0dXMgcmVhZCBmYWls
ZWQgLTcxCkF1ZyAxMCAxNDo0NTowMCBSQ0JMcGkga2VybmVsOiBbICAzMzUuNjgxMDU5XSBpZWVl
ODAyMTEgcGh5NDogcnQyODAwdXNiX3R4X3N0YV9maWZvX3JlYWRfY29tcGxldGVkOiBXYXJuaW5n
IC0gVFggc3RhdHVzIHJlYWQgZmFpbGVkIC03MQpBdWcgMTAgMTQ6NDU6MDAgUkNCTHBpIGtlcm5l
bDogWyAgMzM1LjY4MTEyNl0gaWVlZTgwMjExIHBoeTQ6IHJ0MjgwMHVzYl90eF9zdGFfZmlmb19y
ZWFkX2NvbXBsZXRlZDogV2FybmluZyAtIFRYIHN0YXR1cyByZWFkIGZhaWxlZCAtNzEKQXVnIDEw
IDE0OjQ1OjAwIFJDQkxwaSBrZXJuZWw6IFsgIDMzNS42ODExOTNdIGllZWU4MDIxMSBwaHk0OiBy
dDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVhZF9jb21wbGV0ZWQ6IFdhcm5pbmcgLSBUWCBzdGF0dXMg
cmVhZCBmYWlsZWQgLTcxCkF1ZyAxMCAxNDo0NTowMCBSQ0JMcGkga2VybmVsOiBbICAzMzUuNjgx
MjgyXSBpZWVlODAyMTEgcGh5NDogcnQyODAwdXNiX3R4X3N0YV9maWZvX3JlYWRfY29tcGxldGVk
OiBXYXJuaW5nIC0gVFggc3RhdHVzIHJlYWQgZmFpbGVkIC03MQpBdWcgMTAgMTQ6NDU6MDAgUkNC
THBpIGtlcm5lbDogWyAgMzM1LjY4MTM0OF0gaWVlZTgwMjExIHBoeTQ6IHJ0MjgwMHVzYl90eF9z
dGFfZmlmb19yZWFkX2NvbXBsZXRlZDogV2FybmluZyAtIFRYIHN0YXR1cyByZWFkIGZhaWxlZCAt
NzEKQXVnIDEwIDE0OjQ1OjAwIFJDQkxwaSBrZXJuZWw6IFsgIDMzNS42ODE0MTVdIGllZWU4MDIx
MSBwaHk0OiBydDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVhZF9jb21wbGV0ZWQ6IFdhcm5pbmcgLSBU
WCBzdGF0dXMgcmVhZCBmYWlsZWQgLTcxCkF1ZyAxMCAxNDo0NTowMCBSQ0JMcGkga2VybmVsOiBb
ICAzMzUuNjgxNTQ4XSBpZWVlODAyMTEgcGh5NDogcnQyODAwdXNiX3R4X3N0YV9maWZvX3JlYWRf
Y29tcGxldGVkOiBXYXJuaW5nIC0gVFggc3RhdHVzIHJlYWQgZmFpbGVkIC03MQpBdWcgMTAgMTQ6
NDU6MDAgUkNCTHBpIGtlcm5lbDogWyAgMzM1LjY4MTYyM10gaWVlZTgwMjExIHBoeTQ6IHJ0Mjgw
MHVzYl90eF9zdGFfZmlmb19yZWFkX2NvbXBsZXRlZDogV2FybmluZyAtIFRYIHN0YXR1cyByZWFk
IGZhaWxlZCAtNzEKQXVnIDEwIDE0OjQ1OjAwIFJDQkxwaSBrZXJuZWw6IFsgIDMzNi4xNzE1Njld
IGllZWU4MDIxMSBwaHk0OiBydDJ4MDB1c2JfdmVuZG9yX3JlcXVlc3Q6IEVycm9yIC0gVmVuZG9y
IFJlcXVlc3QgMHgwNyBmYWlsZWQgZm9yIG9mZnNldCAweDE3MDAgd2l0aCBlcnJvciAtNzEKQXVn
IDEwIDE0OjQ1OjA1IFJDQkxwaSBrZXJuZWw6IFsgIDM0MC42ODE1NThdIHJ0MjgwMHVzYl90eF9z
dGFfZmlmb19yZWFkX2NvbXBsZXRlZDogNzM1MjggY2FsbGJhY2tzIHN1cHByZXNzZWQKQXVnIDEw
IDE0OjQ1OjA1IFJDQkxwaSBrZXJuZWw6IFsgIDM0MC42ODE1NzNdIGllZWU4MDIxMSBwaHk0OiBy
dDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVhZF9jb21wbGV0ZWQ6IFdhcm5pbmcgLSBUWCBzdGF0dXMg
cmVhZCBmYWlsZWQgLTcxCkF1ZyAxMCAxNDo0NTowNSBSQ0JMcGkga2VybmVsOiBbICAzNDAuNjgx
NjU5XSBpZWVlODAyMTEgcGh5NDogcnQyODAwdXNiX3R4X3N0YV9maWZvX3JlYWRfY29tcGxldGVk
OiBXYXJuaW5nIC0gVFggc3RhdHVzIHJlYWQgZmFpbGVkIC03MQpBdWcgMTAgMTQ6NDU6MDUgUkNC
THBpIGtlcm5lbDogWyAgMzQwLjY4MTc1NF0gaWVlZTgwMjExIHBoeTQ6IHJ0MjgwMHVzYl90eF9z
dGFfZmlmb19yZWFkX2NvbXBsZXRlZDogV2FybmluZyAtIFRYIHN0YXR1cyByZWFkIGZhaWxlZCAt
NzEKQXVnIDEwIDE0OjQ1OjA1IFJDQkxwaSBrZXJuZWw6IFsgIDM0MC42ODE4MjldIGllZWU4MDIx
MSBwaHk0OiBydDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVhZF9jb21wbGV0ZWQ6IFdhcm5pbmcgLSBU
WCBzdGF0dXMgcmVhZCBmYWlsZWQgLTcxCkF1ZyAxMCAxNDo0NTowNSBSQ0JMcGkga2VybmVsOiBb
ICAzNDAuNjgxOTAzXSBpZWVlODAyMTEgcGh5NDogcnQyODAwdXNiX3R4X3N0YV9maWZvX3JlYWRf
Y29tcGxldGVkOiBXYXJuaW5nIC0gVFggc3RhdHVzIHJlYWQgZmFpbGVkIC03MQpBdWcgMTAgMTQ6
NDU6MDUgUkNCTHBpIGtlcm5lbDogWyAgMzQwLjY4MTk4NF0gaWVlZTgwMjExIHBoeTQ6IHJ0Mjgw
MHVzYl90eF9zdGFfZmlmb19yZWFkX2NvbXBsZXRlZDogV2FybmluZyAtIFRYIHN0YXR1cyByZWFk
IGZhaWxlZCAtNzEKQXVnIDEwIDE0OjQ1OjA1IFJDQkxwaSBrZXJuZWw6IFsgIDM0MC42ODIwNzld
IGllZWU4MDIxMSBwaHk0OiBydDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVhZF9jb21wbGV0ZWQ6IFdh
cm5pbmcgLSBUWCBzdGF0dXMgcmVhZCBmYWlsZWQgLTcxCkF1ZyAxMCAxNDo0NTowNSBSQ0JMcGkg
a2VybmVsOiBbICAzNDAuNjgyMTQ5XSBpZWVlODAyMTEgcGh5NDogcnQyODAwdXNiX3R4X3N0YV9m
aWZvX3JlYWRfY29tcGxldGVkOiBXYXJuaW5nIC0gVFggc3RhdHVzIHJlYWQgZmFpbGVkIC03MQpB
dWcgMTAgMTQ6NDU6MDUgUkNCTHBpIGtlcm5lbDogWyAgMzQwLjY4MjIzNl0gaWVlZTgwMjExIHBo
eTQ6IHJ0MjgwMHVzYl90eF9zdGFfZmlmb19yZWFkX2NvbXBsZXRlZDogV2FybmluZyAtIFRYIHN0
YXR1cyByZWFkIGZhaWxlZCAtNzEKQXVnIDEwIDE0OjQ1OjA1IFJDQkxwaSBrZXJuZWw6IFsgIDM0
MC42ODIzMDJdIGllZWU4MDIxMSBwaHk0OiBydDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVhZF9jb21w
bGV0ZWQ6IFdhcm5pbmcgLSBUWCBzdGF0dXMgcmVhZCBmYWlsZWQgLTcxCkF1ZyAxMCAxNDo0NTox
MCBSQ0JMcGkga2VybmVsOiBbICAzNDUuNjkxNTE2XSBydDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVh
ZF9jb21wbGV0ZWQ6IDc2OTkxIGNhbGxiYWNrcyBzdXBwcmVzc2VkCkF1ZyAxMCAxNDo0NToxMCBS
Q0JMcGkga2VybmVsOiBbICAzNDUuNjkxNTMwXSBpZWVlODAyMTEgcGh5NDogcnQyODAwdXNiX3R4
X3N0YV9maWZvX3JlYWRfY29tcGxldGVkOiBXYXJuaW5nIC0gVFggc3RhdHVzIHJlYWQgZmFpbGVk
IC03MQpBdWcgMTAgMTQ6NDU6MTAgUkNCTHBpIGtlcm5lbDogWyAgMzQ1LjY5MTYwM10gaWVlZTgw
MjExIHBoeTQ6IHJ0MjgwMHVzYl90eF9zdGFfZmlmb19yZWFkX2NvbXBsZXRlZDogV2FybmluZyAt
IFRYIHN0YXR1cyByZWFkIGZhaWxlZCAtNzEKQXVnIDEwIDE0OjQ1OjEwIFJDQkxwaSBrZXJuZWw6
IFsgIDM0NS42OTE3MDRdIGllZWU4MDIxMSBwaHk0OiBydDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVh
ZF9jb21wbGV0ZWQ6IFdhcm5pbmcgLSBUWCBzdGF0dXMgcmVhZCBmYWlsZWQgLTcxCkF1ZyAxMCAx
NDo0NToxMCBSQ0JMcGkga2VybmVsOiBbICAzNDUuNjkxODEwXSBpZWVlODAyMTEgcGh5NDogcnQy
ODAwdXNiX3R4X3N0YV9maWZvX3JlYWRfY29tcGxldGVkOiBXYXJuaW5nIC0gVFggc3RhdHVzIHJl
YWQgZmFpbGVkIC03MQpBdWcgMTAgMTQ6NDU6MTAgUkNCTHBpIGtlcm5lbDogWyAgMzQ1LjY5MTg3
N10gaWVlZTgwMjExIHBoeTQ6IHJ0MjgwMHVzYl90eF9zdGFfZmlmb19yZWFkX2NvbXBsZXRlZDog
V2FybmluZyAtIFRYIHN0YXR1cyByZWFkIGZhaWxlZCAtNzEKQXVnIDEwIDE0OjQ1OjEwIFJDQkxw
aSBrZXJuZWw6IFsgIDM0NS42OTE5NThdIGllZWU4MDIxMSBwaHk0OiBydDI4MDB1c2JfdHhfc3Rh
X2ZpZm9fcmVhZF9jb21wbGV0ZWQ6IFdhcm5pbmcgLSBUWCBzdGF0dXMgcmVhZCBmYWlsZWQgLTcx
CkF1ZyAxMCAxNDo0NToxMCBSQ0JMcGkga2VybmVsOiBbICAzNDUuNjkyMDI0XSBpZWVlODAyMTEg
cGh5NDogcnQyODAwdXNiX3R4X3N0YV9maWZvX3JlYWRfY29tcGxldGVkOiBXYXJuaW5nIC0gVFgg
c3RhdHVzIHJlYWQgZmFpbGVkIC03MQpBdWcgMTAgMTQ6NDU6MTAgUkNCTHBpIGtlcm5lbDogWyAg
MzQ1LjY5MjA5MV0gaWVlZTgwMjExIHBoeTQ6IHJ0MjgwMHVzYl90eF9zdGFfZmlmb19yZWFkX2Nv
bXBsZXRlZDogV2FybmluZyAtIFRYIHN0YXR1cyByZWFkIGZhaWxlZCAtNzEKQXVnIDEwIDE0OjQ1
OjEwIFJDQkxwaSBrZXJuZWw6IFsgIDM0NS42OTIxNzNdIGllZWU4MDIxMSBwaHk0OiBydDI4MDB1
c2JfdHhfc3RhX2ZpZm9fcmVhZF9jb21wbGV0ZWQ6IFdhcm5pbmcgLSBUWCBzdGF0dXMgcmVhZCBm
YWlsZWQgLTcxCkF1ZyAxMCAxNDo0NToxMCBSQ0JMcGkga2VybmVsOiBbICAzNDUuNjkyMjQxXSBp
ZWVlODAyMTEgcGh5NDogcnQyODAwdXNiX3R4X3N0YV9maWZvX3JlYWRfY29tcGxldGVkOiBXYXJu
aW5nIC0gVFggc3RhdHVzIHJlYWQgZmFpbGVkIC03MQpBdWcgMTAgMTQ6NDU6MTUgUkNCTHBpIGtl
cm5lbDogWyAgMzUwLjcwMTU4MF0gcnQyODAwdXNiX3R4X3N0YV9maWZvX3JlYWRfY29tcGxldGVk
OiA3NzAzMCBjYWxsYmFja3Mgc3VwcHJlc3NlZApBdWcgMTAgMTQ6NDU6MTUgUkNCTHBpIGtlcm5l
bDogWyAgMzUwLjcwMTU5Nl0gaWVlZTgwMjExIHBoeTQ6IHJ0MjgwMHVzYl90eF9zdGFfZmlmb19y
ZWFkX2NvbXBsZXRlZDogV2FybmluZyAtIFRYIHN0YXR1cyByZWFkIGZhaWxlZCAtNzEKQXVnIDEw
IDE0OjQ1OjE1IFJDQkxwaSBrZXJuZWw6IFsgIDM1MC43MDE3MjJdIGllZWU4MDIxMSBwaHk0OiBy
dDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVhZF9jb21wbGV0ZWQ6IFdhcm5pbmcgLSBUWCBzdGF0dXMg
cmVhZCBmYWlsZWQgLTcxCkF1ZyAxMCAxNDo0NToxNSBSQ0JMcGkga2VybmVsOiBbICAzNTAuNzAx
Nzg5XSBpZWVlODAyMTEgcGh5NDogcnQyODAwdXNiX3R4X3N0YV9maWZvX3JlYWRfY29tcGxldGVk
OiBXYXJuaW5nIC0gVFggc3RhdHVzIHJlYWQgZmFpbGVkIC03MQpBdWcgMTAgMTQ6NDU6MTUgUkNC
THBpIGtlcm5lbDogWyAgMzUwLjcwMTg3MF0gaWVlZTgwMjExIHBoeTQ6IHJ0MjgwMHVzYl90eF9z
dGFfZmlmb19yZWFkX2NvbXBsZXRlZDogV2FybmluZyAtIFRYIHN0YXR1cyByZWFkIGZhaWxlZCAt
NzEKQXVnIDEwIDE0OjQ1OjE1IFJDQkxwaSBrZXJuZWw6IFsgIDM1MC43MDE5MzVdIGllZWU4MDIx
MSBwaHk0OiBydDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVhZF9jb21wbGV0ZWQ6IFdhcm5pbmcgLSBU
WCBzdGF0dXMgcmVhZCBmYWlsZWQgLTcxCkF1ZyAxMCAxNDo0NToxNSBSQ0JMcGkga2VybmVsOiBb
ICAzNTAuNzAyMDAxXSBpZWVlODAyMTEgcGh5NDogcnQyODAwdXNiX3R4X3N0YV9maWZvX3JlYWRf
Y29tcGxldGVkOiBXYXJuaW5nIC0gVFggc3RhdHVzIHJlYWQgZmFpbGVkIC03MQpBdWcgMTAgMTQ6
NDU6MTUgUkNCTHBpIGtlcm5lbDogWyAgMzUwLjcwMjA4NF0gaWVlZTgwMjExIHBoeTQ6IHJ0Mjgw
MHVzYl90eF9zdGFfZmlmb19yZWFkX2NvbXBsZXRlZDogV2FybmluZyAtIFRYIHN0YXR1cyByZWFk
IGZhaWxlZCAtNzEKQXVnIDEwIDE0OjQ1OjE1IFJDQkxwaSBrZXJuZWw6IFsgIDM1MC43MDIxNTBd
IGllZWU4MDIxMSBwaHk0OiBydDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVhZF9jb21wbGV0ZWQ6IFdh
cm5pbmcgLSBUWCBzdGF0dXMgcmVhZCBmYWlsZWQgLTcxCkF1ZyAxMCAxNDo0NToxNSBSQ0JMcGkg
a2VybmVsOiBbICAzNTAuNzAyMjQxXSBpZWVlODAyMTEgcGh5NDogcnQyODAwdXNiX3R4X3N0YV9m
aWZvX3JlYWRfY29tcGxldGVkOiBXYXJuaW5nIC0gVFggc3RhdHVzIHJlYWQgZmFpbGVkIC03MQpB
dWcgMTAgMTQ6NDU6MTUgUkNCTHBpIGtlcm5lbDogWyAgMzUwLjcwMjMwN10gaWVlZTgwMjExIHBo
eTQ6IHJ0MjgwMHVzYl90eF9zdGFfZmlmb19yZWFkX2NvbXBsZXRlZDogV2FybmluZyAtIFRYIHN0
YXR1cyByZWFkIGZhaWxlZCAtNzEKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1
NS43MTE1ODldIHJ0MjgwMHVzYl90eF9zdGFfZmlmb19yZWFkX2NvbXBsZXRlZDogNzc3NzEgY2Fs
bGJhY2tzIHN1cHByZXNzZWQKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1NS43
MTE2MDNdIGllZWU4MDIxMSBwaHk0OiBydDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVhZF9jb21wbGV0
ZWQ6IFdhcm5pbmcgLSBUWCBzdGF0dXMgcmVhZCBmYWlsZWQgLTcxCkF1ZyAxMCAxNDo0NToyMCBS
Q0JMcGkga2VybmVsOiBbICAzNTUuNzExNjc0XSBpZWVlODAyMTEgcGh5NDogcnQyODAwdXNiX3R4
X3N0YV9maWZvX3JlYWRfY29tcGxldGVkOiBXYXJuaW5nIC0gVFggc3RhdHVzIHJlYWQgZmFpbGVk
IC03MQpBdWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAgMzU1LjcxMTc2M10gaWVlZTgw
MjExIHBoeTQ6IHJ0MjgwMHVzYl90eF9zdGFfZmlmb19yZWFkX2NvbXBsZXRlZDogV2FybmluZyAt
IFRYIHN0YXR1cyByZWFkIGZhaWxlZCAtNzEKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6
IFsgIDM1NS43MTE4MjldIGllZWU4MDIxMSBwaHk0OiBydDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVh
ZF9jb21wbGV0ZWQ6IFdhcm5pbmcgLSBUWCBzdGF0dXMgcmVhZCBmYWlsZWQgLTcxCkF1ZyAxMCAx
NDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAzNTUuNzExOTE3XSBpZWVlODAyMTEgcGh5NDogcnQy
ODAwdXNiX3R4X3N0YV9maWZvX3JlYWRfY29tcGxldGVkOiBXYXJuaW5nIC0gVFggc3RhdHVzIHJl
YWQgZmFpbGVkIC03MQpBdWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAgMzU1LjcxMTk4
M10gaWVlZTgwMjExIHBoeTQ6IHJ0MjgwMHVzYl90eF9zdGFfZmlmb19yZWFkX2NvbXBsZXRlZDog
V2FybmluZyAtIFRYIHN0YXR1cyByZWFkIGZhaWxlZCAtNzEKQXVnIDEwIDE0OjQ1OjIwIFJDQkxw
aSBrZXJuZWw6IFsgIDM1NS43MTIwNDhdIGllZWU4MDIxMSBwaHk0OiBydDI4MDB1c2JfdHhfc3Rh
X2ZpZm9fcmVhZF9jb21wbGV0ZWQ6IFdhcm5pbmcgLSBUWCBzdGF0dXMgcmVhZCBmYWlsZWQgLTcx
CkF1ZyAxMCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAzNTUuNzEyMTM1XSBpZWVlODAyMTEg
cGh5NDogcnQyODAwdXNiX3R4X3N0YV9maWZvX3JlYWRfY29tcGxldGVkOiBXYXJuaW5nIC0gVFgg
c3RhdHVzIHJlYWQgZmFpbGVkIC03MQpBdWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAg
MzU1LjcxMjE5OV0gaWVlZTgwMjExIHBoeTQ6IHJ0MjgwMHVzYl90eF9zdGFfZmlmb19yZWFkX2Nv
bXBsZXRlZDogV2FybmluZyAtIFRYIHN0YXR1cyByZWFkIGZhaWxlZCAtNzEKQXVnIDEwIDE0OjQ1
OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1NS43MTIyNjVdIGllZWU4MDIxMSBwaHk0OiBydDI4MDB1
c2JfdHhfc3RhX2ZpZm9fcmVhZF9jb21wbGV0ZWQ6IFdhcm5pbmcgLSBUWCBzdGF0dXMgcmVhZCBm
YWlsZWQgLTcxCkF1ZyAxMCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAzNTYuMTcxNDkyXSBJ
TkZPOiByY3Vfc2NoZWQgc2VsZi1kZXRlY3RlZCBzdGFsbCBvbiBDUFUKQXVnIDEwIDE0OjQ1OjIw
IFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzE1MjJdICAgMC0uLi46ICgyMDk5IHRpY2tzIHRoaXMg
R1ApIGlkbGU9NzJhLzE0MDAwMDAwMDAwMDAwMi8wIHNvZnRpcnE9MTE2MzIvMTE2MzIgZnFzPTEw
MDIKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzE1MjVdICAgICh0PTIx
MDAgamlmZmllcyBnPTU2MjYgYz01NjI1IHE9MTc1NjgpCkF1ZyAxMCAxNDo0NToyMCBSQ0JMcGkg
a2VybmVsOiBbICAzNTYuMTcxNTQxXSBOTUkgYmFja3RyYWNlIGZvciBjcHUgMApBdWcgMTAgMTQ6
NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAgMzU2LjE3MTU1M10gQ1BVOiAwIFBJRDogMTAwNyBDb21t
OiBrd29ya2VyL3U4OjE3IFRhaW50ZWQ6IEcgICAgICAgICBDICAgICAgNC4xNC42MS12NysgIzEK
QXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzE1NThdIEhhcmR3YXJlIG5h
bWU6IEJDTTI4MzUKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzE1ODhd
IFdvcmtxdWV1ZTogcGh5NCBydDJ4MDB1c2Jfd29ya19yeGRvbmUgW3J0MngwMHVzYl0KQXVnIDEw
IDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzE2MjJdIFs8ODAxMGZmYzA+XSAodW53
aW5kX2JhY2t0cmFjZSkgZnJvbSBbPDgwMTBjMWZjPl0gKHNob3dfc3RhY2srMHgyMC8weDI0KQpB
dWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAgMzU2LjE3MTY0MF0gWzw4MDEwYzFmYz5d
IChzaG93X3N0YWNrKSBmcm9tIFs8ODA3ODk0ZmM+XSAoZHVtcF9zdGFjaysweGM4LzB4MTBjKQpB
dWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAgMzU2LjE3MTY1OV0gWzw4MDc4OTRmYz5d
IChkdW1wX3N0YWNrKSBmcm9tIFs8ODA3OGY0M2M+XSAobm1pX2NwdV9iYWNrdHJhY2UrMHgxMWMv
MHgxMjApCkF1ZyAxMCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAzNTYuMTcxNjc2XSBbPDgw
NzhmNDNjPl0gKG5taV9jcHVfYmFja3RyYWNlKSBmcm9tIFs8ODA3OGY1MjA+XSAobm1pX3RyaWdn
ZXJfY3B1bWFza19iYWNrdHJhY2UrMHhlMC8weDEyYykKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBr
ZXJuZWw6IFsgIDM1Ni4xNzE2OTJdIFs8ODA3OGY1MjA+XSAobm1pX3RyaWdnZXJfY3B1bWFza19i
YWNrdHJhY2UpIGZyb20gWzw4MDEwZTY0OD5dIChhcmNoX3RyaWdnZXJfY3B1bWFza19iYWNrdHJh
Y2UrMHgyMC8weDI0KQpBdWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAgMzU2LjE3MTcx
MF0gWzw4MDEwZTY0OD5dIChhcmNoX3RyaWdnZXJfY3B1bWFza19iYWNrdHJhY2UpIGZyb20gWzw4
MDE4NTcxMD5dIChyY3VfZHVtcF9jcHVfc3RhY2tzKzB4YjAvMHhkYykKQXVnIDEwIDE0OjQ1OjIw
IFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzE3MjhdIFs8ODAxODU3MTA+XSAocmN1X2R1bXBfY3B1
X3N0YWNrcykgZnJvbSBbPDgwMTg1MGIwPl0gKHJjdV9jaGVja19jYWxsYmFja3MrMHg3ZTgvMHg5
NjApCkF1ZyAxMCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAzNTYuMTcxNzQ1XSBbPDgwMTg1
MGIwPl0gKHJjdV9jaGVja19jYWxsYmFja3MpIGZyb20gWzw4MDE4YjMxND5dICh1cGRhdGVfcHJv
Y2Vzc190aW1lcysweDQ0LzB4NzApCkF1ZyAxMCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAz
NTYuMTcxNzYyXSBbPDgwMThiMzE0Pl0gKHVwZGF0ZV9wcm9jZXNzX3RpbWVzKSBmcm9tIFs8ODAx
OWQzMmM+XSAodGlja19zY2hlZF9oYW5kbGUrMHg2NC8weDcwKQpBdWcgMTAgMTQ6NDU6MjAgUkNC
THBpIGtlcm5lbDogWyAgMzU2LjE3MTc3OV0gWzw4MDE5ZDMyYz5dICh0aWNrX3NjaGVkX2hhbmRs
ZSkgZnJvbSBbPDgwMTlkNTkwPl0gKHRpY2tfc2NoZWRfdGltZXIrMHg1MC8weGFjKQpBdWcgMTAg
MTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAgMzU2LjE3MTc5NV0gWzw4MDE5ZDU5MD5dICh0aWNr
X3NjaGVkX3RpbWVyKSBmcm9tIFs8ODAxOGMyY2M+XSAoX19ocnRpbWVyX3J1bl9xdWV1ZXMrMHgx
NTgvMHgyZWMpCkF1ZyAxMCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAzNTYuMTcxODEwXSBb
PDgwMThjMmNjPl0gKF9faHJ0aW1lcl9ydW5fcXVldWVzKSBmcm9tIFs8ODAxOGM3MDQ+XSAoaHJ0
aW1lcl9pbnRlcnJ1cHQrMHhiOC8weDIwYykKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6
IFsgIDM1Ni4xNzE4MjddIFs8ODAxOGM3MDQ+XSAoaHJ0aW1lcl9pbnRlcnJ1cHQpIGZyb20gWzw4
MDYzZGU3ND5dIChhcmNoX3RpbWVyX2hhbmRsZXJfcGh5cysweDQwLzB4NDgpCkF1ZyAxMCAxNDo0
NToyMCBSQ0JMcGkga2VybmVsOiBbICAzNTYuMTcxODQ2XSBbPDgwNjNkZTc0Pl0gKGFyY2hfdGlt
ZXJfaGFuZGxlcl9waHlzKSBmcm9tIFs8ODAxN2ExNTA+XSAoaGFuZGxlX3BlcmNwdV9kZXZpZF9p
cnErMHg4OC8weDIzYykKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzE4
NjNdIFs8ODAxN2ExNTA+XSAoaGFuZGxlX3BlcmNwdV9kZXZpZF9pcnEpIGZyb20gWzw4MDE3NDlm
Yz5dIChnZW5lcmljX2hhbmRsZV9pcnErMHgzNC8weDQ0KQpBdWcgMTAgMTQ6NDU6MjAgUkNCTHBp
IGtlcm5lbDogWyAgMzU2LjE3MTg3OV0gWzw4MDE3NDlmYz5dIChnZW5lcmljX2hhbmRsZV9pcnEp
IGZyb20gWzw4MDE3NTA1MD5dIChfX2hhbmRsZV9kb21haW5faXJxKzB4NmMvMHhjNCkKQXVnIDEw
IDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzE4OTRdIFs8ODAxNzUwNTA+XSAoX19o
YW5kbGVfZG9tYWluX2lycSkgZnJvbSBbPDgwMTAxNTIwPl0gKGJjbTI4MzZfYXJtX2lycWNoaXBf
aGFuZGxlX2lycSsweGFjLzB4YjApCkF1ZyAxMCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAz
NTYuMTcxOTExXSBbPDgwMTAxNTIwPl0gKGJjbTI4MzZfYXJtX2lycWNoaXBfaGFuZGxlX2lycSkg
ZnJvbSBbPDgwN2E0ZmZjPl0gKF9faXJxX3N2YysweDVjLzB4N2MpCkF1ZyAxMCAxNDo0NToyMCBS
Q0JMcGkga2VybmVsOiBbICAzNTYuMTcxOTE4XSBFeGNlcHRpb24gc3RhY2soMHhhZGJmZmFiMCB0
byAweGFkYmZmYWY4KQpBdWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAgMzU2LjE3MTky
N10gZmFhMDogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMDAwMDAwMDAgMDAw
MDAwMDAgYTk4MGJkMDAgMDAwMDAwMDAKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsg
IDM1Ni4xNzE5MzldIGZhYzA6IGI3NzE2ZTgwIDYwMDAwMTEzIGI5ZmJlNDAwIGFkYWU5OWQwIDAw
MDAwMDAxIGFkYmZlMDAwIDAwMDAwMDAxIGFkYmZmYjFjCkF1ZyAxMCAxNDo0NToyMCBSQ0JMcGkg
a2VybmVsOiBbICAzNTYuMTcxOTQ5XSBmYWUwOiBhZGJmZmIwMCBhZGJmZmIwMCA4MDViMzM4OCA4
MDViMzM5YyA2MDAwMDExMyBmZmZmZmZmZgpBdWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDog
WyAgMzU2LjE3MTk2OV0gWzw4MDdhNGZmYz5dIChfX2lycV9zdmMpIGZyb20gWzw4MDViMzM5Yz5d
IChfX3VzYl9oY2RfZ2l2ZWJhY2tfdXJiKzB4MTE4LzB4MTVjKQpBdWcgMTAgMTQ6NDU6MjAgUkNC
THBpIGtlcm5lbDogWyAgMzU2LjE3MTk4OF0gWzw4MDViMzM5Yz5dIChfX3VzYl9oY2RfZ2l2ZWJh
Y2tfdXJiKSBmcm9tIFs8ODA1YjM1MzA+XSAodXNiX2hjZF9naXZlYmFja191cmIrMHg0Yy8weGZj
KSAKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzIwMDZdIFs8ODA1YjM1
MzA+XSAodXNiX2hjZF9naXZlYmFja191cmIpIGZyb20gWzw4MDVkZGU0MD5dIChjb21wbGV0aW9u
X3Rhc2tsZXRfZnVuYysweDgwLzB4YWMpCkF1ZyAxMCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBb
ICAzNTYuMTcyMDI0XSBbPDgwNWRkZTQwPl0gKGNvbXBsZXRpb25fdGFza2xldF9mdW5jKSBmcm9t
IFs8ODA1ZWNjNjA+XSAodGFza2xldF9jYWxsYmFjaysweDIwLzB4MjQpCkF1ZyAxMCAxNDo0NToy
MCBSQ0JMcGkga2VybmVsOiBbICAzNTYuMTcyMDQwXSBbPDgwNWVjYzYwPl0gKHRhc2tsZXRfY2Fs
bGJhY2spIGZyb20gWzw4MDEyM2FjND5dICh0YXNrbGV0X2hpX2FjdGlvbisweDcwLzB4MTA0KQpB
dWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAgMzU2LjE3MjA1NV0gWzw4MDEyM2FjND5d
ICh0YXNrbGV0X2hpX2FjdGlvbikgZnJvbSBbPDgwMTAxNjljPl0gKF9fZG9fc29mdGlycSsweDE3
NC8weDNkOCkKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzIwNjldIFs8
ODAxMDE2OWM+XSAoX19kb19zb2Z0aXJxKSBmcm9tIFs8ODAxMjM2YTg+XSAoaXJxX2V4aXQrMHhl
NC8weDE0MCkKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzIwODNdIFs8
ODAxMjM2YTg+XSAoaXJxX2V4aXQpIGZyb20gWzw4MDE3NTA1ND5dIChfX2hhbmRsZV9kb21haW5f
aXJxKzB4NzAvMHhjNCkKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzIw
OTddIFs8ODAxNzUwNTQ+XSAoX19oYW5kbGVfZG9tYWluX2lycSkgZnJvbSBbPDgwMTAxNTIwPl0g
KGJjbTI4MzZfYXJtX2lycWNoaXBfaGFuZGxlX2lycSsweGFjLzB4YjApCkF1ZyAxMCAxNDo0NToy
MCBSQ0JMcGkga2VybmVsOiBbICAzNTYuMTcyMTExXSBbPDgwMTAxNTIwPl0gKGJjbTI4MzZfYXJt
X2lycWNoaXBfaGFuZGxlX2lycSkgZnJvbSBbPDgwN2E0ZmZjPl0gKF9faXJxX3N2YysweDVjLzB4
N2MpCkF1ZyAxMCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAzNTYuMTcyMTE3XSBFeGNlcHRp
b24gc3RhY2soMHhhZGJmZmM1OCB0byAweGFkYmZmY2EwKQpBdWcgMTAgMTQ6NDU6MjAgUkNCTHBp
IGtlcm5lbDogWyAgMzU2LjE3MjEyNV0gZmM0MDogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgYjlkODNhNDAgMDAwMDAwMDAKQXVnIDEwIDE0OjQ1
OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzIxMzZdIGZjNjA6IDAwMDAwMDAxIDAwMDAwMDAw
IDYwMDAwMDEzIDAwMDAwMDAwIGFhMmQ0YjAwIGE5OTQ5NjAwIGI5ZGIwNDAwIGI5ZmJlNDAwCkF1
ZyAxMCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAzNTYuMTcyMTQ4XSBmYzgwOiAwMDAwMDAw
MCBhZGJmZmNiYyBhZGJmZmNhOCBhZGJmZmNhOCA4MDdhNGQyYyA4MDdhNGQ0MCA2MDAwMDAxMyBm
ZmZmZmZmZgpBdWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAgMzU2LjE3MjE2NF0gWzw4
MDdhNGZmYz5dIChfX2lycV9zdmMpIGZyb20gWzw4MDdhNGQ0MD5dIChfcmF3X3NwaW5fdW5sb2Nr
X2lycXJlc3RvcmUrMHg1MC8weDcwKQpBdWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAg
MzU2LjE3MjE4MF0gWzw4MDdhNGQ0MD5dIChfcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUpIGZy
b20gWzw4MDVlY2JmOD5dIChEV0NfU1BJTlVOTE9DS19JUlFSRVNUT1JFKzB4MTgvMHgxYykKQXVn
IDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzIxOTZdIFs8ODA1ZWNiZjg+XSAo
RFdDX1NQSU5VTkxPQ0tfSVJRUkVTVE9SRSkgZnJvbSBbPDgwNWUyN2Y0Pl0gKGR3Y19vdGdfdXJi
X2VucXVldWUrMHgxZGMvMHgzMWMpCkF1ZyAxMCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAz
NTYuMTcyMjEyXSBbPDgwNWUyN2Y0Pl0gKGR3Y19vdGdfdXJiX2VucXVldWUpIGZyb20gWzw4MDVi
NGYzND5dICh1c2JfaGNkX3N1Ym1pdF91cmIrMHhjOC8weDkzNCkKQXVnIDEwIDE0OjQ1OjIwIFJD
QkxwaSBrZXJuZWw6IFsgIDM1Ni4xNzIyMjZdIFs8ODA1YjRmMzQ+XSAodXNiX2hjZF9zdWJtaXRf
dXJiKSBmcm9tIFs8ODA1YjY4N2M+XSAodXNiX3N1Ym1pdF91cmIrMHgyODQvMHg1MTApCkF1ZyAx
MCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAzNTYuMTcyMjUwXSBbPDgwNWI2ODdjPl0gKHVz
Yl9zdWJtaXRfdXJiKSBmcm9tIFs8N2Y0YTc2ZTA+XSAocnQyeDAwdXNiX2tpY2tfcnhfZW50cnkr
MHhiNC8weGZjIFtydDJ4MDB1c2JdKQpBdWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAg
MzU2LjE3MjI5Nl0gWzw3ZjRhNzZlMD5dIChydDJ4MDB1c2Jfa2lja19yeF9lbnRyeSBbcnQyeDAw
dXNiXSkgZnJvbSBbPDdmNGE3NzU4Pl0gKHJ0MngwMHVzYl9jbGVhcl9lbnRyeSsweDMwLzB4MzQg
W3J0MngwMHVzYl0pCkF1ZyAxMCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAzNTYuMTcyMzU0
XSBbPDdmNGE3NzU4Pl0gKHJ0MngwMHVzYl9jbGVhcl9lbnRyeSBbcnQyeDAwdXNiXSkgZnJvbSBb
PDdmNDkyYTQ0Pl0gKHJ0MngwMGxpYl9yeGRvbmUrMHgxNDgvMHg1YjggW3J0MngwMGxpYl0pCkF1
ZyAxMCAxNDo0NToyMCBSQ0JMcGkga2VybmVsOiBbICAzNTYuMTcyNDEyXSBbPDdmNDkyYTQ0Pl0g
KHJ0MngwMGxpYl9yeGRvbmUgW3J0MngwMGxpYl0pIGZyb20gWzw3ZjRhODA4OD5dIChydDJ4MDB1
c2Jfd29ya19yeGRvbmUrMHg1OC8weDhjIFtydDJ4MDB1c2JdKQpBdWcgMTAgMTQ6NDU6MjAgUkNC
THBpIGtlcm5lbDogWyAgMzU2LjE3MjQ0MF0gWzw3ZjRhODA4OD5dIChydDJ4MDB1c2Jfd29ya19y
eGRvbmUgW3J0MngwMHVzYl0pIGZyb20gWzw4MDEzNzM4ND5dIChwcm9jZXNzX29uZV93b3JrKzB4
MjI0LzB4NTE4KQpBdWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAgMzU2LjE3MjQ1OV0g
Wzw4MDEzNzM4ND5dIChwcm9jZXNzX29uZV93b3JrKSBmcm9tIFs8ODAxMzgzNWM+XSAod29ya2Vy
X3RocmVhZCsweDYwLzB4NWYwKQpBdWcgMTAgMTQ6NDU6MjAgUkNCTHBpIGtlcm5lbDogWyAgMzU2
LjE3MjQ3Nl0gWzw4MDEzODM1Yz5dICh3b3JrZXJfdGhyZWFkKSBmcm9tIFs8ODAxM2RiNjg+XSAo
a3RocmVhZCsweDE0NC8weDE3NCkKQXVnIDEwIDE0OjQ1OjIwIFJDQkxwaSBrZXJuZWw6IFsgIDM1
Ni4xNzI0OTJdIFs8ODAxM2RiNjg+XSAoa3RocmVhZCkgZnJvbSBbPDgwMTA4MGFjPl0gKHJldF9m
cm9tX2ZvcmsrMHgxNC8weDI4KQpBdWcgMTAgMTQ6NDU6MjIgUkNCTHBpIGtlcm5lbDogWyAgMzU3
LjU5MTUxOF0gSU5GTzogcmN1X3NjaGVkIGRldGVjdGVkIGV4cGVkaXRlZCBzdGFsbHMgb24gQ1BV
cy90YXNrczogeyAwLS4uLiB9IDIxMDkgamlmZmllcyBzOiAyMjEgcm9vdDogMHgxLy4KQXVnIDEw
IDE0OjQ1OjIyIFJDQkxwaSBrZXJuZWw6IFsgIDM1Ny41OTE1NDVdIGJsb2NraW5nIHJjdV9ub2Rl
IHN0cnVjdHVyZXM6CkF1ZyAxMCAxNDo0NToyMiBSQ0JMcGkga2VybmVsOiBbICAzNTcuNTkxNTU0
XSBUYXNrIGR1bXAgZm9yIENQVSAwOgpBdWcgMTAgMTQ6NDU6MjIgUkNCTHBpIGtlcm5lbDogWyAg
MzU3LjU5MTU2MF0ga3dvcmtlci91ODoxNyAgIFIgIHJ1bm5pbmcgdGFzayAgICAgICAgMCAgMTAw
NyAgICAgIDIgMHgwMDAwMDAwMgpBdWcgMTAgMTQ6NDU6MjIgUkNCTHBpIGtlcm5lbDogWyAgMzU3
LjU5MTYwM10gV29ya3F1ZXVlOiBwaHk0IHJ0MngwMHVzYl93b3JrX3J4ZG9uZSBbcnQyeDAwdXNi
XQpBdWcgMTAgMTQ6NDU6MjUgUkNCTHBpIGtlcm5lbDogWyAgMzYwLjcyMTUzN10gcnQyODAwdXNi
X3R4X3N0YV9maWZvX3JlYWRfY29tcGxldGVkOiA3Nzg4NiBjYWxsYmFja3Mgc3VwcHJlc3NlZApB
dWcgMTAgMTQ6NDU6MjUgUkNCTHBpIGtlcm5lbDogWyAgMzYwLjcyMTU1Ml0gaWVlZTgwMjExIHBo
eTQ6IHJ0MjgwMHVzYl90eF9zdGFfZmlmb19yZWFkX2NvbXBsZXRlZDogV2FybmluZyAtIFRYIHN0
YXR1cyByZWFkIGZhaWxlZCAtNzEKQXVnIDEwIDE0OjQ1OjI1IFJDQkxwaSBrZXJuZWw6IFsgIDM2
MC43MjE2NTFdIGllZWU4MDIxMSBwaHk0OiBydDI4MDB1c2JfdHhfc3RhX2ZpZm9fcmVhZF9jb21w
bGV0ZWQ6IFdhcm5pbmcgLSBUWCBzdGF0dXMgcmVhZCBmYWlsZWQgLTcxCkF1ZyAxMCAxNDo0NToy
NSBSQ0JMcGkga2VybmVsOiBbICAzNjAuNzIxNzIwXSBpZWVlODAyMTEgcGh5NDogcnQyODAwdXNi
X3R4X3N0YV9maWZvX3JlYWRfY29tcGxldGVkOiBXYXJuaW5nIC0gVFggc3RhdHVzIHJlYWQgZmFp
bGVkIC03MQo=
--000000000000783e39057385d646--
