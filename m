Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.144.28]:43278 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752200AbdIGO45 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 10:56:57 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id C09FDE1CF2
        for <linux-wireless@vger.kernel.org>; Thu,  7 Sep 2017 09:35:55 -0500 (CDT)
Subject: Re: [PATCH] rtlwifi: btcoex: 23b 1ant: fix duplicated code for
 different branches
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170830134223.GA13596@embeddedgus>
 <ae09e952-112e-9616-735a-b86ba01ad398@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <02176aa2-9af5-c933-74e1-b2333c07c36b@embeddedor.com> (sfid-20170907_165700_496294_BA527818)
Date: Thu, 7 Sep 2017 09:35:49 -0500
MIME-Version: 1.0
In-Reply-To: <ae09e952-112e-9616-735a-b86ba01ad398@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On 08/30/2017 11:48 PM, Larry Finger wrote:
> On 08/30/2017 08:42 AM, Gustavo A. R. Silva wrote:
>> Refactor code in order to avoid identical code for different branches.
>>
>> This issue was detected with the help of Coccinelle.
>>
>> Addresses-Coverity-ID: 1226788
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>> This issue was reported by Coverity and it was tested by compilation
>> only.
>> I'm suspicious this may be a copy/paste error. Please, verify.
>>
>>   .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c   | 10
>> ++--------
>>   1 file changed, 2 insertions(+), 8 deletions(-)
>
> This change is not correct. When bt_link_info->sco_exist is true, the
> call should be
>
>                 halbtc8723b1ant_limited_rx(btcoexist,
>                                NORMAL_EXEC, true,
>                                false, 0x5);
>
> NACK
>
> I will push the correct patch.
>

Great. Good to know.

Thanks
-- 
Gustavo A. R. Silva
