Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:33167 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754935AbdBGTX6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 14:23:58 -0500
Received: by mail-qk0-f173.google.com with SMTP id s140so99073121qke.0
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2017 11:23:52 -0800 (PST)
Subject: Re: [PATCH net] brcmfmac: clear skb head state on xmit
To: Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@codeaurora.org>
References: <e5bb3c8e8be4417cc648cfb53add2c89d2c89aa9.1486486128.git.pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Franky Lin <franky.lin@broadcom.com>,
        hante Meuleman <hante.meuleman@broadcom.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f755ffe7-ea05-7481-af51-da2489bc8a43@broadcom.com> (sfid-20170207_202407_272775_E6909E42)
Date: Tue, 7 Feb 2017 20:23:47 +0100
MIME-Version: 1.0
In-Reply-To: <e5bb3c8e8be4417cc648cfb53add2c89d2c89aa9.1486486128.git.pabeni@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7-2-2017 17:50, Paolo Abeni wrote:
> the skbs can be held by the driver for a long time, so we need
> to clear any state on xmit to avoid hanging other subsystems.
> The skbs are already orphaned later in cmsg code, so we just
> need to clear the nf/dst/secpath.
> Do it early, while the relevant entries are hopefully still
> hot in the cache.

What is this about really? A bit more background about the issue might
help understanding the need for this patch. Is this really specific to
brcmfmac. For instance is something similar already done in mac80211?

Regards,
Arend

> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index 9e6f60a..5a8d57b 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -22,6 +22,7 @@
>  #include <net/rtnetlink.h>
>  #include <net/addrconf.h>
>  #include <net/ipv6.h>
> +#include <net/xfrm.h>
>  #include <brcmu_utils.h>
>  #include <brcmu_wifi.h>
>  
> @@ -243,6 +244,13 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
>  	if ((skb->priority == 0) || (skb->priority > 7))
>  		skb->priority = cfg80211_classify8021d(skb, NULL);
>  
> +	/* we can keep the skb for a long time; avoid starving other
> +	 * subsystems
> +	 */
> +	nf_reset(skb);
> +	skb_dst_drop(skb);
> +	secpath_reset(skb);
> +
>  	ret = brcmf_proto_tx_queue_data(drvr, ifp->ifidx, skb);
>  	if (ret < 0)
>  		brcmf_txfinalize(ifp, skb, false);
> 
