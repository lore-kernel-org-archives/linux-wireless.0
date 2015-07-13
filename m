Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46821 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbbGMQhx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2015 12:37:53 -0400
Message-ID: <55A3E960.9060808@candelatech.com> (sfid-20150713_183756_739020_83A43B20)
Date: Mon, 13 Jul 2015 09:37:52 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: How is AP supposed to handle power-save packets from peer?
References: <559F0BEF.4000808@candelatech.com> <CA+BoTQm-e__mFFPBpr+Lphe3BGs+m3EaLZkn1DE2nz8EkKHT6Q@mail.gmail.com> <559FC4F4.5020008@candelatech.com> <CA+BoTQmGwDkJJuGxZOq2id=7=+4SbasYV7stHA-aRAS9-N=BJg@mail.gmail.com>
In-Reply-To: <CA+BoTQmGwDkJJuGxZOq2id=7=+4SbasYV7stHA-aRAS9-N=BJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2015 01:05 AM, Michal Kazior wrote:
> On 10 July 2015 at 15:13, Ben Greear <greearb@candelatech.com> wrote:
>> On 07/09/2015 10:20 PM, Michal Kazior wrote:
>>>
>>> On 10 July 2015 at 02:03, Ben Greear <greearb@candelatech.com> wrote:
>>>>
>>>> Suppose one is doing heavy download (AP -> peer traffic), and there are
>>>> lots of frames in the
>>>> NIC's tx buffers (ath10k firmware, in this case).
>>>>
>>>> Then, peer sends a power-save pkt telling AP it is going off-channel or
>>>> otherwise
>>>> will be unavailable.
>>>
>>>
>>> I assume you're exploring the worst-case scenario when all tx buffers
>>> are consumed and peer goes to sleep, am I correct?
>>
>>
>> Even if not absolutely all...seems like we should flush them quick and
>> let the OS do the buffering by having it re-send when PS is disabled
>> again.  A few stations in PS could quickly eat all firmware tx buffers, not
>> even
>> including the wmi-mgt-frame issue.  I've fixed the tx-status in my CT
>> firmware now...could possibly
>> add another tx-status (like tx-dropped-PS) to better deal with this?  I
>> think
>> I may try to make my firmware able to transmit mgt frames over htt as well,
>> which should help with some of this as well.
> 
> Hmm.. I guess you'd need to either re-implement per-sta buffering in
> ath10k or make ath10k use mac80211's implementation for AP PS. Either
> way I think it might be pretty tricky. The latter will need NullFunc
> frames and PS-Polls to be reported to mac80211. I'm not sure if these
> get delivered without monitor vdev. Even if they are it would work
> with QCA988X and 10.x/636 only. QCA617X4 hw3.x+ has Full Rx offload
> and is incapable of acting as a monitor effectively (it doesn't report
> tons of frame types). And there's QCA99X0 on the horizon which I don't
> know much about yet.

I suspect this sort of thing will require at least some firmware changes,
so I am not planning to go out of my way to hack around upstream firmware
limitations if I can fix CT firmware do to it better.

I think it would be easy enough to modify firmware to make it pass
some extra frames up the stack.

At least as rough outline, does this seem like it could work:

1)  Pass NullFunc & PS Poll frames up to host

2)  Rip out all of the power-save support in the firmware.

3)  Implement a 'flush-peer-ps' API that lets host tell firmware
to discard any pending frames for a particular peer, and have firmware
use a new tx status 'TX_DISCARD_PS'.  I don't think we can reuse
the plain 'DISCARD' tx-status since it *is* used for at least a few
things, and so host would have a hard time knowing how to handle
that rx code properly.

4)  Somehow let mac80211 stack know that the TX_DISCARD_PS frames are
to be retried w/out decrementing the retry counter once PS logic dictates
frames can be sent again.

> 
> I'm not sure but flushed frames could be reported as "discard". If
> that were the case we could probably use that instead of a custom
> tx-dropped-ps. "discard" is rather rare and happens in some corner
> cases from what I've seen so far (missing peer entries, bogus frames,
> etc) only.
> 
> It'd be great if all ath10k hw/fw revisions can benefit.

Maybe if I can implement it in CT firmware, someone upstream
will be willing to accept similar firmware changes into the
official firmware.  Or if not, the alternative firmware will
at least give users more options.

>> In current testing, it actually seems like ath10k firmware (or maybe higher
>> up) is completely
>> ignoring the PS bit..but I have a lot more debugging to do before I'm
>> certain of this.  Possibly peer is being dodgy.
> 
> Can you elaborate more, please? What do you mean 'ignores PS bit'?
> Wouldn't that make a total mess with traffic?

Further debugging showed that the peer went into PS and stayed that
way for about 4 seconds.  Then, ath10k reported lots of tx-failures
(and a sniff showed lots of retried frames on the air at that time).  I did not see
that special 'peer-ps-out-of-sync' message from the firmware, so something
else was causing those frames to start again, it seems.

I decided to spend some effort on mgt-over-htt first, then will look into
this issue more closely.

>>>> What is the appropriate behaviour from the AP?  Can the firmware just
>>>> drop all those tx frames to
>>>> make room to handle other stations?  Maybe report ACK failure and hope
>>>> the upper level stacks
>>>> retransmit as appropriate?
>>>>
>>>> Or, is the host supposed to flush the peer's packets to clear out the
>>>> frames?
>>>>
>>>> Or, is firmware somehow supposed to keep all the frames for when the peer
>>>> comes back?
>>>
>>>
>>> Firmware will keep frames buffered until station wakes up again.
>>>
>>> There's a timeout to detect stale stations as far as I'm aware and the
>>> default value is 10s (sounds familiar? this goes back to mgmt tx/
>>> credit starvation). This makes to handle stations that go to sleep and
>>> then out of range/away. AP doesn't need to keep frames buffered till
>>> the end of time. Once the timeout is hit firmware stops caring about
>>> station's last seen sleep state transition and marks it as awake and
>>> just sends frames to it (with tons of retransmits if it's really not
>>> there anymore since there'd be noone to ACK) - in which case you'll
>>> get no_ack=1 in tx status.
>>
>>
>> We do see lots of no-ack, had to tell hostapd to ignore noack failures
>> or connection to peer was lost.  But, peer should not have been gone for
>> 10+ seconds in this case.
> 
> I think I've seen some differences between few firmware revisions over
> time (I didn't track it though). You might want to inspect Tx
> descriptors carefully in fw and compare them to what is reported via
> HTT Tx.

I spent some effort auditing the tx-status in CT firmware, so I think
it is proper now.  I could be wrong, however...

>>
>> That seems like a horrible waste of time retransmitting packets, by the way.
> 
> I'm guessing the above covers some sort of a rare corner case..

Yes, I think so.  I'll hunt it down eventually if all goes according
to plan.

>>> See: WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS
>>>
>>> Ideally there should be little to no buffer bloat but it's difficult
>>> to do that considering aggregation sizes of 11ac..
>>
>>
>> Ath10k will not aggregate more than about 30 frames as far as I can tell,
>> (maybe 3 times that if amsdu is happening as well?).  Standard driver is
>> using
>> more than 1000 buffers, and stock firmware won't even let you configure this
>> to be smaller than about 1024 (though maybe driver could still use less
>> and firmware wouldn't care, not sure).
> 
> I think it'd be more accurate to say 10.1 (since that's what you use
> mainly, right?) doesn't aggregate more than 30 frames. There's 10.2,
> 10.2.4, 636, and then there's qca61x4 with another firmware branch.
> ath10k doesn't really have much to tell in aggregation.
> 
> 11ac aggregation can be as big as 1MByte as far as I can remember.
> This means it's inherently tricky to avoid buffer bloat and keep max
> throughput with wifi - that's what I originally meant.

Even if it *can* be larger, maybe there is no reason to actually do this
in practice?  For instance, if peers going to sleep and going out of range
(or crapping up their own PS state due to bugs or malicious intent) can effectively live-lock
an AP for everyone else, that seems like a much more serious bug
than slightly slower performance with the limited cases where you can actually
use very large aggregations.

For a common case where you have many stations connected to an AP, doing work
to give each station a modest sized aggregation opportunity is going to do way
more good than making one station very fast, I think.

Thanks for all the comments and thoughts!

Ben


>> But fixing buffer bloat in ath10k is not my primary concern at the moment.
> 
> Sure. Nonetheless your problem *is* related to buffer bloat.
> 
> 
> Michał
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

