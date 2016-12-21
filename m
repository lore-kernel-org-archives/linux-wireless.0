Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42040 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbcLUOfV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Dec 2016 09:35:21 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: Fix kernel oops introduced with commit e49656147359
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161220023812.5999-1-Larry.Finger@lwfinger.net>
References: <20161220023812.5999-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, driver-devel@vger.kernel.org,
        Stable <stable@vger.kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
Message-Id: <20161221143520.5873D61662@smtp.codeaurora.org> (sfid-20161221_153524_657506_BB391A5A)
Date: Wed, 21 Dec 2016 14:35:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> With commit e49656147359 {"rtlwifi: Use dev_kfree_skb_irq instead of
> kfree_skb"), the method used to free an skb was changed because the
> kfree_skb() was inside a spinlock. What was forgotten is that kfree_skb()
> guards against a NULL value for the argument. Routine dev_kfree_skb_irq()
> does not, and a test is needed to prevent kernel panics.
> 
> Fixes: e49656147359 ("rtlwifi: Use dev_kfree_skb_irq instead of kfree_skb")
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> # 4.9+
> Cc: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied to wireless-drivers.git, thanks.

22b68b93ae25 rtlwifi: Fix kernel oops introduced with commit e49656147359

-- 
https://patchwork.kernel.org/patch/9481055/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
