Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.140]:34901 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967385AbeEYSPp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 14:15:45 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 1E7E4401220C0
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 12:50:20 -0500 (CDT)
Subject: Re: [PATCH] ath6kl: mark expected switch fall-throughs
To: Kalle Valo <kvalo@codeaurora.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180524231322.GA22704@embeddedor.com>
 <060f93a0-7210-79b6-37a7-cd8900719d40@cogentembedded.com>
 <871sdzc16l.fsf@kamboji.qca.qualcomm.com>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <e777af5c-8d56-aef7-a4b6-f93f12378049@embeddedor.com> (sfid-20180525_201808_115411_C70B4ABA)
Date: Fri, 25 May 2018 12:50:10 -0500
MIME-Version: 1.0
In-Reply-To: <871sdzc16l.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/25/2018 08:30 AM, Kalle Valo wrote:
> Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> writes:
> 
>> On 5/25/2018 2:13 AM, Gustavo A. R. Silva wrote:
>>
>>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>>> where we are expecting to fall through.
>>>
>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>> ---
>>>    drivers/net/wireless/ath/ath6kl/cfg80211.c | 6 +++---
>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
>>> index 2ba8cf3..29e32cd 100644
>>> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
>>> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
>>> @@ -3898,17 +3898,17 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
>>>    	wiphy->max_scan_ie_len = 1000; /* FIX: what is correct limit? */
>>>    	switch (ar->hw.cap) {
>>>    	case WMI_11AN_CAP:
>>> -		ht = true;
>>> +		ht = true; /* fall through */
>>>    	case WMI_11A_CAP:
>>>    		band_5gig = true;
>>>    		break;
>>>    	case WMI_11GN_CAP:
>>> -		ht = true;
>>> +		ht = true; /* fall through */
>>>    	case WMI_11G_CAP:
>>>    		band_2gig = true;
>>>    		break;
>>>    	case WMI_11AGN_CAP:
>>> -		ht = true;
>>> +		ht = true; /* fall through */
>>>    	case WMI_11AG_CAP:
>>>    		band_2gig = true;
>>>    		band_5gig = true;
>>
>>     Hm, typically such comments are done on a line of their own, have
>> never seen this style...
> 
> Yeah, I was wondering the same. Was there a particular reason for this?
> 

Sometimes people use this style for a one-line code block.

I can change it to the traditional style. No problem.

Thanks
--
Gustavo
