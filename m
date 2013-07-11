Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38584 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab3GKP3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 11:29:39 -0400
Message-ID: <51DECF5B.7040002@candelatech.com> (sfid-20130711_172955_239018_73C749A6)
Date: Thu, 11 Jul 2013 08:29:31 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [WT PATCH 4/6] mac80211: Add per-sdata station hash, and sdata
 hash.
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>  <1372546738-25827-4-git-send-email-greearb@candelatech.com>  (sfid-20130630_005944_514926_D21D8724) <1373532936.8201.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1373532936.8201.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2013 01:55 AM, Johannes Berg wrote:
> On Sat, 2013-06-29 at 15:58 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Add sdata hash (based on sdata->vif.addr) to local
>> structure.
>>
>> Add sta_vhash (based on sta->sta.addr) to sdata struct.
>>
>> Make STA_HASH give a better hash spread more often.
>>
>> Use new hashes where we can.  Might be able to completely
>> get rid of the local->sta_hash, but didn't want to try that
>> quite yet.
>>
>> This significantly improves performance when using lots
>> of station VIFs connected to the same AP.  It will likely
>> help other cases where the old hash logic failed to create
>> a decent spread.
>
> I think this is too much code for a corner case unlikely to happen
> outside of your specific scenario, so I'm not taking this either.
>
> I also don't like maintaining two separate hash tables and all that.
>
> I'd reconsider if you actually remove the hash entirely, but that'll be
> tricky to walk the station list and will quite possibly make the RX path
> there more expensive?

Remove local->sta_hash ?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

