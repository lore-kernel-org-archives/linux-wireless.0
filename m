Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43649 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbbGJNNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 09:13:25 -0400
Message-ID: <559FC4F4.5020008@candelatech.com> (sfid-20150710_151329_159776_DBC25231)
Date: Fri, 10 Jul 2015 06:13:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: How is AP supposed to handle power-save packets from peer?
References: <559F0BEF.4000808@candelatech.com> <CA+BoTQm-e__mFFPBpr+Lphe3BGs+m3EaLZkn1DE2nz8EkKHT6Q@mail.gmail.com>
In-Reply-To: <CA+BoTQm-e__mFFPBpr+Lphe3BGs+m3EaLZkn1DE2nz8EkKHT6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2015 10:20 PM, Michal Kazior wrote:
> On 10 July 2015 at 02:03, Ben Greear <greearb@candelatech.com> wrote:
>> Suppose one is doing heavy download (AP -> peer traffic), and there are lots of frames in the
>> NIC's tx buffers (ath10k firmware, in this case).
>>
>> Then, peer sends a power-save pkt telling AP it is going off-channel or otherwise
>> will be unavailable.
>
> I assume you're exploring the worst-case scenario when all tx buffers
> are consumed and peer goes to sleep, am I correct?

Even if not absolutely all...seems like we should flush them quick and
let the OS do the buffering by having it re-send when PS is disabled
again.  A few stations in PS could quickly eat all firmware tx buffers, not even
including the wmi-mgt-frame issue.  I've fixed the tx-status in my CT firmware now...could possibly
add another tx-status (like tx-dropped-PS) to better deal with this?  I think
I may try to make my firmware able to transmit mgt frames over htt as well,
which should help with some of this as well.

In current testing, it actually seems like ath10k firmware (or maybe higher up) is completely
ignoring the PS bit..but I have a lot more debugging to do before I'm
certain of this.  Possibly peer is being dodgy.


>> What is the appropriate behaviour from the AP?  Can the firmware just drop all those tx frames to
>> make room to handle other stations?  Maybe report ACK failure and hope the upper level stacks
>> retransmit as appropriate?
>>
>> Or, is the host supposed to flush the peer's packets to clear out the frames?
>>
>> Or, is firmware somehow supposed to keep all the frames for when the peer comes back?
>
> Firmware will keep frames buffered until station wakes up again.
>
> There's a timeout to detect stale stations as far as I'm aware and the
> default value is 10s (sounds familiar? this goes back to mgmt tx/
> credit starvation). This makes to handle stations that go to sleep and
> then out of range/away. AP doesn't need to keep frames buffered till
> the end of time. Once the timeout is hit firmware stops caring about
> station's last seen sleep state transition and marks it as awake and
> just sends frames to it (with tons of retransmits if it's really not
> there anymore since there'd be noone to ACK) - in which case you'll
> get no_ack=1 in tx status.

We do see lots of no-ack, had to tell hostapd to ignore noack failures
or connection to peer was lost.  But, peer should not have been gone for
10+ seconds in this case.

That seems like a horrible waste of time retransmitting packets, by the way.

>
> See: WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS
>
> Ideally there should be little to no buffer bloat but it's difficult
> to do that considering aggregation sizes of 11ac..

Ath10k will not aggregate more than about 30 frames as far as I can tell,
(maybe 3 times that if amsdu is happening as well?).  Standard driver is using
more than 1000 buffers, and stock firmware won't even let you configure this
to be smaller than about 1024 (though maybe driver could still use less
and firmware wouldn't care, not sure).
But fixing buffer bloat in ath10k is not my primary concern at the moment.

Thanks,
Ben

>
>
> Michał
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

