Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64802 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094Ab2FEIuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 04:50:07 -0400
Message-ID: <4FCDC838.9010209@qca.qualcomm.com> (sfid-20120605_105011_930920_B021DCB7)
Date: Tue, 5 Jun 2012 14:20:00 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] cfg80211: Fix incompatible interfaces combination
References: <1338824836-2283-1-git-send-email-mohammed@qca.qualcomm.com>		 <1338825141.4512.14.camel@jlt3.sipsolutions.net>		 <4FCCDB63.3040806@qca.qualcomm.com>		 <1338826398.4512.23.camel@jlt3.sipsolutions.net>		 <4FCCDF78.4040606@qca.qualcomm.com>		 <1338826731.4512.24.camel@jlt3.sipsolutions.net>		 (sfid-20120604_181856_034243_5406D052) <1338826773.4512.25.camel@jlt3.sipsolutions.net>	 <4FCDA8DB.9000000@qca.qualcomm.com> <1338878939.4514.11.camel@jlt3.sipsolutions.net>
In-Reply-To: <1338878939.4514.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>>> No, initialization was incorrect -- this is better:
>>> http://p.sipsolutions.net/e5ab0f3e38f90d6d.txt
>>>
>>
>> thanks a lot for the patch!
>> with the above patch ath9k seems be working fine with the single
>> incompatible adhoc interface.
>
> Ok, cool.
>
>> but i was just experimenting with ath9k(similar to iwlwifi having
>> hw->wiphy->n_iface_combinations>  1) with this patch.
>>
>> static const struct ieee80211_iface_limit a[] = {
>>           { .max = 2,     .types = BIT(NL80211_IFTYPE_STATION) },
>> };
>>
>> static const struct ieee80211_iface_limit b[] = {
>>           { .max = 2,     .types = BIT(NL80211_IFTYPE_MESH_POINT) },
>> };
>>
>> static const struct ieee80211_iface_combination if_comb[] = {
>>           {.limits = a,
>>           .n_limits = ARRAY_SIZE(a),
>>           .max_interfaces = 2,
>>           .num_different_channels = 1,
>>           },
>>           {.limits = b,
>>           .n_limits = ARRAY_SIZE(b),
>>           .max_interfaces = 2,
>>           .num_different_channels = 1,
>>           },
>>
>> };
>>
>> i could not add mesh interface if a managed interface is already there
>> and vice versa. if this is the expected behavior, then fine.
>
> No, that's not expected! Another bug!
>
> We should write some unit tests for this code I guess :-)
>
>> iteration 1: cfg80211_can_change_interface all_iftypes 4 and used_iftypes 84
>> iteration 2: cfg80211_can_change_interface all_iftypes 80 and used_iftypes 84
>
> Curious. Why did it accept it then? Where did you place the printk?

not sure whether i missed something, but it did not work for the above 
case. printk just inside the condition check of your patch.

  if ((all_iftypes & used_iftypes) != used_iftypes) {
+                               printk("\nshafi %s all_iftypes %x and 
used_iftypes %x", __func__, all_iftypes, used_iftypes);
+                               goto cont;
+                       }


i think we need to take 'all_iftypes' for all the 
'n_interface_combinations' and then finally compare it with used_iftypes.

>
> I'm handling Linus's problem right now, so it'll be a bit until I can
> look at this in more detail again.

oh ok, sure.



-- 
thanks,
shafi
