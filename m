Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34781 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbbGMIFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2015 04:05:02 -0400
Received: by wgkl9 with SMTP id l9so19232462wgk.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2015 01:05:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559FC4F4.5020008@candelatech.com>
References: <559F0BEF.4000808@candelatech.com>
	<CA+BoTQm-e__mFFPBpr+Lphe3BGs+m3EaLZkn1DE2nz8EkKHT6Q@mail.gmail.com>
	<559FC4F4.5020008@candelatech.com>
Date: Mon, 13 Jul 2015 10:05:00 +0200
Message-ID: <CA+BoTQmGwDkJJuGxZOq2id=7=+4SbasYV7stHA-aRAS9-N=BJg@mail.gmail.com> (sfid-20150713_100510_004206_D84AEE27)
Subject: Re: How is AP supposed to handle power-save packets from peer?
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 July 2015 at 15:13, Ben Greear <greearb@candelatech.com> wrote:
> On 07/09/2015 10:20 PM, Michal Kazior wrote:
>>
>> On 10 July 2015 at 02:03, Ben Greear <greearb@candelatech.com> wrote:
>>>
>>> Suppose one is doing heavy download (AP -> peer traffic), and there are
>>> lots of frames in the
>>> NIC's tx buffers (ath10k firmware, in this case).
>>>
>>> Then, peer sends a power-save pkt telling AP it is going off-channel or
>>> otherwise
>>> will be unavailable.
>>
>>
>> I assume you're exploring the worst-case scenario when all tx buffers
>> are consumed and peer goes to sleep, am I correct?
>
>
> Even if not absolutely all...seems like we should flush them quick and
> let the OS do the buffering by having it re-send when PS is disabled
> again.  A few stations in PS could quickly eat all firmware tx buffers, not
> even
> including the wmi-mgt-frame issue.  I've fixed the tx-status in my CT
> firmware now...could possibly
> add another tx-status (like tx-dropped-PS) to better deal with this?  I
> think
> I may try to make my firmware able to transmit mgt frames over htt as well,
> which should help with some of this as well.

Hmm.. I guess you'd need to either re-implement per-sta buffering in
ath10k or make ath10k use mac80211's implementation for AP PS. Either
way I think it might be pretty tricky. The latter will need NullFunc
frames and PS-Polls to be reported to mac80211. I'm not sure if these
get delivered without monitor vdev. Even if they are it would work
with QCA988X and 10.x/636 only. QCA617X4 hw3.x+ has Full Rx offload
and is incapable of acting as a monitor effectively (it doesn't report
tons of frame types). And there's QCA99X0 on the horizon which I don't
know much about yet.

I'm not sure but flushed frames could be reported as "discard". If
that were the case we could probably use that instead of a custom
tx-dropped-ps. "discard" is rather rare and happens in some corner
cases from what I've seen so far (missing peer entries, bogus frames,
etc) only.

It'd be great if all ath10k hw/fw revisions can benefit.


>
> In current testing, it actually seems like ath10k firmware (or maybe higher
> up) is completely
> ignoring the PS bit..but I have a lot more debugging to do before I'm
> certain of this.  Possibly peer is being dodgy.

Can you elaborate more, please? What do you mean 'ignores PS bit'?
Wouldn't that make a total mess with traffic?


>>> What is the appropriate behaviour from the AP?  Can the firmware just
>>> drop all those tx frames to
>>> make room to handle other stations?  Maybe report ACK failure and hope
>>> the upper level stacks
>>> retransmit as appropriate?
>>>
>>> Or, is the host supposed to flush the peer's packets to clear out the
>>> frames?
>>>
>>> Or, is firmware somehow supposed to keep all the frames for when the peer
>>> comes back?
>>
>>
>> Firmware will keep frames buffered until station wakes up again.
>>
>> There's a timeout to detect stale stations as far as I'm aware and the
>> default value is 10s (sounds familiar? this goes back to mgmt tx/
>> credit starvation). This makes to handle stations that go to sleep and
>> then out of range/away. AP doesn't need to keep frames buffered till
>> the end of time. Once the timeout is hit firmware stops caring about
>> station's last seen sleep state transition and marks it as awake and
>> just sends frames to it (with tons of retransmits if it's really not
>> there anymore since there'd be noone to ACK) - in which case you'll
>> get no_ack=1 in tx status.
>
>
> We do see lots of no-ack, had to tell hostapd to ignore noack failures
> or connection to peer was lost.  But, peer should not have been gone for
> 10+ seconds in this case.

I think I've seen some differences between few firmware revisions over
time (I didn't track it though). You might want to inspect Tx
descriptors carefully in fw and compare them to what is reported via
HTT Tx.


>
> That seems like a horrible waste of time retransmitting packets, by the way.

I'm guessing the above covers some sort of a rare corner case..


>
>>
>> See: WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS
>>
>> Ideally there should be little to no buffer bloat but it's difficult
>> to do that considering aggregation sizes of 11ac..
>
>
> Ath10k will not aggregate more than about 30 frames as far as I can tell,
> (maybe 3 times that if amsdu is happening as well?).  Standard driver is
> using
> more than 1000 buffers, and stock firmware won't even let you configure this
> to be smaller than about 1024 (though maybe driver could still use less
> and firmware wouldn't care, not sure).

I think it'd be more accurate to say 10.1 (since that's what you use
mainly, right?) doesn't aggregate more than 30 frames. There's 10.2,
10.2.4, 636, and then there's qca61x4 with another firmware branch.
ath10k doesn't really have much to tell in aggregation.

11ac aggregation can be as big as 1MByte as far as I can remember.
This means it's inherently tricky to avoid buffer bloat and keep max
throughput with wifi - that's what I originally meant.


> But fixing buffer bloat in ath10k is not my primary concern at the moment.

Sure. Nonetheless your problem *is* related to buffer bloat.


Michał
