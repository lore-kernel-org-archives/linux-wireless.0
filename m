Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43550 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757046AbdCURcI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 13:32:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH] rtlwifi: Fix scheduling while atomic splat
References: <20170321142411.24044-1-Larry.Finger@lwfinger.net>
Date: Tue, 21 Mar 2017 19:32:02 +0200
In-Reply-To: <20170321142411.24044-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Tue, 21 Mar 2017 09:24:11 -0500")
Message-ID: <87fui65yel.fsf@kamboji.qca.qualcomm.com> (sfid-20170321_183344_550801_DD524F7E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Following commit cceb0a597320 ("rtlwifi: Add work queue for c2h cmd."),
> the following BUG is reported when rtl8723be is used:
>
> BUG: sleeping function called from invalid context at mm/slab.h:432
> in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper/0
> CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W  O    4.11.0-rc3-wl+ #276
> Hardware name: TOSHIBA TECRA A50-A/TECRA A50-A, BIOS Version 4.50   09/29/2014
> Call Trace:
>  <IRQ>
>  dump_stack+0x63/0x89
>  ___might_sleep+0xe9/0x130
>  __might_sleep+0x4a/0x90
>  kmem_cache_alloc_trace+0x19f/0x200
>  ? rtl_c2hcmd_enqueue+0x3e/0x110 [rtlwifi]
>  rtl_c2hcmd_enqueue+0x3e/0x110 [rtlwifi]
>  rtl8723be_c2h_packet_handler+0xac/0xc0 [rtl8723be]
>  rtl8723be_rx_command_packet+0x37/0x5c [rtl8723be]
>  _rtl_pci_rx_interrupt+0x200/0x6b0 [rtl_pci]
>  _rtl_pci_interrupt+0x20c/0x5d0 [rtl_pci]
>  __handle_irq_event_percpu+0x3f/0x1d0
>  handle_irq_event_percpu+0x23/0x60
>  handle_irq_event+0x3c/0x60
>  handle_fasteoi_irq+0xa2/0x170
>  handle_irq+0x20/0x30
>  do_IRQ+0x48/0xd0
>  common_interrupt+0x89/0x89
> ...
>
> Although commit cceb0a597320 converted most c2h commands to use a work
> queue, the Bluetooth coexistence routines can be in atomic mode when
> they execute such a call.
>
> Fixes: cceb0a597320 ("rtlwifi: Add work queue for c2h cmd.")
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> ---
> Kalle,
>
> This patch should be applied to kernel 4.11.

Ok, I'll queue this for 4.11.

-- 
Kalle Valo
