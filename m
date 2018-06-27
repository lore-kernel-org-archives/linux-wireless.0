Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57730 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965650AbeF0QN5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 12:13:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/4] libertas_tf: use irqsave() in USB's complete callback
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180620193648.25136-3-bigeasy@linutronix.de>
References: <20180620193648.25136-3-bigeasy@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Message-Id: <20180627161357.103F360791@smtp.codeaurora.org> (sfid-20180627_181413_404072_293079FA)
Date: Wed, 27 Jun 2018 16:13:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> The USB completion callback does not disable interrupts while acquiring
> the lock. We want to remove the local_irq_disable() invocation from
> __usb_hcd_giveback_urb() and therefore it is required for the callback
> handler to disable the interrupts while acquiring the lock.
> The callback may be invoked either in IRQ or BH context depending on the
> USB host controller.
> Use the _irqsave() variant of the locking primitives.
> 
> I am removing the
> 	BUG_ON(!in_interrupt());
> 
> check because it serves no purpose. Running the completion callback in
> BH context makes in_interrupt() still return true but the interrupts
> could be enabled. The important part is that ->driver_lock is acquired
> with disabled interrupts which is the case now.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

3 patches applied to wireless-drivers-next.git, thanks.

fc75122fabb5 libertas_tf: use irqsave() in USB's complete callback
a3128feef6d5 libertas: use irqsave() in USB's complete callback
81454b8405f2 zd1211rw: use irqsave() in USB's complete callback

-- 
https://patchwork.kernel.org/patch/10478609/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
