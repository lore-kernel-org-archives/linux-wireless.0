Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49369 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbbDOPGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 11:06:25 -0400
Message-ID: <552E7E70.5070101@candelatech.com> (sfid-20150415_170628_422795_B230D7E3)
Date: Wed, 15 Apr 2015 08:06:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211_hwsim: notify user-space about channel change.
References: <1424217588-29558-1-git-send-email-greearb@candelatech.com>			  	  (sfid-20150218_005956_617537_D2A9B91F) <1424692155.2782.6.camel@sipsolutions.net>			  	 <54EB66CC.1030800@candelatech.com>			   <1424772714.2192.16.camel@sipsolutions.net>			   <54EC8C5D.5090400@candelatech.com>			  <1424788834.2192.34.camel@sipsolutions.net>			  <5500AE12.6040103@candelatech.com>			 <1427812067.2057.27.camel@sipsolutions.net>			 <551AC3B6.1040001@candelatech.com>		 <1428999215.3019.6.camel@sipsolutions.net>		 <552D2A90.1070307@candelatech.com>	 <1429023990.3019.15.camel@sipsolutions.net>	 <552D386E.40306@candelatech.com> <1429090400.1784.2.camel@sipsolutions.net>
In-Reply-To: <1429090400.1784.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/15/2015 02:33 AM, Johannes Berg wrote:
> On Tue, 2015-04-14 at 08:55 -0700, Ben Greear wrote:
>
>>> True, although I'd like to see the multi-channel issue addressed better.
>>
>> I need a hint or two on what exactly you want changed in my patch to
>> address your request, or maybe you or someone else can just address
>> the issue in follow-on patches?
>
> So right now you're basically saying to userspace "switch to channel X".
> But that's not really how the more generic system works, that's more
> "start using channel X (ctx=1)" / "stop using channel X (ctx=1)" /
> "change channel to X (ctx=1)" and similar.
>
> It seems to me that such an API should probably be the only API to
> userspace. The non-chanctx case in hwsim could simply fake it by
> starting with "start using channel X (ctx=0)" and then changing that
> channel all the time.
>
> The issue is that with your patch in this can't be addressed in
> follow-on patches as it fixes the userspace API.

Ok, so adding an additional 'uint16 ctx' to the channel change data,
and providing a 'type' field that includes start-using, stop-using
would address this problem adequately?

Start-using seems it would be the same as change-channel, or do I need
a type for that as well?

THanks,
Ben



>
> johannes
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
