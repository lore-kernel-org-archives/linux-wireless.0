Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57468 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdARKfe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 05:35:34 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: gavinli@thegavinli.com
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, stable@vger.kernel.org,
        Gavin Li <git@thegavinli.com>
Subject: Re: [PATCH] brcmfmac: fix incorrect event channel deduction
References: <20170117231534.7099-1-gavinli@thegavinli.com>
Date: Wed, 18 Jan 2017 12:27:25 +0200
In-Reply-To: <20170117231534.7099-1-gavinli@thegavinli.com>
        (gavinli@thegavinli.com's message of "Tue, 17 Jan 2017 15:15:34
        -0800")
Message-ID: <87r340hdde.fsf@purkki.adurom.net> (sfid-20170118_113537_861910_A11518DB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gavinli@thegavinli.com writes:

> From: Gavin Li <git@thegavinli.com>
>
> brcmf_sdio_fromevntchan() was being called on the the data frame
> rather than the software header, causing some frames to be
> mischaracterized as on the event channel rather than the data channel.
>
> This fixes a major performance regression (due to dropped packets).
>
> Fixes: c56caa9db8ab ("brcmfmac: screening firmware event packet")
> Signed-off-by: Gavin Li <git@thegavinli.com>
> Cc: <stable@vger.kernel.org> [4.7+]

In the future please add version to the subject so that maintainers can
easily find the latest version:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject

Arend, do you think this is safe enough for 4.10? Or better to get more
testing time and push this to 4.11 and from where to stable releases?

-- 
Kalle Valo
