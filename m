Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45674 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab1KDQLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 12:11:50 -0400
Message-ID: <4EB40EBB.9010402@candelatech.com> (sfid-20111104_171154_061670_4174DCC6)
Date: Fri, 04 Nov 2011 09:11:39 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>  (sfid-20111028_071135_777672_88A08497) <1319789318.3914.10.camel@jlt3.sipsolutions.net>  <4EAAFAA7.8090403@candelatech.com>  (sfid-20111028_205543_472872_4928ADE0) <1320220415.3950.1.camel@jlt3.sipsolutions.net>  <4EB17103.70506@candelatech.com>  <1320256263.7846.3.camel@jlt3.sipsolutions.net>  <4EB22EE6.3030100@candelatech.com>  <1320309058.3950.7.camel@jlt3.sipsolutions.net>  <4EB2DACE.2000707@candelatech.com> <1320417771.3969.90.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320417771.3969.90.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2011 07:42 AM, Johannes Berg wrote:
> On Thu, 2011-11-03 at 11:17 -0700, Ben Greear wrote:
>
>> So back to the capabilities flag like I added in the -v2 patch?
>> Do you want one flag for each thing (set-mcs, disable-ht,
>> disable-ht40, set-mpdu, set-msdu), or maybe one flag for all of
>> this:  set-ht-cap
>
> I think maybe a single one would be sufficient, but you'd still have no
> way of knowing what is actually supported for changing. Maybe you could
> advertise an ht_mask of things that can be changed?

That seems feasible, though it still won't help with the valid ranges
for mpdu-density, for instance.

How about if I add some way to query this, but leave the code loose
in that it won't fail if someone tries to set a value that isn't
supported.  That way, user-space can be lazy if it wants, but
can also get the details if it cares.

To get this info, I'm going to have to add a new driver API, as far
as I can tell, and I only have the ability to deal with ath9k, so
that will be the only driver that reports the mask.  Of course,
others could modify their drivers as they wish.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

