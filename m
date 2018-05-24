Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.46.233]:27354 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S971329AbeEXULb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 16:11:31 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 21216289C
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2018 14:47:33 -0500 (CDT)
Subject: Re: [PATCH] rtlwifi: remove duplicate code
To: Joe Perches <joe@perches.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180524185450.GA2875@embeddedor.com>
 <57f2881d031de041a6ce95cf8adc5ce80551ce19.camel@perches.com>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <cc0b9d9a-88c2-4b93-0fa8-ca0f62e9f135@embeddedor.com> (sfid-20180524_221141_295356_04790FDE)
Date: Thu, 24 May 2018 14:47:25 -0500
MIME-Version: 1.0
In-Reply-To: <57f2881d031de041a6ce95cf8adc5ce80551ce19.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

On 05/24/2018 02:24 PM, Joe Perches wrote:
> On Thu, 2018-05-24 at 13:54 -0500, Gustavo A. R. Silva wrote:
>> Remove and refactor some code in order to avoid having identical code
>> for different branches.
> 
> True and nice tool and patch submittal thanks.
> 
>> Notice that the logic has been there since 2014.
> 
> But perhaps the original logic is a defective copy/paste
> and it should be corrected instead.
> 
> Can anyone from realtek verify this?
> 

I actually used gitk to track down the last changes made to this code 
and, it doesn't look like a copy/paste issue:

commit: c6821613e653aae4f54c75689e229e3f063b7f69
commit: 27a31a60a4de4c1b45e371152bb6e701e1a8cc40

Thanks
--
Gustavo

>> Addresses-Coverity-ID: 1426199 ("Identical code for different branches")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 23 ++++------------------
>>   1 file changed, 4 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
>> index 279fe01..df3facc 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
>> @@ -2876,25 +2876,10 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
>>   		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 13);
>>   
>>   	/* sw mechanism */
>> -	if (BTC_WIFI_BW_HT40 == wifi_bw) {
>> -		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
>> -		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
>> -			btc8723b2ant_sw_mechanism(btcoexist, true, true,
>> -						  false, false);
>> -		} else {
>> -			btc8723b2ant_sw_mechanism(btcoexist, true, true,
>> -						  false, false);
>> -		}
>> -	} else {
>> -		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
>> -		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
>> -			btc8723b2ant_sw_mechanism(btcoexist, false, true,
>> -						  false, false);
>> -		} else {
>> -			btc8723b2ant_sw_mechanism(btcoexist, false, true,
>> -						  false, false);
>> -		}
>> -	}
>> +	if (wifi_bw == BTC_WIFI_BW_HT40)
>> +		btc8723b2ant_sw_mechanism(btcoexist, true, true, false, false);
>> +	else
>> +		btc8723b2ant_sw_mechanism(btcoexist, false, true, false, false);
>>   }
>>   
>>   /* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
