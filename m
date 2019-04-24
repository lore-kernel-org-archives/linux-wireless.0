Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E191EC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 06:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 975E42089F
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 06:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VuctzSUX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbfDXGNr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 02:13:47 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39996 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbfDXGNr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 02:13:47 -0400
Received: by mail-oi1-f196.google.com with SMTP id k10so2840978oik.7
        for <linux-wireless@vger.kernel.org>; Tue, 23 Apr 2019 23:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K48VN97+2CcsQZQpyVt493Gfj5mZZ5l+NKN9njw/cjw=;
        b=VuctzSUXFYvzuIYDZPFSryqmS9a1tKuwOxs6k4wMqD0NeISaY/2D4FOesdihJlbJsR
         5IbJ8QZzz5J2ZT/9mU3Js2mYpSoPSrsiOxvNvHXvNlXRYFxG1c8iR3E/CixumH3EKPaT
         HKLp7gufvMwssD8nTA55btC3LRnrE0Mjc6U3iXz09nOVd+WM72UHr/0J96DAaqGWM2wP
         nW68ghRyVdsbDvxQFkH5TeK7DhlVberawbzl71W2TtMKmVFcI+ocvWDg6tJTwnJSxH6G
         lrp2OF9ylOOKxRNMsG3jYqJtNSJrR9qBdqHU+tCYv2fy0fZS1bJeJzH31UjxRL0TzX3P
         Fg4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K48VN97+2CcsQZQpyVt493Gfj5mZZ5l+NKN9njw/cjw=;
        b=UmPfm/l+LhoiiAtzjkdsxeBuQGBi82mXxtrEkZ1FxiR7pVnEH0eZHvlHXxGqSqRxPG
         rIyRb4LIJoCM6LuBpgWkq9Zg3ogFPJ+CQGSPw457RkwfVHeSYLWj/zBH89rL+lf5y1vG
         rDZn68mCWEFnIVAjEBBfdy/zTkmP7N0sCJ8JpR+UQCDM33GgC7/zCmjNyNSNO6Oal3OM
         3LNZgnktgvh6T0cQUayfvuty0RUSUF3nx8f/vn+GgMjpSphVHUvF6nD6oxFbdznCthoC
         DMXTq0WLlws3E0Qhr9EZRjnUzFu/3MQTOi6guHLbsdL9h//AWisIcYO/qrfpYiA3JCtq
         +2tA==
X-Gm-Message-State: APjAAAUVZGyWGGjwcxlEcVUPiAhWeV+V2VM3ZD76XhsUfXUx+wS/KgeE
        j93EQFRxftVGyjrji9Q8mJH7JokXBdN7Mdnp+7nUKz81u6Y=
X-Google-Smtp-Source: APXvYqyAqMyaULcvR2OPHHZPOSdIZjrTVdeTuZrj9Nyq1+d9gCBAms6VKUigS1inMWNhUuXEDg7d3Tlii5Xbgoz11+Q=
X-Received: by 2002:aca:b288:: with SMTP id b130mr4160609oif.154.1556086426150;
 Tue, 23 Apr 2019 23:13:46 -0700 (PDT)
MIME-Version: 1.0
References: <c8fc9821-3055-8110-fe57-34f06a6b0296@gmail.com> <CAMrEMU85ydLqs-vG5r0nVSgDvdvLQaeKfBiaSnfB6XtMOauuXA@mail.gmail.com>
In-Reply-To: <CAMrEMU85ydLqs-vG5r0nVSgDvdvLQaeKfBiaSnfB6XtMOauuXA@mail.gmail.com>
From:   Justin Capella <justincapella@gmail.com>
Date:   Tue, 23 Apr 2019 23:13:34 -0700
Message-ID: <CAMrEMU_UmRobieM3T=H9Vi9ZmrdYMXg92HkhPW=00gb_=PnjhA@mail.gmail.com>
Subject: Re: ath10k: issue with TX queue scheduling
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        johannes@sipsolutions.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sorry, I didn't say that correctly.

Does maybe the userspace notification of cfg80211 for sta opmode
changes support multiple simulateous changes, whereas rx only ever
need s to handle one at a time? Not sure where this might get
initialized / how long it is kept around but in one place its being
treated as an enum and in another like a bitset/flags.

Does the sta opmode change maybe sometimes cause the queue to be
handled in an unexpected manner?

On Tue, Apr 23, 2019 at 9:13 PM Justin Capella <justincapella@gmail.com> wrote:
>
> I was experiencing this as well, QCA988x-- it eventually lead to a fw
> crash / module unload, because it would cause reconfig to close the
> device, which I think wound up not existing later on.
>
> [257455.643737] WARNING: CPU: 0 PID: 708 at
> net/mac80211/driver-ops.c:39 drv_stop+0xdc/0xf0 [mac80211]
> [257455.643738] Modules linked in: cmac ccm arc4 xt_tcpudp
> xt_conntrack iptable_filter ipt_MASQUERADE iptable_nat nf_nat_ipv4
> nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c
> intel_powerclamp ath10k_pci coretemp kvm_intel ath10k_core kvm ath
> mac80211 irqbypass crct10dif_pclmul crc32_pclmul ofpart
> ghash_clmulni_intel cmdlinepart pcbc intel_spi_platform intel_spi
> spi_nor mtd iTCO_wdt iTCO_vendor_support cfg80211 igb aesni_intel
> aes_x86_64 crypto_simd lpc_ich uas cryptd glue_helper intel_cstate
> pcspkr i2c_i801 usb_storage i2c_algo_bit i2c_ismt dca rfkill evdev
> pcc_cpufreq mac_hid acpi_cpufreq ip_tables x_tables ext4
> crc32c_generic crc16 mbcache jbd2 fscrypto sd_mod ahci libahci libata
> scsi_mod crc32c_intel ehci_pci ehci_hcd
> [257455.643812] CPU: 0 PID: 708 Comm: kworker/0:0 Tainted: G        W
>        4.19.28-1-lts #1
> [257455.643813] Hardware name: ADI Engineering DFFv2/DFFv2, BIOS
> ADI_DFF2-01.00.00.12-nodebug 02/07/2017
> [257455.643846] Workqueue: events_freezable ieee80211_restart_work [mac80211]
> [257455.643879] RIP: 0010:drv_stop+0xdc/0xf0 [mac80211]
> [257455.643883] Code: 51 0b 00 48 85 ed 74 1d 48 8b 45 00 48 8b 7d 08
> 48 83 c5 18 48 89 de e8 b2 48 4c fb 48 8b 45 00 48 85 c0 75 e7 e9 58
> ff ff ff <0f> 0b 5b 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00
> 0f 1f
> [257455.643884] RSP: 0018:ffffa8e680f3fca8 EFLAGS: 00010246
> [257455.643887] RAX: 0000000000000000 RBX: ffff941c378b68c0 RCX:
> 0000000000000000
> [257455.643889] RDX: ffff941c3c889c80 RSI: 0000000000000286 RDI:
> ffff941c378f0760
> [257455.643894] RBP: ffff941c378f0ff0 R08: 0000000000000000 R09:
> 0000000000000000
> [257455.643896] R10: ffff941c3cc00028 R11: 0000000000000000 R12:
> ffff941c378f0b88
> [257455.643898] R13: ffff941c378f0ee8 R14: ffff941c378f0760 R15:
> ffff941c378b73a0
> [257455.643900] FS:  0000000000000000(0000) GS:ffff941c3d600000(0000)
> knlGS:0000000000000000
> [257455.643902] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [257455.643904] CR2: 0000561e406179b0 CR3: 000000007a0ae000 CR4:
> 00000000001006f0
> [257455.643906] Call Trace:
> [257455.643943]  ieee80211_do_stop+0x5ab/0x850 [mac80211]
> [257455.643979]  ieee80211_stop+0x16/0x20 [mac80211]
> [257455.643983]  __dev_close_many+0x9c/0x110
> [257455.643987]  dev_close_many+0x88/0x140
> [257455.643994]  dev_close.part.18+0x44/0x70
> [257455.644032]  cfg80211_shutdown_all_interfaces+0x6d/0xc0 [cfg80211]
> [257455.644069]  ieee80211_reconfig+0xa5/0x1280 [mac80211]
> [257455.644074]  ? rcu_exp_wait_wake+0x240/0x240
> [257455.644077]  ? try_to_del_timer_sync+0x4d/0x80
> [257455.644112]  ieee80211_restart_work+0xbb/0xe0 [mac80211]
> [257455.644117]  process_one_work+0x1f4/0x3e0
> [257455.644121]  worker_thread+0x2d/0x3e0
> [257455.644125]  ? process_one_work+0x3e0/0x3e0
> [257455.644128]  kthread+0x112/0x130
> [257455.644131]  ? kthread_park+0x80/0x80
> [257455.644136]  ret_from_fork+0x35/0x40
> [257455.644139] ---[ end trace 535d7b67d6e7df8f ]---
>
> The one common thing I was seeing was that before the TX queue stall:
> Apr 12 00:21:09 archlinux kernel: ath10k_pci 0000:01:00.0: failed to
> flush transmit queue (skip 1 ar-state 0): 500
>
> Was that a station had set caused "STA_OPMODE_SMPS_MODE_CHANGED" / smps dynamic.
>
> I did notice there was recent additions regarding sending that up to
> userspace, I don't know if actually related or not, but it seemed to
> always happen prior. The other thing I noticed was that htt.c uses =
> (not |=) and rx.c uses a &. Maybe this is intentional / not an issue,
> but it got me scratching my head wondering if perhaps multiple such
> sta mgmt frames were being queued/processed and this somehow impacted
> how things were being TX'd, or processed. Not sure if maybe only ever
> one such chane occurs in a given frame, whereas the rx side may
> support multiple changes for other reasons.
>
> Let me know if I can help troubleshoot / provide any more info
>
> On Tue, Apr 23, 2019 at 7:59 AM Erik Stromdahl <erik.stromdahl@gmail.com> wrote:
> >
> > Hello ath10k and mac80211 developers!
> >
> > I have run into an issue with ath10k SDIO and iperf TX.
> >
> > When running an iperf test (ath10k as server, PC as client),
> > I get a totally stalled transmitter on the ath10k side after some time.
> >
> > [  3] 574.0-575.0 sec  3.25 MBytes  27.3 Mbits/sec
> > [  3] 575.0-576.0 sec   255 KBytes  2.09 Mbits/sec
> > [  3] 576.0-577.0 sec  0.00 Bytes  0.00 bits/sec
> > [  3] 577.0-578.0 sec  0.00 Bytes  0.00 bits/sec
> >
> > Niklas Cassel had the same issue ~1 year ago and he made a fix in commit
> > 3f04950f32d5
> >
> > After this everything has been working fine until lately when I ran into the
> > same issue again.
> >
> > The problem seems to have reappeared after the new mac80211 TX scheduling
> > was introduced. I have not bisected or anything, but last time I was doing
> > these tests was before the introduction of the new TX scheduling, and then
> > everything was working.
> >
> > Niklas fix was to add a call to ath10k_mac_tx_push_pending() in
> > ath10k_sdio_irq_handler() in order to make sure we never get into a situation
> > where we have messages in the ath10k internal queue, but with TX queuing stopped.
> >
> > Since the introduction of the new TX scheduling, the driver internal queue
> > has been removed (there used to be a txqs member in struct ath10k that was
> > removed in commit bb2edb733586 by Toke). So I am unsure if Niklas commit is
> > still needed. At least it does not seem to fix this issue anymore.
> >
> > Are there any nice mac80211 kernel config options available that could
> > ease debugging queuing related issues?
> > Some kind of tracing feature for the TX scheduling perhaps?
> >
> > All tips/hints are welcome!
> >
> > P.S.
> >
> > When I run into the error I also get the below RCU stall splat (~20 seconds after
> > the bitrate has dropped down to 0 bit/s):
> >
> > rcu: INFO: rcu_sched self-detected stall on CPU
> > rcu:    0-....: (2600 ticks this GP) idle=02a/1/0x40000002 softirq=1107/1107 fqs=1294
> > rcu:     (t=2602 jiffies g=633 q=102)
> > NMI backtrace for cpu 0
> > CPU: 0 PID: 120 Comm: irq/64-mmc0 Tainted: G      D           5.1.0-rc3-wt-ath+ #31
> > Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> > Backtrace:
> > [<c010ecec>] (dump_backtrace) from [<c010efec>] (show_stack+0x20/0x24)
> >   r7:00000000 r6:60010193 r5:00000000 r4:c14e9ecc
> > [<c010efcc>] (show_stack) from [<c0cf5674>] (dump_stack+0xdc/0x114)
> > [<c0cf5598>] (dump_stack) from [<c0cfcd0c>] (nmi_cpu_backtrace+0xac/0xbc)
> >   r10:80010193 r9:c14149fc r8:c0e02fd8 r7:00000000 r6:c0112318 r5:00000000
> >   r4:00000000 r3:02fc7d23
> > [<c0cfcc60>] (nmi_cpu_backtrace) from [<c0cfce04>] (nmi_trigger_cpumask_backtrace+0xe8/0x13c)
> >   r5:c1418a30 r4:00000000
> > [<c0cfcd1c>] (nmi_trigger_cpumask_backtrace) from [<c01132cc>] (arch_trigger_cpumask_backtrace+0x1c/0x24)
> >   r9:c14149fc r8:c142a880 r7:00000240 r6:c0e02fd4 r5:c1414978 r4:c142a880
> > [<c01132b0>] (arch_trigger_cpumask_backtrace) from [<c01b6220>] (rcu_dump_cpu_stacks+0xb8/0xfc)
> > [<c01b6168>] (rcu_dump_cpu_stacks) from [<c01b42a8>] (rcu_sched_clock_irq+0x890/0x9c0)
> >   r10:00000066 r9:c142a880 r8:c1414970 r7:c14f30f0 r6:c1405900 r5:c1414ed4
> >   r4:e671b100
> > [<c01b3a18>] (rcu_sched_clock_irq) from [<c01be570>] (update_process_times+0x40/0x6c)
> >   r10:c14150fc r9:e6716740 r8:c1414970 r7:00000027 r6:00000000 r5:d261f2c0
> >   r4:ffffe000
> > [<c01be530>] (update_process_times) from [<c01d4d04>] (tick_sched_handle+0x64/0x68)
> >   r7:00000027 r6:97c52581 r5:d288fba8 r4:e6716c00
> > [<c01d4ca0>] (tick_sched_handle) from [<c01d4fd8>] (tick_sched_timer+0x6c/0xd0)
> > [<c01d4f6c>] (tick_sched_timer) from [<c01bf3e0>] (__hrtimer_run_queues+0x1a8/0x5ac)
> >   r7:c01d4f6c r6:e67167a0 r5:e6716740 r4:e6716c00
> > [<c01bf238>] (__hrtimer_run_queues) from [<c01c08c0>] (hrtimer_interrupt+0x124/0x2ec)
> >   r10:e6716880 r9:ffffffff r8:7fffffff r7:e6716840 r6:00000003 r5:20010193
> >   r4:e6716740
> > [<c01c079c>] (hrtimer_interrupt) from [<c0113cec>] (twd_handler+0x3c/0x50)
> >   r10:c14f2cf4 r9:c1414ed4 r8:00000010 r7:c1414970 r6:c1415110 r5:d20d4900
> >   r4:00000001
> > [<c0113cb0>] (twd_handler) from [<c019eb50>] (handle_percpu_devid_irq+0xec/0x394)
> >   r5:d20d4900 r4:d2037800
> > [<c019ea64>] (handle_percpu_devid_irq) from [<c0197e48>] (generic_handle_irq+0x30/0x44)
> >   r10:c146c114 r9:d2024400 r8:00000001 r7:00000000 r6:c1414ed4 r5:00000010
> >   r4:c13e4450
> > [<c0197e18>] (generic_handle_irq) from [<c0198554>] (__handle_domain_irq+0x74/0xf0)
> > [<c01984e0>] (__handle_domain_irq) from [<c01024b4>] (gic_handle_irq+0x68/0xcc)
> >   r9:d288fba8 r8:c1415110 r7:f4000100 r6:000003ff r5:000003eb r4:f400010c
> > [<c010244c>] (gic_handle_irq) from [<c0101a70>] (__irq_svc+0x70/0x98)
> > Exception stack(0xd288fba8 to 0xd288fbf0)
> > fba0:                   c013417c 00000000 60010093 d288e000 000001ff ffffe000
> > fbc0: c0cb7340 00000003 d2fd86a0 d28c2000 d2fd86a0 d288fc14 d288fbc8 d288fbf8
> > fbe0: c0213544 c0134180 60010013 ffffffff
> >   r10:d2fd86a0 r9:d288e000 r8:d2fd86a0 r7:d288fbdc r6:ffffffff r5:60010013
> >   r4:c0134180
> > [<c01340c8>] (__local_bh_enable_ip) from [<c0d18b84>] (_raw_spin_unlock_bh+0x40/0x44)
> >   r7:00000003 r6:d21a88c0 r5:d2fd873c r4:c0cb7340
> > [<c0d18b44>] (_raw_spin_unlock_bh) from [<c0cb7340>] (_ieee80211_wake_txqs+0x394/0x6d4)
> >   r5:d21a88c0 r4:00000000
> > [<c0cb6fac>] (_ieee80211_wake_txqs) from [<c0cba838>] (ieee80211_wake_txqs+0x44/0x70)
> >   r10:00000006 r9:00000000 r8:00000000 r7:e6711404 r6:d2fd86a0 r5:d2fd8b10
> >   r4:c1414948
> > [<c0cba7f4>] (ieee80211_wake_txqs) from [<c0134a04>] (tasklet_action_common.constprop.5+0x64/0xec)
> >   r6:00000000 r5:d2fd908c r4:d2fd9088
> > [<c01349a0>] (tasklet_action_common.constprop.5) from [<c0134ac8>] (tasklet_action+0x3c/0x48)
> >   r10:00000040 r9:00000101 r8:c1414970 r7:c14f2ca4 r6:00000006 r5:c1403098
> >   r4:00000007 r3:25336000
> > [<c0134a8c>] (tasklet_action) from [<c0102610>] (__do_softirq+0xf8/0x54c)
> > [<c0102518>] (__do_softirq) from [<c01340bc>] (do_softirq.part.4+0x78/0x84)
> >   r10:d21a87cc r9:00000000 r8:00000000 r7:d2fd9e30 r6:bf058104 r5:ffffe000
> >   r4:60010093
> > [<c0134044>] (do_softirq.part.4) from [<c01341fc>] (__local_bh_enable_ip+0x134/0x18c)
> >   r5:ffffe000 r4:000001ff
> > [<c01340c8>] (__local_bh_enable_ip) from [<c0d18b84>] (_raw_spin_unlock_bh+0x40/0x44)
> >   r7:d2fd9e30 r6:d2fd9d38 r5:d2fd9e30 r4:bf058104
> > [<c0d18b44>] (_raw_spin_unlock_bh) from [<bf058104>] (ath10k_mac_tx_push_txq+0x294/0x2a4 [ath10k_core])
> >   r5:d2fd9540 r4:d33220dc
> > [<bf057e70>] (ath10k_mac_tx_push_txq [ath10k_core]) from [<bf05820c>] (ath10k_mac_tx_push_pending+0xf8/0x1ec [ath10k_core])
> >   r10:ffffe8ed r9:d2d96540 r8:fffffffe r7:00000002 r6:00000002 r5:d33220dc
> >   r4:d2fd86a0
> > [<bf058114>] (ath10k_mac_tx_push_pending [ath10k_core]) from [<bf0e2544>] (ath10k_sdio_irq_handler+0x308/0x4d4 [ath10k_sdio])
> >   r8:01340202 r7:d2fde540 r6:d2fde87c r5:00000000 r4:d2fd9540
> > [<bf0e223c>] (ath10k_sdio_irq_handler [ath10k_sdio]) from [<c08e86c0>] (process_sdio_pending_irqs+0x4c/0x1bc)
> >   r10:d287bb80 r9:d22a7400 r8:00000001 r7:00000000 r6:d284c800 r5:c1414948
> >   r4:d2859000
> > [<c08e8674>] (process_sdio_pending_irqs) from [<c08e887c>] (sdio_run_irqs+0x4c/0x68)
> >   r10:d287bb80 r9:d22a7400 r8:00000001 r7:00000000 r6:d28596a0 r5:00000100
> >   r4:d2859000
> > [<c08e8830>] (sdio_run_irqs) from [<c08f3d00>] (sdhci_thread_irq+0x80/0xbc)
> >   r5:00000100 r4:d28594c0
> > [<c08f3c80>] (sdhci_thread_irq) from [<c019a718>] (irq_thread_fn+0x2c/0x88)
> >   r7:00000000 r6:d287bba4 r5:d22a7400 r4:d287bb80
> > [<c019a6ec>] (irq_thread_fn) from [<c019aa54>] (irq_thread+0x120/0x22c)
> >   r7:00000000 r6:d287bba4 r5:ffffe000 r4:00000000
> > [<c019a934>] (irq_thread) from [<c015526c>] (kthread+0x154/0x168)
> >   r10:d2101bd8 r9:c019a934 r8:d287bb80 r7:d288e000 r6:d287bbc0 r5:d2241400
> >   r4:00000000
> > [<c0155118>] (kthread) from [<c01010b4>] (ret_from_fork+0x14/0x20)
> > Exception stack(0xd288ffb0 to 0xd288fff8)
> > ffa0:                                     00000000 00000000 00000000 00000000
> > ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> > ffe0: 00000000 00000000 00000000 00000000 00000013 00000000
> >   r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c0155118
> >   r4:d287bbc0
> >
> > I have a patch where I have rewritten ath10k_mac_tx_push_pending() somewhat in
> > order to reduce the time spent in the RCU critical read section.
> >
> > With this patch the RCU stall warning disappears and the transmitter "recovers"
> > after some time ( I still get the 0 bit/s drop though).
> >
> > Below is list of function calls of a potential scenario (derived from the above backtrace):
> >
> > ath10k_sdio_irq_handler()
> >         ath10k_mac_tx_push_pending()
> >                 rcu_read_lock()                              <- This RCU read lock causes the stall
> >                 ath10k_mac_schedule_txq()                    <- Called in a loop for each ac
> >                         ieee80211_txq_schedule_start()
> >                         ath10k_mac_tx_push_txq()                 <- Called in a loop where we iterate
> >                                                                     all queues using ieee80211_next_txq
> >                                 ...
> >                                 spin_lock_bh(&ar->htt.tx_lock)
> >                                 ...
> >                                 spin_unlock_bh(&ar->htt.tx_lock)     <- Here we have a switch to softirq
> >
> >                                 /* We are now executing softirq ..*/
> >                                 ...
> >                                 ieee80211_wake_txqs()
> >                                         _ieee80211_wake_txqs()
> >                                                 rcu_read_lock()              <- nested rcu_read_lock() (OK I suppose)
> >                                                 __ieee80211_wake_txqs()
> >                                                         spin_lock_bh(&fq->lock);
> >                                                         spin_unlock_bh(&fq->lock);
> >                                                                 ath10k_mac_op_wake_tx_queue() /* via local->ops->wake_tx_queue() */
> >                                                                         ath10k_mac_tx_push_txq()
> >                                                                         ...
> >                                                 rcu_read_unlock()
> >                                 ...
> >                 rcu_read_unlock()
> >
> > If, for some reason, ieee80211_next_txq() never returns NULL (the queues are
> > being refilled while we are iterating), we could potentially spend a very long
> > time in the loop with the RCU read lock held.
> >
> > Another reason could perhaps be that there are so many softirqs that we never
> > have time to exit the loop from where ath10k_mac_schedule_txq() is called.
> >
> > Since I still run into the problem even if the RCU stall is removed, the root
> > cause of the problem remains unknown.
> >
> > --
> > Erik
