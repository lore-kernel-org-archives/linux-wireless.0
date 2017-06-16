Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43546 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752692AbdFPIxW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 04:53:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: fix uninitialized warning in brcmf_usb_probe_phase2()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1497602195-29895-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1497602195-29895-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Message-Id: <20170616085321.8B1D360D5D@smtp.codeaurora.org> (sfid-20170616_105325_759894_C6EB7947)
Date: Fri, 16 Jun 2017 08:53:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> This fixes the following warning:
> 
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c: In function
>   'brcmf_usb_probe_phase2':
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c:1198:2:
>   warning: 'devinfo' may be used uninitialized in this function
>   [-Wmaybe-uninitialized]
>     mutex_unlock(&devinfo->dev_init_lock);
> 
> Fixes: 6d0507a777fb ("brcmfmac: add parameter to pass error code in firmware callback")
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Reported-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers.git, thanks.

35abcd4f9f30 brcmfmac: fix uninitialized warning in brcmf_usb_probe_phase2()

-- 
https://patchwork.kernel.org/patch/9790847/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
