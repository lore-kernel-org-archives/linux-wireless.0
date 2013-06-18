Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52024 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab3FRPio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:38:44 -0400
Message-ID: <51C07EF4.8080603@candelatech.com> (sfid-20130618_173847_267157_8AB5E8EB)
Date: Tue, 18 Jun 2013 08:38:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211:  Fix bss ref leak.
References: <1371504746-8476-1-git-send-email-greearb@candelatech.com>  <1371504746-8476-2-git-send-email-greearb@candelatech.com>  (sfid-20130617_233256_432869_08F1495E) <1371569205.8318.47.camel@jlt4.sipsolutions.net>
In-Reply-To: <1371569205.8318.47.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2013 08:26 AM, Johannes Berg wrote:
> On Mon, 2013-06-17 at 14:32 -0700, greearb@candelatech.com wrote:
>
>>   static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
>> -					 bool assoc)
>> +					 bool assoc, bool put_bss)
>
> Do we _really_ need another argument? Shouldn't it always be put in the
> non-assoc case anyway, at least if non-NULL?

I can check if that is the case...

>
>> @@ -2415,6 +2415,10 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
>>   		ieee80211_vif_release_channel(sdata);
>>   	}
>>
>> +	if (put_bss)
>> +		cfg80211_put_bss(sdata->local->hw.wiphy, assoc_data->bss);
>> +
>> +
>
> just one blank line
>
>> +	/** bss will be passed back to calling code, and that code must
>> +	 * deal with properly putting the reference.
>> +	 */
>
> /** is for kernel-doc only
>
>>   	return RX_MGMT_CFG80211_RX_ASSOC;
>
> You're working on some pretty old code here ... If you want this to be
> in stable the patch really needs to be smaller, I think. And for
> mac80211-next this can't apply.

I'm working on 3.9.6.  When I get the problems fixed here, I can help
port this to whatever is the upstream kernel.

I'm not certain this is worth bothering with for stable anyway.
It seems the leaks are not too bad in general use cases,
and piddling around with code this tricky code could
introduce worse bugs that we may not immediately notice.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

