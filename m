Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39552 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3EVSQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 14:16:00 -0400
Message-ID: <519D0B5B.5070707@candelatech.com> (sfid-20130522_201604_568184_02FDF1DC)
Date: Wed, 22 May 2013 11:15:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 3.10] cfg80211: fix interface down/disconnect state handling
References: <1368516968-29292-1-git-send-email-johannes@sipsolutions.net> <519D00EF.60002@candelatech.com>
In-Reply-To: <519D00EF.60002@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/2013 10:31 AM, Ben Greear wrote:
> On 05/14/2013 12:36 AM, Johannes Berg wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> When the interface goes down, there's no need to call
>> cfg80211_mlme_down() after __cfg80211_disconnect() as
>> the latter will call the former (if appropriate.)
>>
>> Also, in __cfg80211_disconnect(), if the cfg80211 SME
>> isn't used, __cfg80211_disconnected() may still need
>> to be called (depending on the current state) so that
>> the SME state gets cleared.
>
> 3.9.3 with this patch (and others) was running well until I
> tweaked user-space to drive a bit harder/differently and removed the
> noisy printk from my sme state debugging patches.
>
> Now, it appears the problem is back..though of course I
> don't have useful debugging as to why :P

Err, maybe it's something elsewhere in my logic.

Kernel debugging seems to show proper activity so far...

Ben

>
> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

