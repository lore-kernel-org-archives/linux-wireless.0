Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38890 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754888AbcLTLV2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 06:21:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, driver-devel@vger.kernel.org,
        Stable <stable@vger.kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
Subject: Re: [PATCH] rtlwifi: Fix kernel oops introduced with commit e49656147359
References: <20161220023812.5999-1-Larry.Finger@lwfinger.net>
Date: Tue, 20 Dec 2016 13:21:21 +0200
In-Reply-To: <20161220023812.5999-1-Larry.Finger@lwfinger.net> (Larry Finger's
        message of "Mon, 19 Dec 2016 20:38:12 -0600")
Message-ID: <87wpeuu9qm.fsf@kamboji.qca.qualcomm.com> (sfid-20161220_122152_626038_39096E62)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> With commit e49656147359 {"rtlwifi: Use dev_kfree_skb_irq instead of
> kfree_skb"), the method used to free an skb was changed because the
> kfree_skb() was inside a spinlock. What was forgotten is that kfree_skb()
> guards against a NULL value for the argument. Routine dev_kfree_skb_irq()
> does not, and a test is needed to prevent kernel panics.
>
> Fixes: commit e49656147359 {"rtlwifi: Use dev_kfree_skb_irq instead of kfree_skb")

This should be:

Fixes: e49656147359 ("rtlwifi: Use dev_kfree_skb_irq instead of kfree_skb")

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> (4.9+)

And this:

Cc: Stable <stable@vger.kernel.org> # 4.9+

I can fix both of them.

> Cc: Wei Yongjun <weiyongjun1@huawei.com>
> ---
> Kalle,
>
> This change should be sent to mainline during the 4.10 merge period,
> or as soon as possible.

Ok, I'll queue this to 4.10. Most likely I'll send a pull request to
Dave later this week or so.

-- 
Kalle Valo
