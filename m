Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44183 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbCMNNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 09:13:16 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] ath5k: channel change fix
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1425435131-12701-2-git-send-email-ryazanov.s.a@gmail.com>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Message-Id: <20150313131315.66CCF140C00@smtp.codeaurora.org> (sfid-20150313_141319_248730_694A6891)
Date: Fri, 13 Mar 2015 13:13:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> ath5k updates the channel pointer and after that it stops the Rx logic
> and apply channel to HW. In case of channel switch, such sequence
> creates a small window when a frame, which is received on the old
> channel is considered as a frame received on the new one.
> 
> The most notable consequence of this situation occurs during the switch
> from 2 GHz band (CCK+OFDM) to the 5GHz band (OFDM-only). Frame received
> with CCK rate, e.g. beacon received at the 1mbps, causes the following
> warning:
> 
>   WARNING: at ath5k/base.c:589 ath5k_tasklet_rx+0x318/0x6ec [ath5k]()
>   invalid hw_rix: 1a
>   [..]
>   Call Trace:
>   [<802656a8>] show_stack+0x48/0x70
>   [<802dd92c>] warn_slowpath_common+0x88/0xbc
>   [<802dd98c>] warn_slowpath_fmt+0x2c/0x38
>   [<81b51be8>] ath5k_tasklet_rx+0x318/0x6ec [ath5k]
>   [<8028ac64>] tasklet_action+0x8c/0xf0
>   [<80075804>] __do_softirq+0x180/0x32c
>   [<80196ce8>] irq_exit+0x54/0x70
>   [<80041848>] ret_from_irq+0x0/0x4
>   [<80182fdc>] ioread32+0x4/0xc
>   [<81b4c42c>] ath5k_hw_set_sleep_clock+0x2ec/0x474 [ath5k]
>   [<81b4cf28>] ath5k_hw_reset+0x50/0xeb8 [ath5k]
>   [<81b50900>] ath5k_reset+0xd4/0x310 [ath5k]
>   [<81b557e8>] ath5k_config+0x4c/0x104 [ath5k]
>   [<80d01770>] ieee80211_hw_config+0x2f4/0x35c [mac80211]
>   [<80d09aa8>] ieee80211_scan_work+0x2e4/0x414 [mac80211]
>   [<8022c3f4>] process_one_work+0x28c/0x400
>   [<802df8f8>] worker_thread+0x258/0x3c0
>   [<801b5710>] kthread+0xe0/0xec
>   [<800418a8>] ret_from_kernel_thread+0x14/0x1c
> 
> The easiest way to reproduce this warning is to run scan with dualband
> NIC in noisy environments, when the channel 11 runs multiple APs. In my
> tests if the APs num >= 12, the warning appears in the first few
> seconds of scanning.
> 
> In order to fix this, the Rx disable code moved to a higher level and
> placed before the channel pointer update. This is also makes the code a
> bit more symmetrical, since we disable and enable the Rx in the same
> function.
> 
> In fact, at the pointer update time new frames should not appear,
> because interrupt generation at this point should already be disabled.
> The next patch should address this issue.
> 
> CC: Jiri Slaby <jirislaby@gmail.com>
> CC: Nick Kossifidis <mickflemm@gmail.com>
> CC: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> Reported-by: Christophe Prevotaux <cprevotaux@nltinc.com>
> Tested-by: Christophe Prevotaux <cprevotaux@nltinc.com>
> Tested-by: Eric Bree <ebree@nltinc.com>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

4a2f248f9eaf ath5k: channel change fix
ab5e290a8607 ath5k: fix reset race

Kalle Valo
