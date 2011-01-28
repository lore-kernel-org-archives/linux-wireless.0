Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37095 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1A1RPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 12:15:52 -0500
Message-ID: <4D42F9C0.1030609@candelatech.com>
Date: Fri, 28 Jan 2011 09:15:44 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Be more careful when changing channels.
References: <1296194947-12017-1-git-send-email-greearb@candelatech.com> <1296206917.4550.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296206917.4550.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2011 01:28 AM, Johannes Berg wrote:
> On Thu, 2011-01-27 at 22:09 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> If we cannot set the channel type, set the channel back to the
>> original.
>>
>> Don't update the driver hardware if nothing actually changed.
>
> Good catch.
>
>
>> +	old_oper = local->oper_channel;
>>   	local->oper_channel = chan;
>>
>> -	if (!ieee80211_set_channel_type(local, sdata, channel_type))
>> +	old_oper_type = local->_oper_channel_type;
>> +	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
>> +		local->oper_channel = old_oper;
>>   		return -EBUSY;
>> +	}
>> +
>> +	if ((old_oper != local->oper_channel) ||
>> +	    (old_oper_type != local->_oper_channel_type))
>> +		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>>
>> -	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>> -	if (sdata&&  sdata->vif.type != NL80211_IFTYPE_MONITOR)
>> +	if ((sdata&&  sdata->vif.type != NL80211_IFTYPE_MONITOR)&&
>> +	    old_vif_oper_type != sdata->vif.bss_conf.channel_type)
>>   		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);
>
> But why the complicated code? Couldn't you just swap the
> set_channel_type() and oper_channel = chan around? set_channel_type()
> doesn't need oper_channel set.

Yes, that would simplify the first part.  The extra checks at the bottom need to
remain as far as I can tell.

I'll send a new patch today.

Thanks,
Ben

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
