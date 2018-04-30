Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39728 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbeD3WKc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 18:10:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 30 Apr 2018 15:10:31 -0700
From: asinghal@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Kiran Kumar Lokere <klokere@codeaurora.org>,
        jjohnson@codeaurora.org
Subject: Re: [PATCH 2/2] cfg80211: Modify wiphy registration semantics for
 self managed hints
In-Reply-To: <1524150429.3024.24.camel@sipsolutions.net>
References: <1520106021-16836-1-git-send-email-jouni@codeaurora.org>
 <1520106021-16836-2-git-send-email-jouni@codeaurora.org>
 <1521627352.2645.27.camel@sipsolutions.net>
 <5f8caab7e7cfb88072c2e221ea45063e@codeaurora.org>
 <1524150429.3024.24.camel@sipsolutions.net>
Message-ID: <8dab316b358495f85821474540af4532@codeaurora.org> (sfid-20180501_001035_361294_307609C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Johannes,
             replies inline:

On 2018-04-19 08:07, Johannes Berg wrote:
> On Fri, 2018-04-13 at 13:32 -0700, asinghal@codeaurora.org wrote:
>> hi Johannes,
>>              please fine some replies inline:
>> 
>> On 2018-03-21 03:15, Johannes Berg wrote:
>> > So I really think this should just be one patch - it's not about
>> > "registration semantics" but about which types of requests get passed
>> > to reg_notifier(), and if you do it in one place you'd better also do
>> > it in the other.
>> 
>> Sure, I have combined the two patches in one patch now:
> 
> So now you should probably resend it properly, with a new subject that
> explains it better? Just "modify" doesn't really seem all that
> appropriate - what's the modification?
> 
> Patchwork also lost half the patch for some reason, probably you
> copy/pasted it and lost some whitespace at an empty line.
> 
We have posted a new patch-set with better commit title and message.

>> Call the regulatory notifier for self managed hints only if
>> initiator is NL80211_REGDOM_SET_BY_USER and hint type is
>> NL80211_USER_REG_HINT_CELL_BASE. Also call regulatory
>> notifier when wiphy is registered under similar conditions.
> 
> I guess this should say why.
> 
>>   	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
>>   		wiphy = &rdev->wiphy;
>> -		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
>> +		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
>>   			self_managed_found = true;
>> -		else
>> -			return false;
>> +			if (request->initiator == NL80211_REGDOM_SET_BY_USER &&
>> +			    request->user_reg_hint_type ==
>> +			    NL80211_USER_REG_HINT_CELL_BASE)
>> +				reg_call_notifier(wiphy, request);
>> +		} else {
>> +			self_managed_found = false;
>> +		}
>>   	}
> 
> This is awkward now - how about
> 
> self_managed_found = regulatory_flags & SELF_MANAGED;
> if (self_managed_found &&
>     request->initiator == ... &&
>     ...)
>         reg_call_notifier(...)

This has been addressed in the new patch with a separate notify 
function.
> 
> 
>> @@ -3700,15 +3705,21 @@ void wiphy_regulatory_register(struct wiphy
>> *wiphy)
>>   {
>>   	struct regulatory_request *lr;
>> 
>> -	/* self-managed devices ignore external hints */
>> -	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
>> +	lr = get_last_request();
>> +
>> +	/* self-managed devices ignore beacon hints and 11d IE */
>> +	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
>>   		wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
>> -					   REGULATORY_COUNTRY_IE_IGNORE;
>> +			REGULATORY_COUNTRY_IE_IGNORE;
> 
> no need to change the indentation here

has been addressed in new patch.
thanks,
amar
> 
> johannes
