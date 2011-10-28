Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54424 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab1J1QYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 12:24:24 -0400
Message-ID: <4EAAD734.10501@candelatech.com> (sfid-20111028_182428_876939_0D798225)
Date: Fri, 28 Oct 2011 09:24:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>  (sfid-20111028_071135_777672_88A08497) <1319789318.3914.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1319789318.3914.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/2011 01:08 AM, Johannes Berg wrote:
> On Thu, 2011-10-27 at 22:11 -0700, greearb@candelatech.com wrote:
>
>> The additional netlink bits is to allow this patch to work on 3.0
>> and should not be included in the final patch.
>
> What additional bit?

Sorry, that description is bad.  It was from when I wrote the patch
against the 3.0.6 kernel and I had to add a bunch of netlink
crap to make the header file sync up with top-of-tree hostapd.

>> + * @NL80211_ATTR_DISABLE_80211N:  Force /n capable stations to instead
>> + *      function as /a/b/g stations.
>
> IMHO this should be called DISABLE_HT -- "11n" will not exist for much
> longer.

Ok, I can change that.

>
>> +++ b/net/mac80211/cfg.c
>> @@ -57,6 +57,9 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
>>   	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>>   	int ret;
>>
>> +	if (params->disable_11n != -1)
>> +		sdata->cfg_disable_11n = params->disable_11n;
>
> This doesn't seem right -- why change the iface for it? It's a per
> connection parameter.

I wanted it to be an interface parameter, or at least I think
that is what I want.

>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -595,6 +595,8 @@ struct ieee80211_sub_if_data {
>>   	/* to detect idle changes */
>>   	bool old_idle;
>>
>> +	bool cfg_disable_11n; /* configured to disable 11n? */
>
> That should be in the u.mgd part of the struct.

I would like eventually to support this same feature for AP
interfaces, and probably other types.  Would it still be in
the u.mgd struct in that case?

>> +++ b/net/wireless/nl80211.c
>> @@ -1641,6 +1641,13 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
>>   		change = true;
>>   	}
>>
>> +	if (info->attrs[NL80211_ATTR_DISABLE_11N]) {
>> +		params.disable_11n = !!nla_get_u8(info->attrs[NL80211_ATTR_DISABLE_11N]);
>> +		change = true;
>> +	} else {
>> +		params.disable_11n = -1;
>> +	}
>
> This should be a parameter to connect() and assoc(), not a generic
> netdev parameter, since it applies to the connection.
>
> Also, it would be good to have a capability check for it etc. since a
> lot of fullmac drivers will likely never implement this.

I'll see if I can make it thus.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

