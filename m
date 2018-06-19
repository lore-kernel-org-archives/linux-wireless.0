Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 14.mo1.mail-out.ovh.net ([178.32.97.215]:57178 "EHLO
        14.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964897AbeFSUvi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 16:51:38 -0400
Received: from player795.ha.ovh.net (unknown [10.109.122.113])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 113A4109583
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 22:12:28 +0200 (CEST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
References: <1523258757.3076.5.camel@sipsolutions.net>
 <20180515102202.2021-1-alexander.wetzel@web.de>
 <1529062392.10037.7.camel@sipsolutions.net>
 <bc327c9b-d5f4-2343-9ca5-932e9295c546@web.de>
 <1529357234.3092.57.camel@sipsolutions.net>
From: Alexander Wetzel <alexander.wetzel@web.de>
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
Message-ID: <2de1493a-5439-b9ef-6d06-3895333f01c3@web.de> (sfid-20180619_225143_057410_F52A7104)
Date: Tue, 19 Jun 2018 22:12:08 +0200
MIME-Version: 1.0
In-Reply-To: <1529357234.3092.57.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Am I understanding correctly that in the latter (outgoing) case this
> might cause unencrypted packets to be transmitted?

Yes, if we have a driver handling the keys similar to ath9k which is not
implementing drv_flush (correctly) this is a possibility.

This ties somewhat into the discussion what to handle in mac80211 and
what delegate to the drivers. mac80211 itself should drop any packets
trying to use the old outgoing key till the new key is rolled out
correctly with the patch.


>> We can now decrypt and get incoming packets while mac80211 is still on
>> the old key, but the worst (and most likely) case is now, that the
>> replay detection will drop those packets till mac80211 also switch over.
> 
> This actually is somewhat problematic, at least for TKIP it could cause
> countermeasures. Should we exclude TKIP here somehow?
> 
> I don't think we can disable countermeasures because then we could be
> attacked in this time window without starting them, and we have a really
> hard time distinguishing attacks and "fake" replays.
> 
Yes, that is a definitely a possibility. But excluding TKIP seems to be
counterproductive for my understanding: TKIP is due to the weaker cipher
more likely to have unicast rekeying enabled.
So far I was hesitant to add new per packet check for that, but I guess
we have to... I'll add that in the next version, so we can discuss that
with some code.


>> Flushing the queues is not needed for to the logic and only a workaround
>> for drivers like ath9k which can still send out packets for a key which
>> was already deleted. When the driver guarantees that after the key
>> deletion function returns to mac80211 that there will be no more packets
>> send out prepared for the old key it can be removed.
> 
> What will happen for other kinds of packets though?
> 
> For iwlwifi, for example, the key material is added into the key. It
> thus doesn't have this race in the first place, but it will definitely
> send out packets after 

That case is fine. A non-broken remote STA will not be able to decode
the packet if it has already completed the switch to the new key and not
hand over the packet to mac80211 or the equivalent.

> 
> Btw - perhaps that means we should avoid the complicated mechanisms like
> TX aggregation shutdown for keys that the driver marks as being safe?
> Clearly for iwlwifi (at least CCMP and before, not with the longer keys
> in GCMP-256) the race can't possibly happen.

Sounds like that should work and I think I'll just try it out. We'll
lose the side benefit that shutting down TX aggregation will reduce the
risk that a unpatched remote sta freezes the connection, though.
And since I started out to first patch ath9k to drop packets for an
outgoing key: That looks to become either be ugly (delayed work to
complete the key clean up after a given time) or need some API change.

Remember we'll still have to shut down RX aggregation or drop all frames
of a session running during the rekey. We are not able to tell which key
was used to encrypt the frames and which have "old" PNs we can't allow
mac80211 to process after switching to the new key. So I'm not sure that
keeping TX up and running is worth it.

That said I have another working patch which is delaying mac80211 key
deletion from my first misguided attempts to at this issue.
I could repurpose that and keep RX aggregation also up and running,
allowing us to first check if the packet would have been accepted by the
old key and only switch to the new PN counter once it's not. But that
seems to be kind of invasive and overkill.

> 
> In other drivers though, I worry that removing the key will *not* mean
> that there are no more packets transmitted with it. If you have a key
> cache in hardware then it might just be that marking the cache entry as
> invalid means the encryption will be skipped when encountering a packet
> to be transmitted with the key from a given (in the packet) key cache
> index, and then the frame goes out unprotected?
> 
Yes, that is part of the reason I had to add the call to drv_flush for
ath9k. I've experimented with an additional "retire_key" command on top
of the existing to add and delete keys but came to the conclusion that
"replace_key" would make more sense for ath9k at least.

But in order of my preference I see this options:
1) removing a key in HW must also grantee that any packets queued for
this key has either been send or will be dropped after the call returns
to mac80211. (Simply sleeping the max queue and retransmit time would be
an ugly but simple way to implement that)

2) we add a new function/call like "replace_key" for this special case.
But in that case we have to sort out how to handle drivers not
implementing it. Thy only secure way would be to disconnect if someone
tries to rekey...

3) Is what I implemented. We try what we can with the existing API and
any driver not working with that has to be considered buggy.

>> I tried to minimize the changes, but if we can consider an API change I
>> would ask the drivers to provide a new function to switch directly from
>> one key to another, without the need to delete it first. And to
>> guarantee there, that after the function returns no packets with
>> prepared for the old key can be sent out. Including retransmissions.
> 
> This would be pretty tricky for most drivers though.

I do not see any real alternative. Sleeping some reasonable time should
be acceptable here, to allow the hw to flush out queued packets. (100ms
should probably acceptable here, especially compared to complete
connection loss..
Only other idea I have is to lock down TX for all but EAPOL packets
sooner, e.g. during the key handshake. But that's more or less only a
variant of the sleep above.

> 
>> That way drivers like ath9k should be able to directly program the new
>> key and drivers for cards where this is not saving time can simply call
>> delete and add internally.
> 
> I don't think that's really all that much savings, time-wise? But it
> might address the "unprotected TX" issue I worry about above.
> 
Fully agree.

> 
> I'm just saying that
> 
> err = add_to_hardware();
> 
> add_to_debugfs();
> 
> if (err)
> 	remove_from_debugfs();
> 
> is pointless :-)

Agree, that is backwards compatibility a step too far:-)
I'll bypass that in the next patch version.
Planning to work on v3 on the weekend.

Alexander
