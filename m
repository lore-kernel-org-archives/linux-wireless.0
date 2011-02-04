Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45063 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1BDS6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 13:58:46 -0500
Message-ID: <4D4C4C61.7060605@candelatech.com>
Date: Fri, 04 Feb 2011 10:58:41 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v9] mac80211: Optimize scans on current operating channel.
References: <1296670694-28596-1-git-send-email-greearb@candelatech.com> <1296672941.5671.38.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296672941.5671.38.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/2011 10:55 AM, Johannes Berg wrote:
> On Wed, 2011-02-02 at 10:18 -0800, greearb@candelatech.com wrote:
>
>> * Do no blindly go off/on channel in work.c  Instead, only call
>>    appropriate on/off code when we really need to change channels.
>
> Based on the powersave comments I had earlier, maybe we should remove
> that bit for now? Work items here require powersave is disabled, but we
> won't do that right now if we're on the same channel.
>
> Scan, on the other hand, will still disable powersave (right?)

With regard to scanning and power-save:  If we are scanning on
channel, I think we should still be able to receive normal traffic.

The offchannel_ps_enable has this comment:

/*
  * inform AP that we will go to sleep so that it will buffer the frames
  * while we scan
  */
static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)


So, do we really need to call this method for on-channel scanning?

My naive assumption is that we would actually want the NIC to disable it's
local power-save logic while we are scanning so that it doesn't
get sleepy and miss beacons?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

