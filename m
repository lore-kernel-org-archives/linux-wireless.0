Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52526 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933214AbeEYNat (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 09:30:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath6kl: mark expected switch fall-throughs
References: <20180524231322.GA22704@embeddedor.com>
        <060f93a0-7210-79b6-37a7-cd8900719d40@cogentembedded.com>
Date: Fri, 25 May 2018 16:30:42 +0300
In-Reply-To: <060f93a0-7210-79b6-37a7-cd8900719d40@cogentembedded.com> (Sergei
        Shtylyov's message of "Fri, 25 May 2018 14:27:40 +0300")
Message-ID: <871sdzc16l.fsf@kamboji.qca.qualcomm.com> (sfid-20180525_153118_615634_6BC5CFA8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> writes:

> On 5/25/2018 2:13 AM, Gustavo A. R. Silva wrote:
>
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/net/wireless/ath/ath6kl/cfg80211.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
>> index 2ba8cf3..29e32cd 100644
>> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
>> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
>> @@ -3898,17 +3898,17 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
>>   	wiphy->max_scan_ie_len = 1000; /* FIX: what is correct limit? */
>>   	switch (ar->hw.cap) {
>>   	case WMI_11AN_CAP:
>> -		ht = true;
>> +		ht = true; /* fall through */
>>   	case WMI_11A_CAP:
>>   		band_5gig = true;
>>   		break;
>>   	case WMI_11GN_CAP:
>> -		ht = true;
>> +		ht = true; /* fall through */
>>   	case WMI_11G_CAP:
>>   		band_2gig = true;
>>   		break;
>>   	case WMI_11AGN_CAP:
>> -		ht = true;
>> +		ht = true; /* fall through */
>>   	case WMI_11AG_CAP:
>>   		band_2gig = true;
>>   		band_5gig = true;
>
>    Hm, typically such comments are done on a line of their own, have
> never seen this style...

Yeah, I was wondering the same. Was there a particular reason for this?

-- 
Kalle Valo
