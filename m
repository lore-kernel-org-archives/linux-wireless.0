Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11211 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbeHaPPD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 11:15:03 -0400
Subject: Re: [PATCH] rsi: remove set but not used variable 'header_size'
To: Kalle Valo <kvalo@codeaurora.org>,
        Pavani Muthyala <pavani.muthyala@redpinesignals.com>,
        Kees Cook <keescook@chromium.org>,
        Colin Ian King <colin.king@canonical.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
References: <1535707647-191888-1-git-send-email-yuehaibing@huawei.com>
CC: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
From: YueHaibing <yuehaibing@huawei.com>
Message-ID: <9c1571f1-b353-7621-c7e0-20d54cbd59c4@huawei.com> (sfid-20180831_130826_611689_D1004F91)
Date: Fri, 31 Aug 2018 19:07:55 +0800
MIME-Version: 1.0
In-Reply-To: <1535707647-191888-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2018/8/31 17:27, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/rsi/rsi_91x_hal.c: In function 'rsi_send_data_pkt':
> drivers/net/wireless/rsi/rsi_91x_hal.c:288:5: warning:
>  variable 'header_size' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/rsi/rsi_91x_hal.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
> index 01edf96..c4fb319 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_hal.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
> @@ -285,7 +285,6 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
>  	struct skb_info *tx_params;
>  	struct ieee80211_bss_conf *bss;
>  	int status = -EINVAL;
> -	u8 header_size;
>  
>  	if (!skb)
>  		return 0;
> @@ -298,7 +297,6 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
>  	vif = info->control.vif;
>  	bss = &vif->bss_conf;
>  	tx_params = (struct skb_info *)info->driver_data;

tx_params also can be removed.

Will send V2.

> -	header_size = tx_params->internal_hdr_size;
>  
>  	if (((vif->type == NL80211_IFTYPE_STATION) ||
>  	     (vif->type == NL80211_IFTYPE_P2P_CLIENT)) &&
> 
> 
> .
> 
