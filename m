Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36720 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbeAVGOt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 01:14:49 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: release resources in case of error
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180118142348.12759-1-rfried@codeaurora.org>
References: <20180118142348.12759-1-rfried@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: k.eugene.e@gmail.com, bjorn.andersson@linaro.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Ramon Fried <rfried@codeaurora.org>
Message-Id: <20180122061448.B010B6079C@smtp.codeaurora.org> (sfid-20180122_071459_848889_032C6BAA)
Date: Mon, 22 Jan 2018 06:14:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> wrote:

> wcn36xx_dxe_init() doesn't check for the return value
> of wcn36xx_dxe_init_descs().
> This patch releases the resources in case an error ocurred.
> 
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>

Doesn't compile:

drivers/net/wireless/ath/wcn36xx/dxe.c: In function ‘wcn36xx_dxe_deinit_descs’:
drivers/net/wireless/ath/wcn36xx/dxe.c:243:15: error: ‘struct wcn36xx_dxe_ch’ has no member named ‘desc_bum’
  size = wcn_ch->desc_bum * sizeof(struct wcn36xx_dxe_desc);
               ^
drivers/net/wireless/ath/wcn36xx/dxe.c:244:20: error: ‘wcn’ undeclared (first use in this function)
  dma_free_coherent(wcn->dev, size,
                    ^
drivers/net/wireless/ath/wcn36xx/dxe.c:244:20: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/wireless/ath/wcn36xx/dxe.c: In function ‘wcn36xx_dxe_init’:
drivers/net/wireless/ath/wcn36xx/dxe.c:737:3: error: implicit declaration of function ‘dev_error’ [-Werror=implicit-function-declaration]
   dev_error("Error allocating descriptor\n");
   ^
drivers/net/wireless/ath/wcn36xx/dxe.c:818:2: error: expected ‘;’ before ‘if’
  if (ret) {
  ^
drivers/net/wireless/ath/wcn36xx/dxe.c:860:1: warning: label ‘out_err_txh_ch’ defined but not used [-Wunused-label]
 out_err_txh_ch:
 ^
drivers/net/wireless/ath/wcn36xx/dxe.c:856:1: warning: label ‘out_err_rxh_ch’ defined but not used [-Wunused-label]
 out_err_rxh_ch:
 ^
drivers/net/wireless/ath/wcn36xx/dxe.c:760:3: error: label ‘our_err_txh_ch’ used but not defined
   goto our_err_txh_ch;
   ^
cc1: some warnings being treated as errors
make[5]: *** [drivers/net/wireless/ath/wcn36xx/dxe.o] Error 1
make[4]: *** [drivers/net/wireless/ath/wcn36xx] Error 2
make[3]: *** [drivers/net/wireless/ath] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10173325/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
