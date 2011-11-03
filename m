Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59093 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933640Ab1KCSRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 14:17:55 -0400
Message-ID: <4EB2DACE.2000707@candelatech.com> (sfid-20111103_191758_518226_B3159FB2)
Date: Thu, 03 Nov 2011 11:17:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>  (sfid-20111028_071135_777672_88A08497) <1319789318.3914.10.camel@jlt3.sipsolutions.net>  <4EAAFAA7.8090403@candelatech.com>  (sfid-20111028_205543_472872_4928ADE0) <1320220415.3950.1.camel@jlt3.sipsolutions.net>  <4EB17103.70506@candelatech.com>  <1320256263.7846.3.camel@jlt3.sipsolutions.net>  <4EB22EE6.3030100@candelatech.com> <1320309058.3950.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320309058.3950.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 01:30 AM, Johannes Berg wrote:
> On Wed, 2011-11-02 at 23:04 -0700, Ben Greear wrote:
>
>> I think I made at least most of the other changes you were asking
>> for, but I'm still baffled about what to do about fullmac drivers.
>>
>> Based on the comment above, if I simply left out the mac80211 stuff
>> then the new values passed in to the associate/connect logic will just
>> be ignored.
>>
>> So, I suppose the fullmac drivers will just silently ignore the new
>> variables as well.  I looked, but didn't figure out where fullmac
>> connects into the cfg80211 logic.  If I can find it, then I could
>> add explicit checks for the new variables and return failure if
>> they are set..but I'm not sure that is any better than just silently
>> ignoring them anyway.
>
> So I think just ignoring it would be a bad idea, because you have no way
> to know whether or not the values were used afterwards. That might be
> sufficient for you right now, but typically becomes a support problem at
> some point because people try it and can't figure out what part broke.
> That's why I think silently ignoring something like that is not a good
> idea.
>
> Hence the typical handling of this with a wiphy flag that you set and if
> it's unset but userspace is requesting this you reject the command.

So back to the capabilities flag like I added in the -v2 patch?
Do you want one flag for each thing (set-mcs, disable-ht,
disable-ht40, set-mpdu, set-msdu), or maybe one flag for all of
this:  set-ht-cap

My opinion remains that we should silently ignore un-supported
values..this way user-space works with the same config on old and new
kernels.  In future patches, we can report the actual settings via
netlink or similar.

But, I can add logic in user-space to detect kernel versions and
such and deal with this.

So, please tell me how you want it done.  If it's capabilities flags,
that is fine with me.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

