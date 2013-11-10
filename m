Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:57697 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3KJRZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Nov 2013 12:25:17 -0500
Received: by mail-ea0-f180.google.com with SMTP id b11so2242808eae.11
        for <linux-wireless@vger.kernel.org>; Sun, 10 Nov 2013 09:25:16 -0800 (PST)
Message-ID: <527FC179.2040503@gmail.com> (sfid-20131110_182522_212340_2905EEA4)
Date: Sun, 10 Nov 2013 19:25:13 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: I always need a miracle to connect with iwlwifi
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>	<CAMP44s3VRnqw0XJDZTZTym7wBD5-NnfOD56YHbE87OG=3Zan2w@mail.gmail.com>	<CAMP44s15W7gb8rXwqum5bdHOSk=A_sadX7ksvtkG0qTOu1RREg@mail.gmail.com>	<CABPxzYLtbs1s-_T+hk+N1hOEuCi_Yq+CGxG7Xx0hPRmiyQM0Jg@mail.gmail.com>	<CAMP44s0h836BZ+g9-g_t78bKuV_m_xAuvPYRCHaFdJ58eTKthw@mail.gmail.com>	<CABPxzYJsLqJbJQzr8+2GujQsbJpo922v9ouVWWPbTFL11-UV5g@mail.gmail.com>	<CAMP44s1ZtTyfKmgy4174ukQU1dwx1Fw=AngNQ=g2Dv2wm4t2-g@mail.gmail.com>	<CABPxzYKPpL7p0gexV3udgsWYZ_zVYxT6vrz-n-rN36D2AgBCgg@mail.gmail.com>	<CAMP44s1vwEMRYost99JgLxvXJkFwhgnn9jnYR5RxLPDm-Qj7ug@mail.gmail.com>	<CABPxzYKQfz2CBvHwWHXT9rSZ6He8ru1R-dP5z+wVy8o3o6L8eQ@mail.gmail.com>	<CAMP44s2JsVdhRWvkF+jBFns93v7w5kGsP5H83V=CjZr6QynLQA@mail.gmail.com>	<CABPxzYKA1qCg=nkFL1HsXraBadDei2skBzU4eVxTZ5-e+JSMUA@mail.gmail.com>	<CANUX_P2+zb0-rU-0ryCnOdxjSkFcSNXJbmJ3B0HtJcnYpsrbQg@mail.gmail.com> <CAMP44s0Z1RueHfT_taMSn=sdMyqFXc3hE4HE832qHetXbDhZQQ@mail.gmail.com>
In-Reply-To: <CAMP44s0Z1RueHfT_taMSn=sdMyqFXc3hE4HE832qHetXbDhZQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/10/2013 06:26 PM, Felipe Contreras wrote:
> On Sun, Nov 10, 2013 at 12:31 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>>>>>>>> But we are receiving 0 beacons, waiting for more than 1 won't help.
>>>>>>>>>> BTW, why NEED_DTIM_BEFORE_ASSOC if the device doesn't *need* the DTIM
>>>>>>>>>> before the association?
>>>>>>>>>>
>>>>>>> This is not just for your case but rather on a generic note. Regarding
>>>>>>> the flag even i am not
>>>>>>> too sure but i guess some hardware need to know the DTIM to set the
>>>>>>> wakeup schedule
>>>>>>> after the association?
>>>>>>
>>
>> Right - we need the send the beacon interval to the device *before* we
>> configure the device to be associated.
> 
> But what do you mean "need"? If I remove the flag the association works fine.
> 
>>>>>> But not this hardware? Because everything works fine.
>>>>>>
>>>>>>>>> Oops...you just missed, Right after your print there is a check to
>>>>>>>>> drop frames with BAD CRC :-).
>>>>>>>>
>>>>>>>> That's why I put the print before that check. Since I don't see the
>>>>>>>> print, that means the check was never executed. iwlagn_rx_reply_rx()
>>>>>>>> was never called for the beacon frame.
>>>>>>>>
>>
>> That won't help since the firmware will drop frames with bad CRC,
>> unless you are in monitor mode.
> 
> And apparently ad-hoc mode too.
> 
> Either way that's not helping, ideally those corrupted beacons should
> be parsed by the driver, it will see they are corrupted, but still do
> something sensible.
> 
>>>>>>> Ok. So when we disable advertising of that flag in the driver you said things
>>>>>>> are working fine.
>>>>>>
>>>>>> Yes, everything works perfectly.
>>>>>>
>>>>>>> So in that scenario after the connection are you
>>>>>>> seeing the beacons?
>>>>>>
>>>>>> No, there are no beacons ever, at least from this AP
>>>>
>>>>> Oh ok, thats interesting. Are you not seeing any disconnects due
>>>>> to beacon loss triggers?
>>>>
>>>> I see some disconnects now and then, but I don't know why. Before
>>>> trying to tackle those problems I would like to be able to connect
>>>> reliably.
>>
>> No wonder. If we can't receive any beacons you can expect issues....
>> PS will be completely broken and that is only the first on the list...
> 
> That's OK, it's better to connect with issues rather than not connect at all.
> 
>>> Its probably the beacons loss that triggering the disconnects, so
>>> both the problem have the same cause. Its the beacon reception
>>> we need to figure it out.
>>>
>>> Adding some intel guys explicitly.
>>>
>>>>> Also can you add some debugging to the iwlagn_rx_beacon_notif
>>>>> (the beacon RX handler)?
>>>>
>>>> All right, I've added debugging there, but so far I see nothing.
>>>>
>>>
>>> Hmm...dead end this side too.
>>>
>>>>>> It seems to me all the beacon frames are dropped by the firmware
>>>>>> before passing them to the driver, so the driver cannot parse them and
>>>>>> do something sensible even though they are corrupted, the driver never
>>>>>> gets them.
>>>>>>
>>>>>>> Just want to understand the problem is throughout or just before association.
>>>>>>> If the driver itself it not getting the beacons then our debugging ends there,
>>>>>>> some one from intel should guide you through the FW debugging.
>>>>>>
>>>>>> Not really, part of the debugging ends there, but we can still do something.
>>>>>>
>>>>>> What is the meaning of NEED_DTIM_BEFORE_ASSOC, if the driver doesn't
>>>>>> *need* this? Why fail the association completely, if we don't need to?
>>>>>>
>>
>> As I explained, the firmware needs to. This is for configuring the PS
>> state machine. But since you AP is completely broken, PS is likely not
>> to work at all anyway....
> 
> I don't use powersave anyway.
> 
>> And my small experience in WiFi leads me to the conclusion that if a
>> driver cannot rely on the AP sending beacon, it is really in trouble.
> 
> Somehow every device in this house doesn't seem to have a problem.
> Even this device in Windows works fine.
> 
>> We can cope with buggy AP, but not associate to microwaves.
>> Other devices will work, granted. But they can't go to sleep then, and
>> need to poke the AP from time to time to make sure it hasn't
>> disappeared.
> 
> That's better than not associating at all, ever.

No because it would break the driver against all the working APs which
are fortunately enough more common. Maybe you can rewrite mac80211 /
iwlwifi to make things work differently so that PS would still work with
good APs and association would work with yours. Fair enough. Go ahead.

> 
>> Note that this is true regardless of the design / HW wahtever. Ok, the
>> Windows driver on the same device works with this "AP". Fine. But it
>> can't theoretically can't work well. Nor can any other WiFi device
>> that can't hear the beacon. Now - maybe we have an issue in the Linux
>> driver that mangles the beacons (PHY stuff) - that's possible. But
>> since you haven't sent a sniffer capture of the AP with another
>> device, we can't know.
> 
> That's right, I tried to do that with an N900 but the monitor mode
> doesn't work. I'll keep trying.
> 
>>>>>> Also, I realized that after rebooting the router, the beacon frames
>>>>>> are not corrupted any more, so it's a compound problem, yet even in
>>>>>> the corrupted case, the driver can work just fine, if only it didn't
>>>>>> *require* the DTIM unnecessarily,
>>>>>
>>>>> Yeah, that's more of design query with the problem being not able to
>>>>> Rx the beacons? We need to understand the reason for this flag being
>>>>> set by the iwlwifi driver.
>>>>
>>>> Indeed.
>>>>
>>>>>> as apparently all hardware and even
>>>>>> other OS'es on this hardware do.
>>>>>
>>>>> Thats the reason this flag is a _HW_ not all hardwares requrie this
>>>>> but intel does.
>>>>
>>>> But it doesn't, my hardware is Intel, and it works fine without it.
>>>>
>>> Yeah, so far so good. But there should be a reason why they are
>>> specifically advertising this flag? Also DTIM is Multicast+Powersave
>>> so a rare thing, we might no hit that too often.
>>
>> Hmm... well... N/M.
> 
> Wouldn't it make sense to timeout if there's no DTIM, and still
> associate? It's better than not associating ever. Plus, if you already
> know that power saving wouldn't work in this case, merely disable
> powersave.
> 

I can't wait for your patch.
