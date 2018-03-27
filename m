Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47500 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751686AbeC0IyM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 04:54:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rsi: fix error path handling in SDIO probe
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1521553241-12676-1-git-send-email-amitkarwar@gmail.com>
References: <1521553241-12676-1-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Message-Id: <20180327085411.ACD946055D@smtp.codeaurora.org> (sfid-20180327_105417_285805_15F8A884)
Date: Tue, 27 Mar 2018 08:54:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> wrote:

> From: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> 
> We miss to release IRQ in certain error path in SDIO probe which
> causes following kernel panic. This patch corrects error path
> handling
> 
> BUG: unable to handle kernel NULL pointer dereference at        (null)
> IP:           (null)
> PGD 0 P4D 0
> Oops: 0010 [#1] SMP PTI
> Call Trace:
>  <IRQ>
>  ? call_timer_fn+0x29/0x120
>  ? run_timer_softirq+0x1da/0x420
>  ? timer_interrupt+0x11/0x20
>  ? __do_softirq+0xef/0x26e
>  ? irq_exit+0xbe/0xd0
>  ? do_IRQ+0x4a/0xc0
>  ? common_interrupt+0xa2/0xa2
>  </IRQ>
>  ? cpuidle_enter_state+0x118/0x250
>  ? do_idle+0x186/0x1e0
>  ? cpu_startup_entry+0x6f/0x80
>  ? start_kernel+0x47c/0x49c
>  ? secondary_startup_64+0xa5/0xb0
> 
> Fixes: 50117605770c ("rsi: improve RX handling in SDIO interface")
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

2 patches applied to wireless-drivers-next.git, thanks.

90b12aebe54b rsi: fix error path handling in SDIO probe
864db4d50853 rsi: fix kernel panic observed on 64bit machine

-- 
https://patchwork.kernel.org/patch/10297201/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
