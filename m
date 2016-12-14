Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55350 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754053AbcLNUqM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 15:46:12 -0500
Subject: Re: [PATCH v2] ath9k: do not return early to fix rcu unlocking
To: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>,
        kvalo@codeaurora.org, helgaas@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        marc.zyngier@arm.com, Janusz.Dziedzic@tieto.com,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        rmanohar@qca.qualcomm.com, bharat.kumar.gogada@xilinx.com
References: <e15c5efc-d548-8b32-ca86-5ec26506ff7c@nbd.name>
 <20161213170807.4853-1-tobias.johannes.klausmann@mni.thm.de>
Cc: "# v4 . 9" <stable@vger.kernel.org>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <b68fee2a-901b-c2ce-f59e-5968f8846d0f@nbd.name> (sfid-20161214_214642_966843_2F201223)
Date: Wed, 14 Dec 2016 21:45:52 +0100
MIME-Version: 1.0
In-Reply-To: <20161213170807.4853-1-tobias.johannes.klausmann@mni.thm.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-12-13 18:08, Tobias Klausmann wrote:
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
Acked-by: Felix Fietkau <nbd@nbd.name>
