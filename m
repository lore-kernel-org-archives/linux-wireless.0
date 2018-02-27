Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50082 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbeB0QtQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:49:16 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: Fix warning due to duplicate scan_completed notification
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1518692908-29303-1-git-send-email-loic.poulain@linaro.org>
References: <1518692908-29303-1-git-send-email-loic.poulain@linaro.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: k.eugene.e@gmail.com, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, wcn36xx@lists.infradead.org,
        Loic Poulain <loic.poulain@linaro.org>
Message-Id: <20180227164915.8601E60271@smtp.codeaurora.org> (sfid-20180227_174921_021498_02557812)
Date: Tue, 27 Feb 2018 16:49:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Loic Poulain <loic.poulain@linaro.org> wrote:

> The wcn36xx_cancel_hw_scan method stops the hw scan and notify the
> scan completion via ieee80211_scan_completed.
> However, on scan offload cancellation, firmware sends a scan complete
> indication, triggering a new call to ieee80211_scan_completed.
> This leads to kernel warn since the scan has already been completed.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9bfd05e35ac3 wcn36xx: Fix warning due to duplicate scan_completed notification

-- 
https://patchwork.kernel.org/patch/10220895/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
