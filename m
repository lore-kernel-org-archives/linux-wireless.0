Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:38115 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1046499AbdDXLMs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 07:12:48 -0400
Received: by mail-it0-f48.google.com with SMTP id e132so51794925ite.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 04:12:47 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Ensure pointer correctly set if skb data
 location changes
To: James Hughes <james.hughes@raspberrypi.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
References: <20170424105219.18797-1-james.hughes@raspberrypi.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <bb374f51-f0c7-d315-6a82-11400e71625a@broadcom.com> (sfid-20170424_131537_822758_B074E442)
Date: Mon, 24 Apr 2017 13:10:50 +0200
MIME-Version: 1.0
In-Reply-To: <20170424105219.18797-1-james.hughes@raspberrypi.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/24/2017 12:52 PM, James Hughes wrote:
> The incoming skb header may be resized if header space is
> insufficient, which might change the data adddress in the skb.
> Ensure that a cached pointer to that data is correctly set by
> moving assignment to after any possible changes.

Thanks, James

Minor nit below...

You may add my acknowledgement:

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c

[...]

> @@ -229,6 +229,8 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
>   		}
>   	}
>   
> +	eh = (struct ethhdr *)(skb->data);
> +

Please move after the length validation below.

Regards,
Arend

>   	/* validate length for ether packet */
>   	if (skb->len < sizeof(*eh)) {
>   		ret = -EINVAL;
> 
