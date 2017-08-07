Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38639 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752122AbdHGMcF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 08:32:05 -0400
Received: by mail-wm0-f41.google.com with SMTP id m85so5869519wma.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 05:32:04 -0700 (PDT)
Subject: Re: [PATCH 29/34] brcmfmac: stabilise the value of ->sbwad in use for
 some xfer routines.
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-30-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <59885DC2.6040600@broadcom.com> (sfid-20170807_143208_621620_5449C2CE)
Date: Mon, 7 Aug 2017 14:32:02 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-30-ian@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So now I jump to this patch
On 7/26/2017 10:25 PM, Ian Molton wrote:
> The IO functions operate within the Chipcommon IO window. Explicitly
> set this, rather than relying on the last initialisation IO access to
> leave it set to the right value by chance.

> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 ++++----
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 5 +++++
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 1 +
>   3 files changed, 10 insertions(+), 4 deletions(-)
>

[...]

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
> index fb4f24dfc99d..1ab95011adb0 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
> @@ -178,6 +178,7 @@ struct brcmf_sdio_dev {
>   	struct sdio_func *func[SDIO_MAX_FUNCS];
>   	u8 num_funcs;			/* Supported funcs on client */
>   	u32 sbwad;			/* Save backplane window address */
> +	struct brcmf_core *cc_core;	/* chipcommon core info struct */

We actually just need the chipcommon base address so why not have that 
here, ie.:
+	u32 cc_base;

Another option is to simple use SI_ENUM_BASE as the chipcommon base 
address will always be 0x18000000 for the SDIO chips.

>   	struct brcmf_sdio *bus;
>   	struct device *dev;
>   	struct brcmf_bus *bus_if;
>
