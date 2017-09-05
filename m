Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38830 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752858AbdIEVUu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 17:20:50 -0400
Received: by mail-wm0-f50.google.com with SMTP id 187so24019438wmn.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Sep 2017 14:20:50 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 21/30] brcmfmac: Remove {r,w}_sdreg32
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-22-ian@mnementh.co.uk>
Message-ID: <79a7dce3-2075-963f-22d5-2a146f1842e0@broadcom.com> (sfid-20170905_232109_867357_616AA5CD)
Date: Tue, 5 Sep 2017 23:20:48 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-22-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> Remove yet another IO function from the code and replace with one
> that already exists.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 91 +++++++++++-----------
>   1 file changed, 45 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 289ff61b7bf8..c1f3366871e5 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c

[...]

> @@ -1075,6 +1051,8 @@ static void brcmf_sdio_get_console_addr(struct brcmf_sdio *bus)
>   
>   static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
>   {
> +	struct brcmf_sdio_dev *sdiod = bus->sdiodev;
> +	struct brcmf_core *core = bus->sdio_core;
>   	u32 intstatus = 0;
>   	u32 hmb_data;
>   	u8 fcbits;
> @@ -1083,10 +1061,13 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
>   	brcmf_dbg(SDIO, "Enter\n");
>   
>   	/* Read mailbox data and ack that we did so */
> -	ret = r_sdreg32(bus, &hmb_data,	__sd_reg(tohostmailboxdata));
> +	hmb_data = brcmf_sdiod_readl(sdiod, core->base +
> +					__sd_reg(tohostmailboxdata), &ret);

Please keep the address calculation (base + offset) in one line.

> +
> +	if (!ret)
> +		brcmf_sdiod_writel(sdiod, core->base + __sd_reg(tosbmailbox),
> +				   SMB_INT_ACK, &ret);
>   
> -	if (ret == 0)
> -		w_sdreg32(bus, SMB_INT_ACK, __sd_reg(tosbmailbox));
>   	bus->sdcnt.f1regdata += 2;
>   
>   	/* Dongle recomposed rx frames, accept them again */

[...]

> @@ -4044,7 +4041,9 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
>   	if (!err) {
>   		/* Set up the interrupt mask and enable interrupts */
>   		bus->hostintmask = HOSTINTMASK;
> -		w_sdreg32(bus, bus->hostintmask, __sd_reg(hostintmask));
> +		brcmf_sdiod_writel(sdiod, core->base + __sd_reg(hostintmask),
> +				   bus->hostintmask, NULL);
> +
>   
>   		brcmf_sdiod_writeb(sdiodev, SBSDIO_WATERMARK, 8, &err);

It seems this function has two pointer variables, ie. sdiod and sdiodev, 
pointing to the same instance.

>   	} else {
> 
