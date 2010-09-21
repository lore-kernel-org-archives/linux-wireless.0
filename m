Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36695 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0IUTRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 15:17:07 -0400
Message-ID: <4C9904AE.7060107@candelatech.com>
Date: Tue, 21 Sep 2010 12:17:02 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [mac80211/ath9k] mac80211/ath9k:  Support AMPDU with multiple
 VIFs.
References: <1285095455-29081-1-git-send-email-greearb@candelatech.com> <1285096048.12764.9.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285096048.12764.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2010 12:07 PM, Johannes Berg wrote:
> On Tue, 2010-09-21 at 11:57 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> The old ieee80211_find_sta_by_hw method didn't properly
>> find VIFS when there was more than on per AP.  This caused
>> AMPDU logic in ath9k to get the wrong VIF when trying to
>> account for transmitted SKBs.
>>
>> This patch changes ieee80211_find_sta_by_hw to take a
>> net_device pointer to distinguish among multiple VIFs.
>
> Err, no, this certainly isn't the right thing to do, is skb->dev even
> guaranteed to be right? I'm not convinced of that, and besides, if you
> can have the dev you can have the vif too.

The tx path doesn't seem to pass in more than the hardware and the skb,
and we don't always need to lookup the VIF, so looking it up early is
probably a waste.

mac80211 could be changed to pass in the VIF in the xmit path,
and then we could make sure that is passed through the entire
xmit process, but that would touch a lot of drivers and code.

The skb->dev appears to be valid.  Even if the device goes away, we are not
de-referencing the skb->dev anywhere, so it should still be OK.

I can't think of any good reason to corrupt the skb->dev within the xmit
logic, but this is all inside of ath9k anyway, so we should have full
control over that.

I have tested this, and it works.  I don't claim it's the best, but
it may easily be better than what currently exists.

I'm more than happy to test any patches if someone thinks up
a different approach.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

