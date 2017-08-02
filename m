Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:37110 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752255AbdHBOfk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 10:35:40 -0400
Received: by mail-oi0-f66.google.com with SMTP id j194so5799416oib.4
        for <linux-wireless@vger.kernel.org>; Wed, 02 Aug 2017 07:35:40 -0700 (PDT)
Subject: Re: [PATCH v5] rtlwifi: Replace hardcode value with macro
To: Souptick Joarder <jrdr.linux@gmail.com>,
        arend.vanspriel@broadcom.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20170802122915.GA4759@symbol-HP-ZBook-15>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <4d6b58d1-3e26-e6ea-0c0e-7e2b7aa3b75e@lwfinger.net> (sfid-20170802_163543_511784_C9F0391C)
Date: Wed, 2 Aug 2017 09:35:37 -0500
MIME-Version: 1.0
In-Reply-To: <20170802122915.GA4759@symbol-HP-ZBook-15>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2017 07:29 AM, Souptick Joarder wrote:
> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
> and hw->max_rate_tries are replaced by macro and removed the comment.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

Finally!

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

@Kalle: I'm sure you can work around this, but patchwork shows two different 
"v5" versions and a "v4" entry for this same patch. That may be due to no one 
formally rejecting the patch.

Larry

> ---
>   drivers/net/wireless/realtek/rtlwifi/base.c | 5 ++---
>   drivers/net/wireless/realtek/rtlwifi/base.h | 2 ++
>   2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
> index 8b833e2..ea18aa7 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -426,9 +426,8 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
>   	hw->extra_tx_headroom = RTL_TX_HEADER_SIZE;
>   
>   	/* TODO: Correct this value for our hw */
> -	/* TODO: define these hard code value */
> -	hw->max_listen_interval = 10;
> -	hw->max_rate_tries = 4;
> +	hw->max_listen_interval = MAX_LISTEN_INTERVAL;
> +	hw->max_rate_tries = MAX_RATE_TRIES;
>   	/* hw->max_rates = 1; */
>   	hw->sta_data_size = sizeof(struct rtl_sta_info);
>   
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
> index ab7d819..b56d1b7 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.h
> @@ -65,6 +65,8 @@ enum ap_peer {
>   #define FRAME_OFFSET_ADDRESS3		16
>   #define FRAME_OFFSET_SEQUENCE		22
>   #define FRAME_OFFSET_ADDRESS4		24
> +#define MAX_LISTEN_INTERVAL		10
> +#define MAX_RATE_TRIES			4
>   
>   #define SET_80211_HDR_FRAME_CONTROL(_hdr, _val)		\
>   	WRITEEF2BYTE(_hdr, _val)
> 
