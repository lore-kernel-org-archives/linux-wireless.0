Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5197 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752092AbcLUO3s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Dec 2016 09:29:48 -0500
Cc: <kvalo@codeaurora.org>, <helgaas@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <marc.zyngier@arm.com>, <janusz.dziedzic@tieto.com>,
        <ath9k-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
        <rmanohar@qca.qualcomm.com>, <bharat.kumar.gogada@xilinx.com>,
        "Tobias Klausmann" <tobias.johannes.klausmann@mni.thm.de>,
        "# v4 . 9" <stable@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath9k: do not return early to fix rcu unlocking
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161213170807.4853-1-tobias.johannes.klausmann@mni.thm.de>
References: <20161213170807.4853-1-tobias.johannes.klausmann@mni.thm.de>
To: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Message-ID: <f3c186fc7a374be98b725170b57ec1e3@euamsexm01a.eu.qualcomm.com> (sfid-20161221_153008_811446_0E9D165D)
Date: Wed, 21 Dec 2016 15:29:20 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de> wrote:
> Starting with commit d94a461d7a7d ("ath9k: use ieee80211_tx_status_noskb
> where possible") the driver uses rcu_read_lock() && rcu_read_unlock(), yet on
> returning early in ath_tx_edma_tasklet() the unlock is missing leading to stalls
> and suspicious RCU usage:
> 
>  ===============================
>  [ INFO: suspicious RCU usage. ]
>  4.9.0-rc8 #11 Not tainted
>  -------------------------------
>  kernel/rcu/tree.c:705 Illegal idle entry in RCU read-side critical section.!
> 
>  other info that might help us debug this:
> 
>  RCU used illegally from idle CPU!
>  rcu_scheduler_active = 1, debug_locks = 0
>  RCU used illegally from extended quiescent state!
>  1 lock held by swapper/7/0:
>  #0:
>   (
>  rcu_read_lock
>  ){......}
>  , at:
>  [<ffffffffa06ed110>] ath_tx_edma_tasklet+0x0/0x450 [ath9k]
> 
>  stack backtrace:
>  CPU: 7 PID: 0 Comm: swapper/7 Not tainted 4.9.0-rc8 #11
>  Hardware name: Acer Aspire V3-571G/VA50_HC_CR, BIOS V2.21 12/16/2013
>   ffff88025efc3f38 ffffffff8132b1e5 ffff88017ede4540 0000000000000001
>   ffff88025efc3f68 ffffffff810a25f7 ffff88025efcee60 ffff88017edebdd8
>   ffff88025eeb5400 0000000000000091 ffff88025efc3f88 ffffffff810c3cd4
>  Call Trace:
>   <IRQ>
>   [<ffffffff8132b1e5>] dump_stack+0x68/0x93
>   [<ffffffff810a25f7>] lockdep_rcu_suspicious+0xd7/0x110
>   [<ffffffff810c3cd4>] rcu_eqs_enter_common.constprop.85+0x154/0x200
>   [<ffffffff810c5a54>] rcu_irq_exit+0x44/0xa0
>   [<ffffffff81058631>] irq_exit+0x61/0xd0
>   [<ffffffff81018d25>] do_IRQ+0x65/0x110
>   [<ffffffff81672189>] common_interrupt+0x89/0x89
>   <EOI>
>   [<ffffffff814ffe11>] ? cpuidle_enter_state+0x151/0x200
>   [<ffffffff814ffee2>] cpuidle_enter+0x12/0x20
>   [<ffffffff8109a6ae>] call_cpuidle+0x1e/0x40
>   [<ffffffff8109a8f6>] cpu_startup_entry+0x146/0x220
>   [<ffffffff810336f8>] start_secondary+0x148/0x170
> 
> Signed-off-by: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
> Fixes: d94a461d7a7d ("ath9k: use ieee80211_tx_status_noskb where possible")
> Cc: <stable@vger.kernel.org> # v4.9
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to ath-current branch of ath.git, thanks.

d1f1c0e289e1 ath9k: do not return early to fix rcu unlocking

-- 
https://patchwork.kernel.org/patch/9472709/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
