Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4943 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaIBHT3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 03:19:29 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: kill tasklets after free_irq
References: <1409214280-6492-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 2 Sep 2014 10:19:15 +0300
In-Reply-To: <1409214280-6492-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 28 Aug 2014 10:24:40 +0200")
Message-ID: <87sikao5fw.fsf@kamboji.qca.qualcomm.com> (sfid-20140902_091932_198992_882CAA10)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Commit 5c771e7454d148af35e8b4297d00f880de79ea49
> introduced a regression. On some systems spurious
> interrupts could schedule a tasklet while tearing
> down leading to, e.g.:
>
>  BUG: unable to handle kernel paging request at fe589030
>  IP: [<c1316fb0>] ioread32+0x30/0x40
>  ...
>  Call Trace:
>   [<fe576c1b>] ath10k_pci_tasklet+0x1b/0x60 [ath10k_pci]
>   [<c1053fbe>] tasklet_action+0x9e/0xb0
>   [<c10534f1>] __do_softirq+0xf1/0x3f0
>   [<c1053400>] ? ftrace_raw_event_irq_handler_entry+0xa0/0xa0
>   [<c1004999>] do_softirq_own_stack+0x29/0x40
>   <IRQ>
>   [<c1053a76>] irq_exit+0x86/0xb0
>  ...
>   [<c132d522>] do_pci_disable_device+0x52/0x60
>   [<c132d57f>] pci_disable_device+0x4f/0xb0
>   [<c132a961>] ? __pci_set_master+0x51/0x80
>   [<fe5740b3>] ath10k_pci_release+0x33/0x40 [ath10k_pci]
>   [<fe575d4b>] ath10k_pci_remove+0x7b/0x90 [ath10k_pci]
>
> Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied. I also added a "Tested-by: Kalle" line.

-- 
Kalle Valo
