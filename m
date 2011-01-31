Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48352 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab1AaRfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 12:35:34 -0500
Message-ID: <4D46F2E2.3090905@candelatech.com>
Date: Mon, 31 Jan 2011 09:35:30 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Why is wmm_param required for HT40- in mlme.c
References: <4D44F94F.8040707@candelatech.com>	 <1296380208.3616.0.camel@jlt3.sipsolutions.net>	 <4D45A128.6060905@candelatech.com> <1296471791.3812.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296471791.3812.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2011 03:03 AM, Johannes Berg wrote:
> On Sun, 2011-01-30 at 09:34 -0800, Ben Greear wrote:
>> On 01/30/2011 01:36 AM, Johannes Berg wrote:
>>> On Sat, 2011-01-29 at 21:38 -0800, Ben Greear wrote:
>>>> I tried to set up hostapd to do HT40-, but for whatever reason,
>>>> it's not sending any wmm_param options, so the stations will not
>>>> associate with HT40- enabled due to the check below.
>>>>
>>>> Is it really *reqired* that wmm_param exist to enable HT mode?
>>>>
>>>>    From mlme.c:
>>>> 	if (elems.ht_info_elem&&   elems.wmm_param&&
>>>> 	(sdata->local->hw.queues>= 4)&&
>>>> 	!(ifmgd->flags&   IEEE80211_STA_DISABLE_11N))
>>>> 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
>>>> 					       cbss->bssid, ap_ht_cap_flags);
>>>
>>> 802.11n-2009 says it is required.
>>
>> Do you know the pertinent section, or some keywords to search for?  I'm
>> unable to find anything useful.
>
> No, I got confused. 802.11n says an HT STA is a QoS STA (5.2.9), but in
> practice WMM is tested/certified instead of QoS.

So maybe we can remove that check for wmm_param, but put in a printk
to warn users that their AP is probably mis-configured?

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
