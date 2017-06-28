Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38196 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751523AbdF1QRo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 12:17:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rtlwifi: Replace hardcode value with macro
References: <20170622120004.GA5783@symbol-HP-ZBook-15>
Date: Wed, 28 Jun 2017 19:17:39 +0300
In-Reply-To: <20170622120004.GA5783@symbol-HP-ZBook-15> (Souptick Joarder's
        message of "Thu, 22 Jun 2017 17:30:04 +0530")
Message-ID: <87zics2ijg.fsf@purkki.adurom.net> (sfid-20170628_181748_451419_EC5BDEFA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Souptick Joarder <jrdr.linux@gmail.com> writes:

> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
> and hw->max_rate_tries are replaced by macro.
>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> ---
> Changes in v2:
>    - Signed-off was missing in previous one.
>
>  drivers/net/wireless/realtek/rtlwifi/base.c | 6 +++---
>  drivers/net/wireless/realtek/rtlwifi/base.h | 2 ++
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
> index bdc3791..f45d093 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -422,9 +422,9 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
>  	hw->extra_tx_headroom = RTL_TX_HEADER_SIZE;
>
>  	/* TODO: Correct this value for our hw */
> -	/* TODO: define these hard code value */
> -	hw->max_listen_interval = 10;
> -	hw->max_rate_tries = 4;
> +	/* defined these hard code values */
> +	hw->max_listen_interval = MAX_LISTEN_INTERVAL;
> +	hw->max_rate_tries = MAX_RATE_TRIES;

Like Larry said, the comment does not make any sense. Please remove it
and send v3.

-- 
Kalle Valo
