Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36596 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdEaK1U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 06:27:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix a sleep-in-atomic bug in b43legacy_op_bss_info_changed
References: <1496225353-5544-1-git-send-email-baijiaju1990@163.com>
Date: Wed, 31 May 2017 13:26:43 +0300
In-Reply-To: <1496225353-5544-1-git-send-email-baijiaju1990@163.com> (Jia-Ju
        Bai's message of "Wed, 31 May 2017 18:09:13 +0800")
Message-ID: <877f0xnwyk.fsf@kamboji.qca.qualcomm.com> (sfid-20170531_122806_843345_65F79250)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jia-Ju Bai <baijiaju1990@163.com> writes:

> The driver may sleep under a spin lock, and the function call path is:
> b43legacy_op_bss_info_changed (acquire the lock by spin_lock_irqsave)
>   b43legacy_synchronize_irq
>     synchronize_irq --> may sleep
>
> To fix it, the lock is released before b43legacy_synchronize_irq, and the 
> lock is acquired again after this function.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> ---
>  drivers/net/wireless/broadcom/b43legacy/main.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
> index f1e3dad..31ead21 100644
> --- a/drivers/net/wireless/broadcom/b43legacy/main.c
> +++ b/drivers/net/wireless/broadcom/b43legacy/main.c
> @@ -2859,7 +2859,9 @@ static void b43legacy_op_bss_info_changed(struct ieee80211_hw *hw,
>  	b43legacy_write32(dev, B43legacy_MMIO_GEN_IRQ_MASK, 0);
>  
>  	if (changed & BSS_CHANGED_BSSID) {
> +		spin_unlock_irqrestore(&wl->irq_lock, flags);
>  		b43legacy_synchronize_irq(dev);
> +		spin_lock_irqsave(&wl->irq_lock, flags);

To me this looks like a fragile workaround and not a real fix. You can
easily add new race conditions with releasing the lock like this.

-- 
Kalle Valo
