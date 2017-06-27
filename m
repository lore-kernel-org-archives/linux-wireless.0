Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51430 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752454AbdF0OO1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 10:14:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: fix double free upon register_netdevice() failure
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1498338507-3432-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1498338507-3432-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170627141416.E81DB6071A@smtp.codeaurora.org> (sfid-20170627_163552_164897_B90F8D23)
Date: Tue, 27 Jun 2017 14:14:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> The function brcmf_net_attach() can only fail when register_netdevice()
> fails. When this happens register_netdevice() calls priv_destructor, ie.
> brcmf_cfg80211_free_netdev() freeing the vif instance. Also upon this
> failure brcmf_net_attach() calls free_netdev(). However, callers are also
> doing cleanup resulting in double free. In some places they need netdev
> private space as it holds parameters to communicate with the device. So
> we want to do the cleanup only in callers of brcmf_net_attach() by making
> the following changes:
> 
>  - set priv_destructor after register_netdevice() succeeds.
>  - remove call to free_netdev() in brcmf_net_attach().
>  - call free_netdev() in brcmf_net_detach() for unregistered netdev.
>  - add free_netdev() if brcmf_net_attach() fails for a created interface.
> 
> Fixes: cf124db566e6 ("net: Fix inconsistent teardown and release of private netdev state.")
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

dca2307ed625 brcmfmac: fix double free upon register_netdevice() failure

-- 
https://patchwork.kernel.org/patch/9807903/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
