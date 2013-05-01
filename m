Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33375 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab3EAQIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 12:08:52 -0400
Received: by mail-qa0-f53.google.com with SMTP id p6so857290qad.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 09:08:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9E150A22@SC-VEXCH1.marvell.com>
References: <CAMLZHHSVd6GpmqTQyJmbsheH1utZh8mNW8d4zLtjwoONaGwbNA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E0579DB@SC-VEXCH1.marvell.com>
	<CAMLZHHQ=BNuD0UmcV8pv=6phW=W-C5C7Af6n8tLWTrzyuzPQow@mail.gmail.com>
	<CAMLZHHQXY3OuWKr_K1B9-NmZFwCcQFPNTBoOkpvT9kxWJ=ixqQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E14FF4C@SC-VEXCH1.marvell.com>
	<CAMLZHHSHG2ySmW0ac6+M-7fOgNFrqXBf7=SXFFkWDrhwGwYKXQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E150221@SC-VEXCH1.marvell.com>
	<CAMLZHHThUxB_Vj4eOjq+61osUQ3CQ5UGgvrgZXE33oDD1N=YtA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E150A22@SC-VEXCH1.marvell.com>
Date: Wed, 1 May 2013 10:08:51 -0600
Message-ID: <CAMLZHHTNPBh3LDD0F2+zqSvUPmT6bhA8HLZvc1dTJmHGR8eVJg@mail.gmail.com> (sfid-20130501_180857_578540_90C0B2DA)
Subject: Re: Memory leak in mwifiex_cfg80211_scan
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 30, 2013 at 12:26 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Please test the revision attached with this e-mail.

It works with the original test case. Thanks. In that environment, for
whatever reason, scan_delay_fn is not triggered.

However, I think we both agree that scan_delay_fn can (and will)
'legally' execute during the above test (and you did mention earlier
that in your env it is being called). I can see that some conditions
must be met for this to happen, defined in mwifiex_ret_802_11_scan().

To simplify my testing I just "relaxed" those conditions to be:

-               } else if (!mwifiex_wmm_lists_empty(adapter) &&
-                          (priv->scan_request && (priv->scan_request->flags &
-                                           NL80211_SCAN_FLAG_LOW_PRIORITY))) {
+               } else if (1) {

Now it always triggers. A good way to get some solid testing of this codepath.

And as I suspected, running my test now causes an immediate kernel crash.

bash-4.2# bash test.sh
 mwifiex_sdio mmc0:0001:1: WLAN FW already running! Skip FW dnld
 lis3lv02d_i2c 4-0019: Failed to get supply 'Vdd': -517
 i2c 4-0019: Driver lis3lv02d_i2c requests probe deferral
 mwifiex_sdio mmc0:0001:1: WLAN FW is active
 mwifiex_sdio mmc0:0001:1: ignoring F/W country code US
 mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0 (14.66.9.p96)
 systemd-udevd[474]: renamed network interface mlan0 to eth0
 mwifiex_sdio mmc0:0001:1: info: mwifiex_ret_802_11_scan: deferring scan
 mwifiex_sdio mmc0:0001:1: info: mwifiex_ret_802_11_scan: deferring scan
eth0      Failed to read scan data : No such device

 Unable to handle kernel paging request at virtual address 00100100
 pgd = c0004000
 [00100100] *pgd=00000000
 Internal error: Oops: 15 [#1] PREEMPT ARM
 Modules linked in: [last unloaded: mwifiex_sdio]
 CPU: 0    Not tainted  (3.8.0-00021-gd431a65-dirty #992)
 PC is at scan_delay_timer_fn+0x1dc/0x2a0
 LR is at call_timer_fn.isra.36+0x2c/0x94
 pc : [<c021b2a0>]    lr : [<c002a158>]    psr: 600f0193
 sp : c054fe50  ip : c054fe78  fp : c054fe74
 r10: 3fa6bf3c  r9 : 00200000  r8 : c0594080
 r7 : c021b0c4  r6 : 00100100  r5 : ed4fc000  r4 : edbce000
 r3 : c054e000  r2 : 600f0113  r1 : 00000103  r0 : 0000000a
 Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
 Control: 10c5387d  Table: 2d888059  DAC: 00000015
 Process swapper (pid: 0, stack limit = 0xc054e240)
 Stack: (0xc054fe50 to 0xc0550000)
 fe40:                                     c054e000 00000102 ed4fc000 c021b0c4
 fe60: c0594080 3fa6bf3c c054fe9c c054fe78 c002a158 c021b0d0 0000000d 00000001
 fe80: c0594200 c054e000 ed4fc000 c021b0c4 c054fec4 c054fea0 c002a36c c002a138
 fea0: c054fea0 c054fea0 00000001 c05940c8 c054e000 00000102 c054ff0c c054fec8
 fec0: c0023de8 c002a1cc 00000000 ee004740 c054feec 00000004 00000001 0000000a
 fee0: c054ff04 0000000d 00000000 fe282104 c054ff7c 00004059 562f5842 00000000
 ff00: c054ff1c c054ff10 c00241a0 c0023d48 c054ff34 c054ff20 c000fa98 c0024160
 ff20: c000fcac 600f0013 c054ff44 c054ff38 c0008250 c000fa38 c054ffa4 c054ff48
 ff40: c000e6cc c000824c 00000000 c055dbd8 00000000 00000000 c054e000 c0581348
 ff60: c0531198 c15f5a00 00004059 562f5842 00000000 c054ffa4 c054ff90 c054ff90
 ff80: c000fb4c c000fcac 600f0013 ffffffff 00000002 00000000 c054ffbc c054ffa8
 ffa0: c03da988 c000fc5c c055acd0 c05560d8 c054fff4 c054ffc0 c050f7ec c03da924
 ffc0: ffffffff ffffffff c050f2dc 00000000 00000000 c0531198 10c5387d c0556024
 ffe0: c0531194 c05598e4 00000000 c054fff8 00008074 c050f558 00000000 00000000
 Backtrace:
 [<c021b0c4>] (scan_delay_timer_fn+0x0/0x2a0) from [<c002a158>]
(call_timer_fn.isra.36+0x2c/0x94)
 [<c002a12c>] (call_timer_fn.isra.36+0x0/0x94) from [<c002a36c>]
(run_timer_softirq+0x1ac/0x22c)
  r7:c021b0c4 r6:ed4fc000 r5:c054e000 r4:c0594200
 [<c002a1c0>] (run_timer_softirq+0x0/0x22c) from [<c0023de8>]
(__do_softirq+0xac/0x174)
  r7:00000102 r6:c054e000 r5:c05940c8 r4:00000001
 [<c0023d3c>] (__do_softirq+0x0/0x174) from [<c00241a0>] (irq_exit+0x4c/0xb0)
 [<c0024154>] (irq_exit+0x0/0xb0) from [<c000fa98>] (handle_IRQ+0x6c/0x8c)
 [<c000fa2c>] (handle_IRQ+0x0/0x8c) from [<c0008250>] (asm_do_IRQ+0x10/0x14)
  r5:600f0013 r4:c000fcac
 [<c0008240>] (asm_do_IRQ+0x0/0x14) from [<c000e6cc>] (__irq_svc+0x4c/0x94)
 Exception stack(0xc054ff48 to 0xc054ff90)
 ff40:                   00000000 c055dbd8 00000000 00000000 c054e000 c0581348
 ff60: c0531198 c15f5a00 00004059 562f5842 00000000 c054ffa4 c054ff90 c054ff90
 ff80: c000fb4c c000fcac 600f0013 ffffffff
 [<c000fc50>] (cpu_idle+0x0/0xa4) from [<c03da988>] (rest_init+0x70/0x88)
  r5:00000000 r4:00000002
 [<c03da918>] (rest_init+0x0/0x88) from [<c050f7ec>] (start_kernel+0x2a0/0x2f0)
  r4:c05560d8 r3:c055acd0
 [<c050f54c>] (start_kernel+0x0/0x2f0) from [<00008074>] (0x8074)
 Code: e5931004 e2811001 e5831004 e5946a5c (e8960003)
 ---[ end trace 5842e4d79510ea17 ]---
 Kernel panic - not syncing: Fatal exception in interrupt

I suspect this crash also existed before your patch, just I was not
testing scan_delay_fn before. Maybe you prefer to deal with it as a
separate issue.

Daniel
