Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:37511 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732639AbeHGQiG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Aug 2018 12:38:06 -0400
Subject: Re: [PATCH] rtlwifi: btcoex: Fix if == else warnings in
 halbtc8723b2ant.c
To: valdis.kletnieks@vt.edu, YueHaibing <yuehaibing@huawei.com>
Cc: pkshih@realtek.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, colin.king@canonical.com,
        linux-wireless@vger.kernel.org
References: <20180806045440.11920-1-yuehaibing@huawei.com>
 <63216.1533591775@turing-police.cc.vt.edu>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <577a831f-45c3-a687-ca04-edc977ddb925@lwfinger.net> (sfid-20180807_162352_247963_44D9A981)
Date: Tue, 7 Aug 2018 09:23:30 -0500
MIME-Version: 1.0
In-Reply-To: <63216.1533591775@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/06/2018 04:42 PM, valdis.kletnieks@vt.edu wrote:
> On Mon, 06 Aug 2018 12:54:40 +0800, YueHaibing said:
>> Fix following coccinelle warning:
>>
>> ./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2952:2-4: WARNING: possible condition with no effect (if == else)
> 
>>   	/* sw mechanism */
>>   	if (BTC_WIFI_BW_HT40 == wifi_bw) {
>> -		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
>> -		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
>> -			btc8723b2ant_sw_mechanism(btcoexist, true, true,
>> -						  false, false);
>> -		} else {
>> -			btc8723b2ant_sw_mechanism(btcoexist, true, true,
>> -						  false, false);
>> -		}
>> +		btc8723b2ant_sw_mechanism(btcoexist, true, true,
>> +					  false, false);
>>   	} else {
> 
> Rather than blindly fixing this, perhaps a bit of thought needs to be
> applied to why this code looks like this in the first place.
> 
> See commit c6821613e653a  (which looks like the bletcherous "do too many
> things at once" commit indeed), although the actual diff appears to be a
> "no harm, no foul" against this commit, where the issue already existed.
> 
> commit aa45a673b291fd761275493bc15316d79555ed55
> Author: Larry Finger <Larry.Finger@lwfinger.net>
> Date:   Fri Feb 28 15:16:43 2014 -0600
> 
>      rtlwifi: btcoexist: Add new mini driver
> 
> Larry? Can you reach back to 2014 and remember why this code
> looked like this in the first place?

The base code came from Realtek. My only part in getting it into the kernel was 
to clean up the checkpatch and Sparse errors and warnings, and submit it. I was 
a "script kiddy" just like the authors of the current patches. The only 
difference is that I was getting drivers into the kernel so that users hardware 
would work.

Any record of whether these duplicate branches are the result of incorrect copy 
and paste, or just extraneous code, would be at Realtek in their version control 
history. I have never had access to such archives, nor have I ever had an 
non-disclosure agreement with Realtek.

Ping-Ke Shih, who is Cc'd on these messages, might be able to answer these 
questions.

For the moment, these simplifications could be applied as long as they are 
correctly done. After all, they are not changing what is already there and that 
stops any other person that knows how to run coccinelle from submitting the same 
patch in the future. Why "kick the can down the road"? If PK can find that there 
was an error in the original code, he can submit a "Fixes" patch.

Larry
