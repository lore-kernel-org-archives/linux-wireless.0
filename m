Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29439 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932995AbcKPSts (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 13:49:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v5,1/5] soc: qcom: smem_state: Fix include for ERR_PTR()
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1479190014-11297-1-git-send-email-bjorn.andersson@linaro.org>
References: <1479190014-11297-1-git-send-email-bjorn.andersson@linaro.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
CC: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Andy Gross <andy.gross@linaro.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Message-ID: <a4095c49fe5a42c4a405b1faf6c0f3b7@euamsexm01a.eu.qualcomm.com> (sfid-20161116_195010_949459_7655097C)
Date: Wed, 16 Nov 2016 19:49:38 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> The correct include file for getting errno constants and ERR_PTR() is
> linux/err.h, rather than linux/errno.h, so fix the include.
> 
> Fixes: e8b123e60084 ("soc: qcom: smem_state: Add stubs for disabled smem_state")
> Acked-by: Andy Gross <andy.gross@linaro.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

For some reason this fails to compile now. Can you take a look, please?

ERROR: "qcom_wcnss_open_channel" [drivers/net/wireless/ath/wcn36xx/wcn36xx.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

5 patches set to Changes Requested.

9429045 [v5,1/5] soc: qcom: smem_state: Fix include for ERR_PTR()
9429047 [v5,2/5] wcn36xx: Transition driver to SMD client
9429037 [v5,3/5] wcn36xx: Implement firmware assisted scan
9429043 [v5,4/5] wcn36xx: Implement print_reg indication
9429023 [v5,5/5] wcn36xx: Don't use the destroyed hal_mutex

-- 
https://patchwork.kernel.org/patch/9429045/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
