Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43958 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab2LLWP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 17:15:29 -0500
Message-ID: <50C901FC.3040306@candelatech.com> (sfid-20121212_231532_284872_0E0E68CB)
Date: Wed, 12 Dec 2012 14:15:24 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/6] wifi: Don't spam logs with 'Found new beacon' messages.
References: <1355349295-30960-1-git-send-email-greearb@candelatech.com>  <1355349295-30960-2-git-send-email-greearb@candelatech.com>  (sfid-20121212_225535_981449_212B81FE) <1355350115.9708.21.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355350115.9708.21.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/2012 02:08 PM, Johannes Berg wrote:
> On Wed, 2012-12-12 at 13:54 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> We saw logs fill with this (at very high speeds):
>>
>> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
>> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
>> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
>> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
>> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
>> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
>> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
>> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
>> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
>> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
>> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
>> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   net/wireless/reg.c |   11 ++++++-----
>>   1 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index 6e53089..8aa7867 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -2067,11 +2067,12 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
>>   	if (!reg_beacon)
>>   		return -ENOMEM;
>>
>> -	REG_DBG_PRINT("Found new beacon on "
>
> Why not just disable the config option for it if you don't care?

I don't mind seeing it, just don't want thousands of them in my logs
in a very short amount of time.  Maybe I was just hitting some
other bug, and there is no valid reason for this to ever spam?

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

