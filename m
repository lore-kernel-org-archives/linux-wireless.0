Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbeHXPR6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 11:17:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ath10k: fix kernel panic by moving pci flush after
 napi_disable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1532931051-20118-1-git-send-email-tamizhr@codeaurora.org>
References: <1532931051-20118-1-git-send-email-tamizhr@codeaurora.org>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Message-Id: <20180824114341.A74946053B@smtp.codeaurora.org> (sfid-20180824_134344_603136_C77D5AB0)
Date: Fri, 24 Aug 2018 11:43:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tamizh chelvam <tamizhr@codeaurora.org> wrote:

> When continuously running wifi up/down sequence, the napi poll
> can be scheduled after the CE buffers being freed by ath10k_pci_flush
> 
> Steps:
>   In a certain condition, during wifi down below scenario might occur.
> 
> ath10k_stop->ath10k_hif_stop->napi_schedule->ath10k_pci_flush->napi_poll(napi_synchronize).
> 
> In the above scenario, CE buffer entries will be freed up and become NULL in
> ath10k_pci_flush. And the napi_poll has been invoked after the flush process
> and it will try to get the skb from the CE buffer entry and perform some action on that.
> Since the CE buffer already cleaned by pci flush this action will create NULL
> pointer dereference and trigger below kernel panic.
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000005c
> PC is at ath10k_pci_htt_rx_cb+0x64/0x3ec [ath10k_pci]
> ath10k_pci_htt_rx_cb [ath10k_pci]
> ath10k_ce_per_engine_service+0x74/0xc4 [ath10k_pci]
> ath10k_ce_per_engine_service [ath10k_pci]
> ath10k_ce_per_engine_service_any+0x74/0x80 [ath10k_pci]
> ath10k_ce_per_engine_service_any [ath10k_pci]
> ath10k_pci_napi_poll+0x48/0xec [ath10k_pci]
> ath10k_pci_napi_poll [ath10k_pci]
> net_rx_action+0xac/0x160
> net_rx_action
> __do_softirq+0xdc/0x208
> __do_softirq
> irq_exit+0x84/0xe0
> irq_exit
> __handle_domain_irq+0x80/0xa0
> __handle_domain_irq
> gic_handle_irq+0x38/0x5c
> gic_handle_irq
> __irq_usr+0x44/0x60
> 
> Tested on QCA4019 and firmware version 10.4.3.2.1.1-00010
> 
> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

bd1d395070cc ath10k: fix kernel panic by moving pci flush after napi_disable

-- 
https://patchwork.kernel.org/patch/10548453/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
