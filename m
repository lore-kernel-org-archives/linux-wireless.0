Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60688 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750727AbdFORto (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 13:49:44 -0400
Subject: Re: Question on flushing and deauth frames
To: Emmanuel Grumbach <egrumbach@gmail.com>
References: <10e690bb-b201-13e2-8c4d-1708bab37106@candelatech.com>
 <CANUX_P2LrrNzLWRtOERnSyu0q=C4u26V+iJbpxqUssYb80PzEg@mail.gmail.com>
 <485de26b-87ae-6977-dbb2-bc98378d3aeb@candelatech.com>
 <CANUX_P1ppTkXfXS-3RcocB_GBf5earZgZPM3fMiFem2jpRoPZA@mail.gmail.com>
 <c291bc94-d1cd-5fca-dba0-d1b617ea0cb8@candelatech.com>
 <CANUX_P157H0rNV3QmODKTejjYb4smwzMi2N9a9dmwbrZ-G2mkw@mail.gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <4d4da6d1-da3c-9c6a-0a77-1d2848a3f5cb@candelatech.com> (sfid-20170615_194946_673650_F500FE7C)
Date: Thu, 15 Jun 2017 10:49:42 -0700
MIME-Version: 1.0
In-Reply-To: <CANUX_P157H0rNV3QmODKTejjYb4smwzMi2N9a9dmwbrZ-G2mkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2017 10:40 AM, Emmanuel Grumbach wrote:
>>>
>>> Keep in mind that this code is also called when roaming, any
>>> additional operations will slow down the roaming process. Not all the
>>
>>
>> This is a reason to not retransmit, but logically the flush(drop=false) is
>> supposed to wait for the frame to be transmitted anyway, and at that point,
>> tx-status should be immediately available.
>>
>
> I can't disagree here although waiting for the Tx status can be tricky
> for the low level drivers that don't implement tx_status.
>
>>> drivers support tx_status, but I think that this could be implemented
>>> internally in ath10k. In iwlwifi, we just wait until the queues get
>>> empty without dropping the packets.
>>
>>
>> When you support virtual stations and a fat firmware, that can be tricky to
>> implement.
>>
>> From your description, are you waiting on a single vdev, or multiple when
>> you flush?
>
> In the past, we had queues per vdev. So that we had to wait for the
> queues of the vdev. Note that Intel is more focused on the BSS
> scenario in which vdev = station pretty much. I understand that you
> are more focused on the AP scenario, but that shouldn't really delete
> stations all that often, right?

My main interest is in emulating lots of station vdevs, like 64 per
NIC with ath10k.  So, dis-associating one should have the least impact
possible on the others.

More normal users are typically one vdev per NIC, so it matters less,
though with some of the P2P stuff, maybe it would still be useful.

In AP mode, I am less certain of how this all works, but there may
also be cases there where changing a flush to waiting for a tx-completion
would be useful.

>> If multiple, then waiting for tx status of just the deauth frame should be
>> faster
>> on average than waiting for the flush since you don't have to flush the
>> other
>> vdevs.
>
> True. Well, on Intel devices, we work with Tx queues, and now we have
> a Tx queue for each ra/tid. Yes it limits the number of peers we can
> support, but as I said, we are less AP mode oriented.

ath10k has similar.

>
>>
>> Whether drivers support a correct tx-status, I think all of them report
>> *some* tx
>> status...that is how mac80211 knows it can clean up the frame?  That would
>> be enough
>> to know that the frame at least went through the tx logic and thus was
>> flushed.
>
> It is an option. Maybe mac80211 could pass the pointer to the skb it
> is waiting for in the flush(drop=false) call and that would make it
> easier for you to wait for it internally in ath10k?

I think that would not help a great deal.  I've got some more critical
things to poke at first, but maybe will attempt a tx-completion wait
instead of a flush and see how that works.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
