Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 7.mo68.mail-out.ovh.net ([46.105.63.230]:35735 "EHLO
        7.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730149AbeHAVZX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 17:25:23 -0400
Received: from player763.ha.ovh.net (unknown [10.109.159.7])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id 04056F1CA3
        for <linux-wireless@vger.kernel.org>; Wed,  1 Aug 2018 21:38:00 +0200 (CEST)
Subject: Re: [PATCH v4 3/3] mac80211: Fix PTK rekey freezes and cleartext
 leaks
To: Ben Greear <greearb@candelatech.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, s.gottschall@dd-wrt.com,
        denkenz@gmail.com
References: <20180731201030.2619-1-alexander@wetzel-home.de>
 <20180731201030.2619-4-alexander@wetzel-home.de>
 <234090b7-f260-e5c9-d933-8ce5240d5689@candelatech.com>
 <e7941f1c-4999-8cd5-75f5-2973a8ff8feb@wetzel-home.de>
 <2d0d71ef-5384-f0ff-83ca-59a73fcd9991@candelatech.com>
From: Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <9ab523b6-ca8a-5f5b-b85e-554c96ba6a97@wetzel-home.de> (sfid-20180801_213807_400923_194A2DE9)
Date: Wed, 1 Aug 2018 21:37:48 +0200
MIME-Version: 1.0
In-Reply-To: <2d0d71ef-5384-f0ff-83ca-59a73fcd9991@candelatech.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

>>
>>>> Rekeying a pairwise key with encryption offload and only keyid 0 had
>>>> multiple races. Two of them could freeze the wlan connection till
>>>> rekeyed again and the third could send out packets in clear which
>>>> should
>>>> have been encrypted.
>>>>
>>>>  1) Freeze caused by incoming packets:
>>>>     If the local STA installed the key prior to the remote STA we still
>>>>     had the old key active in the hardware while mac80211 was already
>>>>     operating on the new key.
>>>>     The card could still hand over packets decoded with the old key to
>>>>     mac80211, bumping the new PN (IV) value to an incorrect high number
>>>>     and tricking the local replay detection to later drop all packets
>>>>     really sent with the new key.
>>>>
>>>>  2) Freeze caused by outgoing packets:
>>>>     If mac80211 was providing the PN (IV) and handed over a cleartext
>>>>     packets for encryption to the hardware prior to a key change the
>>>>     driver/card could have processed the queued packets after switching
>>>>     to the new key.
>>>>     This immediately bumped the PN (IV) value on the remote STA to
>>>>     an incorrect high number, which also froze the connection.
>>>>
>>>>  3) Clear text leak:
>>>>     Removing encryption offload from the card cleared the encryption
>>>>     offload flag only after the card had removed the key. Packets
>>>> handed
>>>>     over between that were send out unencrypted.
>>>>
>>>> To prevent those issues we now stop queuing packets to the driver while
>>>> replacing the key, replace the key first in the HW and stop/block new
>>>> aggregation sessions during the rekey.
>>>
>>> I guess the replace_key logic will have to flush the tx
>>> hardware/firmware
>>> queues and any other packets currently owned by the driver before it can
>>> replace the key?
>>
>> That is one of the options, but looks like we can also avoid it with
>> some efforts. Question will be what's the best approach per driver and
>> how complex we want the code to become...
>> My current ath9k fix depends on flush - since it's simple - but it
>> definitely looks like it can be done without. (It looks like the
>> userspace updates are more urgent - assuming we can even agree on this
>> overall solution - and I've not done anything on it for weeks.)
>>
>> There are two ways to establish the boundary we need here:
>> 1) Make sure all old packets have been send/dropped or 2) continue to
>> use the old key for them.
>>
>> Iwlwifi e.g. is handing over the key with the packet to the HW and the
>> driver simply uses the key it was told per packet. Implementing
>> replace_key is trivial, we can just call the existing set_key function
>> for deletion and addition from replace_key if we want. (I've tested that
>> quite extensive and it works flawless with my dvm card.)
>>
>> Drivers uploading the keys to the HW and then just tell the HW to use
>> key ID X for encryption - like ath9, the only other driver I drilled
>> deeper so far - are more tricky. But replace_key is still allowed to
>> change the HW key ID for the new key if desired by the driver.
>>
>> The driver can therefore only "deprecate" a key but keep it programmed
>> in HW, assign and program a new key and return to mac80211.
>> Any queued packets will still lookup and use the old key while new
>> packets will tell the HW to use the new one. Problem solved, if we
>> ignore the headache when and how to really free the old key id and
>> remove it from the HW. In the worst case we wait the max time any packet
>> can be stuck in the queue. Of course this may cause other issues in at
>> least some special cases. The one I can think of would be:
>>
>> A busy AP with many clients connected and rekey enabled gets rebooted
>> during work hours. All clients reconnect at basically the same time.
>> Thus all of those will also rekey at nearly the same time and therefore
>> all need two PTK key slots in the HW for some seconds, potentially
>> exceeding the available ones. So you may get some strange effects after
>> the rekey interval expired, long after the reboot...
> 
> The ath10k firmware already sort of handles stale keys as far as I can
> tell,
> and early on in my testing, which often has this issue of all
> stations rekeying at once, I was running out of firmware key objects.  I
> increased the multiplier in the driver and made the firmware smarter about
> recycling key objects, and that fixed the problem for me.
> 
> So, maybe this would just work with ath10k, but if there were any issues,
> probably you'd have to fall back to flushing everything.  And, that might
> be a way to work somewhat generically with drivers that don't have special
> replace-key logic?

The V2 version of the patch called ieee80211_flush_queues
unconditionally as kind of safety net to increase the odds of the driver
to not send out a wrong packet. Argument against that was, that not all
drivers are implementing flush and even when they are we have no
guarantee that the packet was really flushed from the card and not only
the driver. The current patch is now expecting the userspace to never
rekey a connection when the driver is not supporting. If it does anyhow
we are back in uncharted area, only slightly better than current stable
kernels. Of course we can handle that like in the V2 version of the
patch. I kind of like the idea...Is that something I shall add in the
next version?

> 
> Someone could also tweak supplicant to somewhat randomize the rekey timers,
> but that would take a while to propagate to all of the station devices out
> there.

It may not even be a realistic problem. Just trying to think of worst
cases:-) The reconnections will for sure be spread a few ms, at least.
What is the longest time we have to keep the old key programmed in HW?

Alexander
