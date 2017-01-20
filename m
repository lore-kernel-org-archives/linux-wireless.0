Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41118 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbdATKDP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 05:03:15 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] brcmfmac: fix incorrect event channel deduction
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170117232405.7672-1-gavinli@thegavinli.com>
References: <20170117232405.7672-1-gavinli@thegavinli.com>
To: Gavin Li <gavinli@thegavinli.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, stable@vger.kernel.org,
        Gavin Li <git@thegavinli.com>
Message-Id: <20170120100314.C4AFE609EF@smtp.codeaurora.org> (sfid-20170120_110324_408614_1BF52DA1)
Date: Fri, 20 Jan 2017 10:03:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gavin Li <gavinli@thegavinli.com> wrote:
> From: Gavin Li <git@thegavinli.com>
> 
> brcmf_sdio_fromevntchan() was being called on the the data frame
> rather than the software header, causing some frames to be
> mischaracterized as on the event channel rather than the data channel.
> 
> This fixes a major performance regression (due to dropped packets). With 
> this patch the download speed jumped from 1Mbit/s back up to 40MBit/s due
> to the sheer amount of packets being incorrectly processed.
> 
> Fixes: c56caa9db8ab ("brcmfmac: screening firmware event packet")
> Signed-off-by: Gavin Li <git@thegavinli.com>
> Cc: <stable@vger.kernel.org> # 4.7+
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> [kvalo@codeaurora.org: improve commit logs based on email discussion]

Patch applied to wireless-drivers-next.git, thanks.

8e290cecdd01 brcmfmac: fix incorrect event channel deduction

-- 
https://patchwork.kernel.org/patch/9522185/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
