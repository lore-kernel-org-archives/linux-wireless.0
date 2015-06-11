Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:11137 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbbFKMq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 08:46:27 -0400
Message-ID: <5579831F.3020304@neratec.com> (sfid-20150611_144630_930444_315CC734)
Date: Thu, 11 Jun 2015 14:46:23 +0200
From: Matthias May <matthias.may@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 1/4] cfg80211: handle minimum bandwidth for quarter
 and half rates
References: <1434020791-16291-1-git-send-email-matthias.may@neratec.com>	 <1434020791-16291-2-git-send-email-matthias.may@neratec.com>	 (sfid-20150611_130650_868019_E29B6AA4) <1434023059.1915.12.camel@sipsolutions.net>
In-Reply-To: <1434023059.1915.12.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/06/15 13:44, Johannes Berg wrote:
> On Thu, 2015-06-11 at 13:06 +0200, Matthias May wrote:
>
>>   const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
>> -					       u32 center_freq)
>> +					       u32 center_freq, u32 min_bw)
>>   {
>>   	const struct ieee80211_regdomain *regd;
>> +	const struct ieee80211_reg_rule *rr_tmp = NULL;
>> +	const struct ieee80211_reg_rule *reg_rule = NULL;
>> +	u32 bw;
>>   
>>   	regd = reg_get_regdomain(wiphy);
>>   
>> -	return freq_reg_info_regd(wiphy, center_freq, regd);
>> +	for(bw=min_bw; bw <= MHZ_TO_KHZ(20); bw=bw*2) {
>> +		rr_tmp = freq_reg_info_regd(wiphy, center_freq, bw, regd);
>> +		if(!reg_rule || !IS_ERR(rr_tmp))
>> +			reg_rule = rr_tmp;
>> +	}
>> +
>> +	return reg_rule;
> This makes no sense to me.
>
> You have the same code below, but why would you care? You can just look
> at the reg_rule's max_bandwidth, no?
>
> johannes
>
Using the dummy country code:
country XS: DFS-UNSET
     (5170 - 5180 @ 5), (N/A, 14), (N/A)
     (5175 - 5185 @ 10), (N/A, 17), (N/A)
     (5170 - 5190 @ 20), (N/A, 20), (N/A)

For a center freq of 5175
The first loop finds the first rule. --> we want this.
The second loop doesn't find anything.
The third loop doesn't find anything.

However for a center freq of 5180
The first loop find the first rule
The second loop find the second rule
The third loop find the third rule. --> We want this

If there are different overlapping rules for the different bandwidths 
different results can be returned, especially at the border of a 
frequency range.

A work colleague pointed out that it could be done more efficiently:

  	const struct ieee80211_regdomain *regd;
	const struct ieee80211_reg_rule *reg_rule = NULL;
	u32 bw;
  
  	regd = reg_get_regdomain(wiphy);
  
	for (bw = MHZ_TO_KHZ(20); bw >= min_bw; bw = bw / 2) {
		reg_rule = freq_reg_info_regd(wiphy, center_freq, bw, regd);
		if (!IS_ERR(reg_rule))
			return reg_rule;
	}

	return reg_rule;

However after some more discussion we noticed, that this again would 
allow to start 20MHz wide operation at the border
This is because when setting the flags we only look at the max_bandwidth 
of the returned rule.
I guess we would have to recheck if a certain width fits a center freq 
when setting this flags.

Will have to think a bit more how to solve this without having to 
recheck everything again...

Matthias
