Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40614 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2IGPh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 11:37:28 -0400
Message-ID: <504A14B0.4020104@candelatech.com> (sfid-20120907_173732_290358_F7A71BBF)
Date: Fri, 07 Sep 2012 08:37:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: validate skb->dev in the tx status path
References: <1347029656-41430-1-git-send-email-nbd@openwrt.org>  <504A11C0.5030602@candelatech.com> <1347031704.4256.26.camel@jlt4.sipsolutions.net>
In-Reply-To: <1347031704.4256.26.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/07/2012 08:28 AM, Johannes Berg wrote:
> On Fri, 2012-09-07 at 08:24 -0700, Ben Greear wrote:
>> On 09/07/2012 07:54 AM, Felix Fietkau wrote:
>>> skb->dev might contain a stale reference to a device that was already
>>> deleted, and using it unchecked can lead to invalid pointer accesses.
>>> Since this is only used for nl80211 tx, iterate over active interfaces
>>> to find a match for skb->dev, and discard the tx status if the device
>>> is gone.
>>
>> Nasty performance hit if we have lots of virtual
>> interfaces, eh?  Maybe some sort of ref-counting
>> would be better?  Or a hashed lookup on the netdev
>> pointer/token?
>
> As Felix also pointed out to me, no. Frames that need to go to nl80211
> should be rare, this isn't the common case.

Ahh, ok.  I was thinking each transmitted pkt would cause this code
to run.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

