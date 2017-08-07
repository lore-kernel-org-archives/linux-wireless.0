Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:35819 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753066AbdHGL0h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:26:37 -0400
Received: by mail-wr0-f173.google.com with SMTP id k71so645755wrc.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:26:37 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 11/34] brcmfmac: Split brcmf_sdiod_buffrw function up.
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-12-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
Message-ID: <59884E6B.5050801@broadcom.com> (sfid-20170807_132640_300563_788ED980)
Date: Mon, 7 Aug 2017 13:26:35 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-12-ian@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/26/2017 10:25 PM, Ian Molton wrote:
> This function needs to be split up into separate read / write variants
> for clarity.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>

more comments below...

> # Conflicts:
> #	drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 69 +++++++++++++++-------
>   1 file changed, 47 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 9d5716d0ad73..858ad2d8706b 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c

[...]

> @@ -706,10 +725,10 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
>   	err = brcmf_sdiod_addrprep(sdiodev, &addr);
>
>   	if (!err)
> -		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, true, addr,
> -					 mypkt);
> +		err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2, addr, mypkt);
>
>   	brcmu_pkt_buf_free_skb(mypkt);
> +

You are keen on sprinkling whitespace here and there. Could you please 
use separate patches for that as much as possible. Not sure why you 
added this one...

>   	return err;
>

...and kept this one.

>   }
