Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35142 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdFVNfw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 09:35:52 -0400
Received: by mail-oi0-f66.google.com with SMTP id f189so1477637oig.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jun 2017 06:35:51 -0700 (PDT)
Subject: Re: [PATCH v2] rtlwifi: Replace hardcode value with macro
To: Souptick Joarder <jrdr.linux@gmail.com>, chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
References: <20170622120004.GA5783@symbol-HP-ZBook-15>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <80d08513-9da0-2840-dd15-0a3deace3dc7@lwfinger.net> (sfid-20170622_153555_389297_51090BB1)
Date: Thu, 22 Jun 2017 08:35:49 -0500
MIME-Version: 1.0
In-Reply-To: <20170622120004.GA5783@symbol-HP-ZBook-15>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/22/2017 07:00 AM, Souptick Joarder wrote:
> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
> and hw->max_rate_tries are replaced by macro.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> ---
> Changes in v2:
>     - Signed-off was missing in previous one.

This patch includes a comment that is not needed, but it is OK.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> 
>   drivers/net/wireless/realtek/rtlwifi/base.c | 6 +++---
>   drivers/net/wireless/realtek/rtlwifi/base.h | 2 ++
>   2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
> index bdc3791..f45d093 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -422,9 +422,9 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
>   	hw->extra_tx_headroom = RTL_TX_HEADER_SIZE;
> 
>   	/* TODO: Correct this value for our hw */
> -	/* TODO: define these hard code value */
> -	hw->max_listen_interval = 10;
> -	hw->max_rate_tries = 4;
> +	/* defined these hard code values */
> +	hw->max_listen_interval = MAX_LISTEN_INTERVAL;
> +	hw->max_rate_tries = MAX_RATE_TRIES;
>   	/* hw->max_rates = 1; */
>   	hw->sta_data_size = sizeof(struct rtl_sta_info);
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
> index 02ff0c5..d03e198 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.h
> @@ -65,6 +65,8 @@ enum ap_peer {
>   #define FRAME_OFFSET_ADDRESS3		16
>   #define FRAME_OFFSET_SEQUENCE		22
>   #define FRAME_OFFSET_ADDRESS4		24
> +#define MAX_LISTEN_INTERVAL             10
> +#define MAX_RATE_TRIES                  4
> 
>   #define SET_80211_HDR_FRAME_CONTROL(_hdr, _val)		\
>   	WRITEEF2BYTE(_hdr, _val)
> --
> 1.9.1
> 
> 
