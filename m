Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39420 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750986AbdAQMGF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 07:06:05 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V3] brcmfmac: avoid writing channel out of allocated array
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170104110941.21261-1-zajec5@gmail.com>
References: <20170104110941.21261-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20170117115715.A8C43607C9@smtp.codeaurora.org> (sfid-20170117_130610_083727_8540BB78)
Date: Tue, 17 Jan 2017 11:57:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Our code was assigning number of channels to the index variable by
> default. If firmware reported channel we didn't predict this would
> result in using that initial index value and writing out of array. This
> never happened so far (we got a complete list of supported channels) but
> it means possible memory corruption so we should handle it anyway.
> 
> This patch simply detects unexpected channel and ignores it.
> 
> As we don't try to create new entry now, it's also safe to drop hw_value
> and center_freq assignment. For known channels we have these set anyway.
> 
> I decided to fix this issue by assigning NULL or a target channel to the
> channel variable. This was one of possible ways, I prefefred this one as
> it also avoids using channel[index] over and over.
> 
> Fixes: 58de92d2f95e ("brcmfmac: use static superset of channels for wiphy bands")
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

77c0d0cd10e7 brcmfmac: avoid writing channel out of allocated array

-- 
https://patchwork.kernel.org/patch/9496471/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
