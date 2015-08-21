Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:32824 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbbHUIDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 04:03:08 -0400
Received: by lbbsx3 with SMTP id sx3so38806754lbb.0
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2015 01:03:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG8Fs=Nh+3zK1+tKzgi1UOomQzxQptr4MSCB4=Q=1rXtsSuDew@mail.gmail.com>
References: <CAG8Fs=Nh+3zK1+tKzgi1UOomQzxQptr4MSCB4=Q=1rXtsSuDew@mail.gmail.com>
Date: Fri, 21 Aug 2015 13:33:06 +0530
Message-ID: <CAEUmHyaMb-rsrMX++v4TfL6QD7QBPwukWaP4965q3AYv=_1ABg@mail.gmail.com> (sfid-20150821_100355_986498_443E2601)
Subject: Fwd: Memory leak issue in ath9k
From: Varka Bhadram <varkabhadram@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---------- Forwarded message ----------
From: Raghavendra Rao <raghav3276@gmail.com>
Date: Fri, Aug 21, 2015 at 1:05 PM
Subject: Memory leak issue in ath9k
To: linux-wireless@vger.kernel.org
Cc: kvalo@qca.qualcomm.com, Varka Bhadram <varkabhadram@gmail.com>


Hello,

Currently we are facing a memory leak problem while receiving the
packets over ath9k.

Here is the setup:
Board : Gateworks-54xx
SoC : imx6q, 900MHz
RAM : 1GB
WiFi Module : ath9k (AR5BHB112)

The board is currently receiving packets at the rate of 1 packet for
every 1 ms. At this rate, after some time, the kernel panics and
throws the following error:
ath: skbuff alloc of size 1974 failed

We have checked the same issue using kmemleak utility, and found the
following as its output for every received packet:

unreferenced object 0xa2bf1b40 (size 192):
  comm "softirq", pid 0, jiffies 70621 (age 4074.356s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 0c e4 1c 27 43 65 fc 13  ...........'Ce..
    00 00 00 00 00 a0 ae bd 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<80823bac>] kmemleak_alloc+0x68/0xcc
    [<8013ce5c>] kmem_cache_alloc+0x1b4/0x2d4
    [<8064f878>] build_skb+0x34/0xbc
    [<80652a34>] __alloc_rx_skb+0x90/0xfc
    [<80652b1c>] __netdev_alloc_skb+0x28/0x50
    [<80525cf8>] ath_rxbuf_alloc+0x30/0x88
    [<804f15b8>] ath_rx_tasklet+0x394/0xac0
    [<804ef378>] ath9k_tasklet+0xf8/0x214
    [<800316e8>] tasklet_action+0x8c/0x13c
    [<80030900>] __do_softirq+0x114/0x454
    [<80030fc4>] irq_exit+0xcc/0x140
    [<8007b780>] __handle_domain_irq+0x7c/0xe8
    [<800087e4>] gic_handle_irq+0x30/0x70
    [<800140a4>] __irq_svc+0x44/0x5c
    [<80010494>] arch_cpu_idle+0x30/0x4c
    [<80065cc4>] cpu_startup_entry+0x17c/0x2f0

and also the following in the dmesg :
kmemleak: 104107 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

Kindly address this issue, and provide the cause and solution to this.

Thanks and Regards,
Raghavendra



-- 
Thanks and Regards,
Varka Bhadram.
