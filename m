Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:36049 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753071AbdLNPch (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:32:37 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: Reduce spinlock in indication handler
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171209003508.3507-1-bjorn.andersson@linaro.org>
References: <20171209003508.3507-1-bjorn.andersson@linaro.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
CC: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <c8782122bc7640a58d6b06f0a845f223@euamsexm01a.eu.qualcomm.com> (sfid-20171214_163300_884136_1371BA1D)
Date: Thu, 14 Dec 2017 16:32:23 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:

> The purpose of pushing indication on a list and handle these in a
> separate worker is to allow the handlers to sleep. It does therefor not
> make much sense to hold the queue spinlock through the entire indication
> worker function.
> 
> By removing items from the queue early we don't need to hold the lock
> throughout the indication worker, allowing the individual handlers to
> sleep.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

6d1f37323f5b wcn36xx: Reduce spinlock in indication handler

-- 
https://patchwork.kernel.org/patch/10103469/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
