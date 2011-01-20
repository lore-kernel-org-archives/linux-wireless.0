Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63549 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab1ATRvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 12:51:39 -0500
Received: by wwi17 with SMTP id 17so1761430wwi.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 09:51:38 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [RFC PATCH 10/17] zd1211rw: implement beacon fetching and handling ieee80211_get_buffered_bc()
Date: Thu, 20 Jan 2011 18:43:56 +0100
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
References: <20110104234745.25309.72030.stgit@fate.lan> <201101192122.25282.chunkeey@googlemail.com> <20110120101606.53052h18mlpyp8w0@hayate.sektori.org>
In-Reply-To: <20110120101606.53052h18mlpyp8w0@hayate.sektori.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101201843.56916.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 January 2011 09:16:06 Jussi Kivilinna wrote:
> Quoting Christian Lamparter <chunkeey@googlemail.com>:
>> On Wednesday 19 January 2011 19:49:03 Jussi Kivilinna wrote:
>>> Quoting Christian Lamparter <chunkeey@googlemail.com>:
>>>> On Sunday 09 January 2011 16:46:56 Jussi Kivilinna wrote:
>>>>> Quoting Christian Lamparter <chunkeey@googlemail.com>:
>>>>>> Since zd_beacon_done also uploads the next beacon so long in advance,
>>>>>> there could be an equally long race between the outdated state of the
>>>>>> next beacon's DTIM broadcast traffic indicator (802.11-2007 7.3.2.6)
>>>>>> which -in your case- was uploaded almost a beacon interval ago and
>>>>>> the xmit of ieee80211_get_buffered_bc *now*.
>>>>>>
>>>>>> The dtim bc/mc bit might be not set, when a mc/bc arrived after the
>>>>>> beacon was uploaded, but before the "beacon done event" from the
>>>>>> hardware. So, dozing stations don't expect the broadcast traffic
>>>>>> and of course, they might miss it completely.
>>>>>>
>>>>>> It's probably better to fix this in mac80211 (see the attached hack).
>>>>>
>>>>> Ok, should I add this to my patchset?
>>>> well, difficult to say. As far as I can say, it should be correct for "your
>>>> case". But, on the other hand: what about solutions that can't buffer
>>>> mc/bc frames (and needs to call ieee80211_get_buffered_bc), however the
>>>> firmware is clever enough to maintain a beacon internally (so they
>>>> won't call ieee80211_beacon_get and only relies on set_tim)?
>>>>
>>>> Sure, it's just a unlikely corner case... In fact, I didn't check if
>>>> that's even possible, but it does sound reasonable to some extend.
>>>
>>> From what I checked none of currect driver/device is such.
>>> Maybe if such device appears then !bss->dtim_bc_mc check in
>>> ieee80211_beacon_add_tim() could be masked with driver flag (something
>>> like
>>> IEEE80211_HW_CAN_AND_HANDLE_BEACON_BUT_STILL_NEEDS_HOST_BROADCAST_PS_BUFFERING).
>>
>> True, but a recent discussion into this matter have made parts of the
>> API you are planning to use sort-of "deprecated"? [I think?]
>>
>> http://marc.info/?l=linux-wireless&m=129463297300480
>>
>> I don't know the exact details, but I'm sure Kvalo does have his reasons.
>> [afaik it has to do with wl12xx, he even explained it once, but I can't
>> find that mail anymore].
>>
>
> What I understood from that thread is that rt2x00/usb doesn't have HW  
> buffering and doesn't enable IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING  
> (rt2x00/pci does), and yet enables AP-mode. Driver has this comment:
> 	/*
> 	 * Initialize all hw fields.
> 	 *
> 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING unless we are
> 	 * capable of sending the buffered frames out after the DTIM
> 	 * transmission using rt2x00lib_beacondone. This will send out
> 	 * multicast and broadcast traffic immediately instead of buffering it
> 	 * infinitly and thus dropping it after some time.
> 	 */

My bad, you are right. This is not something to worry about anymore.

> > One more thing, is there a tx-control flag to instruct the HW/FW to write
> > the TSF into probe response frames, just like it does for beacons frames?
> >
> > Sure, this feature is far more important for IBSS, but the 802.11-2007
> > specs @11.1.4 says that a STA might use beacons or probe responses to
> > synchronize its timers. [However 11.1.1.1 and 11.1.3.4 say that STAs
> > should "only" pick this information from beacons, if I'm not mistaken?!]
> > (Also a uniform "0..0" timestamp in every probe-response looks so sad.)
> >
> 
> No such flag I'm afraid. Vendor driver appears to be reading  
> tsf-register from driver and writing value to probe response frames,  
> maybe something I should add to zd1211rw too.
It's more of a cosmetic thing, but very difficult to get it right without
firmware/hw support [over an usb]. So you might just leave it as it
is...

Best regards,
	Christian
