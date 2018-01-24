Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41162 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933668AbeAXNWw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 08:22:52 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        bjorn.andersson@linaro.org, wcn36xx@lists.infradead.org,
        k.eugene.e@gmail.com
Subject: Re: [PATCH v2] wcn36xx: release resources in case of error
References: <20180123152013.18257-1-rfried@codeaurora.org>
Date: Wed, 24 Jan 2018 15:22:46 +0200
In-Reply-To: <20180123152013.18257-1-rfried@codeaurora.org> (Ramon Fried's
        message of "Tue, 23 Jan 2018 17:20:13 +0200")
Message-ID: <87tvvbtmqh.fsf@purkki.adurom.net> (sfid-20180124_142305_224482_5D8BDF6D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> writes:

> wcn36xx_dxe_init() doesn't check for the return value
> of wcn36xx_dxe_init_descs().
> This patch releases the resources in case an error ocurred.
>
> Change-Id: I924bd7489b60243c0a0cbaa716caf924f11d7587
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>

This compiled now, thanks. But I did some minor changes in the commit
log and in indentation on the pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=master-pending&id=e5ff4344eab68c86e00036e937847ce89dfaeef6

> @@ -819,11 +847,19 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
>  
>  	ret = wcn36xx_dxe_request_irqs(wcn);
>  	if (ret < 0)
> -		goto out_err;
> +		goto out_err_irq;

The recommended style is to label the err_ based what the target does,
not from where they are called from. It's easier to manage the labels
that way. But as this is a style issue I didn't change it.

-- 
Kalle Valo
