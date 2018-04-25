Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48102 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeDYIPY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 04:15:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] net: wireless: zydas: Replace mdelay with msleep in
 zd1201_probe
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1523367004-31935-1-git-send-email-baijiaju1990@gmail.com>
References: <1523367004-31935-1-git-send-email-baijiaju1990@gmail.com>
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: davem@davemloft.net, stephen@networkplumber.org,
        arvind.yadav.cs@gmail.com, johannes.berg@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Message-Id: <20180425081523.98D9D60556@smtp.codeaurora.org> (sfid-20180425_101549_258918_4A06A81A)
Date: Wed, 25 Apr 2018 08:15:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> zd1201_probe() is never called in atomic context.
> 
> zd1201_probe() is only set as ".probe" in struct usb_driver.
> 
> Despite never getting called from atomic context, zd1201_probe()
> calls mdelay() to busily wait.
> This is not necessary and can be replaced with msleep() to
> avoid busy waiting.
> 
> This is found by a static analysis tool named DCNS written by myself.
> And I also manually check it.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

I need a review from someone else before I'm willing to take this.

-- 
https://patchwork.kernel.org/patch/10333189/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
