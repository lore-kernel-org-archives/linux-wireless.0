Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47275 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab2KMPFd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 10:05:33 -0500
Message-ID: <50A26172.7000703@ti.com> (sfid-20121113_160537_706037_ADED442C)
Date: Tue, 13 Nov 2012 17:04:18 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <coelho@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v4 5/6] nl80211/cfg80211: add ap channel switch command
References: <1350226137-13704-1-git-send-email-victorg@ti.com>    <1350226137-13704-6-git-send-email-victorg@ti.com>   <1350414390.10177.16.camel@jlt4.sipsolutions.net>  <5084256F.2030502@ti.com> <1350910332.10166.0.camel@jlt4.sipsolutions.net>  <50922AA3.7000404@ti.com> <1352129245.9466.21.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352129245.9466.21.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2012 17:27, Johannes Berg wrote:
> On Thu, 2012-11-01 at 09:54 +0200, Victor Goldenshtein wrote:
>
>>>> Yes it works with our 12xx, in the 12xx the FW (upon channel switch
>>>> command) is responsible to decrement the channel switch count in the
>>>> beacon CSA IE and to remove the CSA IE from the beacon once device moves
>>>> to the new channel (+ to updates the DS).
>>>
>>> So ... you've made this kind of behaviour a mandatory part of the
>>> userspace API. Where is it documented then? How will it work with other
>>> devices?
>>
>> It's should work the same with other devices, each device should
>> implement AP channel switch op according the spec, the implementation
>> can be hardware/driver depended. I just mentioned how we do it in our
>> devices, which I think is the right way without introducing any races
>> (as you mentioned), So no behavior enforcement here as long as it
>> according the spec.
>
> I don't think that's how it works ... you should describe what is
> expected of the driver in the right API documentation. Even saying
> "implement the procedures as described in 802.11-2012 section ..." could
> be sufficient, but I think that needs to be there.
>

np, I can add it.

-- 
Thanks,
Victor.
