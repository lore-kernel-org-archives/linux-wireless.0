Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:54168 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458Ab2KAHz1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 03:55:27 -0400
Message-ID: <50922AA3.7000404@ti.com> (sfid-20121101_085532_883549_17EEB1E8)
Date: Thu, 1 Nov 2012 09:54:11 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <coelho@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v4 5/6] nl80211/cfg80211: add ap channel switch command
References: <1350226137-13704-1-git-send-email-victorg@ti.com>   <1350226137-13704-6-git-send-email-victorg@ti.com>  <1350414390.10177.16.camel@jlt4.sipsolutions.net> <5084256F.2030502@ti.com> <1350910332.10166.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1350910332.10166.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/10/2012 14:52, Johannes Berg wrote:
> On Sun, 2012-10-21 at 18:40 +0200, Victor Goldenshtein wrote:
>> On 16/10/2012 21:06, Johannes Berg wrote:
>>> Hmm, does that really work? I mean, it can do the update when the event
>>> comes in, but is that fast enough, or should it give us the new beacon
>>> already when programming the switching?
>>>
>>
>> Yes it works with our 12xx, in the 12xx the FW (upon channel switch
>> command) is responsible to decrement the channel switch count in the
>> beacon CSA IE and to remove the CSA IE from the beacon once device moves
>> to the new channel (+ to updates the DS).
>
> So ... you've made this kind of behaviour a mandatory part of the
> userspace API. Where is it documented then? How will it work with other
> devices?

It's should work the same with other devices, each device should 
implement AP channel switch op according the spec, the implementation 
can be hardware/driver depended. I just mentioned how we do it in our 
devices, which I think is the right way without introducing any races 
(as you mentioned), So no behavior enforcement here as long as it 
according the spec.

-- 
Thanks,
Victor.
