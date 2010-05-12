Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 27.mail-out.ovh.net ([91.121.30.210]:47129 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754675Ab0ELVCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 17:02:31 -0400
Message-ID: <4BEB175F.7000001@free.fr>
Date: Wed, 12 May 2010 23:02:23 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: Add HT IE to IBSS beacons and probe responses.
References: <1273098986-19330-1-git-send-email-benoit.papillault@free.fr>	 <1273098986-19330-2-git-send-email-benoit.papillault@free.fr>	 <1273128051.3573.17.camel@jlt3.sipsolutions.net> <4BE49BDD.8010803@free.fr> <1273574892.3669.54.camel@jlt3.sipsolutions.net>
In-Reply-To: <1273574892.3669.54.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 11/05/2010 12:48, Johannes Berg a écrit :
> On Sat, 2010-05-08 at 01:01 +0200, Benoit Papillault wrote:
>
>>> It would be helpful if you were to rebase over my patch that adds the
>>> channel type tracking.
>>
>> Your patches are now in wireless-testing, so I am doing it at the moment.
>
> Thanks.
>
>>>> +	if (channel_type != NL80211_CHAN_NO_HT&&
>>>> +	    sband->ht_cap.ht_supported) {
>>>
>>> You shouldn't be able to get here with an HT channel but !ht_supported,
>>> no? Or is that to support the case where you have HT only on one band?
>>
>> Good point. I think there are several cases here :
>>
>> - a non-HT STA is joining an HT IBSS (we need to check 802.11n-2009 to
>> see how it's supposed to be handled). In this case channel_type could be
>> ht40+ and ht_supported = false
>
> Hmm, true.
>
>> - an HT STA is joining a non-HT IBSS. It's clear in this case that no HT
>> IE should be sent, which is catched by (channel_type !=
>> NL80211_CHAN_NO_HT) condition.
>
> Right.
>
>> Could we examine those cases in a follow up patch?
>
> Well what do we actually need to do then?

I thought again about 2 HT STA joining a non-HT IBSS. If we want those 2 
STA to be able to send/receive HT frames then they must know each other 
capabilities. So HT Capabilities should be sent if ht_supported = true, 
even if channel_type is CHAN_NO_HT

>
>>>> +}
>>>> +
>>>> +int ieee80211_add_ht_info(u8 **ppos,
>>>> +			  struct ieee80211_supported_band *sband,
>>>> +			  struct ieee80211_channel *channel,
>>>> +			  enum nl80211_channel_type channel_type)
>>>
>>> what's wrong with ieee80211_add_ht_ie()
>>
>> Seems it's close to what I'm doing, but not entirely the same. I will
>> read it. If applicable, should I move ieee80211_add_ht_ie to util.c (and
>> declaration to ieee80211_i.h) then ?
>
> Yes.

Done. I still keep both ieee80211_add_ht_ie and ieee80211_add_ht_cap. 
What is done in ieee80211_add_ht_ie is only required for an HT AP, not 
an HT IBSS STA. I guess we should pass "sdata" to those functions before 
merging them.

>
> Also I just noticed that there's a TODO item in rx.c when we receive an
> HT frame from a peer we don't know about yet. Not sure what to do there,
> but you'll need to look at it.

I did some patch in this area in my tree. Basically, the peer STA is 
created only on beacon/probe response since only those frames contains 
peer capabilities. Any frames received before is simply ignored.

>
> johannes
>
>

Regards,
Benoit
