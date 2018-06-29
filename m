Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 7.mo1.mail-out.ovh.net ([87.98.158.110]:53307 "EHLO
        7.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752549AbeF2Vbn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 17:31:43 -0400
Received: from player737.ha.ovh.net (unknown [10.109.122.31])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 3E1A010C205
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2018 23:15:20 +0200 (CEST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
References: <1523258757.3076.5.camel@sipsolutions.net>
 <20180515102202.2021-1-alexander.wetzel@web.de>
 <1529062392.10037.7.camel@sipsolutions.net>
 <bc327c9b-d5f4-2343-9ca5-932e9295c546@web.de>
 <1529357234.3092.57.camel@sipsolutions.net>
 <2de1493a-5439-b9ef-6d06-3895333f01c3@web.de>
 <1530267147.3481.78.camel@sipsolutions.net>
From: Alexander Wetzel <alexander.wetzel@web.de>
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
Message-ID: <bb4d75d3-7f90-1b58-9525-3f5a54cd952e@web.de> (sfid-20180629_233148_527175_982ACEFA)
Date: Fri, 29 Jun 2018 23:14:56 +0200
MIME-Version: 1.0
In-Reply-To: <1530267147.3481.78.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

>>> Am I understanding correctly that in the latter (outgoing) case this
>>> might cause unencrypted packets to be transmitted?
>>
>> Yes, if we have a driver handling the keys similar to ath9k which is not
>> implementing drv_flush (correctly) this is a possibility.
> 
> Sadly, I think many drivers fall into this category, so I'm not sure we
> should "fix the bug" for them at the expense of a potential security
> risk? So maybe we need to have an opt-in flag for drivers.

Makes sense.

> 
>> This ties somewhat into the discussion what to handle in mac80211 and
>> what delegate to the drivers. mac80211 itself should drop any packets
>> trying to use the old outgoing key till the new key is rolled out
>> correctly with the patch.
> 
> Yeah, but it can't do it for packets already queued to the
> driver/hardware, and it can't know how the hardware behaves wrt.
> encryption: old-iwlwifi style (key material in descriptor) vs. ath9k
> style (key material in on-chip table).
> 
>>>> We can now decrypt and get incoming packets while mac80211 is still on
>>>> the old key, but the worst (and most likely) case is now, that the
>>>> replay detection will drop those packets till mac80211 also switch over.
>>>
>>> This actually is somewhat problematic, at least for TKIP it could cause
>>> countermeasures. Should we exclude TKIP here somehow?
>>>
>>> I don't think we can disable countermeasures because then we could be
>>> attacked in this time window without starting them, and we have a really
>>> hard time distinguishing attacks and "fake" replays.
>>>
>>
>> Yes, that is a definitely a possibility. But excluding TKIP seems to be
>> counterproductive for my understanding: TKIP is due to the weaker cipher
>> more likely to have unicast rekeying enabled.
>> So far I was hesitant to add new per packet check for that, but I guess
>> we have to... I'll add that in the next version, so we can discuss that
>> with some code.
> 
> Ok.

I was wrong here, this is not an issue. Tkip is simply dropping frames
when the IV is too small and never verifies the MIC. And since only MIC
errors can trigger counter measures we are fine as it is...

Nevertheless I also gave TKIP a quick test. While it's really slow
(2.6MB/s instead of 6.5MB/s due to no aggregation) it worked fine with
the patch and my sole client downloading. (Again ath9k as AP and iwlwifi
for STA)

Quick reference to the code:
ieee80211_rx_h_decrypt will return "RX_DROP_UNUSABLE" when IV is too
small and we bypass ieee80211_rx_h_michael_mic_verify in
ieee80211_rx_handlers_result due to the packet drop.

> 
>>> Btw - perhaps that means we should avoid the complicated mechanisms like
>>> TX aggregation shutdown for keys that the driver marks as being safe?
>>> Clearly for iwlwifi (at least CCMP and before, not with the longer keys
>>> in GCMP-256) the race can't possibly happen.
>>
>> Sounds like that should work and I think I'll just try it out. We'll
>> lose the side benefit that shutting down TX aggregation will reduce the
>> risk that a unpatched remote sta freezes the connection, though.
> 
> Fair point.
> 
>> And since I started out to first patch ath9k to drop packets for an
>> outgoing key: That looks to become either be ugly (delayed work to
>> complete the key clean up after a given time) or need some API change.
> 
> Ok.
> 
>> Remember we'll still have to shut down RX aggregation or drop all frames
>> of a session running during the rekey. We are not able to tell which key
>> was used to encrypt the frames and which have "old" PNs we can't allow
>> mac80211 to process after switching to the new key. So I'm not sure that
>> keeping TX up and running is worth it.
> 
> Yeah, good point, and TX is less interesting because we control when/how
> it's set up.
> 

I'll keep the current aggregation tear down in the patch for now, then.
The idea with testing keeping TX aggregation up and running would
require an AP not stopping TX aggregation.


>> That said I have another working patch which is delaying mac80211 key
>> deletion from my first misguided attempts to at this issue.
>> I could repurpose that and keep RX aggregation also up and running,
>> allowing us to first check if the packet would have been accepted by the
>> old key and only switch to the new PN counter once it's not. But that
>> seems to be kind of invasive and overkill.
> 
> Yeah, let's not go there for now. Also if HW crypto is involved it
> usually won't work unless you (a) get the packet and (b) re-encrypt the
> packet with the wrong key, and then decrypt it with the correct key ...

I don't get which case this is... But let's not go into that till we
have to:-)

> 
>> Yes, that is part of the reason I had to add the call to drv_flush for
>> ath9k. I've experimented with an additional "retire_key" command on top
>> of the existing to add and delete keys but came to the conclusion that
>> "replace_key" would make more sense for ath9k at least.
> 
> Ok.
> 
>> But in order of my preference I see this options:
>> 1) removing a key in HW must also grantee that any packets queued for
>> this key has either been send or will be dropped after the call returns
>> to mac80211. (Simply sleeping the max queue and retransmit time would be
>> an ugly but simple way to implement that)
> 
> This works but we have to consider a lot of drivers. I guess we're back
> to some form of "opt-in" scheme then?
> 
>> 2) we add a new function/call like "replace_key" for this special case.
>> But in that case we have to sort out how to handle drivers not
>> implementing it. Thy only secure way would be to disconnect if someone
>> tries to rekey...
> 
> Maybe that's not so bad.

Agree. After all this is what most of my windows drivers were doing
accidentally.


>> 3) Is what I implemented. We try what we can with the existing API and
>> any driver not working with that has to be considered buggy.
> 
> I don't think we can really do this though. We break - in a potentially
> security-relevant way - the older drivers. We can't just say that's
> driver bugs, IMHO.

We would not break it, only not fix it for all drivers. The current code
is already leaking cleartext packets for at least ath9k and most likely
many others when the PTK is rekeyed. The patch would improve that, but
due to more working rekeys it could leak more packets in specific
scenarios, I assume...


>>>> I tried to minimize the changes, but if we can consider an API change I
>>>> would ask the drivers to provide a new function to switch directly from
>>>> one key to another, without the need to delete it first. And to
>>>> guarantee there, that after the function returns no packets with
>>>> prepared for the old key can be sent out. Including retransmissions.
>>>
>>> This would be pretty tricky for most drivers though.
>>
>> I do not see any real alternative. Sleeping some reasonable time should
>> be acceptable here, to allow the hw to flush out queued packets. (100ms
>> should probably acceptable here, especially compared to complete
>> connection loss..
> 
> You have no guarantee that even 100ms is enough to get all packets out.
> They could be sitting on a BK queue and waiting for all BE/VI traffic in
> the vicinity ... basically forever.
> 
>> Only other idea I have is to lock down TX for all but EAPOL packets
>> sooner, e.g. during the key handshake. But that's more or less only a
>> variant of the sleep above.
> 
> Yeah, doesn't really fully address this issue anyway, since EAPOL are on
> VO and others might get way more delayed on HW queues due to contention.
> 
> I think our best bet is some form of opt-in scheme. Perhaps (2), which
> drivers can implement also to get like the "best" behaviour. They could
> also implement there the flushing if they can, for example. Others would
> get a disconnect, but they probably effectively do already?
> 

I'll give (2) a shot, then.

> Obviously if SW crypto is used none of this is a concern, so that's
> another factor to take into account in this decision logic of whether to
> disconnect or not?

I did not check the SW crypto code but I'm pretty sure that indeed works
with the current code.
I assume the packets will only be decrypted after an RX aggregation is
completed. That would filter out all packets send with the old key,
since they simply can't be decrypted any more.

Shall we bypass stopping aggregation sessions if we are on SW crypto?
We'll again lose the benefit that we prevent a broken remote STA to try
a TX Agg. (I tend to still stop them, but do not have a real opinion
here...)

> 
> IOW - I'd rather get bugs that we now force a disconnect (if anyone even
> notices), rather than potentially having a bug that causes unencrypted
> packets to be sent.

Any suggestions how to trick hostap/wpa_supplicant into dropping the
connection? For me it looks like we can just report an error on key
install and expect the wpa_supplicant/hostapd to handle that.

Will try that for the next version of the patch, with the other
discussed improvements: If driver is not signalling "PTK0 rekey support"
we'll simply not accept key installs when we already have a old PTK key
for the connection.

Alexander
