Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:32794 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750756AbdH3Tha (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 15:37:30 -0400
Received: by mail-wm0-f48.google.com with SMTP id r202so3810388wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:37:29 -0700 (PDT)
Subject: Re: [PATCH 18/30] brcmfmac: Cleanup offsetof()
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-19-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c4412aaa-1c66-44d5-1f0b-cc208aad7e60@broadcom.com> (sfid-20170830_213734_252658_B2F8F33E)
Date: Wed, 30 Aug 2017 21:37:27 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-19-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> Create a macro to make the code a bit more readable, whilst we're stuck
> with using struct element offsets as register offsets.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 35 +++++++++-------------
>   1 file changed, 14 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index ce19ccf5d1d6..8f3e99da871a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -161,6 +161,8 @@ struct rte_console {
>   
>   #define CORE_BUS_REG(base, field) \
>   		(base + offsetof(struct sdpcmd_regs, field))
> +#define __sd_reg(field) \
> +		(offsetof(struct sdpcmd_regs, field))

I really dislike __foo() stuff. Please just stick with uppercase for 
macros, so SD_REG(). I am fine with dropping the base here.
