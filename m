Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:40567 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbASMgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 07:36:09 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.19] ath9k: fix race condition in irq processing during hardware reset
References: <1421241456-29085-1-git-send-email-nbd@openwrt.org>
Date: Mon, 19 Jan 2015 14:36:02 +0200
In-Reply-To: <1421241456-29085-1-git-send-email-nbd@openwrt.org> (Felix
	Fietkau's message of "Wed, 14 Jan 2015 14:17:36 +0100")
Message-ID: <87sif7j6bx.fsf@kamboji.qca.qualcomm.com> (sfid-20150119_133613_675851_4B78B2C3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> To fix invalid hardware accesses, the commit
> "ath9k: do not access hardware on IRQs during reset" made the irq
> handler ignore interrupts emitted after queueing a hardware reset (which
> disables the IRQ). This left a small time window for the IRQ to get
> re-enabled by the tasklet, which caused IRQ storms.
> Instead of returning IRQ_NONE when ATH_OP_HW_RESET is set, disable the
> IRQ entirely for the duration of the reset.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, applied to wireless-drivers.git. I made a small change and added
the commit id to the commit log:

commit e3f31175a3eeb492a6ab788e4fa136c19b43aab4
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Wed Jan 14 14:17:36 2015 +0100

    ath9k: fix race condition in irq processing during hardware reset
    
    To fix invalid hardware accesses, the commit 872b5d814f99 ("ath9k: do not
    access hardware on IRQs during reset") made the irq handler ignore interrupts
    emitted after queueing a hardware reset (which disables the IRQ). This left a
    small time window for the IRQ to get re-enabled by the tasklet, which caused
    IRQ storms.  Instead of returning IRQ_NONE when ATH_OP_HW_RESET is set, disable
    the IRQ entirely for the duration of the reset.
    
    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
