Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:39332 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751299AbeAVTAR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 14:00:17 -0500
Received: by mail-ot0-f195.google.com with SMTP id d9so8425961oth.6
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jan 2018 11:00:16 -0800 (PST)
Subject: Re: [PATCH 04/10] rtlwifi: btcoex: add scan_notify within ips_notify
 if RFON
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180119064551.10084-1-pkshih@realtek.com>
 <20180119064551.10084-5-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <6da46040-906f-2c7c-aec8-cf9269774841@lwfinger.net> (sfid-20180122_200022_500829_4039BE45)
Date: Mon, 22 Jan 2018 13:00:15 -0600
MIME-Version: 1.0
In-Reply-To: <20180119064551.10084-5-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/19/2018 12:45 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Three steps of connection procedure are scan, enter/leave IPS, auth.
> There is no scan between leaving IPS and sending auth, but btcoex use scan
> as an important clue that indicates user is going to connect. So add scan
> notifications in ips_notify to correct btcoex's state.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
> index bbc9517260b3..0111ab9e7b05 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
> @@ -212,6 +212,14 @@ void rtl_btc_ips_notify(struct rtl_priv *rtlpriv, u8 type)
>   		return;
>   
>   	exhalbtc_ips_notify(btcoexist, type);
> +
> +	if (type == ERFON) {
> +		/* In some situation, it doesn't scan after leaving IPS, and
> +		 * this will cause btcoex in wrong state.
> +		 */
> +		exhalbtc_scan_notify(btcoexist, 1);
> +		exhalbtc_scan_notify(btcoexist, 0);
> +	}
>   }
>   
>   void rtl_btc_lps_notify(struct rtl_priv *rtlpriv, u8 type)
> 
