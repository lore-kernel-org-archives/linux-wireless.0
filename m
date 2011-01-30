Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li59-9.members.linode.com ([97.107.129.9]:55070 "EHLO erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab1A3RlG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 12:41:06 -0500
Message-ID: <4D45A2B1.5050006@erley.org>
Date: Sun, 30 Jan 2011 12:41:05 -0500
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Why is wmm_param required for HT40- in mlme.c
References: <4D44F94F.8040707@candelatech.com> <1296380208.3616.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296380208.3616.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/11 04:36, Johannes Berg wrote:
> On Sat, 2011-01-29 at 21:38 -0800, Ben Greear wrote:
>> I tried to set up hostapd to do HT40-, but for whatever reason,
>> it's not sending any wmm_param options, so the stations will not
>> associate with HT40- enabled due to the check below.
>>
>> Is it really *reqired* that wmm_param exist to enable HT mode?
>>
>>   From mlme.c:
>> 	if (elems.ht_info_elem&&  elems.wmm_param&&
>> 	(sdata->local->hw.queues>= 4)&&
>> 	!(ifmgd->flags&  IEEE80211_STA_DISABLE_11N))
>> 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
>> 					       cbss->bssid, ap_ht_cap_flags);
>
> 802.11n-2009 says it is required.
>

Having run into this same issue before, I considered adding some
default values for the case that wmm is not configured, but someone
tries to enable 802.11n, I just never decided where the best spot
for that would be.  Should this sort of thing be a hostapd default
or somewhere in the cfg80211/mac80211 layer?  I was thinking this
should be something that hostapd does.

As I see it, there are a few ways to prevent this problem:

1. Hostapd doesn't allow 802.11n to be enabled without wmm
2. Hostapd does allow 802.11n to be enabled without wmm, but uses
    defaults
3. Hostapd doesn't care about this, and the kernel doesn't allow
    802.11n without wmm
4. Hostapd doesn't care, but the kernel makes the correnctions

I believe 2 is the cleanest solution.  So that the packets passed
from hostapd can make it through unmolested, and new hostapd versions
can work with older kernels.  Any other solution I'm not thinking of?

Pat Erley

