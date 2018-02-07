Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35582 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754303AbeBGUgB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 15:36:01 -0500
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Remove variable self-assignment in
 rf.c
To: Matthias Kaehlcke <mka@chromium.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <groeck@chromium.org>,
        Justin TerAvest <teravest@chromium.org>,
        Craig Bergstrom <craigb@chromium.org>
References: <20180207202634.98937-1-mka@chromium.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <947198f5-23eb-afbc-7979-fbc38b6a1a37@lwfinger.net> (sfid-20180207_213616_968607_5A2685F8)
Date: Wed, 7 Feb 2018 14:35:59 -0600
MIME-Version: 1.0
In-Reply-To: <20180207202634.98937-1-mka@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2018 02:26 PM, Matthias Kaehlcke wrote:
> In _rtl92c_get_txpower_writeval_by_regulatory() the variable writeVal
> is assigned to itself in an if ... else statement, apparently only to
> document that the branch condition is handled and that a previously read
> value should be returned unmodified. The self-assignment causes clang to
> raise the following warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c:304:13:
>    error: explicitly assigning value of variable of type 'u32'
>      (aka 'unsigned int') to itself [-Werror,-Wself-assign]
>    writeVal = writeVal;
> 
> Replace the self-assignment with a semicolon, which still serves to
> document the 'handling' of the branch condition.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
> index 9cff6bc4049c..4db92496c122 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
> @@ -301,7 +301,7 @@ static void _rtl92c_get_txpower_writeval_by_regulatory(struct ieee80211_hw *hw,
>   			writeVal = writeVal - 0x06060606;
>   		else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
>   			 TXHIGHPWRLEVEL_BT2)
> -			writeVal = writeVal;
> +			;
>   		*(p_outwriteval + rf) = writeVal;
>   	}
>   }
> 

As the branch condition does nothing, why not remove it and save the compiler's 
optimizer a bit of work? The code looks strange, but it matches the rest of 
Realtek's USB drivers.

Larry
