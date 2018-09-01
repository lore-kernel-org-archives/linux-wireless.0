Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua1-f67.google.com ([209.85.222.67]:41114 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbeIAHwd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Sep 2018 03:52:33 -0400
MIME-Version: 1.0
References: <20180831111325.16984-1-yuehaibing@huawei.com>
In-Reply-To: <20180831111325.16984-1-yuehaibing@huawei.com>
From: Siva Rebbagondla <siva8118@gmail.com>
Date: Sat, 1 Sep 2018 09:11:53 +0530
Message-ID: <CANGSkXTDOa-TCz2wbNh7=C9px4_T7besT6jBPzfs70kVoK+PtA@mail.gmail.com> (sfid-20180901_055237_213642_404227AC)
Subject: Re: [PATCH v2] rsi: remove set but not used variable 'header_size'
To: yuehaibing@huawei.com
Cc: Kalle Valo <kvalo@codeaurora.org>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Amit karwar <amit.karwar@redpinesignals.com>,
        pavani.muthyala@redpinesignals.com, keescook@chromium.org,
        Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 31, 2018 at 4:45 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/wireless/rsi/rsi_91x_hal.c: In function 'rsi_send_data_pkt':
> drivers/net/wireless/rsi/rsi_91x_hal.c:288:5: warning:
>  variable 'header_size' set but not used [-Wunused-but-set-variable]
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: remove unused 'tx_params'
> ---
>  drivers/net/wireless/rsi/rsi_91x_hal.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
> index 01edf96..182b066 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_hal.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
> @@ -282,10 +282,8 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
>         struct rsi_hw *adapter = common->priv;
>         struct ieee80211_vif *vif;
>         struct ieee80211_tx_info *info;
> -       struct skb_info *tx_params;
>         struct ieee80211_bss_conf *bss;
>         int status = -EINVAL;
> -       u8 header_size;
>
>         if (!skb)
>                 return 0;
> @@ -297,8 +295,6 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
>                 goto err;
>         vif = info->control.vif;
>         bss = &vif->bss_conf;
> -       tx_params = (struct skb_info *)info->driver_data;
> -       header_size = tx_params->internal_hdr_size;
Yes, These redundant variables shall be removed.
>
>         if (((vif->type == NL80211_IFTYPE_STATION) ||
>              (vif->type == NL80211_IFTYPE_P2P_CLIENT)) &&
> --
> 2.7.0
>
>
Also, Patch title also can be changed to "[v2] rsi: remove unused variables"

Thanks,
Siva Rebbagondla
