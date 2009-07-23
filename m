Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:48785 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbZGWR5O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 13:57:14 -0400
Message-ID: <4A68A465.6020501@promwad.com>
Date: Thu, 23 Jul 2009 20:56:53 +0300
From: Ivan Kuten <ivan.kuten@promwad.com>
Reply-To: ivan.kuten@promwad.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Johannes Berg <johannes@sipsolutions.net>,
	Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
Subject: Re: [PATCH] wireless: Compare ethernet addresses by unaligned safe
 way
References: <1245149672-18063-1-git-send-email-yauhen.kharuzhy@promwad.com>	<1245150895.8623.3.camel@johannes.local>  <4A475F82.9040007@promwad.com> <1246262320.5947.3.camel@johannes.local>
In-Reply-To: <1246262320.5947.3.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Sun, 2009-06-28 at 15:18 +0300, Ivan Kuten wrote:
>> Hello,
>>
>> In net/wireless/scan.c : cfg80211_wext_siwscan there seems also unaligned allocations
>> for creq->ssids and creq->channels. Should it be something like that?
> 
> Seems alright, but there is more than one instance of this, maybe you
> can make a function to allocate a scan request properly and have it be
> called from all the places it's needed.
> 
> johannes
> 

Hello Johannes,
Can you point to that multiple scan allocations? I see only one kzalloc
with followed possible alignment violation - it's in cfg80211_wext_siwscan in scan.c

Regards,
Ivan


>> Modified: trunk/uClinux-dist-2008R1-RC8/compat-wireless-2009-06-11/net/wireless/scan.c
>> ==============================================================================
>> --- trunk/uClinux-dist-2008R1-RC8/compat-wireless-2009-06-11/net/wireless/scan.c (original)
>> +++ trunk/uClinux-dist-2008R1-RC8/compat-wireless-2009-06-11/net/wireless/scan.c Fri Jun 26 14:00:52 2009
>> @@ -619,7 +619,7 @@
>>  		if (wiphy->bands[band])
>>  			n_channels += wiphy->bands[band]->n_channels;
>>
>> -	creq = kzalloc(sizeof(*creq) + sizeof(struct cfg80211_ssid) +
>> +	creq = kzalloc(roundup(sizeof(*creq), 4) + roundup(sizeof(struct cfg80211_ssid), 4) +
>>  		       n_channels * sizeof(void *),
>>  		       GFP_ATOMIC);
>>  	if (!creq) {
>> @@ -629,8 +629,8 @@
>>
>>  	creq->wiphy = wiphy;
>>  	creq->ifidx = dev->ifindex;
>> -	creq->ssids = (void *)(creq + 1);
>> -	creq->channels = (void *)(creq->ssids + 1);
>> +	creq->ssids = (void *)creq + roundup(sizeof(*creq), 4);
>> +	creq->channels = (void *)creq->ssids + roundup(sizeof(*creq->ssids), 4);
>>  	creq->n_channels = n_channels;
>>  	creq->n_ssids = 1;
>>
>> Regards,
>> Ivan
>>
>>> On Tue, 2009-06-16 at 13:54 +0300, Yauhen Kharuzhy wrote:
>>>> When we try to run RTL8187 driver on AD BlackFin platform, we got
>>>> messages from kernel about unaligned memory access at
>>>> compare_ether_addr() calls.
>>>>
>>>> Replacing of compare_ether_addr() by memcmp() fixes this problem.
>>> This shouldn't be necessary. Which operand is unaligned?
>>>
>>>> --- a/net/mac80211/ibss.c
>>>> +++ b/net/mac80211/ibss.c
>>>> @@ -395,7 +395,7 @@ struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
>>>>  		return NULL;
>>>>  	}
>>>>  
>>>> -	if (compare_ether_addr(bssid, sdata->u.ibss.bssid))
>>>> +	if (memcmp(bssid, sdata->u.ibss.bssid, ETH_ALEN))
>>>>  		return NULL;
>>> So in this case it seems that it is possible that u.ibss.bssid is not
>>> aligned, consider fixing by doing
>>>
>>> --- ieee80211_i.h
>>> +++ ieee80211_i.h
>>> -	u8 bssid[ETH_ALEN];
>>> +	u8 bssid[ETH_ALEN] __align(2);
>>>
>>> or so instead.
>>>  
>>>> --- a/net/wireless/scan.c
>>>> +++ b/net/wireless/scan.c
>>>> @@ -134,7 +134,7 @@ static bool is_bss(struct cfg80211_bss *a,
>>>>  {
>>>>  	const u8 *ssidie;
>>>>  
>>>> -	if (bssid && compare_ether_addr(a->bssid, bssid))
>>>> +	if (bssid && memcmp(a->bssid, bssid, ETH_ALEN))
>>> Since a->bssid is after a pointer I can't see how it would be unaligned,
>>> and bssid should be unaligned only if the call trace shows it's coming
>>> from the above u.ibss.bssid.
>>>
>>> johannes
>>

