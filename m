Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34183 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbHSRoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 13:44:10 -0400
Subject: Re: set channel from radiotap headers during injection
To: Johannes Berg <johannes@sipsolutions.net>,
	Allan Matthew <allanm84@gmail.com>,
	linux-wireless@vger.kernel.org
References: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
 <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com>
 (sfid-20150814_234019_925894_43212D3A)
 <1439983495.2089.7.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <55D4C068.70607@candelatech.com> (sfid-20150819_194423_478362_BCBF991D)
Date: Wed, 19 Aug 2015 10:44:08 -0700
MIME-Version: 1.0
In-Reply-To: <1439983495.2089.7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/19/2015 04:24 AM, Johannes Berg wrote:
> On Fri, 2015-08-14 at 14:39 -0700, Allan Matthew wrote:
>> Anyone have any thoughts on this?
>>
>> Is it possible with channel context enabled somehow?
>>
>
> I don't think it's possible - per-packet configuration would have to be
> basically instantaneous (cannot sleep etc.) and setting the channel is
> necessarily a much longer operation.
>
> If your device supports channel contexts, you might be able to *pick*
> the channel you want to inject on, but you could probably achieve that
> through the existing MAC address selection that picks an interface.
> It's also not clear how monitor + chanctx would work at all, since
> monitor expects to be on the channel all the time.
>
> You could possibly select other parameters like the bitrate, but the
> channel width - especially 5/10 MHz - doesn't seem feasible.

At least with ath9k, it is possible to send HT20 frames
when the radio has other vifs on the same radio sending HT40 frames, for instance.
(And rate-ctrl will do the same thing even for an 'ht40' vif).

ath10k hardware has same general ability, but you have no good way to
get radiotap info to the firmware at this time.

As long as the center freq is the same, it might also be possible to do smaller
bandwith encodings as well.

I would agree that if you are changing the center freq you have little to no chance
of this working as expected.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

