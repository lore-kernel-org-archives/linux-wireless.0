Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35560 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752206AbeCYV7Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Mar 2018 17:59:16 -0400
Subject: Re: [PATCH] mac80211: Fix wlan freezes under load at rekey
To: Alexander Wetzel <alexander.wetzel@web.de>,
        johannes@sipsolutions.net
References: <20180324102921.9814-1-alexander.wetzel@web.de>
 <7bbb4246-324e-1d6d-245f-2642badb034d@candelatech.com>
 <27aca99e-a521-be4a-9fd4-51c557f9777d@web.de>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <3e433bd6-d13e-f71c-d3ff-7163c2b59226@candelatech.com> (sfid-20180325_235920_359444_165AEF92)
Date: Sun, 25 Mar 2018 14:59:09 -0700
MIME-Version: 1.0
In-Reply-To: <27aca99e-a521-be4a-9fd4-51c557f9777d@web.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/25/2018 12:45 PM, Alexander Wetzel wrote:
>
>> What will happen to drivers like ath10k that cannot do software
> encrypt/decrypt?
>>
>> ath10k can support multiple key-ids as far as I can tell,
>> so maybe it would just never hit this code?
>
> Still learning how that all fits together, but I'm sure any card using
> mac80211 will also use ieee80211_key_replace, including ath10k.
>
> We are in a race with the remote station there is no chance that we can
> switch over exactly at the same time. If we can't fall pack to software
> encryption we'll just have to drop some more packets.
>
> I'm pretty sure mac80211 will just encrypt a frame in software and
> send it to ath10 for processing once we have removed the key from the hw
> in the same way as for any other card.

I don't think ath10k can handle sending already-encrypted data packets,
but possibly it works with newer upstream firmware/driver.

Either way, as long as it does not fundamentally break something (like
a non-recoverable data stall), then maybe your patch is fine anyway
and ath10k may just drop a few extra frames.

> My expectation here would be, that the driver detects and drops the
> pre-encrypted frames it no longer has a hw key for.
>
> Unfortunately this is just an assumption, since I haven't found the code
> handling this case in ath10k. And even if true this could well cause
> some undesired warning messages.
>
> I guess we should therefore make sure we do not send out any packets in
> the critical time window.
>
> Now stopping and flushing the queues seems to be bad idea which could
> cause a real performance impact for on a busy AP with many stations and
> rekeys enabled...
> Luckily it looks like we can instead just set KEY_FLAG_TAINTED for the
> old key to make sure we stop sending packets till the rekey is done.
>
> That should cause ieee80211_tx_h_select_key to drop all packets without
> a new per-packet check and also should cover potential undesired side
> effects, isn't it?

I get lost in the weeds when trying to understand all of this, and some
previous attempts of mine to fix some of this evidently wasn't correct
enough to accept upstream:

https://www.spinics.net/lists/hostap/msg03677.html

So I really don't know enough to properly review
your patch.  Just be aware that ath10k is weird about sw-crypt, maybe make
sure your patch is tested on it to make sure it doesn't out-right break something.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
