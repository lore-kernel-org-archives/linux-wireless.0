Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 8.mo173.mail-out.ovh.net ([46.105.46.122]:33664 "EHLO
        8.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936774AbeFRVTZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 17:19:25 -0400
Received: from player694.ha.ovh.net (unknown [10.109.105.96])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id BF4EBC572A
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2018 23:03:51 +0200 (CEST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
References: <1523258757.3076.5.camel@sipsolutions.net>
 <20180515102202.2021-1-alexander.wetzel@web.de>
 <1529062392.10037.7.camel@sipsolutions.net>
From: Alexander Wetzel <alexander.wetzel@web.de>
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
Message-ID: <bc327c9b-d5f4-2343-9ca5-932e9295c546@web.de> (sfid-20180618_231930_608926_3B162BBA)
Date: Mon, 18 Jun 2018 23:03:30 +0200
MIME-Version: 1.0
In-Reply-To: <1529062392.10037.7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, 2018-05-15 at 12:22 +0200, Alexander Wetzel wrote:
>> Rekeying a pairwise key with encryption offload and only keyid 0 has two
>> potential races which can freeze the wlan conection till rekeyed again:
>>
>>  1) For incomming packets:
>>     If the local STA installs the key prior to the remote STA we still
>>     have the old key active in the hardware for a short time after
>>     mac80211 switched to the new key.
>>     The card can still hand over packets decoded with the old key to
>>     mac80211, bumping the new PN (IV) value to an incorrect high number and
>>     tricking the local replay detection to drop all packets really sent
>>     with the new key.
>>
>>  2) For outgoing packets:
>>     If mac80211 is providing the PN (IV) and hands over the cleartext
>>     packets for encryption to the hardware immediately prior to a key
>>     change the driver/card may process the queued packets after
>>     switching to the new key.
>>     This will immediatelly bump the PN (IV) value on the remote STA to
>>     an incorrect high number, also freezing the connection.
>>
>> Both issues can be prevented by first replacing the key in the HW and
>> makeing sure no aggregation sessions are running during the rekey.
> 
> Getting back to this, am I understanding correctly that in the latter
> (outgoing) case this would cause 

I don't get the point here...Shall I flesh out the description of the
exiting races in the code a bit more?

> 
> Also, I think you should probably describe better why the aggregation
> session stuff is needed. I'm already thinking there times about it again
> ...
I'll rework the description and will go into more details.
Here a first quick draft what I plan amend to the commit message. But
this got kind of long:
...
Both issues can be prevented by first replacing the key in the HW and
making sure no aggregation sessions are running during the rekey.

The "core" of the fix is to change the old unicast key install sequence
 - atomic switch over to the new key in mac80211
 - remove the old key in the HW and mac80211
 - add new key in the hw
to
 - mark the old key as tainted to drop TX packets trying to use it
 - remove the old key in the HW and mac80211
 - add new key to the HW
 - atomic switch over to the new key in mac80211

Since the new key is not marked as tainted the last step will also
enable TX again.

With the new procedure the HW will be unable to decode packets still
encrypted with the old key prior to switching to the new key in
mac80211. Locking down TX during the rekey makes sure that there are no
outgoing packets mac80211 prepared for the old key the hw can encrypt
with the new key.
We can now decrypt and get incoming packets while mac80211 is still on
the old key, but the worst (and most likely) case is now, that the
replay detection will drop those packets till mac80211 also switch over.

Instead of checking PN from old key packets against the new key (and
bump the PN for the new key, killing our connection) we are now checking
the PN from new key packets against the old key (and drop a few packets
during rekey only).

When using TX aggregation we get an additional race which can poison the
remote station:
When a TX aggregation session is running during the key replacement it's
possible that one of the frames send out prior of the TX lock down (old
key) got lost and will be repeated after the TX lock down is lifted,
using the old skb prepared for the old key with the new installed key in
the hardware. This would bump the PN counter of our peer to an incorrect
value and breaking the RX for the remote station.
Stopping all running aggregation sessions and declining any new ones
till we have switched over to the new key side steps that problem.

/end commit draft

It would be possible to keep the aggregation sessions running, but that
seems to need some quite invasive changes and checks.

> 
>> +               ieee80211_sta_tear_down_BA_sessions(
>> +                   sta, AGG_STOP_LOCAL_REQUEST);
> 
> minor indentation issue here
I'll go for a 81 char long single line here.

> 
>> +       ieee80211_flush_queues(key->local, key->sdata, false);
>> +       ieee80211_key_disable_hw_accel(key);
> 
> I'm not sure all drivers implement drv_flush() [correctly], what happens
> if they don't? I guess some packets end up being transmitted in clear
> text or a dummy key, unless the hardware/firmware knows about this and
> drops them?
Flushing the queues is not needed for to the logic and only a workaround
for drivers like ath9k which can still send out packets for a key which
was already deleted. When the driver guarantees that after the key
deletion function returns to mac80211 that there will be no more packets
send out prepared for the old key it can be removed.
The driver could simply wait for whatever the may queue time may be or
detect and drop these packets. (In fact it can even send out the packet
again, it just must make sure to still use the old and official deleted
key. May be handy for drivers like iwlwifi.)

> 
> Perhaps that means we should make this whole thing opt-in, and leave it
> up to driver authors to first validate that they handle the flushing
> correctly?

I tried to minimize the changes, but if we can consider an API change I
would ask the drivers to provide a new function to switch directly from
one key to another, without the need to delete it first. And to
guarantee there, that after the function returns no packets with
prepared for the old key can be sent out. Including retransmissions.

That way drivers like ath9k should be able to directly program the new
key and drivers for cards where this is not saving time can simply call
delete and add internally.

As fallback I would still want to use the current code with a flush,
well knowing that not all drivers implement it and only remove it once
all drivers have switched to the new API for rekeys.


> 
> 
> Regarding the code: the whole dance you do with ieee80211_key_link() and
> ieee80211_key_replace() seems to be a little pointless because you still
> add the key to debugfs and then free it, on errors that is?

I hope the more verbose description above explains that part.
The intend of the dance is to finalize the switch to the new key in the
hardware prior to doing it in mac80211. It's probably possible to bypass
more of the code, but I did not touch the logic besides what I needed,
understand or verified to be harmless.



Alexander
