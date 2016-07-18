Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57915 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbcGRTb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:31:29 -0400
Message-ID: <578D2E8A.8090201@candelatech.com> (sfid-20160718_213132_849313_D0D728EC)
Date: Mon, 18 Jul 2016 12:31:22 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
CC: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, ganeshk@qti.qualcomm.com,
	mkalikot@qca.qualcomm.com, amarnath@qca.qualcomm.com
Subject: Re: [PATCH v2] cfg80211: Allow differnt beacon interval if driver
 supports
References: <1468849985-6881-1-git-send-email-pkushwah@qti.qualcomm.com>	 <1468868209.2944.1.camel@sipsolutions.net>	 <578D2846.5060600@candelatech.com> <1468869244.2944.3.camel@sipsolutions.net>
In-Reply-To: <1468869244.2944.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/18/2016 12:14 PM, Johannes Berg wrote:
> On Mon, 2016-07-18 at 12:04 -0700, Ben Greear wrote:
>>
>> On 07/18/2016 11:56 AM, Johannes Berg wrote:
>>> On Mon, 2016-07-18 at 19:23 +0530, Purushottam Kushwaha wrote:
>>>> Driver may allow support for different beacon interval on virtual
>>>> interfaces.
>>>> Allow if such support is advertised by driver. This adds new
>>>> ext_feature as NL80211_EXT_FEATURE_DIFF_BEACON_INTERVAL.
>>>
>>> We have NL80211_IFACE_COMB_STA_AP_BI_MATCH in interface
>>> combinations,
>>> perhaps it would make sense to also put this flag there?
>>
>> I was under impression that ath9k had supported this for years,
>> but I guess I haven't tested it lately....
>>
>
> It may very well have, but if userspace can't rely on it because other
> drivers don't then it's pretty pointless.

A flag would be nice, but for backwards compat, it could be a negative
flag.  But, if mac80211 has to be patched to make this work, then maybe
the ath9k feature has been disabled/broken for some time and wouldn't matter
anyway.

Also, ath9k had some restrictions about having the timers be certain
multiples of each other so the hardware could properly service beacons
for multiple vdevs.  If chip-specific restrictions remain, then it may be almost impossible
to communicate this properly to the hostapd/userspace.  At best, the driver
could just fail to start the vdev in case of mismatch?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
