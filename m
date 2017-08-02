Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:37471 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753108AbdHBMWL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 08:22:11 -0400
Received: by mail-vk0-f65.google.com with SMTP id r199so2094531vke.4
        for <linux-wireless@vger.kernel.org>; Wed, 02 Aug 2017 05:22:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170802122005.GA4652@symbol-HP-ZBook-15>
References: <20170802122005.GA4652@symbol-HP-ZBook-15>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Wed, 2 Aug 2017 17:52:10 +0530
Message-ID: <CAFqt6zZmGV-fn157G6dfdQkxsbSSsEKKjnTcjX5H8_bRsocAzQ@mail.gmail.com> (sfid-20170802_142214_545255_BAE37AED)
Subject: Re: [PATCH v5] rtlwifi: Replace hardcode value with macro
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please ignore this patch.

On Wed, Aug 2, 2017 at 5:50 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
> and hw->max_rate_tries are replaced by macro and removed the comment.
>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/base.c | 5 ++---
>  drivers/net/wireless/realtek/rtlwifi/base.h | 2 ++
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
> index 8b833e2..ea18aa7 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -426,9 +426,8 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
>         hw->extra_tx_headroom = RTL_TX_HEADER_SIZE;
>
>         /* TODO: Correct this value for our hw */
> -       /* TODO: define these hard code value */
> -       hw->max_listen_interval = 10;
> -       hw->max_rate_tries = 4;
> +       hw->max_listen_interval = MAX_LISTEN_INTERVAL;
> +       hw->max_rate_tries = MAX_RATE_TRIES;
>         /* hw->max_rates = 1; */
>         hw->sta_data_size = sizeof(struct rtl_sta_info);
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
> index ab7d819..b56d1b7 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.h
> @@ -65,6 +65,8 @@ enum ap_peer {
>  #define FRAME_OFFSET_ADDRESS3          16
>  #define FRAME_OFFSET_SEQUENCE          22
>  #define FRAME_OFFSET_ADDRESS4          24
> +#define MAX_LISTEN_INTERVAL            10
> +#define MAX_RATE_TRIES                 4
>
>  #define SET_80211_HDR_FRAME_CONTROL(_hdr, _val)                \
>         WRITEEF2BYTE(_hdr, _val)
> --
> 1.9.1
>
