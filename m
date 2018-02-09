Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36026 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752028AbeBIBPs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 20:15:48 -0500
Subject: Re: [PATCH v2] rtlwifi: rtl8192cu: Remove variable self-assignment in
 rf.c
To: Matthias Kaehlcke <mka@chromium.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <groeck@chromium.org>,
        Justin TerAvest <teravest@chromium.org>,
        Craig Bergstrom <craigb@chromium.org>
References: <20180209005712.29353-1-mka@chromium.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <c6b8e448-a848-07bc-2dc3-c1ac5aca0abc@lwfinger.net> (sfid-20180209_021607_855570_2E1DE93A)
Date: Thu, 8 Feb 2018 19:15:46 -0600
MIME-Version: 1.0
In-Reply-To: <20180209005712.29353-1-mka@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2018 06:57 PM, Matthias Kaehlcke wrote:
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
> Delete the branch with the self-assignment.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> Changes in v2:
> - Delete the 'else if' branch entirely
> 
>   drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c | 3 ---
>   1 file changed, 3 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>


> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
> index 9cff6bc4049c..cf551785eb08 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
> @@ -299,9 +299,6 @@ static void _rtl92c_get_txpower_writeval_by_regulatory(struct ieee80211_hw *hw,
>   			writeVal = 0x00000000;
>   		if (rtlpriv->dm.dynamic_txhighpower_lvl == TXHIGHPWRLEVEL_BT1)
>   			writeVal = writeVal - 0x06060606;
> -		else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
> -			 TXHIGHPWRLEVEL_BT2)
> -			writeVal = writeVal;
>   		*(p_outwriteval + rf) = writeVal;
>   	}
>   }
> 
