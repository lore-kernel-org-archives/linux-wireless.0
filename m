Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:31918 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbbFAHYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 03:24:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix possible ps sleep crash
References: <1432877724-8256-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 1 Jun 2015 10:24:44 +0300
In-Reply-To: <1432877724-8256-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 29 May 2015 07:35:24 +0200")
Message-ID: <87mw0jvqkj.fsf@kamboji.qca.qualcomm.com> (sfid-20150601_092453_785502_EE33A934)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If probing failed pci sleep timer could remain
> running and trigger after ath10k structures were
> freed causing invalid pointer dereference:
>
>  BUG: unable to handle kernel paging request at ffffc90001c80004
>  IP: [<ffffffff81354728>] iowrite32+0x38/0x40
>  ...
>  Call Trace:
>   <IRQ>
>   [<ffffffffa00da048>] ? __ath10k_pci_sleep+0x48/0x60 [ath10k_pci]
>   [<ffffffffa00da44e>] ath10k_pci_ps_timer+0x5e/0x80 [ath10k_pci]
>   [<ffffffff810b210e>] call_timer_fn+0x3e/0x120
>   [<ffffffffa00da3f0>] ? ath10k_pci_wake+0x150/0x150 [ath10k_pci]
>   [<ffffffff810b3d11>] run_timer_softirq+0x201/0x2e0
>   [<ffffffff8105d73f>] __do_softirq+0xaf/0x290
>   [<ffffffff8105da95>] irq_exit+0x95/0xa0
>   [<ffffffff81950406>] smp_apic_timer_interrupt+0x46/0x60
>   [<ffffffff8194e77e>] apic_timer_interrupt+0x6e/0x80
>
> Fixes: 77258d409ce4 ("ath10k: enable pci soc powersaving")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
