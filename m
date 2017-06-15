Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58162 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbdFOQr2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 12:47:28 -0400
Subject: Re: Question on flushing and deauth frames
To: Emmanuel Grumbach <egrumbach@gmail.com>
References: <10e690bb-b201-13e2-8c4d-1708bab37106@candelatech.com>
 <CANUX_P2LrrNzLWRtOERnSyu0q=C4u26V+iJbpxqUssYb80PzEg@mail.gmail.com>
 <485de26b-87ae-6977-dbb2-bc98378d3aeb@candelatech.com>
 <CANUX_P1ppTkXfXS-3RcocB_GBf5earZgZPM3fMiFem2jpRoPZA@mail.gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <c291bc94-d1cd-5fca-dba0-d1b617ea0cb8@candelatech.com> (sfid-20170615_184732_177624_209164CF)
Date: Thu, 15 Jun 2017 09:47:27 -0700
MIME-Version: 1.0
In-Reply-To: <CANUX_P1ppTkXfXS-3RcocB_GBf5earZgZPM3fMiFem2jpRoPZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2017 09:34 AM, Emmanuel Grumbach wrote:
> On Thu, Jun 15, 2017 at 4:32 PM, Ben Greear <greearb@candelatech.com> wrote:
>>
>>
>> On 06/14/2017 11:18 PM, Emmanuel Grumbach wrote:
>>>>
>>>> ath10k is a bit weird about flushing frames, and at least my variant of
>>>> the wave-2
>>>> firmware does not always put the deauth frame on the air when deleting
>>>> stations.
>>>>
>>>> It will likely not be much fun to fix this.  I was wondering if the code
>>>> below
>>>> from ieee80211_set_disassoc() could (easily?) be made to wait for a
>>>> tx-status of the deauth frame
>>>> instead of trying to force a flush?
>>>
>>>
>>> That's exactly what it does:
>>
>>
>> Well, the end effect is supposed to be the same, at least...
>>
>>>>        /*
>>>>          * drop any frame before deauth/disassoc, this can be data or
>>>>          * management frame. Since we are disconnecting, we should not
>>>>          * insist sending these frames which can take time and delay
>>>>          * the disconnection and possible the roaming.
>>>>          */
>>>>         if (tx)
>>>>                 ieee80211_flush_queues(local, sdata, true);
>>>
>>>
>>> Remove all the pending data frames from the queues to clear the way
>>> for the deauth.
>>> Note the drop=true
>>>
>>>>
>>>>         /* deauthenticate/disassociate now */
>>>>         if (tx || frame_buf)
>>>>                 ieee80211_send_deauth_disassoc(sdata, ifmgd->bssid,
>>>> stype,
>>>>                                                reason, tx, frame_buf);
>>>>
>>>
>>> Send the deauth.
>>>
>>>>         /* flush out frame - make sure the deauth was actually sent */
>>>>         if (tx)
>>>>                 ieee80211_flush_queues(local, sdata, false);
>>>>
>>>
>>> Wait for the deauth (drop=false).
>>> The question here is how ath10k implements the flush(, drop=false)
>>
>>
>> Not well, it seems.  I don't think it has a good way to flush (drop=false)
>> an individual vdev, though probably I could implement it.  And, I think that
>> the packets in the mac80211 txqs might be difficult to flush.
>>
>> But, mac80211 gets a txstatus when the deauth is sent, so if it simply
>> waited on that, it would not matter how flush is implemented.  And, it might
>> try to re-send a time or two if getting the deauth through was worth the
>> wait and the initial attempt(s) got a false txstatus.
>>
>
> Keep in mind that this code is also called when roaming, any
> additional operations will slow down the roaming process. Not all the

This is a reason to not retransmit, but logically the flush(drop=false) is
supposed to wait for the frame to be transmitted anyway, and at that point,
tx-status should be immediately available.

> drivers support tx_status, but I think that this could be implemented
> internally in ath10k. In iwlwifi, we just wait until the queues get
> empty without dropping the packets.

When you support virtual stations and a fat firmware, that can be tricky to implement.

 From your description, are you waiting on a single vdev, or multiple when you flush?
If multiple, then waiting for tx status of just the deauth frame should be faster
on average than waiting for the flush since you don't have to flush the other
vdevs.

Whether drivers support a correct tx-status, I think all of them report *some* tx
status...that is how mac80211 knows it can clean up the frame?  That would be enough
to know that the frame at least went through the tx logic and thus was flushed.

> Of course, I am giving my *non authoritative* opinion :)

I appreciate it none the less!

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
