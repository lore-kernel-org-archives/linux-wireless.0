Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27174 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756294AbcKWOAL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 09:00:11 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: fix NULL pointer dereference
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1479288188-3793-1-git-send-email-miaoqing@codeaurora.org>
References: <1479288188-3793-1-git-send-email-miaoqing@codeaurora.org>
To: miaoqing pan <miaoqing@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <devin.tuchsen@gmail.com>, Miaoqing Pan <miaoqing@codeaurora.org>
Message-ID: <a66eafb59c62495c8e1fc7d04f1eca35@euamsexm01a.eu.qualcomm.com> (sfid-20161123_150014_666701_E1F3A6AF)
Date: Wed, 23 Nov 2016 14:59:56 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing pan <miaoqing@codeaurora.org> wrote:
> From: Miaoqing Pan <miaoqing@codeaurora.org>
> 
> relay_open() may return NULL, check the return value to avoid the crash.
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> IP: [<ffffffffa01a95c5>] ath_cmn_process_fft+0xd5/0x700 [ath9k_common]
> PGD 41cf28067 PUD 41be92067 PMD 0
> Oops: 0000 [#1] SMP
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.8.6+ #35
> Hardware name: Hewlett-Packard h8-1080t/2A86, BIOS 6.15    07/04/2011
> task: ffffffff81e0c4c0 task.stack: ffffffff81e00000
> RIP: 0010:[<ffffffffa01a95c5>] [<ffffffffa01a95c5>] ath_cmn_process_fft+0xd5/0x700 [ath9k_common]
> RSP: 0018:ffff88041f203ca0 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 000000000000059f RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000040 RDI: ffffffff81f0ca98
> RBP: ffff88041f203dc8 R08: ffffffffffffffff R09: 00000000000000ff
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: ffffffff81f0ca98 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88041f200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000040 CR3: 000000041b6ec000 CR4: 00000000000006f0
> Stack:
> 0000000000000363 00000000000003f3 00000000000003f3 00000000000001f9
> 000000000000049a 0000000001252c04 ffff88041f203e44 ffff880417b4bfd0
> 0000000000000008 ffff88041785b9c0 0000000000000002 ffff88041613dc60
> 
> Call Trace:
> <IRQ>
> [<ffffffffa01b6441>] ath9k_tasklet+0x1b1/0x220 [ath9k]
> [<ffffffff8105d8dd>] tasklet_action+0x4d/0xf0
> [<ffffffff8105dde2>] __do_softirq+0x92/0x2a0
> 
> Reported-by: Devin Tuchsen <devin.tuchsen@gmail.com>
> Tested-by: Devin Tuchsen <devin.tuchsen@gmail.com>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

40bea976c72b ath9k: fix NULL pointer dereference

-- 
https://patchwork.kernel.org/patch/9431163/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
