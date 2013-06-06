Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4318 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752Ab3FFLqZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:46:25 -0400
Message-ID: <51B07683.2030408@broadcom.com> (sfid-20130606_134631_318972_46F45D60)
Date: Thu, 6 Jun 2013 13:46:11 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"Piotr Haber" <phaber@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] brcmfmac: move dereference under check for NULL
References: <20130606105556.GD12953@debian>
In-Reply-To: <20130606105556.GD12953@debian>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2013 12:55 PM, Dan Carpenter wrote:
> skb_pull() dereferences the skb parameter.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Hi Dan,

Just missed that. This code fragment was resubmitted just minutes ago. I 
will rework the patch to incorporate this change.

Regards,
Arend

> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
> index ea37bd4..c35296f 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
> @@ -861,9 +861,9 @@ static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
>   		      BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN + 2 +
>   		      4 + fws->drvr->hdrlen;
>   		skb = brcmu_pkt_buf_get_skb(len);
> -		skb_pull(skb, len);
>   		if (skb == NULL)
>   			return false;
> +		skb_pull(skb, len);
>   		skcb = brcmf_skbcb(skb);
>   		skcb->mac = entry;
>   		skcb->state = BRCMF_FWS_SKBSTATE_TIM;
>


