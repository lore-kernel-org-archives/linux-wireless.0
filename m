Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:36422 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753104AbdHGL1E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:27:04 -0400
Received: by mail-wr0-f171.google.com with SMTP id y43so606105wrd.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:27:04 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 14/34] brcmfmac: Remove brcmf_sdiod_addrprep()
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-15-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
Message-ID: <59884E86.9040502@broadcom.com> (sfid-20170807_133252_376304_A89F46C7)
Date: Mon, 7 Aug 2017 13:27:02 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-15-ian@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/26/2017 10:25 PM, Ian Molton wrote:
> This function has become trivial enough that it may as well be pushed into
> its callers, which has the side-benefit of clarifying what's going on.
>
> Remove it, and rename brcmf_sdiod_set_sbaddr_window() to
> brcmf_sdiod_set_backplane_window() as it's easier to understand.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>

comments below...

> # Conflicts:
> #	drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 78 ++++++++++++----------
>   1 file changed, 44 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index b2945b463fd3..24775869aee4 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -228,41 +228,25 @@ void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
>   	sdiodev->state = state;
>   }
>
> -static int brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev,
> -					 u32 address)
> +static int
> +brcmf_sdiod_set_backplane_window(struct brcmf_sdio_dev *sdiodev, u32 addr)
>   {
> +	u32 v, bar0 = addr & SBSDIO_SBWINDOW_MASK;
>   	int err = 0, i;
> -	u32 addr;
>
> -	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
> -		return -ENOMEDIUM;

So now you are dropping the state check here, which seems significant 
enough to mention in the commit log. We need to discuss that. The idea 
of it was to refrain from using IO function of the MMC stack when we no 
there is no longer a device, ie. when stack has previously returned a 
-ENOMEDIUM.

> +	if (bar0 == sdiodev->sbwad)
> +		return 0;
>
> -	addr = (address & SBSDIO_SBWINDOW_MASK) >> 8;
> +	v = bar0 >> 8;

why introducing a new variable on the stack. You actually don't need any 
and just mask and shift the addr variable passed to the function.

> -	for (i = 0 ; i < 3 && !err ; i++, addr >>= 8)
> +	for (i = 0 ; i < 3 && !err ; i++, v >>= 8)
>   		brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i,
> -				   addr & 0xff, &err);
> -
> -	return err;
> -}
> -
> -static int brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, u32 *addr)
> -{
> -	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
> -	int err = 0;
> -
> -	if (bar0 != sdiodev->sbwad) {
> -		err = brcmf_sdiod_set_sbaddr_window(sdiodev, bar0);
> -		if (err)
> -			return err;
> +				   v & 0xff, &err);
>
> +	if (!err)
>   		sdiodev->sbwad = bar0;
> -	}
> -
> -	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
> -	*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
>
> -	return 0;
> +	return err;
>   }
>
>   u32 brcmf_sdiod_readl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
> @@ -270,11 +254,17 @@ u32 brcmf_sdiod_readl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
>   	u32 data = 0;
>   	int retval;
>
> -	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
> +	retval = brcmf_sdiod_set_backplane_window(sdiodev, addr);
> +	if (retval)
> +		goto out;
> +
> +	addr &= SBSDIO_SB_OFT_ADDR_MASK;
> +	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
>
>   	if (!retval)
>   		data = sdio_readl(sdiodev->func[1], addr, &retval);

The if-statement is now redundant here...

>
> +out:
>   	if (ret)
>   		*ret = retval;
>
> @@ -286,11 +276,17 @@ void brcmf_sdiod_writel(struct brcmf_sdio_dev *sdiodev, u32 addr,
>   {
>   	int retval;
>
> -	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
> +	retval = brcmf_sdiod_set_backplane_window(sdiodev, addr);
> +	if (retval)
> +		goto out;
> +
> +	addr &= SBSDIO_SB_OFT_ADDR_MASK;
> +	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
>
>   	if (!retval)
>   		sdio_writel(sdiodev->func[1], data, addr, &retval);

...and here.

> +out:
>   	if (ret)
>   		*ret = retval;
>   }
