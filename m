Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60730 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750960AbeAWPMu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 10:12:50 -0500
Subject: Re: wcn36xx: release resources in case of error
To: Kalle Valo <kvalo@codeaurora.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        bjorn.andersson@linaro.org, wcn36xx@lists.infradead.org,
        k.eugene.e@gmail.com
References: <20180118142348.12759-1-rfried@codeaurora.org>
 <20180122061448.91CBD6081E@smtp.codeaurora.org>
From: Ramon Fried <rfried@codeaurora.org>
Message-ID: <2c3a6245-a3a0-b3ca-e1f6-c156d1b46076@codeaurora.org> (sfid-20180123_161259_815925_D8D41C82)
Date: Tue, 23 Jan 2018 17:12:45 +0200
MIME-Version: 1.0
In-Reply-To: <20180122061448.91CBD6081E@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 1/22/2018 8:14 AM, Kalle Valo wrote:
> Ramon Fried <rfried@codeaurora.org> wrote:
>
>> wcn36xx_dxe_init() doesn't check for the return value
>> of wcn36xx_dxe_init_descs().
>> This patch releases the resources in case an error ocurred.
>>
>> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> Doesn't compile:
Sorry Kalle, I mistakenly sent the wrong version of the patch :(
I will sent the correct one shortly.
>
> drivers/net/wireless/ath/wcn36xx/dxe.c: In function ‘wcn36xx_dxe_deinit_descs’:
> drivers/net/wireless/ath/wcn36xx/dxe.c:243:15: error: ‘struct wcn36xx_dxe_ch’ has no member named ‘desc_bum’
>   size = wcn_ch->desc_bum * sizeof(struct wcn36xx_dxe_desc);
>                ^
> drivers/net/wireless/ath/wcn36xx/dxe.c:244:20: error: ‘wcn’ undeclared (first use in this function)
>   dma_free_coherent(wcn->dev, size,
>                     ^
> drivers/net/wireless/ath/wcn36xx/dxe.c:244:20: note: each undeclared identifier is reported only once for each function it appears in
> drivers/net/wireless/ath/wcn36xx/dxe.c: In function ‘wcn36xx_dxe_init’:
> drivers/net/wireless/ath/wcn36xx/dxe.c:737:3: error: implicit declaration of function ‘dev_error’ [-Werror=implicit-function-declaration]
>    dev_error("Error allocating descriptor\n");
>    ^
> drivers/net/wireless/ath/wcn36xx/dxe.c:818:2: error: expected ‘;’ before ‘if’
>   if (ret) {
>   ^
> drivers/net/wireless/ath/wcn36xx/dxe.c:860:1: warning: label ‘out_err_txh_ch’ defined but not used [-Wunused-label]
>  out_err_txh_ch:
>  ^
> drivers/net/wireless/ath/wcn36xx/dxe.c:856:1: warning: label ‘out_err_rxh_ch’ defined but not used [-Wunused-label]
>  out_err_rxh_ch:
>  ^
> drivers/net/wireless/ath/wcn36xx/dxe.c:760:3: error: label ‘our_err_txh_ch’ used but not defined
>    goto our_err_txh_ch;
>    ^
> cc1: some warnings being treated as errors
> make[5]: *** [drivers/net/wireless/ath/wcn36xx/dxe.o] Error 1
> make[4]: *** [drivers/net/wireless/ath/wcn36xx] Error 2
> make[3]: *** [drivers/net/wireless/ath] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [drivers] Error 2
>
> Patch set to Changes Requested.
>
