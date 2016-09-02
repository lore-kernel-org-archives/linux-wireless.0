Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37780 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752328AbcIBQY7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 12:24:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 1/2] wcn36xx: Transition driver to SMD client
References: <1472741468-24762-1-git-send-email-bjorn.andersson@linaro.org>
Date: Fri, 02 Sep 2016 19:24:50 +0300
In-Reply-To: <1472741468-24762-1-git-send-email-bjorn.andersson@linaro.org>
        (Bjorn Andersson's message of "Thu, 1 Sep 2016 07:51:07 -0700")
Message-ID: <87mvjqz2ul.fsf@kamboji.qca.qualcomm.com> (sfid-20160902_182541_161377_98F45C5C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjorn Andersson <bjorn.andersson@linaro.org> writes:

> The wcn36xx wifi driver follows the life cycle of the WLAN_CTRL SMD
> channel, as such it should be a SMD client. This patch makes this
> transition, now that we have the necessary frameworks available.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

[...]

> --- a/drivers/net/wireless/ath/wcn36xx/Kconfig
> +++ b/drivers/net/wireless/ath/wcn36xx/Kconfig
> @@ -1,6 +1,6 @@
>  config WCN36XX
>  	tristate "Qualcomm Atheros WCN3660/3680 support"
> -	depends on MAC80211 && HAS_DMA
> +	depends on MAC80211 && HAS_DMA && QCOM_SMD

While I had this patch on my pending branch I noticed that I can't
compile wcn36xx on x86 anymore. This is actually quite inconvenient, for
example then it's easy to miss mac80211 API changes etc. Is there any
way we could continue build testing wcn36xx on x86 (or all) platforms?

Also what about older platforms? Earlier I used wcn36xx on my Nexus 4
with help of backports project. I can't do that anymore, right?

-- 
Kalle Valo
