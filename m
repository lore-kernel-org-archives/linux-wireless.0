Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54114 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab2FDPrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 11:47:08 -0400
Message-ID: <4FCCD860.6020901@qca.qualcomm.com> (sfid-20120604_174713_721778_B40AB4BD)
Date: Mon, 4 Jun 2012 21:16:40 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>, <stable@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: Fix a WARNING in suspend/resume with IBSS
References: <1338532779-4621-1-git-send-email-mohammed@qca.qualcomm.com>			 (sfid-20120601_083956_399882_A3D65832) <1338533070.4884.4.camel@jlt3.sipsolutions.net>		 <4FC86AB4.9020602@qca.qualcomm.com>	 <1338534832.4884.7.camel@jlt3.sipsolutions.net>	 <4FCA30DE.4080805@qca.qualcomm.com> <1338659135.12823.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1338659135.12823.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,


>>>>> You could just remove the entire check since the interface combinations
>>>>> you advertise don't allow it, I think? Or just fix those
>>>>> combinations :-)
>>>>
>>>> i did not check this before, thanks a lot for your inputs. will send a
>>>> proper v2 after checking this out.
>>>
>>> If this is needed for stable, you might want to keep this patch&   send
>>> another one to remove it.
>>
>> thanks Johannes.
>> i was looking at how to fix this properly in iface combination
>> advertised to mac80211.  got few doubts regarding this
>>
>> *if an interface type is not all advertised in the
>> ieee80211_iface_combination then it cannot it be co-existing with any
>> other interfaces ?
>> please let me know is there some other way do that.
>>
>> if we advertise something like this
>>
>> static const struct ieee80211_iface_limit if_limits[] = {
>> 	{set1
>>       	.... },
>> 	{set 2
>> 	.... },
>> };
>>
>> then interface types in set1 and set2 co-exist as per the logic in
>> cfg80211_can_change_interface. is there already a way we can make
>> set1 and set2 interface types mutually exclusive ? thanks!
>
> The sets are mutually exclusive, and there are implied sets of each
> interface with a max number of 1. So for example, in iwlwifi we don't
> advertise IBSS in the combinations at all, because it's not compatible
> with anything. In your case, I think the same applies, since you said
>
>          if the first interface is ADHOC we cannot have any other
>          interface. we cannot add an ADHOC interface if there is already
>          an interface is present
>
> Thus, if you leave IBSS out of the combinations you should get the
> desired behaviour of not being able to combine IBSS with any other
> types.
>

ath9k and also iwlwifi seems to have IBSS check not included in any of 
the interface combinations, but still i am able to IBSS interface 
atleast in ath9k with the checks removed in drv_add_interface.
it seems we are allowing any interface type to be added even if
its not added in the ieee80211_iface_combination structure.

i am sending an RFC to add this check in cfg80211 based on my 
understanding. please review my understanding and any corrections
needed. thanks for your thoughts!

-- 
thanks,
shafi
