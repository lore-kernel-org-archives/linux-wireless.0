Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60558 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2DRD4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 23:56:42 -0400
Message-ID: <4F8E3B76.2010506@candelatech.com> (sfid-20120418_055645_874214_1B2E40A8)
Date: Tue, 17 Apr 2012 20:56:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Add ethtool stats support for Wireless Devices
References: <1334684807-14026-1-git-send-email-greearb@candelatech.com>  (sfid-20120417_194701_243314_85F8C04C) <1334713448.3725.21.camel@jlt3.sipsolutions.net>
In-Reply-To: <1334713448.3725.21.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2012 06:44 PM, Johannes Berg wrote:
> On Tue, 2012-04-17 at 10:46 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>>
>> This enables ethtool stats for mac80211 devices.  It also
>> adds hooks to call down into mac80211 drivers for additional
>> stats.  Patches to enable this hook in ath9k will be posted
>> in a different series.
>>
>> There was a review question about how to make the ethtool
>> strings line up with the data in a less error prone manner.
>> This patch series does NOT address that.  I think it may
>> be more work than it's worth to try to do this, but we
>> can always retro-fit such behaviour later if desired.
>> Many drivers have this issue, so perhaps some support
>> code in the ethtool core is the way to go.
>>
>> V2:  Fix getting survey stats:  Need to specify the
>>    current channel index, not just use index zero.  The
>>    fix for this involved adding a new helper method which
>>    adds a patch to the series.
>
> I'm in training all day tomorrow, and then I'll make my way home only to
> go on vacation this weekend, for two weeks.
>
> Would you mind holding all of this until I return from vacation? There
> are some issues with this where at least one of us has a total
> misunderstanding about how some things work. TBH, it could be me because
> I'm not very familiar with the survey code.

Fair enough.  If the basic infrastructure patches (1-3) seems good
enough, maybe those could go in?  That would let us start tying
the drivers in, and we can work out the survey logic later....

But, if patch 2 and how it adds a netdev's station stats together doesn't
seem right, then we can just hold everything until you are back.

Thanks,
Ben


>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
