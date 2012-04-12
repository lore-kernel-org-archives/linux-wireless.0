Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:60068 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762142Ab2DLH53 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 03:57:29 -0400
Message-ID: <4F868AE6.7080003@tieto.com> (sfid-20120412_095731_646096_1290F9B7)
Date: Thu, 12 Apr 2012 09:57:26 +0200
From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	<chunkeey@googlemail.com>, <wey-yi.w.guy@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: fix interface combinations check.
References: <1334148910-25178-1-git-send-email-lukasz.kucharczyk@tieto.com> <1334204861.3788.20.camel@jlt3.sipsolutions.net>
In-Reply-To: <1334204861.3788.20.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/12/2012 06:27 AM, Johannes Berg wrote:
> On Wed, 2012-04-11 at 14:55 +0200, Lukasz Kucharczyk wrote:
>> Signed-off-by: Lukasz Kucharczyk<lukasz.kucharczyk@tieto.com>
>
> Good catch, should this be Cc stable?

I think so, but I have only tested this with driver which is not yet 
upstreamed. It seems that only carl9170 and iwlwifi are using interface 
combinations. Christian, Wey, what do you think?

Lukasz

>
>> ---
>>   net/wireless/util.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/wireless/util.c b/net/wireless/util.c
>> index 1b7a08d..957f256 100644
>> --- a/net/wireless/util.c
>> +++ b/net/wireless/util.c
>> @@ -989,7 +989,7 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
>>   			if (rdev->wiphy.software_iftypes&  BIT(iftype))
>>   				continue;
>>   			for (j = 0; j<  c->n_limits; j++) {
>> -				if (!(limits[j].types&  iftype))
>> +				if (!(limits[j].types&  BIT(iftype)))
>>   					continue;
>>   				if (limits[j].max<  num[iftype])
>>   					goto cont;
>
>

