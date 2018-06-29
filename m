Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54396 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933005AbeF2L4m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 07:56:42 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] ath9k: use irqsave() in USB's complete callback
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180620193648.25136-2-bigeasy@linutronix.de>
References: <20180620193648.25136-2-bigeasy@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Message-Id: <20180629115642.51C5160AFF@smtp.codeaurora.org> (sfid-20180629_135655_266863_729E9AB6)
Date: Fri, 29 Jun 2018 11:56:42 +0000 (UTC)
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
> Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

84a0d4669c8f ath9k: use irqsave() in USB's complete callback

-- 
https://patchwork.kernel.org/patch/10478601/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
