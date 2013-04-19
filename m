Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1596 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967931Ab3DSILp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 04:11:45 -0400
Message-ID: <5170FBFC.8070403@broadcom.com> (sfid-20130419_101153_509530_52D06C45)
Date: Fri, 19 Apr 2013 10:10:36 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Wei Yongjun" <weiyj.lk@gmail.com>
cc: brudley@broadcom.com, frankyl@broadcom.com, meuleman@broadcom.com,
	linville@tuxdriver.com, pieterpg@broadcom.com, phaber@broadcom.com,
	yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH -next] brcmfmac: fix error return code in
 brcmf_fws_init()
References: <CAPgLHd8GkC50rYFD0zDRuE3o0JUHBCnSGXQi2jNL9DdK+8pNDA@mail.gmail.com>
In-Reply-To: <CAPgLHd8GkC50rYFD0zDRuE3o0JUHBCnSGXQi2jNL9DdK+8pNDA@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/19/2013 04:10 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>

Thanks for the patch. However, I would like to solve it differently. I 
will sent out a patch for handling this.

Regards,
Arend

> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
> index 1bcd58c..df2ac2f 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
> @@ -1875,8 +1875,9 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
>   		goto fail;
>   	}
>
> -	if (brcmf_fweh_register(drvr, BRCMF_E_FIFO_CREDIT_MAP,
> -				brcmf_fws_notify_credit_map)) {
> +	rc = brcmf_fweh_register(drvr, BRCMF_E_FIFO_CREDIT_MAP,
> +				 brcmf_fws_notify_credit_map);
> +	if (rc) {
>   		brcmf_err("register credit map handler failed\n");
>   		goto fail;
>   	}
>
>


