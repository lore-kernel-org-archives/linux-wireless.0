Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35208 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab1K2CQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 21:16:45 -0500
Received: by ggnr5 with SMTP id r5so5923267ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 18:16:44 -0800 (PST)
Message-ID: <4ED44089.7010102@lwfinger.net> (sfid-20111129_031649_110020_C1DD0705)
Date: Mon, 28 Nov 2011 20:16:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Philipp Dreimann <philipp@dreimann.net>
CC: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
	mikem@ring3k.org
Subject: Re: rtlwifi, rtl8192se bug soft-lockup
References: <CADYPuQ7W2B9HjR_TiV=dhD3vW-3pR4Y+s_9oJzTC-CdL+hr=9w@mail.gmail.com>
In-Reply-To: <CADYPuQ7W2B9HjR_TiV=dhD3vW-3pR4Y+s_9oJzTC-CdL+hr=9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/28/2011 06:58 PM, Philipp Dreimann wrote:
> Hello!
>
> I since kernel v3.1, my system suffers from lock-ups because of the
> rtl8192se driver. v3.0 is still fine.
>
>
> [  704.057088] Pid: 2112, comm: kworker/0:3 Not tainted
> 3.1.0-1-686-pae #1 ASUSTeK Computer INC. 1201T/1201T
> [  704.057120] EIP: 0060:[<c105cf7c>] EFLAGS: 00000297 CPU: 0
> [  704.057140] EIP is at do_raw_spin_lock+0x10/0x15
> [  704.057152] EAX: f4bbd188 EBX: f4bbd160 ECX: f4bbc4a8 EDX: 00009998
> [  704.057164] ESI: f4bbc320 EDI: 00000000 EBP: 00000100 ESP: f580dfc0
> [  704.057175]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  704.057190] Process kworker/0:3 (pid: 2112, ti=f580c000
> task=f4b69660 task.ti=f49d8000)
> [  704.057200] Stack:
> [  704.057210]  f84c5608 f4bbd308 f4bbd30c c103bac7 00000006 c13caa18
> c103c05d c103c0f1
> [  704.057265]  00000001 0000000a 00000000 f49d9ebc f49d8000 c103c05d
> 00000046 c100ccb4
> [  704.057322] Call Trace:
> [  704.057352]  [<f84c5608>] ? rtl_lps_leave+0xf/0xc4 [rtlwifi]
> [  704.057369]  [<c103bac7>] ? tasklet_action+0x62/0xa5
> [  704.057383]  [<c103c05d>] ? local_bh_enable+0x2/0x2
> [  704.057397]  [<c103c0f1>] ? __do_softirq+0x94/0x12f
> [  704.057411]  [<c103c05d>] ? local_bh_enable+0x2/0x2
> [  704.057420]<IRQ>
> [  704.057438]  [<c103c2e2>] ? irq_exit+0x32/0x80
> [  704.057454]  [<c100ca6e>] ? do_IRQ+0x65/0x76
> [  704.057468]  [<c12b2a30>] ? common_interrupt+0x30/0x38
> [  704.057487]  [<c1156283>] ? delay_tsc+0x1d/0x54
> [  704.057501]  [<c115623b>] ? __delay+0x6/0x7
> [  704.057520]  [<f86a4a15>] ?
> rtl92s_phy_set_rf_power_state+0x458/0x531 [rtl8192se]
> [  704.057543]  [<f84c4fd1>] ? rtl_ps_set_rf_state+0xbd/0xc2 [rtlwifi]
> [  704.057566]  [<f84c5973>] ? rtl_swlps_rf_sleep+0x6f/0x154 [rtlwifi]
> [  704.057587]  [<f84c5a7b>] ? rtl_swlps_wq_callback+0x23/0x78 [rtlwifi]
> [  704.057603]  [<c1049633>] ? process_one_work+0x112/0x1fa
> [  704.057624]  [<f84c5a58>] ? rtl_swlps_rf_sleep+0x154/0x154 [rtlwifi]
> [  704.057638]  [<c104a33e>] ? worker_thread+0xa9/0x122
> [  704.057653]  [<c104a295>] ? manage_workers.isra.23+0x13d/0x13d
> [  704.057668]  [<c104ca80>] ? kthread+0x63/0x68
> [  704.057683]  [<c104ca1d>] ? kthread_worker_fn+0x101/0x101
> [  704.057696]  [<c12b2a3e>] ? kernel_thread_helper+0x6/0x10
> [  704.057706] Code: c3 3e ff 08 79 05 e8 0c 9d 0f 00 c3 3e 81 28 00
> 00 10 00 74 05 e8 e1 9c 0f 00 c3 ba 00 01 00 00 3e 66 0f c1 10 38 f2
> 74 06 f3 90<8a>  10 eb f6 c3 89 c2 0f b7 02 38 e0 8d 88 00 01 00 00 75
> 05 3e
>
> One of the reasons for this lockup is most likely the change from
> spin_lock_irq* to spin_lock, see
> 67fc6052a49b781efbcfc138f3b68fe79ddd0c2f and earlier.
>
> I will try the recently proposed patch for another problem from
> Stanislaw, [PATCH v2] rtlwifi: fix lps_lock deadlock, to check if it
> resolves my issue as well. But I think that Mike might be affected by
> the change again...

 From a quick look, Stanislaw's patch should fix your system. If not, then 
please consider pulling a git tree and checking out commit 34ddb20, which is the 
one before 67fc6052.

Larry
