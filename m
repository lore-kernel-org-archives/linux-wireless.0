Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51542 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965478AbeFNO3A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 10:29:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 3/3] wcn36xx: Fix WEP encryption
References: <1527506960-13358-1-git-send-email-loic.poulain@linaro.org>
        <1527506960-13358-3-git-send-email-loic.poulain@linaro.org>
Date: Thu, 14 Jun 2018 17:28:56 +0300
In-Reply-To: <1527506960-13358-3-git-send-email-loic.poulain@linaro.org> (Loic
        Poulain's message of "Mon, 28 May 2018 13:29:20 +0200")
Message-ID: <87d0wt8ms7.fsf@kamboji.qca.qualcomm.com> (sfid-20180614_162920_489101_7C356FEB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Loic Poulain <loic.poulain@linaro.org> writes:

> In case of WEP encryption, driver has to configure shared key for
> associated station(s). Note that sta pointer is NULL in case of non
> pairwise key, causing NULL pointer dereference with existing code
> (sta_priv->is_data_encrypted). Fix this by using associated sta list
> instead.
>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

I guess this fix is for AP mode with WEP encryption? And client mode
with WEP doesn't have any issues?

If yes, I'll clarify that in the commit log.

-- 
Kalle Valo
