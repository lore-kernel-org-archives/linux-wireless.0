Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52648 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdFILax (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 07:30:53 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH V5 1/3] brcmfmac: add support multi-scheduled scan
References: <1497007162-13013-1-git-send-email-arend.vanspriel@broadcom.com>
Date: Fri, 09 Jun 2017 14:30:34 +0300
In-Reply-To: <1497007162-13013-1-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Fri, 9 Jun 2017 12:19:20 +0100")
Message-ID: <87efutcs9x.fsf@kamboji.qca.qualcomm.com> (sfid-20170609_133057_224436_FABED72C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> From: Arend Van Spriel <arend.vanspriel@broadcom.com>
>
> This change adds support for multi-scheduled scan in the driver. It
> currently relies on g-scan support in firmware and will set struct
> wiphy::max_sched_scan_reqs accordingly. This is limited to 16 concurrent
> requests.
>
> The firmware currently has a limit of 64 channels that can be configured
> for all requests in total regardless whether there are duplicates. So if
> a request uses 35 channels there are 29 channels left for another request.
> When user-space does not specify any channels cfg80211 will add all
> channels defined by the wiphy instance to the request, which makes
> reaching the limit rather easy for dual-band devices.
>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
> Hi Kalle,
>
> Here a retry for the multi-scheduled scan patches in brcmfmac. Not sure
> if the warnings are gone now. Also stumbled on some error prints that
> should be debug prints so fixed those as well.

Thanks, I didn't see the warnings anymore. But just to be on the safe
side I pushed these to the pending branch for some kbuild bot testing.

-- 
Kalle Valo
