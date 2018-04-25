Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0040.outbound.protection.outlook.com ([104.47.42.40]:27232
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750882AbeDYHuJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 03:50:09 -0400
Date: Wed, 25 Apr 2018 10:49:54 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] qtnfmac: fix qtnf_netdev_hard_start_xmit()'s return type
Message-ID: <20180425074953.hnfwnfsjuwtbjp3o@bars> (sfid-20180425_095030_797029_711638F7)
References: <20180424131810.4963-1-luc.vanoostenryck@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180424131810.4963-1-luc.vanoostenryck@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luc and all,

> The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
> which is a typedef for an enum type, but the implementation in this
> driver returns an 'int'.
> 
> Fix this by returning 'netdev_tx_t' in this driver too.
> 
> Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> ---
>  drivers/net/wireless/quantenna/qtnfmac/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
> index cf26c15a8..b3bfb4faa 100644
> --- a/drivers/net/wireless/quantenna/qtnfmac/core.c
> +++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
> @@ -76,7 +76,7 @@ static int qtnf_netdev_close(struct net_device *ndev)
> 
>  /* Netdev handler for data transmission.
>   */
> -static int
> +static netdev_tx_t
>  qtnf_netdev_hard_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  {
>         struct qtnf_vif *vif;

Previous ACK from Igor slipped through the cracks due to
outlook/exchange issues. So here is another one.

Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Thanks for the fix !

Regards,
Sergey
