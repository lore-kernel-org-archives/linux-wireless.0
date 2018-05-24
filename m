Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0076.hostedemail.com ([216.40.44.76]:49910 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S967322AbeEXTYa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 15:24:30 -0400
Message-ID: <57f2881d031de041a6ce95cf8adc5ce80551ce19.camel@perches.com> (sfid-20180524_212647_555194_627E27E0)
Subject: Re: [PATCH] rtlwifi: remove duplicate code
From: Joe Perches <joe@perches.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 24 May 2018 12:24:26 -0700
In-Reply-To: <20180524185450.GA2875@embeddedor.com>
References: <20180524185450.GA2875@embeddedor.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-05-24 at 13:54 -0500, Gustavo A. R. Silva wrote:
> Remove and refactor some code in order to avoid having identical code
> for different branches.

True and nice tool and patch submittal thanks.

> Notice that the logic has been there since 2014.

But perhaps the original logic is a defective copy/paste
and it should be corrected instead.

Can anyone from realtek verify this?

> Addresses-Coverity-ID: 1426199 ("Identical code for different branches")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 23 ++++------------------
>  1 file changed, 4 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
> index 279fe01..df3facc 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
> @@ -2876,25 +2876,10 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
>  		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 13);
>  
>  	/* sw mechanism */
> -	if (BTC_WIFI_BW_HT40 == wifi_bw) {
> -		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
> -		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
> -			btc8723b2ant_sw_mechanism(btcoexist, true, true,
> -						  false, false);
> -		} else {
> -			btc8723b2ant_sw_mechanism(btcoexist, true, true,
> -						  false, false);
> -		}
> -	} else {
> -		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
> -		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
> -			btc8723b2ant_sw_mechanism(btcoexist, false, true,
> -						  false, false);
> -		} else {
> -			btc8723b2ant_sw_mechanism(btcoexist, false, true,
> -						  false, false);
> -		}
> -	}
> +	if (wifi_bw == BTC_WIFI_BW_HT40)
> +		btc8723b2ant_sw_mechanism(btcoexist, true, true, false, false);
> +	else
> +		btc8723b2ant_sw_mechanism(btcoexist, false, true, false, false);
>  }
>  
>  /* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
