Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,LOCALPART_IN_SUBJECT,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F343C282DD
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 14:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDD8520674
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 14:58:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ewSeQ/dq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfDWO67 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 10:58:59 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40747 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbfDWO66 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 10:58:58 -0400
Received: by mail-lj1-f193.google.com with SMTP id q66so13806551ljq.7
        for <linux-wireless@vger.kernel.org>; Tue, 23 Apr 2019 07:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wQU41y2IFeSWit/IL+eAE7k13uW+jGfx2687QPoTt6o=;
        b=ewSeQ/dqqfMv2O5ajO5Dd2Njk5arjRI5dp6LSh9iqGyWkWP6J801vgu1fvpYVjoyky
         keZ3YUp3UcAdciky1N+vA4/PuVhpvujA5jd8uR+8Z8SHE7ZlxQJhKOmJiEnHHz49Ytm1
         3Tl57jyiVjfEIDg3BFjWRvDq+hHfgZnJwfZdI4XhCQzlzxGqUtTadvzuO8dna+uFyFUZ
         kOsT0iPC6F7en3DjctXpEF5Zw1LT6ahTfPE27Zs1FTykHz1/5aV+A6OUljTIw5+4ncIY
         MEJcqdK/ckiqhYECTZxOfgpefOW0ZpH3kbUJ5s53DASGEWYpY1UDfzAsgznPaKQBiuaP
         9+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wQU41y2IFeSWit/IL+eAE7k13uW+jGfx2687QPoTt6o=;
        b=KNaHFkUtFICiI7mr8d1+ykeQvWWNvBvd4QKLRgJm0Kukum8e8vEDzSQnsQu1AUXhM9
         5x3eRPXfirKQm+x04aq5m31Rw/2RCAX5c3+ab/BIYSwMkeMyHFL86QaXLFFswTzWgtSk
         yLvDJBFaC+SlHTn77dy35nyS0+i0MMU5nfzkeNLvAVQ3gl0x0nhLZ4wfDe6QjX+MJDRt
         tmTl0RpS3/pGWPnjpcvz+zf1T6nRvrgDA8aG38pGCmJduc//FzuZN8R/yr6kYtBgaYYj
         9yJVmcebGROSlHrlfQE3ZaQDA8ZrFYPIIx3xFdaVu6IvJ8ykOl9tDdYXeBOyGjGwKHwq
         RYTQ==
X-Gm-Message-State: APjAAAWl8bnVswRO338do1Uq3FgrQQLhZiyhDUSRHSZIPBq/SgSRrzuY
        xq2T7yn2CzdYD2LiewYV5Mg=
X-Google-Smtp-Source: APXvYqxVHhDv1HkMqDxRZvGdbNdhzVyJ0kIFL9BXzqkKcS3X5X2sk4a2h/PeiXHqRLPOXqdF0+o1mg==
X-Received: by 2002:a2e:9a49:: with SMTP id k9mr14154064ljj.84.1556031535155;
        Tue, 23 Apr 2019 07:58:55 -0700 (PDT)
Received: from [192.168.1.244] (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id c17sm1628910lff.84.2019.04.23.07.58.54
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 07:58:54 -0700 (PDT)
To:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        johannes@sipsolutions.net
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: ath10k: issue with TX queue scheduling
Message-ID: <c8fc9821-3055-8110-fe57-34f06a6b0296@gmail.com>
Date:   Tue, 23 Apr 2019 16:58:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello ath10k and mac80211 developers!

I have run into an issue with ath10k SDIO and iperf TX.

When running an iperf test (ath10k as server, PC as client),
I get a totally stalled transmitter on the ath10k side after some time.

[  3] 574.0-575.0 sec  3.25 MBytes  27.3 Mbits/sec
[  3] 575.0-576.0 sec   255 KBytes  2.09 Mbits/sec
[  3] 576.0-577.0 sec  0.00 Bytes  0.00 bits/sec
[  3] 577.0-578.0 sec  0.00 Bytes  0.00 bits/sec

Niklas Cassel had the same issue ~1 year ago and he made a fix in commit
3f04950f32d5

After this everything has been working fine until lately when I ran into the
same issue again.

The problem seems to have reappeared after the new mac80211 TX scheduling
was introduced. I have not bisected or anything, but last time I was doing
these tests was before the introduction of the new TX scheduling, and then
everything was working.

Niklas fix was to add a call to ath10k_mac_tx_push_pending() in
ath10k_sdio_irq_handler() in order to make sure we never get into a situation
where we have messages in the ath10k internal queue, but with TX queuing stopped.

Since the introduction of the new TX scheduling, the driver internal queue
has been removed (there used to be a txqs member in struct ath10k that was
removed in commit bb2edb733586 by Toke). So I am unsure if Niklas commit is
still needed. At least it does not seem to fix this issue anymore.

Are there any nice mac80211 kernel config options available that could
ease debugging queuing related issues?
Some kind of tracing feature for the TX scheduling perhaps?

All tips/hints are welcome!

P.S.

When I run into the error I also get the below RCU stall splat (~20 seconds after
the bitrate has dropped down to 0 bit/s):

rcu: INFO: rcu_sched self-detected stall on CPU
rcu: 	0-....: (2600 ticks this GP) idle=02a/1/0x40000002 softirq=1107/1107 fqs=1294
rcu: 	 (t=2602 jiffies g=633 q=102)
NMI backtrace for cpu 0
CPU: 0 PID: 120 Comm: irq/64-mmc0 Tainted: G      D           5.1.0-rc3-wt-ath+ #31
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Backtrace:
[<c010ecec>] (dump_backtrace) from [<c010efec>] (show_stack+0x20/0x24)
  r7:00000000 r6:60010193 r5:00000000 r4:c14e9ecc
[<c010efcc>] (show_stack) from [<c0cf5674>] (dump_stack+0xdc/0x114)
[<c0cf5598>] (dump_stack) from [<c0cfcd0c>] (nmi_cpu_backtrace+0xac/0xbc)
  r10:80010193 r9:c14149fc r8:c0e02fd8 r7:00000000 r6:c0112318 r5:00000000
  r4:00000000 r3:02fc7d23
[<c0cfcc60>] (nmi_cpu_backtrace) from [<c0cfce04>] (nmi_trigger_cpumask_backtrace+0xe8/0x13c)
  r5:c1418a30 r4:00000000
[<c0cfcd1c>] (nmi_trigger_cpumask_backtrace) from [<c01132cc>] (arch_trigger_cpumask_backtrace+0x1c/0x24)
  r9:c14149fc r8:c142a880 r7:00000240 r6:c0e02fd4 r5:c1414978 r4:c142a880
[<c01132b0>] (arch_trigger_cpumask_backtrace) from [<c01b6220>] (rcu_dump_cpu_stacks+0xb8/0xfc)
[<c01b6168>] (rcu_dump_cpu_stacks) from [<c01b42a8>] (rcu_sched_clock_irq+0x890/0x9c0)
  r10:00000066 r9:c142a880 r8:c1414970 r7:c14f30f0 r6:c1405900 r5:c1414ed4
  r4:e671b100
[<c01b3a18>] (rcu_sched_clock_irq) from [<c01be570>] (update_process_times+0x40/0x6c)
  r10:c14150fc r9:e6716740 r8:c1414970 r7:00000027 r6:00000000 r5:d261f2c0
  r4:ffffe000
[<c01be530>] (update_process_times) from [<c01d4d04>] (tick_sched_handle+0x64/0x68)
  r7:00000027 r6:97c52581 r5:d288fba8 r4:e6716c00
[<c01d4ca0>] (tick_sched_handle) from [<c01d4fd8>] (tick_sched_timer+0x6c/0xd0)
[<c01d4f6c>] (tick_sched_timer) from [<c01bf3e0>] (__hrtimer_run_queues+0x1a8/0x5ac)
  r7:c01d4f6c r6:e67167a0 r5:e6716740 r4:e6716c00
[<c01bf238>] (__hrtimer_run_queues) from [<c01c08c0>] (hrtimer_interrupt+0x124/0x2ec)
  r10:e6716880 r9:ffffffff r8:7fffffff r7:e6716840 r6:00000003 r5:20010193
  r4:e6716740
[<c01c079c>] (hrtimer_interrupt) from [<c0113cec>] (twd_handler+0x3c/0x50)
  r10:c14f2cf4 r9:c1414ed4 r8:00000010 r7:c1414970 r6:c1415110 r5:d20d4900
  r4:00000001
[<c0113cb0>] (twd_handler) from [<c019eb50>] (handle_percpu_devid_irq+0xec/0x394)
  r5:d20d4900 r4:d2037800
[<c019ea64>] (handle_percpu_devid_irq) from [<c0197e48>] (generic_handle_irq+0x30/0x44)
  r10:c146c114 r9:d2024400 r8:00000001 r7:00000000 r6:c1414ed4 r5:00000010
  r4:c13e4450
[<c0197e18>] (generic_handle_irq) from [<c0198554>] (__handle_domain_irq+0x74/0xf0)
[<c01984e0>] (__handle_domain_irq) from [<c01024b4>] (gic_handle_irq+0x68/0xcc)
  r9:d288fba8 r8:c1415110 r7:f4000100 r6:000003ff r5:000003eb r4:f400010c
[<c010244c>] (gic_handle_irq) from [<c0101a70>] (__irq_svc+0x70/0x98)
Exception stack(0xd288fba8 to 0xd288fbf0)
fba0:                   c013417c 00000000 60010093 d288e000 000001ff ffffe000
fbc0: c0cb7340 00000003 d2fd86a0 d28c2000 d2fd86a0 d288fc14 d288fbc8 d288fbf8
fbe0: c0213544 c0134180 60010013 ffffffff
  r10:d2fd86a0 r9:d288e000 r8:d2fd86a0 r7:d288fbdc r6:ffffffff r5:60010013
  r4:c0134180
[<c01340c8>] (__local_bh_enable_ip) from [<c0d18b84>] (_raw_spin_unlock_bh+0x40/0x44)
  r7:00000003 r6:d21a88c0 r5:d2fd873c r4:c0cb7340
[<c0d18b44>] (_raw_spin_unlock_bh) from [<c0cb7340>] (_ieee80211_wake_txqs+0x394/0x6d4)
  r5:d21a88c0 r4:00000000
[<c0cb6fac>] (_ieee80211_wake_txqs) from [<c0cba838>] (ieee80211_wake_txqs+0x44/0x70)
  r10:00000006 r9:00000000 r8:00000000 r7:e6711404 r6:d2fd86a0 r5:d2fd8b10
  r4:c1414948
[<c0cba7f4>] (ieee80211_wake_txqs) from [<c0134a04>] (tasklet_action_common.constprop.5+0x64/0xec)
  r6:00000000 r5:d2fd908c r4:d2fd9088
[<c01349a0>] (tasklet_action_common.constprop.5) from [<c0134ac8>] (tasklet_action+0x3c/0x48)
  r10:00000040 r9:00000101 r8:c1414970 r7:c14f2ca4 r6:00000006 r5:c1403098
  r4:00000007 r3:25336000
[<c0134a8c>] (tasklet_action) from [<c0102610>] (__do_softirq+0xf8/0x54c)
[<c0102518>] (__do_softirq) from [<c01340bc>] (do_softirq.part.4+0x78/0x84)
  r10:d21a87cc r9:00000000 r8:00000000 r7:d2fd9e30 r6:bf058104 r5:ffffe000
  r4:60010093
[<c0134044>] (do_softirq.part.4) from [<c01341fc>] (__local_bh_enable_ip+0x134/0x18c)
  r5:ffffe000 r4:000001ff
[<c01340c8>] (__local_bh_enable_ip) from [<c0d18b84>] (_raw_spin_unlock_bh+0x40/0x44)
  r7:d2fd9e30 r6:d2fd9d38 r5:d2fd9e30 r4:bf058104
[<c0d18b44>] (_raw_spin_unlock_bh) from [<bf058104>] (ath10k_mac_tx_push_txq+0x294/0x2a4 [ath10k_core])
  r5:d2fd9540 r4:d33220dc
[<bf057e70>] (ath10k_mac_tx_push_txq [ath10k_core]) from [<bf05820c>] (ath10k_mac_tx_push_pending+0xf8/0x1ec [ath10k_core])
  r10:ffffe8ed r9:d2d96540 r8:fffffffe r7:00000002 r6:00000002 r5:d33220dc
  r4:d2fd86a0
[<bf058114>] (ath10k_mac_tx_push_pending [ath10k_core]) from [<bf0e2544>] (ath10k_sdio_irq_handler+0x308/0x4d4 [ath10k_sdio])
  r8:01340202 r7:d2fde540 r6:d2fde87c r5:00000000 r4:d2fd9540
[<bf0e223c>] (ath10k_sdio_irq_handler [ath10k_sdio]) from [<c08e86c0>] (process_sdio_pending_irqs+0x4c/0x1bc)
  r10:d287bb80 r9:d22a7400 r8:00000001 r7:00000000 r6:d284c800 r5:c1414948
  r4:d2859000
[<c08e8674>] (process_sdio_pending_irqs) from [<c08e887c>] (sdio_run_irqs+0x4c/0x68)
  r10:d287bb80 r9:d22a7400 r8:00000001 r7:00000000 r6:d28596a0 r5:00000100
  r4:d2859000
[<c08e8830>] (sdio_run_irqs) from [<c08f3d00>] (sdhci_thread_irq+0x80/0xbc)
  r5:00000100 r4:d28594c0
[<c08f3c80>] (sdhci_thread_irq) from [<c019a718>] (irq_thread_fn+0x2c/0x88)
  r7:00000000 r6:d287bba4 r5:d22a7400 r4:d287bb80
[<c019a6ec>] (irq_thread_fn) from [<c019aa54>] (irq_thread+0x120/0x22c)
  r7:00000000 r6:d287bba4 r5:ffffe000 r4:00000000
[<c019a934>] (irq_thread) from [<c015526c>] (kthread+0x154/0x168)
  r10:d2101bd8 r9:c019a934 r8:d287bb80 r7:d288e000 r6:d287bbc0 r5:d2241400
  r4:00000000
[<c0155118>] (kthread) from [<c01010b4>] (ret_from_fork+0x14/0x20)
Exception stack(0xd288ffb0 to 0xd288fff8)
ffa0:                                     00000000 00000000 00000000 00000000
ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
ffe0: 00000000 00000000 00000000 00000000 00000013 00000000
  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c0155118
  r4:d287bbc0

I have a patch where I have rewritten ath10k_mac_tx_push_pending() somewhat in
order to reduce the time spent in the RCU critical read section.

With this patch the RCU stall warning disappears and the transmitter "recovers"
after some time ( I still get the 0 bit/s drop though).

Below is list of function calls of a potential scenario (derived from the above backtrace):

ath10k_sdio_irq_handler()
	ath10k_mac_tx_push_pending()
		rcu_read_lock()                              <- This RCU read lock causes the stall
		ath10k_mac_schedule_txq()                    <- Called in a loop for each ac
			ieee80211_txq_schedule_start()
			ath10k_mac_tx_push_txq()                 <- Called in a loop where we iterate
			                                            all queues using ieee80211_next_txq
				...
				spin_lock_bh(&ar->htt.tx_lock)
				...
				spin_unlock_bh(&ar->htt.tx_lock)     <- Here we have a switch to softirq

				/* We are now executing softirq ..*/
				...
				ieee80211_wake_txqs()
					_ieee80211_wake_txqs()
						rcu_read_lock()              <- nested rcu_read_lock() (OK I suppose)
						__ieee80211_wake_txqs()
							spin_lock_bh(&fq->lock);
							spin_unlock_bh(&fq->lock);
								ath10k_mac_op_wake_tx_queue() /* via local->ops->wake_tx_queue() */
									ath10k_mac_tx_push_txq()
									...
						rcu_read_unlock()
				...
		rcu_read_unlock()

If, for some reason, ieee80211_next_txq() never returns NULL (the queues are
being refilled while we are iterating), we could potentially spend a very long
time in the loop with the RCU read lock held.

Another reason could perhaps be that there are so many softirqs that we never
have time to exit the loop from where ath10k_mac_schedule_txq() is called.

Since I still run into the problem even if the RCU stall is removed, the root
cause of the problem remains unknown.

--
Erik
