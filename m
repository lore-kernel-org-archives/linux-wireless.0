Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45672 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938698AbcKQGsw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 01:48:52 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [net-next] rtlwifi: Use dev_kfree_skb_irq instead of kfree_skb
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1478011720-27363-1-git-send-email-weiyj.lk@gmail.com>
References: <1478011720-27363-1-git-send-email-weiyj.lk@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org
Message-Id: <20161117064851.6B611615E4@smtp.codeaurora.org> (sfid-20161117_074855_539945_87912FCF)
Date: Thu, 17 Nov 2016 06:48:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> It is not allowed to call kfree_skb() from hardware interrupt
> context or with interrupts being disabled, spin_lock_irqsave()
> make sure always in irq disable context. So the kfree_skb()
> should be replaced with dev_kfree_skb_irq().
> 
> This is detected by Coccinelle semantic patch.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

e49656147359 rtlwifi: Use dev_kfree_skb_irq instead of kfree_skb

-- 
https://patchwork.kernel.org/patch/9407493/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
