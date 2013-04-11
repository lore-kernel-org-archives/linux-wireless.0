Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39401 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3DKQRp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 12:17:45 -0400
Message-ID: <5166E225.5080908@candelatech.com> (sfid-20130411_181754_446532_AF8543D1)
Date: Thu, 11 Apr 2013 09:17:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] mac80211:  Optimize sta lookup for many VIFs
References: <1364572823-28071-1-git-send-email-greearb@candelatech.com>   (sfid-20130329_170033_026763_9F6C74DD) <1365501048.8465.13.camel@jlt4.sipsolutions.net>  <5164517C.1050304@candelatech.com> <1365671709.8272.31.camel@jlt4.sipsolutions.net>
In-Reply-To: <1365671709.8272.31.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2013 02:15 AM, Johannes Berg wrote:
> On Tue, 2013-04-09 at 10:35 -0700, Ben Greear wrote:
>> On 04/09/2013 02:50 AM, Johannes Berg wrote:
>>> On Fri, 2013-03-29 at 09:00 -0700, greearb@candelatech.com wrote:
>>>> From: Ben Greear <greearb@candelatech.com>
>>>>
>>>> The sta_info hash is designed to deal with an AP
>>>> with lots of stations associated, or a station interface
>>>> connected to a single AP.
>>>
>>> Given your other hash patches, does this even make sense still?
>>
>> This handles the TX side for station VIFs.  The more complicated
>> hashing handles the rx logic.  I could use the hash
>> for the tx side, though performance is likely a small bit
>> worse since you have to deal with the hash logic.
>
> Well, for the TX side in your particular case the vhash should always
> just find the right station first, so basically it's the same, no? I
> mean, if you used the new hash in the TX code, it would basically do the
> same the some_sta thing does, assuming your hash spreads well, no?

Yes, assuming good spread.  The hash spread does fail catastrophically
if the lowest MAC octet doesn't change, however.  A cure for that might
just be a smarter hash method, however.

>> And, if the more complicated RFC hashing patch has no upstream
>> chance anyway, then if the 'some-sta' patch is acceptable,
>> I'd still be interested in seeing it upstream.
>
> Well I'm debating (with myself mostly) ... The some_sta seems
> reasonable, but still a big ugly and like a special case. I'd rather not
> merge the vhash because of the various overheads, so you'd probably want
> to maintain that out of tree anyway. It seems to me that the vhash
> should address your other case pretty much just as well, so then if you
> maintain that anyway I wouldn't have to merge the some_sta patch ... I
> guess I'd kinda prefer that :-)

Well, with regard to vhash overhead, it's not that much extra code or
memory, and in the hot paths it should be no worse than the current
code as far as I can tell.

In multi-VAP cases, if we do the per-sdata vhash, you might actually see
some improvements on tx side due to less hash collisions (in real word
cases not quite as strange as mine!).

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

