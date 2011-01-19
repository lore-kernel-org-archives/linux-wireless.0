Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60111 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1ASUXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 15:23:04 -0500
Received: by yxt3 with SMTP id 3so516207yxt.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 12:23:03 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [RFC PATCH 10/17] zd1211rw: implement beacon fetching and handling ieee80211_get_buffered_bc()
Date: Wed, 19 Jan 2011 21:22:24 +0100
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>, kvalo@adurom.com
References: <20110104234745.25309.72030.stgit@fate.lan> <201101092133.37610.chunkeey@googlemail.com> <20110119204903.179429gv9mcqcidc@hayate.sektori.org>
In-Reply-To: <20110119204903.179429gv9mcqcidc@hayate.sektori.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101192122.25282.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 19 January 2011 19:49:03 Jussi Kivilinna wrote:
> Quoting Christian Lamparter <chunkeey@googlemail.com>:
>> On Sunday 09 January 2011 16:46:56 Jussi Kivilinna wrote:
>>> Quoting Christian Lamparter <chunkeey@googlemail.com>:
>>>> this is an interesting one...
>>>>
>>>> Since zd_beacon_done also uploads the next beacon so long in advance,
>>>> there could be an equally long race between the outdated state of the
>>>> next beacon's DTIM broadcast traffic indicator (802.11-2007 7.3.2.6)
>>>> which -in your case- was uploaded almost a beacon interval ago and
>>>> the xmit of ieee80211_get_buffered_bc *now*.
>>>>
>>>> The dtim bc/mc bit might be not set, when a mc/bc arrived after the
>>>> beacon was uploaded, but before the "beacon done event" from the
>>>> hardware. So, dozing stations don't expect the broadcast traffic
>>>> and of course, they might miss it completely.
>>>>
>>>> It's probably better to fix this in mac80211 (see the attached hack).
>>>
>>> Ok, should I add this to my patchset?
>> well, difficult to say. As far as I can say, it should be correct for "your
>> case". But, on the other hand: what about solutions that can't buffer
>> mc/bc frames (and needs to call ieee80211_get_buffered_bc), however the
>> firmware is clever enough to maintain a beacon internally (so they
>> won't call ieee80211_beacon_get and only relies on set_tim)?
>>
>> Sure, it's just a unlikely corner case... In fact, I didn't check if
>> that's even possible, but it does sound reasonable to some extend.
>
> From what I checked none of currect driver/device is such.
> Maybe if such device appears then !bss->dtim_bc_mc check in  
> ieee80211_beacon_add_tim() could be masked with driver flag (something  
> like
> IEEE80211_HW_CAN_AND_HANDLE_BEACON_BUT_STILL_NEEDS_HOST_BROADCAST_PS_BUFFERING).

True, but a recent discussion into this matter have made parts of the
API you are planning to use sort-of "deprecated"? [I think?]

http://marc.info/?l=linux-wireless&m=129463297300480

I don't know the exact details, but I'm sure Kvalo does have his reasons.
[afaik it has to do with wl12xx, he even explained it once, but I can't
find that mail anymore].

>>>> In fact, you could just as well drop "[09/17] zd1211rw: implement
>>>> seq_num for IEEE80211_TX_CTL_ASSIGN_SEQ"... unless of course, I'm
>>>> an idiot and there is a really clever way around these issues.
>>>
>>> Oh well, I should have checked this more closely before doing that
>>> patch. HW is assigning seq-numbers already and that patch is not needed.
>>
>> heh, p54's fw can assign sequence numbers as well, but there's a txdesc flag
>> to control the counter, so the firmware does not mess with the  
>> sequence control
>> of QoS-Data frames. I hope zd1211* has one too.
> 
> There is tx-control flag that doesn't have effect, but since zd1211  
> doesn't appear to support QoS it's not a problem.

Ok, that sound reasonable.

One more thing, is there a tx-control flag to instruct the HW/FW to write
the TSF into probe response frames, just like it does for beacons frames?

Sure, this feature is far more important for IBSS, but the 802.11-2007
specs @11.1.4 says that a STA might use beacons or probe responses to
synchronize its timers. [However 11.1.1.1 and 11.1.3.4 say that STAs
should "only" pick this information from beacons, if I'm not mistaken?!]
(Also a uniform "0..0" timestamp in every probe-response looks so sad.)

Best Regards,
	Christian
