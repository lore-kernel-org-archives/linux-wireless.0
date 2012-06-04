Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45190 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab2FDQRC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 12:17:02 -0400
Message-ID: <4FCCDF78.4040606@qca.qualcomm.com> (sfid-20120604_181721_778343_EAC6F2F0)
Date: Mon, 4 Jun 2012 21:46:56 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] cfg80211: Fix incompatible interfaces combination
References: <1338824836-2283-1-git-send-email-mohammed@qca.qualcomm.com>	 <1338825141.4512.14.camel@jlt3.sipsolutions.net>	 <4FCCDB63.3040806@qca.qualcomm.com> <1338826398.4512.23.camel@jlt3.sipsolutions.net>
In-Reply-To: <1338826398.4512.23.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 04 June 2012 09:43 PM, Johannes Berg wrote:
> On Mon, 2012-06-04 at 21:29 +0530, Mohammed Shafi Shajakhan wrote:
>> On Monday 04 June 2012 09:22 PM, Johannes Berg wrote:
>>> On Mon, 2012-06-04 at 21:17 +0530, Mohammed Shafi Shajakhan wrote:
>>>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>>>
>>>> *if any interface type is not advertised by the driver
>>>> via ieee80211_iface_combination make sure we will have it
>>>> as a single interface only. lets that we will not add
>>>> an incompatible interface if some other interface is
>>>> already present. we cannot add any other interface,
>>>> if the already present interface is an incompatible
>>>> interface. for example in ath9k we don't advertise ADHOC in
>>>> ieee80211_iface_combination structure in the driver,
>>>> so it can only exist as an single interface
>>>
>>> I'm not sure I understand what you're changing here?
>>
>> if an interface say ad-hoc is not advertised in iface combination,
>> with the current still we can add that interface with some other
>> interface(removing the driver checks).
>>
>> in ath9k we have
>>
>> static const struct ieee80211_iface_limit if_limits[] = {
>>           { .max = 2048,  .types = BIT(NL80211_IFTYPE_STATION) |
>>                                    BIT(NL80211_IFTYPE_P2P_CLIENT) |
>>                                    BIT(NL80211_IFTYPE_WDS) },
>>           { .max = 8,     .types =
>> #ifdef CONFIG_MAC80211_MESH
>>                                    BIT(NL80211_IFTYPE_MESH_POINT) |
>> #endif
>>                                    BIT(NL80211_IFTYPE_AP) |
>>                                    BIT(NL80211_IFTYPE_P2P_GO) },
>> };
>>
>> i am able to create an IBSS interface even if a STA interface is up and
>> running in ath9k(removing the driver checks).
>>
>> this patch ensures that if we have an incompatible interface, it is the
>> only one can that can exist.
>
> Right, ok, I see that it's broken now, trying to see if there's a better
> fix though.

sure, thank you.

>
> johannes
>


-- 
thanks,
shafi
