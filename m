Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39944 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab0ITT4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 15:56:19 -0400
Message-ID: <4C97BC5E.5060704@candelatech.com>
Date: Mon, 20 Sep 2010 12:56:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [mac80211] mac80211:  Support receiving data frames on multiple
 vifs.
References: <1285005163-4569-1-git-send-email-greearb@candelatech.com> <1285009828.3688.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285009828.3688.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2010 12:10 PM, Johannes Berg wrote:
> On Mon, 2010-09-20 at 10:52 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> When using multiple STA interfaces on the same radio, some
>> data packets need to be received on all interfaces
>> (broadcast, for instance).
>>
>> Remove special loop for data-only packets and just process all
>> packets in the big loop that previously only handled non-data
>> packets.
>
> I'd prefer keeping different for_each_*, but maybe we can make the loops
> just call a common function, say with&prev pointer or something? The
> station loop will typically be iterating over fewer things here.

While attempting this, I see something strange.  It appears that
for the last interface (in the non-data loop), the
if (status->flag & RX_FLAG_MMIC_ERROR)
logic will not be run?

Is that on purpose?

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

