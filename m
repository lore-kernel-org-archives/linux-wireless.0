Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:20552 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbYKXQvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 11:51:47 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1095843nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 08:51:45 -0800 (PST)
Message-ID: <f76a32050811240851g4c0c895bmca23fb6771aac484@mail.gmail.com> (sfid-20081124_175156_279684_25ADD868)
Date: Mon, 24 Nov 2008 17:51:45 +0100
From: "Stefan Steuerwald" <salsasepp@googlemail.com>
To: "Christian Lamparter" <chunkeey@web.de>
Subject: Re: p54: AP mode: no data frame despite traffic indication set in TIM
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200811241619.28606.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f76a32050811210612i13ee251ewd6c1cab616a62529@mail.gmail.com>
	 <1227533874.2927.2.camel@johannes.berg>
	 <200811241619.28606.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks again Christian and Johannes,

from a first quick check
- set-and-clear.diff doesn't seem to change anything
- both patches together freeze my system

I don't have a serial console on this embedded thing, so I don't know
its death poem yet. Let me set up my debug environment properly and
report back to you.

Stefan.


2008/11/24 Christian Lamparter <chunkeey@web.de>:
> On Monday 24 November 2008 14:37:54 Johannes Berg wrote:
>> On Fri, 2008-11-21 at 15:12 +0100, Stefan Steuerwald wrote:
>>
>> > - frame 7: http request
>> > - frame 13: iPod goes to sleep
>> > - frame 23: AP beacon indicates traffic for iPod (AID 1 in TIM)
>>
>> in 24 too, the ipod probably didn't see the beacon in frame 23 even
>> though 23 was a dtim beacon (which is a bit odd, but maybe the ipod
>> doesn't care about mcast at this point)
>>
>> > - frame 25: iPod wakes up
>>
>> 26: ack from the AP
>>
>> > - in between: MISSING DATA ???
>> > - frame 27: AP beacon with no traffic indicated ???
>> > - frame 29: iPod goes to sleep again
>> > - subsequent frames: repetitions of this, until the TCP connection is closed
>> >
>> > My understanding is that the AP would not indicate any traffic without
>> > actually having some ready to send? Wrong assumption?
>>
>> Indeed. Christian, is it possible that the p54 device is actually
>> filtering these frames? I'm pretty sure mac80211 behaves correctly, and
>> it unsetting the TIM bit means that it must no longer have traffic
>> buffered.
> As far as I know it works like this:
> If a frame with a the PS-Bit in the FC set is received, the firmware
> will mark the source mac / aid as "sleeping". And every frame from
> this moment on for this device will be buffered.
>
> To remove the "mark" again, the driver has to call p54_sta_unlock.
> And the firmware will send out all buffered frames.
> Or if we only need for one frame (e.g: probe resp) we have a tx_flag (_NO_CANCEL)
>
> If for some reason the "mark" doesn't get removed the firmware will eventually timeout
> the stuck frame and sets a the P54_TX_PSM_CANCELLED flag in tx_status.
> And we pass this on to the mac with IEEE80211_TX_STAT_TX_FILTERED.
>
> one thing: p54 reports the tx_status through the rx-ring-buffer.
> so I hope there's no rx/tx race here since everything is in the same "boat" here.
>
> based on that:
> I made two different patches to address the problem.
>
> one fiddles with mac80211 only (set-and-clear.diff).
> It assumes that if a station comes out of PS, we have to set
> the CLEAR_PS_FILT on the same time we clear the WLAN_STA_PS.
>
> the other one is only for p54 (p54-sta-flags.diff)... Doesn't do very much,
> it just checks if the CLEAR_PS_FILT is set and then sets the
> NO_CANCEL flag on that frame, so the firmware won't buffer it.
>
> Of course you can test both patches on the same time, if it doesn't help.
>
> And finally of course, I could be totally wrong and this is all nothing but useless gibberish.
>
> Regards,
>        Chr
>
> BTW: I couldn't test the patches, so it may OOps
>
