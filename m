Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37067 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752878AbdHGL0B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:26:01 -0400
Received: by mail-wm0-f49.google.com with SMTP id t201so4623366wmt.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:26:01 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 07/34] brcmfmac: Remove brcmf_sdiod_request_data()
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-8-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
Message-ID: <59884E46.5090000@broadcom.com> (sfid-20170807_132604_751108_0786C151)
Date: Mon, 7 Aug 2017 13:25:58 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-8-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-07-17 22:25, Ian Molton wrote:
> This function is obfuscating how IO works on this chip. Remove it
> and push its logic into brcmf_sdiod_reg_{read,write}().
>
> Handling of -ENOMEDIUM is altered, but as that's pretty much broken anyway
> we can ignore that.

Please explain why you think it is broken.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>

more comments below.

> # Conflicts:
> #	drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 239 ++++++++-------------
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   2 +-
>  2 files changed, 87 insertions(+), 154 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index d217b1281e0d..f703d7be6a85 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c

[...]

>  static int brcmf_sdiod_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr,
>  				 u8 regsz, void *data)
>  {
> -	u8 func;
> -	s32 retry = 0;
>  	int ret;
>
> -	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
> -		return -ENOMEDIUM;
> -
>  	/*
>  	 * figure out how to read the register based on address range
>  	 * 0x00 ~ 0x7FF: function 0 CCCR and FBR
>  	 * 0x10000 ~ 0x1FFFF: function 1 miscellaneous registers
>  	 * The rest: function 1 silicon backplane core registers
> +	 * f0 writes must be bytewise
>  	 */
> -	if ((addr & ~REG_F0_REG_MASK) == 0)
> -		func = SDIO_FUNC_0;
> -	else
> -		func = SDIO_FUNC_1;
> -
> -	do {
> -		/* for retry wait for 1 ms till bus get settled down */
> -		if (retry)
> -			usleep_range(1000, 2000);
>
> -		ret = brcmf_sdiod_request_data(sdiodev, func, addr, regsz,
> -					       data, true);
> -
> -	} while (ret != 0 && ret != -ENOMEDIUM &&
> -		 retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
> +	if ((addr & ~REG_F0_REG_MASK) == 0) {
> +		if (WARN_ON(regsz > 1))
> +			return -EINVAL;
> +		ret = brcmf_sdiod_f0_writeb(sdiodev->func[0], *(u8 *)data, addr);
> +	} else {
> +		switch (regsz) {
> +		case 1:
> +			sdio_writeb(sdiodev->func[1], *(u8 *)data, addr, &ret);
> +			break;
> +		case 4:
> +			ret = brcmf_sdiod_addrprep(sdiodev, &addr);
> +			if (ret)
> +				goto done;
>
> -	if (ret == -ENOMEDIUM)
> -		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
> +			sdio_writel(sdiodev->func[1], *(u32 *)data, addr, &ret);
> +			break;
> +		default:
> +			BUG();

Please do not use BUG() as it simply crashes the system. You may argue 
that we never reach this unless a coding mistake is made, but still we 
prefer WARN() over BUG() in such cases.

> +			ret = -EINVAL;
> +			break;
> +		}
> +	}
>
> +done:
>  	return ret;
>  }
>
>  static int brcmf_sdiod_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr,
>  				u8 regsz, void *data)
>  {
> -	u8 func;
> -	s32 retry = 0;
>  	int ret;
>
> -	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
> -		return -ENOMEDIUM;
> -
>  	/*
>  	 * figure out how to read the register based on address range
>  	 * 0x00 ~ 0x7FF: function 0 CCCR and FBR
>  	 * 0x10000 ~ 0x1FFFF: function 1 miscellaneous registers
>  	 * The rest: function 1 silicon backplane core registers
> +	 * f0 reads must be bytewise
>  	 */
> -	if ((addr & ~REG_F0_REG_MASK) == 0)
> -		func = SDIO_FUNC_0;
> -	else
> -		func = SDIO_FUNC_1;
> -
> -	do {
> -		memset(data, 0, regsz);
> -
> -		/* for retry wait for 1 ms till bus get settled down */
> -		if (retry)
> -			usleep_range(1000, 2000);
> -
> -		ret = brcmf_sdiod_request_data(sdiodev, func, addr, regsz,
> -					       data, false);
> -
> -	} while (ret != 0 && ret != -ENOMEDIUM &&
> -		 retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
> -
> -	if (ret == -ENOMEDIUM)
> -		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
> -
> -	return ret;
> -}
> -
> -static int
> -brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
> -{
> -	int err = 0, i;
> -	u32 addr;
> -
> -	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
> -		return -ENOMEDIUM;
> -
> -	addr = (address & SBSDIO_SBWINDOW_MASK) >> 8;
> -
> -	for (i = 0 ; i < 3 && !err ; i++, addr >>= 8)
> -		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i,
> -				  addr & 0xff, &err);
> -
> -	return err;
> -}
> -
> -static int
> -brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, u32 *addr)
> -{
> -	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
> -	int err = 0;
> -
> -	if (bar0 != sdiodev->sbwad) {
> -		err = brcmf_sdiod_set_sbaddr_window(sdiodev, bar0);
> -		if (err)
> -			return err;
> +	if ((addr & ~REG_F0_REG_MASK) == 0) {
> +		if (WARN_ON(regsz > 1))
> +			return -EINVAL;
> +		*(u8 *)data = sdio_f0_readb(sdiodev->func[0], addr, &ret);
> +	} else {
> +		switch (regsz) {
> +		case 1:
> +			*(u8 *)data = sdio_readb(sdiodev->func[1], addr, &ret);
> +			break;
> +		case 4:
> +			ret = brcmf_sdiod_addrprep(sdiodev, &addr);
> +			if (ret)
> +				goto done;
>
> -		sdiodev->sbwad = bar0;
> +			*(u32 *)data = sdio_readl(sdiodev->func[1], addr, &ret);
> +			break;
> +		default:
> +			BUG();

same here as with reg_write() function.

> +			ret = -EINVAL;
> +			break;
> +		}
>  	}
>
> -	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
> -	*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
> -
> -	return 0;
> +done:
> +	return ret;
>  }
>
>  u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
> @@ -439,15 +386,9 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
>  	int retval;
>
>  	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
> -	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
> -	if (retval)
> -		goto done;
> -
> -	retval = brcmf_sdiod_reg_read(sdiodev, addr, 4, &data);
> -
>  	brcmf_dbg(SDIO, "data:0x%08x\n", data);

Now this debug statement move before the actual read, which makes it 
useless. You are going to remove it in a subsequent patch, but still.

> +	retval = brcmf_sdiod_reg_read(sdiodev, addr, 4, &data);
>
> -done:
>  	if (ret)
>  		*ret = retval;
>
