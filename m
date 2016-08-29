Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60646 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932816AbcH2MOK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 08:14:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath9k-devel@lists.ath9k.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@linaro.org,
        xie.baoyou@zte.com.cn
Subject: Re: [PATCH] fix:gpio: mark symbols static where possible
References: <1472315228-14802-1-git-send-email-baoyou.xie@linaro.org>
Date: Mon, 29 Aug 2016 15:14:05 +0300
In-Reply-To: <1472315228-14802-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Sun, 28 Aug 2016 00:27:08 +0800")
Message-ID: <87vayj3h82.fsf@purkki.adurom.net> (sfid-20160829_141434_189919_FF26634E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Baoyou Xie <baoyou.xie@linaro.org> writes:

> We get 1 warning about global functions without a declaration
> in the ath9k gpio driver when building with W=1:
> drivers/net/wireless/ath/ath9k/gpio.c:25:6: warning: no previous prototype for 'ath_fill_led_pin' [-Wmissing-prototypes]
>
> In fact, this function is only used in the file in which it is declared
> and don't need a declaration, but can be made static.
> so this patch marks it 'static'.
>
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
> ---
>  drivers/net/wireless/ath/ath9k/gpio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

The commit title should be:

ath9k: mark ath_fill_led_pin() static

Check the wiki how to create titles:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject_name

-- 
Kalle Valo
