Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38153 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S946817AbdDTTWM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 15:22:12 -0400
Received: by mail-wm0-f46.google.com with SMTP id r190so809976wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Apr 2017 12:22:11 -0700 (PDT)
Subject: Re: [PATCH] brcm80211: brcmfmac: Ensure header writes are on writable
 skb
To: James Hughes <james.hughes@raspberrypi.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
References: <20170420154704.32144-1-james.hughes@raspberrypi.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f2c96267-8fec-f878-760d-90e93323d807@broadcom.com> (sfid-20170420_212216_111414_EFA0C07D)
Date: Thu, 20 Apr 2017 21:22:04 +0200
MIME-Version: 1.0
In-Reply-To: <20170420154704.32144-1-james.hughes@raspberrypi.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/20/2017 5:47 PM, James Hughes wrote:
> Driver was writing to skb header area without ensuring it was
> writable i.e. uncloned.
> 
> Used skb_cow_header to ensure that header buffer is large enough
> and is uncloned.
> 
> Detected when, in combination with the smsc85xx driver, both drivers
> attempted to write different headers to the same header buffer.

I guess this patch is limited to one file to address the comment from 
Eric Dumazet. I prefer to talk through the initial patch you sent. Just 
a procedural remark or two here. 1) Please drop 'brcm80211:' from the 
Subject as the 'brcmfmac' prefix is sufficient, and 2) despite the 
change of the Subject you should consider this version 2 of the initial 
patch so the Subject should read '[PATCH V2] brcmfmac: ....'.

> Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
> ---
Related to remark 2) above you should provide a changelog here listing 
what is changed compared to the initial patch.

Regards,
Arend
---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> index 038a960..b9d7d08 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> @@ -249,14 +249,19 @@ brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
>   	return ret;
>   }
>   
> -static void
> +static int
>   brcmf_proto_bcdc_hdrpush(struct brcmf_pub *drvr, int ifidx, u8 offset,
>   			 struct sk_buff *pktbuf)
>   {
>   	struct brcmf_proto_bcdc_header *h;
> +	int err;
>   
>   	brcmf_dbg(BCDC, "Enter\n");
>   
> +	err = skb_cow_head(pktbuf, BCDC_HEADER_LEN);
> +	if (err)
> +		return err;
> +
>   	/* Push BDC header used to convey priority for buses that don't */
>   	skb_push(pktbuf, BCDC_HEADER_LEN);
>   
> @@ -271,6 +276,8 @@ brcmf_proto_bcdc_hdrpush(struct brcmf_pub *drvr, int ifidx, u8 offset,
>   	h->data_offset = offset;
>   	BCDC_SET_IF_IDX(h, ifidx);
>   	trace_brcmf_bcdchdr(pktbuf->data);
> +
> +	return 0;
>   }
>   
>   static int
> @@ -330,7 +337,11 @@ static int
>   brcmf_proto_bcdc_txdata(struct brcmf_pub *drvr, int ifidx, u8 offset,
>   			struct sk_buff *pktbuf)
>   {
> -	brcmf_proto_bcdc_hdrpush(drvr, ifidx, offset, pktbuf);
> +	int err = brcmf_proto_bcdc_hdrpush(drvr, ifidx, offset, pktbuf);
> +
> +	if (err)
> +		return err;
> +
>   	return brcmf_bus_txdata(drvr->bus_if, pktbuf);
>   }
>   
> 
