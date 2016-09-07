Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44358 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934982AbcIGLf2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 07:35:28 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andy Gross <andy.gross@linaro.org>
Subject: Re: [PATCH v4 2/4] wcn36xx: Transition driver to SMD client
References: <1473200312-22438-1-git-send-email-bjorn.andersson@linaro.org>
        <1473200312-22438-2-git-send-email-bjorn.andersson@linaro.org>
Date: Wed, 07 Sep 2016 14:35:17 +0300
In-Reply-To: <1473200312-22438-2-git-send-email-bjorn.andersson@linaro.org>
        (Bjorn Andersson's message of "Tue, 6 Sep 2016 15:18:30 -0700")
Message-ID: <87zinkvt6y.fsf@kamboji.qca.qualcomm.com> (sfid-20160907_133551_447726_F74A89C9)
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
> ---
>
> Changes since v3:
> - Made msg_header const in wcn36xx_smd_rsp_process()
>
> Changes since v2:
> - Correct the call to the new ieee80211_scan_completed()
>
>  drivers/net/wireless/ath/wcn36xx/dxe.c     | 16 +++---
>  drivers/net/wireless/ath/wcn36xx/main.c    | 79 ++++++++++++++++++++----------
>  drivers/net/wireless/ath/wcn36xx/smd.c     | 31 +++++-------
>  drivers/net/wireless/ath/wcn36xx/smd.h     |  5 ++
>  drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 21 +++-----
>  5 files changed, 86 insertions(+), 66 deletions(-)

So I don't actually need to enable COMPILE_TEST anymore? Nice, thanks.

-- 
Kalle Valo
