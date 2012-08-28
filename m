Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54210 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab2H1Ooh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 10:44:37 -0400
Message-ID: <503CD951.2090602@lwfinger.net> (sfid-20120828_164444_760259_6817BD4A)
Date: Tue, 28 Aug 2012 09:44:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192de: remove pointless conditional before
 kfree_skb()
References: <CAPgLHd86W5X=Tb_fXoz_Ood-w_s282QNePTXG9m_6ESdG-rG2A@mail.gmail.com>
In-Reply-To: <CAPgLHd86W5X=Tb_fXoz_Ood-w_s282QNePTXG9m_6ESdG-rG2A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/28/2012 08:11 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Remove pointless conditional before kfree_skb().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192de/fw.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)

Acked-by: Larry Finger <Larry.Finger.net>

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
> index 895ae6c..a3aede0 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
> @@ -570,8 +570,7 @@ static bool _rtl92d_cmd_send_packet(struct ieee80211_hw *hw,
>
>   	ring = &rtlpci->tx_ring[BEACON_QUEUE];
>   	pskb = __skb_dequeue(&ring->queue);
> -	if (pskb)
> -		kfree_skb(pskb);
> +	kfree_skb(pskb);
>   	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
>   	pdesc = &ring->desc[idx];
>   	/* discard output from call below */
>
>
>

