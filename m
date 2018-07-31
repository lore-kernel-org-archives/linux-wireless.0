Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43884 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731007AbeHAAGk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 20:06:40 -0400
Subject: Re: [PATCH] ath10k: fix kernel panic by moving pci flush after
 napi_disable
To: Tamizh chelvam <tamizhr@codeaurora.org>, ath10k@lists.infradead.org
References: <1532931051-20118-1-git-send-email-tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <ef5defff-0687-4b47-4880-a88dd5e99e86@candelatech.com> (sfid-20180801_002420_686814_EC9FD1B9)
Date: Tue, 31 Jul 2018 15:24:10 -0700
MIME-Version: 1.0
In-Reply-To: <1532931051-20118-1-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/29/2018 11:10 PM, Tamizh chelvam wrote:
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

I have been testing this for two days while bisecting buggy 10.4 9984 firmware.  I still see
crashes, but it is certainly no worse.  So, this patch seems OK to me.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
