Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:45059 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab3IPTFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 15:05:41 -0400
Received: by mail-la0-f52.google.com with SMTP id ev20so3396248lab.25
        for <linux-wireless@vger.kernel.org>; Mon, 16 Sep 2013 12:05:40 -0700 (PDT)
Message-ID: <52375683.8060103@cogentembedded.com> (sfid-20130916_210545_092893_73DAE978)
Date: Mon, 16 Sep 2013 23:05:39 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 3/8 V2] rtlwifi: rtl8192cu: Fix smatch warning in rtl8192cu/trx.c
References: <1379357722-17687-1-git-send-email-Larry.Finger@lwfinger.net> <1379357722-17687-4-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1379357722-17687-4-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/16/2013 10:55 PM, Larry Finger wrote:

> Smatch lists the following:
>    CHECK   drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> drivers/net/wireless/rtlwifi/rtl8192cu/trx.c:367 _rtl_rx_process() warn: assigning (-98) to unsigned variable 'stats.noise'

> This variable is unused, thus it is removed.

    It's a structure field initializer you're removing, not a variable. And 
also a comment.

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/trx.c | 2 --
>   1 file changed, 2 deletions(-)

> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> index 763cf1d..04c7e57 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> @@ -349,7 +349,6 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
>   	}
>   	/*rx_status->qual = stats->signal; */
>   	rx_status->signal = stats->rssi + 10;
> -	/*rx_status->noise = -stats->noise; */
>   	return true;
>   }
>
> @@ -364,7 +363,6 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
>   	u8 *rxdesc;
>   	struct rtl_stats stats = {
>   		.signal = 0,
> -		.noise = -98,
>   		.rate = 0,
>   	};

WBR, Sergei


