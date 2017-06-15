Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36261 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbdFOQeG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 12:34:06 -0400
Received: by mail-oi0-f53.google.com with SMTP id k145so10728442oih.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jun 2017 09:34:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <485de26b-87ae-6977-dbb2-bc98378d3aeb@candelatech.com>
References: <10e690bb-b201-13e2-8c4d-1708bab37106@candelatech.com>
 <CANUX_P2LrrNzLWRtOERnSyu0q=C4u26V+iJbpxqUssYb80PzEg@mail.gmail.com> <485de26b-87ae-6977-dbb2-bc98378d3aeb@candelatech.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Thu, 15 Jun 2017 19:34:05 +0300
Message-ID: <CANUX_P1ppTkXfXS-3RcocB_GBf5earZgZPM3fMiFem2jpRoPZA@mail.gmail.com> (sfid-20170615_183444_703740_CA8399D8)
Subject: Re: Question on flushing and deauth frames
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 15, 2017 at 4:32 PM, Ben Greear <greearb@candelatech.com> wrote:
>
>
> On 06/14/2017 11:18 PM, Emmanuel Grumbach wrote:
>>>
>>> ath10k is a bit weird about flushing frames, and at least my variant of
>>> the wave-2
>>> firmware does not always put the deauth frame on the air when deleting
>>> stations.
>>>
>>> It will likely not be much fun to fix this.  I was wondering if the code
>>> below
>>> from ieee80211_set_disassoc() could (easily?) be made to wait for a
>>> tx-status of the deauth frame
>>> instead of trying to force a flush?
>>
>>
>> That's exactly what it does:
>
>
> Well, the end effect is supposed to be the same, at least...
>
>>>        /*
>>>          * drop any frame before deauth/disassoc, this can be data or
>>>          * management frame. Since we are disconnecting, we should not
>>>          * insist sending these frames which can take time and delay
>>>          * the disconnection and possible the roaming.
>>>          */
>>>         if (tx)
>>>                 ieee80211_flush_queues(local, sdata, true);
>>
>>
>> Remove all the pending data frames from the queues to clear the way
>> for the deauth.
>> Note the drop=true
>>
>>>
>>>         /* deauthenticate/disassociate now */
>>>         if (tx || frame_buf)
>>>                 ieee80211_send_deauth_disassoc(sdata, ifmgd->bssid,
>>> stype,
>>>                                                reason, tx, frame_buf);
>>>
>>
>> Send the deauth.
>>
>>>         /* flush out frame - make sure the deauth was actually sent */
>>>         if (tx)
>>>                 ieee80211_flush_queues(local, sdata, false);
>>>
>>
>> Wait for the deauth (drop=false).
>> The question here is how ath10k implements the flush(, drop=false)
>
>
> Not well, it seems.  I don't think it has a good way to flush (drop=false)
> an individual vdev, though probably I could implement it.  And, I think that
> the packets in the mac80211 txqs might be difficult to flush.
>
> But, mac80211 gets a txstatus when the deauth is sent, so if it simply
> waited on that, it would not matter how flush is implemented.  And, it might
> try to re-send a time or two if getting the deauth through was worth the
> wait and the initial attempt(s) got a false txstatus.
>

Keep in mind that this code is also called when roaming, any
additional operations will slow down the roaming process. Not all the
drivers support tx_status, but I think that this could be implemented
internally in ath10k. In iwlwifi, we just wait until the queues get
empty without dropping the packets.
Of course, I am giving my *non authoritative* opinion :)
