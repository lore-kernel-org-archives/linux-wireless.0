Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0046.outbound.protection.outlook.com ([104.47.34.46]:54080
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751851AbdH3BjQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 21:39:16 -0400
Subject: Re: [PATCH 03/27] qtnfmac: retreive current channel info from EP
To: linux-wireless@vger.kernel.org, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <20170825023024.10565-4-igor.mitsyanko.os@quantenna.com>
 <20170829144206.3zri6qpacy7cklkt@bars>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <4bd83ce3-e2af-178c-6fa6-822d5265200b@quantenna.com> (sfid-20170830_033920_434380_4853B0B4)
Date: Tue, 29 Aug 2017 18:39:08 -0700
MIME-Version: 1.0
In-Reply-To: <20170829144206.3zri6qpacy7cklkt@bars>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2017 07:42 AM, Sergey Matyukevich wrote:
> 
> Typo in commit title: retrieve

will fix

> 
> ...
> 
>> -	if (!cfg80211_chandef_valid(&mac->chandef)) {
>> -		pr_err("invalid channel settings on %s\n", ndev->name);
>> -		return -ENODATA;
>> +	if (!cfg80211_chandef_valid(chandef)) {
>> +		pr_err("%s: bad chan freq1=%u bw=%u\n", ndev->name,
>> +		       chandef->center_freq1, chandef->width);
>> +		ret = -ENODATA;
>>   	}
> 
> Lets keep both center_freq1 and center_freq2 in error message.

Ok


> 
> Regards,
> Sergey
> 
