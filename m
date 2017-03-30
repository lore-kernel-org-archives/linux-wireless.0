Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55726 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932919AbdC3Qob (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 12:44:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [for-4.11,
 1/2] brcmfmac: use local iftype avoiding use-after-free of virtual
 interface
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1490688691-20100-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1490688691-20100-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Daniel J Blueman <daniel@quora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170330164429.CBF7060E0E@smtp.codeaurora.org> (sfid-20170330_184434_636486_304C761D)
Date: Thu, 30 Mar 2017 16:44:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> A use-after-free was found using KASAN. In brcmf_p2p_del_if() the virtual
> interface is removed using call to brcmf_remove_interface(). After that
> the virtual interface instance has been freed and should not be referenced.
> Solve this by storing the nl80211 iftype in local variable, which is used
> in a couple of places anyway.
> 
> Cc: stable@vger.kernel.org # 4.10.x, 4.9.x
> Reported-by: Daniel J Blueman <daniel@quora.org>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers.git, thanks.

d77facb88448 brcmfmac: use local iftype avoiding use-after-free of virtual interface

-- 
https://patchwork.kernel.org/patch/9648553/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
